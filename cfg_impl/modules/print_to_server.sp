public Action ConfigEvent_PrintToServer(EventMap args, ConfigEventType_t event_type)
{
    /* 
    "playercrits"
	{
		// ConfigEvent_AddTFCond(TFCond[] condition, const char[] target);
		"<enum>"
		{
			"procedure"  "ConfigEvent_PrintToServer"
			"text"	"Hello from config"
		}
	}
    */
    switch (event_type)
    {
        case CET_UberDeploy:
        {
            // Deployed uber from WhiteFalcon to 2
            VSH2Player medic; ConfigSys.Params.GetValue("medic", medic);
            VSH2Player patient; ConfigSys.Params.GetValue("patient", patient);
            PrintToServer("Deployed uber from %N to %i", medic.index, patient ? patient.index : -1);
        }
        case CET_RedPlayerCrits:
        {
            // Player:  Hello from config
            int str_size = args.GetSize("text");
            char[] str = new char[str_size];
            args.Get("text", str, str_size);
            PrintToServer("Player Said:  %s", str);
        }
    }
}