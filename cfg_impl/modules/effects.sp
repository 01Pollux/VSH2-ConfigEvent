public Action ConfigEvent_MakeBleed(EventMap args, ConfigEventType_t event_type)
{
	/*
	"<enum>"
	{
		// apply bleeding on target
		"procedure"  "ConfigEvent_MakeBleed"

		// depend on 	'event_type', usually 'player' for calling player, check 'vsh2hooks*.sp'
		// 'target' will assume the 'player' is an entity index
		// while 'vsh2target' will assume the 'player' is a client userid
		"vsh2target"	"player"
		// "target"		"player"

		"duration"	  "1.0"
	}
	*/
	
	int calling_player_idx;
	VSH2Player calling_player;
	if (!args.GetTarget(calling_player_idx, calling_player))
		return Plugin_Continue;

	float duration;
	if (!args.GetFloat("duration", duration))
		duration = 5.0;
	
	TF2_MakeBleed(calling_player_idx, calling_player_idx, duration);
	return Plugin_Continue;
}

public Action ConfigEvent_MakeIgnite(EventMap args, ConfigEventType_t event_type)
{
	/*
	"<enum>"
	{
		// ignite the target
		"procedure"  "ConfigEvent_MakeIgnite"

		// depend on 	'event_type', usually 'player' for calling player, check 'vsh2hooks*.sp'
		// 'target' will assume the 'player' is an entity index
		// while 'vsh2target' will assume the 'player' is a client userid
		"vsh2target"	"player"
		// "target"		"player"

		"duration"	  "1.0"
	}
	*/
	
	int calling_player_idx;
	VSH2Player calling_player;
	if (!args.GetTarget(calling_player_idx, calling_player))
		return Plugin_Continue;

	float duration;
	if (!args.GetFloat("duration", duration))
		duration = 5.0;
	
	TF2_IgnitePlayer(calling_player_idx, calling_player_idx, duration);
	return Plugin_Continue;
}

public Action ConfigEvent_MakeStun(EventMap args, ConfigEventType_t event_type)
{
	/*
	"<enum>"
	{
		// stun the target
		"procedure"  "ConfigEvent_MakeStun"

		// depend on 	'event_type', usually 'player' for calling player, check 'vsh2hooks*.sp'
		// 'target' will assume the 'player' is an entity index
		// while 'vsh2target' will assume the 'player' is a client userid
		"vsh2target"	"player"
		// "target"		"player"

		"duration"  "1.0"
		"flags"		"1010"  // 1 << 1 | 1 << 3 (TF_STUNFLAG_CHEERSOUND | TF_STUNFLAG_BONKSTUCK)
	}
	*/
	
	int calling_player_idx;
	VSH2Player calling_player;
	if (!args.GetTarget(calling_player_idx, calling_player))
		return Plugin_Continue;

	float duration;
	if (!args.GetFloat("duration", duration))
		duration = 5.0;

	float slowdown; args.GetFloat("slowdown", slowdown);
	
	int flags; args.GetInt("flags", flags, 2);
	
	TF2_StunPlayer(calling_player_idx, duration, slowdown, flags);
	return Plugin_Continue;
}

public Action ConfigEvent_ForceSuicide(EventMap args, ConfigEventType_t event_type)
{
	/*
	"<enum>"
	{
		// force player to suicide
		"procedure"  "ConfigEvent_ForceSuicide"

		// depend on 	'event_type', usually 'player' for calling player, check 'vsh2hooks*.sp'
		// 'target' will assume the 'player' is an entity index
		// while 'vsh2target' will assume the 'player' is a client userid
		"vsh2target"	"player"
		// "target"		"player"
	}
	*/
	
	int calling_player_idx;
	VSH2Player calling_player;
	if (!args.GetTarget(calling_player_idx, calling_player))
		return Plugin_Continue;
	
	ForcePlayerSuicide(calling_player_idx);
	return Plugin_Continue;
}