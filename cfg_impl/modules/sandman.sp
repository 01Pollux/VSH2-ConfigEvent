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
                "target" "player"
                "vsh2victim"    "victim"
                //Change the vars in cfg_impl/modules/sandman.sp if need.
            }
        }
    }
    */

    int attacker;
    VSH2Player vsh2attacker;
    if (!args.GetTarget(attacker, vsh2attacker))
        return Plugin_Continue;

    int victim;
    VSH2Player vsh2victim;
    if (!args.GetTargetEx("vsh2victim", "victim", victim, vsh2victim))
        return Plugin_Continue;

    int weapon; ConfigSys.Params.GetValue("weapon", weapon);
    int weapon_id = GetEntProp(weapon, Prop_Send, "m_iItemDefinitionIndex");
    if (weapon_id != 44)
      return Plugin_Continue;

    float attacker_pos[3], victim_pos[3];
    GetClientAbsOrigin(attacker, attacker_pos);
    GetClientAbsOrigin(victim, victim_pos);

    float dist = GetVectorDistance(victim_pos, attacker_pos);
    float duration;
    int flags = TF_STUNFLAGS_SMALLBONK;

    float level1; args.GetFloat("level1", level1);
    float level2; args.GetFloat("level2", level2);
    float level3; args.GetFloat("level3", level3);
    float level4; args.GetFloat("level4", level4);
    float level5; args.GetFloat("level5", level5);
    float level6; args.GetFloat("level6", level6);
    float level7; args.GetFloat("level7", level7);


    switch (RoundToFloor(dist / 128))
    {
        case 0: { /* do nothing */ }
        // 128 <= dist < 256
        case 1:
        {
          duration = level1;
        }
        // 256 <= dist < 384
        // 384 <= dist < 512
        case 2, 3:
        {
          duration = level2;
        }
        // 512 <= dist < 640
        // 640 <= dist < 768
        case 4, 5:
        {
          duration = level3;
        }
        // 768 <= dist < 896
        // 896 <= dist < 1024
        case 6, 7:
        {
          duration = level4;
        }
        // 1024 <= dist < 1152
        // 1152 <= dist < 1280
        case 8, 9:
        {
          duration = level5;
        }
        // 1280 <= dist < 1408
        // 1408 <= dist < 1536
        case 10, 11:
        {
          duration = level6;
        }
        // 1536 <= dist < 1664
        // 1664 <= dist < 1792
        case 12, 13:
        {
          duration = level7;
        }
        // dist >= 1792
        default:
        {
          duration = level7;
          flags = TF_STUNFLAGS_BIGBONK;
        }
    }

    if (duration)
        TF2_StunPlayer(victim, duration, 0.0, flags, attacker);
    return Plugin_Continue;
}
