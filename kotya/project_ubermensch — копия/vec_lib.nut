//Functions below by Enviolinador:
//============================================================
/**
 * Attempts to project a triangle onto a surface in front of a point and in a direction
 * to compute the normal of the plane in that surface
 */
::GetApproxPlaneNormal <- function(orig, vec, delta=0.01, ignore= null, drawTrianglePlane=true)
{
	// Compute the direction vector
	local length = vec.Length();
	local dir = vnorm(vec);
	local yaw = atan2(dir.x, dir.z);
	local pitch = atan2(dir.y, sqrt((dir.x * dir.x) + (dir.z * dir.z)));

	// Compute R direction
	local xR = sin(yaw+delta)*cos(pitch+delta);
	local yR = sin(pitch+delta);
	local zR = cos(yaw+delta)*cos(pitch+delta);
	local endR = Vector(xR, yR, zR);
	local vecR = vscale(vnorm(endR), length);

	// Compute L direction
	local xL = sin(yaw-delta)*cos(pitch+delta);
	local yL = sin(pitch+delta);
	local zL = cos(yaw-delta)*cos(pitch+delta);
	local endL = Vector(xL, yL, zL);
	local vecL = vscale(vnorm(endL), length);

	// Find end points distance
	local distA = TraceLine(orig, vadd(orig, vec), ignore);
	local distB = TraceLine(orig, vadd(orig, vecR), ignore);
	local distC = TraceLine(orig, vadd(orig, vecL), ignore);

	// Compute the 3 triangle verts
	local vertA = vadd(orig, vscale(vec, distA));
	local vertB = vadd(orig, vscale(vecR, distB));
	local vertC = vadd(orig, vscale(vecL, distC));

	// Return a null vector if any of the traces hit nothing
	if(distA == 1 && distB == 1 && distC == 1)
		return Vector(0.0, 0.0, 0.0);


	// Draw the triangle used to compute the normal, if desired
	if(drawTrianglePlane)
	{
		DebugDrawLine(vertA, vertB, 255, 0, 0, false, 5);
		DebugDrawLine(vertB, vertC, 0, 255, 0, false, 5);
		DebugDrawLine(vertC, vertA, 0, 0, 255, false, 5);
	}


	// Compute the two planar vectors
	local t1 = vsub(vertB, vertA);
	local t2 = vsub(vertB, vertC);
	local norm = vcross(t1, t2);

	// Return if the normal is the null vector (either t1, t2 or both are null)
	if(vnull(norm))
		return norm;

	// Correct the normal if we're going in the same direction as the original vector
	norm = vnorm(norm);
	if(veqd(norm, dir))
		norm = vinv(norm);
	return norm;
}

/**
 * Compute the negated/inverse direction vector
 */
::vinv <- function(v)
{
	return Vector(-v.x, -v.y, -v.z);
}

/**
 * Add two vectors
 */
::vadd <- function(v1, v2)
{
	return Vector(v1.x + v2.x, v1.y + v2.y, v1.z + v2.z);
}

/**
 * Subtract two vectors
 */
::vsub <- function(v1, v2)
{
	return Vector(v1.x - v2.x, v1.y - v2.y, v1.z - v2.z);
}

/**
 * Multiply all vector components by a scalar
 */
::vscale <- function(v, s)
{
	return Vector(v.x * s, v.y * s, v.z * s);
}

/**
 * Cross product of two vectors, wrapping v1.Cross(v2)
 */
::vcross <- function(v1, v2)
{
	return v1.Cross(v2);
}

/**
 * Divide all components of a vector by a scalar
 */
::vdiv <- function(v, d)
{
	return Vector(v.x / d, v.y / d, v.z / d);
}

/**
 * Normalization of a vector, equivalent for v.norm()
 */
::vnorm <- function(v)
{
	return vdiv(v, v.Length())
}

/**
 * Vector equality
 */
::veq <- function(v1, v2)
{
	return v1.x == v2.x &&
		   v1.y == v2.y &&
		   v1.z == v2.z;
}

/**
 * Vector equality with a delta
 */
::veqd <- function(v1, v2, d=0.001){
	return abs(v1.x - v2.x) < d &&
		   abs(v1.y - v2.y) < d &&
		   abs(v1.z - v2.z) < d;
}

/**
 * Check if a vector is the null vector
 */
::vnull <- function(v)
{
	return v.x == 0 && v.y == 0 && v.z == 0;
}

::Lerp <- function(v1,  v2, percent)
{
	return v1 +  (v2 - v1)  * percent;
}

::LerpTime <- function (v1, v2, time, timepast)
{
	local percent = 0.00 + timepast / time;
	if (percent >= 1.00)
	{
		return v2;
	}
	return Lerp(v1, v2, percent);
}

::Slerp <- function(v1,  v2, percent)
{
	local dot = v1.Dot(v2);

	if (dot < -1.0)
	{
		dot = -1.0;
	}
	else if (dot > 1.0)
	{
		dot = 1.0;
	}

	local theta = acos(dot) * percent;

	local RelativeVec = v2 - v1 * dot;
	RelativeVec.Norm();

	return ((v1 * acos(theta)) + (RelativeVec * sin(theta)));
}


::GetDistance3D <- function(v1, v2){return sqrt((v1.x-v2.x)*(v1.x-v2.x)+(v1.y-v2.y)*(v1.y-v2.y)+(v1.z-v2.z)*(v1.z-v2.z));}
::GetDistance2D <- function(v1, v2){return sqrt((v1.x-v2.x)*(v1.x-v2.x)+(v1.y-v2.y)*(v1.y-v2.y));}
::GetDistanceZ <- function(v1, v2){return sqrt((v1.z-v2.z)*(v1.z-v2.z));}