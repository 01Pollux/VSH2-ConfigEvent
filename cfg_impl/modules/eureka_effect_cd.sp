static bool bIsEurekaEffectCD[MAXPLAYERS+1];
static float fEurekaEffectLastUsed[MAXPLAYERS+1];
static float fEurekaEffectCooldown[MAXPLAYERS+1];

public Action ConfigEvent_BlockCommand(EventMap args, ConfigEventType_t event_type)
{
	int calling_player_idx;
	VSH2Player calling_player;
	if (!args.GetTarget(calling_player_idx, calling_player))
		return Plugin_Continue;

	float cooldown = fEurekaEffectLastUsed[calling_player_idx] + fEurekaEffectCooldown[calling_player_idx] - GetGameTime();
	if (cooldown > 0.0)
		bIsEurekaEffectCD[calling_player_idx] = true;
	else
		bIsEurekaEffectCD[calling_player_idx] = false;

	return bIsEurekaEffectCD[calling_player_idx] ? Plugin_Handled /* block the 'eukura_teleport' from being processed */: Plugin_Continue;
}

public Action ConfigEvent_EurekaEffect_Reset(EventMap args, ConfigEventType_t event_type)
{
	int calling_player_idx;
  VSH2Player calling_player;
  if (!args.GetTarget(calling_player_idx, calling_player))
    return Plugin_Continue;

	fEurekaEffectLastUsed[calling_player_idx] = 0.0;
	fEurekaEffectCooldown[calling_player_idx] = 0.0;

	return Plugin_Continue;
}

public Action ConfigEvent_StartCoolDown(EventMap args, ConfigEventType_t event_type)
{
	/*
	// ConfigEvent_StartCoolDown();
	"<enum>"
	{
		"procedure"  "ConfigEvent_StartCoolDown"
		"vsh2target" "player"
		"cooldown"	"25.0"
	}
	*/
	int calling_player_idx;
	VSH2Player calling_player;
	if (!args.GetTarget(calling_player_idx, calling_player))
		return Plugin_Continue;

	if (bIsEurekaEffectCD[calling_player_idx])	//already in cooldown
		return Plugin_Continue;

	args.GetFloat("cooldown", fEurekaEffectCooldown[calling_player_idx]);
	fEurekaEffectLastUsed[calling_player_idx] = GetGameTime();
	bIsEurekaEffectCD[calling_player_idx] = true;
	return Plugin_Continue;
}

public Action ConfigEvent_CoolDownHUD(EventMap args, ConfigEventType_t event_type)
{
	/* "<enum>"
	{
		"procedure"	"ConfigEvent_CoolDownHUD"
		"vsh2target"	"player"
		//EukuraEffectCooldown = cooldown left
	}
	"<enum>"
	{
		"procedure" "ConfigEvent_SkipIf"
		"first" "f@EukuraEffectCooldown"
		"csecond" "0.0"
		"operators" "100011"	//if cooldown left <= 0.0 then skip
		"skips"	"3"
	}
	"<enum>"
	{
		"procedure"	"ConfigEvent_FormatParams"
		"<enum>"
		{
			"name"	"hud_string"
			"value"	" | Eureka Effect: {0} seconds"
			"size"	"128"
			"args"
			{
				"<enum>"	"f@EukuraEffectCooldown"
			}
		}
	}
	"<enum>"
	{
		"procedure"	"ConfigEvent_ParseForumla"

		"<enum>"
		{
			"name"	"new_text"
			"from"	"@hud_string"
			"truncate"	"false"
		}
	}
	"<enum>"
	{
		"procedure"	"ConfigEvent_WriteReturn"

		"return"	"changed"
	} */
	int calling_player_idx;
	VSH2Player calling_player;
	if (!args.GetTarget(calling_player_idx, calling_player))
		return Plugin_Continue;

	float cooldown = fEurekaEffectLastUsed[calling_player_idx] + fEurekaEffectCooldown[calling_player_idx] - GetGameTime();
	ConfigSys.Params.SetValue("EukuraEffectCooldown", cooldown);

	return Plugin_Continue;
}
