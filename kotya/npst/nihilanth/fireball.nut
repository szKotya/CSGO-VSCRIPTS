g_iRadius <- 128;
g_iDamage <- 10;
g_fSpeed <- 30;
g_bTick <- false;
g_vMove <- null;
g_vBmove <- null;
const TICKRATE_MOVING = 0.01;
const TICKRATE_DAMAGE = 0.25;

function Init()
{
    g_fSpeed = 0.00 + g_fSpeed;
}

EntFireByHandle(self, "RunScriptCode", "Start()", 0, null, null);

function Start() 
{
    Init();

    if(g_vMove == null)
    {
        local target = g_hTarget;
        if(target == null)
            target = GetRandomTarget(self.GetOrigin(), 5000);

        if(target != null)
        {
            g_vBmove = GetPredictionOrigin(self.GetOrigin(), target.EyePosition(), target.GetVelocity(), g_fSpeed, TICKRATE_MOVING, 50);
            local newVec = (self.GetOrigin() - g_vBmove);
            
            newVec.Norm();

            g_vMove = newVec;
        }
        else 
        {
            return SelfDestroy();
        }
    }

    g_bTick = true;

    TickMove();
}


function TickMove() 
{   
    if(g_bTick)
    {
        local so = self.GetOrigin();

        if(CheckForPlayer())
        {
            self.SetOrigin(so - (g_vMove * g_fSpeed * 1.5));
            DamageInSphere(self.GetOrigin(), g_iRadius, g_iDamage);
            return SelfDestroy();
        }
        else if(!InSight(so, so - (g_vMove * g_fSpeed), IgnoreID_Nihilanth))
        {
            DamageInSphere(self.GetOrigin(), g_iRadius, g_iDamage);
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
    if(g_bTick)
    {
        g_bTick = false;
        EntFireByHandle(CreateParticle(self.GetOrigin(), FireBall_Explode, true), "Kill", "", 0.3, null, null);
        EntFireByHandle(self, "DestroyImmediately", "", 0.1, null, null);
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