//#include <tf2wearables>
//https://github.com/nosoop/sourcemod-tf2wearables/blob/master/addons/sourcemod/scripting/include/tf2wearables.inc
//#include <weapondata>
//https://forums.alliedmods.net/showthread.php?t=262695

public Action ConfigEvent_AddClip(EventMap args, ConfigEventType_t event_type)
{
  int calling_player_idx;
	VSH2Player calling_player;
	if (!args.GetTarget(calling_player_idx, calling_player))
		return Plugin_Continue;

  int iAmount = args.GetInt("amount");

  int iClip = GetClip(calling_player_idx, args.GetInt("slot", slot));
  SetClip(calling_player_idx, args.GetInt("slot", slot), iClip+iAmount);

  return Plugin_Continue;
}

}
