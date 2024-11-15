//NOT using the existing /obj/machinery/door type, since that has some complications on its own, mainly based on its
//machineryness

/obj/structure/mineral_door
	name = "metal door"
	density = TRUE
	anchored = TRUE
	opacity = TRUE
	layer = CLOSED_DOOR_LAYER

	icon = 'icons/obj/doors/mineral_doors.dmi'
	icon_state = "metal"
	max_integrity = 1000
	integrity_failure = 0.5
	armor = list("melee" = 10, "bullet" = 0, "laser" = 0, "energy" = 100, "bomb" = 10, "bio" = 100, "rad" = 100, "fire" = 50, "acid" = 50)
	CanAtmosPass = ATMOS_PASS_DENSITY
	rad_flags = RAD_PROTECT_CONTENTS | RAD_NO_CONTAMINATE
	rad_insulation = RAD_MEDIUM_INSULATION

	var/ridethrough = FALSE

	var/door_opened = FALSE //if it's open or not.
	var/isSwitchingStates = FALSE //don't try to change stats if we're already opening

	var/close_delay = -1 //-1 if does not auto close.
	var/openSound = 'sound/blank.ogg'
	var/closeSound = 'sound/blank.ogg'

	var/sheetType = /obj/item/stack/sheet/metal //what we're made of
	var/sheetAmount = 7 //how much we drop when deconstructed

	var/windowed = FALSE
	var/base_state = null

	var/locked = FALSE
	var/last_bump = null
	var/brokenstate = 0
	var/keylock = FALSE
	var/lockhash = 0
	var/lockid = null
	var/lockbroken = 0
	var/locksound = 'sound/foley/doors/woodlock.ogg'
	var/unlocksound = 'sound/foley/doors/woodlock.ogg'
	var/rattlesound = 'sound/foley/doors/lockrattle.ogg'
	var/masterkey = TRUE //if masterkey can open this regardless
	var/kickthresh = 15
	var/swing_closed = TRUE

	var/ghostproof = FALSE	// Set to true to stop dead players passing through closed ones. Only use this for special areas, not generally

	damage_deflection = 10

	var/repairable = FALSE
	var/repair_state = 0
	var/obj/item/repair_cost_first = null
	var/obj/item/repair_cost_second = null
	var/repair_skill = null

/obj/structure/mineral_door/onkick(mob/user)
	if(isSwitchingStates)
		return
	if(door_opened)
		playsound(src, 'sound/combat/hits/onwood/woodimpact (1).ogg', 100)
		user.visible_message(span_warning("[user] kicks [src] shut!"), \
			span_notice("I kick [src] shut!"))
		force_closed()
	else
		if(locked)
			if(isliving(user))
				var/mob/living/L = user
				if(L.STASTR >= initial(kickthresh))
					kickthresh--
				if((prob(L.STASTR * 0.5) || kickthresh == 0) && (L.STASTR >= initial(kickthresh)))
					playsound(src, 'sound/combat/hits/onwood/woodimpact (1).ogg', 100)
					user.visible_message(span_warning("[user] kicks open [src]!"), \
						span_notice("I kick open [src]!"))
					locked = 0
					force_open()
				else
					playsound(src, 'sound/combat/hits/onwood/woodimpact (1).ogg', 100)
					user.visible_message(span_warning("[user] kicks [src]!"), \
						span_notice("I kick [src]!"))
			//try to kick open, destroy lock
		else
			playsound(src, 'sound/combat/hits/onwood/woodimpact (1).ogg', 100)
			user.visible_message(span_warning("[user] kicks open [src]!"), \
				span_notice("I kick open [src]!"))
			force_open()

/obj/structure/mineral_door/proc/force_open()
	isSwitchingStates = TRUE
	if(!windowed)
		set_opacity(FALSE)
	density = FALSE
	door_opened = TRUE
	layer = OPEN_DOOR_LAYER
	air_update_turf(1)
	update_icon()
	isSwitchingStates = FALSE

	if(close_delay != -1)
		addtimer(CALLBACK(src, PROC_REF(Close)), close_delay)

/obj/structure/mineral_door/proc/force_closed()
	isSwitchingStates = TRUE
	if(!windowed)
		set_opacity(TRUE)
	density = TRUE
	door_opened = FALSE
	layer = CLOSED_DOOR_LAYER
	air_update_turf(1)
	update_icon()
	isSwitchingStates = FALSE

