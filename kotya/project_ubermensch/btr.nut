// EntityGroup[0] //UP
// EntityGroup[1] //SIDE
// EntityGroup[2] //CONTROLLER
// EntityGroup[3] //BUTTON
// EntityGroup[4] //LASER
// EntityGroup[5] //LASERStartPOINT
// EntityGroup[6] //LASEREndPOINT
// EntityGroup[7] //CAMERAMEASURE
// EntityGroup[8] //TRAIN
// EntityGroup[9] //OWNERMEASURE
// EntityGroup[10] //OWNEREYE

::BTR_SCRIPT <- self.GetScriptScope();

g_hMover_Side <- EntityGroup[0];
g_hMover_UpSide <- EntityGroup[1];
g_hController <- EntityGroup[2];
g_hButton <- EntityGroup[3];
g_hLaser <- EntityGroup[4];
g_hLaser.SetAngles(0, 0, 0);
g_hLaserStartPoint <- EntityGroup[5];
g_hLaserEndPoint <- EntityGroup[6];
g_hCameraMeasure <- EntityGroup[7];
g_hTrain <- EntityGroup[8];
g_hOwnerMeasure <- EntityGroup[9];
g_hEyeMeasure <- EntityGroup[10];


// DebugDrawAxis(g_hLaserStartPoint.GetOrigin() + g_hLaserStartPoint.GetForwardVector() * 43.5 + g_hLaserStartPoint.GetUpVector() * -4.5, 8, 32);
g_hOwner <- null;
g_hCamera <- null;

g_hWheelsRight <- [];
g_hWheelsLeft <- [];

g_bMove_W <- false;
g_bMove_S <- false;
g_bMove_A <- false;
g_bMove_D <- false;
g_bA1 <- false;

g_vecOldDir <- Vector();
g_iWheelDirX_L <- 0;
g_iWheelDirX_R <- 0;

g_iGunDirX <- 0;

g_ShootA1_Time <- 0;

const SHOOTA1_DELAY = 0.6;
const DIR_UP_MAX = 15;
const DIR_UP_MIN = -40;
const MIN_MOVE_VALUE = 0.01;

g_bTicking <- false;
g_bMoving <- false;

g_bController_Status <- false;

function InitWheelRight()
{
	g_hWheelsRight.push(caller);
}
function InitWheelLeft()
{
	g_hWheelsLeft.push(caller);
}

function Start_Move()
{
	return;

	g_bMoving = true;
	EF(g_hTrain, "StartForWard");
}

function Stop_Move()
{
	g_bMoving = false;
	EF(g_hTrain, "Stop");
}

function SetOwner(owner)
{
	g_iGunDirX = g_hMover_Side.GetAngles().x;
	g_hOwner = owner;

	EntFireByHandle(g_hController, "Activate", "", 0.25, g_hOwner, g_hOwner);
	// EF(g_hOwner, "SetHUDVisibility", "0");

	g_hCamera = GetFreeCamera(g_hOwner);
	g_hCamera.GetCamera().__KeyValueFromInt("fov", 125);

	GetFreeTargetName(g_hOwner);

	EF(g_hOwnerMeasure, "Disable");
	EF(g_hOwnerMeasure, "SetMeasureTarget", "" + g_hOwner.GetName());
	EF(g_hOwnerMeasure, "Enable", "", 0.05);
}

function Tick()
{
	Tick_Wheels();
	if (!Tick_Owner())
	{
		return;
	}

	Tick_Turret_Move();
	Tick_Turret_Laser();
	Tick_Turret_Attack();
	Tick_Info();
}

function Tick_Wheels()
{
	if (!g_bMoving)
	{
		return;
	}

	g_iWheelDirX_L += 4;
	if (g_iWheelDirX_L > 360)
	{
		g_iWheelDirX_L = g_iWheelDirX_L % 360;
	}

	g_iWheelDirX_R -= 4;
	if (g_iWheelDirX_R < 0)
	{
		g_iWheelDirX_R = 360 + g_iWheelDirX_R;
	}

	foreach (wheel in g_hWheelsRight)
	{
		wheel.SetAngles(g_iWheelDirX_R, 180, 0);
	}
	foreach (wheel in g_hWheelsLeft)
	{
		wheel.SetAngles(g_iWheelDirX_L, 0, 0);
	}
}

function Tick_Owner()
{
	return (TargetValid(g_hOwner) && g_hOwner.GetHealth() > 0 && g_hOwner.GetTeam() == 3);
}

function Tick_Turret_Move()
{
	g_bMove_W = false;
	g_bMove_S = false;
	g_bMove_A = false;
	g_bMove_D = false;

	// local dir = g_hEyeMeasure.GetAngles() - g_vecOldDir;
	// ScriptPrintMessageCenterAll(format("%.3f, %.3f, %.3f", dir.x, dir.y, dir.z));

	// if(dir.x > MIN_MOVE_VALUE)
	// {
	// 	g_bMove_W = true;
	// }
	// else if(dir.x < -MIN_MOVE_VALUE)
	// {
	// 	g_bMove_S = true;
	// }

	// if(dir.y > MIN_MOVE_VALUE)
	// {
	// 	g_bMove_A = true;
	// }
	// else if(dir.y < -MIN_MOVE_VALUE)
	// {
	// 	g_bMove_D = true;
	// }

	// g_vecOldDir = g_hEyeMeasure.GetAngles();

	if ((g_bMove_A && !g_bMove_D)
	|| !g_bMove_A && g_bMove_D)
	{
		if (g_bMove_A)
		{
			g_iGunDirX += 4;
			if (g_iGunDirX > 360)
			{
				g_iGunDirX = g_iGunDirX % 360;
			}
		}
		else
		{
			g_iGunDirX -= 4;
			if (g_iGunDirX < 0)
			{
				g_iGunDirX = 360 + g_iGunDirX;
			}
		}

		g_hMover_Side.SetAngles(0, g_iGunDirX, 0);
	}
	if ((g_bMove_W && !g_bMove_S)
	|| !g_bMove_W && g_bMove_S)
	{
		local vecAng = g_hMover_UpSide.GetAngles();
		if (g_bMove_W)
		{
			vecAng.x -= 1.5;
			if (vecAng.x < DIR_UP_MIN)
			{
				vecAng.x = DIR_UP_MIN
			}
		}
		else
		{
			vecAng.x += 1.5;
			if (vecAng.x > DIR_UP_MAX)
			{
				vecAng.x = DIR_UP_MAX
			}
		}
		g_hMover_UpSide.SetAngles(vecAng.x, 0, 0);
	}
}

