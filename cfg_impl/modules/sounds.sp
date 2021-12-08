enum ConfigEvent_EmitType_t
{
	ET_Myself,
	ET_Group,
	ET_All
}

enum ConfigEvent_EmitSoundType_t
{
	EST_Generic,
	EST_Game,
	EST_Stop,
	EST_Ambient,
	EST_GameAmbient
}

enum struct ConfigEvent_EmitSoundInfo_t
{
	int Channel;
	int Level;
	int Flags;
	float Volume;
	int Pitch;
	float Time;
	float Origin[3];
	bool Follow;
}

public Action ConfigEvent_EmitSound(EventMap args, ConfigEventType_t event_type)
{
	/*
	"<enum>"
	{
		// emit sound
		"procedure"  "ConfigEvent_EmitSound"

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

		"sound"		   "..."   // path or name depending on 'type'

		"channel"		""  // SNDCHAN_VOICE = 2
		"level"			""  // SNDLEVEL_TRAFFIC = 75
		"volume"		""  // SNDVOL_NORMAL = 1.0
		"pitch"			""  // SND_CHANGEPITCH = 2 = '10'
		"origin"		""  // false, use NULL_VECTOR
		"follow"		""  // true
		"time"			"0.0"  // either delay for ambient sounds or duration for game sounds

		"filter"		 "myself"	// only emit to myself 'EmitSoundToClient'
		//"filter"		 "group"	// only emit to group of people based on distance 'EmitSound'
		//"filter"		 "all"	// emit to everyone 'EmitSoundToAll'

		"type"			  "none"
		//"type"			"game"
		//"type"			"stop"
		//"type"			"ambient"
		//"type"			"game_ambient"
	}
	*/
	
	int calling_player_idx;
	VSH2Player calling_player;
	if (!args.GetTarget(calling_player_idx, calling_player))
		return Plugin_Continue;

	int sound_size = args.GetSize("sound");
	char[] sound = new char[sound_size];
	args.Get("sound", sound, sound_size);

	ConfigEvent_EmitSoundInfo_t info;
	GetEmitSoundInfo(args, calling_player_idx, info);
	ConfigEvent_EmitType_t filter = GetEmitType(args);

	switch (GetEmitSoundType(args))
	{
		case EST_Generic:
		{
			switch(filter)
			{
				case ET_Myself:
				{
					int clients[1];
					clients[0] = calling_player_idx;

					EmitSound(
						clients,
						1,
						sound,
						calling_player_idx,
						info.Channel,
						info.Level,
						info.Flags,
						info.Volume,
						info.Pitch,
						calling_player_idx,
						info.Origin,
						.updatePos = info.Follow
					);
				}

				case ET_Group:
				{
					int[] clients = new int[MaxClients + 1];
					int player_count = CollectPlayersInRange(args, calling_player, calling_player_idx, clients);

					EmitSound(
						clients,
						player_count,
						sound,
						calling_player_idx,
						info.Channel,
						info.Level,
						info.Flags,
						info.Volume,
						info.Pitch,
						calling_player_idx,
						info.Origin,
						.updatePos = info.Follow
					);
				}

				case ET_All:
				{
					EmitSoundToAll(
						sound,
						calling_player_idx,
						info.Channel,
						info.Level,
						info.Flags,
						info.Volume,
						info.Pitch,
						calling_player_idx,
						info.Origin,
						.updatePos = info.Follow
					);
				}
			}
		}

		case EST_Game:
		{
			switch(filter)
			{
				case ET_Myself:
				{
					int clients[1];
					clients[0] = calling_player_idx;

					EmitGameSound(
						clients,
						1,
						sound,
						calling_player_idx,
						info.Flags,
						-1,
						info.Origin,
						.updatePos = info.Follow,
						.soundtime = info.Time
					);
				}

				case ET_Group:
				{
					int[] clients = new int[MaxClients + 1];
					int player_count = CollectPlayersInRange(args, calling_player, calling_player_idx, clients);

					EmitGameSound(
						clients,
						player_count,
						sound,
						calling_player_idx,
						info.Flags,
						-1,
						info.Origin,
						.updatePos = info.Follow,
						.soundtime = info.Time
					);
				}

				case ET_All:
				{
					EmitGameSoundToAll(
						sound,
						calling_player_idx,
						info.Flags,
						-1,
						info.Origin,
						.updatePos = info.Follow,
						.soundtime = info.Time
					);
				}
			}
		}
		
		case EST_Stop:
		{
			StopSound(
				calling_player_idx,
				info.Channel,
				sound
			);
		}
		
		case EST_Ambient:
		{
			EmitAmbientSound(
				sound,
				info.Origin,
				calling_player_idx,
				info.Level,
				info.Flags,
				info.Volume,
				info.Pitch,
				info.Time
			);
		}
		
		case EST_GameAmbient:
		{
			EmitAmbientGameSound(
				sound,
				info.Origin,
				calling_player_idx,
				info.Flags,
				info.Time
			);
		}
	}
	return Plugin_Continue;
}

