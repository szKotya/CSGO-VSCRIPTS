// EntityGroup[0] //DETAIL
// EntityGroup[1] //CONTROLLER
// EntityGroup[2] //BRUSH0
// EntityGroup[3] //BRUSH1
// EntityGroup[4] //BRUSH2
// EntityGroup[5] //BRUSH3
// EntityGroup[6] //BRUSH4

const LIMIT_TIME = 15.0;
g_fLimit_Time <- 0;
g_bAddCutScene <- false;

const TICKRATE = 0.05;
g_fTick <- 0.00;

const MOVE_CONNECT_TIME = 0.5;
g_fMove_Time <- 0.00;
g_vecOrigin <- null;

const MOVE_Z_UP_TIME = 0.25;
const MOVE_Z_DOWN_TIME = 0.15;

const MOVE_X_TIME = 0.35;
const MOVE_X_DELAY = 0.2;

const LEVELS = 4;
const LEVEL_Z = 3.75;

const WIN_DELAY = 2.0;

ROTORS <- [];
enum Enum_Status
{
	NONE,
	CONNECT,

	MOVE_X,

	MOVE_Z_DOWN,
	MOVE_Z_UP,

	WIN,
}

g_iStatus <- Enum_Status.NONE;

class class_roter
{
	vecMoverOrigin = null;
	vecSelfOrigin = null;

	handle = null;

	level = 0;
	maxlevel = 0;

	connected = false;

	constructor(_handle, _vecMoverOrigin)
	{
		this.handle = _handle;
		this.vecMoverOrigin = _vecMoverOrigin.slice();

		local vec = this.handle.GetOrigin();
		vec = Vector(vec.x.tointeger(), vec.y.tointeger(), vec.z.tointeger());
		this.vecSelfOrigin = [];

		this.vecSelfOrigin.push(vec);

		this.maxlevel = RandomInt(1, LEVELS);

		for(local i = 0; i < this.maxlevel; i++)
		{
			vec -= Vector(0, 0, LEVEL_Z);
			this.vecSelfOrigin.push(vec);
		}
	}

	function Disconnect()
	{
		this.connected = false;
	}

	function GetMoverStartOrigin()
	{
		return this.vecMoverOrigin[0];
	}

	function SetOrigin(vec)
	{
		this.handle.SetOrigin(vec);
	}

	function GetOrigin()
	{
		return this.handle.GetOrigin();
	}

	function GetSelfOrigin()
	{
		return this.vecSelfOrigin[this.level];
	}

	function IsMaxLevel()
	{
		return (this.level >= this.maxlevel);
	}

	function GetMoverStatus()
	{
		if (!this.connected)
		{
			this.connected = true;
			return 0;
		}

		this.level++;
		if (this.level > this.maxlevel)
		{
			this.level = this.maxlevel;
			return -1;
		}

		return 1;
	}

	function GetVecMoverConnect()
	{
		return this.vecMoverOrigin[this.level + 1];
	}
}

g_bMove_W <- false;
g_bMove_S <- false;
g_bMove_A <- false;
g_bMove_D <- false;

g_hMover <- EntityGroup[6];
g_hController <- EntityGroup[1];
g_hOwner <- null;
g_hOwner_HP <- 0;

g_iSlot_x <- 0;
g_bBlock_x <- false;
g_fBlock_x_Time <- 0.00;

g_iWin <- 0.00;
g_bWin <- false;

g_bEnded <- false;
g_bController_Status <- false;

function Init()
{
	local obj;
	local vecStart = g_hMover.GetOrigin();
	vecStart = Vector(vecStart.x.tointeger(), vecStart.y.tointeger(), vecStart.z.tointeger());

	local vecOrigin;
	local vecArray = [];

	for (local i = 0, y = 0; i < 4; i++)
	{
		vecOrigin = vecStart + Vector(0, 44 * i, 0);
		vecArray.push(vecOrigin);

		vecOrigin -= Vector(0, 0, 3);
		vecArray.push(vecOrigin);

		for (y = 0; y < LEVELS+1; y++)
		{
			vecOrigin -= Vector(0, 0, LEVEL_Z);
			vecArray.push(vecOrigin);
		}

		obj = class_roter(EntityGroup[2 + i], vecArray);
		vecArray.clear();

		ROTORS.push(obj);
	}

	g_fLimit_Time = Time() + LIMIT_TIME;

	g_ahGlobal_Tick.push(self);

	REG_GAME_POST(self);
}

