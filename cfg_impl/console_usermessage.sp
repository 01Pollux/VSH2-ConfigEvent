/** when engi run the euraka effect command
 * Keys:
 * [in] "player": player userid/vsh2player instance
 * return any value other than Plugin_Continue to stop the command being processed
 */
public Action Console_EurakaTeleportCommand(int client, const char[] command, int args)
{
	VSH2Player vsh2client = VSH2Player(client);
	if (vsh2client.bIsBoss || VSH2GameMode.GetPropInt("iRoundState") != StateRunning)
		return Plugin_Continue;

	if (ConfigEvent_ShouldExecuteGlobals(CET_EurakaTeleportCmd))
	{
		ConfigSys.Params.SetValue("player", vsh2client);
		ConfigSys.Params.SetValue("to_tele", args == 1);
		switch (ConfigEvent_ExecuteGlobals(CET_EurakaTeleportCmd))
		{
			case Plugin_Continue: { }
			default: return Plugin_Handled;
		}
	}
	if (ConfigEvent_ShouldExecuteWeapons(CET_EurakaTeleportCmd))
	{
		ConfigSys.Params.SetValue("player", vsh2client);
		ConfigSys.Params.SetValue("to_tele", args == 1);
		switch (ConfigEvent_ExecuteWeapons(vsh2client, client, CET_EurakaTeleportCmd))
		{
			case Plugin_Continue: { }
			default: return Plugin_Handled;
		}
	}

	return Plugin_Continue;
}

/**
 * Call when engineer successfully teleport
 * Keys:
 * [in] player: engineer userid/vsh2player instance
 */
public Action OnTeleportHomeMessage(UserMsg msg_id, BfRead msg, const int[] players, int playersNum, bool reliable, bool init)
{
	int client = players[0];
	VSH2Player vsh2client = VSH2Player(client);
	if (vsh2client.bIsBoss || VSH2GameMode.GetPropInt("iRoundState") != StateRunning)
		return Plugin_Continue;

	if (ConfigEvent_ShouldExecuteGlobals(CET_EurakaTeleportFin))
	{
		ConfigSys.Params.SetValue("player", vsh2client);
		ConfigEvent_ExecuteGlobals(CET_EurakaTeleportFin);
	}
	if (ConfigEvent_ShouldExecuteWeapons(CET_EurakaTeleportFin))
	{
		ConfigSys.Params.SetValue("player", vsh2client);
		ConfigEvent_ExecuteWeapons(vsh2client, client, CET_EurakaTeleportFin);
	}

	return Plugin_Continue;
}
