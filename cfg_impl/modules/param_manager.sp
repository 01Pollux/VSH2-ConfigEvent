public Action ConfigEvent_AllocateParams(EventMap args, ConfigEventType_t event_type)
{
	/*
	// ConfigEvent_AllocateParams(...);
	"<enum>"
	{
		"procedure"  "ConfigEvent_AllocateParams"
		
		"<enum>"
		{
			// int a = 32;
			"name"  "a"
			"type"	"int"
			"value" "32"
		}
		"<enum>"
		{
			// char[] b = "hello";
			"name"  "b"
			"type"	"string"
			"value" "hello"
		}
		"<enum>"
		{
			// float[] c = { 1.0, 2.0, 3.0 };
			"name"  "c"
			"type"	"float"
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
			"type"	"object"
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
	
	for (int var_i = args.Size; var_i >= 0; var_i--)
	{
		ConfigMap var_sec = args.GetIntSection(var_i);
		if (!var_sec)
			continue;
		
		int var_name_size = var_sec.GetSize("name");
		char[] var_name = new char[var_name_size];
		var_sec.Get("name", var_name, var_name_size);
		KeyValType key_type = var_sec.GetKeyValType("value");

		switch (GetTypeFromName(var_sec))
		{
		case PT_Char:
		{
			if (key_type == KeyValType_Value)
			{
				char val[1]; var_sec.Get("value", val, sizeof(val));
				ConfigSys.Params.SetValue(var_name, val[0]);
			}
			else
			{
				ConfigMap section = var_sec.GetSection("value");
				int val_count = section.Size;
				char[] val = new char[val_count];
				for (int i = 0; i < val_count; i++)
					section.GetIntKey(i, val[i], 1);
				ConfigSys.Params.SetString(var_name, val);
			}
		}
		case PT_Bool:
		{
			if (key_type == KeyValType_Value)
			{
				bool val;
				if (!var_sec.GetBool("value", val, false))
					var_sec.GetBool("value", val);
				ConfigSys.Params.SetValue(var_name, val);
			}
			else
			{
				ConfigMap section = var_sec.GetSection("value");
				int val_count = section.Size;
				bool[] val = new bool[val_count];
				for (int i = 0; i < val_count; i++)
				{
					if (!var_sec.GetIntKeyBool(i, val[i], false))
						var_sec.GetIntKeyBool(i, val[i]);
				}
				ConfigSys.Params.SetArray(var_name, val, val_count);
			}
		}
		case PT_Int:
		{
			if (key_type == KeyValType_Value)
			{
				int val; var_sec.GetInt("value", val);
				ConfigSys.Params.SetValue(var_name, val);
			}
			else
			{
				ConfigMap section = var_sec.GetSection("value");
				int val_count = section.Size;
				int[] val = new int[val_count];
				for (int i = 0; i < val_count; i++)
					var_sec.GetIntKeyInt(i, val[i]);
				ConfigSys.Params.SetArray(var_name, val, val_count);
			}
		}
		case PT_Float:
		{
			if (key_type == KeyValType_Value)
			{
				float val; var_sec.GetFloat("value", val);
				ConfigSys.Params.SetValue(var_name, val);
			}
			else
			{
				ConfigMap section = var_sec.GetSection("value");
				int val_count = section.Size;
				float[] val = new float[val_count];
				for (int i = 0; i < val_count; i++)
					var_sec.GetIntKeyFloat(i, val[i]);
				ConfigSys.Params.SetArray(var_name, val, val_count);
			}
		}
		case PT_String:
		{
			if (key_type == KeyValType_Value)
			{
				int val_size = var_sec.GetSize("value");
				char[] val = new char[val_size];
				var_sec.Get("value", val, val_size);
				ConfigSys.Params.SetString(var_name, val);
			}
			else
			{
				// Unsupported use object
			}
			
		}
		case PT_Object:
		{
			if (key_type == KeyValType_Value)
			{
				ConfigSys.Params.SetValue(var_name, var_sec.GetSection("value"));
			}
			else
			{
				ConfigMap section = var_sec.GetSection("value");
				int val_count = section.Size;
				ConfigMap[] val = new ConfigMap[val_count];
				for (int i = 0; i < val_count; i++)
					val[i] = var_sec.GetIntSection(i);
				ConfigSys.Params.SetArray(var_name, val, val_count);
			}
		}
		}
	}
	
	return Plugin_Continue;
}


public Action ConfigEvent_EraseParams(EventMap args, ConfigEventType_t event_type)
{
	/*
	// ConfigEvent_EraseParams(...);
	"<enum>"
	{
		"procedure"  "ConfigEvent_EraseParams"
		
		"<enum>"
		{
			"name"  "a"
		}
		"<enum>"
		{
			"name"  "b"
		}
	}
	*/
	
	for (int var_i = args.Size; var_i >= 0; var_i--)
	{
		ConfigMap var_sec = args.GetIntSection(var_i);
		if (!var_sec)
			continue;
		
		int var_name_size = var_sec.GetSize("name");
		char[] var_name = new char[var_name_size];
		var_sec.Get("name", var_name, var_name_size);

		ConfigSys.Params.Remove(var_name);
	}

	return Plugin_Continue;
}


