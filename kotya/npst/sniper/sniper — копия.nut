const TICKRATE = 0.1;
g_bTicking <- false;
g_iT

function Start() 
{
    g_bTicking = true;
    Tick();
}

function Tick()
{
    if(!g_bTicking)
        return;
    
    TickTarget();
    TickDir();
    TickShoot();

    //Debug();
    
    EntFireByHandle(self, "RunScriptCode", "Tick()", TICKRATE, null, null);
}

function Debug()
{
    if(target != null)
        ScriptPrintMessageCenterAll("Left : " + target.GetLeftVector() + "\n Ward" + target.GetForwardVector() + "\n Up" + target.GetUpVector())
}

//TARGET
{
    g_oTarget_last <- Vector(0,0,0);
    target <- null;
    g_iDistance_Retarget <- 4086;

    function TickTarget()
    {
        if(target != null)
        {
            if(!TraceLineD(g_hEye_Start.GetOrigin(), target.GetOrigin() + Vector(0, 0, 64)))
            {
                g_bScope_OnTarget = null;
                target = null;
            }
        }
        if(target == null || !target.IsValid() || target.GetHealth() <= 0 || target.GetTeam() != 3)
            return SearchTarget();
    }

    function SearchTarget()
    {
        target = null;

        local Handle = null;

        while( null != ( Handle = Entities.FindInSphere( Handle, self.GetOrigin(), g_iDistance_Retarget)))
        {
            if(Handle.GetClassname() == "player" && Handle.GetTeam() == 3 && Handle.GetHealth() > 0)
            {
                if(TraceLineD( self.GetOrigin() + Vector(0, 0, 64), Handle.EyePosition()))
                {
                    g_oTarget_last = Handle.EyePosition();
                    return target = Handle
                }
                    
            }
        }
        g_oTarget_last = Vector(0,0,0);
        return target;
    }

    function TraceLineD(start, end)
    {
        if(TraceLine(start, end, self) < 1.00)
        {
            //DebugDrawLine(start, end, 255, 0, 0, true, TICKRATE + 0.01)
            return false;
        }
        //DebugDrawLine(start, end, 0, 255, 0, true, TICKRATE + 0.01)
        return true;
        
    }
}
//DIR
{
    g_hEye_End <- null
    g_hEye_Start <- null

    g_fScope_Speedx <- 0.04;
    g_fScope_Speedy <- 0.04;
    g_fScope_Speedz <- 0.01;
    // g_fScope_Speedx <- 0.2;
    // g_fScope_Speedy <- 0.2;
    // g_fScope_Speedz <- 0.2;
    /*LAST
    local totarget = targetpos - shootpos;
    local a = targetspeed.Dot( targetspeed ) - (125 * 125);
    local b = 2 * targetspeed.Dot( totarget );
    local c = totarget.Dot( totarget );
    local p = -b / (2 * a);
    local q = (0.00 + sqrt( ( b * b ) -4 * a * c ) / ( 2 * a) );
    local t1 = p - q;
    local t2 = p + q;
    local t;
    if( t1 > t2 &&
        t2 > 0)
        t = t2;
    else 
        t = t1;
    local aimSpot = targetpos + targetspeed * t;
    */
    function TickDir()
    {
        if(target != null)
        {
            //local targetdist = (GetDistance(target.GetOrigin(), g_oTarget_last) * TICKRATE * 10.0);
            //local targetdist = 20;
            //ScriptPrintMessageChatAll("" + targetdist);
            local newDir = g_hEye_Start.GetOrigin() - (GetPost()/* + (target.GetLeftVector() * targetdist) + (target.GetLeftVector() * targetdist)*/);
            newDir.Norm();
            local tecDir = g_hEye_Start.GetForwardVector();
            local setDir = Vector((MoveDir(tecDir.x, newDir.x, g_fScope_Speedx)), (MoveDir(tecDir.y, newDir.y, g_fScope_Speedy)), (MoveDir(tecDir.z, newDir.z, g_fScope_Speedz))); 

            if(VectorEqul(newDir, setDir))
                g_bScope_OnTarget = true;
            else 
                g_bScope_OnTarget = false;
            g_hEye_Start.SetForwardVector(setDir);
        }
        
        g_hEye_End.SetOrigin(TraceDir(g_hEye_Start.GetOrigin(), g_hEye_Start.GetForwardVector() * -1, 4086, self))
    }

    function MoveDir(c1, c2, mod)
    {
        if(c1 < c2)
        {
            if(c1 + mod >= c2)
                return c2;
            else
                return c1 + mod;
        }
        else
        {
            if(c1 - mod <= c2)
                return c2;
            else
                return c1 - mod;
        }
    }

    function TraceDir(orig, dir, maxd, filter)
    {
        local frac = TraceLine(orig,orig+dir*maxd,filter);
        if(frac == 1.0)
        {
            return orig + dir * maxd;
        }
        return orig + (dir * (maxd * frac));
    }
    function GetDistance(v1,v2)return 0.00 + sqrt((v1.x-v2.x)*(v1.x-v2.x)+(v1.y-v2.y)*(v1.y-v2.y)+(v1.z-v2.z)*(v1.z-v2.z));
}
//SHOOT
{
    g_bScope_OnTarget <- false;
    g_bCan_Shoot <- true;
    g_fDelay_Shoot <- 1.0;

    function TickShoot()
    {
        if(g_bScope_OnTarget && g_bCan_Shoot)
        {
            local start = g_hEye_Start.GetOrigin();
            local end = GetPost();

            local dir = (start - end);
            dir.Norm();
            
            local sniper_bullet = CreateProp(start, type_parent_prop);
            sniper_bullet.SetForwardVector(dir);
            
            EntFireByHandle(sniper_bullet, "RunScriptFile", "kotya/npst/sniper/sniperbullet.nut", 0.00, null, null);

            g_bCan_Shoot = false;
            EntFireByHandle(self, "RunScriptCode", "g_bCan_Shoot = true;", g_fDelay_Shoot, null, null);
        }
        if(target != null)
            g_oTarget_last = target.EyePosition();
    }

    function GetPost()
    {
        local target_origin = target.EyePosition();
        local self_origin = g_hEye_Start.GetOrigin();
        local k = (GetDistance3D(target_origin, self_origin) / 140.00) / TICKRATE;
        //k = 1
        local x = (target_origin.x - g_oTarget_last.x) * k + target_origin.x;
        local y = (target_origin.y - g_oTarget_last.y) * k + target_origin.y;
        local z = (target_origin.z - g_oTarget_last.z) * k + target_origin.z;

        local text = "" + target_origin + "\n"
        text += "" + k + "\n"
        text += "" + target_origin.x + " - " +g_oTarget_last.x + "*" + k + "+" + target_origin.y + "\n"
        text += "" + Vector(x, y, z) + "\n"

        return Vector(x, y, z);
    }
}