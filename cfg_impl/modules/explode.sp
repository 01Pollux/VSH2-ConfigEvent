public Action ConfigEvent_Explode(EventMap args, ConfigEventType_t event_type)
{

  int calling_player_idx;
	VSH2Player calling_player;
	if (!args.GetTarget(calling_player_idx, calling_player))
		return Plugin_Continue;

  //make entity explode. it's possible to target a entity(such as a projectile, healing bolt, energy orb)
  int explode_target = args.GetTargetEnt("enttarget");

	if (target <= 0 || !IsValidEdict(target) || GameRules_GetRoundState() == RoundState_Preround)
		return;

	float damage = args.GetFloat("damage");
	float radius = args.GetFloat("radius");

	//If no particle was specified, pick a generic explosion particle
	char particle[PLATFORM_MAX_PATH];
	if (!args.GetString("particle", particle, sizeof(particle)))
		Format(particle, sizeof(particle), "ExplosionCore_MidAir");

	//If no sounds were specified, pick a generic explosion sound. If multiple sounds were specified, pick a random one
	char sound[PLATFORM_MAX_PATH];
	if (!tParams.GetStringRandom("sound", sound, sizeof(sound)))
		Format(sound, sizeof(sound), "weapons/airstrike_small_explosion_0%d.wav", GetRandomInt(1, 3));

	float vecPos[3];
	GetEntPropVector(target, Prop_Send, "m_vecOrigin", vecPos);
	//DoExplosion(client, damage, radius, vecPos); //DoExplosion cannot be used to rocketjump
  TF2_Explode(calling_player_idx, vecPos, damage, radius, particle, sound);
}

stock void TF2_Explode(int iAttacker = -1, float flPos[3], float flDamage, float flRadius, const char[] strParticle, const char[] strSound)
{
	int iBomb = CreateEntityByName("tf_generic_bomb");
	DispatchKeyValueVector(iBomb, "origin", flPos);
	DispatchKeyValueFloat(iBomb, "damage", flDamage);
	DispatchKeyValueFloat(iBomb, "radius", flRadius);
	DispatchKeyValue(iBomb, "health", "1");
	DispatchKeyValue(iBomb, "explode_particle", strParticle);
	DispatchKeyValue(iBomb, "sound", strSound);
	DispatchSpawn(iBomb);

	if (iAttacker == -1)
		AcceptEntityInput(iBomb, "Detonate");
	else
		SDKHooks_TakeDamage(iBomb, 0, iAttacker, 9999.0);
}
