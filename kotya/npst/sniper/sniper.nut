const TICKRATE = 0.1;
g_bTicking <- false;
g_bNotFockus <- true;
g_fLastShoot <- 0.00;
g_iRadius_Nade <- 320;

g_fFockus_Time <- 1.00;

g_iBase_HP <- 40;
g_iHuman_HP <- 5;
g_iAddHP_Radius <- 99999;


g_iHP <- 0;
g_oNade <- Vector(0, 0, 0);

function Init()
{
    local origin_new = self.GetOrigin(); //+ Vector(0,0,100);
    local checks = 0;

    while(checks < 1000)
    {
        if(!InSight(origin_new, origin_new - Vector(0,0,1), self))
        {
            origin_new = origin_new + Vector(0,0,10);
            self.SetOrigin(origin_new);
            return EntFireByHandle(self, "RunScriptCode", "Start()", 0.05, null, null);
        }

        origin_new = origin_new - Vector(0,0,1);
        checks++;
    }

    self.Destroy();
}

function Start() 
{
    {
        g_oNade = self.GetOrigin() - self.GetForwardVector() * 50;

        g_hEye_Start = self;
        local origin = g_hEye_Start.GetOrigin() + (g_hEye_Start.GetForwardVector() * 50) + (g_hEye_Start.GetUpVector() * 5);
        // g_hEye_Start = CreateProp(origin, type_sniper_prop);
        // g_hEye_Start.__KeyValueFromString("targetname", "Sniper_Model" + Time());
        
        g_hEye_End = CreateProp(Vector(0, 0, 0), type_parent_prop);
        g_hEye_End.__KeyValueFromString("targetname", "Sniper_Beam2" + Time());

        g_hEye_Sprite = CreateSprite(origin, type_sniper_sprite);
        g_hEye_Sprite.__KeyValueFromString("targetname", "Sniper_Beam1" + Time());
        EntFireByHandle(g_hEye_Sprite, "SetParent", "!activator", 0.00, g_hEye_Start, g_hEye_Start);

        local array = [];
        array.push(g_hEye_Sprite.GetName());
        array.push(g_hEye_End.GetName());
        g_hBeam = CreateBeam(origin, type_sniper_beam, array);

        g_hHbox = CreateProp(g_oNade, type_sniperhbox_prop);
        g_hHbox.SetForwardVector(self.GetForwardVector());
        EntFireByHandle(g_hHbox, "AddOutPut", "OnHealthChanged " + self.GetName() + ":RunScriptCode:Damage():0:-1", 0.01, null, null);
    }

    SetHP()

    g_bTicking = true;
    Tick();
}

function SetHP()
{
    g_iHP = g_iBase_HP// + CountPlayers(self.GetOrigin(), g_iAddHP_Radius) * g_iHuman_HP;
}

function Tick()
{
    if(!g_bTicking)
        return;
    
    if(CheckNade())
        return Death();
    if(g_fLastShoot + g_fFockus_Time < Time())
    {
        if(!g_bNotFockus)
        {
            g_bScope_OnTarget = false;
            g_hTarget = null;
            g_bNotFockus = true;
        }

        TickTarget();
        TickDir();
        TickShoot();
    }
    

    //Debug();
    
    EntFireByHandle(self, "RunScriptCode", "Tick()", TICKRATE, null, null);
}

function CheckNade()
{
    local h = null;

    //DrawAxis(g_oNade, 16, 0.1);

    while(null != (h = Entities.FindInSphere(h, g_oNade, g_iRadius_Nade)))
    {
        if(h.GetClassname() == "hegrenade_projectile" && 
            h.IsValid())
            {
                if(InSight(g_oNade, h.GetOrigin()))
                    return true;
            }
            
    }
    return false;
}

function Damage(i = 1)
{
    if(!g_bTicking)
        return;
    
    {
        g_bNotFockus = false;
        g_fLastShoot = Time();
    }
    
    g_iHP -= i;

    if(g_iHP <= 0)
    {
        Death();
    }
}

