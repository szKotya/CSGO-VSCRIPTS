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

// Выбор левой стороны потом правой?
// Сопоставить цвета?
// Выбор цветов мигает
//


const TICKRATE = 0.05;
g_fTick <- 0.00;
g_bAddCutScene <- false;

g_vecOrigin <- null;

const LIMIT_TIME = 20.0;
g_fLimit_Time <- 0;

const WIN_DELAY = 1.0;

enum Enum_Connect
{
	NOPE,
	CONNECT,
	DISCONNECT,
}


g_bController_Status <- false;

g_bEnded <- false;
g_bWin <- false;
g_iWin <- 0.00;

g_hController <- EntityGroup[1];
g_hOwner <- null;
g_hOwner_HP <- 0;

g_iSelect_Left <- 0;
g_iSelect_Right <- 0;
g_bSelect_Side <- false;

CABLES_LEFT <- [];
CABLES_RIGHT <- [];

g_hSelect_Left <- EntityGroup[2];
g_hSelect_Right <- EntityGroup[6];

CABLES <- [];
class class_cable
{
	connect_right = null;
	connect_left = null;

	beam = null;

	connect = false;

	index_right = -1;
	index_left = -1;

	constructor(_connect_left, _connect_right, _beam)
	{
		this.connect_left = _connect_left;
		this.connect_right = _connect_right;

		this.beam = _beam;
	}

	function GetConnectorRight()
	{
		return this.connect_right;
	}

	function GetConnectorLeft()
	{
		return this.connect_left;
	}

	function SetIndexRight(i)
	{
		this.index_right = i;
	}
	function SetIndexLeft(i)
	{
		this.index_left = i;
	}

	function Connect(index1, index2)
	{
		if (this.connect)
		{
			if (this.index_left == index1 ||
			this.index_right == index2)
			{
				return Enum_Connect.DISCONNECT;
			}
		}
		else
		{
			if (this.index_left == index1 &&
			this.index_right == index2)
			{
				this.connect = true;
				EF(this.beam, "Toggle");
				return Enum_Connect.CONNECT;
			}
		}
		return Enum_Connect.NOPE;
	}

	function Complete()
	{
		return this.connect;
	}
}

