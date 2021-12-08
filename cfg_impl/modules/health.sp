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

		// h : my current health
		// n : my current damage
		"health"		"%h% + (n / 1000.0) * 30.0 + 15.0"
		// <=0.0 to clamp it to current max health
		"clamp"		 "300"
	}
	*/
	
	int calling_player_idx;
	VSH2Player calling_player;
	if (!args.GetTarget(calling_player_idx, calling_player))
		return Plugin_Continue;

	int health_size = args.GetSize("health");
	char[] health_str = new char[health_size];
	args.Get("health", health_str, health_size);

	int my_health = GetEntProp(calling_player_idx, Prop_Send, "m_iHealth");
	char hp_tmp[8]; IntToString(my_health, hp_tmp, sizeof(hp_tmp));
	ReplaceString(health_str, health_size, "%h%", hp_tmp);

	int new_health = RoundToNearest(ParseFormula(health_str, calling_player.GetPropInt("iDamage")));
	int max_health;
	if (!args.GetInt("clamp", max_health) || max_health <= 0)
		max_health = GetEntProp(GetPlayerResourceEntity(), Prop_Send, "m_iMaxHealth", .element = calling_player_idx);

	if (new_health > max_health)
		new_health = max_health;

	SetEntProp(calling_player_idx, Prop_Send, "m_iHealth", new_health);
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

		// h : my current health
		// n : my current damage
		"health"		"%h% + (n / 1000.0) * 30.0 + 15.0"
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

	char distance_str[32];
	args.Get("distance", distance_str, sizeof(distance_str));
	bool more_than_eq = distance_str[0] == '>';
	float distance = StringToFloat(distance_str[distance_str[0] <= '9' ? 0 : 1]);
	int resource_ent = GetPlayerResourceEntity();

	float player_pos[3], target_pos[3];
	GetClientAbsOrigin(calling_player_idx, player_pos);
	int player_team = GetClientTeam(calling_player_idx);

	int health_size = args.GetSize("health");
	char[] health_str = new char[health_size];
	char[] copy_health_str = new char[health_size];
	args.Get("health", health_str, health_size);

	int max_health;
	if (!args.GetInt("clamp", max_health))
		max_health = -1;
	char hp_tmp[8];

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


		int cur_health = GetEntProp(i, Prop_Send, "m_iHealth");
		IntToString(cur_health, hp_tmp, sizeof(hp_tmp));
		FormatEx(copy_health_str, health_size, health_str);
		ReplaceString(copy_health_str, health_size, "%h%", hp_tmp);

		int copy_max_health = max_health;
		if (copy_max_health == -1)
			copy_max_health = GetEntProp(resource_ent, Prop_Send, "m_iMaxHealth", .element = i);
		
		int new_health = RoundToNearest(ParseFormula(copy_health_str, cur_target.GetPropInt("iDamage")));
		if (new_health > copy_max_health)
			new_health = copy_max_health;
			
		SetEntProp(i, Prop_Send, "m_iHealth", new_health);
	}

	return Plugin_Continue;
}