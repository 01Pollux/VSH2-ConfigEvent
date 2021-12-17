/** when engi run the euraka effect command
 * Keys:
 * [in] "player": player userid/vsh2player instance
 * return Plugin_Handled to stop the command being processed
 */
public Action Console_EurakaTeleportCommand(int client, const char[] command, int args)
{
  if (!IsValidClient(client) && VSH2Player(client).GetPropAny(bIsBoss) && VSH2GameMode.GetPropInt("iRoundState") != StateRunning)
    return Plugin_Continue;

  VSH2Player vsh2client = VSH2Player(client);

  //Need help about make event type CET_EurakaTeleportCmd. Need to return Plugin_Handled.
}

/*
  * Call when engineer successfully teleport
  * Keys:
  * [in] player: engineer userid/vsh2player instance
*/
public Action OnTeleportHomeMessage(UserMsg msg_id, Handle tele, const int[] players, playersNum, bool reliable, bool init)
{
  //when engi successfully teleport. maybe should use a void. return Plugin_Handled might block the message but that's useless since the engi has already been teleported
  VSH2Player vsh2client = VSH2Player(players);
  if (ConfigEvent_ShouldExecuteGlobals(CET_EurakaTeleportFin))
	{
		ConfigSys.Params.SetValue("player", vsh2client);
		ConfigEvent_ExecuteGlobals(CET_EurakaTeleportFin);
	}
	if (ConfigEvent_ShouldExecuteWeapons(CET_EurakaTeleportFin))
	{
		ConfigSys.Params.SetValue("player", vsh2client);
		ConfigEvent_ExecuteWeapons(vsh2client, players, CET_EurakaTeleportFin);
	}
}
