static int iChainStabs[MAXPLAYERS+1];

public Action ConfigEvent_ChainStab_Reset(EventMap args, ConfigEventType_t event_type)
{
    int calling_player_idx;
    VSH2Player calling_player;
    if (!args.GetTarget(calling_player_idx, calling_player))
        return Plugin_Continue;

    iChainStabs[calling_player_idx] = 0;

    return Plugin_Continue;
}

public Action ConfigEvent_ChainStab_Stabbed(EventMap args, ConfigEventType_t event_type)
{
    int calling_player_idx;
    VSH2Player calling_player;
    if (!args.GetTarget(calling_player_idx, calling_player))
        return Plugin_Continue;

    //PrintToServer("GetTargetSuccess!");

    iChainStabs[calling_player_idx]++;
    char message[255];
    Format(message, sizeof(message), "%N\n总计背刺：%i/4", calling_player_idx, iChainStabs[calling_player_idx]);
    PrintHintTextToAll(message);
    if (1 <= iChainStabs[calling_player_idx] <= 3)   //0, 1, 2, 3
    {
        char backstabsound[PLATFORM_MAX_PATH];
        Format(backstabsound, sizeof(backstabsound), "vsh_rewrite/stab0%i.mp3", iChainStabs[calling_player_idx]);
        EmitSoundToAll(backstabsound);
        ConfigSys.Params.SetValue("damage", 0.0);
    }
    else if(iChainStabs[calling_player_idx] == 4)   //4
    {
        float damage;   ConfigSys.Params.GetValue("damage", damage);
        float new_damage = 6 * damage + 666;
        ConfigSys.Params.SetValue("damage", new_damage);
        iChainStabs[calling_player_idx] = 0;
        char backstabsound[PLATFORM_MAX_PATH];
        Format(backstabsound, sizeof(backstabsound), "vsh_rewrite/stab04.mp3");
        EmitSoundToAll(backstabsound);
    }

    return Plugin_Changed;
}
