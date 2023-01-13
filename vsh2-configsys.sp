#include <sdktools>
#include <sdkhooks>
#include <vsh2>
#include <cfgmap>
#include <tf2attributes>
#include <tf2utils>

#pragma semicolon 1
#pragma newdecls required

#include "cfg_impl/types.sp"
#include "cfg_impl/utils.sp"
#include "cfg_impl/config.sp"
#include "cfg_impl/vsh2hooks.sp"
#include "cfg_impl/sdkhooks.sp"
#include "cfg_impl/console_usermessage.sp"

#include "cfg_impl/formula_parser.sp"
#include "cfg_impl/modules.sp"

#include "cfg_impl/vsh2_stocks.inc"

public Plugin myinfo =
{
	name		= "VSH2 Config Event",
	author		= "01Pollux, HotoCocoaco",
	description	= "Manage VSH2's events with config",
	version		= "1.0.0"
};

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
	CreateNative("VSH2CfgEvent.Refresh", Native_Refresh);
	CreateNative("VSH2CfgEvent.GetParams", Native_GetCurrentParams);
	return APLRes_Success;
}

public void OnPluginStart()
{
	RegAdminCmd("vsh2_cfgevent_reload", OnReloadConfig, ADMFLAG_ROOT, "Reload VSH2-Configsystem");

	AddCommandListener(Console_EurakaTeleportCommand, "eureka_teleport");
	HookUserMessage(GetUserMessageId("PlayerTeleportHomeEffect"), OnTeleportHomeMessage, true);
}

static stock Action OnReloadConfig(int client, int argc)
{
	ConfigEvent_Unload();
	ConfigEvent_Load();
	if (ConfigEvent_ShouldExecuteGlobals(CET_ResetVSH2Vars))
	{
		for (int i = 1; i <= MaxClients; i++)
		{
			if (IsClientInGame(i))
			{
				ConfigSys.Params.Clear();
				ConfigSys.Params.SetValue("player", VSH2Player(i));
				ConfigEvent_ExecuteGlobals(CET_ResetVSH2Vars);
			}
		}
	}
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
		// ./cfg_impl/modules/airblast.sp
		player.SetPropAny("bIsAirBlastLimited", false);

		if (ConfigEvent_ShouldExecuteGlobals(CET_ResetVSH2Vars))
		{
			ConfigSys.Params.SetValue("player", player);
			ConfigEvent_ExecuteGlobals(CET_ResetVSH2Vars);
		}
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
	if (ConfigEvent_ShouldExecuteGlobals(CET_ResetVSH2Vars))
	{
		for (int i = 1; i <= MaxClients; i++)
		{
			if (IsClientInGame(i))
			{
				ConfigSys.Params.Clear();
				ConfigSys.Params.SetValue("player", VSH2Player(i));
				ConfigEvent_ExecuteGlobals(CET_ResetVSH2Vars);
			}
		}
	}
	return 0;
}

any Native_GetCurrentParams(Handle plugin, int numParams)
{
	return ConfigSys.Params;
}
