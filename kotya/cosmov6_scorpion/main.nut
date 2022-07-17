SendToConsole("sv_cheats 1");
SendToConsole("bot_stop 1");
// SendToConsole("bot_kick");
SendToConsole("mp_freezetime 0");
SendToConsole("mp_warmuptime 999999999");

const TICKRATE = 0.15;
const TICKRATE_TEXT = 1.00;

const CD_ROAR = 15.0;
const CD_JUMP = 10.0;
const CD_DASH = 5.0;
const CD_STRIKE = 2.0;

g_szAnimList <- [
	"attack",			// ТЫЧКА
	"attack2",			// РЫВОК
	"attack3",
	"dead",
	"idle",
	"jump",			// ПРЫГНУЛ ЗАДАМАЖИЛ
	"roar",			// ЗАМЕДЛИЛ
	"run",
];

g_iScroll_ID <- 0;
g_aiAttacks <- [
	"Strike",
	"Dash",
	"Ror",
	"Jump",
]

g_fTicking_Text <- 0.0;
enum EnumAnimStatus
{
	idle,
	run,
}

MainScript <- null;


g_fRoar_CD <- Time();
g_fJump_CD <- Time();
g_fDash_CD <- Time();
g_fStrike_CD <- Time();

g_iHP <- 0;
g_iHP_Init <- 0;
g_iHP_BARS <- 16;

g_bStaned <- false;

g_iShoots_for_Gil <- 15;
g_iShoots_for_Gil = 1.00 / g_iShoots_for_Gil;

g_hOwner <- null;
g_hKnife <- null;

g_hCamera <- null;
g_hEyeParent <- null;
g_hEyeParentModel <- null;
g_hBox <- null;
g_hModel <- null;
g_hGameUI  <- null;

g_bPress_W <- false;
g_bPress_S <- false;
g_bPress_A <- false;
g_bPress_D <- false;

g_bPickUp <- false;
g_bTicking <- false;

g_hText <- null;

function Init()
{
	g_hBox = Entities.FindByName(null, "scorpion_hbox");
	g_hKnife = Entities.FindByName(null, "scorpion_knife");
	CreateModel();
	CreateCamera();
	CreateGameUI();
	CreateText();

	TickPickUp();
}

function PickUp()
{
	SetOwner();
	SetHP(60);

	g_bTicking = true;
	Tick();
}

function TickPickUp()
{
	if (g_bPickUp)
	{
		return;
	}

	local h;
	local oldKnife
	while (null != (h = Entities.FindInSphere(h, g_hKnife.GetOrigin(), 32)))
	{
		if (h.GetClassname() == "player" &&
		h.IsValid() &&
		h.GetHealth() > 0 &&
		h.GetTeam() == 2)
		{
			while ((oldKnife = Entities.FindByClassname(oldKnife, "weapon_knife*")) != null)
			{
				if (oldKnife.GetOwner() == h)
				{
					oldKnife.Destroy();
					break;
				}
			}
			g_bPickUp = true;
			g_hOwner = h;
			return;
		}
	}

	EF(self, "RunScriptcode", "TickPickUp()", 0.5);
}

function Tick()
{
	if (!g_bTicking ||
	!Tick_Owner() ||
	!Tick_HP())
	{
		return;
	}

	Tick_Anim();
	Tick_BossStatus();
	Tick_Text();

	EF(self, "RunScriptcode", "Tick()", TICKRATE);
}

function Tick_Text()
{
	g_fTicking_Text += TICKRATE;
	if (g_fTicking_Text >= TICKRATE_TEXT)
	{
		g_fTicking_Text = 0.0;
		DisplayText();
	}
}

function DisplayText()
{
	local szMsg = "";
	for (local i = 0; i < g_aiAttacks.len(); i++)
	{
		if (i == g_iScroll_ID)
		{
			szMsg += ">>>" + g_aiAttacks[g_iScroll_ID] + GetCD(i) + "<<<";
		}
		else
		{
			szMsg += g_aiAttacks[i] + GetCD(i) ;
		}
		szMsg += "\n";
	}

	EF(g_hText, "SetText", szMsg);
	EntFireByHandle(g_hText, "Display", "", 0, g_hOwner, g_hOwner);
}

function GetCD(ID)
{
	if (ID == 0){ID = g_fStrike_CD;}
	else if (ID == 1){ID = g_fDash_CD;}
	else if (ID == 2){ID = g_fRoar_CD;}
	else if (ID == 3){ID = g_fJump_CD;}
	local fTime = ID - Time().tointeger();
	if (fTime < 0.9)
	{
		return "[R]"
	}
	return "[" + fTime.tointeger() + "]";
}

