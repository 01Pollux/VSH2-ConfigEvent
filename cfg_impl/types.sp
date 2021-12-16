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
	CET_PlayerButton,

	CET_Count
}

ConfigEventType_t ConfigEvent_NameToType(const char[] name)
{
	static const char event_names[][] = {
		"downloads",

		"player_touch",
		"boss_building_touch",
		"player_killed",
		"player_airblasted",
		"boss_mediccall",
		"boss_taunt",
		"boss_building_kill",
		"boss_jarated",
		"boss_pickupitem",

		"uber_deploy",
		"uber_loop",
		"uber_end",

		"last_player",
		"cp_capped",
		"prep_redteam",
		"player_hurt",

		"boss_dealdmg",
		"bdg_stomp",
		"bdg_debuff_hit",
		"bdg_crit_mmph",
		"bdg_medic",
		"bdg_deadringer",
		"bdg_cloaked_spy",
		"bdg_shield_hit",

		"btd_stab",
		"btd_telefrag",
		"btd_decapitation",
		"btd_heavy_shotgun",
		"btd_sniped",
		"btd_thirddegreed",
		"btd_sword_hit",
		"btd_fanowar_hit",
		"btd_candycane_hit",
		"btd_marketgarden",
		"btd_powerjack",
		"btd_katana",
		"btd_ambasssador",
		"btd_diamondback_manmelter",
		"btd_holidaypunch",
		"btd_trigger_hurt",
		"btd_mantreads",

		"airshot_proj",
		"banner_start",
		"banner_effect",

		"think",
		"playerhud",
		"playerclimb",
		"playercrits",
		"falldamage",
		"thinkpost",

		"projectile_touch"
		"playerbutton"
	};

	for (int i = 0; i < sizeof(event_names); i++)
	{
		if (!strcmp(event_names[i], name))
			return view_as<ConfigEventType_t>(i);
	}

	return CET_Invalid;
}
