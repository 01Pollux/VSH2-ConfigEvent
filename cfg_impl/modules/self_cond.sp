public Action ConfigEvent_AddSelfTFCond(VSH2Player player, const int client, EventMap args, ConfigEventType_t event_type)
{
	/*
	// ConfigEvent_AddSelfTFCond(TFCond[] condition);
	"<enum>"
	{
		"procedure"  "ConfigEvent_AddSelfTFCond"
		
		"conditions"
		{
			"<enum>"
			{
				"id"		"3"
				"duration"  "2.0"
			}
			"<enum>"
			{
				"id"			"3"
				// similar to   "2.0 + (n / 1000.0) * 30.0"
				"damage_add"	"(n / 1000.0) * 30.0"
				"duration"	  "2.0"
			}
		}
	}
	*/
	
	char extra_add[32];
	for (int i = args.Size - 1; i >= 0; i--)
	{
		ConfigMap cond = args.GetIntSection(i);
		if (!cond)
			break;
		TFCond id; cond.GetInt("id", view_as<int>(id));
		float duration; cond.GetFloat("duration", duration);
		if (cond.Get("damage_add", extra_add, sizeof(extra_add)))
			duration += ParseFormula(extra_add, player.GetPropInt("iDamage"));
		
		TF2_AddCondition(client, id, duration);
	}
	return Plugin_Continue;
}