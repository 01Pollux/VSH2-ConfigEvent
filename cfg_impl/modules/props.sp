enum CE_PropType
{
	Prop_VSH2Player,
	Prop_Resources,
	Prop_GameRules,
	Prop_VSH2GameRules,
	Prop_Player
}

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
			// "element"	"@my_var"	// element is ignored when "custom" is "resource"
			// "custom"		"resource"
			// "custom"		"gamerules"
			// "custom"		"vsh2gamerules"
			// "custom"		"player"
			"prop"  "m_iHealth"
			"datamap"   "false" // Prop_Data
		}
	}
	*/
	int calling_ent_index;
	{
		VSH2Player dummy_vsh2player;
		if (!args.GetTarget(calling_ent_index, dummy_vsh2player) && !args.GetTargetEnt(calling_ent_index))
			return Plugin_Stop;
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
		CE_PropType ce_proptype = GetConfigPropType(var_sec);

		switch (ce_proptype)
		{
		case Prop_VSH2Player:
		{
			char prop_name[64];
			var_sec.Get("prop", prop_name, sizeof(prop_name));
			ConfigSys.Params.SetValue(out_name, VSH2Player(calling_ent_index).GetPropAny(prop_name));
			continue;
		}
		case Prop_VSH2GameRules:
		{
			char prop_name[64];
			var_sec.Get("prop", prop_name, sizeof(prop_name));
			ConfigSys.Params.SetValue(out_name, VSH2GameMode.GetPropAny(prop_name));
			continue;
		}
		case Prop_Resources:
		{
			if (!resource_ent)
				resource_ent = GetPlayerResourceEntity();
		}
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

		switch (type)
		{
		case PT_Bool, PT_Int, PT_Char:
		{
			any val;
			switch (ce_proptype)
			{
			case Prop_Player:		val = GetEntProp(calling_ent_index, prop_type, prop_name, prop_size, prop_element);
			case Prop_Resources:	val = GetEntProp(resource_ent, prop_type, prop_name, prop_size, calling_ent_index);
			case Prop_GameRules:	val = GameRules_GetProp(prop_name, prop_size, prop_element);
			}
			ConfigSys.Params.SetValue(out_name, val);
		}
		case PT_Float:
		{
			float val;
			switch (ce_proptype)
			{
			case Prop_Player:		val = GetEntPropFloat(calling_ent_index, prop_type, prop_name, prop_element);
			case Prop_Resources:	val = GetEntPropFloat(resource_ent, prop_type, prop_name, calling_ent_index);
			case Prop_GameRules:	val = GameRules_GetPropFloat(prop_name, prop_element);
			}
			ConfigSys.Params.SetValue(out_name, val);
		}
		case PT_Vector:
		{
			float vec[3];
			switch (ce_proptype)
			{
			case Prop_Player:		GetEntPropVector(calling_ent_index, prop_type, prop_name, vec, prop_element);
			case Prop_Resources:	GetEntPropVector(resource_ent, prop_type, prop_name, vec, calling_ent_index);
			case Prop_GameRules:	GameRules_GetPropVector(prop_name, vec, prop_element);
			}
			ConfigSys.Params.SetArray(out_name, vec, sizeof(vec));
		}
		case PT_Entity:
		{
			int entity;
			switch (ce_proptype)
			{
			case Prop_Player:		entity = GetEntPropEnt(calling_ent_index, prop_type, prop_name, prop_element);
			case Prop_Resources:	entity = GetEntPropEnt(resource_ent, prop_type, prop_name, calling_ent_index);
			case Prop_GameRules:	entity = GameRules_GetPropEnt(prop_name, prop_element);
			}
			ConfigSys.Params.SetValue(out_name, entity);
		}
		case PT_String:
		{
			char[] out_val = new char[prop_size];
			switch (ce_proptype)
			{
			case Prop_Player:		GetEntPropString(calling_ent_index, prop_type, prop_name, out_val, prop_size, prop_element);
			case Prop_Resources:	GetEntPropString(resource_ent, prop_type, prop_name, out_val, prop_size, calling_ent_index);
			case Prop_GameRules:	GameRules_GetPropString(prop_name, out_val, prop_size);
			}
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
			"type"	"int"
			// "size"		"4"
			// "element"	"0"
			// "element"	"@my_var"	// element is ignored when "custom" is "resource"
			// "custom"		"resource"
			// "custom"		"gamerules"
			// "custom"		"vsh2gamerules"
			// "custom"		"player"
			"prop"  "m_iHealth"
			"value" "my_var"
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
		if (!var_sec.GetInt("value", out_name_size))
			out_name_size = 48;
		char[] out_name = new char[out_name_size];
		var_sec.Get("value", out_name, out_name_size);

		ConfigEvent_ParamType_t type = GetTypeFromName(var_sec);
		CE_PropType ce_proptype = GetConfigPropType(var_sec);

		switch (ce_proptype)
		{
		case Prop_VSH2Player:
		{
			char prop_name[64];
			var_sec.Get("prop", prop_name, sizeof(prop_name));
			any val;
			if (ConfigSys.Params.GetValue(out_name, val))
				VSH2Player(calling_ent_index).SetPropAny(prop_name, val);
			continue;
		}
		case Prop_VSH2GameRules:
		{
			char prop_name[64];
			var_sec.Get("prop", prop_name, sizeof(prop_name));
			any val;
			if (ConfigSys.Params.GetValue(out_name, val))
				VSH2GameMode.SetProp(prop_name, val);
			continue;
		}
		case Prop_Resources:
		{
			if (!resource_ent)
				resource_ent = GetPlayerResourceEntity();
		}
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

				switch (ce_proptype)
				{
				case Prop_Player:		SetEntProp(calling_ent_index, prop_type, prop_name, val, prop_size, prop_element);
				case Prop_Resources:	SetEntProp(resource_ent, prop_type, prop_name, val, prop_size, calling_ent_index);
				case Prop_GameRules:	GameRules_SetProp(prop_name, val, prop_size, prop_element);
				}
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

				switch (ce_proptype)
				{
				case Prop_Player:		SetEntPropFloat(calling_ent_index, prop_type, prop_name, val, prop_element);
				case Prop_Resources:	SetEntPropFloat(resource_ent, prop_type, prop_name, val, calling_ent_index);
				case Prop_GameRules:	GameRules_SetPropFloat(prop_name, val, prop_element);
				}
			}
		}
		case PT_Vector:
		{
			float vec[3];
			if (ConfigSys.Params.GetArray(out_name, vec, sizeof(vec)))
			{
				switch (ce_proptype)
				{
				case Prop_Player:		SetEntPropVector(calling_ent_index, prop_type, prop_name, vec, prop_element);
				case Prop_Resources:	SetEntPropVector(resource_ent, prop_type, prop_name, vec, calling_ent_index);
				case Prop_GameRules:	GameRules_SetPropVector(prop_name, vec, prop_element);
				}
			}
		}
		case PT_Entity:
		{
			int entity;
			if (ConfigSys.Params.GetValue(out_name, entity))
			{
				switch (ce_proptype)
				{
				case Prop_Player:		SetEntPropEnt(calling_ent_index, prop_type, prop_name, entity, prop_element);
				case Prop_Resources:	SetEntPropEnt(resource_ent, prop_type, prop_name, entity, calling_ent_index);
				case Prop_GameRules:	GameRules_SetPropEnt(prop_name, entity, prop_element);
				}
			}
		}
		case PT_String:
		{
			char[] val = new char[prop_size];
			if (ConfigSys.Params.GetString(out_name, val, prop_size))
			{
				switch (ce_proptype)
				{
				case Prop_Player:		SetEntPropString(calling_ent_index, prop_type, prop_name, val, prop_element);
				case Prop_Resources:	SetEntPropString(resource_ent, prop_type, prop_name, val, calling_ent_index);
				case Prop_GameRules:	GameRules_SetPropString(prop_name, val);
				}
			}
		}
		}
	}

	return Plugin_Continue;
}

