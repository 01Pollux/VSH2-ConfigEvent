#include <sdktools>
#include <sdkhooks>
#include <vsh2>
#include <cfgmap>
#tryinclude <tf2attributes>

#pragma semicolon 1
#pragma newdecls required

#include "cfg_impl/types.sp"
#include "cfg_impl/utils.sp"
#include "cfg_impl/config.sp"
#include "cfg_impl/vsh2hooks.sp"
#include "cfg_impl/sdkhooks.sp"
#include "cfg_impl/sdktools.sp"

#include "cfg_impl/formula_parser.sp"
#include "cfg_impl/modules.sp"

#include "cfg_impl/vsh2_stocks.inc"

public Plugin myinfo =
{
	name		 = "VSH2 Config Event",
	author		 = "01Pollux",
	description	= "Manage VSH2's events with config",
	version		= "1.0.0"
};

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
	CreateNative("VSH2CfgEvent.Refresh", Native_Refresh);
	CreateNative("VSH2CfgEvent.GetParams", Native_GetCurrentParams);
}

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

public void NextFrame_InitVSH2Player(int client)
{
	if (LibraryExists("VSH2"))
	{
		VSH2Player player = VSH2Player(client);

		// ./cfg_impl/modules/zombie.sp
		player.SetPropAny("bIsZombie", false);
	}
}

public void OnClientPutInServer(int client)
{
	RequestFrame(NextFrame_InitVSH2Player, client);
}


any Native_Refresh(Handle plugin, int numParams)
{
	ConfigEvent_Unload();
	ConfigEvent_Load();
	return 0;
}

any Native_GetCurrentParams(Handle plugin, int numParams)
{
	return ConfigSys.Params;
}
