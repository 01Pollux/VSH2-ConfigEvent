public Action ConfigEvent_GetAimTarget(EventMap args, ConfigEventType_t event_type)
{
	/*
	"<enum>"
	{
		"procedure"  "ConfigEvent_GetAimTarget"

		// depend on 	'event_type', usually 'player' for calling player, check 'vsh2hooks*.sp'
		// 'target' will assume the 'player' is an entity index
		// while 'vsh2target' will assume the 'player' is a client userid
		"vsh2target"	"player"
		//"target"		"player"

		// variable to ouput target
		"name"		  "my_var_name"

		"allowboss"	 	"true"
		"allowminion"   "false"
		"onlyclient"	"true" 
	}
	*/

	int calling_player_idx;
	VSH2Player calling_player;
	if (!args.GetTarget(calling_player_idx, calling_player))
		return Plugin_Continue;

	bool only_clients; args.GetBool("onlyclient", only_clients, false);
	int aim_target = GetClientAimTarget(calling_player_idx, only_clients);
	if (aim_target > 0)
	{
		if (aim_target <= MaxClients)
		{
			VSH2Player target = VSH2Player(aim_target);

			bool allow_boss;
			if (args.GetBool("allowboss", allow_boss, false) && !allow_boss && target.bIsBoss)
				return Plugin_Continue;
			bool allow_minions;
			if (args.GetBool("allowminion", allow_minions, false) && !allow_minions && target.bIsMinion)
				return Plugin_Continue;
		}
		
		int var_name_size = args.GetSize("name");
		char[] var_name = new char[var_name_size];
		args.Get("name", var_name, var_name_size);
		ConfigSys.Params.SetValue(var_name, aim_target);
	}
	return Plugin_Continue;
}