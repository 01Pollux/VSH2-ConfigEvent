enum struct ConfigSys_t
{
	// ConfigWeaponEvent_t
	ArrayList WeaponEvents[view_as<int>(CET_Count)];
	// ConfigGlobalEvent_t
	ArrayList GlobalEvents[view_as<int>(CET_Count)];
	StringMap Params;
}
ConfigSys_t ConfigSys;

#include "cfg_impl/target.sp"

typedef ConfigWeaponEvent_Proc = function void(EventMap args, ConfigEventType_t type);
enum struct ConfigWeaponEvent_t
{
	EventMap Arguments;
	Handle Plugin;
	ConfigWeaponEvent_Proc Procedure;
	int	 ItemID;
}

typedef ConfigGlobalEvent_Proc = function void(EventMap args, ConfigEventType_t type);
enum struct ConfigGlobalEvent_t
{
	EventMap Arguments;
	Handle Plugin;
	ConfigGlobalEvent_Proc Procedure;
}

void ConfigEvent_Load()
{
	ConfigMap cfg_event = new ConfigMap("configs/saxton_hale/vsh2.cfgevent");
	if (!cfg_event)
		return;
	
	ConfigMap cfg = cfg_event.GetSection("config");
	if (!cfg)
	{
		DeleteCfg(cfg);
		LogError("[VSH2 CfgEvent] Invalid config.");
		return;
	}

	ConfigSys.Params = new StringMap();

	ConfigMap weapons = cfg.GetSection("weapons");
	if (weapons)
		ConfigEvent_ParseWeapons(weapons);
	
	ConfigMap globals = cfg.GetSection("globals");
	if (globals)
		ConfigEvent_ParseGlobals(globals);

	DeleteCfg(cfg_event);
}

void ConfigEvent_Unload()
{
	{
		ConfigWeaponEvent_t event_info;
		for (int i = 0; i < sizeof(ConfigSys.WeaponEvents); i++)
		{
			ArrayList cur_event = ConfigSys.WeaponEvents[i];
			if (cur_event)
			{
				ConfigSys.WeaponEvents[i] = null;
				for (int j = cur_event.Length - 1; j >= 0; j--)
				{
					cur_event.GetArray(j, event_info);

					int ref_count;
					event_info.Arguments.GetInt("__ref_count__", ref_count);
					if (!--ref_count)
						DeleteCfg(event_info.Arguments);
					else
						event_info.Arguments.SetInt("__ref_count__", ref_count);
				}
				delete cur_event;
			}
		}
	}
	{
		ConfigGlobalEvent_t event_info;
		for (int i = 0; i < sizeof(ConfigSys.GlobalEvents); i++)
		{
			ArrayList cur_event = ConfigSys.GlobalEvents[i];
			if (cur_event)
			{
				ConfigSys.GlobalEvents[i] = null;
				for (int j = cur_event.Length - 1; j >= 0; j--)
				{
					cur_event.GetArray(j, event_info);
					DeleteCfg(event_info.Arguments);
				}
				delete cur_event;
			}
		}
	}
	delete ConfigSys.Params;
}


