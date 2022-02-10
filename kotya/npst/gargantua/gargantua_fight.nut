g_hTeleported <- null;
g_oTeleported <- Vector(0, 0, 0);
g_fTimer_TakeTime <- 0.0;
g_fTimer_fTime_Skip <- 0.0;
g_bTake <- false;
g_bEnd <- false;
g_hMaker <- null;
g_hBoss <- null;

const TICKRATE = 0.5;

g_vPos_Gargantua_PickUp <- class_pos(Vector(-2101, 297, -1375), Vector(0, 25, 0));
g_vPos_Gargantua_Spawn <- class_pos(Vector(-1912, 378, -1525), Vector(0, 25, 0));
g_fTime_TakeTime <- 4;
g_fTime_Skip <- 30;


/*
setpos .588013 .474182 -.511475;setang 21.787840 27.564260 0.000000
Unhandled animation event 1008 for prop_dynamic
] 
] getpos 
setpos .170654 .162476 .989014;setang 10.319903 21.566351 0.000000
*/

ARRAY_BEST_INFECTORS <- [];

EntFireByHandle(self, "RunScriptCode", "Init();", 0.01, null, null);

function Init()
{
    g_fTime_TakeTime = 0.00 + g_fTime_TakeTime;
    g_fTime_Skip = 0.00 + g_fTime_Skip;

    g_fTimer_TakeTime = g_fTime_TakeTime;

    local template = Entities.FindByName(null, "gargantua_template");
    if(template != null)
    {
        g_hMaker = Entities.CreateByClassname("env_entity_maker");
        g_hMaker.__KeyValueFromString("EntityTemplate", template.GetName())
    }
}

function Start()
{
    if(g_hMaker == null)
        return End();

    CreateField();

    g_hMaker.SpawnEntityAtLocation(g_vPos_Gargantua_Spawn.origin, g_vPos_Gargantua_Spawn.angles);

    GenerateBestInfectors();
    
    g_bTake = false;
    Tick();
}

function CreateField()
{
    local z = -1100;
    local arVec = [
        Vector(917, -11, z), Vector(-1585, -11, z), 
        Vector(-1585, 2261, z), Vector(-97, 2261, z),
        Vector(-97, 1541, z), Vector(111, 1541, z),
        Vector(111, 1877, z), Vector(917, 1877, z),
        ]
    
    local beam;
    local parent1;
    local arName = [];

    for(local i = 0; i < arVec.len(); i++)
    {
        parent1 = CreateProp(arVec[i], type_parent_prop);
        parent1.__KeyValueFromString("targetname", "Gargantua_Beam_Parent" + i);
    }

    for(local i = 0; i < arVec.len(); i++)
    {
        arName.clear();
        arName.push("Gargantua_Beam_Parent" + i);
        arName.push("Gargantua_Beam_Parent" + ((i + 1 < arVec.len() ? (i + 1) : 0)));
        
        beam = CreateBeam(arVec[i], type_gargantua_beam, arName);
        beam.__KeyValueFromString("targetname", "Gargantua_Beam");
    }
}

