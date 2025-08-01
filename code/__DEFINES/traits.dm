#define TRAIT_STATUS_EFFECT(effect_id) "[effect_id]-trait"

#define SIGNAL_ADDTRAIT(trait_ref) ("addtrait " + trait_ref)
#define SIGNAL_REMOVETRAIT(trait_ref) ("removetrait " + trait_ref)

// trait accessor defines
#define ADD_TRAIT(target, trait, source) \
	do { \
		var/list/_L; \
		if (!target.status_traits) { \
			target.status_traits = list(); \
			_L = target.status_traits; \
			_L[trait] = list(source); \
			SEND_SIGNAL(target, SIGNAL_ADDTRAIT(trait)); \
			SEND_GLOBAL_SIGNAL(COMSIG_ATOM_ADD_TRAIT, target, trait); \
		} else { \
			_L = target.status_traits; \
			if (_L[trait]) { \
				_L[trait] |= list(source); \
			} else { \
				_L[trait] = list(source); \
				SEND_SIGNAL(target, SIGNAL_ADDTRAIT(trait)); \
				SEND_GLOBAL_SIGNAL(COMSIG_ATOM_ADD_TRAIT, target, trait); \
			}; \
		} \
	} while (0)
#define REMOVE_TRAIT(target, trait, sources) \
	do { \
		var/list/_L = target.status_traits; \
		var/list/_S; \
		if (sources && !islist(sources)) { \
			_S = list(sources); \
		} else { \
			_S = sources; \
		}; \
		if (_L && _L[trait]) { \
			for (var/_T in _L[trait]) { \
				if ((!_S && (_T != ROUNDSTART_TRAIT)) || (_T in _S)) { \
					_L[trait] -= _T; \
				}; \
			};\
			if (!length(_L[trait])) { \
				_L -= trait; \
				SEND_SIGNAL(target, SIGNAL_REMOVETRAIT(trait)); \
				SEND_GLOBAL_SIGNAL(COMSIG_ATOM_REMOVE_TRAIT, target, trait); \
			}; \
			if (!length(_L)) { \
				target.status_traits = null; \
			}; \
		} \
	} while (0)
#define REMOVE_TRAITS_NOT_IN(target, sources) \
	do { \
		var/list/_L = target.status_traits; \
		var/list/_S = sources; \
		if (_L) { \
			for (var/_T in _L) { \
				_L[_T] &= _S; \
				if (!length(_L[_T])) { \
					_L -= _T; \
					SEND_SIGNAL(target, SIGNAL_REMOVETRAIT(_T)); \
					SEND_GLOBAL_SIGNAL(COMSIG_ATOM_REMOVE_TRAIT, target, trait); \
				}; \
			};\
			if (!length(_L)) { \
				target.status_traits = null\
			};\
		}\
	} while (0)

#define HAS_TRAIT(target, trait) (target.status_traits ? (target.status_traits[trait] ? TRUE : FALSE) : FALSE)
#define HAS_TRAIT_FROM(target, trait, source) (target.status_traits ? (target.status_traits[trait] ? (source in target.status_traits[trait]) : FALSE) : FALSE)
#define HAS_TRAIT_NOT_FROM(target, trait, source) (HAS_TRAIT(target, trait) && (length(target.status_traits[trait] - source) > 0))

/*
Remember to update _globalvars/traits.dm if you're adding/removing/renaming traits.
*/

