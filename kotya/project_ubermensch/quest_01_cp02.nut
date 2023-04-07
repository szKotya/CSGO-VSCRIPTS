const TICKRATE = 0.25;
g_fTick <- 0.00;

::cp02_quest_03 <- self.GetScriptScope();

g_hButton <- EntityGroup[0];
g_hModel <- EntityGroup[1];
g_hRagdollButton <- EntityGroup[2];
g_hRagdollGlow <- EntityGroup[3];
g_hRagdoll <- EntityGroup[4];

g_hOwner <- null;

g_vecLastOrigin <- Vector();

g_bTake <- false;
g_bInit <- true;

function Init(vec)
{
	g_bInit = true;
	g_hRagdoll.SetAngles(RandomInt(0, 360), RandomInt(0, 360), RandomInt(0, 360));
	g_hRagdoll.SetOrigin(vec);
	EF(g_hRagdollGlow, "SetParentAttachment", "primary");
	EF(g_hRagdollButton, "SetParentAttachment", "primary");

	EF(g_hRagdoll, "EnableMotion");
	EF(g_hRagdoll, "DisableMotion", "", 5);

	EF(g_hRagdollGlow, "SetGlowEnabled");
	EF(g_hRagdollButton, "UnLock");

	DebugDrawCircle(vec, 160, 32, 60);
}

function SetOwner()
{
	if (activator.GetTeam() != 3)
	{
		return;
	}

	if (caller == g_hRagdollButton)
	{
		EF(g_hRagdollGlow, "SetGlowDisabled");
		EF(g_hRagdollButton, "Lock");
	}
	else
	{
		EF(g_hButton, "Lock");
	}

	if (g_bInit)
	{
		Main_Script.Trigger_Quest_01_CP02_PickUp();

		g_bInit = false;
		g_ahGlobal_Tick.push(self);
	}

	g_hOwner = activator;

	g_bTake = true;

	g_vecLastOrigin = g_hOwner.GetCenter() + Vector (0, 0, 16);

	g_hModel.SetOrigin(g_vecVpizde);
	EF(g_hModel, "SetGlowDisabled");

	SetSpeed(g_hOwner, -0.1);
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
	SetSpeed(g_hOwner, 0.1);
	RemoveBackPackByOwner(g_hOwner);
	// local  owner_class = GetHumanOwnerClassByOwner(g_hOwner)

	// if (owner_class != null)
	// {
	// 	owner_class.SetGlowDisable();
	// }

	EF(g_hRagdollButton, "Kill");
	EF(g_hModel, "SetGlowDisabled");
	EF(g_hModel, "Kill");
	EF(g_hButton, "Kill");
	EF(self, "Kill");
}