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


const TICKRATE = 0.05;
g_fTick <- 0.00;

const LIMIT_TIME = 15.0;
g_fLimit_Time <- 0;

const WIN_DELAY = 1.0;

g_bController_Status <- false;

g_bEnded <- false;
g_bWin <- false;
g_iWin <- 0.00;

g_hController <- EntityGroup[1];
g_hOwner <- null;

function Init()
{
	g_fLimit_Time = Time() + LIMIT_TIME;

	g_ahGlobal_Tick.push(self);

	REG_GAME_POST(self);
}

function SetOwner(owner)
{
	g_hOwner = owner;
	EntFireByHandle(g_hController, "Activate", "", 0, g_hOwner, g_hOwner);
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

	if (g_bWin)
	{
		Tick_Win();
		return;
	}

	if (Time() > g_fLimit_Time)
	{
		End(Enum_MiniGame_End.LOSE);
	}
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

	function Hook_Controller_UnPressed_W()
	{

	}
	function Hook_Controller_UnPressed_S()
	{

	}
	function Hook_Controller_UnPressed_A()
	{

	}
	function Hook_Controller_UnPressed_D()
	{

	}
	function Hook_Controller_Pressed_W()
	{

	}
	function Hook_Controller_Pressed_S()
	{

	}
	function Hook_Controller_Pressed_A()
	{

	}
	function Hook_Controller_Pressed_D()
	{

	}
	function Hook_Controller_Pressed_A1()
	{

	}
	function Hook_Controller_Pressed_A2()
	{

	}
}
Init();