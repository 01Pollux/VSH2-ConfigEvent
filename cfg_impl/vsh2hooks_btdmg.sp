/**
 * Keys:
 * [in] "victim" : victim userid/vsh2player instance
 * [in] "player" : attacker's entity index
 * [in/out] "damage"
 *
 * Return:
 * Plugin_Continue: ignore the new damage
 * default: rewrite the new damage, returning 'Plugin_Handled' will halt function execution for weapons
 */

Action ConfigEvent_OnBossTakeDamage(
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
	if (0 < attacker <= MaxClients)
	{
		VSH2Player player = VSH2Player(attacker);	//player = attacker
		if (player != victim)	//not a self damage
		{
			if (player.GetPropAny("bIsZombie"))
			{
				ConfigMap section = view_as<ConfigMap>(player.GetPropAny("_cfgsys_minion_section"));
				float steal_hp; section.GetFloat("vampire", steal_hp);
				float reduct; section.GetFloat("weak", reduct);
				if (steal_hp)
					player.iHealth = RoundToCeil(damage / steal_hp);
				if (reduct)
					damage /= reduct;
			}
			if (ConfigEvent_ShouldExecuteGlobals(CET_BTD_OnTakeDamage))
			{
				ConfigSys.Params.SetValue("victim", victim);
				ConfigSys.Params.SetValue("player", attacker);
				ConfigSys.Params.SetValue("damage", damage);
				Action ret = ConfigEvent_ExecuteGlobals(CET_BTD_OnTakeDamage);
				switch (ret)
				{
					case Plugin_Continue: { }
					default:
					{
						ConfigSys.Params.GetValue("damage", damage);
						if (ret >= Plugin_Handled)
							return ret;
					}
				}
			}
			if (ConfigEvent_ShouldExecuteWeapons(CET_BTD_OnTakeDamage))
			{
				ConfigSys.Params.SetValue("victim", victim);
				ConfigSys.Params.SetValue("player", attacker);
				ConfigSys.Params.SetValue("damage", damage);
				Action ret = ConfigEvent_ExecuteWeapons(player, attacker, CET_BTD_OnTakeDamage);
				switch (ret)
				{
					case Plugin_Continue: { }
					default:
					{
						ConfigSys.Params.GetValue("damage", damage);
						return ret;
					}
				}
			}
		}
	}
	return Plugin_Continue;
}

Action ConfigEvent_OnBossTakeDamage_OnStabbed(
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
	if (ConfigEvent_ShouldExecuteGlobals(CET_BTD_OnStabbed))
	{
		ConfigSys.Params.SetValue("victim", victim);
		ConfigSys.Params.SetValue("player", attacker);
		ConfigSys.Params.SetValue("damage", damage);
		Action ret = ConfigEvent_ExecuteGlobals(CET_BTD_OnStabbed);
		switch (ret)
		{
			case Plugin_Continue: { }
			default:
			{
				ConfigSys.Params.GetValue("damage", damage);
				if (ret >= Plugin_Handled)
					return ret;
			}
		}
	}
	if (ConfigEvent_ShouldExecuteWeapons(CET_BTD_OnStabbed))
	{
		ConfigSys.Params.SetValue("victim", victim);
		ConfigSys.Params.SetValue("player", attacker);
		ConfigSys.Params.SetValue("damage", damage);
		Action ret = ConfigEvent_ExecuteWeapons(VSH2Player(attacker), attacker, CET_BTD_OnStabbed);
		switch (ret)
		{
			case Plugin_Continue: { }
			default:
			{
				ConfigSys.Params.GetValue("damage", damage);
				return ret;
			}
		}
	}
	return Plugin_Continue;
}

Action ConfigEvent_OnBossTakeDamage_OnTelefragged(
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
	if (ConfigEvent_ShouldExecuteGlobals(CET_BTD_OnTelefragged))
	{
		ConfigSys.Params.SetValue("victim", victim);
		ConfigSys.Params.SetValue("player", attacker);
		ConfigSys.Params.SetValue("damage", damage);
		Action ret = ConfigEvent_ExecuteGlobals(CET_BTD_OnTelefragged);
		switch (ret)
		{
			case Plugin_Continue: { }
			default:
			{
				ConfigSys.Params.GetValue("damage", damage);
				if (ret >= Plugin_Handled)
					return ret;
			}
		}
	}
	if (ConfigEvent_ShouldExecuteWeapons(CET_BTD_OnTelefragged))
	{
		ConfigSys.Params.SetValue("victim", victim);
		ConfigSys.Params.SetValue("player", attacker);
		ConfigSys.Params.SetValue("damage", damage);
		Action ret = ConfigEvent_ExecuteWeapons(VSH2Player(attacker), attacker, CET_BTD_OnTelefragged);
		switch (ret)
		{
			case Plugin_Continue: { }
			default:
			{
				ConfigSys.Params.GetValue("damage", damage);
				return ret;
			}
		}
	}
	return Plugin_Continue;
}