function Tick_Owner()
{
	if (g_hOwner == null ||
	!g_hOwner.IsValid() ||
	g_hOwner.GetTeam() != 2 ||
	g_hOwner.GetHealth() < 1)
	{
		BossDead();
		return false;
	}
	return true;
}

function BossDead()
{
	g_bTicking = false;
	ShowBossDeadStatus();

	BossDead();

	if (MainScript != null && MainScript.IsValid())
	{
		MainScript.GetScriptScope().Active_Boss = null;
	}

	EF("map_brush", "RunScriptCode", "Trigger_CONDIKI_BANG_BANG_PULL_MY_DEVIL_TRIGGER!!!()");
}

function Tick_Anim()
{
	if (g_bPress_W ||
	g_bPress_S ||
	g_bPress_A ||
	g_bPress_D)
	{
		return SetAnimation_Run();
	}
	SetAnimation_Idle();
}

function Tick_HP()
{
	if (g_iHP <= 0)
	{
		g_iHP += g_iHP_Init;
		g_iHP_BARS--;

		if (g_iHP_BARS <= 16)
		{
			local id = 16 - g_iHP_BARS;
			EF("Special_HealthTexture", "SetTextureIndex", "" + id);
		}
	}

	if (g_iHP_BARS <= 0)
	{
		BossDead();
		return false;
	}
	return true;
}

function Press_AT1()
{
	if (g_iScroll_ID == 0)
	{
		g_fStrike_CD = Time().tointeger() + CD_STRIKE;
	}
	else if (g_iScroll_ID == 1)
	{
		g_fDash_CD = Time().tointeger() + CD_DASH;
	}
	else if (g_iScroll_ID == 2)
	{
		g_fRoar_CD = Time().tointeger() + CD_ROAR;
	}
	else if (g_iScroll_ID == 3)
	{
		g_fJump_CD = Time().tointeger() + CD_JUMP;
	}
	DisplayText();
}

function Press_AT2()
{
	g_iScroll_ID++;
	if (g_iScroll_ID >= g_aiAttacks.len())
	{
		g_iScroll_ID = 0;
	}
	DisplayText();
}

function Tick_BossStatus()
{
	local szMsg;

	szMsg = "[Scorpion] : Status : Angry\n";
	for (local i = 1; i <= g_iHP_BARS; i++)
	{
		if (i <= 16)
		{
			szMsg += "◆";
		}
		else
		{
			szMsg += "◈";
		}
	}
	for (local i = g_iHP_BARS; i < 16; i++)
	{
		szMsg += "◇";
	}

	ScriptPrintMessageCenterAll(szMsg);
}

function BossDead()
{
	local item_target = Entities.FindByName(null, "map_item_beam_target");
	EntFireByHandle(item_target, "ClearParent", "", 0, null, null);

	ResetOwner();
	RemoveSkin();
}

function ShowBossDeadStatus()
{
	local szMsg;
	szMsg = "[Scorpion] : Status : Dead\n";

	for (local i = g_iHP_BARS; i < 16; i++)
	{
		szMsg += "◇";
	}

	ScriptPrintMessageCenterAll(szMsg);
}

function SetOwner()
{
	AOP(g_hOwner, "targetname", "scorpion_owner" + Time());
	AOP(g_hOwner, "rendermode", 10);
	AOP(g_hOwner, "gravity", 2.5);

	g_hOwner.SetHealth(80000);
	EF(g_hOwner, "SetDamageFilter", "No_Damage");

	EntFireByHandle(g_hGameUI, "Activate", "", 0, g_hOwner, g_hOwner);
	EntFireByHandle(g_hCamera, "Enable", "", 0, g_hOwner, g_hOwner);
}

function ResetOwner()
{
	if (g_hOwner != null && g_hOwner.IsValid())
	{
		AOP(g_hOwner, "targetname", "");
		AOP(g_hOwner, "rendermode", 0);
		AOP(g_hOwner, "gravity", 1.0);
		EF(g_hGameUI, "Deactivate");
	}

	EF(g_hOwner, "SetDamageFilter", "", 0.05);
	EF(g_hOwner, "SetHealth", "-1", 0.05);
	EF(g_hCamera, "Disable");
}

function RemoveSkin()
{
	EF(g_hBox, "Break", "");
	EF(g_hModel, "ClearParent", "");
	EF(g_hModel, "SetAnimation", "dead");
	EF(g_hModel, "FadeAndKill", "", 1.0);

	EF(g_hCamera, "Kill", "", 0.05);
	EF(g_hEyeParent, "Kill", "", 0.05);
	EF(g_hEyeParentModel, "Kill", "", 0.05);
	EF(g_hGameUI, "Kill", "", 0.05);
	EF(g_hText, "Kill", "", 0.05);
}