function PickUp()
{
    EntFire("pick_gargantua", "Disable", "", 0);
    EntFire("pick_gargantua", "Enable", "", 16);
    g_bTake = true;

    

    foreach(pl in PLAYERS)
    {
        if(ValidTarget(pl.handle, 3))
        {
            if(InArray(ARRAY_INSIDE, pl.handle) == -1)
            {
                local dir = (pl.handle.GetOrigin() - Vector(-334, 1125, -1055));
                dir.Norm();
                dir = Vector(-334, 1125, -1055) + dir * 160;
                pl.handle.SetOrigin(Vector(dir.x, dir.y, -1100));
            }
        }
    }

    EntFireByHandle(g_Camera_Script, "RunScriptCode", "FadeIn();", 0, null, null);
    EntFireByHandle(g_Camera_Script, "RunScriptCode", "FadeOut();", 2 + 1.5 + 3.2 + 5.0 + 5.0, null, null);

    EntFireByHandle(caller, "RunScriptCode", "Camera();", 11.5, null, null);

    g_hBoss = activator;
    g_hBoss.SetOrigin(Vector(-1914, 387, -1463));
    g_hBoss.SetVelocity(Vector(0, 0, 0));
    g_hBoss.SetAngles(0, 25, 0);

    /*
        FadeIn();
        FadeOut();
        
        Vector(4763, 246, -514), Vector(21, 170, 0), 0.2, Vector(3900, 341, -876), Vector(1, 172, 0), 0.0, 2.0
        
        Vector(3900, 341, -876), Vector(1, 172, 0), 0.0, Vector(1646, 778, -746), Vector(-21, 166, 0), 0.0, 5.0
        
        Vector(1646, 778, -746), Vector(-21, 166, 0), 0.0, Vector(403, 447, -950), Vector(16, 145, 0), 0.0, 5.0
        
    */
    
    EntFire("citadel_shake", "StartShake", "", 0); //0
    EntFire("about_to_explode", "PlaySound", "", 2.5); //2.5
    EntFire("transmission_flash_end", "Start", "", 5); //5
    EntFire("portal_rift_1", "Start", "", 6); //6

    EntFire("open_transmission_sound", "PlaySound", "", 6); //6
    EntFire("transmission_ring", "Start", "", 6);   //6
    EntFire("transmission_flash", "Start", "", 6);  //6
    EntFire("citadel_shake", "StopShake", "", 7);   //7
    EntFire("transmission_shake", "StartShake", "", 8.5); //8.5

    EntFire("transmission_ring", "DestroyImmediately", "", 10);  //10
    EntFire("transmission_flash_end", "DestroyImmediately", "", 11); //11

    EntFireByHandle(g_Camera_Script, "RunScriptCode", "SpawnCamera(Vector(4763, 246, -514), Vector(21, 170, 0), 0.2, Vector(3900, 341, -876), Vector(1, 172, 0), 0.0, 3.0)", 1, null, null);
    EntFireByHandle(g_Camera_Script, "RunScriptCode", "SpawnCamera(Vector(3900, 341, -876), Vector(1, 172, 0), 0.0, Vector(1646, 778, -746), Vector(-40, 166, 0), 1.0, 5.0)", 1 + 3.2, null, null);
    EntFireByHandle(g_Camera_Script, "RunScriptCode", "SpawnCamera(Vector(1646, 778, -746), Vector(-40, 166, 0), 0.0, Vector(403, 447, -950), Vector(30, 120, 0), 1.5, 5.0)", 2 + 3.2 + 5.0, null, null);

    //EntFireByHandle(g_Camera_Script, "RunScriptCode", "SpawnCamera(Vector(1794, -656, -480), Vector(15, 135, 0), 0.8, Vector(-641, 2203, -1233), Vector(-22, -117, 0), 0.0, 6.2)", 1, null, null);
    //EntFireByHandle(g_Camera_Script, "RunScriptCode", "SpawnCamera(Vector(-641, 2203, -1233), Vector(-22, -117, 0), 0.8, Vector(-948, 1632, -1262), Vector(8, -117, 0), 0.8, 3.4)", 8, null, null);
}

