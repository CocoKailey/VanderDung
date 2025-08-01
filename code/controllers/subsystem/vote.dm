SUBSYSTEM_DEF(vote)
	name = "Vote"
	wait = 10

	flags = SS_KEEP_TIMING|SS_NO_INIT

	runlevels = RUNLEVEL_LOBBY | RUNLEVELS_DEFAULT

	var/initiator = null
	var/started_time = null
	var/time_remaining = 0
	var/mode = null
	var/question = null
	var/list/choices = list()
	var/list/voted = list()
	var/list/voting = list()
	var/list/generated_actions = list()

/datum/controller/subsystem/vote/fire()	//called by master_controller
	if(mode)
		time_remaining = round((started_time + CONFIG_GET(number/vote_period) - world.time)/10)

		if(time_remaining < 0)
			result()
			for(var/client/C in voting)
				C << browse(null, "window=vote;can_close=0")
			reset()
		else
			var/datum/browser/noclose/client_popup
			for(var/client/C in voting)
				client_popup = new(C, "vote", "Voting Panel")
				client_popup.set_window_options(can_close = FALSE)
				client_popup.set_content(interface(C))
				client_popup.open(FALSE)


/datum/controller/subsystem/vote/proc/reset()
	initiator = null
	time_remaining = 0
	mode = null
	question = null
	choices.Cut()
	voted.Cut()
	voting.Cut()
	remove_action_buttons()

/datum/controller/subsystem/vote/proc/get_result()
	//get the highest number of votes
	var/greatest_votes = 0
	var/total_votes = 0
	for(var/option in choices)
		var/votes = choices[option]
		total_votes += votes
		if(votes > greatest_votes)
			greatest_votes = votes
	//default-vote for everyone who didn't vote
	if(!CONFIG_GET(flag/default_no_vote) && choices.len)
		var/list/non_voters = GLOB.directory.Copy()
		non_voters -= voted
		for (var/non_voter_ckey in non_voters)
			var/client/C = non_voters[non_voter_ckey]
			if (!C || C.is_afk())
				non_voters -= non_voter_ckey
		if(non_voters.len > 0)
			if(mode == "restart")
				choices["Continue Playing"] += non_voters.len
				if(choices["Continue Playing"] >= greatest_votes)
					greatest_votes = choices["Continue Playing"]
			else if(mode == "gamemode")
				if(GLOB.master_mode in choices)
					choices[GLOB.master_mode] += non_voters.len
					if(choices[GLOB.master_mode] >= greatest_votes)
						greatest_votes = choices[GLOB.master_mode]
			else if(mode == "map")
				for (var/non_voter_ckey in non_voters)
					var/client/C = non_voters[non_voter_ckey]
					if(C.prefs.preferred_map)
						var/preferred_map = C.prefs.preferred_map
						choices[preferred_map] += 1
						greatest_votes = max(greatest_votes, choices[preferred_map])
					else if(global.config.defaultmap)
						var/default_map = global.config.defaultmap.map_name
						choices[default_map] += 1
						greatest_votes = max(greatest_votes, choices[default_map])
	//get all options with that many votes and return them in a list
	. = list()
	if(greatest_votes)
		for(var/option in choices)
			if(choices[option] == greatest_votes)
				. += option
	return .

/datum/controller/subsystem/vote/proc/announce_result()
	var/list/winners = get_result()
	var/text
	if(winners.len > 0)
		if(question)
			text += "<b>[question]</b>"
		else
			text += "<b>[capitalize(mode)] Vote</b>"
		for(var/i=1,i<=choices.len,i++)
			var/votes = choices[choices[i]]
			if(!votes)
				votes = 0
			text += "\n<b>[choices[i]]:</b> [votes]"
		if(mode != "custom")
			if(winners.len > 1)
				text = "\n<b>Vote Tied Between:</b>"
				for(var/option in winners)
					text += "\n\t[option]"
				if(mode == "endround")
					winners = list("End Round")
			. = pick(winners)
			text += "\n<b>Vote Result: [.]</b>"
		else
			text += "\n<b>Did not vote:</b> [GLOB.clients.len-voted.len]"
	else
		if(mode == "endround")
			. = "End Round"
			text += "\n<b>Vote Result: [.]</b>"
		else
			text += "<b>Vote Result: Inconclusive - No Votes!</b>"
	log_vote(text)
	remove_action_buttons()
	to_chat(world, "\n<font color='purple'>[text]</font>")
	return .

