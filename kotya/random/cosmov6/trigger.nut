dist <- 1024;
power <- 1024;


function Touch()
{
    local spos = self.GetOrigin();
    local apos = activator.GetOrigin();
    //DrawAxis(spos)
    EntFireByHandle(self, "FireUser1", "", 0, null, null);
    if(GetDistance2D(spos,apos) <= dist)
    {
        Gravity()
        //DrawAxis(apos)
    }

}

function Push()
{
    local spos = self.GetOrigin();
    local apos = activator.GetOrigin();
    local vec = (spos - apos);
    local av = activator.GetVelocity();
    vec.Norm();
    activator.SetVelocity(Vector(vec.x * power, vec.y * power, av.z));
}

function Gravity()
{
    local spos = self.GetOrigin();
    local apos = activator.GetOrigin();
    local vec = (spos - apos) * -1;
    local av = activator.GetVelocity();
    vec.Norm();
    activator.SetVelocity(Vector(vec.x * power, vec.y * power, av.z));
}

function GetDistance2D(v1,v2)return sqrt((v1.x-v2.x)*(v1.x-v2.x)+(v1.y-v2.y)*(v1.y-v2.y));

function DrawAxis(pos,s = 16,nocull = true,time = 10)
{
	DebugDrawLine(Vector(pos.x-s,pos.y,pos.z), Vector(pos.x+s,pos.y,pos.z), 255, 0, 0, nocull, time);
	DebugDrawLine(Vector(pos.x,pos.y-s,pos.z), Vector(pos.x,pos.y+s,pos.z), 0, 255, 0, nocull, time);
	DebugDrawLine(Vector(pos.x,pos.y,pos.z-s), Vector(pos.x,pos.y,pos.z+s), 0, 0, 255, nocull, time);
}
