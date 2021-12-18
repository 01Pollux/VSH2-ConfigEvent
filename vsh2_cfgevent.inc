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

	CET_ProjectileTouch,
	CET_EurakaTeleportCmd,
	CET_EurakaTeleportFin,

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
    /**
     * Get a single custom target/vsh2target
     *
     * @param vsh2_target           if it exists, use the target player as a VSH2Player
     * @param target                if it exists, use the target player as a client entity index
     * @param calling_player_idx    output client entity index
     * @param calling_player        output VSH2Player instance
     * @return                      true if any of the targets exists, false otherwise
     */
	public bool GetTargetEx(
        const char[] vsh2_target,
        const char[] target,
        int& calling_player_idx,
        VSH2Player& calling_player
    )
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

    /**
     * Get a single "target"/"vsh2target"
     *
     * @param calling_player_idx    output client entity index
     * @param calling_player        output VSH2Player instance
     * @return                      true if any of the targets exists, false otherwise
     */
	public bool GetTarget(int& calling_player_idx, VSH2Player& calling_player)
	{
		return this.GetTargetEx("vsh2target", "target", calling_player_idx, calling_player);
	}

    /**
     * Get a size of custom target/vsh2target array
     *
     * @param vsh2_target           if it exists, use the target player as a VSH2Player
     * @param target                if it exists, use the target player as a client entity index
     * @return                      size of the array
     */
	public int GetTargetArrSizeEx(
		const char[] vsh2_target,
		const char[] target
	)
	{
		ConfigMap targets_names;
		if (!(targets_names = this.GetSection(vsh2_target)))
		{
			if (!(targets_names = this.GetSection(target)))
				return 0;
		}
		return targets_names.Size;
	}

    /**
     * Get a size of "target"/"vsh2target" array
     *
     * @return                      size of the array
     */
	public int GetTargetArrSize()
	{
		return this.GetTargetArrSizeEx("vsh2target", "target");
	}

    /**
     * Get an array of custom target/vsh2target
     *
     * @param vsh2_target           if it exists, use the target player as a VSH2Player
     * @param target                if it exists, use the target player as a client entity index
     * @param calling_player_idx    output client entity index
     * @param calling_player        output VSH2Player instance
     * @return                      number of elements that were written to the array
     *
     * @note                        this function assumes that the size of output array is equal to GetTargetArrSize[Ex]()
     */
	public int GetTargetArrEx(
		const char[] vsh2_target,
		const char[] target,
		int[] calling_player_idx,
		VSH2Player[] calling_player
	)
	{
		ConfigMap targets_names;
		bool is_vsh2target = true;

		// grab the calling player instance
		// 'vsh2player' and 'target' required and we can't execute the function without it
		if (!(targets_names = this.GetSection(vsh2_target)))
		{
			is_vsh2target = false;
			if (!(targets_names = this.GetSection(target)))
				return 0;
		}

		int written_targets;
		char target_str[12];

		for (int i = targets_names.Size; i >= 0; i--)
		{
			targets_names.GetIntKey(i, target_str, sizeof(target_str));
			if (VSH2CfgEvent.GetParams().GetValue(target_str, calling_player[written_targets]))
			{
				if (is_vsh2target)
				{
					calling_player_idx[written_targets] = view_as<int>(calling_player[written_targets]);
					calling_player[written_targets] = calling_player_idx[written_targets] == -1 ?
						view_as<VSH2Player>(0) : VSH2Player(calling_player_idx[written_targets]);
				}
				else
				{
					calling_player_idx[written_targets] = calling_player[written_targets] ? calling_player[written_targets].index : -1;
				}

				++written_targets;
			}
		}
		return written_targets;
	}
    /**
     * Get an array of "target"/"vsh2target"
     *
     * @param calling_player_idx    output client entity index
     * @param calling_player        output VSH2Player instance
     * @return                      number of elements that were written to the array
     *
     * @note                        this function assumes that the size of output array is equal to GetTargetArrSize[Ex]()
     */
	public int GetTargetArr(int[] calling_player_idx, VSH2Player[] calling_player)
	{
		return this.GetTargetArrEx("vsh2target", "target", calling_player_idx, calling_player);
	}

    /**
     * Get a single custom target
     *
     * @param target                entity target key
     * @param target_ent_index      output entity index
     * @return                      true if the target exists, false otherwise
     */
	public bool GetTargetEntEx(const char[] target, int& target_ent_index)
	{
		char target_str[12];
		// grab the target entity index
		if (!this.Get(target, target_str, sizeof(target_str)))
			return false;

		return VSH2CfgEvent.GetParams().GetValue(target_str, target_ent_index);
	}

    /**
     * Get a single "target"
     *
     * @param target_ent_index      output entity index
     * @return                      true if the target exists, false otherwise
     */
	public bool GetTargetEnt(int& target_ent_index)
	{
		return this.GetTargetEntEx("enttarget", target_ent_index);
	}

    /**
     * Get a size of custom target array
     *
     * @return                      size of the array
     */
	public int GetTargetEntArrSizeEx(
		const char[] target
	)
	{
		ConfigMap targets_names;
		return (targets_names = this.GetSection(target)) ? targets_names.Size : 0;
	}

    /**
     * Get a size of "target" array
     *
     * @return                      size of the array
     */
	public int GetTargetEntArrSize()
	{
		return this.GetTargetEntArrSizeEx("enttarget");
	}

    /**
     * Get an array custom target/vsh2target
     *
     * @param target                entities target key
     * @param target_ent_index      output entity index
     * @return                      number of elements that were written to the array
     *
     * @note                        this function assumes that the size of output array is equal to GetTargetEntArrSize[Ex]()
     */
	public int GetTargetEntArrEx(const char[] target, int[] target_ent_index)
	{
		ConfigMap targets_names;

		// grab the target entity index
		if (!(targets_names = this.GetSection(target)))
			return 0;

		int written_targets;
		char target_str[12];

		for (int i = targets_names.Size; i >= 0; i--)
		{
			targets_names.GetIntKey(i, target_str, sizeof(target_str));
			if (VSH2CfgEvent.GetParams().GetValue(target_str, target_ent_index[written_targets]))
				++written_targets;
		}
		return written_targets;
	}

    /**
     * Get an array "target"
     *
     * @param target_ent_index      output entity index
     * @return                      number of elements that were written to the array
     *
     * @note                        this function assumes that the size of output array is equal to GetTargetEntArrSize[Ex]()
     */
	public int GetTargetEntArr(int[] target_ent_index)
	{
		return this.GetTargetEntArrEx("enttarget", target_ent_index);
	}
}

public SharedPlugin __pl_vsh2 = {
	name = "vsh2-configsys",
	file = "vsh2-configsys.smx",
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