public Action ConfigEvent_FormatParams(EventMap args, ConfigEventType_t event_type)
{
	/*
	// ConfigEvent_FormatParams(...);
	"<enum>"
	{
		"procedure"  "ConfigEvent_FormatParams"
		
		"<enum>"
		{
			// const char[] other_string = "AAAA";
			// char[] my_string = "A B {} {0} {1} {3}";
			// my_string == "A B C C D other_string"
			"name"	"my_string"
			"value"	"A B {} {0} {1} {3}"
			"size"	"128"
			"args"
			{
				"<enum>"	"C"				// 0
				"<enum>"	"D"				// 1
				"<enum>"	"E"				// 2
				"<enum>"	"s@other_string"// 3
				"<enum>"	"UNUSED"		// 4
				"<enum>"	"i@int_var"		// 5
				"<enum>"	"f@float_var"	// 6
				"<enum>"	"b@binary_var"	// 7
				"<enum>"	"x@hexadec_var"	// 8
				"<enum>"	"o@octal_var"	// 9
				"<enum>"	"c@char_var"	// 10
			}
		}
	}
	*/
	
	int args_count = args.Size;
	for (int var_i = 0; var_i < args_count; ++var_i)
	{
		ConfigMap var_sec = args.GetIntSection(var_i);
		if (!var_sec)
			break;
		

		int str_size;
		if (!var_sec.GetInt("size", str_size))
			str_size = 64;
		char[] var_buffer = new char[str_size]; 
		var_sec.Get("value", var_buffer, str_size);

		ConfigMap args_stack = var_sec.GetSection("args");
		int args_stack_count = args_stack ? args_stack.Size : 0;
		if (args_stack_count)
		{
			char arg_fmt[6];
			// first, replace '{}' with their arg variable
			for (int arg_stack = 0; arg_stack < args_stack_count; ++arg_stack)
			{
				int arg_name_size = args_stack.GetIntKeySize(arg_stack);
				char[] arg_name = new char[arg_name_size];
				args_stack.GetIntKey(arg_stack, arg_name, arg_name_size);
				FormatEx(arg_fmt, sizeof(arg_fmt), "{%i}", arg_stack);

				// reforward
				if (arg_name[1] == '@')
				{
					switch (arg_name[0])
					{
					case 's':
					{
						char str[128];
						ConfigSys.Params.GetString(arg_name[2], str, sizeof(str));

						ReplaceStringEx(var_buffer, str_size, "{}", str);
						ReplaceString(var_buffer, str_size, arg_fmt, str);
					}
					case 'i':
					{
						int val; ConfigSys.Params.GetValue(arg_name[2], val);
						char int_val[16];
						FormatEx(int_val, sizeof(int_val), "%i", val);

						ReplaceStringEx(var_buffer, str_size, "{}", int_val);
						ReplaceString(var_buffer, str_size, arg_fmt, int_val);
					}
					case 'f':
					{
						float val; ConfigSys.Params.GetValue(arg_name[2], val);
						char flt_val[16];
						FormatEx(flt_val, sizeof(flt_val), "%f", val);

						ReplaceStringEx(var_buffer, str_size, "{}", flt_val);
						ReplaceString(var_buffer, str_size, arg_fmt, flt_val);
					}
					case 'b':
					{
						int val; ConfigSys.Params.GetValue(arg_name[2], val);
						char bin_val[32];
						FormatEx(bin_val, sizeof(bin_val), "%b", val);

						ReplaceStringEx(var_buffer, str_size, "{}", bin_val);
						ReplaceString(var_buffer, str_size, arg_fmt, bin_val);
					}
					case 'x':
					{
						int val; ConfigSys.Params.GetValue(arg_name[2], val);
						char hex_val[32];
						FormatEx(hex_val, sizeof(hex_val), "%x", val);

						ReplaceStringEx(var_buffer, str_size, "{}", hex_val);
						ReplaceString(var_buffer, str_size, arg_fmt, hex_val);
					}
					case 'o':
					{
						int val; ConfigSys.Params.GetValue(arg_name[2], val);
						char oct_val[32];
						FormatEx(oct_val, sizeof(oct_val), "%o", val);

						ReplaceStringEx(var_buffer, str_size, "{}", oct_val);
						ReplaceString(var_buffer, str_size, arg_fmt, oct_val);
					}
					case 'c':
					{
						int val; ConfigSys.Params.GetValue(arg_name[2], val);
						char c_val[1]; c_val[0] = view_as<char>(val);
						
						ReplaceStringEx(var_buffer, str_size, "{}", c_val);
						ReplaceString(var_buffer, str_size, arg_fmt, c_val);
					}
					}
				}
				else 
				{
				 	ReplaceStringEx(var_buffer, str_size, "{}", arg_name);
					ReplaceString(var_buffer, str_size, arg_fmt, arg_name);
				}
			}
		}

		int var_name_size = var_sec.GetSize("name");
		char[] var_name = new char[var_name_size];
		var_sec.Get("name", var_name, var_name_size);

		ConfigSys.Params.SetString(var_name, var_buffer);
	}

	return Plugin_Continue;
}


