//static bool g_bIsAirBlastLimit[MAXPLAYERS+1];
static FlamethrowerState g_nTagsAirblastState[MAXPLAYERS+1];
#define SOUND_METERFULL "player/recharged.wav"
static float g_flTagsAirblastCooldown[MAXPLAYERS+1];
static float g_flTagsAirblastLastUsed[MAXPLAYERS+1];

/* --FullExample of Airblast Module--
It only works with pyro. So try not to use it on other classes.
In 'globals' section of the config file:
"globals"
{
  "reset_vsh2player"
  {
    "<enum>"
    {
      "procedure" "ConfigEvent_AirBlast_Reset"  //reset the airblast cooldown of the player
      "vsh2target"  "player"
    }
  }
}
In 'weapons' section of the config file:
"weapons"
{
  "prep_redteam"
  {
    "<enum>"
    {
      "procedure" "ConfigEvent_AirBlast"  //set the airblast cooldown of the player
      "vsh2target"  "player"

      "cooldown"  "6.0"
    }
  }
  "think"
  {
    "<enum>"
    {
      "procedure" "ConfigEvent_AirBlast_Think"  //Detect airblast and fix visual bug
      "vsh2target"  "player"
    }
  }
  "playerhud"
  {
    "<enum>"
    {
      "procedure" "ConfigEvent_AirBlast_HUD"  //show the cooldown in hud
      "vsh2target"  "player"
      "<passive>" "true"  //better show the hud all the time

      "string"  "Airblast cooldown: %f second"
    }
    //no need to write Plugin_Changed with another procedure. it's already done in the ConfigEvent_AirBlast_HUD
  }
} */

public Action ConfigEvent_AirBlast(EventMap args, ConfigEventType_t event_type)
{
  int calling_player_idx;
  VSH2Player calling_player;
  if (!args.GetTarget(calling_player_idx, calling_player))
    return Plugin_Continue;

  args.GetFloat("cooldown", g_flTagsAirblastCooldown[calling_player_idx]);

  return Plugin_Continue;
}

public Action ConfigEvent_AirBlast_Reset(EventMap args, ConfigEventType_t event_type)
{
  int calling_player_idx;
  VSH2Player calling_player;
  if (!args.GetTarget(calling_player_idx, calling_player))
    return Plugin_Continue;

  g_flTagsAirblastCooldown[calling_player_idx] = 0.0;
  g_flTagsAirblastLastUsed[calling_player_idx] = 0.0;

  return Plugin_Continue;
}

public Action ConfigEvent_AirBlast_Think(EventMap args, ConfigEventType_t event_type)
{
  int calling_player_idx;
  VSH2Player calling_player;
  if (!args.GetTarget(calling_player_idx, calling_player))
    return Plugin_Continue;

  if (g_flTagsAirblastCooldown[calling_player_idx] > 0.0 && g_flTagsAirblastLastUsed[calling_player_idx] + g_flTagsAirblastCooldown[calling_player_idx] < GetGameTime())
  {
    //Detect if airblast is used, and reset if so
    int primary = TF2_GetItemInSlot(calling_player_idx, TFWeaponSlot_Primary);
    if (primary > MaxClients)
    {
      FlamethrowerState state = view_as<FlamethrowerState>(GetEntProp(primary, Prop_Send, "m_iWeapoState"));
      if (state != g_nTagsAirblastState[calling_player_idx] && state == FlamethrowerState_Airblast)
      {
        g_flTagsAirblastLastUsed[calling_player_idx] = GetGameTime();	//Set cooldown
        SetEntPropFloat(primary, Prop_Send, "m_flNextSecondaryAttack", GetGameTime() + g_flTagsAirblastCooldown[calling_player_idx]);
      }

      g_nTagsAirblastState[calling_player_idx] = state;
    }
  }

  int buttons = GetClientButtons(calling_player_idx);
  if (buttons & IN_ATTACK2 && g_flTagsAirblastLastUsed[calling_player_idx] + g_flTagsAirblastCooldown[calling_player_idx] > GetGameTime())
  {
    int primary = TF2_GetItemInSlot(calling_player_idx, TFWeaponSlot_Primary);
    int activewep = GetEntPropEnt(calling_player_idx, Prop_Send, "m_hActiveWeapon");
    if (activewep > MaxClients && primary == activewep)
      buttons &= ~IN_ATTACK2;

    //Change the m_iWeaponState to a proper value after the airblast to prevent the visual bug
    if (g_nTagsAirblastState[calling_player_idx] == FlamethrowerState_Airblast)
    {
      if (buttons & IN_ATTACK)
      {
        g_nTagsAirblastState[calling_player_idx] = FlamethrowerState_Firing;
        SetEntProp(primary, Prop_Send, "m_iWeaponState", FlamethrowerState_Firing);
      }
      else
      {
        g_nTagsAirblastState[calling_player_idx] = FlamethrowerState_Idle;
        SetEntProp(primary, Prop_Send, "m_iWeaponState", FlamethrowerState_Idle);
      }
    }
  }

  return Plugin_Continue;
}

public Action ConfigEvent_AirBlast_HUD(EventMap args, ConfigEventType_t event_type)
{
  int calling_player_idx;
  VSH2Player calling_player;
  if (!args.GetTarget(calling_player_idx, calling_player))
    return Plugin_Continue;

  //Display airblast cooldown
  float cooldown = g_flTagsAirblastLastUsed[calling_player_idx] + g_flTagsAirblastCooldown[calling_player_idx] - GetGameTime();
  if (cooldown > 0.0)
  {
    char abhud_str[128];
    args.Get("string", abhud_str, 128);
    char cooldown_replace[16];
    FormatEx(cooldown_replace, sizeof(cooldown_replace), "%.1f", cooldown);
    ReplaceString(abhud_str, strlen(abhud_str), "%f", cooldown_replace);
    ConfigSys.Params.SetString("new_text", abhud_str);
    return Plugin_Changed;
  }

  return Plugin_Continue;
}
