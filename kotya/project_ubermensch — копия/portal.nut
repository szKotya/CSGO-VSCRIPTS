::Portal_Scope <- self.GetScriptScope();
// TEMP_PORTAL <- {
// 	portal_pos = null,
// 	cam_pos = null,

// 	allow_berserk = true,
// 	allow_vulture = true,
// 	allow_tank = true,

// 	disable = false,

// 	limited = false,
// 	limit_count = 2,
// 	limit_cd = 15.0,

// 	kv_hitbox = {},
// 	kv_trigger = {},
// 	kv_model = {},
// };

::PORTALS_CH02_QUEST01 <- [];

function Init()
{
	// printl("INIT PORTAL")
	PORTALS.push(class_zombie_portal({portal_pos = class_pos(), cam_pos = class_pos(Vector(-15740, 15464, 15350), Vector(0, 45, 0)), allow_berserk = true, allow_vulture = true, allow_tank = true, disable = false, limited = false, limit_count = -1, limit_cd = -1, kv_hitbox = null, kv_trigger = null, kv_model = null}));
	PORTALS[0].SetPlug();

	PORTALING_POS = class_pos(Vector(-15740, 15464, 15350), Vector(0, 45, 0));
}

::Portal_Init_CH01 <- function()
{
	local _portal_pos = class_pos(Vector(-873, -2822, -35), Vector(1, 0, 0));
	local _cam_pos = class_pos(Vector(-512, -2514, 146), Vector(17, -166, 0));

	local aData = {portal_pos = null, cam_pos = null, allow_berserk = true, allow_vulture = true, allow_tank = true, disable = false, limited = false, limit_count = -1, limit_cd = -1.0, kv_hitbox = null, kv_trigger = {}, kv_model = {}};

	aData.portal_pos = _portal_pos;
	aData.cam_pos = _cam_pos;

	CreatePortal(aData);
	iChapter01_Save_Portals.push([aData, iChapter01_Save_Portals.len()]);

	_portal_pos = class_pos(Vector(3072, -672, -195), Vector(0, -1, 0));
	_cam_pos = class_pos(Vector(3357, -1219, -87), Vector(2, 107, 0));

	aData = {portal_pos = null, cam_pos = null, allow_berserk = true, allow_vulture = true, allow_tank = true, disable = false, limited = true, limit_count = 5, limit_cd = 15.0, kv_hitbox = {}, kv_trigger = {}, kv_model = {}};

	aData.portal_pos = _portal_pos;
	aData.cam_pos = _cam_pos;

	CreatePortal(aData);
	iChapter01_Save_Portals.push([aData, iChapter01_Save_Portals.len()]);

	_portal_pos = class_pos(Vector(1973, -642, -187), Vector(0, -1, 0));
	_cam_pos = class_pos(Vector(2015, -860, -24), Vector(17, 59, 0));

	aData = {portal_pos = null, cam_pos = null, allow_berserk = true, allow_vulture = true, allow_tank = true, disable = false, limited = true, limit_count = 5, limit_cd = 15.0, kv_hitbox = {}, kv_trigger = {}, kv_model = {}};

	aData.portal_pos = _portal_pos;
	aData.cam_pos = _cam_pos;

	CreatePortal(aData);
	iChapter01_Save_Portals.push([aData, iChapter01_Save_Portals.len()]);
}

::Portal_Init_CH01a_Quest_Zombie <- function()
{
	local aData;
	local _portal_pos;
	local _cam_pos;

	_portal_pos = class_pos(Vector(1393, -677, -160), Vector(0, -1, 0));
	_cam_pos = class_pos(Vector(1547, -782, -47), Vector(20, 100, 0));

	aData = {portal_pos = null, cam_pos = null, allow_berserk = true, allow_vulture = true, allow_tank = true, disable = true, limited = true, limit_count = 10, limit_cd = 15.0, kv_hitbox = {}, kv_trigger = {}, kv_model = {}};

	aData.portal_pos = _portal_pos;
	aData.cam_pos = _cam_pos;

	CreatePortal(aData);
	TEMP_PORTAL.Enable();

	aData  = {portal_pos = null, cam_pos = null, allow_berserk = true, allow_vulture = true, allow_tank = true, disable = false, limited = true, limit_count = 10, limit_cd = 15.0, kv_hitbox = {}, kv_trigger = {}, kv_model = {}};
	aData.portal_pos = _portal_pos;
	aData.cam_pos = _cam_pos;

	iChapter01_Save_Portals.push([aData, iChapter01_Save_Portals.len()]);
}

::Portal_Init_CH01b_Quest_Zombie <- function()
{
	local aData;
	local _portal_pos;
	local _cam_pos;

	_portal_pos = class_pos(Vector(1670, -206, 1686), Vector(0, -1, 0));
	_cam_pos = class_pos(Vector(1709, 138, 1977), Vector(17, -67, 0));

	aData = {portal_pos = null, cam_pos = null, allow_berserk = true, allow_vulture = true, allow_tank = true, disable = true, limited = true, limit_count = 10, limit_cd = 15.0, kv_hitbox = {}, kv_trigger = {}, kv_model = {}};

	aData.portal_pos = _portal_pos;
	aData.cam_pos = _cam_pos;

	CreatePortal(aData);
	TEMP_PORTAL.Enable();

	aData  = {portal_pos = null, cam_pos = null, allow_berserk = true, allow_vulture = true, allow_tank = true, disable = false, limited = true, limit_count = 10, limit_cd = 15.0, kv_hitbox = {}, kv_trigger = {}, kv_model = {}};
	aData.portal_pos = _portal_pos;
	aData.cam_pos = _cam_pos;

	iChapter01_Save_Portals.push([aData, iChapter01_Save_Portals.len()]);
}

::Portal_Init_CH02a_Quest_Zombie <- function()
{
	local aData;
	local _portal_pos;
	local _cam_pos;

	_portal_pos = class_pos(Vector(5493, 610, -184), Vector(-1, 0, 0));
	_cam_pos = class_pos(Vector(4734, 110, 107), Vector(22, 17, 0));

	aData = {portal_pos = null, cam_pos = null, allow_berserk = true, allow_vulture = true, allow_tank = true, disable = true, limited = true, limit_count = 10, limit_cd = 15.0, kv_hitbox = {}, kv_trigger = {}, kv_model = {}};

	aData.portal_pos = _portal_pos;
	aData.cam_pos = _cam_pos;

	CreatePortal(aData);
	TEMP_PORTAL.Enable();
}

::Portal_Init_CH02b_Quest_Zombie <- function()
{
	local aData;
	local _portal_pos;
	local _cam_pos;

	_portal_pos = class_pos(Vector(4487, -1745, -762), Vector(-1, 0, 0));
	_cam_pos = class_pos(Vector(4590, -2043, -570), Vector(25, 147, 0));

	aData = {portal_pos = null, cam_pos = null, allow_berserk = true, allow_vulture = true, allow_tank = true, disable = false, limited = true, limit_count = 10, limit_cd = 15.0, kv_hitbox = {}, kv_trigger = {}, kv_model = {}};

	aData.portal_pos = _portal_pos;
	aData.cam_pos = _cam_pos;

	CreatePortal(aData);
	TEMP_PORTAL.Enable();
}