/*
	HP BLOCK
*/
{
	function SetHP(i)
	{
		g_iHP = 100;
		i = (0.00 + i) / g_iHP_BARS;

		local handle;
		while (null != (handle = Entities.FindByClassname(handle, "player")))
		{
			if (handle.IsValid())
			{
				if (handle.GetTeam() == 3 &&
				handle.GetHealth() > 0)
				{
					g_iHP += i;
					g_iHP_Init += i;
				}
			}
		}
	}

	function AddHP(i)
	{
		if (i < 0)
		{
			i = -i * g_iHP_Init;
		}

		while (g_iHP + i >= g_iHP_Init)
		{
			g_iHP_BARS++;
			i -= g_iHP_Init;
		}

		if (g_iHP_BARS <= 16)
		{
			local id = 16 - g_iHP_BARS;
			EF("Special_HealthTexture", "SetTextureIndex", "" + id);
		}
		else
		{
			EF("Special_HealthTexture", "SetTextureIndex", "0");
		}

		g_iHP += i;
	}

	function ShootDamage()
	{
		SubtractHP(1);
		if (MainScript != null && MainScript.IsValid())
		{
			MainScript.GetScriptScope().GetPlayerClassByHandle(activator).ShootTick(g_iShoots_for_Gil);
		}
	}

	function ItemDamage(i)
	{
		if (i < 0)
		{
			i = -i * g_iHP_Init;
		}

		SubtractHP(i);
	}


	function SubtractHP(i)
	{
		if (g_bStaned)
		{
			i *= StanDamage;
		}

		g_iHP -= i;
	}
}
/*
	ANIM BLOCK
*/
{
	g_iAnimStatus <- -1;

	g_iAnimSelected <- -1;

	function SetAnimation_Idle()
	{
		if (g_iAnimStatus != EnumAnimStatus.idle)
		{
			EF(g_hModel, "SetAnimation", "idle");
			EF(g_hModel, "SetDefaultAnimation", "idle");
		}
		g_iAnimStatus = EnumAnimStatus.idle;
	}

	function SetAnimation_Run()
	{
		if (g_iAnimStatus != EnumAnimStatus.run)
		{
			EF(g_hModel, "SetAnimation", "run");
			EF(g_hModel, "SetDefaultAnimation", "run");
		}
		g_iAnimStatus = EnumAnimStatus.run;
	}

	function OnAnimationComplite()
	{
		return;
	}

	function CreateModel()
	{
		local modelpath = "models/microrost/cosmov6/ff7r/scorpion.mdl";

		self.PrecacheModel(modelpath);
		g_hModel = Entities.CreateByClassname("prop_dynamic");

		AOP(g_hModel, "solid", 0);
		AOP(g_hModel, "rendermode", 1);

		g_hModel.SetModel(modelpath);

		g_hModel.SetAngles(-90 , 90, 0);
		g_hModel.SetOrigin(g_hKnife.GetOrigin() + g_hKnife.GetForwardVector() * -32 + g_hKnife.GetUpVector() * 5);

		EntFireByHandle(g_hModel, "AddOutPut", "OnAnimationDone " + self.GetName() + ":RunScriptCode:OnAnimationComplite():0:-1", 0.01, null, null);
		EntFireByHandle(g_hModel, "SetParent", "!activator", 0.01, g_hKnife, g_hKnife);

		SetAnimation_Idle();
	}

	function CreateCamera()
	{
		g_hEyeParentModel = Entities.CreateByClassname("prop_dynamic");
		AOP(g_hEyeParentModel, "targetname", "scorpion_cameraparent" + Time());
		g_hEyeParentModel.SetOrigin(g_hKnife.GetOrigin() + g_hKnife.GetForwardVector() * -100 + g_hKnife.GetUpVector() * 130);
		g_hEyeParentModel.SetAngles(25, 0, 0);
		EntFireByHandle(g_hEyeParentModel, "SetParent", "!activator", 0.01, g_hKnife, g_hKnife);

		g_hEyeParent = Entities.CreateByClassname("logic_measure_movement");

		AOP(AOP, "TargetScale", 0.0);
		AOP(AOP, "MeasureType", 0);

		g_hCamera = Entities.CreateByClassname("point_viewcontrol");

		g_hCamera.SetOrigin(g_hEyeParentModel.GetOrigin());

		AOP(g_hCamera, "fov", 110);
		AOP(g_hCamera, "spawnflags", 128);
		AOP(g_hCamera, "fov_rate", 0.0);
		AOP(g_hCamera, "targetname", "scorpion_camera" + Time());

		EF(g_hEyeParent, "SetTargetReference", g_hEyeParentModel.GetName());
		EF(g_hEyeParent, "SetMeasureReference", g_hEyeParentModel.GetName());
		EF(g_hEyeParent, "SetMeasureTarget", g_hEyeParentModel.GetName());
		EF(g_hEyeParent, "SetTarget", g_hCamera.GetName());
		EF(g_hEyeParent, "Enable", "", 0.05);
	}

	function CreateText()
	{
		g_hText = Entities.CreateByClassname("game_text");
		g_hText.__KeyValueFromInt("spawnflags", 0);
		g_hText.__KeyValueFromInt("channel", 3);
		g_hText.__KeyValueFromInt("effect", 0);
		g_hText.__KeyValueFromVector("color", Vector(255, 0, 0));
		g_hText.__KeyValueFromVector("color2", Vector(193, 87, 0));
		g_hText.__KeyValueFromFloat("y", 0.78);
		g_hText.__KeyValueFromFloat("x", -1.0);
		g_hText.__KeyValueFromFloat("fadein", 0.75);
		g_hText.__KeyValueFromFloat("fadeout", 0.75);
		g_hText.__KeyValueFromFloat("holdtime", 1.0);
	}

	function CreateGameUI()
	{
		g_hGameUI = Entities.CreateByClassname("game_ui");

		g_hGameUI.__KeyValueFromInt("spawnflags", 0);
		g_hGameUI.__KeyValueFromFloat("FieldOfView", -1.0);

		AOP(g_hGameUI, "PressedAttack", self.GetName() + ":RunScriptCode:Press_AT1():0:-1", 0.01);
		AOP(g_hGameUI, "PressedAttack2", self.GetName() + ":RunScriptCode:Press_AT2():0:-1", 0.01);
		AOP(g_hGameUI, "PressedForward", self.GetName() + ":RunScriptCode:g_bPress_W=true:0:-1", 0.01);
		AOP(g_hGameUI, "PressedBack", self.GetName() + ":RunScriptCode:g_bPress_S=true:0:-1", 0.01);
		AOP(g_hGameUI, "PressedMoveLeft", self.GetName() + ":RunScriptCode:g_bPress_A=true:0:-1", 0.01);
		AOP(g_hGameUI, "PressedMoveRight", self.GetName() + ":RunScriptCode:g_bPress_D=true:0:-1", 0.01);

		AOP(g_hGameUI, "UnPressedForward", self.GetName() + ":RunScriptCode:g_bPress_W=false:0:-1", 0.01);
		AOP(g_hGameUI, "UnPressedBack", self.GetName() + ":RunScriptCode:g_bPress_S=false:0:-1", 0.01);
		AOP(g_hGameUI, "UnPressedMoveLeft", self.GetName() + ":RunScriptCode:g_bPress_A=false:0:-1", 0.01);
		AOP(g_hGameUI, "UnPressedMoveRight", self.GetName() + ":RunScriptCode:g_bPress_D=false:0:-1", 0.01);
	}
}

