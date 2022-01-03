public Action ConfigEvent_GiveRage(EventMap args, ConfigEventType_t event_type)
{
    /* "<enum>"
    {
        "procedure" "ConfigEvent_GiveRage"
        "vsh2target"    "victim"    //red player don't need rage

        "damage"    "200"   //int. can be negative
    } */

    int calling_player_idx;
    VSH2Player calling_player;
    if (!args.GetTarget(calling_player_idx, calling_player))
        return Plugin_Continue;

    int damage; args.GetInt("damage", damage);
    VSH2Player(calling_player).GiveRage(damage);

    return Plugin_Continue;
}

public Action ConfigEvent_ViewRage(EventMap args, ConfigEventType_t event_type)
{
    /* "<enum>"
    {
        "procedure" "ConfigEvent_ViewRage"  //for hud event type only
        "vsh2target"    "player"
        "string"    "Boss Rage: %f"
    } */
    int calling_player_idx;
    VSH2Player calling_player;
    if (!args.GetTarget(calling_player_idx, calling_player))
        return Plugin_Continue;

    int boss;
    for(int i = 0; i <= MaxClients; i++)
    {
        if (!IsValidClient(i) || !IsPlayerAlive(i) || !VSH2Player(i).GetPropInt("bIsBoss")) continue;
        boss = i;
        break;
    }

    int rage = RoundToFloor(VSH2Player(boss).GetPropFloat("flRAGE"));
    if (rage > 0)   //usually it would be > 0
    {
        int viewragehud_size = args.GetSize("string");
        char[] viewragehud_str = new char[viewragehud_size];
        args.Get("string", viewragehud_str, viewragehud_size);
        char rage_replace[3];
        IntToString(rage, rage_replace, 3);
        ReplaceString(viewragehud_str, viewragehud_size, "%f", rage_replace);
        ConfigSys.Params.SetString("new_text", viewragehud_str);
        return Plugin_Changed;
    }
    return Plugin_Continue;
}