::Portal_Init_CH03a_Quest_Zombie <- function()
{
	local aData;
	local _portal_pos;
	local _cam_pos;

	_portal_pos = class_pos(Vector(6501, 985, -184), Vector(0, -1, 0));
	_cam_pos = class_pos(Vector(6997, 1119, 49), Vector(40, -134, 0));

	aData = {portal_pos = null, cam_pos = null, allow_berserk = true, allow_vulture = true, allow_tank = true, disable = true, limited = true, limit_count = 10, limit_cd = 15.0, kv_hitbox = {}, kv_trigger = {}, kv_model = {}};

	aData.portal_pos = _portal_pos;
	aData.cam_pos = _cam_pos;

	CreatePortal(aData);
	TEMP_PORTAL.Enable();
}


::Portal_Init_CH01_Quest01 <- function()
{
	local aData;
	local _portal_pos;
	local _cam_pos;

	if (RandomInt(0, 1))
	{
		_portal_pos = class_pos(Vector(-3072, -3735, -185), Vector(0, -1, 0));
		_cam_pos = class_pos(Vector(-2568, -4048, 81), Vector(16, 115, 0));
	}
	else
	{
		_portal_pos = class_pos(Vector(-2303, -4698, -187), Vector(0, 1, 0));
		_cam_pos = class_pos(Vector(-2679, -5035, 150), Vector(31, 65, 0));
	}

	aData = {portal_pos = null, cam_pos = null, allow_berserk = true, allow_vulture = true, allow_tank = true, disable = true, limited = true, limit_count = 5, limit_cd = 15.0, kv_hitbox = {}, kv_trigger = {}, kv_model = {}};

	aData.portal_pos = _portal_pos;
	aData.cam_pos = _cam_pos;

	CreatePortal(aData);
	TEMP_PORTAL.Enable();
	aData = {portal_pos = null, cam_pos = null, allow_berserk = true, allow_vulture = true, allow_tank = true, disable = false, limited = true, limit_count = 5, limit_cd = 15.0, kv_hitbox = {}, kv_trigger = {}, kv_model = {}};
	aData.portal_pos = _portal_pos;
	aData.cam_pos = _cam_pos;

	iChapter01_Save_Portals.push([aData, iChapter01_Save_Portals.len()]);

	if (RandomInt(0, 1))
	{
		_portal_pos = class_pos(Vector(-256, -3273, -187), Vector(0, -1, 0));
		_cam_pos = class_pos(Vector(69, -3567, 81), Vector(15, 108, 0));
	}
	else
	{
		_portal_pos = class_pos(Vector(768, -4473, -187), Vector(0, 1, 0));
		_cam_pos = class_pos(Vector(33, -4516, 161), Vector(13, 39, 0));
	}

	aData = {portal_pos = null, cam_pos = null, allow_berserk = true, allow_vulture = true, allow_tank = true, disable = true, limited = true, limit_count = 5, limit_cd = 15.0, kv_hitbox = {}, kv_trigger = {}, kv_model = {}};

	aData.portal_pos = _portal_pos;
	aData.cam_pos = _cam_pos;

	CreatePortal(aData);
	TEMP_PORTAL.Enable();
	aData  = {portal_pos = null, cam_pos = null, allow_berserk = true, allow_vulture = true, allow_tank = true, disable = false, limited = true, limit_count = 5, limit_cd = 15.0, kv_hitbox = {}, kv_trigger = {}, kv_model = {}};
	aData.portal_pos = _portal_pos;
	aData.cam_pos = _cam_pos;

	iChapter01_Save_Portals.push([aData, iChapter01_Save_Portals.len()]);

	if (RandomInt(0, 1))
	{
		_portal_pos = class_pos(Vector(2873, -5147, -187), Vector(1, 0, 0));
		_cam_pos = class_pos(Vector(2537, -5023, 180), Vector(31, 23, 0));
	}
	else
	{
		_portal_pos = class_pos(Vector(4871, -4225, -189), Vector(1, 0, 0));
		_cam_pos = class_pos(Vector(4991, -3694, 189), Vector(23, -147, 0));
	}

	aData = {portal_pos = null, cam_pos = null, allow_berserk = true, allow_vulture = true, allow_tank = true, disable = true, limited = true, limit_count = 5, limit_cd = 15.0, kv_hitbox = {}, kv_trigger = {}, kv_model = {}};

	aData.portal_pos = _portal_pos;
	aData.cam_pos = _cam_pos;

	CreatePortal(aData);
	TEMP_PORTAL.Enable();
	aData  = {portal_pos = null, cam_pos = null, allow_berserk = true, allow_vulture = true, allow_tank = true, disable = false, limited = true, limit_count = 5, limit_cd = 15.0, kv_hitbox = {}, kv_trigger = {}, kv_model = {}};
	aData.portal_pos = _portal_pos;
	aData.cam_pos = _cam_pos;

	iChapter01_Save_Portals.push([aData, iChapter01_Save_Portals.len()]);

	if (RandomInt(0, 1))
	{
		_portal_pos = class_pos(Vector(-2041, -359, -186), Vector(0, -1, 0));
		_cam_pos = class_pos(Vector(-1806, 15, 94), Vector(22, -148, 0));
	}
	else
	{
		_portal_pos = class_pos(Vector(-3610, 18, -189), Vector(1, 0, 0));
		_cam_pos = class_pos(Vector(-4057, 204, 193), Vector(35, 29, 0));
	}

	aData = {portal_pos = null, cam_pos = null, allow_berserk = true, allow_vulture = true, allow_tank = true, disable = true, limited = true, limit_count = 5, limit_cd = 15.0, kv_hitbox = {}, kv_trigger = {}, kv_model = {}};

	aData.portal_pos = _portal_pos;
	aData.cam_pos = _cam_pos;

	CreatePortal(aData);
	TEMP_PORTAL.Enable();
	aData  = {portal_pos = null, cam_pos = null, allow_berserk = true, allow_vulture = true, allow_tank = true, disable = false, limited = true, limit_count = 5, limit_cd = 15.0, kv_hitbox = {}, kv_trigger = {}, kv_model = {}};
	aData.portal_pos = _portal_pos;
	aData.cam_pos = _cam_pos;

	iChapter01_Save_Portals.push([aData, iChapter01_Save_Portals.len()]);

	if (RandomInt(0, 1))
	{
		_portal_pos = class_pos(Vector(-513, 2489, -187), Vector(0, -1, 0));
		_cam_pos = class_pos(Vector(-422, 2684, -8), Vector(22, -73, 0));
	}
	else
	{
		_portal_pos = class_pos(Vector(-663, 961, -187), Vector(-1, 0 0));
		_cam_pos = class_pos(Vector(-821, 918, -20), Vector(24, -26, 0));
	}

	aData = {portal_pos = null, cam_pos = null, allow_berserk = true, allow_vulture = true, allow_tank = true, disable = true, limited = true, limit_count = 5, limit_cd = 15.0, kv_hitbox = {}, kv_trigger = {}, kv_model = {}};

	aData.portal_pos = _portal_pos;
	aData.cam_pos = _cam_pos;

	CreatePortal(aData);
	TEMP_PORTAL.Enable();
	aData  = {portal_pos = null, cam_pos = null, allow_berserk = true, allow_vulture = true, allow_tank = true, disable = false, limited = true, limit_count = 5, limit_cd = 15.0, kv_hitbox = {}, kv_trigger = {}, kv_model = {}};
	aData.portal_pos = _portal_pos;
	aData.cam_pos = _cam_pos;

	iChapter01_Save_Portals.push([aData, iChapter01_Save_Portals.len()]);

	_portal_pos = class_pos(Vector(4703, -570, -187), Vector(1, 0, 0));
	_cam_pos = class_pos(Vector(4877, -103, 15), Vector(4, -140, 0));

	aData = {portal_pos = null, cam_pos = null, allow_berserk = true, allow_vulture = true, allow_tank = true, disable = true, limited = true, limit_count = 5, limit_cd = 15.0, kv_hitbox = {}, kv_trigger = {}, kv_model = {}};

	aData.portal_pos = _portal_pos;
	aData.cam_pos = _cam_pos;

	CreatePortal(aData);
	TEMP_PORTAL.Enable();
	aData  = {portal_pos = null, cam_pos = null, allow_berserk = true, allow_vulture = true, allow_tank = true, disable = false, limited = true, limit_count = 5, limit_cd = 15.0, kv_hitbox = {}, kv_trigger = {}, kv_model = {}};
	aData.portal_pos = _portal_pos;
	aData.cam_pos = _cam_pos;

	iChapter01_Save_Portals.push([aData, iChapter01_Save_Portals.len()]);

	_portal_pos = class_pos(Vector(1714, -2816, -186), Vector(1, 0, 0));
	_cam_pos = class_pos(Vector(1932, -2789, 22), Vector(23, 155, 0));

	aData = {portal_pos = null, cam_pos = null, allow_berserk = true, allow_vulture = true, allow_tank = true, disable = true, limited = true, limit_count = 5, limit_cd = 15.0, kv_hitbox = {}, kv_trigger = {}, kv_model = {}};

	aData.portal_pos = _portal_pos;
	aData.cam_pos = _cam_pos;

	CreatePortal(aData);
	TEMP_PORTAL.Enable();
	aData  = {portal_pos = null, cam_pos = null, allow_berserk = true, allow_vulture = true, allow_tank = true, disable = false, limited = true, limit_count = 5, limit_cd = 15.0, kv_hitbox = {}, kv_trigger = {}, kv_model = {}};
	aData.portal_pos = _portal_pos;
	aData.cam_pos = _cam_pos;

	iChapter01_Save_Portals.push([aData, iChapter01_Save_Portals.len()]);
}