function SetOwner(owner)
{
	g_hOwner = owner;
	g_hOwner_HP = g_hOwner.GetHealth();
	EntFireByHandle(g_hController, "Activate", "", 0.25, g_hOwner, g_hOwner);
}

function Tick()
{
	if (g_fTick > Time())
	{
		return;
	}

	g_fTick = Time() + TICKRATE;

	if (Tick_Owner())
	{
		return;
	}

	EntFire("map_entity_text_puzzle00", "Display", "", 0, g_hOwner);

	if (Enum_Status.MOVE_X == g_iStatus)
	{
		Tick_Move_X();
	}
	else if (Enum_Status.MOVE_Z_UP == g_iStatus)
	{
		Tick_Move_Up();
	}
	else if (Enum_Status.MOVE_Z_DOWN == g_iStatus)
	{
		Tick_Move_Down();
	}
	else if (Enum_Status.CONNECT == g_iStatus)
	{
		Tick_Connect();
	}

	if (g_bWin)
	{
		Tick_Win();
		return;
	}

	Tick_Check_Win();
	if (Enum_Status.NONE == g_iStatus)
	{
		Tick_Controller();
	}

	if (CUT_SCENE)
	{
		if (!g_bAddCutScene)
		{
			g_fLimit_Time += CUT_SCENE_TIME;
			g_bAddCutScene = true;
		}
		return;
	}

	if (Time() > g_fLimit_Time)
	{
		End(Enum_MiniGame_End.LOSE);
	}
}

function Tick_Owner()
{
	if (!TargetValid(g_hOwner) ||
	g_hOwner.GetHealth() < 1 ||
	g_hOwner.GetTeam() != 3)
	{
		if (g_bWin)
		{
			End(Enum_MiniGame_End.WIN);
		}
		else
		{
			End(Enum_MiniGame_End.LOSE);
		}
		return true;
	}

	local handle;
	local vec;
	foreach (zombie_owner_class in ZOMBIE_OWNERS)
	{
		handle = zombie_owner_class.GetHandle();
		if (!TargetValid(handle) ||
		handle.GetHealth() < 1)
		{
			continue;
		}

		vec = zombie_owner_class.GetOrigin();

		if (!IsVectorInSphere(g_vecOrigin, 120, vec))
		{
			continue;
		}

		End(Enum_MiniGame_End.LOSE);
		return true;
	}
	return false;
}

function Tick_Win()
{
	if (Time() < g_iWin)
	{
		return;
	}
	End(Enum_MiniGame_End.WIN);
}

function Tick_Check_Win()
{
	foreach (rotor in ROTORS)
	{
		if (!rotor.IsMaxLevel())
		{
			return;
		}
	}

	g_iWin = Time() + WIN_DELAY;
	g_bWin = true;
}

function Tick_Move_X()
{
	local vec1 = ROTORS[g_iSlot_x].GetMoverStartOrigin();
	local vec2 = LerpTime(g_hMover.GetOrigin(), vec1, MOVE_X_TIME, Time() - g_fMove_Time);

	if (vec1 == vec2)
	{
		g_iStatus = Enum_Status.NONE;
		vec2 = vec1;
	}
	g_hMover.SetOrigin(vec2);
}

function Tick_Move_Up()
{
	local vec1 = ROTORS[g_iSlot_x].GetMoverStartOrigin();
	local vec2 = LerpTime(g_hMover.GetOrigin(), vec1, MOVE_Z_UP_TIME, Time() - g_fMove_Time);

	if (vec1 == vec2)
	{
		g_bBlock_x = false;
		ROTORS[g_iSlot_x].Disconnect();
		g_iStatus = Enum_Status.NONE;
		vec2 = vec1;
	}
	g_hMover.SetOrigin(vec2);
}

function Tick_Move_Down()
{
	local vec1 = ROTORS[g_iSlot_x].GetVecMoverConnect();
	local vec2 = LerpTime(g_hMover.GetOrigin(), vec1, MOVE_Z_DOWN_TIME, Time() - g_fMove_Time);
	local vec3 = LerpTime(ROTORS[g_iSlot_x].GetOrigin(), ROTORS[g_iSlot_x].GetSelfOrigin(), MOVE_Z_DOWN_TIME, Time() - g_fMove_Time);

	if (vec1 == vec2)
	{
		g_iStatus = Enum_Status.NONE;
		vec2 = vec1;
		vec3 = ROTORS[g_iSlot_x].GetSelfOrigin();
	}
	ROTORS[g_iSlot_x].SetOrigin(vec3);
	g_hMover.SetOrigin(vec2);
}

