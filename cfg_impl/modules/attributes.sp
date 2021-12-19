#include <tf2attributes>

public Action ConfigEvent_AddAttribPlayer(EventMap args, ConfigEventType_t event_type)
{
    int calling_player_idx;
	VSH2Player calling_player;
	if (!args.GetTarget(calling_player_idx, calling_player))
		return Plugin_Continue;

    char name[PLATFORM_MAX_PATH] = args.GetString("name"); //check items_game.txt for attributes
    float value = args.GetFloat("value");
    float duration = args.GetFloat("duration");
        if (!duration)
            duration = -1.0;    //cannot automatically remove

    TF2Attrib_AddCustomPlayerAttribute(calling_player_idx, name, value, duration);

    return Plugin_Continue;
}

public Action ConfigEvent_SetAttribWep(EventMap args, ConfigEventType_t event_type)
{
    int calling_player_idx;
	VSH2Player calling_player;
	if (!args.GetTarget(calling_player_idx, calling_player))
		return Plugin_Continue;

    int index = args.GetInt("index");
    float value = args.GetFloat("value");
    float duration = args.GetFloat("duration"); //0.0 means do not reset
    int weapon = GetPlayerWeaponSlot(calling_player_idx, args.GetInt("slot"));


    if (IsValidEntity(weapon))
    {
        bool attrib_exists = false;
        float o_value;
        Address attrib_address = TF2Attrib_GetByDefIndex(weapon, index);    //Address_Null if attribute doesn't exist
        int attrib = TF2Attrib_GetDefIndex(attrib_address);
        if (attrib == index)    //weapon has the attrib before being add. need to get original value.
        {
            float o_value = TF2Attrib_GetValue(attrib_address);
            attrib_exists = true;
        }
        TF2Attrib_SetByDefIndex(weapon, index, value);
        TF2Attrib_ClearCache(weapon);
        if (duration > 0.0)
        {
            DataPack data;
            CreateDataTimer(duration, Timer_ResetAttribWep, data);
            data.ReadCell(EntIndexToEntRef(weapon));
            data.ReadCell(index);
            data.ReadCell(bFound);
                if (attrib_exists)
                    data.ReadFloat(o_value);
        }
    }
    return Plugin_Continue;
}

public Action Timer_ResetAttribWep(Handle hTimer, DataPack data)
{
    data.Reset();

    int weapon = EntRefToEntIndex(data.ReadCell());
    int index = data.ReadCell();
    bool attrib_exists = data.ReadCell();
    if (attrib_exists)
        float o_value = data.ReadFloat();

    if (IsValidEntity(weapon))
    {
        if (attrib_exists)
            TF2Attrib_SetByDefIndex(weapon, index, o_value);
        else
            TF2Attrib_RemoveByDefIndex(weapon, index);

        TF2Attrib_ClearCache(weapon);
    }

    delete data;

    return Plugin_Continue;
}
