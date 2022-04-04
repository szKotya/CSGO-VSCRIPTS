g_hLast <- null;
g_bTickingExp <- false;
const TICKRATE_EXP = 5.0;

function GetRandomPlayer() 
{
	local players = [];
	local h;
	while ((h = Entities.FindByClassname(h, "player")) != null)
	{
		if (h.IsValid() &&
		h.GetTeam() == 3 &&
		h.GetHealth() > 0)
		{
			players.push(h);
		}
	}

	if (players.len() == 0)
	{
		return null;
	}
	else if (players.len() == 1)
	{
		return players[0];
	}
	else 
	{
		while (g_hLast == (h = players[RandomInt(0, players.len() - 1)]))
		{

		}
		return g_hLast = h;
	}
}

function StartTickExp()
{
	g_bTickingExp = true;
	TickExp();
}

function TickExp()
{
	if (!g_bTickingExp)
	{
		return;
	}
	local player = GetRandomPlayer();
	if (player == null)
	{
		return;
	}
	CreateExplode(player.EyePosition());

	CallFunction("TickExp()", TICKRATE_EXP);
}

function CreateExplode(vecOrigin)
{
	local Maker = Entities.FindByName(null, "meteor_maker");
	if (Maker == null || !Maker.IsValid())
	{
		return;
	}
	Maker.SpawnEntityAtLocation(vecOrigin, Vector(0, 0, 0));
}

function TriggerExplode(vecOrigin)
{
	local vecPlayer;
	local h;
	local radius = 256.0;
	while ((h = Entities.FindByClassnameWithin(h, "player", vecOrigin, radius)) != null)
	{
		if (h.IsValid() &&
		h.GetHealth() > 0)
		{
			vecPlayer = 1.00 - (GetDistance3D(vecOrigin, h.GetOrigin()) / radius);
			vecPlayer = Vector(vecPlayer * ((RandomInt(0, 1)) ? RandomInt(-1024, -1512) : RandomInt(1024, 1512)), vecPlayer * ((RandomInt(0, 1)) ? RandomInt(-1024, -1512) : RandomInt(1024, 1512)), RandomInt(512, 1024));
			h.SetVelocity(vecPlayer);
			DamagePlayer(h, 5);
		}
	}
	// DebugDrawCircle(vecOrigin, radius, 32, 10);
}

function InitBreak()
{
	if (RandomInt(0, 1))
	{
		caller.__KeyValueFromInt("spawnflags", 2);
	}
}

function InitLast()
{
	local array = [Entities.FindByName(null, "Pivo_HUESOS0"),
		Entities.FindByName(null, "Pivo_HUESOS1"),
		Entities.FindByName(null, "Pivo_HUESOS2"),
	];
	local iRandom;
	for (local i = 0; i < 2; i++)
	{
		iRandom = RandomInt(0, array.len() - 1);
		array[iRandom].__KeyValueFromInt("spawnflags", 2);
		array.remove(iRandom);
	}
}

::DamagePlayer <- function(player, damage)
{
	local hp = player.GetHealth() - damage;

	if (hp <= 0)
	{
		hp = -69;
	}

	EF(player, "SetHealth", "" + hp);
}

::EF <- function(item, key, value = "", d = 0)
{
	if (typeof item == "string")
	{
		EntFire(item, key, value, d);
	}
	else if (typeof item == "instance")
	{
		EntFireByHandle(item, key, value, d, item, item);
	}
}

::CallFunction <- function(func_name, fdelay = 0.0, activator = null, caller = null)
{
	EntFireByHandle(self, "RunScriptCode", "" + func_name, fdelay, activator, caller);
}

::GetDistance3D <- function(v1, v2){return sqrt((v1.x-v2.x)*(v1.x-v2.x)+(v1.y-v2.y)*(v1.y-v2.y)+(v1.z-v2.z)*(v1.z-v2.z));}
::GetDistance2D <- function(v1, v2){return sqrt((v1.x-v2.x)*(v1.x-v2.x)+(v1.y-v2.y)*(v1.y-v2.y));}
::GetDistanceZ <- function(v1, v2){return v1.z-v2.z;}

::DebugDrawCircle <- function(Vector_Center, radius, parts = 32, duration = 1.0) //0 -32 80
{
	local Vector_RGB = Vector(255, 255, 255);
	local u = 0.0;
	local vec_end = [];
	local parts_l = parts;
	local radius = radius;
	local a = PI / parts * 2;
	while (parts_l > 0)
	{
		local vec = Vector(Vector_Center.x+cos(u)*radius, Vector_Center.y+sin(u)*radius, Vector_Center.z);
		vec_end.push(vec);
		u += a;
		parts_l--;
	}
	for (local i = 0; i < vec_end.len(); i++)
	{
		if (i < vec_end.len()-1){DebugDrawLine(vec_end[i], vec_end[i+1], Vector_RGB.x, Vector_RGB.y, Vector_RGB.z, true, duration);}
		else{DebugDrawLine(vec_end[i], vec_end[0], Vector_RGB.x, Vector_RGB.y, Vector_RGB.z, true, duration);}
	}
}