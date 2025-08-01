/datum/repeatable_crafting_recipe/leather
	abstract_type = /datum/repeatable_crafting_recipe/leather
	requirements = list(
		/obj/item/natural/hide/cured = 1
	)
	tool_usage = list(
		/obj/item/needle = list("starts to sew", "start to sew")
	)

	starting_atom = /obj/item/needle
	attacked_atom = /obj/item/natural/hide/cured
	skillcraft = /datum/skill/craft/tanning
	craftdiff = 0
	subtypes_allowed = TRUE // so you can use any subtype of fur
	category = "Leatherworking"

/// Storage ///
/datum/repeatable_crafting_recipe/leather/storage
	abstract_type = /datum/repeatable_crafting_recipe/leather/storage
	attacked_atom = /obj/machinery/tanningrack
	category = "Storage"
	craftdiff = 1

/datum/repeatable_crafting_recipe/leather/storage/quiver
	name = "quiver"
	requirements = list(
		/obj/item/natural/hide/cured = 1,
		/obj/item/natural/fibers = 2,
	)
	output = /obj/item/ammo_holder/quiver

/datum/repeatable_crafting_recipe/leather/storage/dartpouch
	name = "dart pouch"
	requirements = list(
		/obj/item/natural/hide/cured = 1,
		/obj/item/natural/fibers = 2,
	)
	output = /obj/item/ammo_holder/dartpouch

/datum/repeatable_crafting_recipe/leather/storage/magepouch
	name = "summoners pouch"
	requirements = list(
		/obj/item/natural/hide/cured = 1,
		/obj/item/natural/fibers = 2,
	)
	output = /obj/item/storage/magebag

/datum/repeatable_crafting_recipe/leather/storage/meatbag
	name = "game satchel"
	requirements = list(
		/obj/item/natural/hide/cured = 1,
		/obj/item/natural/fibers = 2,
	)
	output = /obj/item/storage/meatbag

/datum/repeatable_crafting_recipe/leather/storage/waterskin
	name = "waterskin"
	requirements = list(
		/obj/item/natural/hide/cured = 1,
		/obj/item/natural/fibers = 2,
	)
	output = /obj/item/reagent_containers/glass/bottle/waterskin
	craftdiff = 0

/datum/repeatable_crafting_recipe/leather/storage/pouch
	name = "leather pouch"
	requirements = list(
		/obj/item/natural/hide/cured = 1,
		/obj/item/natural/cloth = 1,
	)
	output = /obj/item/storage/belt/pouch
	sellprice = 6

/datum/repeatable_crafting_recipe/leather/storage/satchel
	name = "leather satchel"
	requirements = list(
		/obj/item/natural/hide/cured = 2,
		/obj/item/rope = 1,
	)
	output = /obj/item/storage/backpack/satchel
	craftdiff = 1

/datum/repeatable_crafting_recipe/leather/storage/backpack
	name = "leather backpack"
	requirements = list(
		/obj/item/natural/hide/cured = 3,
		/obj/item/rope = 2,
	)
	output = /obj/item/storage/backpack/backpack
	craftdiff = 2

/// Misc Leatherworking
/datum/repeatable_crafting_recipe/leather/bedsheetpelt
	name = "leather bedsheet"
	output = /obj/item/bedsheet/pelt
	attacked_atom = /obj/machinery/tanningrack
	requirements = list(/obj/item/natural/hide/cured = 2,
				/obj/item/natural/cloth = 1)
	craftdiff = 1
	category = "Misc Leather"

/datum/repeatable_crafting_recipe/leather/double_bedsheetpelt
	name = "large leather bedsheet"
	output = /obj/item/bedsheet/double_pelt
	attacked_atom = /obj/machinery/tanningrack
	requirements = list(/obj/item/natural/hide/cured = 4,
				/obj/item/natural/cloth = 2)
	craftdiff = 2
	category = "Misc Leather"

/datum/repeatable_crafting_recipe/leather/sleepingbag_deluxe
	name = "deluxe bedroll"
	output = /obj/item/sleepingbag/deluxe
	attacked_atom = /obj/machinery/tanningrack
	requirements =  list(/obj/item/natural/hide/cured = 2,
				/obj/item/rope = 1)
	craftdiff = 2
	category = "Misc Leather"

/datum/repeatable_crafting_recipe/leather/saddle
	name = "saddle"
	attacked_atom = /obj/machinery/tanningrack
	requirements = list(
		/obj/item/natural/hide/cured = 2,
	)
	output = /obj/item/natural/saddle
	craftdiff = 1
	category = "Misc Leather"

