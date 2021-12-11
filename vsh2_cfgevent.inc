#if defined _vsh2_cfgevent_included
	#endinput
#endif
#define _vsh2_cfgevent_included

#include <vsh2>
#include <cfgmap>

enum ConfigEventType_t
{
	CET_Invalid = -1,
	CET_Download,

	CET_TouchPlayer,
	CET_BossTouchBuilding,
	CET_PlayerKilled,
	CET_PlayerAirblasted,
	CET_BossMedicCall,
	CET_BossTaunt,
	CET_BossKillBuilding,
	CET_BossJarated,
	CET_BossPickupItem,

	CET_UberDeploy,
	CET_UberLoop,
	CET_UberLoopEnd,

	CET_OnLastPlayer,
	CET_ControlPointCapped,
	CET_PrepRedTeam,
	CET_PlayerHurt,

	CET_BossDealDamage,
	CET_BDD_OnStomp,
	CET_BDD_OnHitDebuff,
	CET_BDD_OnHitCritMmph,
	CET_BDD_OnHitMedic,
	CET_BDD_OnDeadRinger,
	CET_BDD_OnCloakedSpy,
	CET_BDD_OnHitShield,

	CET_BTD_OnStabbed,
	CET_BTD_OnTelefragged,
	CET_BTD_OnSwordTaunt,
	CET_BTD_OnHeavyShotgun,
	CET_BTD_OnSniped,
	CET_BTD_OnThirdDegreed,
	CET_BTD_OnHitSword,
	CET_BTD_OnHitFanOWar,
	CET_BTD_OnHitCandyCane,
	CET_BTD_OnMarketGardened,
	CET_BTD_OnPowerJack,
	CET_BTD_OnKatana,
	CET_BTD_OnAmbassadorHeadshot,
	CET_BTD_OnDiamonBackManmelterCrit,
	CET_BTD_OnHolidayPunch,
	CET_BTD_OnTriggerHurt,
	CET_BTD_OnMantreadsStomps,

	CET_BossAirshotProj,
	CET_BannerDeployed,
	CET_BannerEffect,
	
	CET_RedPlayerThink,
	CET_RedPlayerHUD,
	CET_PlayerClimb,
	CET_RedPlayerCrits,
	CET_PlayerTakeFallDamage,
	CET_RedPlayerThinkPost,

	CET_Count
}

methodmap VSH2CfgEvent
{
	/**
	 * Reload the main plugin's config
	 */
	public static native void Refresh();

	/**
	 * Get the current event parameters
	 */
	public static native StringMap GetParams();
}

methodmap EventMap < ConfigMap
{
	public bool GetTargetEx(const char[] vsh2_target, const char[] target, int& calling_player_idx, VSH2Player& calling_player)
	{
		char target_str[12];
		// grab the calling player instance
		// 'vsh2player' and 'target' required and we can't execute the function without it
		if (!this.Get(vsh2_target, target_str, sizeof(target_str)) && !this.Get(target, target_str, sizeof(target_str)))
			return false;
		
		VSH2CfgEvent.GetParams().GetValue(target_str, calling_player);
		if (target_str[0] == 'v')
		{
			calling_player_idx = view_as<int>(calling_player);
			calling_player = calling_player_idx == -1 ? view_as<VSH2Player>(0) : VSH2Player(calling_player_idx);
		}
		else
		{
			calling_player_idx = calling_player ? calling_player.index : -1;
		}
		return true;
	}

	public bool GetTarget(int& calling_player_idx, VSH2Player& calling_player)
	{
		return this.GetTargetEx("vsh2target", "target", calling_player_idx, calling_player);
	}
}

public SharedPlugin __pl_vsh2 = {
	name = "VSH2",
	file = "vsh2.smx",
#if defined REQUIRE_PLUGIN
	required = 1,
#else
	required = 0,
#endif
};

#if !defined REQUIRE_PLUGIN
public void __pl_vsh2_SetNTVOptional()
{
	MarkNativeAsOptional("VSH2CfgEvent.Refresh");
	MarkNativeAsOptional("VSH2CfgEvent.GetParams");
}
#endif