static ConfigEvent_EmitType_t GetEmitType(EventMap args)
{
	static const char types[][] = {
		"myself",
		"group",
		"all"
	};

	char type[8]; args.Get("filter", type, sizeof(type));
	for(int i = 0; i < sizeof(types); i++)
	{
		if (!strcmp(type, types[i]))
			return view_as<ConfigEvent_EmitType_t>(i);
	}
	return ET_All;
}

static ConfigEvent_EmitSoundType_t GetEmitSoundType(EventMap args)
{
	static const char types[][] = {
		"generic",
		"game",
		"stop",
		"ambient",
		"game_ambient"
	};

	char type[8]; args.Get("filter", type, sizeof(type));
	for(int i = 0; i < sizeof(types); i++)
	{
		if (!strcmp(type, types[i]))
			return view_as<ConfigEvent_EmitSoundType_t>(i);
	}
	return EST_Generic;
}

static void GetEmitSoundInfo(EventMap args, int client, ConfigEvent_EmitSoundInfo_t info)
{
	if (!args.GetInt("channel", info.Channel))
		info.Channel = SNDCHAN_VOICE;
	if (!args.GetInt("level", info.Level))
		info.Level = SNDLEVEL_TRAFFIC;
	if (!args.GetFloat("volume", info.Volume))
		info.Volume = SNDVOL_NORMAL;
	if (!args.GetInt("pitch", info.Pitch, 2))
		info.Pitch = SND_CHANGEPITCH;
	bool tmp;
	if (args.GetBool("origin", tmp, false) && tmp)
		GetClientAbsOrigin(client, info.Origin);
	else info.Origin = NULL_VECTOR;
	if (!args.GetInt("follow", info.Follow))
		info.Follow = true;
	if (!args.GetFloat("time", info.Time))
		info.Time = SNDVOL_NORMAL;
}

static int CollectPlayersInRange(EventMap args, VSH2Player player, int client, int[] clients)
{
	int target_flags;
	// check if 'flags' doesnt exists or none of team flags are set
	if (!args.GetInt("flags", target_flags, 2) || !(target_flags & (AREA_COND_MY_TEAM | AREA_COND_OTHER_TEAM)))
		return 0;
	
	char distance_str[32];
	args.Get("distance", distance_str, sizeof(distance_str));
	bool more_than_eq = distance_str[0] == '>';
	float distance = StringToFloat(distance_str[distance_str[0] <= '9' ? 0 : 1]);
	
	float player_pos[3], target_pos[3];
	GetClientAbsOrigin(client, player_pos);
	int player_team = GetClientTeam(client);

	clients[0] = client;
	int players = 1;
	for (int i = 1; i <= MaxClients; i++)
	{
		if (!IsClientInGame(i) || !IsPlayerAlive(i) || i == client)
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
			if (cur_target.hOwnerBoss == player)
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

		clients[players++] = i;
	}
	return players;
}