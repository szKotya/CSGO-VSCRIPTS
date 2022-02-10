StartTime <- null;
StartPos <- null;

ticking <- false;
tickrate <- 0.05

SetSpeed <- 5000;
function Start()
{
    StartTime = Time();
    StartPos = self.GetOrigin();

    ticking = true;
    //Tick();
}

function Tick()
{
    // if(!ticking)
    //     return;

    EntFireByHandle(self, "SetSpeed", "" + SetSpeed, 0, null, null)
    //EntFireByHandle(self, "RunScriptCode", "Tick();", tickrate, null, null)
}

function End()
{
    ticking = false;

    local EndTime = Time();
    local EndPos = self.GetOrigin();
    local Distance = GetDistance(StartPos, EndPos);
    local FlyTime = EndTime - StartTime;
    local Speed = Distance / FlyTime;
    printl("--------");
    printl("Class : " + self.GetClassname());
    printl("Star Time : " + StartTime);
    printl("End Time : "  + EndTime);
    printl("Star Pos : " + StartPos);
    printl("End Pos : "  + EndPos);
    printl("Time : " + FlyTime);
    printl("Distance : " + Distance);
    printl("Real Speed : "  + Speed);
    printl("SetSpeed : "  + SetSpeed);
    printl("--------");
}

function Touch()
{

    local EndTime = Time();
    local EndPos = self.GetOrigin();
    local Distance = GetDistance(StartPos, EndPos);
    local FlyTime = EndTime - StartTime;
    local Speed = Distance / FlyTime;
    printl("--------");
    printl("Class : " + self.GetClassname());
    printl("Star Time : " + StartTime);
    printl("End Time : "  + EndTime);
    printl("Time : " + FlyTime);
    printl("Distance : " + Distance);
    printl("Real Speed : " + Speed);
    printl("Activator : " + activator);
    printl("SetSpeed : "  + SetSpeed);
    printl("--------");
}

function GetDistance(v1,v2)
{
    return sqrt( (v1.x - v2.x) * (v1.x - v2.x) + (v1.y - v2.y) * (v1.y - v2.y) + (v1.z - v2.z) * (v1.z - v2.z) )
}