/obj/structure/mineral_door/Initialize()
	. = ..()
	if(!base_state)
		base_state = icon_state
	air_update_turf(TRUE)
	if(lockhash)
		GLOB.lockhashes += lockhash
	else if(keylock)
		if(lockid)
			if(GLOB.lockids[lockid])
				lockhash = GLOB.lockids[lockid]
			else
				lockhash = rand(1000,9999)
				while(lockhash in GLOB.lockhashes)
					lockhash = rand(1000,9999)
				GLOB.lockhashes += lockhash
				GLOB.lockids[lockid] = lockhash
		else
			lockhash = rand(1000,9999)
			while(lockhash in GLOB.lockhashes)
				lockhash = rand(1000,9999)
			GLOB.lockhashes += lockhash

/obj/structure/mineral_door/Move()
	var/turf/T = loc
	. = ..()
	move_update_air(T)

/obj/structure/mineral_door/attack_ghost(mob/dead/observer/user)	// lets ghosts click on windows to transport across
	if(!ghostproof)
		density = FALSE
		. = step(user,get_dir(user,src.loc))
		density = TRUE

/obj/structure/mineral_door/Bumped(atom/movable/AM)
	..()
	if(door_opened)
		return
	if(world.time < last_bump+20)
		return
	last_bump = world.time
	if(ismob(AM))
		var/mob/user = AM
		if(HAS_TRAIT(user, TRAIT_BASHDOORS))
			if(locked)
				user.visible_message(span_warning("[user] bashes into [src]!"))
				take_damage(200, "brute", "melee", 1)
			else
				playsound(src, 'sound/combat/hits/onwood/woodimpact (1).ogg', 100)
				force_open()
				user.visible_message(span_warning("[user] smashes through [src]!"))
			return
		if(HAS_TRAIT(user, TRAIT_ROTMAN))
			if(locked)
				user.visible_message(span_warning("The deadite bashes into [src]!"))
				take_damage(50, "brute", "melee", 1)
			else
				playsound(src, 'sound/combat/hits/onwood/woodimpact (1).ogg', 90)
				force_open()
				user.visible_message(span_warning("The deadite smashes through [src]!"))
			return
		if(locked)
			playsound(src, rattlesound, 90)
			var/oldx = pixel_x
			animate(src, pixel_x = oldx+1, time = 0.5)
			animate(pixel_x = oldx-1, time = 0.5)
			animate(pixel_x = oldx, time = 0.5)
			return
		if(TryToSwitchState(AM))
			if(swing_closed)
				if(isliving(AM))
					var/mob/living/M = AM
					if(M.m_intent == MOVE_INTENT_SNEAK)
						addtimer(CALLBACK(src, PROC_REF(Close), TRUE), 25)
					else
						addtimer(CALLBACK(src, PROC_REF(Close), FALSE), 25)


/obj/structure/mineral_door/attack_paw(mob/user)
	return attack_hand(user)

/obj/structure/mineral_door/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	if(brokenstate)
		return
	if(isSwitchingStates)
		return
	if(locked)
		if( user.used_intent.type == /datum/intent/unarmed/claw )
			user.changeNext_move(CLICK_CD_MELEE)
			to_chat(user, "<span class='warning'>The deadite claws at the door!!</span>")
			take_damage(40, "brute", "melee", 1)
			return
		if(isliving(user))
			var/mob/living/L = user
			if(L.m_intent == MOVE_INTENT_SNEAK)
				to_chat(user, span_warning("This door is locked."))
				return
		if(world.time >= last_bump+20)
			last_bump = world.time
			playsound(src, 'sound/foley/doors/knocking.ogg', 100)
			user.visible_message(span_warning("[user] knocks on [src]."), \
				span_notice("I knock on [src]."))
		return
	return TryToSwitchState(user)

/obj/structure/mineral_door/CanPass(atom/movable/mover, turf/target)
	if(istype(mover, /obj/effect/beam))
		return !opacity
	return !density

/obj/structure/mineral_door/proc/TryToSwitchState(atom/user)
	if(isSwitchingStates || !anchored)
		return
	if(isliving(user))
		var/mob/living/M = user
		if(world.time - M.last_bumped <= 60)
			return //NOTE do we really need that?
		if(M.client)
			if(iscarbon(M))
				var/mob/living/carbon/C = M
				if(!C.handcuffed)
					if(C.m_intent == MOVE_INTENT_SNEAK)
						SwitchState(TRUE)
					else
						SwitchState()
			else
				SwitchState()
	else if(ismecha(user))
		SwitchState()
	return TRUE