::Portal_Init_CH01_Quest04 <- function()
{
	local aData;
	local _portal_pos;
	local _cam_pos;

	_portal_pos = class_pos(Vector(1504, 611, 124), Vector(1, 0, 0));
	_cam_pos = class_pos(Vector(1923, 812, 95), Vector(-40, -127, 0));

	aData = {portal_pos = null, cam_pos = null, allow_berserk = true, allow_vulture = true, allow_tank = true, disable = true, limited = false, limit_count = -1, limit_cd = -1.0, kv_hitbox = null, kv_trigger = {}, kv_model = {}};

	aData.portal_pos = _portal_pos;
	aData.cam_pos = _cam_pos;

	CreatePortal(aData);
	TEMP_PORTAL.Enable();
	aData = {portal_pos = null, cam_pos = null, allow_berserk = true, allow_vulture = true, allow_tank = true, disable = false, limited = true, limit_count = 5, limit_cd = 15.0, kv_hitbox = {}, kv_trigger = {}, kv_model = {}};
	aData.portal_pos = _portal_pos;
	aData.cam_pos = _cam_pos;

	iChapter01_Save_Portals.push([aData, iChapter01_Save_Portals.len()]);

	_portal_pos = class_pos(Vector(1776, 2159, 1517), Vector(0, 1, 0));
	_cam_pos = class_pos(Vector(1367, 2577, 1778), Vector(8, -64, 0));

	aData = {portal_pos = null, cam_pos = null, allow_berserk = false, allow_vulture = true, allow_tank = false, disable = true, limited = false, limit_count = -1, limit_cd = -1.0, kv_hitbox = null, kv_trigger = {}, kv_model = {}};

	aData.portal_pos = _portal_pos;
	aData.cam_pos = _cam_pos;

	CreatePortal(aData);
	TEMP_PORTAL.Enable();
	aData  = {portal_pos = null, cam_pos = null, allow_berserk = false, allow_vulture = true, allow_tank = false, disable = false, limited = true, limit_count = 5, limit_cd = 15.0, kv_hitbox = {}, kv_trigger = {}, kv_model = {}};
	aData.portal_pos = _portal_pos;
	aData.cam_pos = _cam_pos;

	iChapter01_Save_Portals.push([aData, iChapter01_Save_Portals.len()]);
}

::Portal_Init_CH02 <- function()
{
	local aData;
	local _portal_pos;
	local _cam_pos;

	_portal_pos = class_pos(Vector(2756, 2435, -187), Vector(0, -1, 0));
	_cam_pos = class_pos(Vector(2998, 2761, 72), Vector(16, -92, 0));

	aData = {portal_pos = null, cam_pos = null, allow_berserk = true, allow_vulture = true, allow_tank = true, disable = false, limited = false, limit_count = -1, limit_cd = -1.0, kv_hitbox = null, kv_trigger = {}, kv_model = {}};

	aData.portal_pos = _portal_pos;
	aData.cam_pos = _cam_pos;

	CreatePortal(aData);
}

::Portal_Init_CH02_Quest01 <- function()
{
	local aData;
	local _portal_pos;
	local _cam_pos;

	_portal_pos = class_pos(Vector(642, -2222, -664), Vector(0, 1, 0));
	_cam_pos = class_pos(Vector(143, -2176, -587), Vector(18, 5, 0));

	aData = {portal_pos = null, cam_pos = null, allow_berserk = true, allow_vulture = false, allow_tank = true, disable = false, limited = true, limit_count = 5, limit_cd = -1.0, kv_hitbox = null, kv_trigger = {}, kv_model = {}};

	aData.portal_pos = _portal_pos;
	aData.cam_pos = _cam_pos;

	CreatePortal(aData);
	PORTALS_CH02_QUEST01.push(TEMP_PORTAL);

	_portal_pos = class_pos(Vector(341, -2769, -924), Vector(1, 0, 0));
	_cam_pos = class_pos(Vector(506, -2745, -787), Vector(12, 141, 0));

	aData = {portal_pos = null, cam_pos = null, allow_berserk = true, allow_vulture = false, allow_tank = true, disable = false, limited = true, limit_count = 8, limit_cd = 15.0, kv_hitbox = {}, kv_trigger = {}, kv_model = {}};

	aData.portal_pos = _portal_pos;
	aData.cam_pos = _cam_pos;

	CreatePortal(aData);
	PORTALS_CH02_QUEST01.push(TEMP_PORTAL);

	_portal_pos = class_pos(Vector(929, -1362, -923), Vector(0, -1, 0));
	_cam_pos = class_pos(Vector(1142, -1383, -791), Vector(15, -134, 0));

	aData = {portal_pos = null, cam_pos = null, allow_berserk = true, allow_vulture = false, allow_tank = true, disable = false, limited = true, limit_count = 8, limit_cd = 15.0, kv_hitbox = {}, kv_trigger = {}, kv_model = {}};

	aData.portal_pos = _portal_pos;
	aData.cam_pos = _cam_pos;

	CreatePortal(aData);
	PORTALS_CH02_QUEST01.push(TEMP_PORTAL);

	cp02_quest_01.Init();
}

