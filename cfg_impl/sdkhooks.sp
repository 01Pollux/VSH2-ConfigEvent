public void OnEntityCreated(int entity, const char[] classname)
{
	if (entity <= 0 || entity > 2048)
		return;

	if (StrContains(classname, "tf_projectile_") == 0)
	{
		SDKHook(entity, SDKHook_StartTouchPost, OnProjectileTouch);
	}
}

/**
 * Keys:
 * [in] "projectile": projectile entity index
 * [in] "toucher": toucher entity index actually idk where to use it
 * [in] "player" projectile owner vsh2player instance
 */
public Action OnProjectileTouch(int projectile, int toucher)
{
	if (VSH2GameMode.GetPropInt("iRoundState") != StateRunning)	return Plugin_Continue;

	int client = GetEntPropEnt(projectile, Prop_Send, "m_hOwnerEntity");
	if (client < 0 && client > MaxClients && !IsClientInGame(client))	return Plugin_Continue;

	VSH2Player vsh2client = VSH2Player(client);
	if (vsh2client.GetPropInt("bIsBoss"))
		return Plugin_Continue;

	int weapon = GetEntPropEnt(projectile, Prop_Send, "m_hOriginalLauncher");	//There also similar m_hLauncher
	int slot = GetSlotFromWeapon(client, weapon);

	if (slot > -1)
	{
		if (ConfigEvent_ShouldExecuteGlobals(CET_ProjectileTouch))
		{
			ConfigSys.Params.SetValue("toucher", toucher);
			ConfigSys.Params.SetValue("projectile", projectile);
			ConfigSys.Params.SetValue("player", vsh2client);
			ConfigEvent_ExecuteGlobals(CET_ProjectileTouch);
		}
		if (ConfigEvent_ShouldExecuteWeapons(CET_ProjectileTouch))
		{
			ConfigSys.Params.SetValue("toucher", toucher);
			ConfigSys.Params.SetValue("projectile", projectile);
			ConfigSys.Params.SetValue("player", vsh2client);
			ConfigEvent_ExecuteWeapons(vsh2client, client, CET_ProjectileTouch);
		}
	}

	return Plugin_Continue;
}