/obj/structure/mineral_door/proc/SwitchState(silent = FALSE)
	if(door_opened)
		Close(silent)
	else
		Open(silent)

/obj/structure/mineral_door/proc/Open(silent = FALSE)
	isSwitchingStates = TRUE
	if(!silent)
		playsound(src, openSound, 90)
	if(!windowed)
		set_opacity(FALSE)
	flick("[base_state]opening",src)
	sleep(10)
	density = FALSE
	door_opened = TRUE
	layer = OPEN_DOOR_LAYER
	air_update_turf(1)
	update_icon()
	isSwitchingStates = FALSE

	if(close_delay != -1)
		addtimer(CALLBACK(src, PROC_REF(Close)), close_delay)

/obj/structure/mineral_door/proc/Close(silent = FALSE)
	if(isSwitchingStates || !door_opened)
		return
	var/turf/T = get_turf(src)
	for(var/mob/living/L in T)
		return
	isSwitchingStates = TRUE
	if(!silent)
		playsound(src, closeSound, 90)
	flick("[base_state]closing",src)
	sleep(10)
	density = TRUE
	if(!windowed)
		set_opacity(TRUE)
	door_opened = FALSE
	layer = initial(layer)
	air_update_turf(1)
	update_icon()
	isSwitchingStates = FALSE

/obj/structure/mineral_door/update_icon()
	icon_state = "[base_state][door_opened ? "open":""]"

/obj/structure/mineral_door/examine(mob/user)
	. = ..()
	if(repairable)
		var/obj/cast_repair_cost_first = repair_cost_first
		var/obj/cast_repair_cost_second = repair_cost_second
		if((repair_state == 0) && (obj_integrity < max_integrity))
			. += span_notice("A [initial(cast_repair_cost_first.name)] can be used to repair it.")
			if(brokenstate)
				. += span_notice("An additional [initial(cast_repair_cost_second.name)] is needed to finish repairs.")
		if(repair_state == 1)
			. += span_notice("An additional [initial(cast_repair_cost_second.name)] is needed to finish repairs.")

/obj/structure/mineral_door/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/roguekey) || istype(I, /obj/item/keyring))
		trykeylock(I, user)
//	else if(user.used_intent.type != INTENT_HARM)
//		return attack_hand(user)
	if(istype(I, /obj/item/lockpick))
		trypicklock(I, user)
	else
		if(repairable && (user.mind.get_skill_level(repair_skill) > 0) && ((istype(I, repair_cost_first)) || (istype(I, repair_cost_second)))) // At least 1 skill level needed
			repairdoor(I,user)
		else
			return ..()

/obj/structure/mineral_door/proc/repairdoor(obj/item/I, mob/user)
	if(brokenstate)
		switch(repair_state)
			if(0)
				if(istype(I, repair_cost_first))
					user.visible_message(span_notice("[user] starts repairing [src]."), \
					span_notice("I start repairing [src]."))
					playsound(user, 'sound/misc/wood_saw.ogg', 100, TRUE)
					if(do_after(user, (300 / user.mind.get_skill_level(repair_skill)), target = src)) // 1 skill = 30 secs, 2 skill = 15 secs etc.
						qdel(I)
						playsound(user, 'sound/misc/wood_saw.ogg', 100, TRUE)
						repair_state = 1
						var/obj/cast_repair_cost_second = repair_cost_second
						to_chat(user, span_notice("An additional [initial(cast_repair_cost_second.name)] is needed to finish the job."))
			if(1)
				if(istype(I, repair_cost_second))
					user.visible_message(span_notice("[user] starts repairing [src]."), \
					span_notice("I start repairing [src]."))
					playsound(user, 'sound/misc/wood_saw.ogg', 100, TRUE)
					if(do_after(user, (300 / user.mind.get_skill_level(repair_skill)), target = src)) // 1 skill = 30 secs, 2 skill = 15 secs etc.
						qdel(I)
						playsound(user, 'sound/misc/wood_saw.ogg', 100, TRUE)
						icon_state = "[base_state]"
						density = TRUE
						opacity = TRUE
						brokenstate = FALSE
						obj_broken = FALSE
						obj_integrity = max_integrity
						repair_state = 0
						user.visible_message(span_notice("[user] repaired [src]."), \
						span_notice("I repaired [src]."))
	else
		if(obj_integrity < max_integrity && istype(I, repair_cost_first))
			to_chat(user, span_warning("[obj_integrity]"))
			user.visible_message(span_notice("[user] starts repairing [src]."), \
			span_notice("I start repairing [src]."))
			playsound(user, 'sound/misc/wood_saw.ogg', 100, TRUE)
			if(do_after(user, (300 / user.mind.get_skill_level(repair_skill)), target = src)) // 1 skill = 30 secs, 2 skill = 15 secs etc.
				qdel(I)
				playsound(user, 'sound/misc/wood_saw.ogg', 100, TRUE)
				obj_integrity = obj_integrity + (max_integrity/2)
				if(obj_integrity > max_integrity)
					obj_integrity = max_integrity
				user.visible_message(span_notice("[user] repaired [src]."), \
				span_notice("I repaired [src]."))

