public Action ConfigEvent_SandManStun(EventMap args, ConfigEventType_t event_type)
{
    /*
    Only for btd_takedamage
    "44"    //Sandman
    {
        "btd_takedamage"
        {
            "<enum>"
            {
                "procedure" "ConfigEvent_SandManStun"
                "vsh2player" "victim"
                //Change the vars in cfg_impl/modules/sandman.sp if need.
            }
        }
    }

    */

    int calling_player_idx;
    VSH2Player calling_player;
    if (!args.GetTarget(calling_player_idx, calling_player))
        return Plugin_Continue;

    float fClientLocation[3];
    float fClientEyePosition[3];
    GetClientAbsOrigin(attacker, fClientEyePosition);
    GetClientAbsOrigin(client, fClientLocation);
    float fDistance[3];
    MakeVectorFromPoints(fClientLocation, fClientEyePosition, fDistance);
    float dist = GetVectorLength(fDistance);
    float duration;
    bool bIsBigBonk = false;
    switch (RoundToFloor(dist / 128))
    {
        case 0: { /* do nothing */ }
        // 128 <= dist < 256
        case 1:
        {
            duration = 1.0;
        }
        // 256 <= dist < 384
        // 384 <= dist < 512
        case 2, 3:
        {
            duration = 2.0
        }
        // 512 <= dist < 640
        // 640 <= dist < 768
        case 4, 5:
        {
            duration = 3.0;
        }
        // 768 <= dist < 896
        // 896 <= dist < 1024
        case 6, 7:
        {
            duration = 4.0;
        }
        // 1024 <= dist < 1152
        // 1152 <= dist < 1280
        case 8, 9:
        {
            duration = 5.0;
        }
        // 1280 <= dist < 1408
        // 1408 <= dist < 1536
        case 10, 11:
        {
            duration = 6.0;
        }
        // 1536 <= dist < 1664
        // 1664 <= dist < 1792
        case 12, 13:
        {
            duration = 7.0;
        }
        // dist >= 1792
        default:
        {
          duration = 7.0;
          bIsBigBonk = true;
        }
    }
    if (duration > 0.0)
    {
        if (!bIsBigBonk)
        {
            TF2_StunPlayer(victim.index, duration, 0.0, TF_STUNFLAGS_SMALLBONK, calling_player_idx);
        }
        TF2_StunPlayer(victim.index, duration, 0.0, TF_STUNFLAGS_BIGBONK, calling_player_idx);
    }
    return Plugin_Continue;
}
