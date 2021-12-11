#include <vsh2_cfgevent>

public Action ConfigEvent_ExternalPrint(EventMap args, ConfigEventType_t type)
{
    int text_size = args.GetSize("text");
    if (!text_size)
        return Plugin_Continue;
    
    char[] text = new char[text_size];
    args.Get("text", text, text_size);
    PrintToServer("External plugin: \n\n\n%s\n\n\n", text);

    return Plugin_Continue;
}