/obj/structure/mineral_door/proc/trykeylock(obj/item/I, mob/user, is_right = FALSE)
	if(door_opened || isSwitchingStates)
		return
	if(!keylock)
		return
	if(lockbroken)
		to_chat(user, "<span class='warning'>The lock to this door is broken.</span>")
	user.changeNext_move(CLICK_CD_MELEE)
	if(istype(I,/obj/item/keyring))
		var/obj/item/keyring/R = I
		if(!R.keys.len)
			return
		var/list/keysy = shuffle(R.keys.Copy())
		for(var/obj/item/roguekey/K in keysy)
			if(user.cmode)
				if(!do_after(user, 10, TRUE, src))
					break
			if(K.lockhash == lockhash)
				lock_toggle(user)
				break
			else
				if(user.cmode)
					playsound(src, rattlesound, 100)
					var/oldx = pixel_x
					animate(src, pixel_x = oldx+1, time = 0.5)
					animate(pixel_x = oldx-1, time = 0.5)
					animate(pixel_x = oldx, time = 0.5)
		return
	else
		var/obj/item/roguekey/K = I
		if(K.lockhash == lockhash)
			lock_toggle(user, is_right)
			return
		else
			playsound(src, rattlesound, 100)
			var/oldx = pixel_x
			animate(src, pixel_x = oldx+1, time = 0.5)
			animate(pixel_x = oldx-1, time = 0.5)
			animate(pixel_x = oldx, time = 0.5)
		return

/obj/structure/mineral_door/attack_right(mob/user)
	if(istype(user.get_active_held_item(), /obj/item/roguekey))
		var/obj/item/roguekey/held = user.get_active_held_item()
		trykeylock(held, user, TRUE)
		return
	. = ..()

/obj/structure/mineral_door/proc/trypicklock(obj/item/I, mob/user)
	if(door_opened || isSwitchingStates)
		to_chat(user, span_warning("This cannot be picked while it is open."))
		return
	if(!keylock)
		return
	if(lockbroken)
		to_chat(user, span_warning("The lock to this door is broken."))
		user.changeNext_move(CLICK_CD_MELEE)
	else
		var/lockprogress = 0
		var/locktreshold = 100

		var/obj/item/lockpick/P = I
		var/mob/living/L = user

		var/pickskill = user.mind.get_skill_level(/datum/skill/misc/lockpicking)
		var/perbonus = L.STAPER/5
		var/picktime = 70
		var/pickchance = 35
		var/moveup = 10

		picktime -= (pickskill * 10)
		picktime = clamp(picktime, 10, 70)

		moveup += (pickskill * 3)
		moveup = clamp(moveup, 10, 30)

		pickchance += pickskill * 10
		pickchance += perbonus
		pickchance *= P.picklvl
		pickchance = clamp(pickchance, 1, 95)



		while(!QDELETED(I) &&(lockprogress < locktreshold))
			if(!do_after(user, picktime, target = src))
				break
			if(prob(pickchance))
				lockprogress += moveup
				playsound(src.loc, pick('sound/items/pickgood1.ogg','sound/items/pickgood2.ogg'), 5, TRUE)
				to_chat(user, span_warning("Click..."))
				if(L.mind)
					var/amt2raise = L.STAINT
					var/boon = L.mind.get_learning_boon(/datum/skill/misc/lockpicking)
					L.mind.adjust_experience(/datum/skill/misc/lockpicking, amt2raise * boon)
				if(lockprogress >= locktreshold)
					to_chat(user, span_warning("The locking mechanism gives."))
					lock_toggle(user)
					break
				else
					continue
			else
				playsound(loc, 'sound/items/pickbad.ogg', 40, TRUE)
				I.take_damage(1, BRUTE, "melee")
				to_chat(user, span_warning("Clack."))
				continue
		return

