#define TRAIT_BAN_PUNISHMENT "banpunish"

#define BAN_MISC_RESPAWN "Respawn"
#define BAN_MISC_PUNISHMENT_CURSE "PunishmentCurse"
#define BAN_MISC_LUNATIC "Lunatic"
#define BAN_MISC_LEPROSY "Leprosy"
#define BAN_MISC_OOC "OOC"
#define BAN_MISC_DEADCHAT "Deadchat"

#define ALL_MISC_BANS list(,\
	BAN_MISC_RESPAWN,\
	BAN_MISC_PUNISHMENT_CURSE,\
	BAN_MISC_LEPROSY,\
	BAN_MISC_LUNATIC,\
	BAN_MISC_OOC,\
	BAN_MISC_DEADCHAT,\
)

#define ALL_ANTAG_BANS list(,\
	ROLE_SYNDICATE,\
	ROLE_VILLAIN,\
	ROLE_WEREWOLF,\
	ROLE_VAMPIRE,\
	ROLE_NBEAST,\
	ROLE_BANDIT,\
	ROLE_PREBEL,\
)

#define ALL_PRESET_TRAIT_BANS list(,\
	TRAIT_PACIFISM,\
)

GLOBAL_LIST_EMPTY(ckey_role_bans)
GLOBAL_PROTECT(ckey_role_bans)