//mob traits
#define TRAIT_IMMOBILIZED		"immobilized" //! Prevents voluntary movement.
#define TRAIT_KNOCKEDOUT		"knockedout" //! Forces the user to stay unconscious.
#define TRAIT_FLOORED 			"floored" //! Prevents standing or staying up on its own.
/// Prevents usage of manipulation appendages (picking, holding or using items, manipulating storage).
#define TRAIT_HANDS_BLOCKED		"handsblocked"
/// Inability to access UI hud elements. Turned into a trait from [MOBILITY_UI] to be able to track sources.
#define TRAIT_UI_BLOCKED		"uiblocked"
/// Inability to pull things. Turned into a trait from [MOBILITY_PULL] to be able to track sources.
#define TRAIT_PULL_BLOCKED		"pullblocked"
/// Abstract condition that prevents movement if being pulled and might be resisted against. Handcuffs and straight jackets, basically.
#define TRAIT_RESTRAINED		"restrained"
#define TRAIT_INCAPACITATED		"incapacitated"
#define TRAIT_BLIND 			"blind"
#define TRAIT_MUTE				"mute"
#define TRAIT_ZOMBIE_SPEECH 	"zombie_speech"
#define TRAIT_GARGLE_SPEECH		"gargle_speech"
#define TRAIT_EMOTEMUTE			"emotemute"
#define TRAIT_DEAF				"deaf"
#define TRAIT_NEARSIGHT			"nearsighted"
#define TRAIT_FAT				"fat"
#define TRAIT_HUSK				"husk"
#define TRAIT_CHUNKYFINGERS		"chunkyfingers" //means that you can't use weapons with normal trigger guards.
#define TRAIT_DUMB				"dumb"
#define TRAIT_MONKEYLIKE		"monkeylike" //sets IsAdvancedToolUser to FALSE
#define TRAIT_PACIFISM			"pacifism"
#define TRAIT_IGNORESLOWDOWN	"ignoreslow"
#define TRAIT_IGNOREDAMAGESLOWDOWN "ignoredamageslowdown"
#define TRAIT_DEATHCOMA			"deathcoma" //Causes death-like unconsciousness
#define TRAIT_FAKEDEATH			"fakedeath" //Makes the owner appear as dead to most forms of medical examination
#define TRAIT_STUNIMMUNE		"stun_immunity"
#define TRAIT_STUNRESISTANCE    "stun_resistance"
#define TRAIT_SLEEPIMMUNE		"sleep_immunity"
#define TRAIT_PUSHIMMUNE		"push_immunity"
#define TRAIT_STABLEHEART		"stable_heart"
#define TRAIT_NOPAINSTUN		"no_pain-stun"
#define TRAIT_RESISTHEAT		"resist_heat"
#define TRAIT_RESISTHEATHANDS	"resist_heat_handsonly" //For when you want to be able to touch hot things, but still want fire to be an issue.
#define TRAIT_RESISTCOLD		"resist_cold"
#define TRAIT_RESISTHIGHPRESSURE	"resist_high_pressure"
#define TRAIT_RESISTLOWPRESSURE	"resist_low_pressure"
#define TRAIT_RADIMMUNE			"rad_immunity"
#define TRAIT_PIERCEIMMUNE		"pierce_immunity"
#define TRAIT_NODISMEMBER		"dismember_immunity"
#define TRAIT_NOFIRE			"nonflammable"
#define TRAIT_NOGUNS			"no_guns"
#define TRAIT_NOHUNGER			"no_hunger"
#define TRAIT_NOMETABOLISM		"no_metabolism"
#define TRAIT_TOXIMMUNE			"toxin_immune"
#define TRAIT_EASYDISMEMBER		"easy_dismember"
#define TRAIT_LIMBATTACHMENT	"limb_attach"
#define TRAIT_NOLIMBDISABLE		"no_limb_disable"
#define TRAIT_EASYLIMBDISABLE	"easy_limb_disable"
#define TRAIT_TOXINLOVER		"toxinlover"
#define TRAIT_NOBREATH			"no_breath"
#define TRAIT_HOLY				"holy"
#define TRAIT_NOCRITDAMAGE		"no_crit"
#define TRAIT_NOSLIPWATER		"noslip_water"
#define TRAIT_NOSLIPALL			"noslip_all"
#define TRAIT_NODEATH			"nodeath"
#define TRAIT_NOHARDCRIT		"nohardcrit"
#define TRAIT_NOSOFTCRIT		"nosoftcrit"
#define TRAIT_MINDSHIELD		"mindshield"
#define TRAIT_DISSECTED			"dissected"
#define TRAIT_SIXTHSENSE		"sixth_sense" //I can hear dead people
#define TRAIT_FEARLESS			"fearless"
#define TRAIT_PARALYSIS_L_ARM	"para-l-arm" //These are used for brain-based paralysis, where replacing the limb won't fix it
#define TRAIT_PARALYSIS_R_ARM	"para-r-arm"
#define TRAIT_PARALYSIS_L_LEG	"para-l-leg"
#define TRAIT_PARALYSIS_R_LEG	"para-r-leg"
#define TRAIT_NOMOBSWAP         "no-mob-swap"
#define TRAIT_XRAY_VISION       "xray_vision"
#define TRAIT_THERMAL_VISION    "thermal_vision"
#define TRAIT_ABDUCTOR_TRAINING "abductor-training"
#define TRAIT_ABDUCTOR_SCIENTIST_TRAINING "abductor-scientist-training"
#define TRAIT_SURGEON           "surgeon"
#define TRAIT_STRONG_GRABBER	"strong_grabber"
#define TRAIT_MAGIC_CHOKE		"magic_choke"
#define TRAIT_SOOTHED_THROAT    "soothed-throat"
#define TRAIT_LAW_ENFORCEMENT_METABOLISM "law-enforcement-metabolism"
#define TRAIT_ALWAYS_CLEAN      "always-clean"
#define TRAIT_BOOZE_SLIDER      "booze-slider"
#define TRAIT_QUICK_CARRY		"quick-carry"
#define TRAIT_QUICKER_CARRY		"quicker-carry"
#define TRAIT_UNINTELLIGIBLE_SPEECH "unintelligible-speech"
#define TRAIT_LANGUAGE_BARRIER	"language-barrier"
#define TRAIT_PASSTABLE			"passtable"
#define TRAIT_NOFLASH			"noflash" //Makes you immune to flashes
#define TRAIT_NOPAIN			"no_pain"
#define TRAIT_DRUQK				"druqk"
#define TRAIT_BURIED_COIN_GIVEN "buried_coin_given" // prevents a human corpse from being used for a corpse multiple times
#define TRAIT_BLOODLOSS_IMMUNE "bloodloss_immune" // can bleed, but will never die from blood loss
#define TRAIT_ROTMAN "rotman" //you are a rotman and need occasional maintenance
#define TRAIT_ZOMBIE_IMMUNE "zombie_immune" //immune to zombie infection
#define TRAIT_NO_BITE "no_bite" //prevents biting
#define TRAIT_HARDDISMEMBER		"hard_dismember"
#define TRAIT_FOREIGNER "foreigner" // is this guy a foreigner?
#define TRAIT_NOAMBUSH "no_ambush" //! mob cannot be ambushed for any reason
/// Can swim ignoring water flow and slowdown
#define TRAIT_GOOD_SWIM "good_swim"
///trait determines if this mob can breed given by /datum/component/breeding
#define TRAIT_MOB_BREEDER "mob_breeder"
#define TRAIT_IMPERCEPTIBLE "imperceptible" // can't be perceived in any way, likely due to invisibility