/obj/structure/mineral_door/proc/lock_toggle(mob/user, is_right = FALSE)
	if(isSwitchingStates || door_opened)
		return
	if(locked && is_right)
		user.visible_message(span_warning("[user] unlocks [src]."), \
			span_notice("I unlock [src]."))
		playsound(src, unlocksound, 100)
		locked = 0
	else if(!is_right && !locked)
		user.visible_message(span_warning("[user] locks [src]."), \
			span_notice("I lock [src]."))
		playsound(src, locksound, 100)
		locked = 1

/obj/structure/mineral_door/setAnchored(anchorvalue) //called in default_unfasten_wrench() chain
	. = ..()
	set_opacity(anchored ? !door_opened : FALSE)
	air_update_turf(TRUE)

/obj/structure/mineral_door/wrench_act(mob/living/user, obj/item/I)
	..()
	default_unfasten_wrench(user, I, 40)
	return TRUE


/obj/structure/mineral_door/obj_break(damage_flag, mapload)
	if(!brokenstate)
		icon_state = "[base_state]br"
		density = FALSE
		opacity = FALSE
		brokenstate = TRUE
	..()

/obj/structure/mineral_door/OnCrafted(dirin, user)
	. = ..()
	keylock = FALSE
	GLOB.lockhashes.Remove(lockhash)
	lockhash = 0

/////////////////////// TOOL OVERRIDES ///////////////////////


/obj/structure/mineral_door/proc/pickaxe_door(mob/living/user, obj/item/I) //override if the door isn't supposed to be a minable mineral.
	return/*
	if(!istype(user))
		return
	if(I.tool_behaviour != TOOL_MINING)
		return
	. = TRUE
	to_chat(user, "<span class='notice'>I start digging [src]...</span>")
	if(I.use_tool(src, user, 40, volume=50))
		to_chat(user, "<span class='notice'>I finish digging.</span>")
		deconstruct(TRUE)*/

/obj/structure/mineral_door/welder_act(mob/living/user, obj/item/I) //override if the door is supposed to be flammable.
	..()
	. = TRUE
	if(anchored)
		to_chat(user, span_warning("[src] is still firmly secured to the ground!"))
		return

	user.visible_message(span_notice("[user] starts to weld apart [src]!"), span_notice("I start welding apart [src]."))
	if(!I.use_tool(src, user, 60, 5, 50))
		to_chat(user, span_warning("I failed to weld apart [src]!"))
		return

	user.visible_message(span_notice("[user] welded [src] into pieces!"), span_notice("I welded apart [src]!"))
	deconstruct(TRUE)

/obj/structure/mineral_door/proc/crowbar_door(mob/living/user, obj/item/I) //if the door is flammable, call this in crowbar_act() so we can still decon it
	. = TRUE
	if(anchored)
		to_chat(user, span_warning("[src] is still firmly secured to the ground!"))
		return

	user.visible_message(span_notice("[user] starts to pry apart [src]!"), span_notice("I start prying apart [src]."))
	if(!I.use_tool(src, user, 60, volume = 50))
		to_chat(user, span_warning("I failed to pry apart [src]!"))
		return

	user.visible_message(span_notice("[user] pried [src] into pieces!"), span_notice("I pried apart [src]!"))
	deconstruct(TRUE)


/////////////////////// END TOOL OVERRIDES ///////////////////////
/*

/obj/structure/mineral_door/deconstruct(disassembled = TRUE)
//	var/turf/T = get_turf(src)
//	if(disassembled)
//		new sheetType(T, sheetAmount)
//	else
//		new sheetType(T, max(sheetAmount - 2, 1))
//	qdel(src)
*/


/obj/structure/mineral_door/iron
	name = "iron door"
	max_integrity = 300

/obj/structure/mineral_door/silver
	name = "silver door"
	icon_state = "silver"
	sheetType = /obj/item/stack/sheet/mineral/silver
	max_integrity = 300
	rad_insulation = RAD_HEAVY_INSULATION

/obj/structure/mineral_door/gold
	name = "gold door"
	icon_state = "gold"
	sheetType = /obj/item/stack/sheet/mineral/gold
	rad_insulation = RAD_HEAVY_INSULATION

/obj/structure/mineral_door/uranium
	name = "uranium door"
	icon_state = "uranium"
	sheetType = /obj/item/stack/sheet/mineral/uranium
	max_integrity = 300
	light_outer_range =  2

