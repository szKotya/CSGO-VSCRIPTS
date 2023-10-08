function OnPostSpawn()
{
   DrawBoundingBoxEntity(self, Vector(0, 255, 0), 1.01);
   EntFireByHandle(self, "RunScriptCode", "OnPostSpawn()", 1.00, null, null);
}

::DrawBoundingBoxEntity <- function(ent, color = Vector(255, 0, 255), ftime = 0.1)
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