/// Clothing
/datum/repeatable_crafting_recipe/leather/gloves
	name = "leather gloves"
	output_amount = 2
	output = /obj/item/clothing/gloves/leather

/datum/repeatable_crafting_recipe/leather/bracers
	name = "leather bracers"
	output_amount = 2
	output = /obj/item/clothing/wrists/bracers/leather

/datum/repeatable_crafting_recipe/leather/pants
	name = "leather pants"
	output = /obj/item/clothing/pants/trou/leather

/datum/repeatable_crafting_recipe/leather/shoes
	name = "leather shoes"
	output_amount = 2
	output = /obj/item/clothing/shoes/simpleshoes

/datum/repeatable_crafting_recipe/leather/boots
	name = "leather boots"
	output = /obj/item/clothing/shoes/boots/leather

/datum/repeatable_crafting_recipe/leather/corset
	name = "corset"
	output = /obj/item/clothing/armor/corset

/datum/repeatable_crafting_recipe/leather/sandals
	name = "sandals"
	requirements = list(
		/obj/item/natural/hide/cured = 1,
		/obj/item/natural/fibers = 1
	)
	output = /obj/item/clothing/shoes/sandals

/datum/repeatable_crafting_recipe/leather/gladiator
	name = "caligae"
	requirements = list(
		/obj/item/natural/hide/cured = 1,
		/obj/item/natural/fibers = 1
	)
	output = /obj/item/clothing/shoes/gladiator
	sellprice = 17
	craftdiff = 1

/datum/repeatable_crafting_recipe/leather/cloak
	name = "leather raincloak"
	requirements = list(
		/obj/item/natural/hide/cured = 2,
	)
	output = /obj/item/clothing/cloak/raincloak/brown
	craftdiff = 2

/datum/repeatable_crafting_recipe/leather/cloakfur
	name = "fur lined raincloak"
	requirements = list(
		/obj/item/natural/hide/cured = 2,
		/obj/item/natural/fur = 1,
	)
	output = /obj/item/clothing/cloak/raincloak/furcloak

/datum/repeatable_crafting_recipe/leather/belt
	name = "leather belt"
	requirements = list(
		/obj/item/natural/hide/cured = 1,
		/obj/item/natural/fibers = 1,
	)
	output = /obj/item/storage/belt/leather

/datum/repeatable_crafting_recipe/leather/vest
	name = "leather vest"
	requirements = list(
		/obj/item/natural/hide/cured = 2,
	)
	output = /obj/item/clothing/armor/leather/vest
	craftdiff = 3

/datum/repeatable_crafting_recipe/leather/seajacket
	name = "sea jacket"
	requirements = list(
		/obj/item/natural/hide/cured = 2,
	)
	output = /obj/item/clothing/armor/leather/jacket/sea
	craftdiff = 3

/datum/repeatable_crafting_recipe/leather/apron
	name = "leather apron"
	requirements = list(
		/obj/item/natural/cloth = 2,
		/obj/item/natural/hide/cured = 1,
	)
	output = /obj/item/clothing/cloak/apron/brown
	craftdiff = 2

/datum/repeatable_crafting_recipe/leather/furlinedanklets
	name = "fur lined anklets"
	requirements = list(
		/obj/item/natural/hide/cured = 1,
		/obj/item/natural/fur = 1,
	)
	output = /obj/item/clothing/shoes/boots/furlinedanklets

/datum/repeatable_crafting_recipe/leather/heavygloves
	name = "heavy leather gloves"
	requirements = list(
		/obj/item/natural/hide/cured = 1,
		/obj/item/natural/fur = 1,
	)
	output = /obj/item/clothing/gloves/angle
	craftdiff = 1

/datum/repeatable_crafting_recipe/leather/helmet
	name = "leather helmet"
	requirements = list(
		/obj/item/natural/hide/cured = 2,
	)
	output = /obj/item/clothing/head/helmet/leather
	craftdiff = 1

/datum/repeatable_crafting_recipe/leather/coif
	name = "leather coif"
	requirements = list(
		/obj/item/natural/hide/cured = 1,
	)
	output = /obj/item/clothing/neck/coif
	craftdiff = 2

/datum/repeatable_crafting_recipe/leather/leatherjacket
	name = "leather jacket"
	requirements = list(
		/obj/item/natural/hide/cured = 2,
	)
	output = /obj/item/clothing/armor/leather/jacket
	craftdiff = 1

