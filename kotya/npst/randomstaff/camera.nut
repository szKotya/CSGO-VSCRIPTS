
Fade_In <- Entities.CreateByClassname("env_fade");
{
    Fade_In.__KeyValueFromFloat("duration", 1.0);
    Fade_In.__KeyValueFromFloat("holdtime", 0.1);
    Fade_In.__KeyValueFromInt("renderamt", 255);
    Fade_In.__KeyValueFromInt("spawnflags", 6);
    Fade_In.__KeyValueFromVector("rendercolor", Vector(0, 0, 0));
}
Fade_Out <- Entities.CreateByClassname("env_fade");
{
    Fade_Out.__KeyValueFromFloat("duration", 1.0);
    Fade_Out.__KeyValueFromFloat("holdtime", 0.1);
    Fade_Out.__KeyValueFromInt("renderamt", 255);
    Fade_Out.__KeyValueFromInt("spawnflags", 5);
    Fade_Out.__KeyValueFromVector("rendercolor", Vector(0, 0, 0));
}

Overlay <- null;
//Overlay <- "Rafuron/LMS_Other/cinematic_overlay"
//ent_fire map_script_camera runscriptcode "SpawnCamera(Vector(0,0,0), Vector(0,0,0), 5, Vector(100,100,100), Vector(50,50,50), 5, 10)"
//ent_fire viewtarget runscriptcode "self.SetOrigin(Vector(-100, -100, -100))"

function SpawnCamera(o1, a1, time1, o2, a2, time2, flytime)
{
    local viewcontrol = Entities.CreateByClassname("point_viewcontrol_multiplayer");
    local viewtarget = Entities.CreateByClassname("info_target");
    viewcontrol.__KeyValueFromString("targetname", "viewcontrol");
    viewtarget.__KeyValueFromString("targetname", "viewtarget");
    viewtarget.SetAngles(a2.x, a2.y, a2.z);
    viewtarget.SetOrigin(o2);
    viewcontrol.SetAngles(a1.x, a1.y, a1.z);
    viewcontrol.SetOrigin(o1);
    viewcontrol.__KeyValueFromString("target_entity", "viewtarget");
    EntFireByHandle(viewcontrol, "Enable", "", 0, viewcontrol, viewcontrol);
    viewcontrol.__KeyValueFromFloat("interp_time", flytime);
    EntFireByHandle(viewcontrol, "StartMovement", "", 0.01 + time1, viewcontrol, viewcontrol);
    EntFireByHandle(viewcontrol, "Disable", "", time1+time2+flytime - 0.01, viewcontrol, viewcontrol);
    EntFireByHandle(viewcontrol, "Kill", "", time1+time2+flytime, viewcontrol, viewcontrol);
    EntFireByHandle(viewtarget, "Kill", "", time1+time2+flytime, viewtarget, viewtarget);
}

function FadeIn()
{
    local handle = null;
    while(null != (handle = Entities.FindByClassname(handle, "player")))
	{
        if(!handle.IsValid())
            continue;

        if(Fade_In != null && Fade_In.IsValid())
            EntFireByHandle(Fade_In, "Fade", "", 0.00, handle, handle);

        if(Overlay != null)
            EntFire("point_clientcommand", "Command", "r_screenoverlay " + OverLayName, 0, handle); 
    }
}

function FadeOut()
{
    local handle = null;
    while(null != (handle = Entities.FindByClassname(handle, "player")))
	{
        if(!handle.IsValid())
            continue;

        if(Fade_Out != null && Fade_Out.IsValid())
            EntFireByHandle(Fade_Out, "Fade", "", 0.00, handle, handle);

        EntFire("point_clientcommand", "Command", "r_screenoverlay clear", 0, handle); 
    }
}