/datum/controller/subsystem/vote/proc/result()
	. = announce_result()
	var/restart = 0
	if(.)
		switch(mode)
			if("restart")
				if(. == "Restart Round")
					restart = 1
			if("gamemode")
				if(GLOB.master_mode != .)
					SSticker.save_mode(.)
					if(SSticker.HasRoundStarted())
						restart = 1
					else
						GLOB.master_mode = .
			if("map")
				SSmapping.changemap(global.config.maplist[.])
				SSmapping.map_voted = TRUE
			if("endround")
				if(. == "Continue Playing")
					log_game("LOG VOTE: CONTINUE PLAYING AT [REALTIMEOFDAY]")
					GLOB.round_timer = GLOB.round_timer + (32 MINUTES)
				else
					log_game("LOG VOTE: ELSE  [REALTIMEOFDAY]")
					log_game("LOG VOTE: ROUNDVOTEEND [REALTIMEOFDAY]")
					to_chat(world, "\n<font color='purple'>[ROUND_END_TIME_VERBAL]</font>")
					SSgamemode.roundvoteend = TRUE
					SSgamemode.round_ends_at = GLOB.round_timer + ROUND_END_TIME
			if("storyteller")
				SSgamemode.storyteller_vote_result(.)

	if(restart)
		var/active_admins = 0
		for(var/client/C in GLOB.admins)
			if(!C.is_afk() && check_rights_for(C, R_SERVER))
				active_admins = 1
				break
		if(!active_admins)
			SSticker.Reboot("Restart vote successful.", "restart vote")
		else
			to_chat(world, "<span style='boldannounce'>Notice:Restart vote will not restart the server automatically because there are active gamemasters on, if nothing is done the server will restart in 15 minutes.</span>")
			message_admins("A restart vote has passed, but there are active admins on with +server, so it has been canceled. If you wish, you may restart the server.")
			SSticker.reboot_anyway = world.time + 15 MINUTES
	return .

/datum/controller/subsystem/vote/proc/submit_vote(vote)
	if(mode)
//		if(CONFIG_GET(flag/no_dead_vote) && usr.stat == DEAD && !usr.client.holder)
//			return 0
		if(!(usr.ckey in voted))
			if(vote && 1<=vote && vote<=choices.len)
				voted += usr.ckey
				var/vote_power = 1
				if(usr.client.holder)
					vote_power += 5
				if(ishuman(usr))
					var/mob/living/carbon/H = usr
					if(H.stat != DEAD)
						vote_power += 3
					if(H.job)
						var/list/list_of_powerful = list("Monarch", "Consort", "Priest", "Steward", "Hand")
						if(H.job in list_of_powerful)
							vote_power += 5
						else
							if(H.mind)
								for(var/datum/antagonist/D in H.mind.antag_datums)
									if(D.increase_votepwr)
										vote_power += 3
				choices[choices[vote]] += vote_power //check this
				return vote
	return 0