Action ConfigEvent_OnBossTakeDamage_OnSwordTaunt(
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
	if (ConfigEvent_ShouldExecuteGlobals(CET_BTD_OnSwordTaunt))
	{
		ConfigSys.Params.SetValue("victim", victim);
		ConfigSys.Params.SetValue("player", attacker);
		ConfigSys.Params.SetValue("damage", damage);
		Action ret = ConfigEvent_ExecuteGlobals(CET_BTD_OnSwordTaunt);
		switch (ret)
		{
			case Plugin_Continue: { }
			default:
			{
				ConfigSys.Params.GetValue("damage", damage);
				if (ret >= Plugin_Handled)
					return ret;
			}
		}
	}
	if (ConfigEvent_ShouldExecuteWeapons(CET_BTD_OnSwordTaunt))
	{
		ConfigSys.Params.SetValue("victim", victim);
		ConfigSys.Params.SetValue("player", attacker);
		ConfigSys.Params.SetValue("damage", damage);
		Action ret = ConfigEvent_ExecuteWeapons(VSH2Player(attacker), attacker, CET_BTD_OnSwordTaunt);
		switch (ret)
		{
			case Plugin_Continue: { }
			default:
			{
				ConfigSys.Params.GetValue("damage", damage);
				return ret;
			}
		}
	}
	return Plugin_Continue;
}

Action ConfigEvent_OnBossTakeDamage_OnHeavyShotgun(
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
	if (ConfigEvent_ShouldExecuteGlobals(CET_BTD_OnHeavyShotgun))
	{
		ConfigSys.Params.SetValue("victim", victim);
		ConfigSys.Params.SetValue("player", attacker);
		ConfigSys.Params.SetValue("damage", damage);
		Action ret = ConfigEvent_ExecuteGlobals(CET_BTD_OnHeavyShotgun);
		switch (ret)
		{
			case Plugin_Continue: { }
			default:
			{
				ConfigSys.Params.GetValue("damage", damage);
				if (ret >= Plugin_Handled)
					return ret;
			}
		}
	}
	if (ConfigEvent_ShouldExecuteWeapons(CET_BTD_OnHeavyShotgun))
	{
		ConfigSys.Params.SetValue("victim", victim);
		ConfigSys.Params.SetValue("player", attacker);
		ConfigSys.Params.SetValue("damage", damage);
		Action ret = ConfigEvent_ExecuteWeapons(VSH2Player(attacker), attacker, CET_BTD_OnHeavyShotgun);
		switch (ret)
		{
			case Plugin_Continue: { }
			default:
			{
				ConfigSys.Params.GetValue("damage", damage);
				return ret;
			}
		}
	}
	return Plugin_Continue;
}

Action ConfigEvent_OnBossTakeDamage_OnSniped(
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
	if (ConfigEvent_ShouldExecuteGlobals(CET_BTD_OnSniped))
	{
		ConfigSys.Params.SetValue("victim", victim);
		ConfigSys.Params.SetValue("player", attacker);
		ConfigSys.Params.SetValue("damage", damage);
		Action ret = ConfigEvent_ExecuteGlobals(CET_BTD_OnSniped);
		switch (ret)
		{
			case Plugin_Continue: { }
			default:
			{
				ConfigSys.Params.GetValue("damage", damage);
				if (ret >= Plugin_Handled)
					return ret;
			}
		}
	}
	if (ConfigEvent_ShouldExecuteWeapons(CET_BTD_OnSniped))
	{
		ConfigSys.Params.SetValue("victim", victim);
		ConfigSys.Params.SetValue("player", attacker);
		ConfigSys.Params.SetValue("damage", damage);
		Action ret = ConfigEvent_ExecuteWeapons(VSH2Player(attacker), attacker, CET_BTD_OnSniped);
		switch (ret)
		{
			case Plugin_Continue: { }
			default:
			{
				ConfigSys.Params.GetValue("damage", damage);
				return ret;
			}
		}
	}
	return Plugin_Continue;
}

