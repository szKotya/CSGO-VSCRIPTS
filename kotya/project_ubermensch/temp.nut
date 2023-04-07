IncludeScript("kotya/project_ubermensch/vec_lib.nut", this);
IncludeScript("kotya/project_ubermensch/morefunctions_lib.nut", this);
IncludeScript("kotya/project_ubermensch/draw_lib.nut", this);

function SpawnCameras(o1, a1, time1, o2, a2, time2, flytime)
{
    local viewtarget = Entities.CreateByClassname("info_target");

    viewtarget.__KeyValueFromString("targetname", "viewtarget");
    viewtarget.SetAngles(a2.x, a2.y, a2.z);
    viewtarget.SetOrigin(o2);

    local viewcontrol = Entities.CreateByClassname("point_viewcontrol_multiplayer");
	viewcontrol.__KeyValueFromString("targetname", "viewcontrol");
    viewcontrol.SetAngles(a1.x, a1.y, a1.z);
    viewcontrol.SetOrigin(o1);
    viewcontrol.__KeyValueFromString("target_entity", "viewtarget");
	viewcontrol.__KeyValueFromFloat("interp_time", flytime);

    EntFireByHandle(viewcontrol, "Enable", "", 0, viewcontrol, viewcontrol);
    EntFireByHandle(viewcontrol, "StartMovement", "", 0.01 + time1, viewcontrol, viewcontrol);
    EntFireByHandle(viewcontrol, "Disable", "", time1+time2+flytime - 0.01, viewcontrol, viewcontrol);
    EntFireByHandle(viewcontrol, "Kill", "", time1+time2+flytime, viewcontrol, viewcontrol);

    EntFireByHandle(viewtarget, "Kill", "", time1+time2+flytime, viewtarget, viewtarget);
}


// SpawnCameras(Vector(-487, 721, 172), Vector(5, 24, 0), 0, Vector(-196, 894, 136), Vector(-0, -87, 0), 1, 5)
// SpawnCameras(Vector(-207, 115, 166), Vector(1, 142, 0), 3, Vector(-855, 184, 169), Vector(5, 75, 0), 4, 1)

// function Init()
// {
// 	CAMERA_PLACE.push(class_camera_place(Vector(-487, 721, 172), Vector(5, 24, 0), 0, 5));
// 	CAMERA_PLACE.push(class_camera_place(Vector(-196, 894, 136), Vector(-0, -87, 0), 1, 2));
// 	CAMERA_PLACE.push(class_camera_place(Vector(-207, 115, 166), Vector(1, 142, 0), 3, 1));
// 	CAMERA_PLACE.push(class_camera_place(Vector(-855, 184, 169), Vector(5, 75, 0), 4, 1));
// }