/datum/controller/subsystem/vote/proc/initiate_vote(vote_type, initiator_key)
	if(!mode)
		if(started_time && initiator_key)
			var/next_allowed_time = (started_time + CONFIG_GET(number/vote_delay))
			if(mode)
				to_chat(usr, "<span class='warning'>There is already a vote in progress! please wait for it to finish.</span>")
				return 0

			var/admin = FALSE
			var/ckey = ckey(initiator_key)
			if(GLOB.admin_datums[ckey])
				admin = TRUE

			if(next_allowed_time > world.time && !admin)
				to_chat(usr, "<span class='warning'>A vote was initiated recently, you must wait [DisplayTimeText(next_allowed_time-world.time)] before a new vote can be started!</span>")
				return 0

		reset()
		switch(vote_type)
			if("restart")
				choices.Add("Restart Round","Continue Playing")
			if("gamemode")
				choices.Add(config.votable_modes)
			if("map")
				for(var/map in config.maplist)
					var/datum/map_config/VM = config.maplist[map]
					if(!VM.available_for_vote())
						continue
					choices.Add(VM.map_name)
			if("custom")
				question = stripped_input(usr,"What is the vote for?")
				if(!question)
					return 0
				for(var/i=1,i<=10,i++)
					var/option = capitalize(stripped_input(usr,"Please enter an option or hit cancel to finish"))
					if(!option || mode || !usr.client)
						break
					choices.Add(option)
			if("endround")
				var/rng = rand(1, 1000)
				if(rng > 200) // 80%
					initiator_key = pick("Astrata", "Noc", "Dendor", "Abyssor", "Necra", "Ravox", "Xylix", "Pestra", "Malum", "Eora")
				else if(rng > 50) // 15%
					initiator_key = pick("Zizo", "Graggar", "Matthios", "Baotha")
				else
					initiator_key = "Psydon"
				choices.Add("Continue Playing","End Round")
			if("storyteller")
				choices.Add(SSgamemode.storyteller_vote_choices())
			else
				return 0
		mode = vote_type
		initiator = initiator_key
		started_time = world.time
		var/text = "[capitalize(mode)] vote started by [initiator]."
		if(mode == "storyteller")
			text = initiator
		if(mode == "custom")
			text += "\n[question]"
		log_vote(text)
		var/vp = CONFIG_GET(number/vote_period)
		to_chat(world, "\n<font color='purple'><b>[text]</b>\nClick <a href='byond://?src=[REF(src)]'>here</a> to place your vote.\nYou have [DisplayTimeText(vp)] to vote.</font>")
		time_remaining = round(vp/10)
//		for(var/c in GLOB.clients)
//			var/client/C = c
//			var/datum/action/vote/V = new
//			if(question)
//				V.name = "Vote: [question]"
//			C.player_details.player_actions += V
//			V.Grant(C.mob)
//			generated_actions += V
		return 1
	return 0

/datum/controller/subsystem/vote/proc/interface(client/C)
	if(!C)
		return
	var/admin = 0
	var/trialmin = 0
	if(C.holder)
		admin = 1
		if(check_rights_for(C, R_ADMIN))
			trialmin = 1
	voting |= C

	if(mode)
		if(question)
			. += "<h2>Vote: '[question]'</h2>"
		else
			. += "<h2>Vote: [capitalize(mode)]</h2>"
		. += "Time Left: [time_remaining] s<hr><ul>"
		for(var/i=1,i<=choices.len,i++)
			var/votes = choices[choices[i]]
			if(!votes)
				votes = 0
			. += "<li><a href='byond://?src=[REF(src)];vote=[i]'>[choices[i]]</a> ([votes] votepwr)</li>"
		. += "</ul><hr>"
		if(admin)
			. += "(<a href='byond://?src=[REF(src)];vote=cancel'>Cancel Vote</a>) "
	else
		. += "<h2>Start a vote:</h2><hr><ul><li>"
		//restart
		var/avr = CONFIG_GET(flag/allow_vote_restart)
		if(trialmin || avr)
			. += "<a href='byond://?src=[REF(src)];vote=restart'>Restart</a>"
		else
			. += "<font color='grey'>Restart (Disallowed)</font>"
		if(trialmin)
			. += "\t(<a href='byond://?src=[REF(src)];vote=toggle_restart'>[avr ? "Allowed" : "Disallowed"]</a>)"
		. += "</li><li>"
		//gamemode
		var/avm = CONFIG_GET(flag/allow_vote_mode)
		if(trialmin || avm)
			. += "<a href='byond://?src=[REF(src)];vote=gamemode'>GameMode</a>"
		else
			. += "<font color='grey'>GameMode (Disallowed)</font>"
		if(trialmin)
			. += "\t(<a href='byond://?src=[REF(src)];vote=toggle_gamemode'>[avm ? "Allowed" : "Disallowed"]</a>)"

		. += "</li>"
		//map
		var/avmap = CONFIG_GET(flag/allow_vote_map)
		if(trialmin || avmap)
			. += "<a href='byond://?src=[REF(src)];vote=map'>Map</a>"
		else
			. += "<font color='grey'>Map (Disallowed)</font>"
		if(trialmin)
			. += "\t(<a href='byond://?src=[REF(src)];vote=toggle_map'>[avmap ? "Allowed" : "Disallowed"]</a>)"

		. += "</li>"
		//custom
		if(trialmin)
			. += "<li><a href='byond://?src=[REF(src)];vote=custom'>Custom</a></li>"
		. += "</ul><hr>"
	. += "<a href='byond://?src=[REF(src)];vote=close' style='position:absolute;right:50px'>Close</a>"
	return .