/obj/structure/mineral_door/uranium/ComponentInitialize()
	return

/obj/structure/mineral_door/sandstone
	name = "sandstone door"
	icon_state = "sandstone"
	sheetType = /obj/item/stack/sheet/mineral/sandstone
	max_integrity = 100

/obj/structure/mineral_door/transparent
	opacity = FALSE
	rad_insulation = RAD_VERY_LIGHT_INSULATION

/obj/structure/mineral_door/transparent/Close()
	..()
	set_opacity(FALSE)

/obj/structure/mineral_door/transparent/plasma
	name = "plasma door"
	icon_state = "plasma"
	sheetType = /obj/item/stack/sheet/mineral/plasma

/obj/structure/mineral_door/transparent/plasma/ComponentInitialize()
	return

/obj/structure/mineral_door/transparent/plasma/welder_act(mob/living/user, obj/item/I)
	return

/obj/structure/mineral_door/transparent/plasma/attackby(obj/item/W, mob/user, params)
	if(W.get_temperature())
		var/turf/T = get_turf(src)
		message_admins("Plasma mineral door ignited by [ADMIN_LOOKUPFLW(user)] in [ADMIN_VERBOSEJMP(T)]")
		log_game("Plasma mineral door ignited by [key_name(user)] in [AREACOORD(T)]")
		TemperatureAct()
	else
		return ..()

/obj/structure/mineral_door/transparent/plasma/temperature_expose(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature > 300)
		TemperatureAct()

/obj/structure/mineral_door/transparent/plasma/proc/TemperatureAct()
	atmos_spawn_air("plasma=500;TEMP=1000")
	deconstruct(FALSE)

/obj/structure/mineral_door/transparent/diamond
	name = "diamond door"
	icon_state = "diamond"
	sheetType = /obj/item/stack/sheet/mineral/diamond
	max_integrity = 1000
	rad_insulation = RAD_EXTREME_INSULATION




/obj/structure/mineral_door/paperframe
	name = "paper frame door"
	icon_state = "paperframe"
	openSound = 'sound/foley/doors/creak.ogg'
	closeSound = 'sound/foley/doors/shut.ogg'
	sheetType = /obj/item/stack/sheet/paperframes
	sheetAmount = 3
	resistance_flags = FLAMMABLE
	max_integrity = 20

/obj/structure/mineral_door/paperframe/Initialize()
	. = ..()
	queue_smooth_neighbors(src)

/obj/structure/mineral_door/paperframe/examine(mob/user)
	. = ..()
	if(obj_integrity < max_integrity)
		. += span_info("It looks a bit damaged, you may be able to fix it with some <b>paper</b>.")

/obj/structure/mineral_door/paperframe/pickaxe_door(mob/living/user, obj/item/I)
	return

/obj/structure/mineral_door/paperframe/welder_act(mob/living/user, obj/item/I)
	return

/obj/structure/mineral_door/paperframe/crowbar_act(mob/living/user, obj/item/I)
	return crowbar_door(user, I)

/obj/structure/mineral_door/paperframe/attackby(obj/item/I, mob/living/user)
	if(I.get_temperature()) //BURN IT ALL DOWN JIM
		fire_act(I.get_temperature())
		return

	if((user.used_intent.type != INTENT_HARM) && istype(I, /obj/item/paper) && (obj_integrity < max_integrity))
		user.visible_message(span_notice("[user] starts to patch the holes in [src]."), span_notice("I start patching some of the holes in [src]!"))
		if(do_after(user, 20, TRUE, src))
			obj_integrity = min(obj_integrity+4,max_integrity)
			qdel(I)
			user.visible_message(span_notice("[user] patches some of the holes in [src]."), span_notice("I patch some of the holes in [src]!"))
			return TRUE

	return ..()

/obj/structure/mineral_door/paperframe/ComponentInitialize()
	return

/obj/structure/mineral_door/paperframe/Destroy()
	queue_smooth_neighbors(src)
	return ..()



//ROGUEDOOR

