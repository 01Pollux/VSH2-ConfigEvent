public Action Console_EurakaTeleportCommand(int client, const char[] command, int args)
{
  if (!IsValidClient(client) && VSH2Player(client).GetPropAny(bIsBoss) && VSH2GameMode.GetPropInt("iRoundState") != StateRunning)
    return Plugin_Continue;

  OnEurakaTeleport(client);
  CreateTimer(3.9, OnEurakaTeleported, client);

  return Plugin_Continue;
}

/**
 * Keys:
 * [in] "player": player userid/vsh2player instance
 */
void OnEurakaTeleport(int client)
{
  VSH2Player vsh2client = VSH2Player(client);
  if (ConfigEvent_ShouldExecuteGlobals(CET_EurakaTeleport))
	{
		ConfigSys.Params.SetValue("player", vsh2client);
		ConfigEvent_ExecuteGlobals(CET_EurakaTeleport);
	}
	if (ConfigEvent_ShouldExecuteWeapons(CET_EurakaTeleport))
	{
		ConfigSys.Params.SetValue("player", vsh2client);
		ConfigEvent_ExecuteWeapons(vsh2client, client, CET_EurakaTeleport);
	}
}

/**
 * Keys:
 * [in] "player": player userid/vsh2player instance
 */
Action OnEurakaTeleported(int client)
{
  if (!IsValidClient(client) && IsPlayerAlive(client))
  {
    VSH2Player vsh2client = VSH2Player(client);
    if (ConfigEvent_ShouldExecuteGlobals(CET_EurakaTeleported))
  	{
  		ConfigSys.Params.SetValue("player", vsh2client);
  		ConfigEvent_ExecuteGlobals(CET_EurakaTeleported);
  	}
  	if (ConfigEvent_ShouldExecuteWeapons(CET_EurakaTeleported))
  	{
  		ConfigSys.Params.SetValue("player", vsh2client);
  		ConfigEvent_ExecuteWeapons(vsh2client, client, CET_EurakaTeleported);
  	}
  }
}
