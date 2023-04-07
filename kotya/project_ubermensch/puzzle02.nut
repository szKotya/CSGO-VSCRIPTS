// EntityGroup[0] //DETAIL
// EntityGroup[1] //CONTROLLER
// EntityGroup[2] //BRUSH0
// EntityGroup[3] //BRUSH1
// EntityGroup[4] //BRUSH2
// EntityGroup[5] //BRUSH3
// EntityGroup[6] //BRUSH4
// EntityGroup[7] //BRUSH5
// EntityGroup[8] //BRUSH6
// EntityGroup[9] //BRUSH7
// EntityGroup[10] //BEAM0
// EntityGroup[11] //BEAM1
// EntityGroup[12] //BEAM2
// EntityGroup[13] //BEAM3

enum Enum_Ring
{
	LEFT = 4,
	RIGHT = 5,
	DOWN = 8,
}


const TICKRATE = 0.05;
g_fTick <- 0.00;

const LIMIT_TIME = 60.0;
g_fLimit_Time <- 0;
g_bAddCutScene <- false;

g_vecOrigin <- null;

const ROTATE_TIME = 0.5;

const WIN_DELAY = 1.0;

g_fInit_Time <- Time() + ROTATE_TIME + 0.01;

g_bController_Status <- false;

g_iSide_old <- null;
g_iSide <- Enum_Ring.LEFT;

g_bEnded <- false;
g_bWin <- false;
g_iWin <- 0.00;

g_hController <- EntityGroup[1];
g_hOwner <- null;
g_hOwner_HP <- 0;

g_bMoveObj <- false;
g_fMove_Time <- 0.00;

MOVE_OBJ <- [];

class class_moveobj
{
	obj = null;
	vecorigin = null;
	green = false;

	constructor(_obj)
	{
		this.obj = _obj;
		this.vecorigin = obj.GetOrigin();
	}

	function SetObj(_obj)
	{
		this.obj = _obj
	}

	function GetObj()
	{
		return this.obj;
	}

	function SetGreen(i)
	{
		this.green = i;
	}

	function IsGreen()
	{
		return this.green;
	}

	function GetPOrigin()
	{
		return this.vecorigin;
	}

	function SetOrigin(_vec)
	{
		this.obj.SetOrigin(_vec);
	}

	function GetOrigin()
	{
		return this.obj.GetOrigin();
	}
}

