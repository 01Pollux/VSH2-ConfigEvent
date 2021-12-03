public Action ConfigEvent_WriteParams(EventMap args, ConfigEventType_t event_type)
{
	/*
	// ConfigEvent_WriteParams(...);
	"<enum>"
	{
		"procedure"  "ConfigEvent_WriteParams"
		
		"<enum>"
		{
			// any a = 32.0;
			"name"  "a"
			"value" "32.0"
		}
		"<enum>"
		{
			// any[] b = "hello";
			"name"  "b"
			"value" "hello"
		}
		// TODO: add support for the new cfgmap
		// "<enum>"
		// {
		//	 any[] c = { 1.0, 2.0, 3.0 };
		//	 "name"  "c"
		//	 "value" [ '1.0', '2.0', '3.0' ]
		// }
		"<enum>"
		{
			// any[] c = { 1.0, 2.0, 3.0 };
			"name"  "c"
			"value"
			{
				"<enum>"	"1.0"
				"<enum>"	"2.0"
				"<enum>"	"3.0"
			}
		}
		"<enum>"
		{
			// auto c = { { "something", 0.0 }, { "awesome", 1.0 } };
			// in reality:
			// ConfigMap c = { { "<enum>", { "something", "0.0" } },  { "<enum>", { "awesome", "1.0" } } };
			"name"  "c"
			"value"
			{
				"<enum>"
				{
					"name"  "something"
					"value" "0.0"
				}
				"<enum>"
				{
					"name"  "awesome"
					"value" "1.0"
				}
			}
		}
	}
	*/
	
	for (int i = args.Size - 1; i >= 0; i--)
	{
		ConfigMap var_sec = args.GetIntSection(i);
		if (!var_sec)
			break;
		
		int var_name_size = var_sec.GetSize("name");
		char[] var_name = new char[var_name_size];
		var_sec.Get("name", var_name, var_name_size);

		switch (var_sec.GetKeyValType("value"))
		{
			case KeyValType_Section:
			{
				ConfigSys.Params.SetValue(var_name, var_sec.GetSection("value"));
			}
			case KeyValType_Value:
			{
				ConfigSys.Params.SetValue(var_name, var_sec);
			}
		}
	}
}

// public Action ConfigEvent_BreakIf(EventMap args, ConfigEventType_t event_type)
// {
// }