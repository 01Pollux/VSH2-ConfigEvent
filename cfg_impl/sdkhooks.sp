public void OnEntityCreated(int entity, const char[] classname)
{
	if (entity <= 0 || entity > 2048)
		return;

  if (StrContains(classname, "tf_projectile_") == 0)
  {
  	SDKHook(entity, SDKHook_StartTouchPost, OnProjectileTouch);
  }
}

public Action OnProjectileTouch(int projectile, int toucher)
{
	if (VSH2GameMode.GetPropInt(iRoundState) !== StateRunning)	return Plugin_Continue;

	int client = GetEntPropEnt(projectile, Prop_Send, "m_hOwnerEntity");
	if (0 < client <= MaxClients && IsClientInGame(client) && VSH2Player(client).GetPropInt("bIsBoss"))	return Plugin_Continue;

	int weapon = GetEntPropEnt(projectile, Prop_Send, "m_hOriginalLauncher");	//There also similar m_hLauncher
	int slot = TF2_GetSlotFromWeapon(weapon);

	if (slot > -1)
	{
		if (ConfigEvent_ShouldExecuteGlobals(CET_ProjectileTouch))
		{
			ConfigSys.Params.SetValue("toucher", toucher);
			ConfigSys.Params.SetValue("projectile", projectile);
			ConfigEvent_ExecuteGlobals(CET_ProjectileTouch);
		}
		if (ConfigEvent_ShouldExecuteWeapons(CET_ProjectileTouch))
		{
			ConfigSys.Params.SetValue("toucher", toucher);
			ConfigSys.Params.SetValue("projectile", projectile);
			ConfigEvent_ExecuteWeapons(VSH2Player(client), client, CET_ProjectileTouch);
		}
	}
}

	return Plugin_Continue;
}
