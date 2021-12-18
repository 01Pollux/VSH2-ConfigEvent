
#include "cfg_impl/vsh2hooks_btdmg.sp"
#include "cfg_impl/vsh2hooks_bddmg.sp"

#define VSH2_HOOK(%0) VSH2_Hook(%0, ConfigEvent_%0)
void ConfigEvent_LoadVSH2Hooks()
{
	VSH2_HOOK(OnCallDownloads);

	VSH2_HOOK(OnTouchPlayer);
	VSH2_HOOK(OnMinionInitialized);
	VSH2_HOOK(OnTouchBuilding);
	VSH2_HOOK(OnPlayerKilled);
	VSH2_HOOK(OnPlayerAirblasted);
	VSH2_HOOK(OnBossMedicCall);
	VSH2_HOOK(OnBossTaunt);
	VSH2_HOOK(OnBossKillBuilding);
	VSH2_HOOK(OnBossJarated);
	VSH2_HOOK(OnBossPickUpItem);
	VSH2_HOOK(OnVariablesReset);
	VSH2_HOOK(OnUberDeployed);
	VSH2_HOOK(OnUberLoop);
	VSH2_HOOK(OnLastPlayer);
	VSH2_HOOK(OnControlPointCapped);
	VSH2_HOOK(OnPrepRedTeam);
	VSH2_HOOK(OnPlayerHurt);

	VSH2_HOOK(OnBossDealDamage);
	VSH2_HOOK(OnBossDealDamage_OnStomp);
	VSH2_HOOK(OnBossDealDamage_OnHitDefBuff);
	VSH2_HOOK(OnBossDealDamage_OnHitCritMmmph);
	VSH2_HOOK(OnBossDealDamage_OnHitMedic);
	VSH2_HOOK(OnBossDealDamage_OnHitDeadRinger);
	VSH2_HOOK(OnBossDealDamage_OnHitCloakedSpy);
	VSH2_HOOK(OnBossDealDamage_OnHitShield);

	VSH2_HOOK(OnBossTakeDamage);
	VSH2_HOOK(OnBossTakeDamage_OnStabbed);
	VSH2_HOOK(OnBossTakeDamage_OnTelefragged);
	VSH2_HOOK(OnBossTakeDamage_OnSwordTaunt);
	VSH2_HOOK(OnBossTakeDamage_OnHeavyShotgun);
	VSH2_HOOK(OnBossTakeDamage_OnSniped);
	VSH2_HOOK(OnBossTakeDamage_OnThirdDegreed);
	VSH2_HOOK(OnBossTakeDamage_OnHitSword);
	VSH2_HOOK(OnBossTakeDamage_OnHitFanOWar);
	VSH2_HOOK(OnBossTakeDamage_OnHitCandyCane);
	VSH2_HOOK(OnBossTakeDamage_OnMarketGardened);
	VSH2_HOOK(OnBossTakeDamage_OnPowerJack);
	VSH2_HOOK(OnBossTakeDamage_OnKatana);
	VSH2_HOOK(OnBossTakeDamage_OnAmbassadorHeadshot);
	VSH2_HOOK(OnBossTakeDamage_OnDiamondbackManmelterCrit);
	VSH2_HOOK(OnBossTakeDamage_OnHolidayPunch);

	VSH2_HOOK(OnBossAirShotProj);
	VSH2_HOOK(OnBossTakeDamage_OnTriggerHurt);
	VSH2_HOOK(OnBossTakeDamage_OnMantreadsStomp);
	VSH2_HOOK(OnRedPlayerThink);
	VSH2_HOOK(OnPlayerTakeFallDamage);
	VSH2_HOOK(OnPlayerClimb);
	VSH2_HOOK(OnBannerDeployed);
	VSH2_HOOK(OnBannerEffect);
	VSH2_HOOK(OnUberLoopEnd);
	VSH2_HOOK(OnRedPlayerThinkPost);
	VSH2_HOOK(OnRedPlayerHUD);
	VSH2_HOOK(OnRedPlayerCrits);
}
#undef VSH2_HOOK