function Death()
{
    if(!g_bTicking)
        return;
    
    g_bTicking = true;
    
    EntFireByHandle(CreateSound(g_oNade, type_sniperdeath_sound, RandomInt(0, SniperDeathArray_Sound.len() - 1)), "Kill", "", 1.0, null, null);

    local part = CreateParticle(g_oNade, Sniper_Explosion, false);
    EntFireByHandle(part, "Start", "", 0.75, null, null);
    EntFireByHandle(part, "Kill", "", 1.0, null, null);

    if(g_hHbox != null && g_hHbox.IsValid())
        g_hHbox.Destroy();

    if(g_hEye_End != null && g_hEye_End.IsValid())
        EntFireByHandle(g_hEye_End, "Kill", "", 0.8, null, null);

    if(g_hEye_Sprite != null && g_hEye_Sprite.IsValid())
        EntFireByHandle(g_hEye_Sprite, "Kill", "", 0.8, null, null);

    if(g_hBeam != null && g_hBeam.IsValid())
        EntFireByHandle(g_hBeam, "Kill", "", 0.8, null, null);

    if(g_hEye_Start != null && g_hEye_Start.IsValid())
        EntFireByHandle(g_hEye_Start, "Kill", "", 0.8, null, null);
}

function Debug()
{
    if(g_hTarget != null)
        ScriptPrintMessageCenterAll("Left : " + g_hTarget.GetLeftVector() + "\n Ward" + g_hTarget.GetForwardVector() + "\n Up" + g_hTarget.GetUpVector())
}

