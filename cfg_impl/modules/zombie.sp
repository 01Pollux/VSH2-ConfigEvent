public Action ConfigEvent_SummonZombie(EventMap args, ConfigEventType_t event_type)
{
	/*
	"<enum>"
	{
		"procedure"	 "ConfigEvent_SummonZombie"

		"minion can execute"	"false"	// allow mininos to execute weapons

		"vsh2target"	 "player"
		"max players"	 "3"

		"vampire"		 "10.0"	// steal 1/10 of victim's health on attack
		"weak"			 "3.0"	// reduce  damage by 1/3

		"slay"			"true"  // slay when the owner dies
		"no boss"		"true"  // dont summon as minion if the player was previously a boss

		"delay"			"0.1"	// spawn minion after 'delay' seconds
		"spawn"		 "false" // true to teleport directly to spawn

		"climb"
		{
			"enable"	"true"
			"velocity"  "400.0"
		}

		"conditions"
		{
			"<enum>"
			{
				"id"	"Xx"
				"value" "1.0"
			}
		}

		"info"
		{
			"<enum>"
			{
				"class"	 "soldier"
				"health"	"450.0"
				"model"	 "models/freak_fortress_2/seeman/seeldier_v0.mdl"

				"text"  "You are now %N's minion! Attack the other team."

				"classname"  "tf_weapon_bottle"
				"attributes" "68 ; -1"
				"index"	  "191"
				"ammo"		"-9"
				"clip"		"-9"

				"particle"	""
				"offset"	"0.0"
			}
		}
	}
	*/

	int calling_player_idx;
	VSH2Player calling_player;
	if (!args.GetTarget(calling_player_idx, calling_player))
		return Plugin_Continue;

	bool no_boss; args.GetBool("no boss", no_boss, false);
	ArrayList players_list = new ArrayList();

	for (int i = 1; i <= MaxClients; i++)
	{
		if (!IsClientInGame(i) || i == calling_player_idx || IsPlayerAlive(i))
			continue;
		VSH2Player player = VSH2Player(i);
		if (no_boss && player.bIsBoss)
			continue;
		players_list.Push(player);
	}

	if (!players_list.Length)
	{
		delete players_list;
		return Plugin_Continue;
	}

	int max_players; args.GetInt("max players", max_players);
	int player_list_size = players_list.Length;
	if (player_list_size >= max_players)
	{
		player_list_size = max_players;
		players_list.Sort(Sort_Random, Sort_Integer);
	}

	ConfigMap info_section = args.GetSection("info");
	float spawn_time; args.GetFloat("delay", spawn_time);
	int info_section_size = info_section.Size - 1;

	bool slay; args.GetBool("slay", slay, false);

	for (int i = 0; i < player_list_size; i++)
	{
		ConfigMap section = info_section.GetIntSection(GetRandomInt(0, info_section_size));
		VSH2Player player = players_list.Get(i);

		player.SetPropAny("_cfgsys_slay_on_ownerdeath", slay);
		player.SetPropAny("_cfgsys_minion_infosection", section);
		player.SetPropAny("_cfgsys_minion_section", args);

		player.hOwnerBoss = calling_player;
		player.SetPropAny("bIsZombie", true);
		player.ConvertToMinion(spawn_time);
	}

	return Plugin_Continue;
}