function Tick_Connect()
{
	local vec1 = ROTORS[g_iSlot_x].GetVecMoverConnect();
	local vec2 = LerpTime(g_hMover.GetOrigin(), vec1, MOVE_CONNECT_TIME, Time() - g_fMove_Time);
	if (vec1 == vec2)
	{
		g_iStatus = Enum_Status.NONE;
		vec2 = vec1;
	}
	g_hMover.SetOrigin(vec2);
}

function Tick_Controller()
{
	if ((g_bMove_W && g_bMove_S) ||
	(g_bMove_A && g_bMove_D) || (g_bMove_A || g_bMove_D) &&
	(g_bBlock_x || g_fBlock_x_Time > Time()))
	{
		return;
	}

	if (g_bMove_A)
	{
		g_iSlot_x--;
		if (g_iSlot_x < 0)
		{
			g_iSlot_x = 0;
			return;
		}
		g_iStatus = Enum_Status.MOVE_X;
		g_fBlock_x_Time = Time() + MOVE_X_DELAY;
		g_fMove_Time = Time() - 0.001;
		Tick_Move_X();
	}
	else if (g_bMove_D)
	{
		g_iSlot_x++;
		if (g_iSlot_x > 3)
		{
			g_iSlot_x = 3;
			return;
		}
		g_iStatus = Enum_Status.MOVE_X;
		g_fBlock_x_Time = Time() + MOVE_X_DELAY;
		g_fMove_Time = Time() - 0.001;
		Tick_Move_X();
	}
	else if (g_bMove_W)
	{
		g_iStatus = Enum_Status.MOVE_Z_UP;
		g_fMove_Time = Time() - 0.001;
		Tick_Move_Up();
	}
	else if (g_bMove_S)
	{
		local callback = ROTORS[g_iSlot_x].GetMoverStatus();
		if (callback == 0)	//CONNECT
		{
			g_iStatus = Enum_Status.CONNECT;
			g_fMove_Time = Time() - 0.001;
			g_bBlock_x = true;
			Tick_Connect();
		}
		else if (callback == 1) //MOVE_Z_DOWN
		{
			g_iStatus = Enum_Status.MOVE_Z_DOWN;
			g_fMove_Time = Time() - 0.001;
			Tick_Move_Down();
		}
		else
		{
			g_bMove_S = false;

			g_iStatus = Enum_Status.MOVE_Z_UP;
			g_fMove_Time = Time() - 0.001;
			Tick_Move_Up();
		}
	}
}

function End(end)
{
	if (g_bEnded)
	{
		return;
	}

	g_bEnded = true;

	Destroy();
	MiniGameIsEnd(self, end);
}

function Destroy()
{
	if (TargetValid(g_hOwner))
	{
		if (g_bController_Status)
		{
			EF(g_hController, "Deactivate");
		}
	}
	EF(g_hController, "Kill");

	EF(EntityGroup[2], "Kill");
	EF(EntityGroup[3], "Kill");
	EF(EntityGroup[4], "Kill");
	EF(EntityGroup[5], "Kill");
	EF(g_hMover, "Kill");


	EF(EntityGroup[0], "Kill");

	EF(self, "Kill");
}

function Hook_Controller_Off()
{
	g_bController_Status = false;
	if (g_bWin)
	{
		End(Enum_MiniGame_End.WIN);
	}
	else
	{
		End(Enum_MiniGame_End.LOSE);
	}
}

function Hook_Controller_On()
{
	g_bController_Status = true;
}

//HOOKS
{
	function Hook_Controller_UnPressed_W()
	{
		g_bMove_W = false;
	}
	function Hook_Controller_UnPressed_S()
	{
		g_bMove_S = false;
	}
	function Hook_Controller_UnPressed_A()
	{
		g_bMove_A = false;
	}
	function Hook_Controller_UnPressed_D()
	{
		g_bMove_D = false;
	}
	function Hook_Controller_Pressed_W()
	{
		g_bMove_W = true;
	}
	function Hook_Controller_Pressed_S()
	{
		g_bMove_S = true;
	}
	function Hook_Controller_Pressed_A()
	{
		g_bMove_A = true;
		g_fBlock_x_Time = 0.00;
	}
	function Hook_Controller_Pressed_D()
	{
		g_bMove_D = true;
		g_fBlock_x_Time = 0.00;
	}
}
Init();