#include <tf2wearables>
//https://github.com/nosoop/sourcemod-tf2wearables/blob/master/addons/sourcemod/scripting/include/tf2wearables.inc
#include <weapondata>
//https://forums.alliedmods.net/showthread.php?t=262695

public Action ConfigEvent_AddClip(EventMap args, ConfigEventType_t event_type)
{
  int calling_player_idx;
	VSH2Player calling_player;
	if (!args.GetTarget(calling_player_idx, calling_player))
		return Plugin_Continue;

  int iTarget = TF2_GetPlayerLoadoutSlot(calling_player_idx, args.GetInt("slot", slot), false);
  if (iTarget <= 0 || !IsValidEdict(iTarget))
		return Plugin_Continue;

  int iAmount = args.GetInt("amount");
  float flDuration = args.GetFloat("duration");

  int iClip = GetEntProp(iTarget, Prop_Send, "m_iClip1"); //leave the iTarget for now. Once we are done with the target we can use it. This will target a weapon entity index.
  SetEntProp(calling_player_idx, Prop_Send, "m_iClip1", iClip+iAmount);
  if (flDuration >= 0.0)
		CreateTimer(flDuration, Timer_ResetClip, EntIndexToEntRef(iTarget));

  return Plugin_Continue;
}

public Action Timer_ResetClip(Handle hTimer, int iRef)
{
	int iEntity = EntRefToEntIndex(iRef);
	if (iEntity > MaxClients)
	{
		int iMaxClip = GetMaxClip(iEntity);
		int iCurrentClip = GetEntProp(iEntity, Prop_Send, "m_iClip1");
		if (iCurrentClip > iMaxClip)
			iCurrentClip = iMaxClip;

		SetEntProp(iEntity, Prop_Send, "m_iClip1", iCurrentClip);
	}
}
