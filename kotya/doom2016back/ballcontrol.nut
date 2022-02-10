
IncludeScript("kotya/doom2016/support/math.nut");

function TickFireBall()
{
	if(caller==null||!caller.IsValid())return;
	local mepos = caller.GetOrigin();
	if(TraceLine(mepos,mepos-(caller.GetForwardVector()*20),caller)<1.00)
	{
		EntFireByHandle(caller,"FireUser1","",0,null,null);
        //printl("dead")
		return;
	}
	EntFireByHandle(self,"RunScriptCode"," TickFireBall(); ",0.05,null,caller);
}

function TickBFG()
{
	if(caller==null||!caller.IsValid())return;
	local dist = 20;
	local mepos = caller.GetOrigin();
    if(GetAllTraceVector(caller,dist))
	{
		//testpaintred(mepos,mepos-(caller.GetForwardVector()*dist))
		EntFireByHandle(caller,"FireUser1","",0,null,null);
        //printl("dead")
		return;
	}
	EntFireByHandle(self,"RunScriptCode","TickBFG();",0.05,null,caller);
}

function TickFireWave()
{
	if(caller==null||!caller.IsValid())return;
	local mepos = caller.GetOrigin();
    //(mepos+(caller.GetForwardVector()*64),GVO((mepos+(caller.GetForwardVector()*64)),0,0,-64))
	if(TraceLine(mepos,mepos+(caller.GetForwardVector()*64),caller)<1.00 ||
    TraceLine(mepos+(caller.GetForwardVector()*64),GVO((mepos+(caller.GetForwardVector()*64)),0,0,-100),caller)==1)
	{
		EntFireByHandle(caller,"FireUser1","",0,null,null);
        //printl("dead")
		return;
	}
	EntFireByHandle(self,"RunScriptCode","TickFireWave(); ",0.05,null,caller);
}

function TickFire()
{
	if(caller==null||!caller.IsValid())return;
	local mepos = caller.GetOrigin();
    testpaintblue(mepos,(GVO(mepos,0,0,-32)))
	if(TraceLine(mepos,GVO(mepos,0,0,-32),caller)<1.00)
	{
		EntFireByHandle(caller,"FireUser2","",0,null,null);
        //printl("dead")
		return;
	}
	EntFireByHandle(self,"RunScriptCode","TickFire();",0.05,null,caller);
}

function TickFireLake()
{
	if(caller==null||!caller.IsValid())return;
	local mepos = caller.GetOrigin();
    testpaintblue(mepos,GVO(mepos,0,0,-64));
	if(TraceLine(mepos,GVO(mepos,0,0,-64),caller)==1.00)
	{
		EntFireByHandle(caller,"FireUser2","",0,null,null);
        printl("dead")
		return;
	}
	EntFireByHandle(caller,"FireUser3","",0,null,null);
}
function GetAllTraceVector(v,dist)
{
    // if(TraceLine(v.GetOrigin(),v.GetOrigin()-(v.GetForwardVector()*dist),caller)<1.00
    // ||TraceLine(v.GetOrigin(),v.GetOrigin()-(v.GetUpVector()*dist*(-1)),caller)<1.00
    // ||TraceLine(v.GetOrigin(),v.GetOrigin()-(v.GetUpVector()*dist),caller)<1.00
    // ||TraceLine(v.GetOrigin(),v.GetOrigin()-(v.GetLeftVector()*dist*(-1)),caller)<1.00
    // ||TraceLine(v.GetOrigin(),v.GetOrigin()-(v.GetLeftVector()*dist),caller)<1.00) return true
    // else return false;

    if(TraceLine(v.GetOrigin(),v.GetOrigin()-(v.GetForwardVector()*dist),caller)<1.00)
    {
        printl("GetForwardVector()*dist")
        testpaintred(v.GetOrigin(),v.GetOrigin()-(v.GetForwardVector()*dist));
        return true;
    }
    if(TraceLine(v.GetOrigin(),v.GetOrigin()-(v.GetUpVector()*dist*(-1)),caller)<1.00)
    {
        printl("GetUpVector()*dist*(-1)")
        testpaintred(v.GetOrigin(),v.GetOrigin()-(v.GetUpVector()*dist*(-1)));
        return true;
    }
    if(TraceLine(v.GetOrigin(),v.GetOrigin()-(v.GetUpVector()*dist),caller)<1.00)
    {
        printl("GetUpVector()*dist")
        testpaintred(v.GetOrigin(),v.GetOrigin()-(v.GetUpVector()*dist));
        return true;
    }
    if(TraceLine(v.GetOrigin(),v.GetOrigin()-(v.GetLeftVector()*dist*(-1)),caller)<1.00)
    {
        printl("GetLeftVector()*dist*(-1)")
        testpaintred(v.GetOrigin(),v.GetOrigin()-(v.GetLeftVector()*dist*(-1)));
        return true;
    }
    if(TraceLine(v.GetOrigin(),v.GetOrigin()-(v.GetLeftVector()*dist),caller)<1.00)
    {
        printl("GetLeftVector()*dist")
        testpaintred(v.GetOrigin(),v.GetOrigin()-(v.GetLeftVector()*dist));
        return true;
    }
    return false;

}

function testpaintblue(start,end) {DebugDrawLine(start,end, 0, 0, 255, true, 1)}
function testpaintred(start,end) {DebugDrawLine(start,end, 255, 0, 0, true, 4)}