void ConfigEvent_Zombie_Init(VSH2Player minion, VSH2Player vsh2_owner)
{
	if (!minion.GetPropAny("bIsZombie"))
		return;

	ConfigMap infosection = view_as<ConfigMap>(minion.GetPropAny("_cfgsys_minion_infosection"));
	ConfigMap section = view_as<ConfigMap>(minion.GetPropAny("_cfgsys_minion_section"));

	char classname[64], buffer_g[PLATFORM_MAX_PATH];
	int health = 250;

	if (infosection.Get("health", buffer_g, sizeof(buffer_g)))
		health = RoundToNearest(ParseFormula(buffer_g, VSH2GameMode_GetTotalRedPlayers()));

	int client = minion.index;
	int owner_index = vsh2_owner.index;
	{
		char buffer[16];
		infosection.Get("class", buffer, sizeof(buffer));
		TFClassType class = TF2_GetClass(buffer);

		/* SetEntProp(client, Prop_Send, "m_lifeState", 2);
		ChangeClientTeam(client, GetClientTeam(owner_index));
		SetEntProp(client, Prop_Send, "m_lifeState", 0); */
		TFTeam team = view_as<TFTeam>(GetClientTeam(owner_index));
		AssignTeam(client, team, 1);

		//PrintToServer("Respawn player %N", client);

		//TF2_RespawnPlayer(client); //Already respawn the player in AssignTeam
		TF2_SetPlayerClass(client, class, .persistent = false);
		//PrintToServer("Changing %N's class to %s / %i", client, buffer, class);
	}

	TF2_RemoveAllWeapons(client);
	if (VSH2GameMode.GetPropInt("bTF2Attribs"))
		TF2Attrib_RemoveAll(client);

	if (infosection.Get("classname", classname, sizeof(classname)))
	{
		infosection.Get("attributes", buffer_g, sizeof(buffer_g));
		int index; infosection.GetInt("index", index);
		int weapon = minion.SpawnWeapon(
			classname,
			index,
			100,
			5,
			buffer_g /* attributes */
		);

		if (IsValidEntity(weapon))
		{
			SetEntPropEnt(client, Prop_Send, "m_hActiveWeapon", weapon);
			SetEntProp(weapon, Prop_Send, "m_iWorldModelIndex", -1);

			/// PDA, normal sapper
			if (StrEqual(classname, "tf_weapon_builder") && index != 735 )
			{
				for (int i = 0; i < 4; i++)
					SetEntProp(weapon, Prop_Send, "m_aBuildableObjectTypes", 0, .element = i);
			}
			/// Sappers, normal sapper
			else if (StrEqual(classname, "tf_weapon_sapper") || index == 735)
			{
				SetEntProp(weapon, Prop_Send, "m_iObjectType", 3);
				SetEntProp(weapon, Prop_Data, "m_iSubType", 3);
				for (int i = 0; i < 4; i++)
					SetEntProp(weapon, Prop_Send, "m_aBuildableObjectTypes", 0, .element = i);
			}

			int ammo; infosection.GetInt("ammo", ammo);
			int clip; infosection.GetInt("clip", clip);

			if (ammo >= 0 || clip >= 0)
			{
				if (clip > -1)
					SetEntProp(weapon, Prop_Data, "m_iClip1", clip);

				int ammo_type = (ammo>-1 ? GetEntProp(weapon, Prop_Send, "m_iPrimaryAmmoType") : -1);
				if (ammo_type != -1)
					SetEntProp(client, Prop_Data, "m_iAmmo", ammo, _, ammo_type);
			}
		}
	}

	SetEntProp(client, Prop_Data, "m_iMaxHealth", health);
	SetEntityHealth(client, health);

	bool tele_to_spawn;
	if (!section.GetBool("spawn", tele_to_spawn, false) || !tele_to_spawn)
	{
		float position[3], velocity[3];
		GetEntPropVector(owner_index, Prop_Data, "m_vecOrigin", position);

		velocity[0] = GetRandomFloat(300.0, 500.0) * (GetRandomInt(0, 1) ? 1:-1);
		velocity[1] = GetRandomFloat(300.0, 500.0) * (GetRandomInt(0, 1) ? 1:-1);
		velocity[2] = GetRandomFloat(300.0, 500.0);

		TeleportEntity(client, position, NULL_VECTOR, velocity);
		TF2_AddCondition(client, TFCond_Ubercharged, 2.0);
	}

	char model[PLATFORM_MAX_PATH];
	if (!infosection)	LogToFileEx("logs/zombie_model.txt", "Invalid Info section");
	if (!infosection.Get("model", model, sizeof(model)) || !model[0])	LogToFileEx("logs/zombie_model.txt", "Invalid Model");
	//infosection.Get("model", model, sizeof(model));

	if (model[0])
	{
		SetVariantString(model);
		AcceptEntityInput(client, "SetCustomModel");
		SetEntProp(client, Prop_Send, "m_bUseClassAnimations", 1);
	}

	if (infosection.Get("text", model, sizeof(model)))
		PrintHintText(client, model, owner_index);

	if (infosection.Get("particle", model, sizeof(model)))
	{
		float offset; infosection.GetFloat("offset", offset);
		AttachParticle(client, model, offset);
	}
}

void ConfigEvent_Zombie_Think(VSH2Player minion, int minion_index)
{
	if (!minion.GetPropAny("bIsZombie"))
		return;
	if (minion.GetPropAny("_cfgsys_slay_on_ownerdeath"))
	{
		VSH2Player owner_boss = minion.hOwnerBoss;
		if (IsClientInGame(owner_boss.index) && 0 < owner_boss.index <= MaxClients)
		{
			if (!IsPlayerAlive(owner_boss.index))
				ForcePlayerSuicide(minion_index);
		}
	}
}

stock void AssignTeam(int client, TFTeam team, int desiredclass=0)
{
	if(!GetEntProp(client, Prop_Send, "m_iDesiredPlayerClass")) // Initial living spectator check. A value of 0 means that no class is selected
	{
		LogError("Zombie: INVALID DESIRED CLASS FOR %N!", client);
		SetEntProp(client, Prop_Send, "m_iDesiredPlayerClass", !desiredclass ? 1 : desiredclass); // So we assign one to prevent living spectators
	}
	SetEntProp(client, Prop_Send, "m_lifeState", 2);
	TF2_ChangeClientTeam(client, team);
	// SetEntProp(client, Prop_Send, "m_lifeState", 0); // Is this even needed? According to naydef, this is the other cause of living spectators.
	TF2_RespawnPlayer(client);

	if(GetEntProp(client, Prop_Send, "m_iObserverMode") && IsPlayerAlive(client)) // If the initial checks fail, use brute-force.
	{
		LogError("Zombie: %N IS A LIVING SPECTATOR!", client);
		TF2_SetPlayerClass(client, view_as<TFClassType>((!desiredclass ? 1 : desiredclass)), _, true);
		TF2_RespawnPlayer(client);
	}
}