/*
	SOFT BLOCK
*/
{
	::AOP <- function(item, key, value = "", d = 0.00)
	{
		if (typeof item == "string")
		{
			EntFire(item, "AddOutPut", key + " " + value, d);
		}
		else if (typeof item == "instance")
		{
			if (d > 0.00)
			{
				EntFireByHandle(item, "AddOutPut", key + " " + value, d, item, item);
			}
			else
			{
				if (typeof value == "string")
				{
					item.__KeyValueFromString(key, value);
				}
				else if (typeof value == "integer")
				{
					item.__KeyValueFromInt(key, value);
				}
				else if (typeof value == "float")
				{
					item.__KeyValueFromFloat(key, value);
				}
				else if (typeof value == "vector")
				{
					item.__KeyValueFromVector(key, value);
				}
				else
				{
					EntFireByHandle(item, "AddOutPut", key + " " + value, d, item, item);
				}
			}
		}
	}
	::EF <- function(target, action, value = "", delay = 0.00)
	{
		if (typeof target == "string")
		{
			EntFire(target, action, value, delay, null)
		}
		else
		{
			EntFireByHandle(target, action, value, delay, null, null);
		}
	}
	function AnimCheck(ID = -1)
	{
		if (ID == -1)
		{
			g_iAnimSelected++;
			if (g_szAnimList.len() <= g_iAnimSelected)
			{
				g_iAnimSelected = 0;
			}
		}
		else
		{
			g_iAnimSelected = ID;
		}

		printl("SetAnim: " + g_szAnimList[g_iAnimSelected]);
		EF(g_hModel, "SetAnimation", g_szAnimList[g_iAnimSelected]);
	}
}

EF(self, "RunScriptCode", "Init()", 0.05);