//bodypart traits
#define TRAIT_PARALYSIS	"paralysis" //Used for limb-based paralysis and full body paralysis
#define TRAIT_BRITTLE "brittle" //The limb is more susceptible to fractures
#define TRAIT_FINGERLESS "fingerless" //The limb has no fingies

//item traits
#define TRAIT_NODROP            "nodrop"
#define TRAIT_NOEMBED			"noembed"
#define TRAIT_NO_TELEPORT		"no-teleport" //you just can't

// Debug traits
/// This object has sound debugging tools attached to it
#define TRAIT_SOUND_DEBUGGED "sound_debugged"

/// Buckling yourself to objects with this trait won't immobilize you
#define TRAIT_NO_IMMOBILIZE "no_immobilize"

// common trait sources
#define TRAIT_GENERIC "generic"
#define UNCONSCIOUS_TRAIT "unconscious"
#define EYE_DAMAGE "eye_damage"
#define GENETIC_MUTATION "genetic"
#define OBESITY "obesity"
#define MAGIC_TRAIT "magic"
#define TRAUMA_TRAIT "trauma"
#define DISEASE_TRAIT "disease"
#define SPECIES_TRAIT "species"
#define ORGAN_TRAIT "organ"
#define CRIT_TRAIT "crit"
#define ROUNDSTART_TRAIT "roundstart" //cannot be removed without admin intervention
#define JOB_TRAIT "job"
#define CYBORG_ITEM_TRAIT "cyborg-item"
#define ADMIN_TRAIT "admin" // (B)admins only.
#define CHANGELING_TRAIT "changeling"
#define CULT_TRAIT "cult"
#define CURSED_ITEM_TRAIT "cursed-item" // The item is magically cursed
#define ABSTRACT_ITEM_TRAIT "abstract-item"
#define STATUS_EFFECT_TRAIT "status-effect"
#define CLOTHING_TRAIT "clothing"
#define HELMET_TRAIT "helmet"
#define GLASSES_TRAIT "glasses"
#define VEHICLE_TRAIT "vehicle" // inherited from riding vehicles
#define INNATE_TRAIT "innate"
#define CRIT_HEALTH_TRAIT "crit_health"
#define OXYLOSS_TRAIT "oxyloss"
#define BLOODLOSS_TRAIT "bloodloss"
#define TRAIT_PROFANE "profane"
/// Trait associated to being buckled
#define BUCKLED_TRAIT "buckled"
/// Trait associated to being held in a chokehold
#define CHOKEHOLD_TRAIT "chokehold"
/// trait associated to resting
#define RESTING_TRAIT "resting"
/// Trait associated to wearing a suit
#define SUIT_TRAIT "suit"
/// Trait associated to lying down (having a [lying_angle] of a different value than zero).
#define LYING_DOWN_TRAIT "lying-down"