#define VSH2_UNHOOK(%0) VSH2_Unhook(%0, ConfigEvent_%0)
void ConfigEvent_UnloadVSH2Hooks()
{
	VSH2_UNHOOK(OnCallDownloads);

	VSH2_UNHOOK(OnTouchPlayer);
	VSH2_UNHOOK(OnMinionInitialized);
	VSH2_UNHOOK(OnTouchBuilding);
	VSH2_UNHOOK(OnPlayerKilled);
	VSH2_UNHOOK(OnPlayerAirblasted);
	VSH2_UNHOOK(OnBossMedicCall);
	VSH2_UNHOOK(OnBossTaunt);
	VSH2_UNHOOK(OnBossKillBuilding);
	VSH2_UNHOOK(OnBossJarated);
	VSH2_UNHOOK(OnBossPickUpItem);
	VSH2_UNHOOK(OnVariablesReset);
	VSH2_UNHOOK(OnUberDeployed);
	VSH2_UNHOOK(OnUberLoop);
	VSH2_UNHOOK(OnLastPlayer);
	VSH2_UNHOOK(OnControlPointCapped);
	VSH2_UNHOOK(OnPrepRedTeam);
	VSH2_UNHOOK(OnPlayerHurt);

	VSH2_UNHOOK(OnBossDealDamage);
	VSH2_UNHOOK(OnBossDealDamage_OnStomp);
	VSH2_UNHOOK(OnBossDealDamage_OnHitDefBuff);
	VSH2_UNHOOK(OnBossDealDamage_OnHitCritMmmph);
	VSH2_UNHOOK(OnBossDealDamage_OnHitMedic);
	VSH2_UNHOOK(OnBossDealDamage_OnHitDeadRinger);
	VSH2_UNHOOK(OnBossDealDamage_OnHitCloakedSpy);
	VSH2_UNHOOK(OnBossDealDamage_OnHitShield);

	VSH2_UNHOOK(OnBossTakeDamage);
	VSH2_UNHOOK(OnBossTakeDamage_OnStabbed);
	VSH2_UNHOOK(OnBossTakeDamage_OnTelefragged);
	VSH2_UNHOOK(OnBossTakeDamage_OnSwordTaunt);
	VSH2_UNHOOK(OnBossTakeDamage_OnHeavyShotgun);
	VSH2_UNHOOK(OnBossTakeDamage_OnSniped);
	VSH2_UNHOOK(OnBossTakeDamage_OnThirdDegreed);
	VSH2_UNHOOK(OnBossTakeDamage_OnHitSword);
	VSH2_UNHOOK(OnBossTakeDamage_OnHitFanOWar);
	VSH2_UNHOOK(OnBossTakeDamage_OnHitCandyCane);
	VSH2_UNHOOK(OnBossTakeDamage_OnMarketGardened);
	VSH2_UNHOOK(OnBossTakeDamage_OnPowerJack);
	VSH2_UNHOOK(OnBossTakeDamage_OnKatana);
	VSH2_UNHOOK(OnBossTakeDamage_OnAmbassadorHeadshot);
	VSH2_UNHOOK(OnBossTakeDamage_OnDiamondbackManmelterCrit);
	VSH2_UNHOOK(OnBossTakeDamage_OnHolidayPunch);

	VSH2_UNHOOK(OnBossAirShotProj);
	VSH2_UNHOOK(OnBossTakeDamage_OnTriggerHurt);
	VSH2_UNHOOK(OnBossTakeDamage_OnMantreadsStomp);
	VSH2_UNHOOK(OnRedPlayerThink);
	VSH2_UNHOOK(OnPlayerTakeFallDamage);
	VSH2_UNHOOK(OnPlayerClimb);
	VSH2_UNHOOK(OnBannerDeployed);
	VSH2_UNHOOK(OnBannerEffect);
	VSH2_UNHOOK(OnUberLoopEnd);
	VSH2_UNHOOK(OnRedPlayerThinkPost);
	VSH2_UNHOOK(OnRedPlayerHUD);
	VSH2_UNHOOK(OnRedPlayerCrits);
}
#undef VSH2_UNHOOK


void ConfigEvent_OnCallDownloads()
{
	if (ConfigEvent_ShouldExecuteGlobals(CET_Download))
		ConfigEvent_ExecuteGlobals(CET_Download);
}

