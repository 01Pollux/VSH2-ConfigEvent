public Action ConfigEvent_GetProp(EventMap args, ConfigEventType_t event_type)
{
	/*
	// ConfigEvent_GetProp(...);
	"<enum>"
	{
		"procedure"  "ConfigEvent_GetProp"
		
		"vsh2target"	"player"
		// "target"		"entity"

		"<enum>"
		{
			"name"	"my_string"
			"type"	"int"
			// "size"		"4" 
			// "element"	"0"
			// "element"	"@my_var"
			// "resource"	"false"
			"prop"  "m_iHealth"
			"datamap"   "false" // Prop_Data
		}
	}
	*/
	int calling_ent_index;
	{
		VSH2Player dummy_vsh2player;
		if (!args.GetTarget(calling_ent_index, dummy_vsh2player) && !args.GetTargetEnt(calling_ent_index))
			return Plugin_Continue;
	}
	
	int args_count = args.Size;
	int resource_ent;

	for (int var_i = 0; var_i < args_count; ++var_i)
	{
		ConfigMap var_sec = args.GetIntSection(var_i);
		if (!var_sec)
			break;

		int out_name_size;
		if (!var_sec.GetInt("name", out_name_size))
			out_name_size = 48;
		char[] out_name = new char[out_name_size];
		var_sec.Get("name", out_name, out_name_size);

		ConfigEvent_ParamType_t type = GetTypeFromName(var_sec);
		if (type == PT_VSH2)
		{
			char prop_name[64];
			var_sec.Get("prop", prop_name, sizeof(prop_name));
			ConfigSys.Params.SetValue(out_name, VSH2Player(calling_ent_index).GetPropAny(prop_name));
			continue;
		}

		int prop_name_size;
		if (!var_sec.GetInt("prop", prop_name_size))
			prop_name_size = 48;
		char[] prop_name = new char[prop_name_size]; 
		var_sec.Get("prop", prop_name, prop_name_size);

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

		bool is_resource;
		{
			if (var_sec.GetBool("resource", is_resource) && is_resource && !resource_ent)
				resource_ent = GetPlayerResourceEntity();
		}

		switch (type)
		{
		case PT_Bool, PT_Int, PT_Char:
		{
			ConfigSys.Params.SetValue(
				out_name,
				GetEntProp(is_resource ? resource_ent : calling_ent_index, prop_type, prop_name, prop_size, prop_element)
			);
		}
		case PT_Float:
		{
			ConfigSys.Params.SetValue(
				out_name,
				GetEntPropFloat(is_resource ? resource_ent : calling_ent_index, prop_type, prop_name, prop_element)
			);
		}
		case PT_Vector:
		{
			float vec[3]; GetEntPropVector(is_resource ? resource_ent : calling_ent_index, prop_type, prop_name, vec, prop_element);
			ConfigSys.Params.SetArray(out_name, vec, sizeof(vec));
		}
		case PT_Entity:
		{
			int entity = GetEntPropEnt(is_resource ? resource_ent : calling_ent_index, prop_type, prop_name, prop_element);
			if (entity != -1)
				ConfigSys.Params.SetValue(out_name, entity);
		}
		case PT_String:
		{
			char[] out_val = new char[prop_size];
			GetEntPropString(is_resource ? resource_ent : calling_ent_index, prop_type, prop_name, out_val, prop_size, prop_element);
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

		"vsh2target"	"player"
		// "target"		"entity"

		"<enum>"
		{
			"name" "my_var"
			"type"	"int"
			// "size"		"4" 
			// "element"	"0"
			// "element"	"@my_var"
			// "resource"	"false"
			"prop"  "m_iHealth"
			"datamap"   "false" // Prop_Data

			// "min"	""
			// "max"	""
		}
	}
	*/
	int calling_ent_index;
	{
		VSH2Player dummy_vsh2player;
		if (!args.GetTarget(calling_ent_index, dummy_vsh2player) && !args.GetTargetEnt(calling_ent_index))
			return Plugin_Continue;
	}

	int args_count = args.Size;
	int resource_ent;

	for (int var_i = 0; var_i < args_count; ++var_i)
	{
		ConfigMap var_sec = args.GetIntSection(var_i);
		if (!var_sec)
			break;

		int out_name_size;
		if (!var_sec.GetInt("name", out_name_size))
			out_name_size = 48;
		char[] out_name = new char[out_name_size];
		var_sec.Get("name", out_name, out_name_size);

		ConfigEvent_ParamType_t type = GetTypeFromName(var_sec);
		if (type == PT_VSH2)
		{
			char prop_name[64];
			var_sec.Get("prop", prop_name, sizeof(prop_name));
			any val;
			if (ConfigSys.Params.GetValue(out_name, val))
				VSH2Player(calling_player_idx).SetPropAny(prop_name, val);
			continue;
		}

		int prop_name_size;
		if (!var_sec.GetInt("prop", prop_name_size))
			prop_name_size = 48;
		char[] prop_name = new char[prop_name_size]; 
		var_sec.Get("prop", prop_name, prop_name_size);

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

		bool is_resource;
		{
			if (var_sec.GetBool("resource", is_resource) && is_resource && !resource_ent)
				resource_ent = GetPlayerResourceEntity();
		}

		switch (type)
		{
		case PT_Bool, PT_Int, PT_Char:
		{
			any val;
			if (ConfigSys.Params.GetValue(out_name, val))
			{
				int clamp;
				if (var_sec.GetInt("min", clamp) && clamp > val)
					val = clamp;
				if (var_sec.GetInt("max", clamp) && clamp < val)
					val = clamp;

				SetEntProp(is_resource ? resource_ent : calling_player_idx, prop_type, prop_name, val, prop_size, prop_element);
			}
		}
		case PT_Float:
		{
			float val;
			if (ConfigSys.Params.GetValue(out_name, val))
			{
				float clamp;
				if (var_sec.GetFloat("min", clamp) && clamp > val)
					val = clamp;
				if (var_sec.GetFloat("max", clamp) && clamp < val)
					val = clamp;

				SetEntPropFloat(is_resource ? resource_ent : calling_player_idx, prop_type, prop_name, val, prop_element);
			}
		}
		case PT_Vector:
		{
			float vec[3];
			if (ConfigSys.Params.GetArray(out_name, vec, sizeof(vec)))
				SetEntPropVector(is_resource ? resource_ent : calling_player_idx, prop_type, prop_name, vec, prop_element);
		}
		case PT_Entity:
		{
			int entity;
			if (ConfigSys.Params.GetValue(out_name, entity))
				SetEntPropEnt(is_resource ? resource_ent : calling_player_idx, prop_type, prop_name, entity, prop_element);
		}
		case PT_String:
		{
			char[] out_val = new char[prop_size];
			if (ConfigSys.Params.GetString(out_name, out_val, prop_size))
				SetEntPropString(is_resource ? resource_ent : calling_player_idx, prop_type, prop_name, out_val, prop_element);
		}
		}
	}

	return Plugin_Continue;
}