/datum/repeatable_crafting_recipe/leather/armor
	name = "leather armor"
	requirements = list(
		/obj/item/natural/hide/cured = 2,
	)
	output = /obj/item/clothing/armor/leather
	craftdiff = 1

/datum/repeatable_crafting_recipe/leather/hidearmor
	name = "fur lined leather armor"
	requirements = list(
		/obj/item/natural/hide/cured = 2,
		/obj/item/natural/fur = 1,
	)
	output = /obj/item/clothing/armor/leather/hide
	craftdiff = 2

/datum/repeatable_crafting_recipe/leather/whip
	name = "leather whip"
	requirements = list(
		/obj/item/natural/hide/cured = 2,
	)
	output = /obj/item/weapon/whip
	craftdiff = 1

/datum/repeatable_crafting_recipe/leather/furlinedboots
	name = "fur lined boots"
	requirements = list(
		/obj/item/natural/hide/cured = 2,
		/obj/item/natural/fur = 2,
	)
	output = /obj/item/clothing/shoes/boots/furlinedboots
	craftdiff = 1

/datum/repeatable_crafting_recipe/leather/shortboots
	name = "shortboots"
	requirements = list(
		/obj/item/natural/hide/cured = 2,
	)
	output = /obj/item/clothing/shoes/shortboots
	craftdiff = 1

/datum/repeatable_crafting_recipe/leather/darkboots
	name = "dark boots"
	requirements = list(
		/obj/item/natural/hide/cured = 2,
		/obj/item/natural/cloth = 1
	)
	output = /obj/item/clothing/shoes/boots
	craftdiff = 2

/datum/repeatable_crafting_recipe/leather/ridingboots
	name = "riding boots"
	requirements = list(
		/obj/item/natural/hide/cured = 1,
		/obj/item/natural/fibers = 2,
		/obj/item/natural/cloth = 1,
	)
	output = /obj/item/clothing/shoes/ridingboots
	craftdiff = 3

/datum/repeatable_crafting_recipe/leather/leathercoat
	name = "leather coat"
	output = /obj/item/clothing/armor/leather/jacket/leathercoat
	requirements = list(/obj/item/natural/hide/cured = 2,
				/obj/item/natural/fibers = 2)
	craftdiff = 3

/datum/repeatable_crafting_recipe/leather/leathercoat/black // never add items with the same names
	name = "black leather coat"
	output = /obj/item/clothing/armor/leather/jacket/leathercoat/black
	requirements = list(/obj/item/natural/hide/cured = 2,
				/obj/item/natural/fibers = 2)
	craftdiff = 3

/datum/repeatable_crafting_recipe/leather/nobleboots
	name = "noble boots"
	output = /obj/item/clothing/shoes/nobleboot
	requirements = list(
		/obj/item/natural/hide/cured = 2,
		/obj/item/natural/fibers = 2,
		/obj/item/natural/cloth = 2,
	)
	craftdiff = 4

/datum/repeatable_crafting_recipe/leather/lordcloak
	name = "lordly cloak"
	output = /obj/item/clothing/cloak/lordcloak
	requirements = list(/obj/item/natural/fur = 2,
				/obj/item/natural/hide/cured = 4)
	craftdiff = 4

/datum/repeatable_crafting_recipe/leather/ladycloak
	name = "lady cloak"
	output = /obj/item/clothing/cloak/lordcloak/ladycloak
	requirements = list(/obj/item/natural/fur = 2,
				/obj/item/natural/hide/cured = 4)
	craftdiff = 4

/datum/repeatable_crafting_recipe/leather/brimmedhat
	name = "brimmed hat"
	requirements = list(
		/obj/item/natural/hide/cured = 1,
	)
	output_amount = 2
	output = /obj/item/clothing/head/brimmed
	craftdiff = 1

/datum/repeatable_crafting_recipe/leather/tricorn
	name = "tricorn (black)"
	requirements = list(
		/obj/item/natural/hide/cured = 2,
	)
	output = /obj/item/clothing/head/helmet/leather/tricorn
	craftdiff = 2

/// Standalones

/datum/repeatable_crafting_recipe/leather/leathercollar
	name = "leather collar"
	output = /obj/item/clothing/neck/leathercollar
	requirements = list(/obj/item/natural/hide/cured = 1,
				/obj/item/natural/fibers = 2)
	craftdiff = 2

/datum/repeatable_crafting_recipe/leather/bellcollar
	name = "bell collar"
	output = /obj/item/clothing/neck/bellcollar
	requirements = list(/obj/item/natural/hide/cured = 1,
				/obj/item/natural/fibers = 2,
				/obj/item/jingle_bells = 1)
	craftdiff = 2