/datum/controller/subsystem/vote/Topic(href,href_list[],hsrc)
	if(!usr || !usr.client)
		return	//not necessary but meh...just in-case somebody does something stupid

	var/trialmin = 0
	if(usr.client.holder)
		if(check_rights_for(usr.client, R_ADMIN))
			trialmin = 1

	switch(href_list["vote"])
		if("close")
			voting -= usr.client
			usr << browse(null, "window=vote")
			return
		if("cancel")
			if(usr.client.holder)
				reset()
		if("toggle_restart")
			if(usr.client.holder && trialmin)
				CONFIG_SET(flag/allow_vote_restart, !CONFIG_GET(flag/allow_vote_restart))
		if("toggle_gamemode")
			if(usr.client.holder && trialmin)
				CONFIG_SET(flag/allow_vote_mode, !CONFIG_GET(flag/allow_vote_mode))
		if("toggle_map")
			if(usr.client.holder && trialmin)
				CONFIG_SET(flag/allow_vote_map, !CONFIG_GET(flag/allow_vote_map))
		if("restart")
			if(CONFIG_GET(flag/allow_vote_restart) || usr.client.holder)
				initiate_vote("restart",usr.key)
		if("gamemode")
			if(CONFIG_GET(flag/allow_vote_mode) || usr.client.holder)
				initiate_vote("gamemode",usr.key)
		if("map")
			if(CONFIG_GET(flag/allow_vote_map) || usr.client.holder)
				initiate_vote("map",usr.key)
		if("custom")
			if(usr.client.holder)
				initiate_vote("custom",usr.key)
		else
			submit_vote(round(text2num(href_list["vote"])))
	usr.vote()

/datum/controller/subsystem/vote/proc/remove_action_buttons()
	for(var/datum/action/vote/V as anything in generated_actions)
		if(!QDELETED(V))
			V.remove_from_client()
			V.Remove(V.owner)
	generated_actions = list()

/mob/verb/vote()
	set category = "OOC"
	set name = "Vote"
	set hidden = 1
	var/datum/browser/noclose/popup = new(src, "vote", "Voting Panel")
	popup.set_window_options(can_close = FALSE)
	popup.set_content(SSvote.interface(client))
	popup.open(FALSE)

/datum/action/vote
	name = "Vote!"
	button_icon_state = "vote"

/datum/action/vote/Trigger(trigger_flags)
	if(owner)
		owner.vote()
		remove_from_client()
		Remove(owner)

/datum/action/vote/IsAvailable()
	return 1

/datum/action/vote/proc/remove_from_client()
	if(!owner)
		return
	if(owner.client)
		owner.client.player_details.player_actions -= src
	else if(owner.ckey)
		var/datum/player_details/P = GLOB.player_details[owner.ckey]
		if(P)
			P.player_actions -= src
