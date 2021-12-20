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