::Portal_Init_CH01_Save <- function()
{
	if (iChapter01_Save_Portals.len() < 1)
	{
		return;
	}

	foreach (saveportal in iChapter01_Save_Portals)
	{
		CreatePortal(saveportal[0]);
	}

	Portal_Init_CH01_CH02();
}

::Portal_Init_CH01_CH02 <- function()
{
	foreach (portal in PORTALS)
	{
		if (IsVectorInBoundingBox(portal.GetSelfOrigin(), Vector(-2050, -1294, 447), Vector(2318, 3989, 700)))
		{
			portal.Death(false);
		}
	}

	TEMP_PORTALS = GetPortalsNearVector(Vector(2866, -1062, -147), 2500);
	if (TEMP_PORTALS == null)
	{
		return;
	}
	foreach (portal in TEMP_PORTALS)
	{
		portal.Disable();
	}
}

::Portal_PostInitCH02 <- function()
{
	if (TEMP_PORTALS == null)
	{
		return;
	}
	foreach (portal in TEMP_PORTALS)
	{
		portal.Enable();
	}
}

::Portal_Init_CH03 <- function()
{
	local _portal_pos;
	local _cam_pos;
	local aData;

	_portal_pos = class_pos(Vector(10624, -1679, 292), Vector(1, 0, 0));
	_cam_pos = class_pos(Vector(10773, -871, 387), Vector(21, -130, 0));

	aData = {portal_pos = null, cam_pos = null, allow_berserk = true, allow_vulture = true, allow_tank = true, disable = false, limited = false, limit_count = -1, limit_cd = -1.0, kv_hitbox = null, kv_trigger = {}, kv_model = {}};

	aData.portal_pos = _portal_pos;
	aData.cam_pos = _cam_pos;

	CreatePortal(aData);

	_portal_pos = class_pos(Vector(5709, -2066, -188), Vector(0, -1, 0));
	_cam_pos = class_pos(Vector(6558, -2867, 259), Vector(19, 138, 0));

	aData = {portal_pos = null, cam_pos = null, allow_berserk = true, allow_vulture = true, allow_tank = true, disable = false, limited = true, limit_count = 5, limit_cd = 15.0, kv_hitbox = {}, kv_trigger = {}, kv_model = {}};

	aData.portal_pos = _portal_pos;
	aData.cam_pos = _cam_pos;

	CreatePortal(aData);

	_portal_pos = class_pos(Vector(8562, -1340, -187), Vector(1, 0, 0));
	_cam_pos = class_pos(Vector(9001, -1177, 153), Vector(22, 162, 0));

	aData = {portal_pos = null, cam_pos = null, allow_berserk = true, allow_vulture = true, allow_tank = true, disable = false, limited = true, limit_count = 5, limit_cd = 15.0, kv_hitbox = {}, kv_trigger = {}, kv_model = {}};

	aData.portal_pos = _portal_pos;
	aData.cam_pos = _cam_pos;

	CreatePortal(aData);

	_portal_pos = class_pos(Vector(9703, -2220, -187), Vector(0, 1, 0));
	_cam_pos = class_pos(Vector(9017, -2681, 29), Vector(22, 44, 0));

	aData = {portal_pos = null, cam_pos = null, allow_berserk = true, allow_vulture = true, allow_tank = true, disable = false, limited = true, limit_count = 5, limit_cd = 15.0, kv_hitbox = {}, kv_trigger = {}, kv_model = {}};

	aData.portal_pos = _portal_pos;
	aData.cam_pos = _cam_pos;

	CreatePortal(aData);

	_portal_pos = class_pos(Vector(7378, -2145, -188), Vector(-1, 0, 0));
	_cam_pos = class_pos(Vector(7565, -2205, 100), Vector(24, -150, 0));

	aData = {portal_pos = null, cam_pos = null, allow_berserk = true, allow_vulture = true, allow_tank = true, disable = false, limited = true, limit_count = 5, limit_cd = 15.0, kv_hitbox = {}, kv_trigger = {}, kv_model = {}};

	aData.portal_pos = _portal_pos;
	aData.cam_pos = _cam_pos;

	CreatePortal(aData);

	_portal_pos = class_pos(Vector(9884, -4357, -31), Vector(1, 0, 0));
	_cam_pos = class_pos(Vector(10254, -3927, 166), Vector(14, -160, 0));

	aData = {portal_pos = null, cam_pos = null, allow_berserk = true, allow_vulture = true, allow_tank = true, disable = false, limited = true, limit_count = 5, limit_cd = 15.0, kv_hitbox = {}, kv_trigger = {}, kv_model = {}};

	aData.portal_pos = _portal_pos;
	aData.cam_pos = _cam_pos;

	CreatePortal(aData);
}

::Portal_Init_CH03a <- function()
{
	local aData;
	local _portal_pos = class_pos(Vector(6800, -5208, 512), Vector(1, 0, 0));
	local _cam_pos = class_pos(Vector(5965, -4421, 1176), Vector(39, -15, 0));

	aData = {portal_pos = null, cam_pos = null, allow_berserk = true, allow_vulture = false, allow_tank = true, disable = false, limited = true, limit_count = 5, limit_cd = 15.0, kv_hitbox = {}, kv_trigger = {}, kv_model = {}};

	aData.portal_pos = _portal_pos;
	aData.cam_pos = _cam_pos;

	CreatePortal(aData);
}

::Portal_InitCH02_CH03 <- function()
{
	foreach (portal in PORTALS)
	{
		if (IsVectorInBoundingBox(portal.GetSelfOrigin(), Vector(110, -1184, 922 ), Vector(5552, 3911, 1974)))
		{
			portal.Death(false);
		}
	}

	foreach (portal_maker in PORTALS_MAKER)
	{
		portal_maker.Destroy();
	}
}

