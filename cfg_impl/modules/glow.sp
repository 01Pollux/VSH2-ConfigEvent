public Action ConfigEvent_SetClientGlow(EventMap args, ConfigEventType_t event_type)
{
    /* // ConfigEvent_SetClientGlow
    "<enum>"
    {
        "procedure" "ConfigEvent_SetClientGlow"
        "vsh2target"    "player"

        "addtime"  "5.0" //can be negative
    } */

    int calling_player_idx;
	VSH2Player calling_player;
	if (!args.GetTarget(calling_player_idx, calling_player))
		return Plugin_Continue;

    float o_glowtime = calling_player.GetPropFloat("flGlowtime");
    float addtime; args.GetFloat("addtime", addtime);
    float new_glowtime = o_glowtime + addtime;
    if (new_glowtime > 0.0)
    {
        calling_player.SetPropFloat("flGlowtime", new_glowtime);
        calling_player.GlowThink(0.1);
    }
    return Plugin_Continue;
}