/obj/structure/mineral_door/wood
	name = "door"
	desc = ""
	icon_state = "woodhandle"
	openSound = list('sound/foley/doors/creak.ogg')
	closeSound = 'sound/foley/doors/shut.ogg'
	sheetType = null
	resistance_flags = FLAMMABLE
	max_integrity = 1000
	damage_deflection = 12
	layer = ABOVE_MOB_LAYER
	keylock = TRUE
	icon = 'icons/roguetown/misc/doors.dmi'
	blade_dulling = DULLING_BASHCHOP
	break_sound = 'sound/combat/hits/onwood/destroywalldoor.ogg'
	attacked_sound = list('sound/combat/hits/onwood/woodimpact (1).ogg','sound/combat/hits/onwood/woodimpact (2).ogg')
	var/over_state = "woodover"
	repairable = TRUE
	repair_cost_first = /obj/item/grown/log/tree/small
	repair_cost_second = /obj/item/grown/log/tree/small
	repair_skill = /datum/skill/craft/carpentry

/obj/structure/mineral_door/wood/Initialize()
	if(icon_state =="woodhandle")
		if(icon_state != "wcv")
			if(prob(10))
				icon_state = "wcg"
			else if(prob(10))
				icon_state = "wcr"
	if(over_state)
		add_overlay(mutable_appearance(icon, "[over_state]", ABOVE_MOB_LAYER))
	..()

/obj/structure/mineral_door/wood/green
	icon_state = "wcg"
/obj/structure/mineral_door/wood/red
	icon_state = "wcr"
/obj/structure/mineral_door/wood/violet
	icon_state = "wcv"


/obj/structure/mineral_door/wood/pickaxe_door(mob/living/user, obj/item/I)
	return

/obj/structure/mineral_door/wood/welder_act(mob/living/user, obj/item/I)
	return

/obj/structure/mineral_door/wood/crowbar_act(mob/living/user, obj/item/I)
	return crowbar_door(user, I)

/obj/structure/mineral_door/wood/attackby(obj/item/I, mob/living/user)
	return ..()

/obj/structure/mineral_door/wood/fire_act(added, maxstacks)
	testing("added [added]")
	if(!added)
		return FALSE
	if(added < 10)
		return FALSE
	..()

/obj/structure/mineral_door/swing_door
	name = "swing door"
	desc = "A door that swings."
	icon_state = "woodhandle"
	openSound = 'sound/foley/doors/creak.ogg'
	closeSound = 'sound/foley/doors/shut.ogg'
	sheetType = null
	resistance_flags = FLAMMABLE
	max_integrity = 1000
	damage_deflection = 12
	layer = ABOVE_MOB_LAYER
	opacity = FALSE
	windowed = TRUE
	keylock = FALSE
	icon = 'icons/roguetown/misc/doors.dmi'
	icon_state = "swing"
	blade_dulling = DULLING_BASHCHOP
	break_sound = 'sound/combat/hits/onwood/destroywalldoor.ogg'
	attacked_sound = list('sound/combat/hits/onwood/woodimpact (1).ogg','sound/combat/hits/onwood/woodimpact (2).ogg')
	repairable = TRUE
	repair_cost_first = /obj/item/grown/log/tree/small
	repair_cost_second = /obj/item/grown/log/tree/small
	repair_skill = /datum/skill/craft/carpentry

/obj/structure/mineral_door/wood/window
	opacity = FALSE
	icon_state = "woodwindow"
	windowed = TRUE
	desc = ""
	over_state = "woodwindowopen"

/obj/structure/mineral_door/wood/fancywood
	icon_state = "fancy_wood"
	desc = ""
	over_state = "fancy_woodopen"

/obj/structure/mineral_door/wood/deadbolt
	desc = ""
	icon_state = "wooddir"
	base_state = "wood"
	var/lockdir
	keylock = FALSE
	max_integrity = 500
	over_state = "woodopen"
	kickthresh = 10
	openSound = 'sound/foley/doors/shittyopen.ogg'
	closeSound = 'sound/foley/doors/shittyclose.ogg'

/obj/structure/mineral_door/wood/deadbolt/OnCrafted(dirin)
	dir = turn(dirin, 180)
	lockdir = dir

/obj/structure/mineral_door/wood/deadbolt/Initialize()
	. = ..()
	lockdir = dir
	icon_state = base_state

/obj/structure/mineral_door/wood/deadbolt/attack_right(mob/user)
	if(door_opened || isSwitchingStates)
		return
	if(lockbroken)
		to_chat(user, span_warning("The lock to this door is broken."))
		return
	if(brokenstate)
		to_chat(user, span_warning("There isn't much left of this door."))
		return
	if(get_dir(src,user) == lockdir)
		lock_toggle(user)
	else
		to_chat(user, span_warning("The door doesn't lock from this side."))

