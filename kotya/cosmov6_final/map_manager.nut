
::MOVETYPE_NONE <- 1				//Freezes the entity, outside sources can't move it.
::MOVETYPE_WALK <- 2				//Default player (client) move type.
::MOVETYPE_FLY <- 4						//Fly with no gravity.
::MOVETYPE_FLYGRAVITY <- 5		//Fly with gravity.
::MOVETYPE_VPHYSICS <- 6		//Physics movetype (prop models etc.)
::MOVETYPE_PUSH <- 7				//No clip to world, but pushes and crushes things.
::MOVETYPE_NOCLIP <- 8				//Noclip, behaves exactly the same as console command.
::MOVETYPE_LADDER <- 9				//For players, when moving on a ladder.
::MOVETYPE_OBSERVER <- 10		//Spectator movetype. DO NOT use this to make player spectate.

::SpeedMod <- Entities.CreateByClassname("player_speedmod");

::PLAYERS <- [];
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
	if (!TargerValid(handle) || handle.GetHealth() < 1)
	{
		return;
	}

	local player_movement_class = GetPlayerClassByHandle(handle, true);
	player_movement_class.SetSpeed(fSpeed);

	if (fTime > 0.00)
	{
		EntFire("map_script_map_manager", "RunScriptCode", "SetSpeedByActivator(" + (-fSpeed) + ", 0.00)", fTime, handle);
	}
}

::SetGravity <- function(handle, fGravity, fTime = 0.00)
{
	if (!TargerValid(handle) || handle.GetHealth() < 1)
	{
		return;
	}

	local player_movement_class = GetPlayerClassByHandle(handle, true);
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

::GetPlayerClassByHandle <- function(handle, bCreate = false)
{
	foreach(player_movement in PLAYERS)
	{
		if (player_movement.handle == handle)
		{
			return player_movement;
		}
	}

	if (bCreate)
	{
		local obj = class_player(handle);
		PLAYERS.push(obj);
		return obj;
	}
	return null;
}

g_bTicking <- true;
function Tick()
{
	if (g_bTicking)
	{
		ScriptPrintMessageCenterAll(PLAYERS[0].fSpeed + "\n" + PLAYERS[0].fGravity);
		CallFunction("Tick()", 0.1);
	}
}