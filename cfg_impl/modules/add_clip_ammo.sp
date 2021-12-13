public Action ConfigEvent_AddClip(EventMap args, ConfigEventType_t event_type)
{
  int calling_player_idx;
	VSH2Player calling_player;
	if (!args.GetTarget(calling_player_idx, calling_player))
		return Plugin_Continue;

  int iAmount = args.GetInt("amount");

  int iClip = GetClip(calling_player_idx, args.GetInt("slot", slot));
  SetClip(calling_player_idx, args.GetInt("slot", slot), iClip+iAmount);

  return Plugin_Continue;
}

public Action ConfigEvent_AddAmmo(EventMap args, ConfigEventType_t event_type)
{
  int calling_player_idx;
	VSH2Player calling_player;
	if (!args.GetTarget(calling_player_idx, calling_player))
		return Plugin_Continue;

  int iAmount = args.GetInt("amount");

  int iClip = GetAmmo(calling_player_idx, args.GetInt("slot", slot));
  SetAmmo(calling_player_idx, args.GetInt("slot", slot), iClip+iAmount);

  return Plugin_Continue;
}