public Action ConfigEvent_GetGameTime(EventMap args, ConfigEventType_t event_type)
{
	/*
	// ConfigEvent_SetProp(...);
	"<enum>"
	{
		"procedure"  "ConfigEvent_GetGameTime"
		"name"		"out_name"

		// time to add to the out_name
		// "delta"		"@prop_name"
		// "delta"		"0.0"
	}
	*/
	int name_size = args.GetSize("name");
	char[] name = new char[name_size];
	args.Get("name", name, name_size);

	int delta_name_size = args.GetSize("delta");
	float time = GetGameTime();

	if (delta_name_size)
	{
		float delta_time;
		char[] delta_name = new char[delta_name_size];
		args.Get("delta", delta_name, delta_name_size);
		if (delta_name[0] == '@')
			ConfigSys.Params.GetValue(delta_name[1], delta_time);
		else delta_time = StringToFloat(delta_name);

		time += delta_time;
	}

	ConfigSys.Params.SetValue(name, time);
	return Plugin_Continue;
}

static CE_PropType GetConfigPropType(ConfigMap cfg)
{
	char types[][] = {
		"vsh2player",
		"resource",
		"gamerules",
		"vsh2gamerules",
		"player"
	};

	char type[16];
	if (cfg.Get("custom", type, sizeof(type)))
	{
		for (int i = 0; i < sizeof(type); i++)
		{
			if (!strcmp(types[i], type))
				return view_as<CE_PropType>(i);
		}
	}
	return Prop_Player;
}
