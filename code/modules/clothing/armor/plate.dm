/obj/item/clothing/armor/plate
	name = "steel half-plate"
	desc = "Plate armor with shoulder guards. An incomplete, bulky set of excellent armor."
	icon_state = "halfplate"
	anvilrepair = /datum/skill/craft/armorsmithing
	smeltresult = /obj/item/ingot/steel
	equip_delay_self = 4 SECONDS
	unequip_delay_self = 4 SECONDS
	equip_sound = 'sound/foley/equip/equip_armor_plate.ogg'
	sellprice = VALUE_STEEL_ARMOR
	clothing_flags = CANT_SLEEP_IN

	armor_class = AC_HEAVY
	armor = ARMOR_PLATE
	body_parts_covered = COVERAGE_ALL_BUT_ARMS
	prevent_crits = ALL_EXCEPT_STAB
	max_integrity = INTEGRITY_STRONGEST
	do_sound_plate = TRUE

//................ Full Plate Armor ............... //
/obj/item/clothing/armor/plate/full
	name = "plate armor"
	desc = "Full plate. Leg protecting tassets, groin cup, armored vambraces."
	icon_state = "plate"
	item_state = "plate"
	equip_delay_self = 8 SECONDS
	unequip_delay_self = 7 SECONDS
	sellprice = VALUE_FULL_PLATE

	armor = ARMOR_PLATE
	body_parts_covered = COVERAGE_FULL


//................ Iron Plate Armor ............... //
/obj/item/clothing/armor/plate/iron
	name = "iron plate armor"
	desc = "A rough set of iron armor, complete with chainmail joints and pauldrons. A simple and cheap design to protect vital zones, but not the arms."
	icon_state = "ironplate"
	smeltresult = /obj/item/ingot/iron
	sellprice = VALUE_IRON_ARMOR*2

	armor = ARMOR_PLATE_BAD
	max_integrity = INTEGRITY_STRONG

//................ Rusted Half-plate ............... //
/obj/item/clothing/armor/plate/rust
	name = "rusted half-plate"
	desc = "Old glory, old defeats, most of the rust comes from damp and not the blood of previous wearers, one would hope."
	icon = 'icons/roguetown/clothing/special/rust_armor.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/rust_armor.dmi'
	sleeved = 'icons/roguetown/clothing/special/onmob/rust_armor.dmi'
	icon_state = "rustplate"
	item_state = "rustplate"
	smeltresult = /obj/item/ingot/iron
	sellprice = VALUE_IRON_ARMOR/2
	armor = ARMOR_PLATE_BAD
	max_integrity = INTEGRITY_STANDARD

/obj/item/clothing/armor/plate/blkknight
	name = "blacksteel plate"
	body_parts_covered = COVERAGE_ALL_BUT_LEGS
	armor_class = AC_MEDIUM
	icon_state = "bkarmor"
	icon = 'icons/roguetown/clothing/special/blkknight.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'
	sleeved = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'
	anvilrepair = /datum/skill/craft/blacksmithing
	smeltresult = /obj/item/ingot/blacksteel