/**
 * Keys:
 * [in] "victim": victim userid/vsh2player instance
 * [in] "toucher": toucher userid/vsh2player instance
 */
void ConfigEvent_OnTouchPlayer(const VSH2Player victim, const VSH2Player attacker)
{
	if (ConfigEvent_ShouldExecuteGlobals(CET_TouchPlayer))
	{
		ConfigSys.Params.SetValue("toucher", attacker);
		ConfigSys.Params.SetValue("victim", victim);
		ConfigEvent_ExecuteGlobals(CET_TouchPlayer);
	}
	if (ConfigEvent_ShouldExecuteWeapons(CET_TouchPlayer))
	{
		ConfigSys.Params.SetValue("toucher", attacker);
		ConfigSys.Params.SetValue("victim", victim);
		ConfigEvent_ExecuteWeapons(attacker, attacker.index, CET_TouchPlayer);
	}
}

void ConfigEvent_OnMinionInitialized(const VSH2Player minion, const VSH2Player vsh2_owner)
{
	// ./cfg_impl/modules/zombie.sp
	ConfigEvent_Zombie_Init(minion, vsh2_owner);
}

/**
 * Keys:
 * [in] "player" : boss userid/vsh2player instance
 * [in] "building" : building's entity index
 */
void ConfigEvent_OnTouchBuilding(const VSH2Player player, const int BuildingRef)
{
	if (ConfigEvent_ShouldExecuteGlobals(CET_BossTouchBuilding))
	{
		ConfigSys.Params.SetValue("player", player);
		ConfigSys.Params.SetValue("building", BuildingRef);
		ConfigEvent_ExecuteGlobals(CET_BossTouchBuilding);
	}
}

/**
 * Keys:
 * [in] "player" : attacker userid/vsh2player instance
 * [in] "victim" : victim userid/vsh2player instance
 * [in] "event" : event handle
 */
void ConfigEvent_OnPlayerKilled(const VSH2Player player, const VSH2Player victim, Event event)
{
	if (ConfigEvent_ShouldExecuteGlobals(CET_PlayerKilled))
	{
		ConfigSys.Params.SetValue("player", player);
		ConfigSys.Params.SetValue("victim", victim);
		ConfigSys.Params.SetValue("event", event);
		ConfigEvent_ExecuteGlobals(CET_PlayerKilled);
	}
}

/**
 * Keys:
 * [in] "player" : attacker userid/vsh2player instance
 * [in] "victim" : victim userid/vsh2player instance
 * [in] "event" : event handle
 */
void ConfigEvent_OnPlayerAirblasted(const VSH2Player airblaster, const VSH2Player airblasted, Event event)
{
	if (ConfigEvent_ShouldExecuteGlobals(CET_PlayerAirblasted))
	{
		ConfigSys.Params.SetValue("player", airblaster);
		ConfigSys.Params.SetValue("victim", airblasted);
		ConfigSys.Params.SetValue("event", event);
		ConfigEvent_ExecuteGlobals(CET_PlayerAirblasted);
	}
}

/**
 * Keys:
 * [in] "boss" : boss userid/vsh2player instance
 */
void ConfigEvent_OnBossMedicCall(const VSH2Player rager)
{
	if (ConfigEvent_ShouldExecuteGlobals(CET_BossMedicCall))
	{
		ConfigSys.Params.SetValue("boss", rager);
		ConfigEvent_ExecuteGlobals(CET_BossMedicCall);
	}
}

/**
 * Keys:
 * [in] "boss" : boss userid/vsh2player instance
 */
void ConfigEvent_OnBossTaunt(const VSH2Player rager)
{
	if (ConfigEvent_ShouldExecuteGlobals(CET_BossTaunt))
	{
		ConfigSys.Params.SetValue("boss", rager);
		ConfigEvent_ExecuteGlobals(CET_BossTaunt);
	}
}

/**
 * Keys:
 * [in] "player" : boss userid/vsh2player instance
 * [in] "building" : building's entity index
 * [in] "event" : event handle
 */
