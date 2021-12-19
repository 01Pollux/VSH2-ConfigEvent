public Action ConfigEvent_Explode(EventMap args, ConfigEventType_t event_type)
{
	/*
	// ConfigEvent_Explode();
	"<enum>"
	{
		"procedure"  "ConfigEvent_Explode"
		"vsh2target" "player"
		"damage"	"25.0"
		"radius"	"25.0"
		"sound"		"..."
		"particle"		"..."
	}
	*/
	int calling_player_idx;
	VSH2Player calling_player;
	int explode_target;

	if (!args.GetTarget(calling_player_idx, calling_player))
		return Plugin_Continue;

	//make entity explode. it's possible to target a entity(such as a projectile, healing bolt, energy orb)
	if (!args.GetTargetEnt(explode_target) || !IsValidEntity(explode_target) || GameRules_GetRoundState() == RoundState_Preround)
		return Plugin_Continue;

	float damage; args.GetFloat("damage", damage);
	float radius; args.GetFloat("radius", radius);

	//If no particle was specified, pick a generic explosion particle
	char particle[64];
	if (!args.GetString("particle", particle, sizeof(particle)))
		particle = "ExplosionCore_MidAir";

	//If no sounds were specified, pick a generic explosion sound. If multiple sounds were specified, pick a random one
	char sound[PLATFORM_MAX_PATH];
	{
		ConfigMap sound_sec = args.GetSection("sound");
		int sound_size = sound_sec ? sound_sec.Size : 0;
		if (!sound_size || sound_sec.GetIntKey(GetRandomInt(0, sound_size - 1), sound, sizeof(sound)))
			FormatEx(sound, sizeof(sound), "weapons/airstrike_small_explosion_0%d.wav", GetRandomInt(1, 3));
	}

	float origin[3];
	GetEntPropVector(explode_target, Prop_Send, "m_vecOrigin", origin);
	TF2_Explode(calling_player_idx, origin, damage, radius, particle, sound);

	return Plugin_Continue;
}