/// trait associated to a stat value or range of
#define STAT_TRAIT "stat"

// unique trait sources, still defines
#define TRAIT_BESTIALSENSE "bestial-sense"
#define TRAIT_DARKVISION "darkvision"
#define CLONING_POD_TRAIT "cloning-pod"
#define STATUE_MUTE "statue"
#define CHANGELING_DRAIN "drain"
#define CHANGELING_HIVEMIND_MUTE "ling_mute"
#define ABYSSAL_GAZE_BLIND "abyssal_gaze"
#define HIGHLANDER "highlander"
#define TRAIT_HULK "hulk"
#define STASIS_MUTE "stasis"
#define GENETICS_SPELL "genetics_spell"
#define EYES_COVERED "eyes_covered"
#define CULT_EYES "cult_eyes"
#define TRAIT_SANTA "santa"
#define SCRYING_ORB "scrying-orb"
#define ABDUCTOR_ANTAGONIST "abductor-antagonist"
#define NUKEOP_TRAIT "nuke-op"
#define DEATHSQUAD_TRAIT "deathsquad"
#define CLOWN_NUKE_TRAIT "clown-nuke"
#define STICKY_MOUSTACHE_TRAIT "sticky-moustache"
#define CHAINSAW_FRENZY_TRAIT "chainsaw-frenzy"
#define CHRONO_GUN_TRAIT "chrono-gun"
#define REVERSE_BEAR_TRAP_TRAIT "reverse-bear-trap"
#define CURSED_MASK_TRAIT "cursed-mask"
#define HIS_GRACE_TRAIT "his-grace"
#define HAND_REPLACEMENT_TRAIT "magic-hand"
#define HOT_POTATO_TRAIT "hot-potato"
#define SABRE_SUICIDE_TRAIT "sabre-suicide"
#define ABDUCTOR_VEST_TRAIT "abductor-vest"
#define CAPTURE_THE_FLAG_TRAIT "capture-the-flag"
#define EYE_OF_GOD_TRAIT "eye-of-god"
#define SHAMEBRERO_TRAIT "shamebrero"
#define CHRONOSUIT_TRAIT "chronosuit"
#define LOCKED_HELMET_TRAIT "locked-helmet"
#define ANTI_DROP_IMPLANT_TRAIT "anti-drop-implant"
#define SLEEPING_CARP_TRAIT "sleeping_carp"
#define MADE_UNCLONEABLE "made-uncloneable"
#define TIMESTOP_TRAIT "timestop"
#define PULLED_WHILE_SOFTCRIT_TRAIT "pulled-while-softcrit"
#define ADVENTURER_TRAIT "adventurer"
#define TRAIT_LONGSTRIDER "longstrider"
#define TRAIT_GUIDANCE "guidance"

