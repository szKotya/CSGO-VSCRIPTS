g_iGrid <- 16;

g_aiSize <- [
    Vector(-944, -944, 532),
    Vector(944, 944, 532),
]

class class_path
{
    origin = Vector(0, 0, 0);
    path = null;

    function GetOrigin()
    {
        return this.origin;
    }

    function DrawPath()
    {
        foreach(elem in this.path)
        {
            DrawLine(this.GetOrigin(), elem.GetOrigin());
        }
    }

    function AddPath(point)
    {
        this.path.push(point);
    }

    function RemovePath(point)
    {
        foreach (index, elem in this.path)
        {
            if (elem == point)
            {
                DrawLine(elem.GetOrigin(), this.GetOrigin(), 20, 1);
                this.path.remove(index);
                return;
            }
        }   
    }

    function HavePoint(point)
    {
        foreach (elem in this.path)
        {
            if (elem == point)
            {
                return true;
            }
        }

        return false;
    }
}

g_acpPaths <- [];

function Init()
{
    local obj;
    local h;
    while ((h = Entities.FindByName(h, "testpath_*")) != null)
    {
        obj = class_path();
        obj.origin = h.GetOrigin();
        obj.path = [];

        g_acpPaths.push(obj);
    }

    foreach (i in g_acpPaths)
    {
        foreach (a in g_acpPaths)
        {
            if (InSight(i.GetOrigin(), a.GetOrigin()))
            {
                i.AddPath(a);
            }
        }
    }
    local temp0;
    local temp1;
    local temp2;
    local count = 0;

    for (local i = 0; i < g_acpPaths.len(); i++)
    {
        for (local a = 0; a < g_acpPaths.len(); a++)
        {
            if (i == a)
            {
                continue;
            }

            for (local j = 0; j < g_acpPaths.len(); j++)
            {
                printl(++count);
                if (a == j)
                {          
                    continue;  
                }
                else if (i == j)
                {          
                    continue;  
                }

                if (g_acpPaths[i].HavePoint(g_acpPaths[a]) &&
                    g_acpPaths[a].HavePoint(g_acpPaths[j]) && 
                    g_acpPaths[j].HavePoint(g_acpPaths[i]))
                {
                    local temp0 = GetDistance3D(g_acpPaths[i].GetOrigin(), g_acpPaths[a].GetOrigin());
                    local temp1 = GetDistance3D(g_acpPaths[a].GetOrigin(), g_acpPaths[j].GetOrigin());
                    local temp2 = GetDistance3D(g_acpPaths[j].GetOrigin(), g_acpPaths[i].GetOrigin());

                    if (temp0 > temp1 && temp0 > temp2)
                    {
                        g_acpPaths[i].RemovePath(g_acpPaths[a]);
                        g_acpPaths[a].RemovePath(g_acpPaths[i]);
                    }
                    else if (temp1 > temp0 && temp1 > temp2)
                    {
                        g_acpPaths[a].RemovePath(g_acpPaths[j]);
                        g_acpPaths[j].RemovePath(g_acpPaths[a]);
                    }
                    else if (temp2 > temp0 && temp2 > temp1)
                    {
                        g_acpPaths[i].RemovePath(g_acpPaths[j]);
                        g_acpPaths[j].RemovePath(g_acpPaths[i]);
                    }
                }
            }
        }
    }

    DrawAllPath();
}

function GetPath(vecStart, vecEnd)
{
    local StartPoint = GetNeartsPath(vecStart);
    local EndPoint = GetNeartsPath(vecEnd);
    DrawAxis(StartPoint.GetOrigin());
    DrawAxis(EndPoint.GetOrigin());

    local obj;
    local temp; 

    local bFind = false;
    local aPath = [];
    obj = StartPoint;
    while (!bFind)
    {
        aPath.push(obj);
        foreach(elem in obj.path)
        {
            if (elem.HavePoint(EndPoint))
            {
                aPath.push(elem);
                aPath.push(EndPoint);
                bFind = true;
                break;
            }
        }

        obj = obj.path[0];
    }

    for (local i = 1; i < aPath.len(); i++)
    {
        DrawLine(aPath[i - 1].GetOrigin(), aPath[i].GetOrigin());
    }
}