function Tick()
{
    if(g_bTake)
        return;

    g_fTimer_TakeTime += TICKRATE;
    if(g_fTimer_TakeTime >= g_fTime_TakeTime)
    {
        g_fTimer_TakeTime = 0.0;

        if(ValidTarget(g_hTeleported))
        {
            g_hTeleported.SetOrigin(g_oTeleported.origin);
            g_hTeleported.SetAngles(g_oTeleported.ax, g_oTeleported.ay, g_oTeleported.az);
        }
        
        g_hTeleported = GetBestInfector();

        if(g_hTeleported == null)
            return End();
        
        g_oTeleported = class_pos(g_hTeleported.GetOrigin(), g_hTeleported.GetAngles());

        g_hTeleported.SetOrigin(g_vPos_Gargantua_PickUp.origin);
        g_hTeleported.SetAngles(g_vPos_Gargantua_PickUp.ax, g_vPos_Gargantua_PickUp.ay, g_vPos_Gargantua_PickUp.az);
    }

    g_fTimer_fTime_Skip += TICKRATE;
    if(g_fTimer_fTime_Skip >= g_fTime_Skip)
    {
        if(ValidTarget(g_hTeleported))
            g_hTeleported.SetOrigin(g_oTeleported);
        return End();
    }

    EntFireByHandle(self, "RunScriptCode", "Tick();", TICKRATE, null, null);
}

function End()
{
    if(g_bEnd)
        return;
    g_bEnd = true;
    
    EntFire("SkyExplose2", "Trigger", "", 5);
    EntFire("Gargantua*", "Kill", "", 5);

    EntFire("text_command", "Command", "say Gargantua died, let's get back to the bridge.", 0);

    local handle;
    while((handle = Entities.FindByClassname(handle, "player")) != null)
    {
        if(!handle.IsValid() || handle.GetHealth() <= 0)
            continue;
        if(handle.GetTeam() == 2)
            handle.SetOrigin(Vector(-2666, 1317, 105));
        else
            EntFireByHandle(handle, "SetDamageFilter", "", 0, null, null); 
    }
}

function GenerateBestInfectors()
{
    ARRAY_BEST_INFECTORS.clear();

    foreach(p in PLAYERS)
    {
        local handle = p.handle;

        if(!ValidTarget(handle, 2)){continue;}
        
        ARRAY_BEST_INFECTORS.push(p);
    }
    
    ARRAY_BEST_INFECTORS.sort(Infector_SortFunction);
}


function Infector_SortFunction(first, second) 
{
    if(first.infects > second.infects){return 1;}
    if(first.infects < second.infects){return -1;}
    return 0;
}

function GetBestInfector()
{
    local i = ARRAY_BEST_INFECTORS.len() - 1;
    local infector = null;
    
    for(; i >= 0; i--)
    {
        local handle = ARRAY_BEST_INFECTORS[i].handle;

        if(!ValidTarget(handle, 2)){continue;}
        
        infector = handle;
        ARRAY_BEST_INFECTORS.remove(i);

        break;
    }
    
    return infector;
}

ARRAY_INSIDE <- [];

function EndTouch()
{
    if(g_bEnd)
        return;

    if(activator.GetTeam() == 3)
    {
        local i = InArray(ARRAY_INSIDE, activator)
        if(i == -1)
            return;
    
        EntFireByHandle(ARRAY_INSIDE[i], "SetDamageFilter", "", 0, null, null);
        ARRAY_INSIDE.remove(i);
    }
    else if(g_hBoss == activator)
    {
        activator.SetOrigin(Vector(caller.GetOrigin().x, caller.GetOrigin().y, activator.GetOrigin().z))
        activator.SetVelocity(Vector(0, 0, 0));
    }
}

function Touch()
{
    if(g_bEnd)
        return;

    if(activator.GetTeam() == 3)
    {
        if(InArray(ARRAY_INSIDE, activator) != -1)
            return;

        ARRAY_INSIDE.push(activator);

        EntFireByHandle(activator, "SetDamageFilter", "No_T", 0, null, null);
    }
}

function InArray(array, value)
{
    for (local i = 0; i < array.len(); i++)
    {
        if(array[i] == value)
            return i;
    }

    return -1;
}
// function test_1()
// {
//     for(local i = 0; i < ARRAY_BEST_INFECTORS.len(); i++){printl("\n" + i + ")" + ARRAY_BEST_INFECTORS[i].handle + " - " + ARRAY_BEST_INFECTORS[i].infects)};
// }