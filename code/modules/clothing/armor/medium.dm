/obj/item/clothing/armor/medium	// Template, not for use
	name = "Medium armor template"
	equip_delay_self = 4 SECONDS
	unequip_delay_self = 3 SECONDS
	anvilrepair = /datum/skill/craft/armorsmithing
	smeltresult = /obj/item/ingot/steel
	armor_class = AC_MEDIUM
	armor = ARMOR_SCALE
	max_integrity = INTEGRITY_STANDARD
	clothing_flags = CANT_SLEEP_IN
	prevent_crits = ALL_EXCEPT_STAB

/obj/item/clothing/armor/medium/scale // important is how this item covers legs too compared to halfplate
	name = "scalemail"
	desc = "Overlapping steel plates almost makes the wearer look like he has silvery fish scales."
	icon_state = "scale"
	sellprice = VALUE_STEEL_ARMOR_FINE

	body_parts_covered = COVERAGE_ALL_BUT_ARMS
	prevent_crits = ALL_CRITICAL_HITS
	max_integrity = INTEGRITY_STRONG


//................ Armored Surcoat ............... //	- splint mail looking armor thats colored
/obj/item/clothing/armor/medium/surcoat
	name = "armored surcoat"
	desc = "Metal plates partly hidden by cloth, fitted for a man."
	icon_state = "surcoat"
	item_state = "surcoat"
	detail_tag = "_metal"		// metal bits are the details so keep them uncolorer = white
	detail_color = COLOR_WHITE

/obj/item/clothing/armor/medium/surcoat/Initialize()
	. = ..()
	update_icon()

/obj/item/clothing/armor/medium/surcoat/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

//................ Armored surcoat (Heartfelt) ............... //
/obj/item/clothing/armor/medium/surcoat/heartfelt
	desc = "A lordly protection in Heartfelt colors. Masterfully crafted coat of plates, for important nobility."
	color = CLOTHING_BLOOD_RED
	sellprice = VALUE_SNOWFLAKE_STEEL+BONUS_VALUE_SMALL

	body_parts_covered = COVERAGE_FULL
