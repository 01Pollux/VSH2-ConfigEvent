static bool bIsEukuraEffectCD[MAXPLAYERS+1];

public Action ConfigEvent_BlockCommand(EventMap args, ConfigEventType_t event_type)
{
  int calling_player_idx;
	VSH2Player calling_player;
	if (!args.GetTarget(calling_player_idx, calling_player))
		return Plugin_Continue;

  if (bIsEukuraEffectCD[calling_player_idx])  //in cooldown
  {
    return Plugin_Handled;  //block the 'eukura_teleport' from being processed
  }
  return Plugin_Continue;
}

public Action ConfigEvent_StartCoolDown(EventMap args, ConfigEventType_t event_type)
{
  int calling_player_idx;
	VSH2Player calling_player;
	if (!args.GetTarget(calling_player_idx, calling_player))
		return Plugin_Continue;

  if (bIsEukuraEffectCD[calling_player_idx])  //already in cooldown
  {
    return Plugin_Continue;
  }
  bIsEukuraEffectCD[calling_player_idx] = true;
  float cooldown = args.GetFloat("cooldown");
  CreateTimer(cooldown, FinishCooldown, calling_player_idx);
  return Plugin_Continue;
}

Action FinishCooldown(Handle timer, int client)
{
  bIsEukuraEffectCD[calling_player_idx] = false;
  return Plugin_Continue;
}