Action ConfigEvent_OnBossTakeDamage_OnThirdDegreed(
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
	if (ConfigEvent_ShouldExecuteGlobals(CET_BTD_OnThirdDegreed))
	{
		ConfigSys.Params.SetValue("victim", victim);
		ConfigSys.Params.SetValue("player", attacker);
		ConfigSys.Params.SetValue("damage", damage);
		Action ret = ConfigEvent_ExecuteGlobals(CET_BTD_OnThirdDegreed);
		switch (ret)
		{
			case Plugin_Continue: { }
			default:
			{
				ConfigSys.Params.GetValue("damage", damage);
				if (ret >= Plugin_Handled)
					return ret;
			}
		}
	}
	if (ConfigEvent_ShouldExecuteWeapons(CET_BTD_OnThirdDegreed))
	{
		ConfigSys.Params.SetValue("victim", victim);
		ConfigSys.Params.SetValue("player", attacker);
		ConfigSys.Params.SetValue("damage", damage);
		Action ret = ConfigEvent_ExecuteWeapons(VSH2Player(attacker), attacker, CET_BTD_OnThirdDegreed);
		switch (ret)
		{
			case Plugin_Continue: { }
			default:
			{
				ConfigSys.Params.GetValue("damage", damage);
				return ret;
			}
		}
	}
	return Plugin_Continue;
}

Action ConfigEvent_OnBossTakeDamage_OnHitSword(
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
	if (ConfigEvent_ShouldExecuteGlobals(CET_BTD_OnHitSword))
	{
		ConfigSys.Params.SetValue("victim", victim);
		ConfigSys.Params.SetValue("player", attacker);
		ConfigSys.Params.SetValue("damage", damage);
		Action ret = ConfigEvent_ExecuteGlobals(CET_BTD_OnHitSword);
		switch (ret)
		{
			case Plugin_Continue: { }
			default:
			{
				ConfigSys.Params.GetValue("damage", damage);
				if (ret >= Plugin_Handled)
					return ret;
			}
		}
	}
	if (ConfigEvent_ShouldExecuteWeapons(CET_BTD_OnHitSword))
	{
		ConfigSys.Params.SetValue("victim", victim);
		ConfigSys.Params.SetValue("player", attacker);
		ConfigSys.Params.SetValue("damage", damage);
		Action ret = ConfigEvent_ExecuteWeapons(VSH2Player(attacker), attacker, CET_BTD_OnHitSword);
		switch (ret)
		{
			case Plugin_Continue: { }
			default:
			{
				ConfigSys.Params.GetValue("damage", damage);
				return ret;
			}
		}
	}
	return Plugin_Continue;
}

Action ConfigEvent_OnBossTakeDamage_OnHitFanOWar(
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
	if (ConfigEvent_ShouldExecuteGlobals(CET_BTD_OnHitFanOWar))
	{
		ConfigSys.Params.SetValue("victim", victim);
		ConfigSys.Params.SetValue("player", attacker);
		ConfigSys.Params.SetValue("damage", damage);
		Action ret = ConfigEvent_ExecuteGlobals(CET_BTD_OnHitFanOWar);
		switch (ret)
		{
			case Plugin_Continue: { }
			default:
			{
				ConfigSys.Params.GetValue("damage", damage);
				if (ret >= Plugin_Handled)
					return ret;
			}
		}
	}
	if (ConfigEvent_ShouldExecuteWeapons(CET_BTD_OnHitFanOWar))
	{
		ConfigSys.Params.SetValue("victim", victim);
		ConfigSys.Params.SetValue("player", attacker);
		ConfigSys.Params.SetValue("damage", damage);
		Action ret = ConfigEvent_ExecuteWeapons(VSH2Player(attacker), attacker, CET_BTD_OnHitFanOWar);
		switch (ret)
		{
			case Plugin_Continue: { }
			default:
			{
				ConfigSys.Params.GetValue("damage", damage);
				return ret;
			}
		}
	}
	return Plugin_Continue;
}

