::DebugDrawCircle <- function(Vector_Center, radius, parts = 32, duration = 10) //0 -32 80
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

::DebugDrawAxis <- function(pos, s = 16, time = 10)
{
	DebugDrawLine(Vector(pos.x-s,pos.y,pos.z), Vector(pos.x+s,pos.y,pos.z), 255, 0, 0, true, time);
	DebugDrawLine(Vector(pos.x,pos.y-s,pos.z), Vector(pos.x,pos.y+s,pos.z), 0, 255, 0, true, time);
	DebugDrawLine(Vector(pos.x,pos.y,pos.z-s), Vector(pos.x,pos.y,pos.z+s), 0, 0, 255, true, time);
}

::DrawBoundingBox <- function(Vector_Center, Vector_Bounding, color = Vector(255, 0, 255), ftime = 10)
{
	local TFR = Vector_Center + Vector(Vector_Bounding.x, Vector_Bounding.y, Vector_Bounding.z);
	local TFL = Vector_Center + Vector(-Vector_Bounding.x, Vector_Bounding.y, Vector_Bounding.z);

	local TBR = Vector_Center + Vector(Vector_Bounding.x, -Vector_Bounding.y, Vector_Bounding.z);
	local TBL = Vector_Center + Vector(-Vector_Bounding.x, -Vector_Bounding.y, Vector_Bounding.z);

	local BFR = Vector_Center + Vector(Vector_Bounding.x, Vector_Bounding.y, -Vector_Bounding.z);
	local BFL = Vector_Center + Vector(-Vector_Bounding.x, Vector_Bounding.y, -Vector_Bounding.z);

	local BBR = Vector_Center + Vector(Vector_Bounding.x, -Vector_Bounding.y, -Vector_Bounding.z);
	local BBL = Vector_Center + Vector(-Vector_Bounding.x, -Vector_Bounding.y, -Vector_Bounding.z);

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

::DebugDrawSphere <- function(vCenter, flRadius, time)
{
	local nPhi = 8;
	local nTheta = 36;
	++nTheta;
	local pVerts = array( nPhi * nTheta );
	local i, j, c = 0;
	for(i = 0; i < nPhi; ++i)
	{
		for (j = 0; j < nTheta; ++j)
		{
			local u = j / (nTheta - 1).tofloat();
			local v = i / (nPhi - 1).tofloat();
			local theta = 6.283185307 * u;
			local phi = PI * v;
			local sp = flRadius * sin(phi);
			pVerts[c++] = Vector(vCenter.x + (sp * cos(theta)), vCenter.y + (sp * sin(theta)), vCenter.z + (flRadius * cos(phi)));
		}
	}

	for(i = 0; i < nPhi - 1; ++i)
	{
		for(j = 0; j < nTheta - 1; ++j)
		{
			local idx = nTheta * i + j;
			DebugDrawLine(pVerts[idx], pVerts[idx+nTheta], 0, 0, 255, true, time);
			DebugDrawLine(pVerts[idx], pVerts[idx+1], 0, 0, 255, true, time);
		}
	}
}
