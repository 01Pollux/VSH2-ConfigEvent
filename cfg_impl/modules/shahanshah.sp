public Action ConfigEvent_Shahanshah(EventMap args, ConfigEventType_t event_type)
{
  int calling_player_idx;
  VSH2Player calling_player;
  if (!args.GetTarget(calling_player_idx, calling_player))
    return Plugin_Continue;

  int health = GetClientHealth(calling_player_idx);
  int judge = GetEntProp(calling_player_idx, Prop_Send, "m_iMaxHealth") / 2;
  if (health <= judge)
  {
    float upwardvel = 300.0;
    ConfigSys.Params.SetValue("upwardvel", upwardvel);
    return Plugin_Changed;
  }
  else
  {
    float upwardvel = 800.0;
    ConfigSys.Params.SetValue("upwardvel", upwardvel);
    return Plugin_Changed;
  }
}