Action ConfigEvent_OnBossTakeDamage_OnHitCandyCane(
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
	if (ConfigEvent_ShouldExecuteGlobals(CET_BTD_OnHitCandyCane))
	{
		ConfigSys.Params.SetValue("victim", victim);
		ConfigSys.Params.SetValue("player", attacker);
		ConfigSys.Params.SetValue("damage", damage);
		Action ret = ConfigEvent_ExecuteGlobals(CET_BTD_OnHitCandyCane);
		switch (ret)
		{
			case Plugin_Continue: { }
			default:
			{
				ConfigSys.Params.GetValue("damage", damage);
				if (ret >= Plugin_Handled)
					return ret;
			}
		}
	}
	if (ConfigEvent_ShouldExecuteWeapons(CET_BTD_OnHitCandyCane))
	{
		ConfigSys.Params.SetValue("victim", victim);
		ConfigSys.Params.SetValue("player", attacker);
		ConfigSys.Params.SetValue("damage", damage);
		Action ret = ConfigEvent_ExecuteWeapons(VSH2Player(attacker), attacker, CET_BTD_OnHitCandyCane);
		switch (ret)
		{
			case Plugin_Continue: { }
			default:
			{
				ConfigSys.Params.GetValue("damage", damage);
				return ret;
			}
		}
	}
	return Plugin_Continue;
}

Action ConfigEvent_OnBossTakeDamage_OnMarketGardened(
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
	if (ConfigEvent_ShouldExecuteGlobals(CET_BTD_OnMarketGardened))
	{
		ConfigSys.Params.SetValue("victim", victim);
		ConfigSys.Params.SetValue("player", attacker);
		ConfigSys.Params.SetValue("damage", damage);
		Action ret = ConfigEvent_ExecuteGlobals(CET_BTD_OnMarketGardened);
		switch (ret)
		{
			case Plugin_Continue: { }
			default:
			{
				ConfigSys.Params.GetValue("damage", damage);
				if (ret >= Plugin_Handled)
					return ret;
			}
		}
	}
	if (ConfigEvent_ShouldExecuteWeapons(CET_BTD_OnMarketGardened))
	{
		ConfigSys.Params.SetValue("victim", victim);
		ConfigSys.Params.SetValue("player", attacker);
		ConfigSys.Params.SetValue("damage", damage);
		Action ret = ConfigEvent_ExecuteWeapons(VSH2Player(attacker), attacker, CET_BTD_OnMarketGardened);
		switch (ret)
		{
			case Plugin_Continue: { }
			default:
			{
				ConfigSys.Params.GetValue("damage", damage);
				return ret;
			}
		}
	}
	return Plugin_Continue;
}

Action ConfigEvent_OnBossTakeDamage_OnKatana(
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
	if (ConfigEvent_ShouldExecuteGlobals(CET_BTD_OnKatana))
	{
		ConfigSys.Params.SetValue("victim", victim);
		ConfigSys.Params.SetValue("player", attacker);
		ConfigSys.Params.SetValue("damage", damage);
		Action ret = ConfigEvent_ExecuteGlobals(CET_BTD_OnKatana);
		switch (ret)
		{
			case Plugin_Continue: { }
			default:
			{
				ConfigSys.Params.GetValue("damage", damage);
				if (ret >= Plugin_Handled)
					return ret;
			}
		}
	}
	if (ConfigEvent_ShouldExecuteWeapons(CET_BTD_OnKatana))
	{
		ConfigSys.Params.SetValue("victim", victim);
		ConfigSys.Params.SetValue("player", attacker);
		ConfigSys.Params.SetValue("damage", damage);
		Action ret = ConfigEvent_ExecuteWeapons(VSH2Player(attacker), attacker, CET_BTD_OnKatana);
		switch (ret)
		{
			case Plugin_Continue: { }
			default:
			{
				ConfigSys.Params.GetValue("damage", damage);
				return ret;
			}
		}
	}
	return Plugin_Continue;
}

Action ConfigEvent_OnBossTakeDamage_OnPowerJack(
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
	if (ConfigEvent_ShouldExecuteGlobals(CET_BTD_OnPowerJack))
	{
		ConfigSys.Params.SetValue("victim", victim);
		ConfigSys.Params.SetValue("player", attacker);
		ConfigSys.Params.SetValue("damage", damage);
		Action ret = ConfigEvent_ExecuteGlobals(CET_BTD_OnPowerJack);
		switch (ret)
		{
			case Plugin_Continue: { }
			default:
			{
				ConfigSys.Params.GetValue("damage", damage);
				if (ret >= Plugin_Handled)
					return ret;
			}
		}
	}
	if (ConfigEvent_ShouldExecuteWeapons(CET_BTD_OnPowerJack))
	{
		ConfigSys.Params.SetValue("victim", victim);
		ConfigSys.Params.SetValue("player", attacker);
		ConfigSys.Params.SetValue("damage", damage);
		Action ret = ConfigEvent_ExecuteWeapons(VSH2Player(attacker), attacker, CET_BTD_OnPowerJack);
		switch (ret)
		{
			case Plugin_Continue: { }
			default:
			{
				ConfigSys.Params.GetValue("damage", damage);
				return ret;
			}
		}
	}
	return Plugin_Continue;
}

