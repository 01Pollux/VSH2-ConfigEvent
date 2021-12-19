public Action ConfigEvent_ManageSelfHeal(EventMap args, ConfigEventType_t event_type)
{
	/*
	"<enum>"
	{
		// add or remove health to myself
		"procedure"  "ConfigEvent_ManageSelfHeal"

		// depend on 	'event_type', usually 'player' for calling player, check 'vsh2hooks*.sp'
		// 'target' will assume the 'player' is an entity index
		// while 'vsh2target' will assume the 'player' is a client userid
		"vsh2target"	"player"
		//"target"		"player"

		"health"
		{
			"formula"	"A + B + (B / C) * 100"
			"<enum>"
			{
				"token"	"A"
				"value"	"10"
			}
			"<enum>"
			{
				"token"	"B"
				"value"	"@myHealth"
			}
			"<enum>"
			{
				"token"	"B"
				"value"	"@myMaxHealth"
			}
		}
		// <=0.0 to clamp it to current max health
		"clamp"		 "300"
	}
	*/
	
	int calling_player_idx;
	VSH2Player calling_player;
	if (!args.GetTarget(calling_player_idx, calling_player))
		return Plugin_Continue;

	ConfigMap health_sec = args.GetSection("health");
	if (health_sec)
	{
		int token_size = health_sec.Size - 1;
		char[] tokens = new char[token_size];
		float[] values = new float[token_size];
		int written_tokens;

		for (int i = 0; i < token_size; i++)
		{
			ConfigMap sec = health_sec.GetIntSection(i);
			if (!sec)
				break;
			
			sec.Get("token", tokens[written_tokens], 1);

			int value_size = sec.GetSize("value");
			char[] value_str = new char[value_size];
			sec.Get("value", value_str, value_size);
			if (value_str[0] == '@')
				ConfigSys.Params.GetValue(value_str[1], view_as<float>(values[written_tokens]));
			else values[written_tokens] = StringToFloat(value_str);
			++written_tokens;
		}

		if (written_tokens)
		{
			int health_size = health_sec.GetSize("formula");
			char[] health_str = new char[health_size];
			health_sec.Get("formula", health_str, health_size);

			int new_health = RoundToFloor(ParseFormulaEx(health_str, tokens, values, written_tokens));
			int max_health;
			if (args.GetInt("clamp", max_health) && new_health > max_health)
				new_health = GetEntProp(GetPlayerResourceEntity(), Prop_Send, "m_iMaxHealth", .element = calling_player_idx);

			SetEntProp(calling_player_idx, Prop_Send, "m_iHealth", new_health);
		}
	}
	return Plugin_Continue;
}

public Action ConfigEvent_ManageAreaHeal(EventMap args, ConfigEventType_t event_type)
{
	/*
	"<enum>"
	{
		// add or remove health to myself
		"procedure"  "ConfigEvent_ManageSelfHeal"

		// depend on 	'event_type', usually 'player' for calling player, check 'vsh2hooks*.sp'
		// 'target' will assume the 'player' is an entity index
		// while 'vsh2target' will assume the 'player' is a client userid
		"vsh2target"	"player"
		//"target"		"player"

		// 1 << 0 = target my team
		// 1 << 1 = target other team
		// 1 << 2 = target my minions
		// 1 << 3 = target other minions
		"flags"			"101"		// target my team and my minions only
		
		"distance"		"<800.0"	// less than 800.0 HU
		//"distance"	"800.0"		// less than 800.0 HU
		//"distance"	">800.0"	// more than 800.0 HU
		
		"health"
		{
			"formula"	"A + B + (B / C) * 100"
			"<enum>"
			{
				"token"	"A"
				"value"	"10"
			}
			"<enum>"
			{
				"token"	"B"
				"value"	"@myHealth"
			}
			"<enum>"
			{
				"token"	"B"
				"value"	"@myMaxHealth"
			}
		}
		// <=0.0 to clamp it to current max health
		"clamp"		 "300"
	}
	*/

	int target_flags;
	// check if 'flags' doesnt exists or none of team flags are set
	if (!args.GetInt("flags", target_flags, 2) || !(target_flags & (AREA_COND_MY_TEAM | AREA_COND_OTHER_TEAM)))
		return Plugin_Continue;

	int calling_player_idx;
	VSH2Player calling_player;
	if (!args.GetTarget(calling_player_idx, calling_player))
		return Plugin_Continue;
	
	ConfigMap health_sec = args.GetSection("health");
	if (!health_sec)
		return Plugin_Continue;
	
	int token_size = health_sec.Size - 1;
	char[] tokens = new char[token_size];
	char[][] values_str = new char[token_size][24];
	int written_tokens;

	for (int i = 0; i < token_size; i++)
	{
		ConfigMap sec = health_sec.GetIntSection(i);
		if (!sec)
			break;
		
		sec.Get("token", tokens[written_tokens], 1);
		sec.Get("value", values_str[written_tokens], 24);
		++written_tokens;
	}

	if (!written_tokens)
		return Plugin_Continue;
	
	float[] values = new float[token_size];
	
	int health_size = health_sec.GetSize("formula");
	char[] health_str = new char[health_size];
	health_sec.Get("formula", health_str, health_size);

	char distance_str[32];
	args.Get("distance", distance_str, sizeof(distance_str));
	bool more_than_eq = distance_str[0] == '>';
	float distance = StringToFloat(distance_str[distance_str[0] <= '9' ? 0 : 1]);
	int resource_ent = GetPlayerResourceEntity();

	float player_pos[3], target_pos[3];
	GetClientAbsOrigin(calling_player_idx, player_pos);
	int player_team = GetClientTeam(calling_player_idx);

	int max_health;
	if (!args.GetInt("clamp", max_health))
		max_health = -1;

	for (int i = 1; i <= MaxClients; i++)
	{
		if (!IsClientInGame(i) || !IsPlayerAlive(i) || i == calling_player_idx)
			continue;
		
		if (GetClientTeam(i) == player_team)
		{
			if (!(target_flags & AREA_COND_MY_TEAM))
				continue;
		}
		else if (!(target_flags & AREA_COND_OTHER_TEAM))
			continue;
		
		VSH2Player cur_target = VSH2Player(i);
		if (cur_target.bIsMinion)
		{
			if (cur_target.hOwnerBoss == calling_player)
			{
				if (!(target_flags & AREA_COND_MY_MINIONS))
					continue;
			}
			else if (!(target_flags & AREA_COND_OTHER_MINIONS))
				continue;
		}
		
		GetClientAbsOrigin(i, target_pos);
		if (GetVectorDistance(player_pos, target_pos) > distance)
		{
			if (!more_than_eq)
				continue;
		}

		for (int tok = 0; tok < written_tokens; tok++)
		{
			if (values_str[tok][0] == '@')
				ConfigSys.Params.GetValue(values_str[tok][1], view_as<float>(values[written_tokens]));
			else values[written_tokens] = StringToFloat(values_str[tok]);
		}

		int new_health = RoundToFloor(ParseFormulaEx(health_str, tokens, values, written_tokens));
		if (max_health != -1 && new_health > max_health)
			new_health = GetEntProp(resource_ent, Prop_Send, "m_iMaxHealth", .element = i);
			
		SetEntProp(i, Prop_Send, "m_iHealth", new_health);
	}

	return Plugin_Continue;
}