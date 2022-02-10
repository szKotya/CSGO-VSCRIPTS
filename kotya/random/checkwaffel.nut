tickrate <- 0.1;

function OnPostSpawn()
{
    Tick()
}

function Tick()
{
    DrawBox(self.GetOrigin(),8,Vector(255, 255, 255),0.11);
    DebugDrawLine(self.GetOrigin(),self.GetOrigin() + self.GetForwardVector() * 25, 255, 255, 255, true, 0.11);
    EntFireByHandle(self,"RunScriptCode"," Tick(); ",tickrate,null,null);
}
function DrawBox(origin,size,color,time)
{
    DebugDrawBox(origin, Vector(size,size,size), Vector(size,size,size)*-1, color.x, color.y, color.z, 50, time);
}