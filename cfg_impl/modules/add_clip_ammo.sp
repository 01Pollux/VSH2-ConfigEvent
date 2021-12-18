public Action ConfigEvent_AddClip(EventMap args, ConfigEventType_t event_type)
{
	int calling_player_idx;
	VSH2Player calling_player;
	if (!args.GetTarget(calling_player_idx, calling_player))
		return Plugin_Continue;

	int amount; args.GetInt("amount", amount);
	int max; args.GetInt("max", max);
	int slot; args.GetInt("slot", slot);
	float duration; args.GetFloat("duration", duration);

	int clip = GetClip(calling_player_idx, slot);
	SetClip(calling_player_idx, slot, clip+amount);

	if (duration >= 0.0)
	{
		DataPack data;
		CreateDataTimer(duration, Timer_ResetClip, data);
		data.WriteCell(clip);
		data.WriteCell(max);
		data.WriteCell(slot);
		data.WriteCell(calling_player_idx);
	}

	return Plugin_Continue;
}

public Action Timer_ResetClip(Handle hTimer, DataPack data)
{
	data.Reset();

	int clip = data.ReadCell();
	int max = data.ReadCell();
	int slot = data.ReadCell();
	int calling_player_idx = data.ReadCell();

	int currentclip = GetClip(calling_player_idx, slot);
	if (currentclip > max)
		currentclip = max;

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

public Action ConfigEvent_SetClipEnergy(EventMap args, ConfigEventType_t event_type)	//I want to use props.sp but it doens't support 'delay' right now.
{
	int calling_player_idx;
	VSH2Player calling_player;
	if (!args.GetTarget(calling_player_idx, calling_player))
		return Plugin_Continue;

	float clip; args.GetFloat("clip", clip);
	float max; args.GetFloat("max", max);
	int slot; args.GetInt("slot", slot);
	float duration; args.GetFloat("duration", duration);

	int weapon = GetIndexOfWeaponSlot(calling_player_idx, slot);
	SetEntProp(weapon, Prop_Send, "m_flEnergy", clip);

	if (duration >= 0.0)
	{
		DataPack data;
		CreateDataTimer(duration, Timer_ResetClipEnergy, data);
		date.WriteCell(max);
		data.WriteCell(weapon);
	}

	return Plugin_Continue;
}

public Action Timer_ResetClipEnergy(Handle hTimer, DataPack data)
{
	data.Reset();

	int max = data.ReadCell();
	int weapon = data.ReadCell();

	int currentclip = GetEntPropFloat(weapon, Prop_Send, "m_flEnergy");
	if (currentclip > max)
		currentclip = max;

	SetEntProp(weapon, Prop_Send, "m_flEnergy", currentclip);
	delete data;
}