function Tick_Turret_Laser()
{
	g_hLaserEndPoint.SetOrigin(g_hLaserStartPoint.GetOrigin() + g_hLaserStartPoint.GetForwardVector() * TraceLine(g_hLaserStartPoint.GetOrigin(), g_hLaserStartPoint.GetOrigin() + g_hLaserStartPoint.GetForwardVector() * 1500, null) * 1500);
}

function Tick_Info()
{
	return;
	local szMessage = "";
	// DebugDrawAxis(g_hCamera.GetCamera().GetOrigin(), 8, 3);
	szMessage += format("%.2f %.2f %.2f\n", g_hMover_UpSide.GetAngles().x, g_hMover_UpSide.GetAngles().y, g_hMover_UpSide.GetAngles().z);
	szMessage += format("%.2f %.2f %.2f\n", g_hMover_Side.GetAngles().x, g_hMover_Side.GetAngles().y, g_hMover_Side.GetAngles().z);

	szMessage += format("%.2f %.2f %.2f\n", g_hEyeMeasure.GetAngles().x, g_hEyeMeasure.GetAngles().y, g_hEyeMeasure.GetAngles().z);
	szMessage += format("%.2f %.2f %.2f\n", g_hEyeMeasure.GetForwardVector().x, g_hEyeMeasure.GetForwardVector().y, g_hEyeMeasure.GetForwardVector().z);
	// szMessage += g_hMover_UpSide.GetAngles().x + ", " + g_hMover_UpSide.GetAngles().y + ", " + g_hMover_UpSide.GetAngles().z + "\n";
	// szMessage += g_hMover_Side.GetAngles().x + ", " + g_hMover_Side.GetAngles().y + ", " + g_hMover_Side.GetAngles().z + "\n";
	ScriptPrintMessageCenterAll(szMessage)
}

function Tick_Turret_Attack()
{
	if (g_bA1)
	{
		if (g_ShootA1_Time < Time())
		{
			g_ShootA1_Time = Time() + SHOOTA1_DELAY;
			Shoot();
		}
	}
}

function Shoot()
{
	AOP(Entity_Maker, "EntityTemplate", "btr_projectile");
	Entity_Maker.SetForwardVector(g_hLaserStartPoint.GetForwardVector());
	Entity_Maker.SetOrigin(g_hLaserStartPoint.GetOrigin() + g_hLaserStartPoint.GetForwardVector() * 43.5 + g_hLaserStartPoint.GetUpVector() * -4.5);

	Entity_Maker.SpawnEntity();
}

//HOOKS
{
	function OnPressed()
	{
		SetOwner(activator);

		if (!g_bTicking)
		{
			g_ahGlobal_Tick.push(self);
		}
		Trigger_BTR_ON();
		local pos = class_pos(g_hLaserStartPoint.GetOrigin() + g_hLaserStartPoint.GetLeftVector() * 32.5 + g_hLaserStartPoint.GetUpVector() * -1 + g_hLaserStartPoint.GetForwardVector() * 3, Vector(0, 270, 0));

		EF(g_hButton, "Lock");
		EF(g_hLaser, "TurnOn");

		g_hCamera.SetCameraPos(class_pos(Vector(), Vector(0, g_hMover_Side.GetAngles().y, 0)));
		EF(g_hCameraMeasure, "SetTarget", g_hCamera.GetCamera().GetName());
		EF(g_hCameraMeasure, "Enable", "", 0.05);

		g_bTicking = true;
	}
	function Hook_Controller_Off()
	{
		g_bController_Status = false;
		EF(g_hOwner, "SetHUDVisibility", "1");
		EF(g_hButton, "UnLock");
		EF(g_hLaser, "TurnOff");

		RemoveFreeTargetName(g_hOwner);

		g_hOwner = null;

		EF(g_hOwnerMeasure, "Disable");
		EF(g_hCameraMeasure, "Disable", "", 0.05);
		EF(g_hCameraMeasure, "Disable", "", 0.05);
		g_hCamera.Disable();

		g_bMove_W = false;
		g_bMove_S = false;
		g_bMove_A = false;
		g_bMove_D = false;
		g_bA1 = false;
	}
	function Hook_Controller_On()
	{
		g_bController_Status = true;
	}
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
	}
	function Hook_Controller_Pressed_D()
	{
		g_bMove_D = true;
	}
	function Hook_Controller_Pressed_A1()
	{
		g_bA1 = true;
	}
	function Hook_Controller_UnPressed_A1()
	{
		g_bA1 = false;
	}
}