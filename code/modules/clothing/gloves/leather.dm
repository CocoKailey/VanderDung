
/obj/item/clothing/gloves/leather
	name = "leather gloves"
	desc = "Gloves made out of sturdy leather. Warm, and offer very small protection against melee attacks."
	icon_state = "leather_gloves"
	resistance_flags = null
	blocksound = SOFTHIT
	blade_dulling = DULLING_BASHCHOP
	resistance_flags = FLAMMABLE // Made of leather

	armor = ARMOR_PADDED_BAD
	prevent_crits = CUT_AND_MINOR_CRITS
	max_integrity = INTEGRITY_POOR
	salvage_result = /obj/item/natural/hide/cured

/obj/item/clothing/gloves/leather/black
	color = CLOTHING_SOOT_BLACK

/obj/item/clothing/gloves/leather/advanced
	name = "hardened leather gloves"
	desc = "Sturdy, durable, flexible. A marvel of the dark ages that exists solely to protect your fingers."
	max_integrity = 200
	prevent_crits = list(BCLASS_CUT, BCLASS_BLUNT, BCLASS_TWIST)
	armor = list("blunt" = 50, "slash" = 40, "stab" = 20, "piercing" = 0, "fire" = 0, "acid" = 0)

/obj/item/clothing/gloves/leather/masterwork
	name = "masterwork leather gloves"
	desc = "These gloves are a craftsmanship marvel. Made with the finest leather. Strong, nimible, reliable."
	max_integrity = 300
	prevent_crits = list(BCLASS_CUT, BCLASS_BLUNT, BCLASS_TWIST, BCLASS_CHOP) //we're adding chop here!
	armor = list("blunt" = 80, "slash" = 60, "stab" = 40, "piercing" = 0, "fire" = 0, "acid" = 0)

/obj/item/clothing/gloves/leather/masterwork/Initialize()
	. = ..()
	filters += filter(type="drop_shadow", x=0, y=0, size=0.5, offset=1, color=rgb(218, 165, 32))

/obj/item/clothing/gloves/leather/feld
	name = "feldsher's gloves"
	desc = "Improved grip for wielding the tools of the trade."
	icon_state = "feldgloves"

/obj/item/clothing/gloves/leather/phys
	name = "physicker's gloves"
	desc = "Improved grip for wielding disembowled organs."
	icon_state = "surggloves"

/obj/item/clothing/gloves/leather/apothecary
	name = "apothecary gloves"
	desc = "Thick leather gloves for pulling thorny plants... or cracking skulls."
	icon_state = "apothgloves"