void ConfigEvent_OnBossKillBuilding(const VSH2Player attacker, const int building, Event event)
{
	if (ConfigEvent_ShouldExecuteGlobals(CET_BossKillBuilding))
	{
		ConfigSys.Params.SetValue("player", attacker);
		ConfigSys.Params.SetValue("building", building);
		ConfigSys.Params.SetValue("event", event);
		ConfigEvent_ExecuteGlobals(CET_BossKillBuilding);
	}
}

/**
 * Keys:
 * [in] "player" : attacker userid/vsh2player instance
 * [in] "victim" : victim userid/vsh2player instance
 * [in] "event" : event handle
 */
void ConfigEvent_OnBossJarated(const VSH2Player victim, const VSH2Player attacker)
{
	if (ConfigEvent_ShouldExecuteGlobals(CET_BossJarated))
	{
		ConfigSys.Params.SetValue("player", attacker);
		ConfigSys.Params.SetValue("victim", victim);
		ConfigEvent_ExecuteGlobals(CET_BossJarated);
	}
}

/**
 * Keys:
 * [in] "player" : attacker userid/vsh2player instance
 * [in] "item" : item's classname
 */
void ConfigEvent_OnBossPickUpItem(const VSH2Player player, const char item[64])
{
	if (ConfigEvent_ShouldExecuteGlobals(CET_BossPickupItem))
	{
		ConfigSys.Params.SetValue("player", player);
		ConfigSys.Params.SetString("item", item);
		ConfigEvent_ExecuteGlobals(CET_BossPickupItem);
	}
}

void ConfigEvent_OnVariablesReset(const VSH2Player player)
{
	// ./cfg_impl/modules/zombie.sp
	player.SetPropAny("bIsZombie", false);
	//./cfg_impl/modules/airblast.sp
	player.SetPropAny("bIsAirBlastLimited", false);
}

/**
 * Keys:
 * [in] "medic": the medic's userid
 * [in] "patient": the patient's userid, can be invalid
 */
void ConfigEvent_OnUberDeployed(const VSH2Player medic, const VSH2Player patient)
{
	if (ConfigEvent_ShouldExecuteGlobals(CET_UberDeploy))
	{
		ConfigSys.Params.SetValue("medic", medic);
		ConfigSys.Params.SetValue("patient", patient);
		ConfigEvent_ExecuteGlobals(CET_UberDeploy);
	}
	if (ConfigEvent_ShouldExecuteWeapons(CET_UberDeploy))
	{
		ConfigSys.Params.SetValue("medic", medic);
		ConfigSys.Params.SetValue("patient", patient);
		ConfigEvent_ExecuteWeapons(medic, medic.index, CET_UberDeploy);
	}
}

/**
 * Keys:
 * [in] "medic": the medic's userid
 * [in] "patient": the patient's userid, can be invalid
 */
void ConfigEvent_OnUberLoop(const VSH2Player medic, const VSH2Player patient)
{
	if (ConfigEvent_ShouldExecuteGlobals(CET_UberLoop))
	{
		ConfigSys.Params.SetValue("medic", medic);
		ConfigSys.Params.SetValue("patient", patient);
		ConfigEvent_ExecuteGlobals(CET_UberLoop);
	}
	if (ConfigEvent_ShouldExecuteWeapons(CET_UberLoop))
	{
		ConfigSys.Params.SetValue("medic", medic);
		ConfigSys.Params.SetValue("patient", patient);
		ConfigEvent_ExecuteWeapons(medic, medic.index, CET_UberLoop);
	}
}

/**
 * Keys:
 * [in] "player": player userid/vsh2player instance
 * [in] "boss": boss userid/vsh2player instance
 */
void ConfigEvent_OnLastPlayer(const VSH2Player boss, const VSH2Player attacker)
{
	if (ConfigEvent_ShouldExecuteGlobals(CET_OnLastPlayer))
	{
		ConfigSys.Params.SetValue("player", attacker);
		ConfigSys.Params.SetValue("boss", boss);
		ConfigEvent_ExecuteGlobals(CET_OnLastPlayer);
	}
	if (ConfigEvent_ShouldExecuteWeapons(CET_OnLastPlayer))
	{
		ConfigSys.Params.SetValue("player", attacker);
		ConfigSys.Params.SetValue("boss", boss);
		ConfigEvent_ExecuteWeapons(attacker, attacker.index, CET_OnLastPlayer);
	}
}

