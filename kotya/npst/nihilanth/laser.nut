g_iDistance <- 4500;
g_fTime_Init <- 0;

g_bTicking <- false;
g_iRadius <- 128;
g_iDamage <- 20;
g_fSpeed <- 12;

g_vMove <- Vector(0,0,0);
const TICKRATE_MOVING = 0.01;
const TICKRATE_DAMAGE = 0.25;

function OnPostSpawn()
{
    Start();
}

function Init()
{
    g_fTime_Init = 0.00 + (g_iDistance / g_fSpeed) * TICKRATE_MOVING;

    g_fSpeed = 0.00 + g_fSpeed;
    g_vMove = self.GetForwardVector() * -1;
}

function Start() 
{
    Init();

    EntFireByHandle(self, "RunScriptCode", "SelfDestoy()", g_fTime_Init, null, null);

    g_bTicking = true;
    TickMove();
    TickDamage();
}

function SelfDestoy()
{
    g_bTicking = false;
    EntFireByHandle(self, "Kill", "", 0, null, null);
}

function TickMove() 
{   
    if(!g_bTicking)
        return;

    self.SetOrigin(self.GetOrigin() - (g_vMove * g_fSpeed));
    EntFireByHandle(self, "RunScriptCode", "TickMove()", TICKRATE_MOVING, null, null);
}

function TickDamage() 
{
    if(!g_bTicking)
        return;
        // DebugDrawCircle(self.GetOrigin() + Vector(0, 0, 160), Vector(0,255,0), g_iRadius, 16, true, 1);
    DamageInSphere((self.GetOrigin() + Vector(0, 0, 160)), g_iRadius, g_iDamage)

    EntFireByHandle(self, "RunScriptCode", "Tickdamage()", TICKRATE_DAMAGE, null, null);
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