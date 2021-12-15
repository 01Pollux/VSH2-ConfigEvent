#define MAX_BUTTONS 					26
int g_iPlayerLastButtons[MAXPLAYERS+1];

public Action OnPlayerRunCmd(int client,int &buttons,int &impulse, float vel[3], float angles[3],int &weapon,int &subtype,int &cmdnum,int &tickcount,int &seed,int mouse[2])
{
	if (VSH2GameMode.GetPropInt(iRoundState) == StateRunning) return Plugin_Continue;
	if (client <= 0 || client > MaxClients || !IsClientInGame(client)) return Plugin_Continue;

	g_iPlayerLastButtons[client] = buttons;
  VSH2Player player = VSH2Player(client);
	ConfigEvent_OnButton(player, buttons);

	if (g_iPlayerLastButtons[client] != buttons)
		return Plugin_Changed;

	return Plugin_Continue;
}

/*
* Keys:
* [in] "player": player userid/vsh2player instance
* [in] "button": button that player use
*/

void ConfigEvent_OnButton(const VSH2Player player, int &buttons)
{
	ConfigEvent_AirBlast_Button(player, buttons);
	if (ConfigEvent_ShouldExecuteGlobals(CET_PlayerButton))
	{
		ConfigSys.Params.SetValue("player", player);
		ConfigSys.Params.SetValue("buttons", buttons);
		ConfigEvent_ExecuteGlobals(CET_PlayerButton);
	}
	if (ConfigEvent_ShouldExecuteWeapons(CET_PlayerButton))
	{
		ConfigSys.Params.SetValue("player", player);
		ConfigSys.Params.SetValue("buttons", buttons);
		ConfigEvent_ExecuteWeapons(player, player.index, CET_PlayerButton);
	}
}
