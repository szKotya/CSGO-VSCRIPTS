const TICKRATE = 0.25;
g_fTick <- 0.00;

::cp01_quest_01 <- self.GetScriptScope();

g_hModel <- EntityGroup[0];
g_hButton <- EntityGroup[1];
g_hOwner <- null;

g_vecLastOrigin <- Vector();

g_bTake <- false;
g_bInit <- true;

function Init(vec)
{
	g_bInit = true;

	g_hModel.SetOrigin(vec);
	EF(g_hModel, "SetGlowEnabled");
	EF(g_hButton, "UnLock");

	DebugDrawCircle(vec, 160, 32, 60);
}

function SetOwner()
{
	if (activator.GetTeam() != 3)
	{
		return;
	}

	g_hOwner = activator;

	EF(g_hButton, "Lock");
	g_bTake = true;

	g_vecLastOrigin = g_hOwner.GetCenter() + Vector (0, 0, 16);

	g_hModel.SetOrigin(g_vecVpizde);
	EF(g_hModel, "SetGlowDisabled");

	if (g_bInit)
	{
		Main_Script.Trigger_Quest_01_PickUp();

		g_bInit = false;

		// AOP(g_hModel, "glowdist", 99999);

		g_ahGlobal_Tick.push(self);
	}

	SetSpeed(g_hOwner, -0.2);
	CreateBackPack(g_hOwner);
	// local  owner_class = GetHumanOwnerClassByOwner(g_hOwner)

	// if (owner_class != null)
	// {
	// 	owner_class.SetGlowEnable();
	// }
}
function RemoveOwner()
{
	RemoveBackPackByOwner(g_hOwner);

	g_hOwner = null;
	EF(g_hButton, "UnLock");
	g_bTake = false;

	EF(g_hModel, "SetGlowEnabled");
	g_hModel.SetOrigin(GetFloor(g_vecLastOrigin));
}

function Tick()
{
	if (!g_bTake ||
	g_fTick > Time())
	{
		return;
	}
	g_fTick = Time() + TICKRATE;

	if (!TargetValid(g_hOwner) ||
	g_hOwner.GetHealth() < 1 ||
	g_hOwner.GetTeam() != 3)
	{
		RemoveOwner();
		return;
	}
	g_vecLastOrigin = g_hOwner.GetCenter() + Vector (0, 0, 16);
}

function Complete()
{
	SetSpeed(g_hOwner, 0.2);
	RemoveBackPackByOwner(g_hOwner);
	// local  owner_class = GetHumanOwnerClassByOwner(g_hOwner)

	// if (owner_class != null)
	// {
	// 	owner_class.SetGlowDisable();
	// }

	EF(g_hModel, "SetGlowDisabled");
	EF(g_hModel, "Kill");
	EF(g_hButton, "Kill");
	EF(self, "Kill");
}