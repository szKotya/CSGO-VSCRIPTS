::TargetValid <- function(target)
{
	if (target != null &&
	target.IsValid())
	{
		return true;
	}
	return false;
}

::EF <- function(item, key, value = "", d = 0)
{
	if (typeof item == "string")
	{
		// local i = Entities.FindByName(null, item);
		// if (i == null || !i.IsValid())
		// {
		// 	printl("BUG: " + item);
		// }

		EntFire(item, key, value, d);
		// printl("EntFire: " + item + " : " + key + " : " + value + " : " + d);
	}
	else if (typeof item == "instance")
	{
		EntFireByHandle(item, key, value, d, item, item);
		// printl("EntFireByHandle: " + item + " : " + key + " : " + value + " : " + d);
	}
}

::AOP <- function(item, key, value = "", d = 0.00)
{
	if (typeof item == "string")
	{
		// printl("AddOutPut " + item + " : " + key + " : " + value);
		EntFire(item, "AddOutPut", key + " " + value, d);
	}
	else if (typeof item == "instance")
	{
		if (typeof value == "string")
		{
			// printl("string " + item + " : " + key + " : " + value);
			item.__KeyValueFromString(key, value);
		}
		else if (typeof value == "integer")
		{
			// printl("integer " + item + " : " + key + " : " + value);
			item.__KeyValueFromInt(key, value);
		}
		else if (typeof value == "float")
		{
			// printl("float " + item + " : " + key + " : " + value);
			item.__KeyValueFromFloat(key, value);
		}
		else if (typeof value == "Vector")
		{
			// printl("Vector " + item + " : " + key + " : " + value);
			item.__KeyValueFromVector(key, value);
		}
	}
}

::CallFunction <- function(func_name, fdelay = 0.0, activator = null, caller = null)
{
	EntFireByHandle(self, "RunScriptCode", "" + func_name, fdelay, activator, caller);
}

::GetFloor <- function(vecOrigin, ignore = null)
{
	local vecStart = vecOrigin;
	local iDist = 64;
	vecOrigin = Vector(vecOrigin.x, vecOrigin.y, vecOrigin.z + iDist);
	local fact = TraceLine(vecOrigin, vecOrigin - Vector(0, 0, 2 * iDist), ignore);
	if (fact == 1.00)
	{
		return vecStart;
	}
	vecOrigin = vecOrigin + Vector(0, 0, -1) * fact * 2 * iDist;
	return vecOrigin;
}

//GetIndexOnArrayByValue(value, array, {function Compare(value, k){return value.h == k}});
::GetIndexOnArrayByValue <- function(find, array, search)
{
	foreach (index, value in array)
	{
		if (search.Compare(value, find))
		{
			return index;
		}
	}
	return -1;
}

::GetValueOnArrayByValue <- function(find, array, search)
{
	foreach (index, value in array)
	{
		if (search.Compare(value, find))
		{
			return value;
		}
	}
	return null;
}


::GetChande <- function(iChance)
{
	return (RandomInt(1, 100) <= iChance);
}

::class_pos <- class
{
	origin = Vector();

	ox = 0;
	oy = 0;
	oz = 0;

	angles = Vector();

	ax = 0;
	ay = 0;
	az = 0;

	constructor(_origin = Vector(), _angles = Vector())
	{
		this.origin = _origin;
		this.ox = this.origin.x;
		this.oy = this.origin.y;
		this.oz = this.origin.z;

		this.angles = _angles;
		this.ax = this.angles.x;
		this.ay = this.angles.y;
		this.az = this.angles.z;
	}

	function GetOrigin()
	{
		return this.origin;
	}
	function GetAngles()
	{
		return this.angles;
	}
}

::IsVectorInBoundingBox <- function(v1, vecCenter, vecBound)
{
	local v2 = vecCenter + vecBound;
	local v3 = vecCenter - vecBound;
	// DebugDrawBox(vecCenter, Vector(-vecBound.x, -vecBound.y, -vecBound.z), vecBound, 255, 255, 255, 255, 100);
	if (v1.x > v2.x ||
	v1.y > v2.y ||
	v1.z > v2.z ||
	v1.x < v3.x ||
	v1.y < v3.y ||
	v1.z < v3.z)
	{
		return false;
	}
	return true;
}

::IsVectorInBoundingBoxVectors <- function(v1, v2, v3)
{
	local vecCenter = Vector((v2.x + v3.x) * 0.5, (v2.y + v3.y) * 0.5, (v2.z+ v3.z) * 0.5);
	local vecBound = vecCenter - v2;
	if (vecBound.x < 0 &&
	vecBound.y < 0 &&
	vecBound.z < 0)
	{
		vecBound = Vector(-vecBound.x, -vecBound.y, -vecBound.z);
	}
	return IsVectorInBoundingBox(v1, vecCenter, vecBound);
}


::IsVectorInSphere <- function(v1, radius, v2)
{
	if (pow(v2.x - v1.x, 2.00) + pow(v2.y - v1.y, 2.00) + pow(v2.z - v1.z, 2.00) < pow(radius, 2))
	{
		return true;
	}
	return false;
}


::InSight <- function(start, end, ignorehandle = null)
{
	if (ignorehandle == null ||
	typeof ignorehandle == "instance")
	{
		return !(TraceLine(start, end, ignorehandle) < 1.00);
	}

	if (typeof ignorehandle == "array")
	{
		foreach (collision in ignorehandle)
		{
			if (collision == null ||
			!collision.IsValid())
			{
				continue;
			}

			if (TraceLine(start, end, collision) >= 1.00)
			{
				return true;
			}
		}
	}

	return false;
}