Action ConfigEvent_OnBossTakeDamage_OnAmbassadorHeadshot(
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
	if (ConfigEvent_ShouldExecuteGlobals(CET_BTD_OnAmbassadorHeadshot))
	{
		ConfigSys.Params.SetValue("victim", victim);
		ConfigSys.Params.SetValue("player", attacker);
		ConfigSys.Params.SetValue("damage", damage);
		Action ret = ConfigEvent_ExecuteGlobals(CET_BTD_OnAmbassadorHeadshot);
		switch (ret)
		{
			case Plugin_Continue: { }
			default:
			{
				ConfigSys.Params.GetValue("damage", damage);
				if (ret >= Plugin_Handled)
					return ret;
			}
		}
	}
	if (ConfigEvent_ShouldExecuteWeapons(CET_BTD_OnAmbassadorHeadshot))
	{
		ConfigSys.Params.SetValue("victim", victim);
		ConfigSys.Params.SetValue("player", attacker);
		ConfigSys.Params.SetValue("damage", damage);
		Action ret = ConfigEvent_ExecuteWeapons(VSH2Player(attacker), attacker, CET_BTD_OnAmbassadorHeadshot);
		switch (ret)
		{
			case Plugin_Continue: { }
			default:
			{
				ConfigSys.Params.GetValue("damage", damage);
				return ret;
			}
		}
	}
	return Plugin_Continue;
}

Action ConfigEvent_OnBossTakeDamage_OnHolidayPunch(
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
	if (ConfigEvent_ShouldExecuteGlobals(CET_BTD_OnHolidayPunch))
	{
		ConfigSys.Params.SetValue("victim", victim);
		ConfigSys.Params.SetValue("player", attacker);
		ConfigSys.Params.SetValue("damage", damage);
		Action ret = ConfigEvent_ExecuteGlobals(CET_BTD_OnHolidayPunch);
		switch (ret)
		{
			case Plugin_Continue: { }
			default:
			{
				ConfigSys.Params.GetValue("damage", damage);
				if (ret >= Plugin_Handled)
					return ret;
			}
		}
	}
	if (ConfigEvent_ShouldExecuteWeapons(CET_BTD_OnHolidayPunch))
	{
		ConfigSys.Params.SetValue("victim", victim);
		ConfigSys.Params.SetValue("player", attacker);
		ConfigSys.Params.SetValue("damage", damage);
		Action ret = ConfigEvent_ExecuteWeapons(VSH2Player(attacker), attacker, CET_BTD_OnHolidayPunch);
		switch (ret)
		{
			case Plugin_Continue: { }
			default:
			{
				ConfigSys.Params.GetValue("damage", damage);
				return ret;
			}
		}
	}
	return Plugin_Continue;
}

Action ConfigEvent_OnBossTakeDamage_OnDiamondbackManmelterCrit(
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
	if (ConfigEvent_ShouldExecuteGlobals(CET_BTD_OnDiamonBackManmelterCrit))
	{
		ConfigSys.Params.SetValue("victim", victim);
		ConfigSys.Params.SetValue("player", attacker);
		ConfigSys.Params.SetValue("damage", damage);
		Action ret = ConfigEvent_ExecuteGlobals(CET_BTD_OnDiamonBackManmelterCrit);
		switch (ret)
		{
			case Plugin_Continue: { }
			default:
			{
				ConfigSys.Params.GetValue("damage", damage);
				if (ret >= Plugin_Handled)
					return ret;
			}
		}
	}
	if (ConfigEvent_ShouldExecuteWeapons(CET_BTD_OnDiamonBackManmelterCrit))
	{
		ConfigSys.Params.SetValue("victim", victim);
		ConfigSys.Params.SetValue("player", attacker);
		ConfigSys.Params.SetValue("damage", damage);
		Action ret = ConfigEvent_ExecuteWeapons(VSH2Player(attacker), attacker, CET_BTD_OnDiamonBackManmelterCrit);
		switch (ret)
		{
			case Plugin_Continue: { }
			default:
			{
				ConfigSys.Params.GetValue("damage", damage);
				return ret;
			}
		}
	}
	return Plugin_Continue;
}

