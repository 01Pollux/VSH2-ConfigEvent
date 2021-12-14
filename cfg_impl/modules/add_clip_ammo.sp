public Action ConfigEvent_AddClip(EventMap args, ConfigEventType_t event_type)
{
	int calling_player_idx;
	VSH2Player calling_player;
	if (!args.GetTarget(calling_player_idx, calling_player))
		return Plugin_Continue;

	int amount; args.GetInt("amount", amount);
	int slot; args.GetInt("slot", slot);
	float duration; args.GetFloat("duration", duration);

	int clip = GetClip(calling_player_idx, slot);
	SetClip(calling_player_idx, slot, clip+amount);

	if (duration >= 0.0)
	{
		DataPack data;
		CreateDataTimer(duration, Timer_ResetClip, data);
		data.WriteCell(clip);
		data.WriteCell(slot);
		data.WriteCell(calling_player_idx);
	}

	return Plugin_Continue;
}

public Action Timer_ResetClip(Handle hTimer, DataPack data)
{
	data.Reset();
	
	int clip = data.ReadCell();
	int slot = data.ReadCell();
	int calling_player_idx = data.ReadCell();

	int currentclip = GetClip(calling_player_idx, slot);
	if (currentclip > clip)
		currentclip = clip;

	SetClip(calling_player_idx, slot, currentclip);
	delete data;
}

public Action ConfigEvent_AddAmmo(EventMap args, ConfigEventType_t event_type)
{
	int calling_player_idx;
	VSH2Player calling_player;
	if (!args.GetTarget(calling_player_idx, calling_player))
		return Plugin_Continue;

	int amount; args.GetInt("amount", amount);
	int slot; args.GetInt("slot", slot);

	int ammo = GetAmmo(calling_player_idx, slot);
	int newammo = ammo + amount;
	int maxammo = GetMaxAmmo(calling_player_idx, slot);
	if (newammo > maxammo)
		newammo = maxammo;

	SetAmmo(calling_player_idx, args.GetInt("slot", slot), newammo);
	return Plugin_Continue;
}