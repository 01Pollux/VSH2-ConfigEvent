# VSH2-ConfigEvent

Execute function based on event in VSH2. Inspired by

[redsunservers/VSH-Rewrite](https://github.com/redsunservers/VSH-Rewrite). Also some codes are from VSH-Rewrite.

## Install

Install the dependencies first.

- [VSH2](https://github.com/VSH2-Devs/Vs-Saxton-Hale-2)
- [TF2Attributes](https://forums.alliedmods.net/showthread.php?t=210221)
- [TFUtils](https://github.com/nosoop/SM-TFUtils/)

Then compile vsh2-configsys.sp with the compiler. `./spcomp vsh2-configsys.sp`

## Modules

Check [cfg_impl/modules](https://github.com/01Pollux/VSH2-ConfigEvent/tree/main/cfg_impl/modules) to see existing modules and usage.

## Usage

Check [test/vsh2.cfgevent](https://github.com/01Pollux/VSH2-ConfigEvent/blob/main/test/vsh2.cfgevent) for examples. The config file should be in `sourcemod/configs/saxton_hale`.

`"globals"` means function will be executed as the event is called.

`"weapons"` means function will be executed as the event is called and player's active weapon's index match the one in the weapons section.

`<passive> true` in the weapon index section means it will bypass the player's active weapon check. As long as player has the weapon in their slot, the function will be executed.

## External modules

Without having to modify this plugin's source, now you can easily implement them externally.

```SourcePawn
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
```

- Each function must have this type of signature in order to be compatible and visible to ConfigEvent's system.

```SourcePawn
"<enum>"
{
    "module"        "external_plugin_test.smx"
    "procedure"	    "ConfigEvent_ExternalPrint"
    "text"          "Hello plugin"
}

```

- To export and use the plugin, add `"module"` key with the plugin's filename as its value inside the callback config.