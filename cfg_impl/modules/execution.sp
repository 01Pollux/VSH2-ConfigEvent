enum
{
    JIFLAGS_EQUAL   = (1 << 0),
    JIFLAGS_LESS    = (1 << 1),
    JIFLAGS_GREATER = (1 << 2),
    JIFLAGS_AND     = (1 << 3),
    JIFLAGS_OR      = (1 << 4),
    JIFLAGS_XOR     = (1 << 5),
    JIFLAGS_NOT     = (1 << 6)
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

        // execute the 'success' functions if operators is
        // first [==, !=, <, >, <=, >=, |, &] second
        // "first" and "second" are variable must be set in ConfigSys.Params
        // "cfirst" and "csecond" are constants
		"procedure"  "ConfigEvent_JumpIf"

        // must be set if we won't be using their counterpart
        // "cfirst"        "3"
        // "csecond"       "3"

        "operators"     ""
        // skip the next 3 "<enum>" if the results were successful
        "skips"         "3"


        // // a < b
        // "first"         "a"
        // "second"        "b"
        // "operators"     "10" // Less

        // // a > b == !(a <= b)
        // "first"         "a"
        // "second"        "b"
        // "operators"     "100"    // Greater
        // // "operators"  "100011" // Less or equal

        // // a != b
        // "first"         "a"
        // "second"        "b"
        // "operators"     "1000001"    // No equal

        // // !(a ^ b)
        // "first"         "a"
        // "second"        "b"
        // "operators"     "1100000"    // Not Xor (NXOR)

        // // !(a | b)
        // "first"         "a"
        // "second"        "b"
        // "operators"     "1010000"    // Not Or (NOR)
	}
	*/

    any first, second;
    if (!(ConfigSys.Params.GetValue("first", first) || args.GetInt("cfirst", first)))
        return Plugin_Continue;
    if (!(ConfigSys.Params.GetValue("second", second) || args.GetInt("csecond", second)))
        return Plugin_Continue;

    int jiflags; args.GetInt("operators", jiflags);

    bool success = false;
    if ((jiflags & JIFLAGS_EQUAL) && first == second)
        success = true;

    if (!success && (jiflags & JIFLAGS_LESS) && (first < second))
        success = true;

    if (!success && (jiflags & JIFLAGS_GREATER) && (first > second))
        success = true;

    if (!success && (jiflags & JIFLAGS_AND) && (first & second))
        success = true;

    if (!success && (jiflags & JIFLAGS_OR) && (first | second))
        success = true;

    if ((jiflags & JIFLAGS_NOT))
        success = !success;

    if (success)
    {
        int skips; args.GetInt("skips", skips);
        return view_as<Action>(Plugin_SkipN * 2) + view_as<Action>(skips);
    }
    else return Plugin_Continue;
}
