g_vGrab_Origin <- null;
g_vKill_Origin <- null;
g_bTicking <- false;

g_iHP <- 0;

g_hPlayer <- null;
g_vGrabPlayer_Origin <- null;

Anim_now <- "";

/*Settings*/
const TICKRATE = 0.2;
const TICKRATE_MOVE = 0.02;

g_fClean_Time <- 200.0;

g_iKill_Distance <- 110;
g_iGrab_Distance <- 15;

g_iGrab_Speed <- 2;

g_iBase_HP <- 60;
g_iHuman_HP <- 10;
g_iAddHP_Radius <- 2048;
/*End*/

EntFireByHandle(self, "RunScriptCode", "PreInit()", 0, null, null);

function PreInit()
{
    g_fClean_Time = 0.00 + g_fClean_Time;

    Init();
}

function Init()
{
    local origin_new = self.GetOrigin() //+ Vector(0,0,100);
    local checks = 0;

    while(checks < 10000)
    {
        if(!InSight(origin_new, origin_new + Vector(0,0,1), self))
        {
            origin_new = origin_new - Vector(0,0,2);

            self.SetOrigin(origin_new);
            g_vKill_Origin = origin_new;
            return Init_Last(origin_new);
        }

        origin_new = origin_new + Vector(0,0,1);
        checks++;
    }

    self.Destroy();
}

function Init_Last(origin_grab)
{
    local checks = 0;

    while(checks < 10000)
    {
        if(!InSight(origin_grab, origin_grab - Vector(0,0,16), self))
        {
            g_vGrab_Origin = origin_grab;
            
            return Start();
        }

        origin_grab = origin_grab - Vector(0,0,8);
        checks++;
    }

    self.Destroy();
}

function Start()
{
    SetHP();

    EntFireByHandle(self, "AddOutPut", "OnAnimationDone !self:RunScriptCode:AnimDone():0:-1", 0.01, null, null);
    EntFireByHandle(self, "AddOutPut", "OnHealthChanged !self:RunScriptCode:Damage():0:-1", 0.01, null, null);

    EntFireByHandle(self, "RunScritpCode", "Death()", g_fClean_Time, null, null);

    g_bTicking = true;
    Tick();
}

function SetHP()
{
    g_iHP = g_iBase_HP + CountPlayers(self.GetOrigin(), g_iAddHP_Radius) * g_iHuman_HP;
}

function Damage(i = 1)
{
    if(!g_bTicking)
        return;

    g_iHP -= i;

    if(g_iHP <= 0)
    {
        Death();
    }
    else if(Anim_now == "Idle")
    {
        if(RandomBool())
            SetAnimation(A_TakeDamage1);
        else
            SetAnimation(A_TakeDamage2);
        Anim_now = "Damage"
    }
}

function Death()
{
    if(!g_bTicking)
        return;

    g_bTicking = false;

    if(ValidTarget(g_hPlayer, -1))
        UnGrab();

    if(RandomBool())
    {
        local time = 3;
        SetAnimation(A_Death1);
        EntFireByHandle(self, "FadeAndKill", "", time, null, null);
    }
    else
    {
        local time = 3;
        SetAnimation(A_Death2);
        EntFireByHandle(self, "FadeAndKill", "", time, null, null);
    }
}

function UnGrab(kill = false)
{
    g_hPlayer.__KeyValueFromInt("MoveType", 2);

    g_hPlayer.SetVelocity(Vector(0,0,0));

    if(kill)
        EntFireByHandle(g_hPlayer, "SetHealth", "-69", 0, g_hPlayer, g_hPlayer);
    
    g_hPlayer = null;
}

function Grab(handle)
{
    g_hPlayer = handle;
    g_hPlayer.__KeyValueFromInt("MoveType", 7);
    g_vGrabPlayer_Origin = g_vGrab_Origin + Vector(0, 0, 16);
    g_hPlayer.SetOrigin(g_vGrabPlayer_Origin);
}

function SearchTarget()
{
    local h = null;
    while(null != (h = Entities.FindInSphere(h, g_vGrab_Origin, g_iGrab_Distance)))
    {
        if(h.GetClassname() == "player" && h.IsValid() && h.GetHealth() > 0)
		{
            SetAnimGrab();
            Grab(h);
            
            return;
        }
    }
}

function MoveTarget()
{
    if(GetDistance3D(g_hPlayer.GetOrigin(), g_vKill_Origin) < g_iKill_Distance)
    {
        SetAnimAttack();
        EntFireByHandle(self, "RunScriptCode", "UnGrab(true);", 0.85, null, null);
    }
    else
    {
        g_vGrabPlayer_Origin += Vector(0, 0, g_iGrab_Speed);
        g_hPlayer.SetOrigin(g_vGrabPlayer_Origin);
    }
}

function SetAnimAttack()
{
    Anim_now = "Attack";
    SetAnimation(A_Attack);
}

function Tick()
{
    if(!g_bTicking)
        return;

    if(Anim_now != "Attack" && Anim_now != "Reset")
    {
        if(ValidTarget(g_hPlayer, -1))
        {
            MoveTarget();
            return EntFireByHandle(self, "RunScriptCode", "Tick();", TICKRATE_MOVE, null, null);
        }
        
        SearchTarget();

        if(ValidTarget(g_hPlayer, -1))
        {
            MoveTarget();
            return EntFireByHandle(self, "RunScriptCode", "Tick();", TICKRATE_MOVE, null, null);
        }

        if(Anim_now != "Damage")
            SetAnimIdle();
    }

    EntFireByHandle(self, "RunScriptCode", "Tick();", TICKRATE, null, null);

    //PrintInfo()
    
}

function AnimDone()
{
    if(Anim_now == "Attack")
    {
        SetAnimReset();
    }
    else if(Anim_now == "Reset")
    {
        SetAnimIdle();
    }
    else if(Anim_now == "Damage")
    {
        Anim_now = "Idle";
    }
}

function SetAnimReset()
{
    Anim_now = "Reset";
    SetAnimation(A_Reset);
}

function SetAnimIdle()
{
    if(Anim_now != "Idle")
    {
        SetDefAnimation(A_Idle);
        SetAnimation(A_Idle); 
    }
    Anim_now = "Idle";
}

function SetAnimGrab()
{
    Anim_now = "Grab";
    SetDefAnimation(A_Grabing);
    SetAnimation(A_Grabing); 
}

A_Death1 <- "death";
A_Death2 <- "death2";

A_TakeDamage1 <- "flinch1";
A_TakeDamage2 <- "flinch2";

A_Idle <- "idle01";
A_Reset <- "reset_tongue";
A_Attack <- "eat_humanoid";
A_Grabing <- "slurp";

function SetDefAnimation(animationName,time = 0.01)EntFireByHandle(self,"SetDefaultAnimation",animationName.tostring(),time,null,null);
function SetAnimation(animationName,time = 0)EntFireByHandle(self,"SetAnimation",animationName.tostring(),time,null,null);