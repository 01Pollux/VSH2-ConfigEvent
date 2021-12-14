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

	if (g_iTagsAirblastRequirement[iAttacker] > 0 && primary == weapon)
	{
		bool bFull = (g_iTagsAirblastDamage[player.index] >= g_iTagsAirblastRequirement[player.index]);
		g_iTagsAirblastDamage[player.index] += RoundToNearest(damage);

		if (g_iTagsAirblastDamage[player.index] >= g_iTagsAirblastRequirement[player.index])
		{
			g_iTagsAirblastDamage[player.index] = g_iTagsAirblastRequirement[player.index];

			if (!bFull)
			{
				EmitSoundToClient(player.index, SOUND_METERFULL);	//Alert player meter is fully
				SetEntPropFloat(primary, Prop_Send, "m_flNextSecondaryAttack", 0.0);	//Allow airblast to be used
			}
		}
  }
}

stock float GetAirblastPercentage(int client) //I can't leave those vars. But since you can use stock anywhere.
{
	if (g_iTagsAirblastRequirement[client] <= 0)
		return -1.0;

	return float(g_iTagsAirblastDamage[client]) / float(g_iTagsAirblastRequirement[client]);
}
