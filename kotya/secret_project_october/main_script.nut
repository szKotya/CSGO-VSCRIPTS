IncludeScript("kotya/secret_project_october/vectors/vec_lib.nut", this);

::Main_Script <- self.GetScriptScope();

::CS_TEAM_CT <- 3;
::CS_TEAM_T <- 2;

::MODEL_ZOMBIE_HITBOX <- Entities.FindByName(null, "brush_preset_hitbox").GetModelName();
::MODEL_ZOMBIE_CUM <- Entities.FindByName(null, "brush_preset_zombie_cum").GetModelName();

function RoundStart()
{
	local h;
	h = Entities.CreateByClassname("logic_script");
	EF(h, "RunScriptFile", "kotya/secret_project_october/prespawn/prespawn_controller.nut");
	AOP(h, "targetname", "map_script_prespawn_controller");

	h = Entities.CreateByClassname("logic_script");
	EF(h, "RunScriptFile", "kotya/secret_project_october/map_manager.nut");
	AOP(h, "targetname", "map_script_map_manager");

	h = Entities.CreateByClassname("logic_script");
	EF(h, "RunScriptFile", "kotya/secret_project_october/menu/controller.nut");
	AOP(h, "targetname", "map_script_controller");

	h = Entities.CreateByClassname("logic_script");
	EF(h, "RunScriptFile", "kotya/secret_project_october/menu/menu_builder.nut");
	AOP(h, "targetname", "map_script_menu_builder");

	h = Entities.CreateByClassname("logic_script");
	EF(h, "RunScriptFile", "kotya/secret_project_october/zombie/zombie_controller.nut");
	AOP(h, "targetname", "map_script_zombie_controller");

	h = Entities.CreateByClassname("logic_script");
	EF(h, "RunScriptFile", "kotya/secret_project_october/human/human_controller.nut");
	AOP(h, "targetname", "map_script_human_controller");

	//DEBUG
	SendToConsole("sv_cheats 1");
	SendToConsole("bot_stop 1");
	// SendToConsole("bot_kick");
	SendToConsole("mp_freezetime 0");
	SendToConsole("mp_warmuptime 999999999");
}

function RoundStartPost()
{
	local fdelay = 0.5;
	local h;
	h = CreateTrigger(Vector(-7488, 8568, 16), Vector(384, 384, 160));
	AOP(h, "OnStartTouch", "map_script_map_manager:RunScriptCode:TouchSpawn():0:-1", fdelay);
	EF(h, "Enable", "", fdelay);
}

SendToConsole("mp_restartgame 1");

::class_pos <- class
{
	origin = Vector(0, 0, 0);
	ox = 0;
	oy = 0;
	oz = 0;
	angles = Vector(0, 0, 0);
	ax = 0;
	ay = 0;
	az = 0;

	constructor(_origin = Vector(0, 0, 0), _angles = Vector(0, 0, 0))
	{
		this.origin = _origin;
		this.ox = _origin.x;
		this.oy = _origin.y;
		this.oz = _origin.z;

		this.angles = _angles;
		this.ax = _angles.x;
		this.ay = _angles.y;
		this.az = _angles.z;
	}
}

