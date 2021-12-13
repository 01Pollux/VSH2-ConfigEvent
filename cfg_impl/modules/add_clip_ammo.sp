public Action ConfigEvent_AddClip(EventMap args, ConfigEventType_t event_type)
{
  int calling_player_idx;
	VSH2Player calling_player;
	if (!args.GetTarget(calling_player_idx, calling_player))
		return Plugin_Continue;

  int iAmount = args.GetInt("amount");
  int iSlot = args.GetInt("slot", slot);

  int iClip = GetClip(calling_player_idx, iSlot);
  SetClip(calling_player_idx, iSlot, iClip+iAmount);
  return Plugin_Continue;
}

public Action ConfigEvent_AddAmmo(EventMap args, ConfigEventType_t event_type)
{
  int calling_player_idx;
	VSH2Player calling_player;
	if (!args.GetTarget(calling_player_idx, calling_player))
		return Plugin_Continue;

  int iAmount = args.GetInt("amount");
  int iSlot = args.GetInt("slot", slot);

  int iAmmo = GetAmmo(calling_player_idx, iSlot);
  int iNewAmmo = iAmmo + iAmount;
  int iMaxAmmo = GetMaxAmmo(calling_player_idx, iSlot)
  if (iNewAmmo > iMaxAmmo)
    iNewAmmo = iMaxAmmo;

  SetAmmo(calling_player_idx, args.GetInt("slot", slot), iNewAmmo);
  return Plugin_Continue;
}
