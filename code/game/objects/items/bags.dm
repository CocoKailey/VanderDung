/obj/item/storage/sack
	name = "sack"
	desc = "A simple canvas sack."
	icon_state = "cbag"
	item_state = "bag"
	icon = 'icons/roguetown/items/misc.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/head_items.dmi'
	slot_flags = ITEM_SLOT_HEAD
	w_class = WEIGHT_CLASS_NORMAL
	resistance_flags = NONE
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR
	max_integrity = 300
	lefthand_file = 'icons/mob/inhands/weapons/rogue_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/rogue_righthand.dmi'
	experimental_inhand = FALSE
	experimental_onhip = FALSE
	experimental_onback = FALSE
	component_type = /datum/component/storage/concrete/grid/sack

/obj/item/storage/sack/examine(mob/user)
	. = ..()
	if(length(contents))
		. += span_notice("[length(contents)] thing[length(contents) > 1 ? "s" : ""] in [src].")

/obj/item/storage/sack/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(slot & ITEM_SLOT_HEAD)
		user.become_blind("blindfold_[REF(src)]")
	if(HAS_TRAIT(user, TRAIT_ROTMAN))
		to_chat(user, span_info("The [src] slips through dead fingers..."))
		user.dropItemToGround(src, TRUE)

/obj/item/storage/sack/dropped(mob/living/carbon/human/user)
	..()
	user.cure_blind("blindfold_[REF(src)]")

/obj/item/storage/sack/mob_can_equip(mob/M, slot)
	if(!..())
		return FALSE
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	var/list/things = STR.contents()
	if(things.len)
		return FALSE
	else
		return TRUE

/obj/item/storage/sack/attack_hand_secondary(mob/user, params)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	. = SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	if(user.get_active_held_item())
		to_chat(user, span_warning("My hands are full, I cannot reach into [src]!"))
		return
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	var/list/things = STR.contents()
	if(!length(things))
		to_chat(user, span_warning("The sack is empty!"))
		return
	var/obj/item/I = pick(things)
	STR.remove_from_storage(I, get_turf(user))
	user.put_in_hands(I)
	user.changeNext_move(CLICK_CD_MELEE)
	return

/obj/item/storage/sack/update_icon_state()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	var/list/things = STR.contents()
	if(things.len)
		icon_state = "fbag"
		w_class = WEIGHT_CLASS_BULKY
	else
		icon_state = "cbag"
		w_class = WEIGHT_CLASS_NORMAL

/obj/item/storage/sack/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,
"sx" = -4,
"sy" = -7,
"nx" = 6,
"ny" = -6,
"wx" = -2,
"wy" = -7,
"ex" = -1,
"ey" = -7,
"northabove" = 0,
"southabove" = 1,
"eastabove" = 1,
"westabove" = 0,
"nturn" = 0,
"sturn" = 0,
"wturn" = 0,
"eturn" = 0,
"nflip" = 8,
"sflip" = 0,
"wflip" = 0,
"eflip" = 8)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/storage/meatbag
	name = "game satchel"
	desc = "A cloth and leather satchel for storing the fruit of one's hunt."
	icon_state = "gamesatchel"
	icon = 'icons/roguetown/clothing/storage.dmi'
	slot_flags = ITEM_SLOT_BACK_L|ITEM_SLOT_BACK_R|ITEM_SLOT_HIP
	w_class = WEIGHT_CLASS_NORMAL
	resistance_flags = NONE
	max_integrity = 300
	component_type = /datum/component/storage/concrete/grid/sack/meat

/obj/item/storage/meatbag/attack_hand_secondary(mob/user, params)
	. = ..()
	if(.)
		return
	user.changeNext_move(CLICK_CD_MELEE)
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	var/list/things = STR.contents()
	if(things.len)
		var/obj/item/I = pick(things)
		STR.remove_from_storage(I, get_turf(user))
		user.put_in_hands(I)

/obj/item/storage/meatbag/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.4,
"sx" = -4,
"sy" = -7,
"nx" = 6,
"ny" = -6,
"wx" = -2,
"wy" = -7,
"ex" = -1,
"ey" = -7,
"northabove" = 0,
"southabove" = 1,
"eastabove" = 1,
"westabove" = 0,
"nturn" = 0,
"sturn" = 0,
"wturn" = 0,
"eturn" = 0,
"nflip" = 0,
"sflip" = 0,
"wflip" = 0,
"eflip" = 8)