/**
 * Keys:
 * [in] "cappers": array of cappers
 * [in] "capper_count": sizeof "cappers"
 * [in] "team": team
 */
void ConfigEvent_OnControlPointCapped(char cappers[MAXPLAYERS+1], const int team, VSH2Player[] pcappers, const int capper_count)
{
	if (ConfigEvent_ShouldExecuteGlobals(CET_ControlPointCapped))
	{
		ConfigSys.Params.SetArray("cappers", pcappers, capper_count);
		ConfigSys.Params.SetValue("capper_count", capper_count);
		ConfigSys.Params.SetValue("team", team);
		ConfigEvent_ExecuteGlobals(CET_ControlPointCapped);
	}
}

/**
 * Keys:
 * [in] "player": player userid/vsh2player instance
 */
void ConfigEvent_OnPrepRedTeam(const VSH2Player player)
{
	if (ConfigEvent_ShouldExecuteGlobals(CET_PrepRedTeam))
	{
		ConfigSys.Params.SetValue("player", player);
		ConfigEvent_ExecuteGlobals(CET_PrepRedTeam);
	}
	if (ConfigEvent_ShouldExecuteWeapons(CET_PrepRedTeam))
	{
		ConfigSys.Params.SetValue("player", player);
		ConfigEvent_ExecuteWeapons(player, player.index, CET_PrepRedTeam);
	}
}

/**
 * Keys:
 * [in] "player" : attacker's userid/vsh2player instance
 * [in] "victim" : victim's userid/vsh2player instance
 * [in] "event" : event handle
 */
void ConfigEvent_OnPlayerHurt(const VSH2Player player, const VSH2Player victim, Event event)
{
	if (ConfigEvent_ShouldExecuteGlobals(CET_PlayerHurt))
	{
		ConfigSys.Params.SetValue("player", player);
		ConfigSys.Params.SetValue("victim", victim);
		ConfigSys.Params.SetValue("event", event);
		ConfigEvent_ExecuteGlobals(CET_PlayerHurt);
	}
}

void ConfigEvent_OnRedPlayerThink(const VSH2Player player)
{
	int player_index = player.index;
	if (!player_index || !IsPlayerAlive(player_index))
		return;

	ConfigEvent_Zombie_Think(player, player_index);
	ConfigEvent_AirBlast_Think(player);
	ConfigEvent_OnAimEnemy(player, player_index);
	if (ConfigEvent_ShouldExecuteGlobals(CET_RedPlayerThink))
	{
		ConfigSys.Params.SetValue("player", player);
		ConfigEvent_ExecuteGlobals(CET_RedPlayerThink);
	}
	if (ConfigEvent_ShouldExecuteWeapons(CET_RedPlayerThink))
	{
		ConfigSys.Params.SetValue("player", player);
		ConfigEvent_ExecuteWeapons(player, player.index, CET_RedPlayerThink);
	}
}

/**
 * Keys:
 * [in] "player" : aimer's userid/vsh2player instance
 * [in] "target" : target's userid/vsh2player instance
 */
void ConfigEvent_OnAimEnemy(const VSH2Player player, const int player_index)
{
	int aimtarget = GetClientAimTarget(player_index, true);
	if (aimtarget < 0)
		return;

	VSH2Player target = VSH2Player(aimtarget);
	if (!target.GetPropInt("bIsBoss") && !target.GetPropAny("bIsMinion"))	//aiming at redplayer
		return;

	if (ConfigEvent_ShouldExecuteGlobals(CET_AimAtEnemy))
	{
		ConfigSys.Params.SetValue("player", player);
		ConfigSys.Params.SetValue("target", target);
		ConfigEvent_ExecuteGlobals(CET_AimAtEnemy);
	}
	if (ConfigEvent_ShouldExecuteWeapons(CET_AimAtEnemy))
	{
		ConfigSys.Params.SetValue("player", player);
		ConfigSys.Params.SetValue("target", target);
		ConfigEvent_ExecuteWeapons(player, player.index, CET_AimAtEnemy);
	}
}