#define TRAIT_WEBWALK 					"Webwalker"
#define TRAIT_NOSTINK 					"Dead Nose"
#define TRAIT_ZJUMP 					"High Jumping"
#define TRAIT_JESTERPHOBIA 				"Jesterphobic"
#define TRAIT_XENOPHOBIC 				"Xenophobic"
#define TRAIT_TOLERANT 					"Tolerant"
#define TRAIT_NOSEGRAB 				"Intimidating"
#define TRAIT_NUTCRACKER 				"Nutcracker"
#define TRAIT_STRONGBITE				"Strong Bite"
#define TRAIT_HATEWOMEN				"Ladykiller"
#define TRAIT_SEEDKNOW 				"Seed Knower"
#define TRAIT_NOBLE					"Noble Blooded"
#define TRAIT_EMPATH					"Empath"
#define TRAIT_BREADY					"Battleready"
#define TRAIT_HEARING_SENSITIVE 		"hearing_sensitive"
#define TRAIT_MEDIUMARMOR				"Mail Training"
#define TRAIT_HEAVYARMOR				"Plate Training"
#define TRAIT_DODGEEXPERT              "Fast Reflexes"
#define TRAIT_DECEIVING_MEEKNESS 		"Deceiving Meekness"
#define TRAIT_VILLAIN					"Villain"
#define TRAIT_CRITICAL_RESISTANCE		"Critical Resistance"
#define TRAIT_CRITICAL_WEAKNESS		"Critical Weakness"
#define TRAIT_MANIAC_AWOKEN			"Awoken"
#define TRAIT_NOSTAMINA				"Indefatigable" //for ai
#define TRAIT_NOSLEEP				"Fatal Insomnia" //for thralls
#define TRAIT_FASTSLEEP 			"Fast Sleeper"
#define TRAIT_NUDIST					"Nudist" //you can't wear most clothes
#define TRAIT_INHUMANE_ANATOMY			"Inhumen Anatomy" //can't wear hats and shoes
#define TRAIT_NASTY_EATER 				"Inhumen Digestion" //can eat rotten food, organs, poison berries, and drink murky water
#define TRAIT_NOFALLDAMAGE1 		"Minor Fall Damage Immunity"
#define TRAIT_NOFALLDAMAGE2 		"Total	 Fall Damage Immunity"
#define TRAIT_DEATHSIGHT "Veiled Whispers" // Is notified when a player character dies, but not told exactly where or how.
#define TRAIT_CYCLOPS_LEFT				"Cyclops (Left)" //poked left eye
#define TRAIT_CYCLOPS_RIGHT				"Cyclops (Right)" //poked right eye
#define TRAIT_ASSASSIN					"Assassin Training" //used for the assassin drifter's unique mechanics.
#define TRAIT_BARDIC_TRAINING			"Bardic Training"
#define TRAIT_GRAVEROBBER				"Graverobber"	// Prevents getting the cursed debuff when unearthing a grave, but permanent -1 LUC to whoever has it.
#define TRAIT_BLESSED					"Once Blessed"	// prevents blessings stackings
#define TRAIT_MIRACULOUS_FORAGING		"Miracle Foraging"	// makes bushes much more generous
#define TRAIT_MISSING_NOSE				"Missing Nose" //halved stamina regeneration
#define TRAIT_DISFIGURED				"Disfigured"
#define TRAIT_SPELLBLOCK				"Bewitched" //prevents spellcasting
#define TRAIT_ANTISCRYING				"Anti-Scrying"
#define TRAIT_SHOCKIMMUNE				"Shock Immunity"
#define TRAIT_LEGENDARY_ALCHEMIST		"Expert Herb Finder"
#define TRAIT_LIGHT_STEP				"Light Step" //Can't trigger /obj/structure/trap/'s
#define TRAIT_THIEVESGUILD				"Thieves Guild Member"
#define TRAIT_ENGINEERING_GOGGLES		"Engineering Goggles"
#define TRAIT_SEEPRICES				    "Golden Blood" //See prices
#define TRAIT_SEE_LEYLINES				"Magical Visions"
#define TRAIT_POISONBITE				"Poison Bite"
#define TRAIT_FORAGER					"Foraging Knowledge" //Can tell which berries are good to eat when examining
#define TRAIT_TINY 						"Tiny"
#define TRAIT_DREAM_WATCHER				"Noc Blessed" //Unique Trait of the Dream Watcher Town Elder Class, they have a chance to know about antags or gods influences.
#define TRAIT_HOLLOWBONES				"Hollow Bones"
#define TRAIT_AMAZING_BACK				"Light Load"
#define TRAIT_KITTEN_MOM				"Loved By Kittens"
#define TRAIT_WATER_BREATHING			"Waterbreathing"
#define TRAIT_MOONWATER_ELIXIR			"Moonwater Elixir"
#define TRAIT_FLOWERFIELD_IMMUNITY		"Flower Strider"
#define TRAIT_SECRET_OFFICIANT			"Secret Officiant"
/// applied to orphans
#define TRAIT_ORPHAN 					"Orphan"
#define TRAIT_RECRUITED					"Recruit" //Trait used to give foreigners their new title

