public Action ConfigEvent_ManageSelfTFCond(EventMap args, ConfigEventType_t event_type)
{
	/*
	"<enum>"
	{
		// add or remove TFCond to myself
		"procedure"  "ConfigEvent_ManageSelfTFCond"

		// depend on 	'event_type', usually 'player' for calling player, check 'vsh2hooks*.sp'
		// 'target' will assume the 'player' is an entity index
		// while 'vsh2target' will assume the 'player' is a client userid
		"vsh2target"	"player"
		//"target"		"player"

		"add"			"true"

		"conditions"
		{
			"<enum>"
			{
				"id"		"3"
				"duration"  "2.0"
			}
			"<enum>"
			{
				"id"			"3"
				// similar to   "2.0 + (n / 1000.0) * 30.0"
				"damage_add"	"(n / 1000.0) * 30.0" // where n is the client's damage
				"duration"		"2.0"
			}
		}
	}
	*/

	int calling_player_idx;
	VSH2Player calling_player;
	if (!args.GetTarget(calling_player_idx, calling_player))
		return Plugin_Continue;

	ConfigMap conditions = args.GetSection("conditions");
	char extra_add[32];

	bool add_cond; args.GetBool("add", add_cond, false);

	for (int i = conditions.Size - 1; i >= 0; i--)
	{
		ConfigMap cond = conditions.GetIntSection(i);
		TFCond id; cond.GetInt("id", view_as<int>(id));

		if (add_cond)
		{
			float duration; cond.GetFloat("duration", duration);
			if (cond.Get("damage_add", extra_add, sizeof(extra_add)))
				duration += ParseFormula(extra_add, calling_player.GetPropInt("iDamage"));
			TF2_AddCondition(calling_player_idx, id, duration);
		}
		else
		{
			TF2_RemoveCondition(calling_player_idx, id);
		}
	}
	return Plugin_Continue;
}

public Action ConfigEvent_ManageAreaTFCond(EventMap args, ConfigEventType_t event_type)
{
	/*
	"<enum>"
	{
		// add or remove TFCond to a range of people
		"procedure"  "ConfigEvent_ManageAreaTFCond"

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

		"conditions"
		{
			"<enum>"
			{
				"id"		"3"
				"duration"  "2.0"
			}
			"<enum>"
			{
				"id"			"3"
				// similar to   "2.0 + (n / 1000.0) * 30.0"
				"damage_add"	"(n / 1000.0) * 30.0" // where n is the client's damage
				"duration"		"2.0"
			}
		}
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

	ConfigMap conditions = args.GetSection("conditions");
	int conds_size = conditions.Size;
	bool add_cond; args.GetBool("add", add_cond, false);

	// Grab the conditions and their durations
	TFCond[] conds = new TFCond[conds_size];
	float[] durations = new float[conds_size];
	for (int i = 0; i < conds_size; i++)
	{
		ConfigMap cond = conditions.GetIntSection(i);
		if (!cond)
		{
			conds_size = i;
			break;
		}
		cond.GetInt("id", view_as<int>(conds[i]));
		if (!add_cond)
			continue;

		cond.GetFloat("duration", durations[i]);
		if (cond.Get("damage_add", distance_str, sizeof(distance_str)))
			durations[i] += ParseFormula(distance_str, calling_player.GetPropInt("iDamage"));
	}

	float player_pos[3], target_pos[3];
	GetClientAbsOrigin(calling_player_idx, player_pos);
	int player_team = GetClientTeam(calling_player_idx);

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

		for (int cond_idx = 0; cond_idx < conds_size; cond_idx++)
		{
			if (add_cond)
				TF2_AddCondition(i, conds[cond_idx], durations[cond_idx]);
			else
				TF2_RemoveCondition(i, conds[cond_idx]);
		}
	}

	return Plugin_Continue;
}

public Action ConfigEvent_ManagePatientTFCond(EventMap args, ConfigEventType_t event_type)
{
	/*
	"<enum>"
	{
		// add or remove TFCond to patient (medic only)
		"procedure"  "ConfigEvent_ManagePatientTFCond"

		// depend on 	'event_type', usually 'player' for calling player, check 'vsh2hooks*.sp'
		// 'target' will assume the 'player' is an entity index
		// while 'vsh2target' will assume the 'player' is a client userid
		"vsh2target"	"player"
		//"target"		"player"

		"add"			"true"

		"conditions"
		{
			"<enum>"
			{
				"id"		"3"
				"duration"  "2.0"
			}
			"<enum>"
			{
				"id"			"3"
				// similar to   "2.0 + (n / 1000.0) * 30.0"
				"damage_add"	"(n / 1000.0) * 30.0" // where n is the client's damage
				"duration"		"2.0"
			}
		}
	}
	*/

	int calling_player_idx;
	VSH2Player calling_player;
	if (!args.GetTarget(calling_player_idx, calling_player))
		return Plugin_Continue;

	int patient = GetHealingTarget(calling_player_idx);
	if (patient == -1 || patient > MaxClients || !IsClientInGame(patient))
		return Plugin_Continue;

	ConfigMap conditions = args.GetSection("conditions");
	char extra_add[32];

	bool add_cond; args.GetBool("add", add_cond, false);

	for (int i = conditions.Size - 1; i >= 0; i--)
	{
		ConfigMap cond = conditions.GetIntSection(i);
		TFCond id; cond.GetInt("id", view_as<int>(id));

		if (add_cond)
		{
			float duration; cond.GetFloat("duration", duration);
			if (cond.Get("damage_add", extra_add, sizeof(extra_add)))
				duration += ParseFormula(extra_add, VSH2Player(patient).GetPropInt("iDamage"));
			TF2_AddCondition(patient, id, duration);
		}
		else
		{
			TF2_RemoveCondition(patient, id);
		}
	}
	return Plugin_Continue;
}
