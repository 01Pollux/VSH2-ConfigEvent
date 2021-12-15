static int g_iTagsAirblastRequirement[MAXPLAYERS+1];
static int g_iTagsAirblastDamage[MAXPLAYERS+1];
static FlamethrowerState g_nTagsAirblastState[MAXPLAYERS+1];
#define SOUND_METERFULL		"player/recharged.wav"
PrecacheSound(SOUND_METERFULL);

public Action ConfigEvent_AirBlast(EventMap args, ConfigEventType_t event_type)
{
  int calling_player_idx;
	VSH2Player calling_player;
	if (!args.GetTarget(calling_player_idx, calling_player))
		return Plugin_Continue;

  g_iTagsAirblastRequirement[calling_player_idx] = args.GetInt("damage", -1);
  g_iTagsAirblastDamage[calling_player_idx] = args.GetInt("start", 0);

  if (g_iTagsAirblastRequirement[calling_player_idx] > g_iTagsAirblastDamage[calling_player_idx])
  	SetEntPropFloat(iTarget, Prop_Send, "m_flNextSecondaryAttack", 31536000.0+GetGameTime());	//3 years
  else
  	SetEntPropFloat(iTarget, Prop_Send, "m_flNextSecondaryAttack", 0.0);
}

void ConfigEvent_AirBlast_OnTakeDamage(VSH2Player player, float damage, int weapon)
{
  int primary = player.GetWeaponSlotIndex(TF2WeaponSlot_Primary);
	if (primary == INVALID_ENT_REFERENCE)
		return;

  int attacker = player.index;
	if (g_iTagsAirblastRequirement[attacker] > 0 && primary == weapon)
	{
		bool full = (g_iTagsAirblastDamage[attacker] >= g_iTagsAirblastRequirement[attacker]);
		g_iTagsAirblastDamage[attacker] += RoundToNearest(damage);

		if (g_iTagsAirblastDamage[attacker] >= g_iTagsAirblastRequirement[attacker])
		{
			g_iTagsAirblastDamage[attacker] = g_iTagsAirblastRequirement[attacker];

			if (!full)
			{
				EmitSoundToClient(attacker, SOUND_METERFULL);	//Alert player meter is fully
				SetEntPropFloat(primary, Prop_Send, "m_flNextSecondaryAttack", 0.0);	//Allow airblast to be used
			}
		}
  }
}

void ConfigEvent_AirBlast_Think(VSH2Player player)
{
  int client = player.index
  if (g_iTagsAirblastRequirement[client] > 0 && g_iTagsAirblastDamage[client] >= g_iTagsAirblastRequirement[client])
	{
		//Detect if airblast is used, and reset if so
		int primary = player.GetWeaponSlotIndex(TF2WeaponSlot_Primary);
		if (primary > MaxClients)
		{
			FlamethrowerState state = view_as<FlamethrowerState>(GetEntProp(primary, Prop_Send, "m_iWeapostate"));
			if (state != g_nTagsAirblastState[client] && state == FlamethrowerState_Airblast)
			{
				g_iTagsAirblastDamage[client] = 0;	//Reset damage
				SetEntPropFloat(primary, Prop_Send, "m_flNextSecondaryAttack", 31536000.0+GetGameTime());	//3 years
			}

			g_nTagsAirblastState[client] = state;
		}
	}
}

void ConfigEvent_AirBlast_Button(VSH2Player player, int &buttons)
{
  int client = player.index;
  //Prevent clients holding m2 while airblast in cooldown
	if (buttons & IN_ATTACK2 && g_iTagsAirblastRequirement[client] > 0 && g_iTagsAirblastDamage[client] < g_iTagsAirblastRequirement[client])
	{
		int primary = player.GetWeaponSlotIndex(TF2WeaponSlot_Primary);
		int activewep = GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon");
		if (activewep > MaxClients && primary == activewep)
			buttons &= ~IN_ATTACK2;

		//Change the m_iWeaponState to a proper value after the airblast to prevent the visual bug
		if (g_nTagsAirblastState[client] == FlamethrowerState_Airblast)
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

stock float GetAirblastPercentage(int client)
{
	if (g_iTagsAirblastRequirement[client] <= 0)
		return -1.0;

	return float(g_iTagsAirblastDamage[client]) / float(g_iTagsAirblastRequirement[client]);
}