Action ConfigEvent_OnBossAirShotProj(
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
	if (ConfigEvent_ShouldExecuteGlobals(CET_BossAirshotProj))
	{
		ConfigSys.Params.SetValue("victim", victim);
		ConfigSys.Params.SetValue("player", attacker);
		ConfigSys.Params.SetValue("damage", damage);
		Action ret = ConfigEvent_ExecuteGlobals(CET_BossAirshotProj);
		switch (ret)
		{
			case Plugin_Continue: { }
			default:
			{
				ConfigSys.Params.GetValue("damage", damage);
				if (ret >= Plugin_Handled)
					return ret;
			}
		}
	}
	if (ConfigEvent_ShouldExecuteWeapons(CET_BossAirshotProj))
	{
		ConfigSys.Params.SetValue("victim", victim);
		ConfigSys.Params.SetValue("player", attacker);
		ConfigSys.Params.SetValue("damage", damage);
		Action ret = ConfigEvent_ExecuteWeapons(VSH2Player(attacker), attacker, CET_BossAirshotProj);
		switch (ret)
		{
			case Plugin_Continue: { }
			default:
			{
				ConfigSys.Params.GetValue("damage", damage);
				return ret;
			}
		}
	}
	return Plugin_Continue;
}

/**
 * Keys:
 * [in] "victim"
 * [in] "attacker"
 * [in/out] "damage"
 *
 * Return:
 * Plugin_Continue: ignore the new params
 * Plugin_Changed: rewrite the params and don't do vsh2's internal damage calculations
 */
Action ConfigEvent_OnBossTakeDamage_OnTriggerHurt(
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
	if (ConfigEvent_ShouldExecuteGlobals(CET_BTD_OnTriggerHurt))
	{
		ConfigSys.Params.SetValue("victim", victim);
		ConfigSys.Params.SetValue("player", attacker);
		ConfigSys.Params.SetValue("damage", damage);
		Action ret = ConfigEvent_ExecuteGlobals(CET_BTD_OnTriggerHurt);
		switch (ret)
		{
			case Plugin_Continue: { }
			default:
			{
				ConfigSys.Params.GetValue("damage", damage);
				if (ret >= Plugin_Handled)
					return ret;
			}
		}
	}
	if (ConfigEvent_ShouldExecuteWeapons(CET_BTD_OnTriggerHurt))
	{
		ConfigSys.Params.SetValue("victim", victim);
		ConfigSys.Params.SetValue("attacker", attacker);
		ConfigSys.Params.SetValue("damage", damage);
		Action ret = ConfigEvent_ExecuteWeapons(VSH2Player(attacker), attacker, CET_BTD_OnTriggerHurt);
		switch (ret)
		{
			case Plugin_Continue: { }
			default:
			{
				ConfigSys.Params.GetValue("damage", damage);
				return ret;
			}
		}
	}
	return Plugin_Continue;
}

Action ConfigEvent_OnBossTakeDamage_OnMantreadsStomp(
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
	if (ConfigEvent_ShouldExecuteGlobals(CET_BTD_OnMantreadsStomps))
	{
		ConfigSys.Params.SetValue("victim", victim);
		ConfigSys.Params.SetValue("player", attacker);
		ConfigSys.Params.SetValue("damage", damage);
		Action ret = ConfigEvent_ExecuteGlobals(CET_BTD_OnMantreadsStomps);
		switch (ret)
		{
			case Plugin_Continue: { }
			default:
			{
				ConfigSys.Params.GetValue("damage", damage);
				if (ret >= Plugin_Handled)
					return ret;
			}
		}
	}
	if (ConfigEvent_ShouldExecuteWeapons(CET_BTD_OnMantreadsStomps))
	{
		ConfigSys.Params.SetValue("victim", victim);
		ConfigSys.Params.SetValue("damage", damage);
		ConfigSys.Params.SetValue("attacker", attacker);
		Action ret = ConfigEvent_ExecuteWeapons(VSH2Player(attacker), attacker, CET_BTD_OnMantreadsStomps);
		switch (ret)
		{
			case Plugin_Continue: { }
			default:
			{
				ConfigSys.Params.GetValue("damage", damage);
				return ret;
			}
		}
	}
	return Plugin_Continue;
}
