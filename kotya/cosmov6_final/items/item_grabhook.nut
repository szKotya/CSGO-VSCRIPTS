const TICKRATE = 0.05;

g_hOwner <- null;
g_hController <- null;
g_hMeasure <- null;
g_hEye <- null;

g_hBeam <- null;

g_hHookTarget <- CreateTempParent();

g_bTicking <- false;
g_bFlyTime <- 0.0;

g_fDistance_Grab <- 500.0;

g_fSpeed <- 1000.0;
g_fDistance <- 56.0;
g_fTimeMax <- g_fDistance_Grab / g_fSpeed;
g_fDistance_UpBoost <- 300;
g_fUnGrab_Velocity <- 0.75;

function Spawn()
{
	g_hOwner = activator;
	g_hController = CreateController(g_hOwner, self, g_iItem_GameUIFlags);

	local temp = CreateEyeParent(g_hOwner);
	g_hMeasure = temp[0];
	g_hEye = temp[1];

	g_hController.press_attack = self.GetScriptScope().PressedAttack2;
	g_hController.press_attack2 = self.GetScriptScope().UnPressedAttack2;
}

function Tick()
{
	if (!g_bTicking)
	{
		return;
	}
	if (!TargerValid(g_hOwner) || g_hOwner.GetHealth() < 0)
	{
		g_hOwner = null;
		return UnHook();
	}
	if (GetDistance3D(g_hHookTarget.GetOrigin(), g_hOwner.GetOrigin()) < g_fDistance)
	{
		g_hOwner.SetVelocity(Vector(0, 0, g_fDistance_UpBoost));
		return UnHook();
	}
	if (g_bFlyTime > g_fTimeMax)
	{
		return UnHook();
	}


	local dir = (g_hHookTarget.GetOrigin() - g_hOwner.GetOrigin());
	dir.Norm();
	local vel = (dir * g_fSpeed);
	g_hOwner.SetVelocity(vel);

	g_bFlyTime += TICKRATE;

	CallFunction("Tick()", TICKRATE);
}

function PressedAttack2()
{
	this.controller_caller.GetScriptScope().TryToHook();
}
function UnPressedAttack2()
{
	this.controller_caller.GetScriptScope().UnHookPre();
}

function TryToHook()
{
	if (g_bTicking)
	{
		return;
	}

	local vecOrigin = Trace(g_hOwner.EyePosition(), g_hEye.GetForwardVector(), 10000);
	if (GetDistance3D(vecOrigin, g_hOwner.EyePosition()) > g_fDistance_Grab)
	{
		return;
	}
	DebugDrawAxis(vecOrigin);

	local vel = g_hOwner.GetVelocity();
	local dir = g_hEye.GetForwardVector();
	dir.Norm();
	if (vel.z < 10)
	{
		g_hOwner.SetVelocity(Vector(dir.x, dir.y, 250));
	}

	MakeHook();

	g_hHookTarget.SetOrigin(vecOrigin);
	g_bTicking = true;
	g_bFlyTime = 0.0;
	Tick();
}
function MakeHook()
{
	local kv = {};
	kv["life"] <- 0;
	kv["BoltWidth"] <- 2;
	g_hBeam = Beam_Maker.CreateBeamToTargets(kv, g_hHookTarget, g_hEye);
	g_hBeam = g_hBeam[0];
	EF(g_hBeam, "TurnOn");
}
function RemoveHook()
{
	if (TargerValid(g_hBeam))
	{
		EF(g_hBeam, "Kill");
	}
}

function UnHookPre()
{
	if (g_bTicking)
	{
		local vel = g_hOwner.GetVelocity();
		vel.x = vel.x * g_fUnGrab_Velocity;
		vel.y = vel.y * g_fUnGrab_Velocity;
		vel.z = vel.z * g_fUnGrab_Velocity;
		g_hOwner.SetVelocity(vel);
	}
	UnHook();
}

function UnHook()
{
	if (g_bTicking)
	{
		RemoveHook();
	}
	g_bTicking = false;
}