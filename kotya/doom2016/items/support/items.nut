function HaveVelocity(v)
{
    if(v.GetVelocity().x == 0 &&
    v.GetVelocity().y == 0 &&
    v.GetVelocity().z == 0)
    {
        return false;
    }
    else
    {
        return true;
    }

}

function SetPosM()
{
    if(!Ticking)
    {
        local CurentPos = Center_M.GetOrigin();
        Center_M.SetAngles(Center_T.GetAngles().x,Center_T.GetAngles().y,Center_T.GetAngles().z);
        Center_M.SetOrigin(Center_T.GetOrigin());
        if(CompareCoordinates(CurentPos.x,CurentPos.y,CurentPos.z)){return;}
        EntFireByHandle(self, "RunScriptCode", "SetPosM();", 0.01, null, null);
    }
}

function CompareCoordinates(x1,y1,z1)
{
    local CurentPos = Center_M.GetOrigin();
	if(x1 == CurentPos.x && y1 == CurentPos.y && z1 == CurentPos.z)
	{
		return true;
	}
    else
    {
        return false;
    }
}

function CheakItem()
{
    if(self != null && Center_T != null && Owner != null && self.IsValid() && Center_T.IsValid())
    {
        return true;
    }
    else
    {
        return false;
    }
}

function TraceDir(orig, dir, maxd, filter)
{
	local frac = TraceLine(orig,orig+dir*maxd,filter);
	if(frac == 1.0)
    {
        local S_Hit = orig + dir * maxd;
        local S_Dist = 0.00;
        return Hit = S_Hit, Dist = S_Dist;
    }
    local S_Hit = orig + (dir * (maxd * frac));
    local S_Dist = maxd * frac;
	return Hit = S_Hit, Dist = S_Dist;
}

function FreezeOwner(time,time1)
{
    EntFireByHandle(Freeze, "ModifySpeed", "0", time, Owner, Owner);
    EntFireByHandle(Freeze, "ModifySpeed", "1", time1, Owner, Owner);
}

function SetNewParent(array)
{
    if(array == 0)return;
    for(local i = 0; i <= array.len()-1;i++)
    {
        array[i].SetOrigin(array[i].GetOrigin() - (Vector(
        array[i].GetOrigin().x*2 - Parent.GetOrigin().x*2,
        array[i].GetOrigin().y*2 - Parent.GetOrigin().y*2,
        array[i].GetOrigin().z - Parent.GetOrigin().z)));
        EntFireByHandle(array[i], "SetParent", "!activator", 0.01, Parent, Parent);
    }
}

function PushSkin()
{
    if (activator == null || Owner == null) return;
    local a = Owner.GetCenter();
    local b = activator.GetCenter();
    local dir = Vector(a.x - b.x, a.y - b.y, a.z - b.z);
    dir.Norm();
    local vel = Vector(PUSH_SCALE * dir.x, PUSH_SCALE * dir.y, PUSH_SCALE * dir.z);
    Owner.__KeyValueFromVector("basevelocity", vel);
}