/**
 * Keys:
 * [in] "player"
 * [in/out] "attacker"
 * [in/out] "inflictor"
 * [in/out] "damage"
 *
 * Return:
 * Plugin_Continue: ignore the new params
 * Plugin_Changed: rewrite the params and don't do vsh2's internal damage calculations
 */
Action ConfigEvent_OnPlayerTakeFallDamage(
	VSH2Player victim,
	int& attacker,
	int& inflictor,
	float& damage,
	int& damagetype,
	int& weapon,
	float damageForce[3],
	float damagePosition[3],
	int damagecustom
)
{
	if (ConfigEvent_ShouldExecuteGlobals(CET_PlayerTakeFallDamage))
	{
		ConfigSys.Params.SetValue("player", victim);
		ConfigSys.Params.SetValue("attacker", attacker);
		ConfigSys.Params.SetValue("inflictor", inflictor);
		ConfigSys.Params.SetValue("damage", damage);
		Action ret = ConfigEvent_ExecuteGlobals(CET_PlayerTakeFallDamage);
		switch (ret)
		{
			case Plugin_Continue: { }
			default:
			{
				ConfigSys.Params.GetValue("attacker", attacker);
				ConfigSys.Params.GetValue("inflictor", inflictor);
				ConfigSys.Params.GetValue("damage", damage);
				return ret;
			}
		}
	}
	if (ConfigEvent_ShouldExecuteWeapons(CET_PlayerTakeFallDamage))
	{
		ConfigSys.Params.SetValue("player", victim);
		ConfigSys.Params.SetValue("attacker", attacker);
		ConfigSys.Params.SetValue("inflictor", inflictor);
		ConfigSys.Params.SetValue("damage", damage);
		Action ret = ConfigEvent_ExecuteWeapons(victim, victim.index, CET_PlayerTakeFallDamage);
		switch (ret)
		{
			case Plugin_Continue: { }
			default:
			{
				ConfigSys.Params.GetValue("attacker", attacker);
				ConfigSys.Params.GetValue("inflictor", inflictor);
				ConfigSys.Params.GetValue("damage", damage);
				return ret;
			}
		}
	}
	return Plugin_Continue;
}

/**
 * Keys:
 * [in] "player"
 * [in/out] "upwardvel"
 * [in/out] "health"
 * [in/out] "attackdelay"
 *
 * Return:
 * Plugin_Continue: ignore the new params
 * Plugin_Changed: rewritethe params
 * Plugin_Handled, Plugin_Stop: don't call the original function
 */
Action ConfigEvent_OnPlayerClimb(const VSH2Player player, const int weapon, float& upwardvel, float& health, bool& attackdelay)
{
	if (ConfigEvent_ShouldExecuteGlobals(CET_PlayerClimb))
	{
		ConfigSys.Params.SetValue("player", player);
		ConfigSys.Params.SetValue("upwardvel", upwardvel);
		ConfigSys.Params.SetValue("health", health);
		ConfigSys.Params.SetValue("attack_delay", attackdelay);
		switch (ConfigEvent_ExecuteGlobals(CET_PlayerClimb))
		{
			case Plugin_Continue: { }
			case Plugin_Changed:
			{
				ConfigSys.Params.GetValue("upwardvel", upwardvel);
				ConfigSys.Params.GetValue("health", health);
				ConfigSys.Params.GetValue("health", attackdelay);
				return Plugin_Changed;
			}
		}
	}
	if (ConfigEvent_ShouldExecuteWeapons(CET_PlayerClimb))
	{
		ConfigSys.Params.SetValue("player", player);
		ConfigSys.Params.SetValue("upwardvel", upwardvel);
		ConfigSys.Params.SetValue("health", health);
		ConfigSys.Params.SetValue("attack_delay", attackdelay);
		switch (ConfigEvent_ExecuteWeapons(player, player.index, CET_PlayerClimb))
		{
			case Plugin_Changed:
			{
				ConfigSys.Params.GetValue("upwardvel", upwardvel);
				ConfigSys.Params.GetValue("health", health);
				ConfigSys.Params.GetValue("health", attackdelay);
				return Plugin_Changed;
			}
			case Plugin_Handled, Plugin_Stop: return Plugin_Handled;
		}
	}
	return Plugin_Continue;
}