void ConfigEvent_ParseWeapons(ConfigMap weapons)
{
	StringMapSnapshot weapon_iter = weapons.Snapshot();
	Handle myself = GetMyHandle();

	for (int weapon_iter_i = weapon_iter.Length - 1; weapon_iter_i >= 0; weapon_iter_i--)
	{
		int key_size = weapon_iter.KeyBufferSize(weapon_iter_i) + 1;
		char[] key = new char[key_size];
		weapon_iter.GetKey(weapon_iter_i, key, key_size);
		
		int separators = CountCharInString(key, ',') + 1;
		char[][] weapon_ids = new char[separators][6];
		int entries = ExplodeString(key, ",", weapon_ids, separators, 6);

		ConfigMap cur_weapon = weapons.GetSection(key);

		{
			StringMapSnapshot cur_weapon_iter = cur_weapon.Snapshot();
			for (int cur_weapon_j = cur_weapon_iter.Length - 1; cur_weapon_j >= 0; cur_weapon_j--)
			{
				int event_key_size = cur_weapon_iter.KeyBufferSize(cur_weapon_j) + 1;
				char[] event_key = new char[event_key_size];
				
				cur_weapon_iter.GetKey(cur_weapon_j, event_key, event_key_size);
				ConfigMap event_sec = cur_weapon.GetSection(event_key);
				if (!event_sec)
					continue;
				
				ConfigEventType_t type = ConfigEvent_NameToType(event_key);
				if (type == CET_Invalid)
				{
					LogError("[VSH2 CfgEvent] Event doesn't exists \"weapons::%s::%s\".", key, event_key);
					continue;
				}

				ArrayList cur_event = ConfigSys.WeaponEvents[type];
				if (!cur_event)
					ConfigSys.WeaponEvents[type] = cur_event = new ArrayList(sizeof(ConfigWeaponEvent_t));
				
				ConfigWeaponEvent_t event_info;
				for (int event_info_i = event_sec.Size - 1; event_info_i >= 0; event_info_i--)
				{
					ConfigMap section = event_sec.GetIntSection(event_info_i);
					if (!section)
					{
						LogError("[VSH2 CfgEvent] Section is not an array \"weapons::%s::%s\".", key, event_key);
						break;
					}

					int function_name_size = section.GetSize("procedure");
					char[] function_name = new char[function_name_size];
					section.Get("procedure", function_name, function_name_size);

					// check if the module is imported externally
					int plugin_name_size = section.GetSize("module");
					event_info.Plugin = myself;
					if (plugin_name_size)
					{
						char[] plugin_name = new char[plugin_name_size];
						section.Get("module", plugin_name, plugin_name_size);
						if (!(event_info.Plugin = FindPluginByFile(plugin_name)))
						{
							LogError("[VSH2 CfgEvent] Plugin doesn't exists \"weapons::%s::%s::%s\".", key, event_key, function_name);
							continue;
						}
					}

					event_info.Procedure = view_as<ConfigWeaponEvent_Proc>(GetFunctionByName(event_info.Plugin, function_name));
					if (event_info.Procedure == INVALID_FUNCTION)
					{
						LogError("[VSH2 CfgEvent] Function doesn't exists \"weapons::%s::%s::%s\".", key, event_key, function_name);
						continue;
					}
					event_info.Arguments = new EventMap(section, event_info.Plugin);

					// disallow external use of '__ref_count__'
					int ref_count;
					if (event_info.Arguments.GetInt("__ref_count__", ref_count))
					{
						LogError("[VSH2 CfgEvent] Invalid access to '__ref_count__' key in \"weapons::%s::%s::%s\".", key, event_key, function_name);
						event_info.Arguments.SetInt("__ref_count__", 0);
					}

					// Iterate through our weapon indexes "xx, yy" 'weapon_ids'
					for (int weapon_i = 0; weapon_i < entries; weapon_i++)
					{
						if (weapon_ids[weapon_i][0] == '*' && !weapon_ids[weapon_i][1])
							event_info.ItemID = -1;
						else if (StringToIntEx(weapon_ids[weapon_i], event_info.ItemID) <= 0)
						{
							LogError("[VSH2 CfgEvent] Bad weapon id was passed \"weapons::%s::%s\".", key, event_key);
							continue;
						}

						cur_event.PushArray(event_info);
					}
					event_info.Arguments.SetInt("__ref_count__", entries);
				}

				if (!cur_event.Length)
					delete ConfigSys.WeaponEvents[type];
			}
			delete cur_weapon_iter;
		}
	}

	delete weapon_iter;
}

void ConfigEvent_ParseGlobals(ConfigMap globals)
{
	StringMapSnapshot globals_iter = globals.Snapshot();
	ConfigGlobalEvent_t event_info;
	Handle myself = GetMyHandle();

	for (int globals_iter_i = globals_iter.Length - 1; globals_iter_i >= 0; globals_iter_i--)
	{
		int event_key_size = globals_iter.KeyBufferSize(globals_iter_i) + 1;
		char[] event_key = new char[event_key_size];
		globals_iter.GetKey(globals_iter_i, event_key, event_key_size);
		
		ConfigEventType_t type = ConfigEvent_NameToType(event_key);
		if (type == CET_Invalid)
		{
			LogError("[VSH2 CfgEvent] Event doesn't exists \"globals::%s\".", event_key);
			continue;
		}
		
		ConfigMap cur_global = globals.GetSection(event_key);
		int cur_global_size = cur_global ? cur_global.Size : 0;
		if (!cur_global_size)
			continue;
		
		ArrayList cur_event = ConfigSys.GlobalEvents[type];
		if (!cur_event)
			ConfigSys.GlobalEvents[type] = cur_event = new ArrayList(sizeof(ConfigGlobalEvent_t));
		
		for (int cur_global_i = cur_global_size; cur_global_i >= 0; cur_global_i--)
		{
			ConfigMap event_sec = cur_global.GetIntSection(cur_global_i);
			if (!event_sec)
				continue;
			
			int function_name_size = event_sec.GetSize("procedure");
			char[] function_name = new char[function_name_size];
			event_sec.Get("procedure", function_name, function_name_size);

			// check if the module is imported externally
			int plugin_name_size = event_sec.GetSize("module");
			event_info.Plugin = myself;
			if (plugin_name_size)
			{
				char[] plugin_name = new char[plugin_name_size];
				event_sec.Get("module", plugin_name, plugin_name_size);
				if (!(event_info.Plugin = FindPluginByFile(plugin_name)))
				{
					LogError("[VSH2 CfgEvent] Plugin doesn't exists \"globals::%s::%s\".",  event_key, function_name);
					continue;
				}
			}

			if (!(event_info.Procedure = view_as<ConfigGlobalEvent_Proc>(GetFunctionByName(event_info.Plugin, function_name))))
			{
				LogError("[VSH2 CfgEvent] Function doesn't exists \"globals::%s::%s\".", event_key, function_name);
				continue;
			}

			event_info.Arguments = new EventMap(event_sec, event_info.Plugin);
			cur_event.PushArray(event_info);
		}

		if (!cur_event.Length)
			delete ConfigSys.GlobalEvents[type];
	}

	delete globals_iter;
}


