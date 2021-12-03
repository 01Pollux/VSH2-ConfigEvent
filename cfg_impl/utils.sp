enum
{
	TF2WeaponSlot_Primary = 0,
	TF2WeaponSlot_Secondary,
	TF2WeaponSlot_Melee,
	TF2WeaponSlot_PDABuild,
	TF2WeaponSlot_PDADisguise = 3,
	TF2WeaponSlot_PDADestroy,
	TF2WeaponSlot_InvisWatch = 4,
	TF2WeaponSlot_BuilderEngie,

	TF2WeaponSlot_MaxWeapons
}

enum ConfigEventParam_t 
{
	CEP_Cell,
	CEP_CellRef,
	CEP_Float,
	CEP_FloatRef,
	CEP_Array,
	CEP_ArrayRef,
	CEP_String
//	CEP_StringRef
}

enum ShakeCommand_t
{
	SHAKE_START,			// Starts the screen shake for all players within the radius.
	SHAKE_STOP,				// Stops the screen shake for all players within the radius.
	SHAKE_AMPLITUDE,		// Modifies the amplitude of an active screen shake for all players within the radius.
	SHAKE_FREQUENCY,		// Modifies the frequency of an active screen shake for all players within the radius.
	SHAKE_START_RUMBLEONLY,	// Starts a shake effect that only rumbles the controller, no screen effect.
	SHAKE_START_NORUMBLE	// Starts a shake that does NOT rumble the controller.
};

#define AREA_COND_MY_TEAM		(1 << 0)
#define AREA_COND_OTHER_TEAM	(1 << 1)
#define AREA_COND_MY_MINIONS	(1 << 2)
#define AREA_COND_OTHER_MINIONS	(1 << 3)

int CountCharInString(const char[] str, char c)
{
	int total = 0;
	for (int i = strlen(str) - 1; i >= 0; i--)
	{
		if (str[i] == c)
			++total;
	}
	return total;
}

#define MAX_SHAKE_AMPLITUDE 16.0

void ScreenShakeOne(int client, float amplitude, float frequency, float duration, ShakeCommand_t command, const char[] sound = "", bool airshake = true)
{
	if (!airshake && command == SHAKE_START && GetEntityFlags(client) & ~FL_ONGROUND)
		return;

	if (amplitude > MAX_SHAKE_AMPLITUDE)
		amplitude = MAX_SHAKE_AMPLITUDE;

	float origin[3];
	GetClientAbsOrigin(client, origin);
	if (sound[0])
		EmitSoundToClient(client, sound);

	TransmitShakeEvent(client, amplitude, frequency, duration, command);
}

void ScreenShakeAll(const float center[3], float amplitude, float frequency, float duration, float radius, ShakeCommand_t command, const char[] sound, bool airshake = true)
{
	if (amplitude > MAX_SHAKE_AMPLITUDE)
		amplitude = MAX_SHAKE_AMPLITUDE;

	float origin[3];

	for (int i = 1; i <= MaxClients; i++)
	{
		if (!IsClientInGame(i) || !IsPlayerAlive(i))
			continue;

		if (!airshake && command == SHAKE_START && GetEntityFlags(i) & ~FL_ONGROUND)
			continue;

		GetClientAbsOrigin(i, origin);
		float cur_amplitude = ComputeShakeAmplitude(center, origin, amplitude, radius);
		if (cur_amplitude < 0)
			continue;

		if (sound[0] && GetVectorDistance(center, origin, true) <= radius * radius)
			EmitSoundToClient(i, sound);

		TransmitShakeEvent(i, cur_amplitude, frequency, duration, command);
	}
}

static stock void TransmitShakeEvent(int client, float amplitude, float frequency, float duration, ShakeCommand_t command)
{
	if (amplitude > 0.0 || command == SHAKE_STOP)
	{
		if (command)	
			amplitude = 0.0;

		BfWrite shake_msg = UserMessageToBfWrite(StartMessageOne("Shake", client, 1));

		shake_msg.WriteByte(view_as<int>(command));
		shake_msg.WriteFloat(amplitude);
		shake_msg.WriteFloat(frequency);
		shake_msg.WriteFloat(duration);

		EndMessage();
	}
}

static stock float ComputeShakeAmplitude(const float center[3], const float shake_point[3], float amplitude, float radius)
{
	if (radius <= 0.0)
		return amplitude;

	float delta[3];
	SubtractVectors(center, shake_point, delta);
	float distance = GetVectorLength(delta);

	return distance <= radius ? (amplitude * (1.0 - (distance / radius))) : -1.0;
}