// Divine patron trait bonuses:
#define TRAIT_SOUL_EXAMINE				"Blessing of Necra"  //can check bodies to see if they have departed
#define TRAIT_ROT_EATER					"Blessing of Pestra" //can eat rotten food
#define TRAIT_KNEESTINGER_IMMUNITY		"Blessing of Dendor" //Can move through kneestingers.
#define TRAIT_LEECHIMMUNE				"Unleechable" //leeches drain very little blood
#define TRAIT_SHARPER_BLADES			"Sharper Blades" //Weapons lose less blade integrity
#define TRAIT_BETTER_SLEEP				"Better Sleep" //Recover more energy (blue bar) when sleeping
#define TRAIT_EXTEROCEPTION				"Exteroception" //See others' hunger and thirst
#define TRAIT_TUTELAGE					"Tutelage" //Slightly more sleep xp to you and xp to apprentices
#define TRAIT_APRICITY					"Apricity" //Decreased stamina regen time during "day"
#define TRAIT_BLACKLEG					"Blackleg" //Rig coin, dice, cards in your favor

// Inhumen patron trait bonuses:
#define TRAIT_ORGAN_EATER				"Blessing of Graggar"//Can eat organs (duh.) and raw meat
#define TRAIT_CRACKHEAD					"Blessing of Baotha" //No overdose on drugs.
#define TRAIT_CABAL                     "Of the Cabal" //Zizo cultists recognize each other too
#define TRAIT_MATTHIOS_EYES				"Eyes of Matthios" //Examine to see the most expensive item someone has

#define TRAIT_BASHDOORS "bashdoors"
#define TRAIT_NOMOOD "no_mood"
#define TRAIT_BAD_MOOD "Bad Mood"
#define TRAIT_NIGHT_OWL "Night Owl"
#define TRAIT_SIMPLE_WOUNDS "simple_wounds"
#define TRAIT_SCHIZO_AMBIENCE "schizo_ambience" //replaces all ambience with creepy shit
#define TRAIT_SCREENSHAKE "screenshake" //screen will always be shaking, you cannot stop it
#define TRAIT_PUNISHMENT_CURSE "PunishmentCurse"
#define TRAIT_BANDITCAMP "banditcamp"
#define TRAIT_KNOWBANDITS "knowbandits"
#define TRAIT_KNOWKEEPPLANS "knowkeepplans"
#define TRAIT_VAMPMANSION "vampiremansion"
#define TRAIT_VAMP_DREAMS "vamp_dreams"
#define TRAIT_INHUMENCAMP "inhumencamp"
#define TRAIT_INTRAINING "intraining" //allows certain roles to bypass the average skill limitation of training dummies
#define TRAIT_STEELHEARTED "steelhearted" //no bad mood from dismembering or seeing this
#define TRAIT_IWASREVIVED "iwasrevived" //prevents PQ gain from reviving the same person twice
#define TRAIT_IWASUNZOMBIFIED "iwasunzombified" //prevents PQ gain from curing a zombie twice
#define TRAIT_ZIZOID_HUNTED "zizoidhunted" // Used to signal character has been marked by death by the Zizoid cult
#define TRAIT_LEPROSY "Leprosy"
#define TRAIT_NUDE_SLEEPER "Nude Sleeper"
#define TRAIT_CIVILIZEDBARBARIAN "Civilized Barbarian"
#define TRAIT_BEAUTIFUL "Beautiful"
#define TRAIT_UGLY "Ugly"
#define TRAIT_SCHIZO_FLAW "Schizophrenic"