bool ConfigEvent_ShouldExecuteWeapons(ConfigEventType_t type)
{
	if (ConfigSys.WeaponEvents[type])
	{
		ConfigSys.Params.Clear();
		return true;
	}
	else return false;
}

Action ConfigEvent_ExecuteWeapons(VSH2Player player, int client, ConfigEventType_t type)
{
	ArrayList cur_event = ConfigSys.WeaponEvents[type];
	ConfigWeaponEvent_t event_info;

	// grab the weapon id to check if we have it to execute the event
	int weapons[TF2WeaponSlot_MaxWeapons];
	for(int slot; slot < TF2WeaponSlot_MaxWeapons; slot++)
	{
		int weapon = GetPlayerWeaponSlot(client, slot);
		if (weapon == -1)
			continue;
		
		weapons[slot] = GetEntProp(weapon, Prop_Send, "m_iItemDefinitionIndex");
	}

	Action highest_ret = Plugin_Continue;
	bool is_minion = player.bIsMinion;
	int event_size = cur_event.Length;
	for (int i = 0; i < event_size; i++)
	{
		cur_event.GetArray(i, event_info);
		if (event_info.ItemID !=-1)
		{
			bool has_slot = false;

			for (int slot = 0; slot < sizeof(weapons); slot++)
			{
				if (weapons[slot] == event_info.ItemID)
				{
					has_slot = true;
					break;
				}
			}
			
			if (!has_slot)
				continue;
		}

		// Disallow minions from executing weapon's callbacks,
		bool minion_can_execute;
		if (!event_info.Arguments.GetBool("minion can execute", minion_can_execute, false) || (!minion_can_execute && is_minion))
			continue;

		Call_StartFunction(event_info.Plugin, event_info.Procedure);
		Call_PushCell(event_info.Arguments);
		Call_PushCell(type);
		Action ret;
		Call_Finish(ret);
		if (ret < view_as<Action>(Plugin_SkipN))
		{
			if (ret > highest_ret)
			{
				if ((highest_ret = ret) >= Plugin_Stop)
					break;
			}
		}
		else
		{
			int skip_delta = view_as<int>(ret) - Plugin_SkipN * 2;
			i += skip_delta;
			ClampValue(i, 0, event_size - 1);
		}
	}
	return highest_ret;
}

bool ConfigEvent_ShouldExecuteGlobals(ConfigEventType_t type)
{
	if (ConfigSys.GlobalEvents[type])
	{
		ConfigSys.Params.Clear();
		return true;
	}
	else return false;
}

Action ConfigEvent_ExecuteGlobals(ConfigEventType_t type)
{
	ArrayList cur_event = ConfigSys.GlobalEvents[type];
	ConfigGlobalEvent_t event_info;

	Action highest_ret = Plugin_Continue;
	int event_size = cur_event.Length;
	for (int i = 0; i < event_size; i++)
	{
		cur_event.GetArray(i, event_info);

		Call_StartFunction(event_info.Plugin, event_info.Procedure);
		Call_PushCell(event_info.Arguments);
		Call_PushCell(type);
		Action ret;
		Call_Finish(ret);
		if (ret < view_as<Action>(Plugin_SkipN))
		{
			if (ret > highest_ret)
			{
				if ((highest_ret = ret) >= Plugin_Stop)
					break;
			}
		}
		else
		{
			int skip_delta = view_as<int>(ret) - Plugin_SkipN * 2;
			i += skip_delta;
			ClampValue(i, 0, event_size - 1);
		}
	}
	return highest_ret;
}
