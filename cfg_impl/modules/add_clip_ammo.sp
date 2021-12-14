public Action ConfigEvent_AddClip(EventMap args, ConfigEventType_t event_type)
{
  int calling_player_idx;
	VSH2Player calling_player;
	if (!args.GetTarget(calling_player_idx, calling_player))
		return Plugin_Continue;

  int amount = args.GetInt("amount");
  int slot = args.GetInt("slot", slot);
  float duration = args.GetFloat("duration");

  int clip = GetClip(calling_player_idx, slot);
  SetClip(calling_player_idx, slot, clip+amount);

  if (duration >= 0.0)
		CreateTimer(duration, Timer_ResetClip, clip, slot, calling_player_idx);

  return Plugin_Continue;
}

public Action Timer_ResetClip(Handle hTimer, int clip, int slot, int calling_player_idx)
{
  int currentclip = GetClip(calling_player_idx, slot);
  if (currentclip > clip)
    currentclip = clip;

  SetClip(calling_player_idx, slot, currentclip);
}

public Action ConfigEvent_AddAmmo(EventMap args, ConfigEventType_t event_type)
{
  int calling_player_idx;
	VSH2Player calling_player;
	if (!args.GetTarget(calling_player_idx, calling_player))
		return Plugin_Continue;

  int amount = args.GetInt("amount");
  int slot = args.GetInt("slot", slot);

  int ammo = GetAmmo(calling_player_idx, slot);
  int newammo = ammo + amount;
  int maxammo = GetMaxAmmo(calling_player_idx, slot)
  if (newammo > maxammo)
    newammo = maxammo;

  SetAmmo(calling_player_idx, args.GetInt("slot", slot), newammo);
  return Plugin_Continue;
}