//TARGET
{
    g_hTarget <- null;
    g_iDistance_Retarget <- 12000;

    function TickTarget()
    {
        if(ValidTarget(g_hTarget, 3))
        {
            if(!InSight(g_hEye_Start.GetOrigin() + Vector(0, 0, 16), g_hTarget.EyePosition()))
            {
                g_bScope_OnTarget = false;
                g_hTarget = null;
            }
            else
                return; 
        }

        return SearchTarget();
    }

    function SearchTarget()
    {
        g_hTarget = null;
        g_bScope_OnTarget = false;
        local Handle = null;

        while(null != (Handle = Entities.FindInSphere(Handle, self.GetOrigin(), g_iDistance_Retarget)))
        {
            if(Handle.GetClassname() == "player" && Handle.GetTeam() == 3 && Handle.GetHealth() > 0)
            {
                if(InSight(g_hEye_Start.GetOrigin() + Vector(0, 0, 16), Handle.EyePosition()))
                {
                    return g_hTarget = Handle
                }
                    
            }
        }
        return g_hTarget;
    }
}
//DIR
{
    g_hEye_End <- null;
    g_hEye_Sprite <- null;
    g_hEye_Start <- null;
    g_hBeam <- null;
    g_hHbox <- null;

    g_fScope_Speedx <- 0.05;
    g_fScope_Speedy <- 0.05;
    g_fScope_Speedz <- 0.05;
    
    function TickDir()
    {
        if(ValidTarget(g_hTarget, 3))
        {
            local newDir = g_hEye_Start.GetOrigin() - (GetPredictionOrigin(g_hEye_Start.GetOrigin(), g_hTarget.EyePosition(), g_hTarget.GetVelocity(), 100.0, 0.01, 50)/* + (target.GetLeftVector() * targetdist) + (target.GetLeftVector() * targetdist)*/);
            newDir.Norm();
            local tecDir = g_hEye_Start.GetForwardVector() * -1;
            local setDir = Vector((MoveDir(tecDir.x, newDir.x, g_fScope_Speedx)), (MoveDir(tecDir.y, newDir.y, g_fScope_Speedy)), (MoveDir(tecDir.z, newDir.z, g_fScope_Speedz))); 

            if(VectorEqul(newDir, setDir))
                g_bScope_OnTarget = true;
            else 
                g_bScope_OnTarget = false;
            g_hEye_Start.SetForwardVector(setDir * -1);
        }
        
        g_hEye_End.SetOrigin(TraceDir(g_hEye_Start.GetOrigin(), g_hEye_Start.GetForwardVector(), 12000, self))
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
}
//SHOOT
{
    //g_iClipSize <- 100;
    g_iClipSize <- 5;
    g_iAmmo <- g_iClipSize;
    g_fDelay_Reload <- 5.0;

    g_bScope_OnTarget <- false;
    g_bReload <- false;
    g_bCan_Shoot <- true;
    g_fDelay_Shoot <- 2.5;
    //g_fDelay_Shoot <- 0.05;

    function TickShoot()
    {
        if(!g_bReload && g_bCan_Shoot && g_bNotFockus)
        {
            if(g_iAmmo < 1 || (g_hTarget == null && g_iAmmo < g_iClipSize))
            {
                g_bReload = true;
                local start = g_hEye_Start.GetOrigin();

                EntFireByHandle(g_hBeam, "TurnOff", "", 0.00, null, null);
                EntFireByHandle(g_hBeam, "TurnOn", "", g_fDelay_Reload * 0.7, null, null);

                local sound1 = CreateSound((start), type_sniperreload_sound, 2);
                local sound2 = CreateSound((start), type_sniperreload_sound, 1);
                local sound3 = CreateSound((start), type_sniperreload_sound, 0);
                local sound4 = CreateSound((start), type_sniperreload_sound, 3);
                local sound5 = CreateSound((start), type_sniperreload_sound, 4);

                EntFireByHandle(sound1, "PlaySound", "", g_fDelay_Reload * 0.3, null, null)
                EntFireByHandle(sound2, "PlaySound", "", g_fDelay_Reload * 0.45, null, null)
                EntFireByHandle(sound3, "PlaySound", "", g_fDelay_Reload * 0.6, null, null)
                EntFireByHandle(sound4, "PlaySound", "", g_fDelay_Reload * 0.8, null, null)
                EntFireByHandle(sound5, "PlaySound", "", g_fDelay_Reload * 0.9, null, null)

                EntFireByHandle(sound1, "Kill", "", g_fDelay_Reload, null, null)
                EntFireByHandle(sound2, "Kill", "", g_fDelay_Reload, null, null)
                EntFireByHandle(sound3, "Kill", "", g_fDelay_Reload, null, null)
                EntFireByHandle(sound4, "Kill", "", g_fDelay_Reload, null, null)
                EntFireByHandle(sound5, "Kill", "", g_fDelay_Reload, null, null)
                
                EntFireByHandle(self, "RunScriptCode", "g_bReload = false;g_iAmmo = " + g_iClipSize, g_fDelay_Reload, null, null);
            }
            else if(g_bScope_OnTarget)
            {
                g_iAmmo--;

                local start = g_hEye_Start.GetOrigin();
                EntFireByHandle(CreateSprite(start - g_hEye_Start.GetForwardVector() * 200, type_snipershot_sprite), "Kill", "", 0.1, null, null);
                EntFireByHandle(CreateLightd(start - g_hEye_Start.GetForwardVector() * 200, type_snipershot_light), "Kill", "", 0.1, null, null);
        
                local end = GetPredictionOrigin(start, g_hTarget.EyePosition(), g_hTarget.GetVelocity(), 100.0, 0.01, 50);

                // //DebugDrawBox(end, Vector(-32, -32, -32), Vector(32, 32, 32), 255, 0, 0, 255, 2);

                local dir = (start - end);
                dir.Norm();

                
                local sniper_bullet = CreateProp(start, type_sniperbullet_prop);
                sniper_bullet.SetForwardVector(dir);
                
                EntFireByHandle(sniper_bullet, "RunScriptFile", "kotya/npst/sniper/sniperbullet.nut", 0.00, null, null);
                
                {
                    EntFireByHandle(g_hEye_Sprite, "HideSprite", "", 0.00, null, null);
                    EntFireByHandle(g_hEye_Sprite, "ShowSprite", "", 0.25, null, null);

                    EntFireByHandle(g_hBeam, "TurnOff", "", 0.00, null, null);
                    EntFireByHandle(g_hBeam, "TurnOn", "", 0.25, null, null);
                }

                //if(GetDistance3D(start, g_hTarget.EyePosition()) < 2500)
                    {EntFireByHandle(CreateSound((start - g_hEye_Start.GetForwardVector() * 200), type_snipershoot_sound, 0), "Kill", "", g_fDelay_Shoot, null, null);}

                {
                    local sound4 = CreateSound((start), type_sniperreload_sound, 3);
                    local sound5 = CreateSound((start), type_sniperreload_sound, 4);

                    EntFireByHandle(sound4, "PlaySound", "", g_fDelay_Shoot * 0.4, null, null)
                    EntFireByHandle(sound5, "PlaySound", "", g_fDelay_Shoot * 0.6, null, null)

                    EntFireByHandle(sound4, "Kill", "", g_fDelay_Shoot, null, null)
                    EntFireByHandle(sound5, "Kill", "", g_fDelay_Shoot, null, null)
                }

                g_bCan_Shoot = false;
                EntFireByHandle(self, "RunScriptCode", "g_bCan_Shoot = true;", g_fDelay_Shoot, null, null);

                g_bScope_OnTarget = false;
                g_hTarget = null;
            }
        }
    }
    /*
    function GetPost()
    {
        local targetpos = g_hTarget.EyePosition();
        local shootpos = g_hEye_Start.GetOrigin();
        local targetspeed = g_hTarget.GetVelocity();
        local buttetspeed = 80.00;

        local totarget = targetpos - shootpos;

        local a = VectorDot(targetspeed, targetspeed) - (buttetspeed * buttetspeed / 0.01 * 50);

        //9 000 000
        
        local b = 2 * VectorDot(targetspeed, totarget);
        local c = VectorDot(totarget, totarget);

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
    
        return targetpos + targetspeed * t;
    }
    
        Vector totarget =  target.position - tower.position;

        float a = Vector.Dot(target.velocity, target.velocity) - (bullet.velocity * bullet.velocity);
        float b = 2 * Vector.Dot(target.velocity, totarget);
        float c = Vector.Dot(totarget, totarget);

        float p = -b / (2 * a);
        float q = (float)Math.Sqrt((b * b) - 4 * a * c) / (2 * a);

        float t1 = p - q;
        float t2 = p + q;
        float t;

        if (t1 > t2 && t2 > 0)
        {
            t = t2;
        }
        else
        {
            t = t1;
        }

        Vector aimSpot = target.position + target.velocity * t;
        Vector bulletPath = aimSpot - tower.position;
        float timeToImpact = bulletPath.Length() / bullet.speed;//speed must be in units per second 
    */


    // function GetPost()
    // {
    //     local target_origin = target.EyePosition();
    //     local self_origin = g_hEye_Start.GetOrigin();
    //     local k = (GetDistance3D(target_origin, self_origin) / 140.00) / TICKRATE;
    //     //k = 1
    //     local x = (target_origin.x - g_oTarget_last.x) * k + target_origin.x;
    //     local y = (target_origin.y - g_oTarget_last.y) * k + target_origin.y;
    //     local z = (target_origin.z - g_oTarget_last.z) * k + target_origin.z;

    //     local text = "" + target_origin + "\n"
    //     text += "" + k + "\n"
    //     text += "" + target_origin.x + " - " +g_oTarget_last.x + "*" + k + "+" + target_origin.y + "\n"
    //     text += "" + Vector(x, y, z) + "\n"

    //     return Vector(x, y, z);
    // }
}
Init();