function DrawAllPath()
{
    foreach (elem in g_acpPaths)
    {
        elem.DrawPath();
    }
}

function GetNeartsPath(vecOrigin)
{
    local iMin_Index = 0;
    local fMin_Range = GetDistance3D(vecOrigin, g_acpPaths[iMin_Index].GetOrigin());
    local temp;
    foreach (index, elem in g_acpPaths)
    {
        temp = GetDistance3D(vecOrigin, elem.GetOrigin());
        if (temp < fMin_Range)
        {
            iMin_Index = index;
            fMin_Range = temp;
        }
    }
    return g_acpPaths[iMin_Index];
}



g_bTicking <- false;
const TICK_RATE = 0.5;
function StartTick()
{
    if (g_bTicking)
    {
        return;
    }
    g_bTicking = true;
    Tick();
}
function EndTick()
{
    if (!g_bTicking)
    {
        return;
    }
    g_bTicking = false;
}

function Tick()
{
    foreach(elem in g_acpPaths)
    {
        DrawAxis(elem.GetOrigin(), 16, TICK_RATE + 0.01);
    }
    if (g_bTicking)
    {
        EF(self, "RunScriptCode", "Tick()", TICK_RATE);
    }
}

::InSight <- function(vecStart, vecEnd, hIgnore = null)
{
    if (hIgnore == null || typeof hIgnore == "instance")
    {
        if (TraceLine(vecStart, vecEnd, hIgnore) < 1.00)
        {
            return false;
        }
        return true;
    }

    if (typeof hIgnore == "array")
    {
        for(local i = 0; i < hIgnore.len(); i++)
        {
            if (hIgnore[i] == null || !hIgnore[i].IsValid())
            {
                continue;
            }

            if (InSight(vecStart, vecEnd, hIgnore[i]))
            {
                return true;
            }
        }
    }

    return InSight(vecStart, vecEnd, null);
}

::GetDistance3D <- function(v1,v2)
{
    return 0.00 + sqrt((v1.x-v2.x)*(v1.x-v2.x)+(v1.y-v2.y)*(v1.y-v2.y)+(v1.z-v2.z)*(v1.z-v2.z));
}

::DrawAxis <- function(pos, s = 16, time = 10, aVecColor = 0)
{
    if (aVecColor == 0)
    {
        aVecColor = [Vector(255, 0, 0), Vector(0, 255, 0), Vector(0, 0, 255)];
    }
    else
    {
        aVecColor = [Vector(255, 0, 0), Vector(255, 0, 0), Vector(0, 0, 0)];
    }
	DebugDrawLine(Vector(pos.x-s,pos.y,pos.z), Vector(pos.x+s,pos.y,pos.z), aVecColor[0].x, aVecColor[0].y, aVecColor[0].z, true, time);
	DebugDrawLine(Vector(pos.x,pos.y-s,pos.z), Vector(pos.x,pos.y+s,pos.z), aVecColor[1].x, aVecColor[1].y, aVecColor[1].z, true, time);
	DebugDrawLine(Vector(pos.x,pos.y,pos.z-s), Vector(pos.x,pos.y,pos.z+s), aVecColor[2].x, aVecColor[2].y, aVecColor[2].z, true, time);
}

::DrawLine <- function(vecStart, VecEnd, time = 10, aVecColor = 0)
{
    if (aVecColor == 0)
    {
        aVecColor = Vector(255, 255, 255);
    }
    else
    {
        aVecColor = Vector(255, 0, 0);
    }

    DebugDrawLine(vecStart, VecEnd, aVecColor.x, aVecColor.y, aVecColor.z, true, time);
}

::AOP <- function(item, key, value = "", d = 0.00)
{
	if (typeof item == "string")
	{
		EntFire(item, "addoutput", key + " " + value, d);
	}
	else if (typeof item == "instance")
	{
		if (typeof value == "string")
		{
			item.__KeyValueFromString(key, value);
		}
		else if (typeof value == "integer")
		{
			item.__KeyValueFromInt(key, value);
		}
		else
		{
			EntFireByHandle(item, "AddOutPut", key + " " + value, d, item, item);
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

Init();