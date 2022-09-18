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

## Todo(Probably not gonna do)

- [ ] Allow custom module as a sub-plugin.