/datum/repeatable_crafting_recipe/leather/standalone
	abstract_type = /datum/repeatable_crafting_recipe/leather/standalone
	category = "Special Leather"

/datum/repeatable_crafting_recipe/leather/standalone/boots
	name = "hardened leather boots"
	output = /obj/item/clothing/shoes/boots/leather/advanced
	requirements = list(/obj/item/natural/hide/cured = 1,
				/obj/item/natural/fibers = 1)
	craftdiff = 4

/datum/repeatable_crafting_recipe/leather/standalone/gloves
	name = "hardened leather gloves"
	output = /obj/item/clothing/gloves/leather/advanced
	requirements = list(/obj/item/natural/hide/cured = 1,
				/obj/item/natural/fibers = 1)
	craftdiff = 4

/datum/repeatable_crafting_recipe/leather/standalone/coat
	name = "hardened leather coat"
	output = /obj/item/clothing/armor/leather/advanced
	requirements = list(/obj/item/natural/hide/cured = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 4

/datum/repeatable_crafting_recipe/leather/standalone/helmet
	name = "hardened leather helmet"
	output = /obj/item/clothing/head/helmet/leather/advanced
	requirements = list(/obj/item/natural/hide/cured = 1,
				/obj/item/natural/fibers = 1)
	craftdiff = 4

/datum/repeatable_crafting_recipe/leather/standalone/chausses
	name = "hardened leather chausses"
	output = /obj/item/clothing/pants/trou/leather/advanced
	requirements = list(/obj/item/natural/hide/cured = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 4

/// MASTERWORK

/datum/repeatable_crafting_recipe/leather/standalone/boots/masterwork
	name = "masterwork leather boots"
	output = /obj/item/clothing/shoes/boots/leather/masterwork
	attacked_atom = /obj/item/clothing/shoes/boots/leather
	requirements = list(/obj/item/clothing/shoes/boots/leather = 1,
				/obj/item/natural/cured/essence = 1,
				/obj/item/natural/fibers = 1)
	craftdiff = 5

/datum/repeatable_crafting_recipe/leather/standalone/gloves/masterwork
	name = "masterwork leather gloves"
	output = /obj/item/clothing/gloves/leather/masterwork
	attacked_atom = /obj/item/clothing/gloves/leather
	requirements = list(/obj/item/clothing/gloves/leather = 1,
				/obj/item/natural/cured/essence = 1,
				/obj/item/natural/fibers = 1)
	craftdiff = 5

/datum/repeatable_crafting_recipe/leather/standalone/bracers
	abstract_type = /datum/repeatable_crafting_recipe/leather/standalone/bracers

/datum/repeatable_crafting_recipe/leather/standalone/bracers/masterwork
	name = "masterwork leather bracers"
	output = /obj/item/clothing/wrists/bracers/leather/masterwork
	attacked_atom = /obj/item/clothing/wrists/bracers/leather
	requirements = list(/obj/item/clothing/wrists/bracers/leather = 1,
				/obj/item/natural/cured/essence = 1,
				/obj/item/natural/fibers = 1)
	craftdiff = 5

/datum/repeatable_crafting_recipe/leather/standalone/coat/masterwork
	name = "masterwork leather coat"
	output = /obj/item/clothing/armor/leather/masterwork
	attacked_atom = /obj/item/clothing/armor/leather
	requirements = list(/obj/item/clothing/armor/leather = 1,
				/obj/item/natural/cured/essence = 1,
				/obj/item/natural/fibers = 1)
	craftdiff = 5

/datum/repeatable_crafting_recipe/leather/standalone/helmet/masterwork
	name = "masterwork leather helmet"
	output = /obj/item/clothing/head/helmet/leather/masterwork
	attacked_atom = /obj/item/clothing/head/helmet/leather
	requirements = list(/obj/item/clothing/head/helmet/leather = 1,
				/obj/item/natural/cured/essence = 1,
				/obj/item/natural/fibers = 1)
	craftdiff = 5

/datum/repeatable_crafting_recipe/leather/standalone/chausses/masterwork
	name = "masterwork leather chausses"
	output = /obj/item/clothing/pants/trou/leather/masterwork
	attacked_atom = /obj/item/clothing/pants/trou/leather
	requirements = list(/obj/item/clothing/pants/trou/leather = 1,
				/obj/item/natural/cured/essence = 1,
				/obj/item/natural/fibers = 1)
	craftdiff = 5