/obj/structure/mineral_door/wood/donjon
	desc = ""
	icon_state = "donjondir"
	base_state = "donjon"
	keylock = TRUE
	max_integrity = 2000
	over_state = "dunjonopen"
	var/viewportdir
	kickthresh = 15
	locksound = 'sound/foley/doors/lockmetal.ogg'
	unlocksound = 'sound/foley/doors/lockmetal.ogg'
	rattlesound = 'sound/foley/doors/lockrattlemetal.ogg'
	attacked_sound = list("sound/combat/hits/onmetal/metalimpact (1).ogg", "sound/combat/hits/onmetal/metalimpact (2).ogg")
	repair_cost_second = /obj/item/ingot/iron
	repair_skill = /datum/skill/craft/carpentry

/obj/structure/mineral_door/wood/donjon/stone
	desc = ""
	icon_state = "stone"
	base_state = "stone"
	keylock = TRUE
	max_integrity = 1000
	over_state = "stoneopen"
	attacked_sound = list('sound/combat/hits/onwood/woodimpact (1).ogg','sound/combat/hits/onwood/woodimpact (2).ogg')
	repair_cost_first = /obj/item/natural/stone
	repair_cost_second = /obj/item/natural/stone
	repair_skill = /datum/skill/craft/masonry

/obj/structure/mineral_door/wood/donjon/stone/attack_right(mob/user)
	return

/obj/structure/mineral_door/wood/donjon/stone/view_toggle(mob/user)
	return

/obj/structure/mineral_door/wood/donjon/Initialize()
	viewportdir = dir
	icon_state = base_state
	..()

/obj/structure/mineral_door/wood/donjon/attack_right(mob/user)
	if(door_opened || isSwitchingStates)
		return
	if(brokenstate)
		to_chat(user, span_warning("There isn't much left of this door."))
		return
	if(get_dir(src,user) == viewportdir)
		view_toggle(user)
	else
		to_chat(user, span_warning("The viewport doesn't toggle from this side."))
		return

/obj/structure/mineral_door/wood/donjon/proc/view_toggle(mob/user)
	if(door_opened)
		return
	if(opacity)
		to_chat(user, span_info("I slide the viewport open."))
		opacity = FALSE
		playsound(src, 'sound/foley/doors/windowup.ogg', 100, FALSE)
	else
		to_chat(user, span_info("I slide the viewport closed."))
		opacity = TRUE
		playsound(src, 'sound/foley/doors/windowup.ogg', 100, FALSE)


/obj/structure/mineral_door/bars
	name = "iron door"
	desc = ""
	icon_state = "bars"
	openSound = 'sound/foley/doors/ironopen.ogg'
	closeSound = 'sound/foley/doors/ironclose.ogg'
	resistance_flags = null
	max_integrity = 1000
	damage_deflection = 15
	layer = ABOVE_MOB_LAYER
	keylock = TRUE
	icon = 'icons/roguetown/misc/doors.dmi'
	blade_dulling = DULLING_BASH
	opacity = FALSE
	windowed = TRUE
	keylock = TRUE
	sheetType = null
	locksound = 'sound/foley/doors/lock.ogg'
	unlocksound = 'sound/foley/doors/unlock.ogg'
	rattlesound = 'sound/foley/doors/lockrattlemetal.ogg'
	attacked_sound = list("sound/combat/hits/onmetal/metalimpact (1).ogg", "sound/combat/hits/onmetal/metalimpact (2).ogg")
	ridethrough = TRUE
	swing_closed = FALSE
	repair_cost_first = /obj/item/ingot/iron
	repair_cost_second = /obj/item/ingot/iron
	repair_skill = /datum/skill/craft/blacksmithing

/obj/structure/mineral_door/bars/Initialize()
	. = ..()
	add_overlay(mutable_appearance(icon, "barsopen", ABOVE_MOB_LAYER))


/obj/structure/mineral_door/bars/onkick(mob/user)
	user.visible_message("<span class='warning'>[user] kicks [src]!</span>")
	return


/obj/structure/mineral_door/wood/deadbolt/shutter
	name = "serving hatch"
	desc = "Can be locked from the inside."
	icon_state = "serving"
	base_state = "serving"
	max_integrity = 250
	over_state = "servingopen"
	openSound = 'modular/Neu_Food/sound/blindsopen.ogg'
	closeSound = 'modular/Neu_Food/sound/blindsclose.ogg'
	dir = NORTH
	locked = TRUE