// JOB RELATED TRAITS

#define TRAIT_MALUMFIRE "Professional Smith"
#define TRAIT_CRATEMOVER "Crate Mover"
#define TRAIT_BURDEN "Burdened" //Gaffer stuff
#define TRAIT_OLDPARTY "Old Party"
#define TRAIT_EARGRAB "Ear Grab"
#define TRAIT_FACELESS "Faceless One"

// PATRON CURSE TRAITS
#define TRAIT_CURSE "Curse" //source
#define TRAIT_ATHEISM_CURSE "Curse of Atheism"
#define TRAIT_PSYDON_CURSE "Psydon's Curse"
#define TRAIT_ASTRATA_CURSE "Astrata's Curse"
#define TRAIT_NOC_CURSE "Noc's Curse"
#define TRAIT_RAVOX_CURSE "Ravox's Curse"
#define TRAIT_NECRA_CURSE "Necra's Curse"
#define TRAIT_XYLIX_CURSE "Xylix's Curse"
#define TRAIT_PESTRA_CURSE "Pestra's Curse"
#define TRAIT_EORA_CURSE "Eora's Curse"
#define TRAIT_ZIZO_CURSE "Zizo's Curse"
#define TRAIT_GRAGGAR_CURSE "Graggar's Curse"
#define TRAIT_MATTHIOS_CURSE "Matthios' Curse"
#define TRAIT_BAOTHA_CURSE "Baotha's Curse"

#define TRAIT_I_AM_INVISIBLE_ON_A_BOAT "invisible_on_tram"
///Trait given by /datum/element/relay_attacker
#define TRAIT_RELAYING_ATTACKER "relaying_attacker"

#define LACKING_LOCOMOTION_APPENDAGES_TRAIT "lacking-locomotion-appengades" //trait associated to not having locomotion appendages nor the ability to fly or float
#define LACKING_MANIPULATION_APPENDAGES_TRAIT "lacking-manipulation-appengades" //trait associated to not having fine manipulation appendages such as hands
#define HANDCUFFED_TRAIT "handcuffed"
/// Trait applied by by [/datum/component/soulstoned]
#define SOULSTONE_TRAIT "soulstone"
/// Trait applied to brain mobs when they lack external aid for locomotion, such as being inside a mech.
#define BRAIN_UNAIDED "brain-unaided"
/// Ignores body_parts_covered during the add_fingerprint() proc. Works both on the person and the item in the glove slot.
#define TRAIT_FINGERPRINT_PASSTHROUGH "fingerprint_passthrough"

/// This mob is phased out of reality from magic, either a jaunt or rod form
#define TRAIT_MAGICALLY_PHASED "magically_phased"

/// Is runechat for this atom/movable currently disabled, regardless of prefs or anything?
#define TRAIT_RUNECHAT_HIDDEN "runechat_hiddenn"

/// Target can't be grabbed by tanglers
#define TRAIT_ENTANGLER_IMMUNE "tangler_immune"

/// This mob is antimagic, and immune to spells / cannot cast spells
#define TRAIT_ANTIMAGIC "anti_magic"

/// This allows a person who has antimagic to cast spells without getting blocked
#define TRAIT_ANTIMAGIC_NO_SELFBLOCK "anti_magic_no_selfblock"

/// makes your footsteps completely silent
#define TRAIT_SILENT_FOOTSTEPS "silent_footsteps"

#define TRAIT_DUALWIELDER "Dual Wielder"

/// Properly wielded two handed item
#define TRAIT_WIELDED "wielded"
/// The items needs two hands to be carried
#define TRAIT_NEEDS_TWO_HANDS "needstwohands"
