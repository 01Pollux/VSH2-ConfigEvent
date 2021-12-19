public Action ConfigEvent_AddClip(EventMap args, ConfigEventType_t event_type)
{
	/*
	// ConfigEvent_AddClip();
	"<enum>"
	{
		"procedure"  "ConfigEvent_AddClip"
		"vsh2target" "player"

		"amount"	""
		"max"		""
		"slot"		""
		"duration"	""
	}
	*/
	int calling_player_idx;
	VSH2Player calling_player;
	if (!args.GetTarget(calling_player_idx, calling_player))
		return Plugin_Continue;

	int amount; args.GetInt("amount", amount);
	int max; args.GetInt("max", max);
	int slot; args.GetInt("slot", slot);
	float duration; args.GetFloat("duration", duration);

	int clip = GetClip(calling_player_idx, slot);
	SetClip(calling_player_idx, slot, clip + amount);

	if (duration >= 0.0)
	{
		DataPack data;
		CreateDataTimer(duration, Timer_ResetClip, data);
		data.WriteCell(calling_player);
		data.WriteCell(max);
		data.WriteCell(slot);
	}

	return Plugin_Continue;
}

public Action Timer_ResetClip(Handle hTimer, DataPack data)
{
	data.Reset();

	VSH2Player calling_player = data.ReadCell();
	int calling_player_idx = calling_player.index;

	if (calling_player_idx)
	{
		int max = data.ReadCell();
		int slot = data.ReadCell();
		int currentclip = GetClip(calling_player_idx, slot);
		if (currentclip > max)
			currentclip = max;

		SetClip(calling_player_idx, slot, currentclip);
	}
	delete data;

	return Plugin_Continue;
}

public Action ConfigEvent_AddAmmo(EventMap args, ConfigEventType_t event_type)
{
	/*
	// ConfigEvent_AddAmmo();
	"<enum>"
	{
		"procedure"  "ConfigEvent_AddAmmo"
		"vsh2target" "player"

		"amount"	""
		"slot"		""
	}
	*/
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

	SetAmmo(calling_player_idx, slot, newammo);
	return Plugin_Continue;
}

public Action ConfigEvent_SetClipEnergy(EventMap args, ConfigEventType_t event_type)	//I want to use props.sp but it doens't support 'delay' right now.
{
	/*
	// ConfigEvent_SetClipEnergy();
	"<enum>"
	{
		"procedure"  "ConfigEvent_SetClipEnergy"
		"vsh2target" "player"

		"amount"	""
		"max"		""
		"slot"		""
		"duration"	""
	}
	*/
	int calling_player_idx;
	VSH2Player calling_player;
	if (!args.GetTarget(calling_player_idx, calling_player))
		return Plugin_Continue;

	float clip; args.GetFloat("clip", clip);
	float max; args.GetFloat("max", max);
	int slot; args.GetInt("slot", slot);
	float duration; args.GetFloat("duration", duration);

	int weapon = GetPlayerWeaponSlot(calling_player_idx, slot);
	if (IsValidEntity(weapon))
	{
		SetEntProp(weapon, Prop_Send, "m_flEnergy", clip);

		if (duration >= 0.0)
		{
			DataPack data;
			CreateDataTimer(duration, Timer_ResetClipEnergy, data);
			data.WriteCell(EntIndexToEntRef(weapon));
			data.WriteFloat(max);
		}
	}

	return Plugin_Continue;
}

public Action Timer_ResetClipEnergy(Handle hTimer, DataPack data)
{
	data.Reset();

	int weapon = EntRefToEntIndex(data.ReadCell());
	if (IsValidEntity(weapon))
	{
		float max = data.ReadFloat();
		float cur_energy = GetEntPropFloat(weapon, Prop_Send, "m_flEnergy");
		if (cur_energy > max)
			cur_energy = max;

		SetEntProp(weapon, Prop_Send, "m_flEnergy", cur_energy);
	}

	delete data;

	return Plugin_Continue;
}
