
::MOVETYPE_NONE <- 1				//Freezes the entity, outside sources can't move it.
::MOVETYPE_WALK <- 2				//Default player (client) move type.
::MOVETYPE_FLY <- 4						//Fly with no gravity.
::MOVETYPE_FLYGRAVITY <- 5		//Fly with gravity.
::MOVETYPE_VPHYSICS <- 6		//Physics movetype (prop models etc.)
::MOVETYPE_PUSH <- 7				//No clip to world, but pushes and crushes things.
::MOVETYPE_NOCLIP <- 8				//Noclip, behaves exactly the same as console command.
::MOVETYPE_LADDER <- 9				//For PLAYERS_MOVEMENT, when moving on a ladder.
::MOVETYPE_OBSERVER <- 10		//Spectator movetype. DO NOT use this to make player spectate.

::SpeedMod <- Entities.CreateByClassname("player_speedmod");

::PLAYERS_MOVEMENT <- [];
::class_player <- class
{
	handle = null;

	fSpeed = 1.00;
	fGravity = 1.00;

	iMovetype = MOVETYPE_WALK;

	constructor (_handle)
	{
		this.handle = _handle;
	}

	function SetSpeed(fSpeed)
	{
		this.fSpeed += (0.00 + fSpeed);
		this.fSpeed = ValueLimiter(this.fSpeed, 0.00);
		EntFireByHandle(SpeedMod, "ModifySpeed", "" + this.fSpeed, 0.00, this.handle, this.handle);
	}
	function SetGravity(fGravity)
	{
		this.fGravity += 0.00 + fGravity;
		this.fGravity = ValueLimiter(this.fGravity, 0.00);
		AOP(this.handle, "gravity", this.fGravity);
	}
}

::SetSpeed <- function(handle, fSpeed, fTime = 0.00)
{
	if (!TargetValid(handle) || handle.GetHealth() < 1)
	{
		return;
	}

	local player_movement_class = GetPlayerMovementClassByHandle(handle, true);
	player_movement_class.SetSpeed(fSpeed);

	if (fTime > 0.00)
	{
		EntFire("map_script_map_manager", "RunScriptCode", "SetSpeedByActivator(" + (-fSpeed) + ", 0.00)", fTime, handle);
	}
}

::SetGravity <- function(handle, fGravity, fTime = 0.00)
{
	if (!TargetValid(handle) || handle.GetHealth() < 1)
	{
		return;
	}

	local player_movement_class = GetPlayerMovementClassByHandle(handle, true);
	player_movement_class.SetGravity(fGravity);

	if (fTime > 0.00)
	{
		EntFire("map_script_map_manager", "RunScriptCode", "SetSpeedByActivator(" + (-fSpeed) + ", 0.00)", fTime, handle);
	}
}

::SetSpeedByActivator <- function(fSpeed, fTime = 0.00)
{
	SetSpeed(activator, fSpeed, fTime);
}

::SetGravityByActivator <- function(fGravity, fTime = 0.00)
{
	SetGravity(activator, fGravity, fTime);
}

::GetPlayerMovementClassByHandle <- function(handle, bCreate = false)
{
	foreach(player_movement in PLAYERS_MOVEMENT)
	{
		if (player_movement.handle == handle)
		{
			return player_movement;
		}
	}

	if (bCreate)
	{
		local obj = class_player(handle);
		PLAYERS_MOVEMENT.push(obj);
		return obj;
	}
	return null;
}

::RemovePlayerMovementClassByHandle <- function(handle)
{
	foreach(index, player_movement in PLAYERS_MOVEMENT)
	{
		if (player_movement.handle == handle)
		{
			EntFireByHandle(SpeedMod, "ModifySpeed", "1.0", 0.00, player_movement.handle, player_movement.handle);
			AOP(player_movement.handle, "gravity", 1.0);
			PLAYERS_MOVEMENT.remove(index);
			return
		}
	}
}

::g_vecBaza <- [];
::g_BazaID <- 0;

function Init()
{
	g_vecBaza.clear();
	local x = 0;
	local y = 0;
	for (x = 0; x < 8; x++)
	{
		for (y = 0; y < 8; y++)
		{
			g_vecBaza.push(Vector(-7640 + (64 * x), 8808 + (64 * y), 12));
		}
	}
	// for (local i = 0; i < g_vecBaza.len(); i++)
	// {
	// 	DebugDrawCircle(GetOriginBAZA(), 48, 16, 20);
	// }
}
::GetOriginBAZA <- function()
{
	return g_vecBaza[((g_BazaID >= g_vecBaza.len()) ? (g_BazaID = 0) : g_BazaID++)];
}

function TouchSpawn()
{
	local origin = GetOriginBAZA();
	if (activator.GetTeam() == CS_TEAM_CT)
	{
		CreateHuman(origin);
		activator.SetOrigin(origin);
		CallFunction("activator.SetOrigin(Vector(-613 + RandomInt(-64, 64), -709 + RandomInt(-64, 64), -12))", 0.5, activator);
	}
	else
	{
		CreateZombie(origin, 2);
		activator.SetOrigin(origin);
		CallFunction("activator.SetOrigin(Vector(-704 + RandomInt(-64, 64), -165 + RandomInt(-64, 64), -12))", 0.5, activator);
	}
}

Init();