static bool bIsEurekaEffectCD[MAXPLAYERS+1];
static float fEurekaEffectLastUsed[MAXPLAYERS+1];
static float fEurekaEffectCooldown[MAXPLAYERS+1];

public Action ConfigEvent_TeleportBlock(EventMap args, ConfigEventType_t event_type)
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

public Action ConfigEvent_TeleportReset(EventMap args, ConfigEventType_t event_type)
{
	int calling_player_idx;
	VSH2Player calling_player;
	if (!args.GetTarget(calling_player_idx, calling_player))
		return Plugin_Continue;

	fEurekaEffectLastUsed[calling_player_idx] = 0.0;
	fEurekaEffectCooldown[calling_player_idx] = 0.0;

	return Plugin_Continue;
}

public Action ConfigEvent_TeleportCooldown(EventMap args, ConfigEventType_t event_type)
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

public Action ConfigEvent_TeleportHUD(EventMap args, ConfigEventType_t event_type)
{
	/* "<enum>"
	{
		"procedure"	"ConfigEvent_EurekaEffect_CoolDownHUD"
		"vsh2target"	"player"
		//EukuraEffectCooldown = cooldown left
		"string"	" | Eureka Effect: %f seconds"
	} */
	int calling_player_idx;
	VSH2Player calling_player;
	if (!args.GetTarget(calling_player_idx, calling_player))
		return Plugin_Continue;

	float cooldown = fEurekaEffectLastUsed[calling_player_idx] + fEurekaEffectCooldown[calling_player_idx] - GetGameTime();
	if (cooldown > 0.0)
	{
		char hud_string[128];
		args.Get("string", hud_string, 128);
		char cooldown_replace[16];
		FormatEx(cooldown_replace, sizeof(cooldown_replace), "%.2f", cooldown);
		ReplaceString(hud_string, strlen(hud_string), "%f", cooldown_replace);
		ConfigSys.Params.SetString("new_text", hud_string);
		return Plugin_Changed;
	}

	return Plugin_Continue;
}