public Action ConfigEvent_WriteReturn(EventMap args, ConfigEventType_t event_type)
{
	/*
	// ConfigEvent_WriteReturn(...);
	"<enum>"
	{
		"procedure"  "ConfigEvent_WriteReturn"
		
		"return"		"continue"
		// "return"		"changed"
		// "return"		"handled"
		// "return"		"stop"
	}
	*/
	
	char return_names[][] = {
		"continue",
		"changed",
		"handled",
		"stop"
	};

	int return_str_size = args.GetSize("return");
	if (!return_str_size)
		return Plugin_Continue;
	char[] return_str = new char[return_str_size];
	args.Get("return", return_str, return_str_size);

	for (int i = 0; i < sizeof(return_names); i++)
	{
		if (!strcmp(return_names[i], return_str))
			return view_as<Action>(i);
	}
	return Plugin_Continue;
}

public Action ConfigEvent_ParseForumla(EventMap args, ConfigEventType_t event_type)
{
	/*
	// ConfigEvent_ParseForumla(...);
	"<enum>"
	{
		"procedure"  "ConfigEvent_ParseForumla"
		
		"<enum>"
		{
			// int my_n = 10;
			// const char[] other_string = "12 + 10 ^ 10 + 0 + 9.0";
			"name"		"my_val"
			"from"		"@other_string"
			//"from"	"12 + 10 ^ 10 + 0 + 9.0"
			"truncate"	"true"
		}
	}
	*/
	
	int args_count = args.Size;
	for (int var_i = 0; var_i < args_count; ++var_i)
	{
		ConfigMap var_sec = args.GetIntSection(var_i);
		if (!var_sec)
			break;
		
		int from_str_size = var_sec.GetSize("from");
		char[] from_str = new char[from_str_size]; 
		var_sec.Get("from", from_str, from_str_size);
		if (from_str[0] == '@')
		{
			char str[128];
			ConfigSys.Params.GetString(from_str[1], str, sizeof(str));
			ConfigEvent_ParseForumla_Internal(var_sec, str);
		}
		else
		{
			ConfigEvent_ParseForumla_Internal(var_sec, from_str);
		}
	}

	return Plugin_Continue;
}

static void ConfigEvent_ParseForumla_Internal(ConfigMap var_sec, const char[] from_str)
{
	any val = ParseFormulaEx(from_str, "", view_as<float>({ 0.0 }), 0);
	bool trucate;
	if (var_sec.GetBool("truncate", trucate, false) && trucate)
		val = RoundToFloor(val);
	
	int val_name_size = var_sec.GetSize("name");
	char[] val_name = new char[val_name_size];
	var_sec.Get("name", val_name, val_name_size);
	ConfigSys.Params.SetValue(val_name, val);
}