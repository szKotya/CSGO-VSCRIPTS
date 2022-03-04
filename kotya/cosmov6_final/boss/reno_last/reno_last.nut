const TICKRATE = 0.2;

g_afDelay_Phase1 <- [1.0, 1.4];
g_afDelay_Phase2 <- [0.9, 1.2];


//Island
g_afDelay_Phase3 <- [0.6, 0.8];

g_bTicking <- false;
g_YLaser <- false;

g_iPhase <- 0;

g_hLaserMaker <- null; 
g_hModel <- null;

g_fLaser_Delay <- 0.00;
g_fLaser_Timer <- 0.00;

function Init()
{
	g_hLaserMaker = Entities.FindByName(null, "Laser_maker");
	g_hModel = Entities.FindByName(null, "Reno_Final_Model");
	printl(g_hModel);

	g_fLaser_Delay = RandomFloat(g_afDelay_Phase1[0], g_afDelay_Phase1[1]);
	g_iPhase = 1;
}

function Start()
{
	Init();
	// return;

	g_bTicking = true;
	Tick();
}

function Tick()
{
	if (!g_bTicking)
	{
		return;
	}
	LaserTick();

	CallFunction("Tick()", TICKRATE);
}

function PickLaser()
{
	PickRandomAnim();
	PickRandomLaser(1.00);
}

function LaserTick()
{
	g_fLaser_Timer += TICKRATE;
	if (g_fLaser_Timer >= g_fLaser_Delay)
	{
		g_fLaser_Timer = 0.00;
		local fDelay;
		if (g_iPhase == 1)
		{
			fDelay = g_afDelay_Phase1.slice();
		}
		else if (g_iPhase == 2)
		{
			fDelay = g_afDelay_Phase2.slice();
		}
		else if (g_iPhase == 3)
		{
			fDelay = g_afDelay_Phase3.slice();
		}

		g_fLaser_Delay = RandomFloat(fDelay[0], fDelay[1]);
		PickLaser();
	}
}

function PickRandomAnim(Anim = -1)
{
	if (Anim == -1)
	{
		Anim = RandomInt(0, 1);
	}
	
	if (Anim)
	{
		SetAnimation("attack2");
	}
	else
	{
		SetAnimation("karateguy");
	}
}

g_aLaserPresets <- [
	class_pos(Vector(-11300, -928, 1860), Vector(0, 5, 90)),
	class_pos(Vector(-11300, -928, 1860), Vector(0, 0, 0)),
	class_pos(Vector(-11300, -928, 1865), Vector(0, 0, 0)),
	class_pos(Vector(-11300, -928, 1870), Vector(0, 0, 0)),
	class_pos(Vector(-11300, -928, 1872), Vector(0, 0, 0)),
	class_pos(Vector(-11300, -928, 1880), Vector(0, 0, 0)),
	class_pos(Vector(-11300, -928, 1885), Vector(0, 0, 0)),
	class_pos(Vector(-11300, -928, 1890), Vector(0, 0, 0)),
	class_pos(Vector(-11300, -928, 1895), Vector(0, 0, 0)),

	class_pos(Vector(-11300, -928, 1860), Vector(0, 0, 9.5)),
	class_pos(Vector(-11300, -928, 1860), Vector(0, 0, -9.5)),

	// class_pos(Vector(-11300, -928, 1830), Vector(0, 0, 0)),
	// class_pos(Vector(-11300, -928, 1855), Vector(0, 0, 0)),

	// class_pos(Vector(-11300, -928, 1880), Vector(0, 0, 0)),
	// class_pos(Vector(-11300, -928, 1895), Vector(0, 0, 0)),

	// class_pos(Vector(-11300, -928, 1830), Vector(0, 0, 0)),
	// class_pos(Vector(-11300, -928, 1862), Vector(0, 0, -9.5)),

	// class_pos(Vector(-11300, -928, 1862), Vector(0, 0, 9.5)),
];
function PickRandomLaser(fDelay = 0.00, ID = -1)
{
	if (ID == -1)
	{
		ID = RandomInt(0, g_aLaserPresets.len() - 1);
		if (g_iPhase > 1)
		{
			if (g_YLaser)
			{
				ID = -1;
			}
			g_YLaser = !g_YLaser;
		}	
	}
	CallFunction("SpawnLaser(" +ID + ")", fDelay);
}

function SpawnLaser(ID)
{
	local origin; 
	local angles;
	if (ID == -1)
	{
		local target;
		while (null != (target = Entities.FindByClassnameWithin(target, "player", self.GetOrigin(), 900)))
		{
			if (target.IsValid() && target.GetTeam() == 3 && target.GetHealth() > 0)
			{
				break;
			}
		}

		origin = Vector(-11300, -928, 1855);
		angles = Vector(180, GetTwoVectorsYaw(origin, target.GetOrigin()), 90);
	}
	else
	{
		origin = g_aLaserPresets[ID].origin;
		angles = g_aLaserPresets[ID].angles;
	}

	g_hLaserMaker.SpawnEntityAtLocation(origin, angles);
}

function SetAnimation(szAnim, fDelay = 0.00)
{
	EF(g_hModel, "SetAnimation", szAnim, fDelay);
}

function SetDefaultAnimation(szAnim, fDelay = 0.01)
{
	EF(g_hModel, "SetDefaultAnimation", szAnim, fDelay);
}

function SetPlaybackRate(fRate = 1.00, fDelay = 0.01)
{
	EF(g_hModel, "SetPlaybackRate", "" + fRate, fDelay);
}