/**
 * Keys:
 * [in] "owner"
 * [in] "type": the type of the banner
 */
Action ConfigEvent_OnBannerDeployed(const VSH2Player owner, const BannerType banner)
{
	if (ConfigEvent_ShouldExecuteGlobals(CET_BannerDeployed))
	{
		ConfigSys.Params.SetValue("owner", owner);
		ConfigSys.Params.SetValue("type", banner);
		ConfigEvent_ExecuteGlobals(CET_BannerDeployed);
	}
	if (ConfigEvent_ShouldExecuteWeapons(CET_BannerDeployed))
	{
		ConfigSys.Params.SetValue("owner", owner);
		ConfigSys.Params.SetValue("type", banner);
		ConfigEvent_ExecuteWeapons(owner, owner.index, CET_BannerDeployed);
	}
	return Plugin_Continue;
}

/**
 * Keys:
 * [in] "owner"
 * [in] "player": the played that's being buffed
 * [in] "type": the type of the banner
 */
Action ConfigEvent_OnBannerEffect(const VSH2Player player, const VSH2Player owner, const BannerType banner)
{
	if (ConfigEvent_ShouldExecuteGlobals(CET_BannerEffect))
	{
		ConfigSys.Params.SetValue("owner", owner);
		ConfigSys.Params.SetValue("player", player);
		ConfigSys.Params.SetValue("type", banner);
		ConfigEvent_ExecuteGlobals(CET_BannerEffect);
	}
	if (ConfigEvent_ShouldExecuteWeapons(CET_BannerEffect))
	{
		ConfigSys.Params.SetValue("owner", owner);
		ConfigSys.Params.SetValue("type", banner);
		ConfigSys.Params.SetValue("player", player);
		ConfigEvent_ExecuteWeapons(owner, owner.index, CET_BannerEffect);
	}
	return Plugin_Continue;
}

/**
 * Keys:
 * [in] "medic": medic's userid
 * [in] "patient": the patient's userid, can be invalid
 * [out] "new_charge" : the return value charge
 *
 * Return:
 * Plugin_Continue: ignore the new charge
 * Plugin_Changed: add the outgoing charge to the incoming one
 * default: override the outgoing charge
 */
Action ConfigEvent_OnUberLoopEnd(const VSH2Player medic, const VSH2Player target, float& reset_charge)
{
	if (ConfigEvent_ShouldExecuteGlobals(CET_UberLoopEnd))
	{
		ConfigSys.Params.SetValue("medic", medic);
		ConfigSys.Params.SetValue("patient", target);
		Action ret = ConfigEvent_ExecuteGlobals(CET_UberLoopEnd);

		switch (ret)
		{
			case Plugin_Continue: { }
			default:
			{
				float tmp;
				if (ConfigSys.Params.GetValue("new_charge", tmp))
					reset_charge = tmp;
				if (ret == Plugin_Changed)
					reset_charge += tmp;
				else
					reset_charge = tmp;
			}
		}
	}
	if (ConfigEvent_ShouldExecuteWeapons(CET_UberLoopEnd))
	{
		ConfigSys.Params.SetValue("patient", target);
		Action ret = ConfigEvent_ExecuteWeapons(medic, medic.index, CET_UberLoopEnd);

		switch (ret)
		{
			case Plugin_Continue: { }
			default:
			{
				float tmp;
				if (ConfigSys.Params.GetValue("new_charge", tmp))
					reset_charge = tmp;
				if (ret == Plugin_Changed)
					reset_charge += tmp;
				else
					reset_charge = tmp;
			}
		}
	}
	return Plugin_Continue;
}

void ConfigEvent_OnRedPlayerThinkPost(const VSH2Player player)
{
	if (ConfigEvent_ShouldExecuteGlobals(CET_RedPlayerThinkPost))
	{
		ConfigSys.Params.SetValue("player", player);
		ConfigEvent_ExecuteGlobals(CET_RedPlayerThinkPost);
	}
	if (ConfigEvent_ShouldExecuteWeapons(CET_RedPlayerThinkPost))
	{
		ConfigSys.Params.SetValue("player", player);
		ConfigEvent_ExecuteWeapons(player, player.index, CET_RedPlayerThinkPost);
	}
}