::AOP <- function(item, key, value = "", d = 0.00)
{
	if (typeof item == "string")
	{
		EntFire(item, "AddOutPut", key + " " + value, d);
	}
	else if (typeof item == "instance")
	{
		if (d > 0.00)
		{
			EntFireByHandle(item, "AddOutPut", key + " " + value, d, item, item);
		}
		else
		{
			if (typeof value == "string")
			{
				item.__KeyValueFromString(key, value);
			}
			else if (typeof value == "integer")
			{
				item.__KeyValueFromInt(key, value);
			}
			else if (typeof value == "float")
			{
				item.__KeyValueFromFloat(key, value);
			}
			else if (typeof value == "vector")
			{
				item.__KeyValueFromVector(key, value);
			}
			else
			{
				EntFireByHandle(item, "AddOutPut", key + " " + value, d, item, item);
			}
		}
	}
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

::DamagePlayerByHandle <- function(damage, damagetype = null)
{
	DamagePlayer(activator, damage, damagetype);
}

::DamagePlayer <- function(player, damage, damagetype = null)
{
	local hp = player.GetHealth() - damage;

	if (hp <= 0)
	{
		hp = -69;
	}

	EF(player, "SetHealth", "" + hp);
}

::InSight <- function(start, end, ignorehandle = null)
{
	if (ignorehandle == null || typeof ignorehandle == "instance")
	{
		if (TraceLine(start, end, ignorehandle) < 1.00)
		{
			return false;
		}
		return true;
	}

	if (typeof ignorehandle == "array")
	{
		for (local i = 0; i < ignorehandle.len(); i++)
		{
			if (ignorehandle[i] == null || !ignorehandle[i].IsValid())
			{
				continue;
			}

			if (InSight(start, end, ignorehandle[i]))
			{
				return true;
			}
		}
	}

	return InSight(start, end, null);
}

::GetPlayerKnifeByOwner <- function(owner)
{
	local knife;
	while ((knife = Entities.FindByClassname(knife,"weapon_knife*")) != null)
	{
		if (knife.GetOwner() == owner)
		{
			return knife;
		}
	}
	return null;
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

::GetPithXawFVect3D <- function(a, b)
{
	local deltaX = a.x - b.x;
	local deltaY = a.y - b.y;
	local deltaZ = a.z - b.z;
	local yaw = atan2(deltaY,deltaX) * 180 / PI
	local pitch = asin(deltaZ / sqrt(deltaX * deltaX + deltaY * deltaY + deltaZ * deltaZ)) * 180 / PI;
	if(pitch > 0){pitch = -pitch;}
	else{pitch = fabs(pitch);}
	return Vector(pitch, yaw, 0);
}

::GetPredictionOriginTarget <- function(oShoot, oTarget, velTarget, iBullet, tickrate = 0.01, speedmodif = 50)
{
	local totarget = oTarget - oShoot;

	local a = VectorDot(velTarget, velTarget) - (iBullet * iBullet / tickrate * speedmodif);

	local b = 2 * VectorDot(velTarget, totarget);
	local c = VectorDot(totarget, totarget);

	local p = -b / (2 * a);
	local q = (0.00 + sqrt( ( b * b ) -4 * a * c ) / ( 2 * a) );

	local t1 = p - q;
	local t2 = p + q;

	local t;
	if( t1 > t2 &&
		t2 > 0)
		t = t2;
	else
		t = t1;

	return oTarget + velTarget * t;
}

::DebugDrawAxis <- function(pos, s = 16, time = 10)
{
	DebugDrawLine(Vector(pos.x-s,pos.y,pos.z), Vector(pos.x+s,pos.y,pos.z), 255, 0, 0, true, time);
	DebugDrawLine(Vector(pos.x,pos.y-s,pos.z), Vector(pos.x,pos.y+s,pos.z), 0, 255, 0, true, time);
	DebugDrawLine(Vector(pos.x,pos.y,pos.z-s), Vector(pos.x,pos.y,pos.z+s), 0, 0, 255, true, time);
}

::DrawBoundingBox <- function(ent, color = Vector(255, 0, 255), ftime = 0.1)
{
	local origin = ent.GetOrigin();

	local max = ent.GetBoundingMaxs();
	local min = ent.GetBoundingMins();

	local rV = ent.GetLeftVector();
	local fV = ent.GetForwardVector();
	local uV = ent.GetUpVector();

	local TFR = origin + uV * max.z + rV * max.y + fV * max.x;
	local TFL = origin + uV * max.z + rV * min.y + fV * max.x;

	local TBR = origin + uV * max.z + rV * max.y + fV * min.x;
	local TBL = origin + uV * max.z + rV * min.y + fV * min.x;

	local BFR = origin + uV * min.z + rV * max.y + fV * max.x;
	local BFL = origin + uV * min.z + rV * min.y + fV * max.x;

	local BBR = origin + uV * min.z + rV * max.y + fV * min.x;
	local BBL = origin + uV * min.z + rV * min.y + fV * min.x;

	DebugDrawLine(TFR, TFL, color.x, color.y, color.z, true, ftime);
	DebugDrawLine(TBR, TBL, color.x, color.y, color.z, true, ftime);

	DebugDrawLine(TFR, TBR, color.x, color.y, color.z, true, ftime);
	DebugDrawLine(TFL, TBL, color.x, color.y, color.z, true, ftime);

	DebugDrawLine(TFR, BFR, color.x, color.y, color.z, true, ftime);
	DebugDrawLine(TFL, BFL, color.x, color.y, color.z, true, ftime);

	DebugDrawLine(TBR, BBR, color.x, color.y, color.z, true, ftime);
	DebugDrawLine(TBL, BBL, color.x, color.y, color.z, true, ftime);

	DebugDrawLine(BFR, BBR, color.x, color.y, color.z, true, ftime);
	DebugDrawLine(BFL, BBL, color.x, color.y, color.z, true, ftime);

	DebugDrawLine(BFR, BFL, color.x, color.y, color.z, true, ftime);
	DebugDrawLine(BBR, BBL, color.x, color.y, color.z, true, ftime);
}


::GetTwoVectorsYaw <- function(start, target)
{
	local yaw = 0.00;
	local v = Vector(start.x - target.x, start.y - target.y, start.z - target.z);
	local vl = sqrt(v.x * v.x + v.y * v.y);
	yaw = 180 * acos(v.x / vl) / PI;
	if(v.y < 0)
	{
		yaw = -yaw;
	}
	return yaw;
}
//(orig, dir, maxd, filter)
::Trace <- function(origin, dir, distance = 4096, filter = null)
{
	return  origin + (dir * (distance * TraceLine(origin, origin + dir * distance, filter)));
}

::TargetValid <- function(target)
{
	if (target == null || !target.IsValid())
	{
		return false;
	}
	return true;
}

::CallFunction <- function(func_name, fdelay = 0.0, activator = null, caller = null)
{
	EntFireByHandle(self, "RunScriptCode", "" + func_name, fdelay, activator, caller);
}

::DamageType_Item <- 0;
::DamageType_Explosion <- 1;

::ValueLimiter <- function(Value, Min = null, Max = null)
{
	if (Max != null && Value > Max)
	{
		return Max;
	}
	else if (Min != null && Value < Min)
	{
		return Min;
	}
	return Value;
}

::GetSizeByWLH <- function(v1)
{
	if (typeof v1 == "Vector")
	{
		return [Vector(-v1.x * 0.5, -v1.y * 0.5, -v1.z * 0.5), Vector(v1.x * 0.5, v1.y * 0.5, v1.z * 0.5)]
	}
	else
	{
		return [Vector(-v1 * 0.5, -v1 * 0.5, -v1 * 0.5), Vector(v1 * 0.5, v1 * 0.5, v1 * 0.5)]
	}
}

::KVremoveK <- function(kv, key)
{
	local newkv = {};
	foreach (k, v in kv)
	{
		if (k == key)
		{
			continue;
		}
		newkv[k] <- v;
	}
	return newkv;
}

::KVmerge <- function(kv1, kv2)
{
	foreach(k,v in kv2)
	{
		if (KVhaveK(kv1, k))
		{
			continue;
		}
		kv1[k] <- v;
	}
	return kv1;
}

::KVhaveK <- function(kv, key)
{
	foreach(k,v in kv)
	{
		if (k == key)
		{
			return true;
		}
	}

	return false;
}