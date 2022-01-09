static int g_iTagsAirblastRequirement[MAXPLAYERS+1];
static int g_iTagsAirblastDamage[MAXPLAYERS+1];
static bool g_bIsAirBlastLimit[MAXPLAYERS+1];
static FlamethrowerState g_nTagsAirblastState[MAXPLAYERS+1];
#define SOUND_METERFULL "player/recharged.wav"

/*
"<enum>"
{
  // limit pyro's airblast until it deals certain damage (use this only when round begins/player spawns. like "prep_redteam")
  "procedure"  "ConfigEvent_AirBlast"

  // depend on 	'event_type', usually 'player' for calling player, check 'vsh2hooks*.sp'
  // 'target' will assume the 'player' is an entity index
  // while 'vsh2target' will assume the 'player' is a client userid
  "vsh2target"	"player"
  //"target"		"player"

  //damage required to recharge airblast
  "damage"  "400"
  //charged when add
  "start" "400"
}
*/

public Action ConfigEvent_AirBlast(EventMap args, ConfigEventType_t event_type)
{
  int calling_player_idx;
  VSH2Player calling_player;
  if (!args.GetTarget(calling_player_idx, calling_player))
    return Plugin_Continue;

  PrecacheSound(SOUND_METERFULL);
  args.GetInt("damage", g_iTagsAirblastRequirement[calling_player_idx]);
  args.GetInt("start", g_iTagsAirblastDamage[calling_player_idx]);

  int primary = calling_player.GetWeaponSlotIndex(TF2WeaponSlot_Primary);
  if (primary == INVALID_ENT_REFERENCE)
    return Plugin_Continue;
  if (g_iTagsAirblastRequirement[calling_player_idx] > g_iTagsAirblastDamage[calling_player_idx])
    SetEntPropFloat(calling_player_idx, Prop_Send, "m_flNextSecondaryAttack", 31536000.0+GetGameTime()); //3 years
  else
    SetEntPropFloat(calling_player_idx, Prop_Send, "m_flNextSecondaryAttack", 0.0);

  g_bIsAirBlastLimit[calling_player_idx] = true;

  return Plugin_Continue;
}

void ConfigEvent_AirBlast_OnTakeDamage(VSH2Player player, float damage, int weapon)
{
  if (!g_bIsAirBlastLimit[player.index])
    return;

  int primary = player.GetWeaponSlotIndex(TF2WeaponSlot_Primary);
  if (primary == INVALID_ENT_REFERENCE)
    return;

  int attacker = player.index;
  if (g_iTagsAirblastRequirement[attacker] > 0 && primary == weapon)
  {
    bool full = (g_iTagsAirblastDamage[attacker] >= g_iTagsAirblastRequirement[attacker]);
    g_iTagsAirblastDamage[attacker] = g_iTagsAirblastRequirement[attacker];
    g_iTagsAirblastDamage[attacker] += RoundToNearest(damage);

    if (g_iTagsAirblastDamage[attacker] >= g_iTagsAirblastRequirement[attacker])
    {
      g_iTagsAirblastDamage[attacker] = g_iTagsAirblastRequirement[attacker];
      if (!full)
      {
        EmitSoundToClient(attacker, SOUND_METERFULL);
        SetEntPropFloat(primary, Prop_Send, "m_flNextSecondaryAttack", 0.0);
      }
    }
  }
}

void ConfigEvent_AirBlast_Think(VSH2Player player)
{
  if (!g_bIsAirBlastLimit[player.index])
    return;

  int client = player.index;
  if (g_iTagsAirblastRequirement[client] > 0 && g_iTagsAirblastDamage[client] >= g_iTagsAirblastRequirement[client])
  {
    int primary = player.GetWeaponSlotIndex(TF2WeaponSlot_Primary); //Detect if airblast is used, and reset if so
    if (primary > MaxClients)
    {
      FlamethrowerState state = view_as<FlamethrowerState>(GetEntProp(primary, Prop_Send, "m_iWeapostate"));
      if (state != g_nTagsAirblastState[client] && state == FlamethrowerState_Airblast)
      {
        g_iTagsAirblastDamage[client] = 0;
        SetEntPropFloat(primary, Prop_Send, "m_flNextSecondaryAttack", 31536000.0+GetGameTime()); //3 years
      }
      g_nTagsAirblastState[client] = state;
    }
  }

  int buttons = GetClientButtons(client); //Prevent clients holding m2 while airblast in cooldown
  if (buttons & IN_ATTACK2 && g_iTagsAirblastRequirement[client] > 0 && g_iTagsAirblastDamage[client] < g_iTagsAirblastRequirement[client])
  {
    int primary = player.GetWeaponSlotIndex(TF2WeaponSlot_Primary);
    int activewep = GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon");
    if (activewep > MaxClients && primary == activewep)
      buttons &= ~IN_ATTACK2;

    if (g_nTagsAirblastState[client] == FlamethrowerState_Airblast) //Change the m_iWeaponState to a proper value after the airblast to prevent the visual bug
    {
      if (buttons & IN_ATTACK)
      {
        g_nTagsAirblastState[client] = FlamethrowerState_Firing;
        SetEntProp(primary, Prop_Send, "m_iWeaponState", FlamethrowerState_Firing);
      }
      else
      {
        g_nTagsAirblastState[client] = FlamethrowerState_Idle;
        SetEntProp(primary, Prop_Send, "m_iWeaponState", FlamethrowerState_Idle);
      }
    }
  }
}

/*
"<enum>"
{
  // process airblast hud. for event type "playerhud" only
  "procedure"  "ConfigEvent_AirBlast_HUD"

  // depend on 	'event_type', usually 'player' for calling player, check 'vsh2hooks*.sp'
  // 'target' will assume the 'player' is an entity index
  // while 'vsh2target' will assume the 'player' is a client userid
  "vsh2target"	"player"
  //"target"		"player"

  // %f : percentage of airblast
  "string"		"Airblast: %f%"
}
*/

public Action ConfigEvent_AirBlast_HUD(EventMap args, ConfigEventType_t event_type)
{
  int calling_player_idx;
  VSH2Player calling_player;
  if (!args.GetTarget(calling_player_idx, calling_player))
    return Plugin_Continue;

  if (!g_bIsAirBlastLimit[calling_player_idx])
    return Plugin_Continue;

  float percentage = GetAirblastPercentage(calling_player_idx) * 100.0;
  if (percentage >= 0.0)
  {
    int abhud_size = args.GetSize("string");
    char[] abhud_str = new char[abhud_size];
    args.Get("string", abhud_str, abhud_size);
    char percentage_replace[3];
    IntToString(RoundToFloor(percentage), percentage_replace, 3);
    ReplaceString(abhud_str, abhud_size, "%f", percentage_replace);
    ConfigSys.Params.SetString("new_text", abhud_str);
    return Plugin_Changed;
  }
  return Plugin_Continue;
}

stock float GetAirblastPercentage(int client)
{
  if (g_iTagsAirblastRequirement[client] <= 0)
    return -1.0;

  return float(g_iTagsAirblastDamage[client]) / float(g_iTagsAirblastRequirement[client]);
}