/**
 * Keys:
 * [in] "player": player's userid
 * [out] "new_text": new hud string
 *
 * Return:
 * Plugin_Continue: ignore the new string
 * Plugin_Changed: concat the return string into 'hud_test'
 * Plugin_Handled: concat 'hud_text' info the return string
 * Plugin_Stop: override 'hud_test'
 */
Action ConfigEvent_OnRedPlayerHUD(const VSH2Player player, char hud_text[PLAYER_HUD_SIZE])
{
	if (ConfigEvent_ShouldExecuteGlobals(CET_RedPlayerThinkPost))
	{
		ConfigSys.Params.SetValue("player", player);
		Action ret = ConfigEvent_ExecuteGlobals(CET_RedPlayerThinkPost);
		switch (ret)
		{
			case Plugin_Continue: { }
			case Plugin_Stop:
			{
				ConfigSys.Params.GetString("new_text", hud_text, sizeof(hud_text));
				return Plugin_Changed;
			}
			default:
			{
				char ret_str[PLAYER_HUD_SIZE / 2];
				ConfigSys.Params.GetString("new_text", ret_str, sizeof(ret_str));
				if (ret == Plugin_Handled)
					Format(hud_text, sizeof(hud_text), "%s%s", ret_str, hud_text);
				else
					Format(hud_text, sizeof(hud_text), "%s%s", hud_text, ret_str);
				return Plugin_Changed;
			}
		}
	}
	if (ConfigEvent_ShouldExecuteWeapons(CET_RedPlayerHUD))
	{
		ConfigSys.Params.SetValue("player", player);
		Action ret = ConfigEvent_ExecuteWeapons(player, player.index, CET_RedPlayerHUD);
		switch (ret)
		{
			case Plugin_Continue: { }
			case Plugin_Stop:
			{
				ConfigSys.Params.GetString("new_text", hud_text, sizeof(hud_text));
				return Plugin_Changed;
			}
			default:
			{
				char ret_str[PLAYER_HUD_SIZE / 2];
				ConfigSys.Params.GetString("new_text", ret_str, sizeof(ret_str));
				if (ret == Plugin_Handled)
					Format(hud_text, sizeof(hud_text), "%s%s", ret_str, hud_text);
				else
					Format(hud_text, sizeof(hud_text), "%s%s", hud_text, ret_str);
				return Plugin_Changed;
			}
		}
	}
	return Plugin_Continue;
}

/**
 * Keys:
 * [in] "player": player's userid
 * [in/out] "crit_flags": type of crits
 *
 * Return:
 * Plugin_Continue: ignore the new flags
 * default: override the crit flags
 */
Action ConfigEvent_OnRedPlayerCrits(const VSH2Player player, int& crit_flags)
{
	if (ConfigEvent_ShouldExecuteGlobals(CET_RedPlayerCrits))
	{
		ConfigSys.Params.SetValue("player", player);
		ConfigSys.Params.SetValue("crit_flags", crit_flags);

		Action ret = ConfigEvent_ExecuteGlobals(CET_RedPlayerCrits);
		switch (ret)
		{
			case Plugin_Continue: { }
			default:
			{
				ConfigSys.Params.GetValue("crit_flags", crit_flags);
				return Plugin_Changed;
			}
		}
	}
	if (ConfigEvent_ShouldExecuteWeapons(CET_RedPlayerCrits))
	{
		ConfigSys.Params.SetValue("player", player);
		ConfigSys.Params.SetValue("crit_flags", crit_flags);

		Action ret = ConfigEvent_ExecuteWeapons(player, player.index, CET_RedPlayerCrits);
		switch (ret)
		{
			case Plugin_Continue: { }
			default:
			{
				ConfigSys.Params.GetValue("crit_flags", crit_flags);
				return Plugin_Changed;
			}
		}
	}

	return Plugin_Continue;
}
