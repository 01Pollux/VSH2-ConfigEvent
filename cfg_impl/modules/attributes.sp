#include <tf2attributes>

public Action ConfigEvent_AddAttribPlayer(EventMap args, ConfigEventType_t event_type)
{
	/*
	// ConfigEvent_AddAttribPlayer();
	"<enum>"
	{
		"procedure"  "ConfigEvent_AddAttribPlayer"
		"vsh2target" "player"

		"attributes"
		{
			"<enum>"
			{
				"name"		"..."
				"value"  	"2.0"
				"duration"	"10.0"
			}
		}
	}
	*/
	int calling_player_idx;
	VSH2Player calling_player;
	if (!args.GetTarget(calling_player_idx, calling_player))
		return Plugin_Continue;

	ConfigMap attributes = args.GetSection("attributes");
	int attributes_size = attributes ? attributes.Size : 0;
	if (attributes_size)
	{
		for (int i = 0; i < attributes_size; i++)
		{
			ConfigMap attrib = attributes.GetIntSection(i);
			if (!attrib)
				break;

			int name_size = attrib.GetSize("name");
			char[] name = new char[name_size];
			attrib.Get("name", name, name_size);

			float value; attrib.GetFloat("value", value);
			float duration; attrib.GetFloat("duration", duration);

			TF2Attrib_AddCustomPlayerAttribute(calling_player_idx, name, value, duration);
		}
	}
	return Plugin_Continue;
}

public Action ConfigEvent_SetAttribWep(EventMap args, ConfigEventType_t event_type)
{
	/*
	// ConfigEvent_SetAttribWep();
	"<enum>"
	{
		"procedure"  "ConfigEvent_SetAttribWep"
		"vsh2target" "player"

		"attributes"
		{
			"<enum>"
			{
				"index"		"..."
				"value"  	"2.0"
				"duration"	"10.0"
			}
			"<enum>"
			{
				"id"		"3"
				"value"  	"@other_var"
			}
		}
	}
	*/
	int calling_player_idx;
	VSH2Player calling_player;
	if (!args.GetTarget(calling_player_idx, calling_player))
		return Plugin_Continue;

	ConfigMap attributes = args.GetSection("attributes");
	int attributes_size = attributes ? attributes.Size : 0;
	if (attributes_size)
	{
		int slot;
		int weapon = args.GetInt("slot", slot) ? GetPlayerWeaponSlot(calling_player_idx, slot) : -1;
		if (weapon == -1)
			return Plugin_Continue;

		int wep_ref = EntIndexToEntRef(weapon);

		for (int i = 0; i < attributes_size; i++)
		{
			ConfigMap attrib = attributes.GetIntSection(i);
			if (!attrib)
				break;

			int index; attrib.GetInt("index", index);
			int value_str_size = attrib.GetSize("value");
			char[] value_str = new char[value_str_size];
			attrib.Get("value", value_str, value_str_size);
			
			float value;
			if (value_str[0] == '@')
				ConfigSys.Params.GetValue(value_str[1], value);
			else value = StringToFloat(value_str);

			float duration; attrib.GetFloat("duration", duration);

			//Address_Null if attribute doesn't exist
			Address attrib_address = TF2Attrib_GetByDefIndex(weapon, index);
			int attrib_idx = TF2Attrib_GetDefIndex(attrib_address);
			float o_value = attrib_idx == index ? TF2Attrib_GetValue(attrib_address) : -39393939.0;

			TF2Attrib_SetByDefIndex(weapon, index, value);
			
			if (duration != -1.0)
			{
				DataPack data;
				CreateDataTimer(duration, Timer_ResetAttribWep, data);
				data.WriteCell(wep_ref);
				data.WriteCell(index);
				data.WriteFloat(o_value);
			}
		}

		TF2Attrib_ClearCache(weapon);
	}

	return Plugin_Continue;
}

public Action Timer_ResetAttribWep(Handle hTimer, DataPack data)
{
	data.Reset();

	int weapon = EntRefToEntIndex(data.ReadCell());
	if (IsValidEntity(weapon))
	{
		int index = data.ReadCell();
		float o_value = data.ReadFloat();

		if (o_value != -39393939.0)
			TF2Attrib_SetByDefIndex(weapon, index, o_value);
		else
			TF2Attrib_RemoveByDefIndex(weapon, index);

		TF2Attrib_ClearCache(weapon);
	}

	delete data;

	return Plugin_Continue;
}

public Action ConfigEvent_RemoveAttribWep(EventMap args, ConfigEventType_t event_type)
{
	/*
	// ConfigEvent_RemoveAttribWep();
	"<enum>"
	{
		"procedure"  "ConfigEvent_RemoveAttribWep"
		"vsh2target" "player"

		"attributes"
		{
			"<enum>"
			{
				"index"		"..."
			}
		}
	}
	*/
	int calling_player_idx;
	VSH2Player calling_player;
	if (!args.GetTarget(calling_player_idx, calling_player))
		return Plugin_Continue;

	ConfigMap attributes = args.GetSection("attributes");
	int attributes_size = attributes ? attributes.Size : 0;
	if (attributes_size)
	{
		int slot;
		int weapon = args.GetInt("slot", slot) ? GetPlayerWeaponSlot(calling_player_idx, slot) : -1;
		if (weapon == -1)
			return Plugin_Continue;
		
		for (int i = 0; i < attributes_size; i++)
		{
			ConfigMap attrib = attributes.GetIntSection(i);
			if (!attrib)
				break;

			int index; attrib.GetInt("index", index);
			TF2Attrib_RemoveByDefIndex(weapon, index);
		}

		TF2Attrib_ClearCache(weapon);
	}
	
	return Plugin_Continue;
}
