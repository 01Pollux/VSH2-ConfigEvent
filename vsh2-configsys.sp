#include <sdktools>
#include <vsh2>
#include <cfgmap>

#pragma semicolon 1
#pragma newdecls required

#include "cfg_impl/types.sp"
#include "cfg_impl/utils.sp"
#include "cfg_impl/config.sp"
#include "cfg_impl/vsh2hooks.sp"

#include "cfg_impl/formula_parser.sp"
#include "cfg_impl/modules.sp"

public Plugin myinfo =
{
	name		 = "VSH2 Config Event",
	author		 = "01Pollux",
	description	= "Manage VSH2's events with config",
	version		= "1.0.0"
};

public void OnPluginStart()
{
	RegAdminCmd("vsh2_cfgevent_reload", OnReloadConfig, ADMFLAG_ROOT, "Reload VSH2-Configsystem");
}

static stock Action OnReloadConfig(int client, int argc)
{
	ConfigEvent_Unload();
	ConfigEvent_Load();
	ReplyToCommand(client, "[VSH2 CfgEvent] Successfully reloaded config.");
	return Plugin_Handled;
}

public void OnLibraryAdded(const char[] lib_name)
{
	if (!strcmp(lib_name, "VSH2"))
	{
		ConfigEvent_Load();
		ConfigEvent_LoadVSH2Hooks();
	}
}

public void OnLibraryRemoved(const char[] lib_name)
{
	if (!strcmp(lib_name, "VSH2"))
	{
		ConfigEvent_UnloadVSH2Hooks();
		ConfigEvent_Unload();
	}
}
