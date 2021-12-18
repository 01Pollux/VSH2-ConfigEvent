public Action ConfigEvent_GetProp(EventMap args, ConfigEventType_t event_type)
{
	/*
	// ConfigEvent_GetProp(...);
	"<enum>"
	{
		"procedure"  "ConfigEvent_GetProp"
		
		"<enum>"
		{
			"name"	"my_string"
			"type"	"int"
			// "size"		"4" 
			// "element"	"0"
			// "element"	"@my_var"
			"prop"  "m_iHealth"
			"datamap"   "false" // Prop_Data
		}
	}
	*/
	int calling_player_idx;
	VSH2Player calling_player;
	if (!args.GetTarget(calling_player_idx, calling_player))
		return Plugin_Continue;
	
	int args_count = args.Size;
	for (int var_i = 0; var_i < args_count; ++var_i)
	{
		ConfigMap var_sec = args.GetIntSection(var_i);
		if (!var_sec)
			break;

		int prop_name_size;
		if (!var_sec.GetInt("prop", prop_name_size))
			prop_name_size = 48;
		char[] prop_name = new char[prop_name_size]; 
		var_sec.Get("prop", prop_name, prop_name_size);

		int out_name_size;
		if (!var_sec.GetInt("prop", out_name_size))
			out_name_size = 48;
		char[] out_name = new char[out_name_size];
		var_sec.Get("prop", out_name, out_name_size);

		int prop_size;
		if (!var_sec.GetInt("size", prop_size))
			prop_size = 4;
		
		int prop_element;
		{
			char element[8];
			var_sec.Get("element", element, sizeof(element));
			if (element[0] == '@')
				ConfigSys.Params.GetValue(element[1], prop_element);
			else prop_element = StringToInt(element);
		}
		

		PropType prop_type;
		{
			bool is_datamap; var_sec.GetBool("datamap", is_datamap, false);
			prop_type = is_datamap ? Prop_Data : Prop_Send;
		}

		switch (GetTypeFromName(var_sec))
		{
		case PT_Bool, PT_Int, PT_Char:
		{
			ConfigSys.Params.SetValue(out_name, GetEntProp(calling_player_idx, prop_type, prop_name, prop_size, prop_element));
		}
		case PT_Float:
		{
			ConfigSys.Params.SetValue(out_name, GetEntPropFloat(calling_player_idx, prop_type, prop_name, prop_element));
		}
		case PT_Vector:
		{
			float vec[3]; GetEntPropVector(calling_player_idx, prop_type, prop_name, vec, prop_element);
			ConfigSys.Params.SetArray(out_name, vec, sizeof(vec));
		}
		case PT_Entity:
		{
			int entity = GetEntPropEnt(calling_player_idx, prop_type, prop_name, prop_element);
			if (entity != -1)
				ConfigSys.Params.SetValue(out_name, entity);
		}
		case PT_String:
		{
			char[] out_val = new char[prop_size]; GetEntPropString(calling_player_idx, prop_type, prop_name, out_val, prop_size, prop_element);
			ConfigSys.Params.SetString(out_name, out_val);
		}
		}
	}

	return Plugin_Continue;
}

public Action ConfigEvent_SetProp(EventMap args, ConfigEventType_t event_type)
{
	/*
	// ConfigEvent_SetProp(...);
	"<enum>"
	{
		"procedure"  "ConfigEvent_SetProp"
		
		"<enum>"
		{
			"type"	"int"
			// "size"		"4" 
			// "element"	"0"
			// "element"	"@my_var"
			"prop"  "m_iHealth"
			"datamap"   "false" // Prop_Data
			"value" "my_var"

			// "min"	""
			// "max"	""
		}
	}
	*/
	int calling_player_idx;
	VSH2Player calling_player;
	if (!args.GetTarget(calling_player_idx, calling_player))
		return Plugin_Continue;
	
	int args_count = args.Size;
	for (int var_i = 0; var_i < args_count; ++var_i)
	{
		ConfigMap var_sec = args.GetIntSection(var_i);
		if (!var_sec)
			break;

		int prop_name_size;
		if (!var_sec.GetInt("prop", prop_name_size))
			prop_name_size = 48;
		char[] prop_name = new char[prop_name_size]; 
		var_sec.Get("prop", prop_name, prop_name_size);

		int out_name_size;
		if (!var_sec.GetInt("value", out_name_size))
			out_name_size = 48;
		char[] out_name = new char[out_name_size];
		var_sec.Get("value", out_name, out_name_size);

		int prop_size;
		if (!var_sec.GetInt("size", prop_size))
			prop_size = 4;
		
		int prop_element;
		{
			char element[8];
			var_sec.Get("element", element, sizeof(element));
			if (element[0] == '@')
				ConfigSys.Params.GetValue(element[1], prop_element);
			else prop_element = StringToInt(element);
		}

		PropType prop_type;
		{
			bool is_datamap; var_sec.GetBool("datamap", is_datamap, false);
			prop_type = is_datamap ? Prop_Data : Prop_Send;
		}

		switch (GetTypeFromName(var_sec))
		{
		case PT_Bool, PT_Int, PT_Char:
		{
			any val;
			ConfigSys.Params.GetValue(out_name, val);

			int clamp;
			if (var_sec.GetInt("min", clamp) && clamp > val)
				val = clamp;
			if (var_sec.GetInt("max", clamp) && clamp < val)
				val = clamp;

			SetEntProp(calling_player_idx, prop_type, prop_name, val, prop_size, prop_element);
		}
		case PT_Float:
		{
			float val;
			ConfigSys.Params.GetValue(out_name, val);
			SetEntProp(calling_player_idx, prop_type, prop_name, val, prop_size, prop_element);
		}
		case PT_Vector:
		{
			float vec[3];
			ConfigSys.Params.GetArray(out_name, vec, sizeof(vec));
			SetEntPropVector(calling_player_idx, prop_type, prop_name, vec, prop_element);
		}
		case PT_Entity:
		{
			int entity;
			ConfigSys.Params.GetValue(out_name, entity);
			if (entity != -1)
				SetEntPropEnt(calling_player_idx, prop_type, prop_name, entity, prop_element);
		}
		case PT_String:
		{
			char[] out_val = new char[prop_size];
			ConfigSys.Params.GetString(out_name, out_val, prop_size);
			SetEntPropString(calling_player_idx, prop_type, prop_name, out_val, prop_element);
		}
		}
	}

	return Plugin_Continue;
}
