public Action ConfigEvent_ScreenShake(EventMap args, ConfigEventType_t event_type)
{
	/*
	"<enum>"
	{
		// apply screen shake to target
		"procedure"  "ConfigEvent_ScreenShake"

		// depend on 	'event_type', usually 'player' for calling player, check 'vsh2hooks*.sp'
		// 'target' will assume the 'player' is an entity index
		// while 'vsh2target' will assume the 'player' is a client userid
		"vsh2target"	"player"
		// "target"		"player"

		"amplitude"	 "6.0"
		"frequency"	 "1.0"
		"duration"	  "5.0"
		"sound"		 ""
		"air"		   "true" 
	}
	*/
	
	int calling_player_idx;
	VSH2Player calling_player;
	if (!args.GetTarget(calling_player_idx, calling_player))
		return Plugin_Continue;
	
	int sound_size = args.GetSize("sound");
	char[] sound = new char[sound_size];
	if (sound_size)
		args.Get("sound", sound, sound_size);
	
	float amplitude; args.GetFloat("amplitude", amplitude);
	float frequency; args.GetFloat("frequency", frequency);
	float duration; args.GetFloat("duration", duration);
	bool air_shake; args.GetBool("air", air_shake, false);

	ScreenShakeOne(calling_player_idx, amplitude, frequency, duration, SHAKE_START, sound, air_shake);

	return Plugin_Continue;
}

public Action ConfigEvent_AreaScreenShake(EventMap args, ConfigEventType_t event_type)
{
	/*
	"<enum>"
	{
		// apply screen shake to targets
		"procedure"  "ConfigEvent_AreaScreenShake"

		// depend on 	'event_type', usually 'player' for calling player, check 'vsh2hooks*.sp'
		// 'target' will assume the 'player' is an entity index
		// while 'vsh2target' will assume the 'player' is a client userid
		"vsh2target"	"player"
		// "target"		"player"

		"amplitude"	 "6.0"
		"frequency"	 "1.0"
		"duration"   "5.0"
		"radius"	 "600.0"
		"sound"		 ""
		"air"		   "true" 
	}
	*/
	
	int calling_player_idx;
	VSH2Player calling_player;
	if (!args.GetTarget(calling_player_idx, calling_player))
		return Plugin_Continue;
	
	int sound_size = args.GetSize("sound");
	char[] sound = new char[sound_size];
	if (sound_size)
		args.Get("sound", sound, sound_size);
	
	float amplitude; args.GetFloat("amplitude", amplitude);
	float frequency; args.GetFloat("frequency", frequency);
	float duration; args.GetFloat("duration", duration);
	float radius; args.GetFloat("radius", radius);
	bool air_shake; args.GetBool("air", air_shake, false);

	float origin[3];
	GetClientAbsOrigin(calling_player_idx, origin);

	ScreenShakeAll(origin, amplitude, frequency, duration, radius, SHAKE_START, sound, air_shake);

	return Plugin_Continue;
}