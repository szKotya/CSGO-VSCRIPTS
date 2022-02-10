
Fade_In <- Entities.CreateByClassname("env_fade");
{
    Fade_In.__KeyValueFromFloat("duration", 4.0);
    Fade_In.__KeyValueFromFloat("holdtime", 0.8);
    Fade_In.__KeyValueFromInt("renderamt", 200);
    Fade_In.__KeyValueFromInt("spawnflags", 7);
    Fade_In.__KeyValueFromVector("rendercolor", Vector(28, 184, 227));
}
Fade_Out <- Entities.CreateByClassname("env_fade");
{
    Fade_Out.__KeyValueFromFloat("duration", 2.0);
    Fade_Out.__KeyValueFromFloat("holdtime", 0.2);
    Fade_Out.__KeyValueFromInt("renderamt", 200);
    Fade_Out.__KeyValueFromInt("spawnflags", 7);
    Fade_Out.__KeyValueFromVector("rendercolor", Vector(28, 184, 227));
}

Overlay <- null;
//Overlay <- "Rafuron/LMS_Other/cinematic_overlay"
//ent_fire map_script_camera runscriptcode "SpawnCamera(Vector(0,0,0), Vector(0,0,0), 5, Vector(100,100,100), Vector(50,50,50), 5, 10)"
//ent_fire viewtarget runscriptcode "self.SetOrigin(Vector(-100, -100, -100))"

ARRAY_CAMERA <- [];
viewcontrol <- null;
viewtarget <- null;

class class_camera_path
{
    camera0 = null;
    camera1 = null;
    flytime = 0.0;

    constructor(_camera0, _camera1, _flytime)
    {
        this.camera0 = _camera0;
        this.camera1 = _camera1;
        this.flytime = 0.0 + _flytime;
    }
}

class class_camera 
{
    origin = Vector(0, 0, 0);
    angles = Vector(0, 0, 0);
    hold = 0.0;

    constructor(_origin, _angles, _hold)
    {
        this.origin = _origin;
        this.angles = _angles;
        this.hold = 0.0 + _hold;
    }

    function SetPos(h)
    {
        h.SetOrigin(this.origin);
        h.SetAngles(this.angles.x, this.angles.y, this.angles.z)
    }
}

{
    local value1 = class_camera( Vector(0, 0, 20), Vector(111, 111, 0), 2);
    local value2 = class_camera( Vector(250, 250, 50), Vector(0, 0, 0), 2);

    ARRAY_CAMERA.push(class_camera_path(value1, value2, 3));

    value1 = class_camera( Vector(250, 250, 50), Vector(0, 0, 0), 2);
    value2 = class_camera( Vector(0, 0, 20), Vector(111, 111, 0), 2);

    ARRAY_CAMERA.push(class_camera_path(value1, value2, 3));
}

function SpawnPreset()
{
    viewcontrol = Entities.CreateByClassname("point_viewcontrol_multiplayer");
    viewtarget = Entities.CreateByClassname("info_target");
    viewcontrol.__KeyValueFromString("targetname", "viewcontrol");
    viewtarget.__KeyValueFromString("targetname", "viewtarget");
    viewcontrol.__KeyValueFromString("target_entity", "viewtarget");

    EntFireByHandle(viewcontrol, "Enable", "", 0, viewcontrol, viewcontrol);

    local fKill = 0.00;
    local fMove = 0.01;
    local bend = false;

    local origin;
    local angles;
    
    for(local i = 0; i < ARRAY_CAMERA.len(); i++)
    {
        EntFireByHandle(viewcontrol, "AddOutPut", "interp_time " + ARRAY_CAMERA[i].flytime, fKill, null, null);
        
        origin = ARRAY_CAMERA[i].camera0.origin;
        angles = ARRAY_CAMERA[i].camera0.origin;

        EntFireByHandle(viewcontrol, "RunScriptCode", "self.SetOrigin(Vector(" + origin.x + "," + origin.y + "," + origin.z + "));self.SetAngles(" + angles.x + "," + angles.y + "," + angles.z + ")", fMove - 0.01, null, null);
        
        if(ARRAY_CAMERA[i].camera1 != null)
        {
            origin = ARRAY_CAMERA[i].camera1.origin;
            angles = ARRAY_CAMERA[i].camera1.origin;
        }

        EntFireByHandle(viewtarget, "RunScriptCode", "self.SetOrigin(Vector(" + origin.x + "," + origin.y + "," + origin.z + "));self.SetAngles(" + angles.x + "," + angles.y + "," + angles.z + ")", fMove - 0.01, null, null);

        fKill += ARRAY_CAMERA[i].flytime;
        
        if(ARRAY_CAMERA[i].camera1 != null)
        {
            origin = ARRAY_CAMERA[i].camera0.origin;
            angles = ARRAY_CAMERA[i].camera0.origin;

            fMove += ARRAY_CAMERA[i].camera0.hold;
            if(i != 0)
            {
                EntFireByHandle(viewcontrol, "Disable", "", fMove, viewcontrol, viewcontrol);
                EntFireByHandle(viewcontrol, "Enable", "", fMove, viewcontrol, viewcontrol);
            }
            EntFireByHandle(viewcontrol, "StartMovement", "", fMove, viewcontrol, viewcontrol);
            
            fMove += ARRAY_CAMERA[i].camera1.hold;
            fMove += ARRAY_CAMERA[i].flytime;
        }

        if(ARRAY_CAMERA[i].camera0 != null)
        {
            fKill += ARRAY_CAMERA[i].camera0.hold; 
        }
            
        if(ARRAY_CAMERA[i].camera1 != null)
        {
            fKill += ARRAY_CAMERA[i].camera1.hold;   
        }
    }

    EntFireByHandle(self, "RunScriptCode", "KillCamera()", fKill, null, null);
}

function KillCamera()
{
    if(viewcontrol != null && viewcontrol.IsValid())
    {
        EntFireByHandle(viewcontrol, "Disable", "", 0, null, null);
        EntFireByHandle(viewcontrol, "Kill", "", 0.01, null, null);
    }

    if(viewtarget != null && viewtarget.IsValid())
    {
        EntFireByHandle(viewtarget, "Kill", "", 0.01, null, null);
    }
}

// function SpawnCamera_V2(o1, a1, time1, o2, a2, time2, flytime)
// {
//     local viewcontrol = Entities.CreateByClassname("point_viewcontrol_multiplayer");
//     local viewtarget = Entities.CreateByClassname("info_target");
//     viewcontrol.__KeyValueFromString("targetname", "viewcontrol");
//     viewtarget.__KeyValueFromString("targetname", "viewtarget");
//     viewtarget.SetAngles(a2.x, a2.y, a2.z);
//     viewtarget.SetOrigin(o2);
//     viewcontrol.SetAngles(a1.x, a1.y, a1.z);
//     viewcontrol.SetOrigin(o1);
//     viewcontrol.__KeyValueFromString("target_entity", "viewtarget");
//     viewcontrol.__KeyValueFromFloat("interp_time", flytime);
//     EntFireByHandle(viewcontrol, "Enable", "", 0, viewcontrol, viewcontrol);
//     EntFireByHandle(viewcontrol, "StartMovement", "", 0.01 + time1, viewcontrol, viewcontrol);
//     EntFireByHandle(viewcontrol, "Disable", "", time1+time2+flytime - 0.01, viewcontrol, viewcontrol);
//     EntFireByHandle(viewcontrol, "Kill", "", time1+time2+flytime, viewcontrol, viewcontrol);
//     EntFireByHandle(viewtarget, "Kill", "", time1+time2+flytime, viewtarget, viewtarget);
// }

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
