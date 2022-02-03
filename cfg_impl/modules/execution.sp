enum 
{
    JIFLAGS_EQUAL       = (1 << 0),
    JIFLAGS_LESS        = (1 << 1),
    JIFLAGS_GREATER     = (1 << 2),
    JIFLAGS_AND         = (1 << 3),
    JIFLAGS_OR          = (1 << 4),
    JIFLAGS_XOR         = (1 << 5),
    JIFLAGS_NOT         = (1 << 6)
};

/**
 * Rewind or skip functions if the comparaison between 'first' and 'second' was successful
 */
public Action ConfigEvent_JumpIf(EventMap args, ConfigEventType_t event_type)
{
    /*
	"<enum>"
	{
        // 0000001: Equal
        // 0000010: Less
        // 0000100: Greater
        // 0001000: And
        // 0010000: Or
        // 0100000: Xor
        // 1000000: Not

        // skip the next procedures on success
        // first [==, !=, <, >, <=, >=, |, &] second
        // "first" and "second" are variable must be set in ConfigSys.Params
		"procedure"  "ConfigEvent_SkipIf"

        // flags to read first/second as floating point instead of integers
        // "fsecond"    "true"
        // "ffirst"     "true"

        "operators"     ""
        // skip the next 3 "<enum>" if the results were successful
        "skips"         "3"


        // // a < b
        // "first"         "@a"
        // "second"        "@b"
        // "operators"     "10" // Less

        // // a > b == !(a <= b)
        // "first"         "@a"
        // "second"        "@b"
        // "operators"     "100"    // Greater
        // // "operators"  "100011" // Less or equal

        // // a != 0
        // "first"         "@a"
        // "second"        "0"
        // "operators"     "1000001"    // No equal

        // // !(1 ^ b)
        // "first"         "1"
        // "second"        "@b"
        // "operators"     "1100000"    // Not Xor (NXOR)

        // // !(12 | 32)
        // "first"         "12"
        // "second"        "32"
        // "operators"     "1010000"    // Not Or (NOR)
	}
	*/

    any first, second;
    bool first_is_float, second_is_float;
    char tmp_name[36];

    args.GetBool("ffirst", first_is_float, false);
    args.GetBool("fsecond", second_is_float, false);

    if (args.Get("first", tmp_name, sizeof(tmp_name)))
    {
        if (tmp_name[0] == '@')
            ConfigSys.Params.GetValue(tmp_name[1], first);
        else
        {
            if (first_is_float)
                first = StringToFloat(tmp_name);
            else 
                first = StringToInt(tmp_name);
        }
    }
    else return Plugin_Continue;
    if (args.Get("second", tmp_name, sizeof(tmp_name)))
    {
        if (tmp_name[0] == '@')
            ConfigSys.Params.GetValue(tmp_name[1], first);
        else
        {
            if (first_is_float)
                first = StringToFloat(tmp_name);
            else 
                first = StringToInt(tmp_name);
        }
    }
    else return Plugin_Continue;

    int jiflags; args.GetInt("operators", jiflags, 2);

    bool success = true;
    if (jiflags & JIFLAGS_LESS)
    {
        if (first_is_float)
        {
            if (second_is_float)
                success = view_as<float>(first) < view_as<float>(second);
            else
                success = view_as<float>(first) < float(second);
        }
        else
        {
            if (second_is_float)
                success = float(first) < view_as<float>(second);
            else
                success = first < second;
        }
        if ((jiflags & JIFLAGS_EQUAL) && !success)
        {
            if (first_is_float)
            {
                if (second_is_float)
                    success = view_as<float>(first) == view_as<float>(second);
                else
                    success = view_as<float>(first) == float(second);
            }
            else
            {
                if (second_is_float)
                    success = float(first) == view_as<float>(second);
                else
                    success = first == second;
            }
        }
    }
    else if (jiflags & JIFLAGS_GREATER)
    {
        if (first_is_float)
        {
            if (second_is_float)
                success = view_as<float>(first) > view_as<float>(second);
            else
                success = view_as<float>(first) > float(second);
        }
        else
        {
            if (second_is_float)
                success = float(first) > view_as<float>(second);
            else
                success = first > second;
        }
        if ((jiflags & JIFLAGS_EQUAL) && !success)
        {
            if (first_is_float)
            {
                if (second_is_float)
                    success = view_as<float>(first) == view_as<float>(second);
                else
                    success = view_as<float>(first) == float(second);
            }
            else
            {
                if (second_is_float)
                    success = float(first) == view_as<float>(second);
                else
                    success = first == second;
            }
        }
    }

    if (!first_is_float && !second_is_float)
    {
        if (jiflags & JIFLAGS_AND)
            success = (first & second);
        else if (jiflags & JIFLAGS_OR)
            success = (first | second);
        else if (jiflags & JIFLAGS_XOR)
            success = (first | second);
    }

    if (jiflags & JIFLAGS_NOT)
        success = !success;

    if (success)
    {
        int skips; args.GetInt("skips", skips);
        return view_as<Action>(Plugin_SkipN * 2) + view_as<Action>(skips);
    }
    else return Plugin_Continue;
}