//PORTAL_DATA
{
	const TICKRATE_PORTAL_LIMIT = 1.0;
	::g_TickRate_PORTAL_LIMIT <- 0.00;

	const PORTAL_PICK_TIME = 20.0;

	const PICK_TICKRATE_INFO = 0.9;
	g_t_PICK_TickRate_INFO <- 0;

	::PORTALING_POS <- Vector();
	::PORTALING_DELAY <- 2.0;

	::PORTALS <- [];
	::TEMP_PORTAL <- null;
	::TEMP_PORTALS <- null;

	::PORTAL_KV_TRIGGER <- {};
	::PORTAL_KV_TRIGGERHURT <- {};
	::PORTAL_KV_HITBOX <- {};
	::PORTAL_KV_MODEL <- {};

	::PORTAL_TELEPORT_BLOCK <- [];

	const PORTAL_TELEPORT_DISTANCE_Z = 35;
	const PORTAL_TELEPORT_DISTANCE = 75;
	const PORTAL_BLOCK_DELAY = 5.0;

	::CreatePortal <- function(aData)
	{
		TEMP_PORTAL = class_zombie_portal(aData);

		AOP(Entity_Maker, "EntityTemplate", "portal");

		PORTAL_KV_TRIGGERHURT = {};
		if (aData.disable)
		{
			if (aData.kv_trigger != null)
			{
				aData.kv_trigger["StartDisabled"] <- 1;
				PORTAL_KV_TRIGGERHURT["StartDisabled"] <- 1;
			}
			if (aData.kv_model != null)
			{
				aData.kv_model["StartDisabled"] <- 1;
				aData.kv_model["glowenabled"] <- 0;
			}
		}

		if (aData.kv_hitbox == null)
		{
			if (aData.kv_model != null)
			{
				aData.kv_model["glowcolor"] <- Vector(255, 128, 0);
			}
		}

		PORTAL_KV_TRIGGER = aData.kv_trigger;
		PORTAL_KV_HITBOX = aData.kv_hitbox;
		PORTAL_KV_MODEL = aData.kv_model;

		Entity_Maker.SetOrigin(aData.portal_pos.origin);
		Entity_Maker.SetForwardVector(aData.portal_pos.angles);
		Entity_Maker.SpawnEntity();

		PORTALS.push(TEMP_PORTAL);

		if (PORTALS[0].IsPlug())
		{
			PORTALS.remove(0);
			UpdatePortals(0);
		}
	}

	::class_zombie_portal <- class
	{
		// id = 0;
		cam_pos = null;
		player_pos = null;

		hp = 7000;
		last_hp = 100;

		limited = false;
		limit_count = -1;
		limit_count_max = -1;
		limit_time = 0;
		limit_cd = 20;

		hitbox_origin = Vector();

		teleport_block_users = null;
		teleport_block_time = null;

		allow_berserk = true;
		allow_vulture = true;
		allow_tank = true;

		disable = false;

		plug = false;

		dead = false;

		hitbox = null;
		model = null;
		trigger = null;
		hurttrigger = null;

		script = null;

		constructor(_Data = null)
		{
			this.cam_pos = _Data.cam_pos;
			this.disable = _Data.disable;

			this.allow_berserk = _Data.allow_berserk;
			this.allow_vulture = _Data.allow_vulture;
			this.allow_tank = _Data.allow_tank;

			this.limited = _Data.limited;
			if (this.limited)
			{
				this.limit_count = _Data.limit_count;
				this.limit_count_max = this.limit_count;
				this.limit_cd = _Data.limit_cd;
			}

			// this.id = PORTALS_ID++;
		}

		function SetLimit(_count, _cd)
		{
			this.limited = true;
			this.limit_count = _count;
			this.limit_count_max = this.limit_count;
			this.limit_cd = _cd;
		}

		function SetScript(_script)
		{
			this.script = _script;
		}

		function GetCamPos()
		{
			return this.cam_pos;
		}

		function Valid(player_class = null)
		{
			if (this.dead ||
			this.disable/*)*/ ||
			(!this.allow_berserk && (player_class == Enum_ZOMBIE_CLASS.BERSERK)) ||
			(!this.allow_vulture && (player_class == Enum_ZOMBIE_CLASS.VULTURE)) ||
			(!this.allow_tank && (player_class == Enum_ZOMBIE_CLASS.TANK)) ||
			(this.limited && this.limit_count < 1))//*/
			{
				return false;
			}
			return true;
		}

		function SetPlug()
		{
			this.plug = true;
		}

		function IsPlug()
		{
			return this.plug;
		}

		function SetAllowVulture(_allow)
		{
			this.allow_vulture = _allow;
		}

		function UseTeleport_Pre()
		{
			if (!this.limited)
			{
				return;
			}

			if (this.script != null)
			{
				this.script.UseTeleport_Pre();
			}

			this.limit_count--;
			if (this.limit_count < 1)
			{
				this.limit_count = 0;
				this.limit_time = Time() + this.limit_cd;
			}
		}

		function Enable()
		{
			if (!this.disable ||
			this.dead)
			{
				return;
			}

			this.disable = false;

			if (this.hitbox != null)
			{
				this.hitbox.SetOrigin(this.hitbox_origin);
			}
			if (this.trigger != null)
			{
				EF(this.trigger, "Enable");
			}
			if (this.hurttrigger != null)
			{
				EF(this.hurttrigger, "Enable");
			}
			EF(this.model, "Enable");
			EF(this.model, "SetGlowEnabled");

			local iAlpha = 0;
			local fTime = 0.0;

			local iAlpha_add = 17;
			local fTime_add = 0.075;
			for (local i = 0; i < 15; i++)
			{
				iAlpha += iAlpha_add;
				EF(this.model, "Alpha", "" + iAlpha.tointeger(), fTime);
				fTime += fTime_add;
			}
		}

		function Disable()
		{
			if (this.disable ||
			this.dead)
			{
				return;
			}

			this.disable = true;

			if (this.hitbox != null)
			{
				this.hitbox.SetOrigin(g_vecVpizde);
			}
			if (this.trigger != null)
			{
				EF(this.trigger, "Disable");
			}
			if (this.hurttrigger != null)
			{
				EF(this.hurttrigger, "Disable");
			}
			EF(this.model, "SetGlowDisabled");

			local iAlpha = 255;
			local fTime = 0.0;

			local iAlpha_add = 17;
			local fTime_add = 0.075;
			for (local i = 0; i < 15; i++)
			{
				iAlpha -= iAlpha_add;
				EF(this.model, "Alpha", "" + iAlpha.tointeger(), fTime);
				fTime += fTime_add;
			}
			EF(this.model, "Disable", "", fTime);
			// EntFireByHandle(handle,"AddOutput","renderamt 0",0.00,null,null);
			// local ii = 0.00;
			// for(local alpha=0;alpha<255;alpha+=::SPAWNFADE_ALPHA_ADD){
			// 	EntFireByHandle(handle,"AddOutput","renderamt "+alpha.tostring(),ii,null,null);
			// 	ii += ::SPAWNFADE_ALPHA_TADD;}
			// EntFireByHandle(handle,"AddOutput","renderamt 255",ii,null,null);
			RemovePortal(GetPortalIndexByPortalClass(this));
		}

		function SetHitBox(hitbox)
		{
			this.hitbox = hitbox;
			this.hitbox_origin = this.hitbox.GetOrigin();

			if (this.disable)
			{
				this.hitbox.SetOrigin(g_vecVpizde);
			}

			this.last_hp = this.hitbox.GetHealth();
		}

		function SetModel(model)
		{
			this.model = model;
			if (this.disable)
			{
				EF(this.model, "Alpha", "0");
			}
		}

		function SetTriggerHurt(trigger)
		{
			this.hurttrigger = trigger;
		}

		function SetTrigger(trigger)
		{
			this.trigger = trigger;

			local dir = vinv(this.trigger.GetForwardVector().Cross(Vector(0, 0, 1)));
			local dirZ = this.trigger.GetForwardVector().Cross(this.trigger.GetForwardVector().Cross(Vector(0, 0, 1)));

			this.player_pos = class_pos(this.trigger.GetOrigin() + dir * PORTAL_TELEPORT_DISTANCE + dirZ * PORTAL_TELEPORT_DISTANCE_Z, dir);
		}

		function GetSelfOrigin()
		{
			return this.player_pos.origin;
		}

		function GetPlayerPos()
		{
			if (this.script != null)
			{
				this.script.UseTeleport();
			}
			return this.player_pos;
		}

		function Damage(activator = null)
		{
			if (this.dead)
			{
				return;
			}

			local idamage = this.last_hp - this.hitbox.GetHealth();
			this.last_hp = this.hitbox.GetHealth();

			this.hp -= idamage.tointeger();

			if (this.hp < 1)
			{
				this.Death(true);
			}
		}

		function Death(fade = true)
		{
			if (this.dead)
			{
				return;
			}

			this.dead = true;

			if (this.hitbox != null)
			{
				EF(this.hitbox, "Kill");
			}
			if (this.trigger != null)
			{
				EF(this.trigger, "Kill");
			}
			if (this.hurttrigger != null)
			{
				EF(this.hurttrigger, "Kill");
			}

			local fTime = 0.0;
			if (fade)
			{
				EF(this.model, "SetGlowDisabled");

				local iAlpha = 255;

				local iAlpha_add = 17;
				local fTime_add = 0.075;
				for (local i = 0; i < 15; i++)
				{
					iAlpha -= iAlpha_add;
					EF(this.model, "Alpha", "" + iAlpha.tointeger(), fTime);
					fTime += fTime_add;
				}
			}
			EF(this.model, "Kill", "", fTime);

			RemovePortal(GetPortalIndexByPortalClass(this));
		}

		function Tick_Limit()
		{
			if (Time() < this.limit_time ||
			this.limit_count > 0)
			{
				return;
			}
			this.limit_count = this.limit_count_max;
		}

		function IsDead()
		{
			return this.dead;
		}

		function isLimited()
		{
			return this.limited;
		}
	}

	function Hook_TouchTrigger()
	{
		local portal_class = GetPortalClassByTrigger(caller);
		if (portal_class == null)
		{
			return;
		}

		foreach (i, user in PORTAL_TELEPORT_BLOCK)
		{
			if (activator != user[0])
			{
				continue;
			}

			if (user[1] > Time())
			{
				return;
			}
			break;
		}

		local portalindex = GetPortalIndexByTrigger(caller);
		CreatePortalPicker(activator, portalindex);
	}

	::IsBlockPortalTeleport <- function(activator)
	{
		local index = -1;
		foreach (i, user in PORTAL_TELEPORT_BLOCK)
		{
			if (activator != user[0])
			{
				continue;
			}

			if (user[1] > Time())
			{
				return false;
			}
			index = i;
			break;
		}

		if (index != -1)
		{
			PORTAL_TELEPORT_BLOCK[index][1] = Time() + PORTAL_BLOCK_DELAY;
		}
		else
		{
			PORTAL_TELEPORT_BLOCK.push([activator, Time() + PORTAL_BLOCK_DELAY]);
		}
		return true;
	}

	::GetPortalsNearVector <- function(vec, radius)
	{
		local array = [];
		foreach (ID, portal in PORTALS)
		{
			if (!portal.Valid())
			{
				continue;
			}
			if (GetDistance3D(vec, portal.GetSelfOrigin()) > radius)
			{
				continue;
			}
			array.push(portal);
		}

		if (array.len() < 1)
		{
			return null;
		}

		return array;
	}

	::UpdatePortals <- function(ID = -1, remove = false)
	{
		foreach (picker_class in PORTAL_PICKERS)
		{
			if (remove || picker_class.GetID() == ID)
			{
				if (picker_class.IsPortaling())
				{
					if (picker_class.IsIniting())
					{
						picker_class.IDminus();
						continue;
					}
					picker_class.SetPortaling(false);
				}
				picker_class.Press_A_Post();
			}
		}
	}

	::RemovePortal <- function(ID)
	{
		UpdatePortals(ID);

		if (iChapter == 1)
		{
			foreach (index, portal in iChapter01_Save_Portals)
			{
				if (portal[1] == ID)
				{
					iChapter01_Save_Portals.remove(index);
					return;
				}
			}
		}
	}

	::ZombieToTeleport <- function()
	{
		local picker_class;
		foreach (player in PLAYERS)
		{
			if (!TargetValid(player))
			{
				continue;
			}

			if (player.GetTeam() != 2 ||
			player.GetHealth() < 1)
			{
				continue;
			}

			picker_class = GetPortalPickerClassByOwner(player);
			if (picker_class != null)
			{
				continue;
			}
			CreatePortalPickerClass(player);
		}
	}

	::ZombieToTeleportRadius <- function(v1, radius)
	{
		local picker_class;
		foreach (player in PLAYERS)
		{
			if (!TargetValid(player))
			{
				continue;
			}

			if (player.GetTeam() != 2 ||
			player.GetHealth() < 1)
			{
				continue;
			}

			picker_class = GetPortalPickerClassByOwner(player);
			if (picker_class != null)
			{
				continue;
			}

			if (!IsVectorInSphere(v1, radius, player.GetOrigin()))
			{
				continue;
			}



			CreatePortalPickerClass(player);
		}
	}



	::Tick_Portals <- function()
	{
		// UPDATE ABILITY
		local bUpdatePortal = false;

		if (Time() > g_TickRate_PORTAL_LIMIT)
		{
			g_TickRate_PORTAL_LIMIT = Time() + TICKRATE_PORTAL_LIMIT;
			bUpdatePortal = true;
		}

		foreach (portal in PORTALS)
		{
			if (portal.IsDead() &&
			!portal.isLimited())
			{
				continue;
			}

			if (bUpdatePortal)
			{
				portal.Tick_Limit();
			}
		}
	}

	function Hook_TakeDamage()
	{
		local portal_class = GetPortalClassByHitBox(caller);
		if (portal_class == null)
		{
			return;
		}
		portal_class.Damage(activator);
	}

	function GetPortalClassByHitBox(hitbox)
	{
		foreach (portal in PORTALS)
		{
			if (hitbox == portal.hitbox)
			{
				return portal;
			}
		}

		return null;
	}

	function GetPortalClassByTrigger(trigger)
	{
		foreach (portal in PORTALS)
		{
			if (trigger == portal.trigger)
			{
				return portal;
			}
		}

		return null;
	}

	function GetPortalIndexByTrigger(trigger)
	{
		foreach (index, portal in PORTALS)
		{
			if (trigger == portal.trigger)
			{
				return index;
			}
		}

		return -1;
	}

	::GetPortalIndexByPortalClass <- function(_portal)
	{
		foreach (index, portal in PORTALS)
		{
			if (_portal == portal)
			{
				return index;
			}
		}

		return -1;
	}

	::GetPortalIndexByPortal<- function(portal)
	{
		foreach (index, _portal in PORTALS)
		{
			if (_portal == portal)
			{
				return index;
			}
		}

		return -1;
	}


	function PreSpawnInstance(szClass, szName)
	{
		if (szClass == "func_physbox_multiplayer")
		{
			return PORTAL_KV_HITBOX;
		}
		else if (szClass == "trigger_multiple")
		{
			return PORTAL_KV_TRIGGER;
		}
		else if (szClass == "trigger_hurt")
		{
			return PORTAL_KV_TRIGGERHURT;
		}
		else if (szClass == "prop_dynamic_glow")
		{
			return PORTAL_KV_MODEL;
		}
	}

	function PostSpawn(entities)
	{
		foreach(handle in entities)
		{
			if (handle.GetClassname() == "func_physbox_multiplayer")
			{
				if (PORTAL_KV_HITBOX == null)
				{
					EF(handle, "Kill");
					continue;
				}
				TEMP_PORTAL.SetHitBox(handle);
			}
			else if (handle.GetClassname() == "trigger_multiple")
			{
				if (PORTAL_KV_TRIGGER == null)
				{
					EF(handle, "Kill");
					continue;
				}
				TEMP_PORTAL.SetTrigger(handle);
			}
			else if (handle.GetClassname() == "trigger_hurt")
			{
				if (PORTAL_KV_TRIGGERHURT == null)
				{
					EF(handle, "Kill");
					continue;
				}
				TEMP_PORTAL.SetTriggerHurt(handle);
			}
			else if (handle.GetClassname() == "prop_dynamic_glow")
			{
				TEMP_PORTAL.SetModel(handle);
			}
		}
	}
}
//PORTAL_PICKERS
{
	const TICKRATE_PORTAL = 0.2;
	::g_TickRate_PORTAL <- 0.00;

	::PORTAL_PICKERS <- [];
	::class_portalpicker <- class
	{
		handle = null;
		camera = null;

		classid = 0;

		szcontroller = "";
		controller_status = false;

		name = null;

		switch_time = 0;
		id = -1;

		destroy = false;

		pick_time = 0;

		portaling = false;
		portaling_time = 0;

		init = true;

		constructor(_handle, _name, _classselect, _id = -1)
		{
			this.handle = _handle;
			this.id = _id;
			local zombie_owner_class = GetZombieOwnerClassByOwner(_handle);
			if (zombie_owner_class != null)
			{
				this.classid = zombie_owner_class.GetID();
			}

			this.name = _name;

			this.szcontroller = "select_controller" + this.name;

			this.camera = GetFreeCamera(activator);

			this.pick_time = Time() + PORTAL_PICK_TIME;

			if (_classselect)
			{
				this.Init();
			}
			else
			{
				this.id--;

				this.init = true;

				this.portaling = true;
				this.portaling_time = Time() + PORTALING_DELAY;
				this.camera.SetCameraPos(PORTALING_POS);
			}
		}

		function Init()
		{
			this.IDplus();
			this.init = false;

			EntFire(this.szcontroller, "Activate", "", 0.25, this.handle);

			this.Tick_Display_Info();
			this.UpDate_Cam();
		}

		function Tick_Display_Info()
		{
			if (this.portaling ||
			CUT_SCENE)
			{
				return;
			}
			EntFire("map_entity_text_classpicker", "Display", "", 0, this.handle);
		}

		function Tick_AutoPick()
		{
			if (Time() < this.pick_time)
			{
				return;
			}

			if (this.portaling)
			{
				return;
			}

			this.Press_A1(false);
		}

		function Tick_Portal()
		{
			if (!this.portaling)
			{
				return;
			}

			if (this.portaling_time > Time())
			{
				return;
			}

			this.portaling = false;

			if (this.init)
			{
				this.Init();
				return;
			}

			IsBlockPortalTeleport(this.handle);

			local pos = PORTALS[this.id].GetPlayerPos();
			this.handle.SetOrigin(pos.origin);
			this.handle.SetForwardVector(pos.angles);

			this.destroy = true;
		}

		function UpDate_Cam()
		{
			this.camera.SetCameraPos(PORTALS[this.id].GetCamPos());
		}

		function SetControllerStatus(status)
		{
			this.controller_status = status;
		}

		function IsValid()
		{
			return (this.destroy ||
			!TargetValid(this.handle) ||
			this.handle.GetTeam() != 2 ||
			this.handle.GetHealth() < 1)
		}

		function GetHandle()
		{
			return this.handle;
		}

		function Press_A()
		{
			if (this.switch_time > Time())
			{
				return;
			}

			this.IDminus();
			this.Move();
		}

		function IDminus()
		{
			for (local i = 0; i < 50; i++)
			{
				this.id--;
				if (this.id < 0)
				{
					this.id = PORTALS.len() - 1;
				}

				if (PORTALS[this.id].Valid(this.classid))
				{
					return;
				}
			}

			printl("critical error: no free portals");
			this.id = 0;
		}

		function IDplus()
		{
			for (local i = 0; i < 50; i++)
			{
				this.id++;

				if (this.id > PORTALS.len() - 1)
				{
					this.id = 0;
				}

				if (PORTALS[this.id].Valid(this.classid))
				{
					return;
				}
			}

			printl("critical error: no free portals");
			this.id = 0;
		}

		function Press_D_Post()
		{
			this.IDplus();
			this.Move();
		}

		function Press_A_Post()
		{
			this.IDminus();
			this.Move();
		}

		function Press_D()
		{
			if (this.switch_time > Time())
			{
				return;
			}

			this.Press_D_Post();
		}

		function Press_A1(press_player = true)
		{
			if (!PORTALS[this.id].Valid(this.classid))
			{
				this.Press_A_Post();
				if (press_player)
				{
					return;
				}
			}

			if (PORTALS[this.id].IsPlug())
			{
				this.pick_time = Time() + PORTAL_PICK_TIME;
				return;
			}

			PORTALS[this.id].UseTeleport_Pre();

			this.portaling = true;
			this.portaling_time = Time() + PORTALING_DELAY;
			this.camera.SetCameraPos(PORTALING_POS);

			this.DeactivateController();
		}

		// function RemovePortals()
		// {
		// 	if (this.portaling)
		// 	{
		// 		if (this.init)
		// 		{
		// 			return;
		// 		}
		// 		this.portaling = false;
		// 	}
		// 	this.UpDate_Cam();
		// }

		function SetPortaling(value)
		{
			this.portaling = value;
		}

		function IsPortaling()
		{
			return this.portaling;
		}

		function GetID()
		{
			return this.id;
		}

		function IsIniting()
		{
			return this.init;
		}

		function Move()
		{
			this.switch_time = Time() + 0.25;

			this.Tick_Display_Info();
			this.UpDate_Cam();
		}

		function DeactivateController()
		{
			if (this.controller_status)
			{
				EF(this.szcontroller, "Deactivate");
			}
		}

		function Destroy()
		{
			if (!this.destroy &&
			TargetValid(this.handle))
			{
				this.DeactivateController();
			}

			this.camera.Disable();
			EF(this.szcontroller, "Kill");
		}
	}



	::Tick_PortalPick <- function()
	{
		// UPDATE ABILITY
		local bUpdatePortal = false;

		if (Time() > g_TickRate_PORTAL)
		{
			g_TickRate_PORTAL = Time() + TICKRATE_PORTAL;
			bUpdatePortal = true;
		}

		// UPDATE INFO
		local bUpdateInfo = false;

		if (Time() > g_t_PICK_TickRate_INFO)
		{
			g_t_PICK_TickRate_INFO = Time() + PICK_TICKRATE_INFO;
			bUpdateInfo = true;
		}

		local handle;
		foreach (index, picker in PORTAL_PICKERS)
		{
			if (picker.IsValid())
			{
				picker.Destroy();
				PORTAL_PICKERS.remove(index);
				continue;
			}

			if (CUT_SCENE)
			{
				continue;
			}

			if (bUpdateInfo)
			{
				picker.Tick_Display_Info();
			}

			if (bUpdatePortal)
			{
				picker.Tick_Portal();
			}

			picker.Tick_AutoPick();
		}
	}

	::CreatePortalPicker <- function(activator, ID = 0)
	{
		PRESELECTS.push([activator, Enum_PickerType.PortalPicker, ID]);
		CreateSelect(activator);
	}

	::CreatePortalPickerClass <- function(activator)
	{
		PRESELECTS.push([activator, Enum_PickerType.PortalPickerClass]);
		CreateSelect(activator);
	}

	::GetPortalPickerClassByOwner <- function(owner)
	{
		foreach (picker_class in PORTAL_PICKERS)
		{
			if (owner == picker_class.handle)
			{
				return picker_class;
			}
		}
		return null;
	}
}
//PORTAL_MAKER
{
	::TEMP_PORTAL_MAKER_DATA <- null;

	const PORTAL_MAKER_TICKS = 11;
	const PORTAL_MAKER_RADIUS = 64;

	const TICKRATE_PORTAL_MAKER_TICKS = 1.0;
	::g_TickRate_PORTAL_MAKER_TICKS <- 0.00;

	::PORTALS_MAKER <- [];

	::class_portalmaker <- class
	{
		handle = null;
		model = null;

		origin = Vector();
		users = null;

		destroy = false;
		ticks = 10;

		data = null;

		constructor(_handle)
		{
			this.ticks = PORTAL_MAKER_TICKS;
			this.handle = _handle;
			this.model = this.handle.GetMoveParent();
			this.origin = this.model.GetOrigin();

			this.data = TEMP_PORTAL_MAKER_DATA;
			this.users = [];
		}

		function AddPlayer(_user)
		{
			foreach (user in this.users)
			{
				if (user == _user)
				{
					return;
				}
			}
			this.users.push(_user);
		}

		function Tick()
		{
			if (this.users.len() < 1)
			{
				return;
			}


			local removearray = [];
			foreach (index, user in this.users)
			{
				if (!TargetValid(user) ||
				user.GetTeam() != 2 ||
				user.GetHealth() < 1 ||
				GetDistance3D(user.GetOrigin(), this.origin) > PORTAL_MAKER_RADIUS)
				{
					removearray.push(index);
					continue;
				}
			}

			removearray.reverse();
			foreach (value in removearray)
			{
				this.users.remove(value);
			}

			if (this.users.len() < 1)
			{
				this.ticks = PORTAL_MAKER_TICKS;
				return;
			}

			this.ticks--;
			if (this.ticks <= 0)
			{
				this.Complete();
			}
			else
			{
				EF("map_entity_text_portal", "SetText", Translate["gt_openingportal"] + " " + this.ticks);
				foreach (user in this.users)
				{
					EntFire("map_entity_text_portal", "Display", "", 0, user);
				}
			}
		}

		function Complete()
		{
			EF("map_entity_text_portal", "SetText", Translate["gt_portalopen"]);

			foreach (player in PLAYERS)
			{
				if (!TargetValid(player))
				{
					continue;
				}
				if (player.GetTeam() != 2 ||
				player.GetHealth() < 1)
				{
					continue;
				}

				EntFire("map_entity_text_portal", "Display", "", 0, player);
			}

			this.data.Complete();
			this.Destroy();
		}

		function Valid()
		{
			return this.destroy;
		}

		function Destroy()
		{
			if (this.destroy)
			{
				return;
			}

			this.destroy = true;
			EF(this.model, "FadeAndKill");
		}
	}

	::CreatePortal_Maker <- function(vecOrigin, Data)
	{
		TEMP_PORTAL_MAKER_DATA = Data;
		AOP(Entity_Maker, "EntityTemplate", "portalmaker");
		Entity_Maker.SpawnEntityAtLocation(vecOrigin, Vector());
	}

	::RegPortalMaker <- function()
	{
		PORTALS_MAKER.push(class_portalmaker(caller));
	}

	::Tick_PortalMaker <- function()
	{
		if (PORTALS_MAKER.len() < 1)
		{
			return;
		}

		if (Time() <= g_TickRate_PORTAL_MAKER_TICKS)
		{
			return;
		}

		g_TickRate_PORTAL_MAKER_TICKS = Time() + TICKRATE_PORTAL_MAKER_TICKS;

		local removearray = [];
		foreach (index, portal_maker in PORTALS_MAKER)
		{
			if (portal_maker.Valid())
			{
				removearray.push(index);
				continue;
			}

			portal_maker.Tick();
		}

		removearray.reverse();
		foreach (value in removearray)
		{
			PORTALS_MAKER.remove(value);
		}
	}

	::Hook_PM_Touch <- function()
	{
		local portalmaker_class = GetPortalMakerByTrigger(caller);
		if (portalmaker_class == null)
		{
			return;
		}

		portalmaker_class.AddPlayer(activator);
	}

	::GetPortalMakerByTrigger <- function(_handle)
	{
		foreach (portal_maker in PORTALS_MAKER)
		{
			if (portal_maker.handle == _handle)
			{
				return portal_maker;
			}
		}
		return null;
	}
//
	function Portal_Maker_CH01a()
	{
		local Data = {
			function Complete()
			{
				Portal_Scope.Portal_Init_CH01a_Quest_Zombie();
			},
		}

		CreatePortal_Maker(Vector(1448, -668, -151), Data);
	}

	function Portal_Maker_CH01b()
	{
		local Data = {
			function Complete()
			{
				Portal_Scope.Portal_Init_CH01b_Quest_Zombie()
			},
		}

		CreatePortal_Maker(Vector(1753, -206, 1697), Data);
	}

	function Portal_Maker_CH02a()
	{
		local Data = {
			function Complete()
			{
				Portal_Scope.Portal_Init_CH02a_Quest_Zombie();
			},
		}

		CreatePortal_Maker(Vector(5493, 541, -175), Data);
	}

	function Portal_Maker_CH02b()
	{
		local Data = {
			function Complete()
			{
				Portal_Scope.Portal_Init_CH02b_Quest_Zombie();
			},
		}

		CreatePortal_Maker(Vector(4477, -1805, -751), Data);
	}

	function Portal_Maker_CH03a()
	{
		local Data = {
			function Complete()
			{
				Portal_Scope.Portal_Init_CH03a_Quest_Zombie();
			},
		}

		CreatePortal_Maker(Vector(6571, 981, -175), Data);
	}
}