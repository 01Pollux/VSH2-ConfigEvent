/**
 * Keys:
 * [in] "victim": victim userid/vsh2player instance 
 * [in] "inflictor": boss' entity index 
 * [in/out] "damage"
 *
 * Return:
 * Plugin_Continue: ignore the new damage
 * default: rewrite the new damage, returning 'Plugin_Handled' will halt function execution for weapons
 */


Action ConfigEvent_OnBossDealDamage(
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
	if (ConfigEvent_ShouldExecuteGlobals(CET_BossDealDamage))
	{
		ConfigSys.Params.SetValue("victim", victim);
		ConfigSys.Params.SetValue("inflictor", inflictor);
		ConfigSys.Params.SetValue("damage", damage);
		Action ret = ConfigEvent_ExecuteGlobals(CET_BossDealDamage);
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
	if (ConfigEvent_ShouldExecuteWeapons(CET_BossDealDamage))
	{
		ConfigSys.Params.SetValue("victim", victim);
		ConfigSys.Params.SetValue("inflictor", inflictor);
		ConfigSys.Params.SetValue("damage", damage);
		Action ret = ConfigEvent_ExecuteWeapons(victim.index, CET_BossDealDamage);
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

Action ConfigEvent_OnBossDealDamage_OnStomp(
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
	if (ConfigEvent_ShouldExecuteGlobals(CET_BDD_OnStomp))
	{
		ConfigSys.Params.SetValue("victim", victim);
		ConfigSys.Params.SetValue("inflictor", inflictor);
		ConfigSys.Params.SetValue("damage", damage);
		Action ret = ConfigEvent_ExecuteGlobals(CET_BDD_OnStomp);
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
	if (ConfigEvent_ShouldExecuteWeapons(CET_BDD_OnStomp))
	{
		ConfigSys.Params.SetValue("victim", victim);
		ConfigSys.Params.SetValue("inflictor", inflictor);
		ConfigSys.Params.SetValue("damage", damage);
		Action ret = ConfigEvent_ExecuteWeapons(victim.index, CET_BDD_OnStomp);
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

Action ConfigEvent_OnBossDealDamage_OnHitDefBuff(
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
	if (ConfigEvent_ShouldExecuteGlobals(CET_BDD_OnHitDebuff))
	{
		ConfigSys.Params.SetValue("victim", victim);
		ConfigSys.Params.SetValue("inflictor", inflictor);
		ConfigSys.Params.SetValue("damage", damage);
		Action ret = ConfigEvent_ExecuteGlobals(CET_BDD_OnHitDebuff);
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
	if (ConfigEvent_ShouldExecuteWeapons(CET_BDD_OnHitDebuff))
	{
		ConfigSys.Params.SetValue("victim", victim);
		ConfigSys.Params.SetValue("inflictor", inflictor);
		ConfigSys.Params.SetValue("damage", damage);
		Action ret = ConfigEvent_ExecuteWeapons(victim.index, CET_BDD_OnHitDebuff);
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

Action ConfigEvent_OnBossDealDamage_OnHitCritMmmph(
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
	if (ConfigEvent_ShouldExecuteGlobals(CET_BDD_OnHitCritMmph))
	{
		ConfigSys.Params.SetValue("victim", victim);
		ConfigSys.Params.SetValue("inflictor", inflictor);
		ConfigSys.Params.SetValue("damage", damage);
		Action ret = ConfigEvent_ExecuteGlobals(CET_BDD_OnHitCritMmph);
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
	if (ConfigEvent_ShouldExecuteWeapons(CET_BDD_OnHitCritMmph))
	{
		ConfigSys.Params.SetValue("victim", victim);
		ConfigSys.Params.SetValue("inflictor", inflictor);
		ConfigSys.Params.SetValue("damage", damage);
		Action ret = ConfigEvent_ExecuteWeapons(victim.index, CET_BDD_OnHitCritMmph);
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

Action ConfigEvent_OnBossDealDamage_OnHitMedic(
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
	if (ConfigEvent_ShouldExecuteGlobals(CET_BDD_OnHitMedic))
	{
		ConfigSys.Params.SetValue("victim", victim);
		ConfigSys.Params.SetValue("inflictor", inflictor);
		ConfigSys.Params.SetValue("damage", damage);
		Action ret = ConfigEvent_ExecuteGlobals(CET_BDD_OnHitMedic);
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
	if (ConfigEvent_ShouldExecuteWeapons(CET_BDD_OnHitMedic))
	{
		ConfigSys.Params.SetValue("victim", victim);
		ConfigSys.Params.SetValue("inflictor", inflictor);
		ConfigSys.Params.SetValue("damage", damage);
		Action ret = ConfigEvent_ExecuteWeapons(victim.index, CET_BDD_OnHitMedic);
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

Action ConfigEvent_OnBossDealDamage_OnHitDeadRinger(
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
	if (ConfigEvent_ShouldExecuteGlobals(CET_BDD_OnDeadRinger))
	{
		ConfigSys.Params.SetValue("victim", victim);
		ConfigSys.Params.SetValue("inflictor", inflictor);
		ConfigSys.Params.SetValue("damage", damage);
		Action ret = ConfigEvent_ExecuteGlobals(CET_BDD_OnDeadRinger);
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
	if (ConfigEvent_ShouldExecuteWeapons(CET_BDD_OnDeadRinger))
	{
		ConfigSys.Params.SetValue("victim", victim);
		ConfigSys.Params.SetValue("inflictor", inflictor);
		ConfigSys.Params.SetValue("damage", damage);
		Action ret = ConfigEvent_ExecuteWeapons(victim.index, CET_BDD_OnDeadRinger);
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

Action ConfigEvent_OnBossDealDamage_OnHitCloakedSpy(
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
	if (ConfigEvent_ShouldExecuteGlobals(CET_BDD_OnCloakedSpy))
	{
		ConfigSys.Params.SetValue("victim", victim);
		ConfigSys.Params.SetValue("inflictor", inflictor);
		ConfigSys.Params.SetValue("damage", damage);
		Action ret = ConfigEvent_ExecuteGlobals(CET_BDD_OnCloakedSpy);
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
	if (ConfigEvent_ShouldExecuteWeapons(CET_BDD_OnCloakedSpy))
	{
		ConfigSys.Params.SetValue("victim", victim);
		ConfigSys.Params.SetValue("inflictor", inflictor);
		ConfigSys.Params.SetValue("damage", damage);
		Action ret = ConfigEvent_ExecuteWeapons(victim.index, CET_BDD_OnCloakedSpy);
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

Action ConfigEvent_OnBossDealDamage_OnHitShield(
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
	if (ConfigEvent_ShouldExecuteGlobals(CET_BDD_OnHitShield))
	{
		ConfigSys.Params.SetValue("victim", victim);
		ConfigSys.Params.SetValue("inflictor", inflictor);
		ConfigSys.Params.SetValue("damage", damage);
		Action ret = ConfigEvent_ExecuteGlobals(CET_BDD_OnHitShield);
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
	if (ConfigEvent_ShouldExecuteWeapons(CET_BDD_OnHitShield))
	{
		ConfigSys.Params.SetValue("victim", victim);
		ConfigSys.Params.SetValue("inflictor", inflictor);
		ConfigSys.Params.SetValue("damage", damage);
		Action ret = ConfigEvent_ExecuteWeapons(victim.index, CET_BDD_OnHitShield);
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