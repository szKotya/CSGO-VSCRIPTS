
g_aiLimit <- [self.GetOrigin().z + RandomInt(-40, -25), self.GetOrigin().z + RandomInt(15, 35)];
g_bUp <- RandomInt(0, 1)
g_bRotate <- RandomInt(-1, 1);

//g_fTime_Init <- 10.0;

g_fTime_Init <- 5.0;
g_bInit <- false;
g_bTicking <- false;

g_iRadius <- 0;
g_iDamage <- 0;
g_fSpeed <- 45;
g_bFade <- false;
g_vMove <- Vector(0,0,0);
const TICKRATE_MOVING = 0.01;
const TICKRATE_INIT = 0.05;

function Init()
{
    g_fTime_Init = 0.00 + g_fTime_Init;
    g_fSpeed = 0.00 + g_fSpeed;

    g_bInit = true;
}

EntFireByHandle(self, "RunScriptCode", "Start()", 0.01, null, null);

function Start() 
{
    EntFireByHandle(self, "RunScriptCode", "StartPush()", g_fTime_Init, null, null);

    Init();
    TickRotate();
}

function StartPush() 
{
    local target = GetRandomTarget(self.GetOrigin(), 5000);

    if(target != null)
    {
        local endVec = GetPredictionOrigin(self.GetOrigin(), target.EyePosition(), target.GetVelocity(), g_fSpeed, TICKRATE_MOVING, 50);
        local newVec = (self.GetOrigin() - endVec)
        newVec.Norm();

        g_vMove = newVec;
    }
    else 
    {
        return SelfDestroy();
    }

    g_bTicking = true;
    //g_bInit = false;

    TickMove();
}

function TickMove() 
{   
    if(self.IsValid())
    {
        local so = self.GetOrigin();
        
        if(CheckForPlayer())
        {
            self.SetOrigin(so - (g_vMove * g_fSpeed * 1.5));
            Tickdamage();
            return SelfDestroy();
        }
        else if(!InSight(so, so - (g_vMove * g_fSpeed), IgnoreID_Nihilanth))
        {
            Tickdamage();
            return SelfDestroy();
        }

        self.SetOrigin(so - (g_vMove * g_fSpeed));
        EntFireByHandle(self, "RunScriptCode", "TickMove()", TICKRATE_MOVING, null, null);
    }
}

function CheckForPlayer()
{
    local h = null;
    while(null != (h = Entities.FindInSphere(h, self.GetOrigin(), g_iRadius)))
    {
        if(h.GetClassname() == "player" && 
            h.IsValid() && 
            h.GetHealth() > 0 &&
            h.GetTeam() == 3)
            return true;
    }
    return false;
}

function Tickdamage() 
{
    if(!g_bTicking)
        return;
    
    DamageInSphere(self.GetOrigin(), g_iRadius, g_iDamage)
}

function TickRotate() 
{
    if(!g_bInit)
        return;

    if(g_bUp)
    {
        self.SetOrigin(self.GetOrigin() + Vector(0, 0, 1))
        if(self.GetOrigin().z >= g_aiLimit[1])
            g_bUp = false;
    }
    else
    {
        self.SetOrigin(self.GetOrigin() - Vector(0, 0, 1))
        if(self.GetOrigin().z <= g_aiLimit[0])
            g_bUp = true;
    }

    if(g_bRotate == 1)
    {
        local angels = self.GetAngles();
        self.SetAngles(angels.x + 1, angels.y + 1, angels.z + 1)
    }
    else if(g_bRotate == 0)
    {
        local angels = self.GetAngles();
        self.SetAngles(angels.x - 1, angels.y - 1, angels.z - 1)
    }

    EntFireByHandle(self, "RunScriptCode", "TickRotate()", TICKRATE_INIT, null, null);
}

function GetRandomTarget(origin, radius) 
{
    local array = [];
    local h = null;
    while(null != (h = Entities.FindInSphere(h, origin, radius)))
    {
        if(h.GetClassname() == "player" && 
            h.IsValid() && 
            h.GetHealth() > 0 &&
            h.GetTeam() == 3)
        array.push(h);
    }    
    if(array.len() <= 0)
        return null;
    return array[RandomInt(0, array.len() - 1)];
}

function SelfDestroy() 
{
    g_bTicking = false;
    g_bInit = false;
    
    if(!g_bFade)
        EntFireByHandle(self, "Break", "", 0.05, null, null);
    else
        EntFireByHandle(self, "Kill", "", 10.0, null, null);
    local part = CreateParticle(self.GetOrigin(), Teleprop_end, true);
    EntFireByHandle(part, "Kill", "", 0.8, null, null);
}