function Init()
{
	{
		CABLES.push(class_cable(EntityGroup[2], EntityGroup[6], EntityGroup[10]));
		CABLES.push(class_cable(EntityGroup[3], EntityGroup[7], EntityGroup[11]));
		CABLES.push(class_cable(EntityGroup[4], EntityGroup[8], EntityGroup[12]));
		CABLES.push(class_cable(EntityGroup[5], EntityGroup[9], EntityGroup[13]));

		local i;

		local temp;
		local randomindex;

		for (i = 2; i <= 5; i++)
		{
			CABLES_LEFT.push(EntityGroup[i]);
		}
		for (i = 6; i <= 9; i++)
		{
			CABLES_RIGHT.push(EntityGroup[i]);
		}

		for (i = 0; i < CABLES_LEFT.len(); i++)
		{
			randomindex = RandomInt(0, CABLES_LEFT.len() - 1);
			temp = [CABLES_LEFT[i], CABLES_LEFT[i].GetOrigin(), CABLES_LEFT[randomindex], CABLES_LEFT[randomindex].GetOrigin()];

			CABLES_LEFT[i].SetOrigin(temp[3]);
			CABLES_LEFT[randomindex].SetOrigin(temp[1]);

			CABLES_LEFT[i] = temp[2];
			CABLES_LEFT[randomindex] = temp[0];


			randomindex = RandomInt(0, CABLES_RIGHT.len() - 1);
			temp = [CABLES_RIGHT[i], CABLES_RIGHT[i].GetOrigin(), CABLES_RIGHT[randomindex], CABLES_RIGHT[randomindex].GetOrigin()];

			CABLES_RIGHT[i].SetOrigin(temp[3]);
			CABLES_RIGHT[randomindex].SetOrigin(temp[1]);

			CABLES_RIGHT[i] = temp[2];
			CABLES_RIGHT[randomindex] = temp[0];
		}

		foreach (cable in CABLES)
		{
			cable.SetIndexRight(GetConnectorIndexByRight(cable.GetConnectorRight()));
			cable.SetIndexLeft(GetConnectorIndexByLeft(cable.GetConnectorLeft()));
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

	EntFire("map_entity_text_puzzle01", "Display", "", 0, g_hOwner);

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

function GetConnectorIndexByRight(connector)
{
	foreach (index, value in CABLES_RIGHT)
	{
		if (value == connector)
		{
			return index;
		}
	}
	return -1;
}

function GetConnectorIndexByLeft(connector)
{
	foreach (index, value in CABLES_LEFT)
	{
		if (value == connector)
		{
			return index;
		}
	}
	return -1;
}

function UpDateGlow()
{
	if (g_bSelect_Side)
	{
		if (g_hSelect_Right != null)
		{
			AOP(g_hSelect_Right, "glowstyle", 2);
			AOP(g_hSelect_Right, "renderfx", 0);
		}

		g_hSelect_Right = CABLES_RIGHT[g_iSelect_Right];
		AOP(g_hSelect_Right, "glowstyle", 1);
		AOP(g_hSelect_Right, "renderfx", 17);
	}
	else
	{
		if (g_hSelect_Right != null)
		{
			AOP(g_hSelect_Right, "glowstyle", 2);
			AOP(g_hSelect_Right, "renderfx", 0);
		}

		if (g_hSelect_Left != null)
		{
			AOP(g_hSelect_Left, "glowstyle", 2);
			AOP(g_hSelect_Left, "renderfx", 0);
		}

		g_hSelect_Left = CABLES_LEFT[g_iSelect_Left];
		AOP(g_hSelect_Left, "glowstyle", 1);
		AOP(g_hSelect_Left, "renderfx", 17);
	}
}

function Check_Win()
{
	foreach (cable in CABLES)
	{
		if (!cable.Complete())
		{
			return false;
		}
	}

	g_iWin = Time() + WIN_DELAY;
	g_bWin = true;
	return true;
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
	function Hook_Controller_Pressed_W()
	{
		if (g_bWin)
		{
			return;
		}

		if (g_bSelect_Side)
		{
			g_iSelect_Right--;
			if (g_iSelect_Right < 0)
			{
				g_iSelect_Right = 0
				return;
			}
		}
		else
		{
			g_iSelect_Left--;
			if (g_iSelect_Left < 0)
			{
				g_iSelect_Left = 0
				return;
			}
		}
		UpDateGlow();
	}
	function Hook_Controller_Pressed_S()
	{
		if (g_bWin)
		{
			return;
		}

		if (g_bSelect_Side)
		{
			g_iSelect_Right++;
			if (g_iSelect_Right >= CABLES_RIGHT.len())
			{
				g_iSelect_Right = CABLES_RIGHT.len() - 1;
				return;
			}
		}
		else
		{
			g_iSelect_Left++;
			if (g_iSelect_Left >= CABLES_LEFT.len())
			{
				g_iSelect_Left = CABLES_LEFT.len() - 1;
				return;
			}
		}
		UpDateGlow();
	}
	function Hook_Controller_Pressed_A()
	{
		return;
	}
	function Hook_Controller_Pressed_D()
	{
		return;
	}
	function Hook_Controller_Pressed_A1()
	{
		if (g_bWin)
		{
			return;
		}

		if (g_bSelect_Side)
		{
			local bBadChoise = true;
			local bResult

			foreach (cable in CABLES)
			{
				bResult = cable.Connect(g_iSelect_Left, g_iSelect_Right);
				if (bResult == Enum_Connect.DISCONNECT)
				{
					return End(Enum_MiniGame_End.LOSE);
				}
				else if (bResult == Enum_Connect.CONNECT)
				{
					bBadChoise = false;
				}
			}

			if (bBadChoise)
			{
				return End(Enum_MiniGame_End.LOSE);
			}

			if (Check_Win())
			{
				return;
			}
		}
		g_bSelect_Side = !g_bSelect_Side;
		UpDateGlow();
	}
	function Hook_Controller_Pressed_A2()
	{
		return;
	}
}
Init();