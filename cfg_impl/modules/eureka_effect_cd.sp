static bool bIsEurekaEffectCD[MAXPLAYERS+1];

public Action ConfigEvent_BlockCommand(EventMap args, ConfigEventType_t event_type)
{
	int calling_player_idx;
	VSH2Player calling_player;
	if (!args.GetTarget(calling_player_idx, calling_player))
		return Plugin_Continue;

	return bIsEurekaEffectCD[calling_player_idx] ? Plugin_Handled /* block the 'eukura_teleport' from being processed */: Plugin_Continue;
}

public Action ConfigEvent_StartCoolDown(EventMap args, ConfigEventType_t event_type)
{
	int calling_player_idx;
	VSH2Player calling_player;
	if (!args.GetTarget(calling_player_idx, calling_player))
		return Plugin_Continue;

	if (bIsEurekaEffectCD[calling_player_idx])	//already in cooldown
		return Plugin_Continue;

	float cooldown; args.GetFloat("cooldown", cooldown);
	CreateTimer(cooldown, FinishCooldown, calling_player);
	bIsEurekaEffectCD[calling_player_idx] = true;
	return Plugin_Continue;
}

Action FinishCooldown(Handle timer, VSH2Player vsh2player)
{
	int calling_player_idx = vsh2player.index;
	if (calling_player_idx)
		bIsEurekaEffectCD[calling_player_idx] = false;
	return Plugin_Continue;
}
