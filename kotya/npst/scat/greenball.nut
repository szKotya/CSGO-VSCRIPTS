g_iRadius <- 128;
g_iExplosion <- 15;
g_iDamage <- 2;
g_fSpeed <- 40;
g_fTime_Life <- 10;

g_bTick <- false;
g_vMove <- null;
g_vBmove <- null;

g_hWave <- null;
const TICKRATE_MOVING = 0.01;
const TICKRATE_DAMAGE = 0.25;

function Init()
{
    g_fTime_Life = 0.00 + g_fTime_Life;
    g_fSpeed = 0.00 + g_fSpeed;
}

EntFireByHandle(self, "RunScriptCode", "Start()", 0, null, null);

function Start() 
{
    Init();
    
    local target = GetRandomTarget(self.GetOrigin(), 99999);

    g_bTick = true;

    if(target != null)
    {
        local predict = GetPredictionOrigin(self.GetOrigin(), target.GetOrigin(), target.GetVelocity(), 40, 0.01, 50);
        g_vBmove = GetFloor(predict);
        local newVec = (self.GetOrigin() - g_vBmove);
        
        newVec.Norm();

        g_vMove = newVec;
    }
    else 
    {
        return SelfDestroy();
    }

    TickMove();
}


function TickMove() 
{   
    if(g_bTick)
    {
        local so = self.GetOrigin();

        if(CheckForPlayer())
        {
            self.SetOrigin(so - (g_vMove * g_fSpeed * 2.5));
            return Explosion();
        }
        else if(!InSight(so, so - (g_vMove * g_fSpeed), null))
        {
            return Explosion();
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
            h.GetHealth() > 0)
            return true;
    }
    return false;
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

function Explosion()
{
    g_bTick = false;
    DamageInSphere(self.GetOrigin(), g_iRadius, g_iExplosion);
    local origin = GetFloor(self.GetOrigin() + Vector(0, 0, 50), 200);

    // EntFireByHandle(self, "DestroyImmediately", "", 0.1, null, null);
    g_hWave = CreateParticle(origin, GeenBall_Floor, true)
    EntFireByHandle(self, "Kill", "", g_fTime_Life, null, null);
    EntFireByHandle(g_hWave, "Kill", "", g_fTime_Life, null, null);

    TickDamage();
}

function TickDamage()
{
    if(self.IsValid())
    {
        DamageInSphere(g_hWave.GetOrigin(), g_iRadius, g_iDamage);
        EntFireByHandle(self, "RunScriptCode", "TickDamage()", TICKRATE_DAMAGE, null, null);
    }
}


function SelfDestroy()
{
    if(g_bTick)
    {
        g_bTick = false;

        EntFireByHandle(self, "Kill", "", 0.5, null, null);
    }
}



// //Support
// {
//     function DebugDrawCircle(Vector_Center, Vector_RGB, radius, parts, zTest, duration) //0 -32 80
//     {
//         local u = 0.0;
//         local vec_end = [];
//         local parts_l = parts;
//         local radius = radius;
//         local a = PI / parts * 2;
//         while(parts_l > 0)
//         {
//             local vec = Vector(Vector_Center.x+cos(u)*radius, Vector_Center.y+sin(u)*radius, Vector_Center.z);
//             vec_end.push(vec);
//             u += a;
//             parts_l--;
//         }
//         for(local i = 0; i < vec_end.len(); i++)
//         {
//             if(i < vec_end.len()-1){DebugDrawLine(vec_end[i], vec_end[i+1], Vector_RGB.x, Vector_RGB.y, Vector_RGB.z, zTest, duration);}
//             else{DebugDrawLine(vec_end[i], vec_end[0], Vector_RGB.x, Vector_RGB.y, Vector_RGB.z, zTest, duration);}
//         }
//     }
// }