function Init()
{
	{
		for (local i = 2 ; i <= 13; i++)
		{
			if (i == 12)
			{
				MOVE_OBJ.push(null);
			}
			MOVE_OBJ.push(class_moveobj(EntityGroup[i]))
		}
		MOVE_OBJ[1].SetGreen(true);
		MOVE_OBJ[4].SetGreen(true);
		MOVE_OBJ[5].SetGreen(true);
		MOVE_OBJ[7].SetGreen(true);
		MOVE_OBJ[8].SetGreen(true);
		MOVE_OBJ[9].SetGreen(true);

		local iSide;
		for (local i = 0 ; i <= 40; i++)
		{
			switch (RandomInt(0, 2))
			{
				case 0:
				{
					iSide = Enum_Ring.LEFT;
					break;
				}
				case 1:
				{
					iSide = Enum_Ring.RIGHT;
					break;
				}
				case 2:
				{
					iSide = Enum_Ring.DOWN;
					break;
				}
			}
			MoveObj(iSide, RandomInt(0, 1));
		}

		UpDateGlow();
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

function MoveObj(Ring, Side = true)
{
	local array = GetRingArray(Ring);

	local temp = [];
	foreach (value in array)
	{
		temp.push([MOVE_OBJ[value].GetObj(), MOVE_OBJ[value].IsGreen()]);
		MOVE_OBJ[value].SetGreen(false);
	}

	if (Side)
	{
		MOVE_OBJ[array[0]].SetObj(temp[5][0]);
		MOVE_OBJ[array[0]].SetGreen(temp[5][1]);
		for(local i = 1; i < array.len(); i++)
		{
			MOVE_OBJ[array[i]].SetObj(temp[i - 1][0]);
			MOVE_OBJ[array[i]].SetGreen(temp[i - 1][1]);
		}
	}
	else
	{
		MOVE_OBJ[array[5]].SetObj(temp[0][0]);
		MOVE_OBJ[array[5]].SetGreen(temp[0][1]);
		for(local i = 0; i < array.len() - 1; i++)
		{
			MOVE_OBJ[array[i]].SetObj(temp[i + 1][0]);
			MOVE_OBJ[array[i]].SetGreen(temp[i + 1][1]);
		}
	}
	g_bMoveObj = true;
	g_fMove_Time = Time();
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

	EntFire("map_entity_text_puzzle02", "Display", "", 0, g_hOwner);

	if (g_bMoveObj)
	{
		Tick_Move();
	}

	if (g_bWin)
	{
		Tick_Win();
		return;
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
		End(Enum_MiniGame_End.DRAW);
	}
}

function Tick_Move()
{
	MOVE_OBJ
	local vec1;
	local vec2;

	foreach(obj in MOVE_OBJ)
	{
		if (obj == null)
		{
			continue;
		}

		vec1 = obj.GetPOrigin();
		vec2 = LerpTime(obj.GetOrigin(), vec1, ROTATE_TIME, Time() - g_fMove_Time);

		if (vec1 == vec2)
		{
			g_bMoveObj = false;
			vec2 = vec1;
		}
		obj.SetOrigin(vec2);
	}


	Check_Win();
}

function Check_Win()
{
	if (Time() <= g_fInit_Time ||
	g_bMoveObj ||
	!MOVE_OBJ[1].IsGreen() ||
	!MOVE_OBJ[4].IsGreen() ||
	!MOVE_OBJ[5].IsGreen() ||
	!MOVE_OBJ[7].IsGreen() ||
	!MOVE_OBJ[8].IsGreen() ||
	!MOVE_OBJ[9].IsGreen())
	{
		return;
	}

	g_iWin = Time() + WIN_DELAY;
	g_bWin = true;
}

function Tick_Win()
{
	if (Time() < g_iWin)
	{
		return;
	}
	End(Enum_MiniGame_End.WIN);
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
	EF(EntityGroup[6], "Kill");
	EF(EntityGroup[7], "Kill");
	EF(EntityGroup[8], "Kill");
	EF(EntityGroup[9], "Kill");
	EF(EntityGroup[10], "Kill");
	EF(EntityGroup[11], "Kill");
	EF(EntityGroup[12], "Kill");
	EF(EntityGroup[13], "Kill");

	EF(EntityGroup[0], "Kill");

	EF(self, "Kill");
}

function GetRingArray(Ring)
{
	return [Ring + 1, Ring + 4, Ring + 3, Ring - 1, Ring - 4, Ring - 3];
}

function UpDateGlow()
{
	local array1;
	local array2 = GetRingArray(g_iSide);

	if (g_iSide_old != null)
	{
		array1 = GetRingArray(g_iSide_old);

		foreach(index1, value1 in array1)
		{
			foreach(index2, value2 in array2)
			{
				if (value1 == value2)
				{
					array1.remove(index1);
					array2.remove(index2);
					break;
				}
			}
		}

		foreach(index in array1)
		{
			EF(MOVE_OBJ[index].GetObj(), "SetGlowDisabled");
		}
	}
	foreach(index in array2)
	{
		EF(MOVE_OBJ[index].GetObj(), "SetGlowEnabled");
	}
}

//HOOKS
{
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

	function Hook_Controller_Pressed_S()
	{
		if (g_bWin)
		{
			return;
		}

		if (g_bMoveObj)
		{
			return;
		}

		if (g_iSide == Enum_Ring.DOWN)
		{
			return;
		}

		g_iSide_old = g_iSide;
		g_iSide = Enum_Ring.DOWN;
		UpDateGlow();
	}
	function Hook_Controller_Pressed_A()
	{
		if (g_bWin)
		{
			return;
		}

		if (g_bMoveObj)
		{
			return;
		}

		if (g_iSide == Enum_Ring.LEFT)
		{
			return;
		}

		g_iSide_old = g_iSide;
		g_iSide = Enum_Ring.LEFT;
		UpDateGlow();
	}
	function Hook_Controller_Pressed_D()
	{
		if (g_bWin)
		{
			return;
		}

		if (g_bMoveObj)
		{
			return;
		}

		if (g_iSide == Enum_Ring.RIGHT)
		{
			return;
		}

		g_iSide_old = g_iSide;
		g_iSide = Enum_Ring.RIGHT;
		UpDateGlow();
	}
	function Hook_Controller_Pressed_A1()
	{
		if (g_bWin)
		{
			return;
		}

		if (g_bMoveObj)
		{
			return;
		}
		MoveObj(g_iSide, false);
	}
	function Hook_Controller_Pressed_A2()
	{
		if (g_bWin)
		{
			return;
		}

		if (g_bMoveObj)
		{
			return;
		}
		MoveObj(g_iSide, true);
	}
}
CallFunction("Init()", 0.05);