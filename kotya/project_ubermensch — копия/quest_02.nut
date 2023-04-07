const LIMIT = 145.0;
const TICKRATE = 0.05;

g_fTime <- 30.0;
g_fSpeed <- (LIMIT - 90.0) / (g_fTime * (1.00 / TICKRATE));

g_hDoor <- self;
g_hButton <- null;

g_bTicking <- false;


function Tick()
{
	if (!g_bTicking)
	{
		return;
	}
	local angles = self.GetAngles().y + g_fSpeed;
	if (angles >= LIMIT)
	{
		g_bTicking = false;
		angles = LIMIT;
		self.SetAngles(0, angles, 0);
		EF(g_hButton, "Kill");

		Main_Script.Trigger_Chapter1_05();
		return;
	}
	self.SetAngles(0, angles, 0);
	CallFunction("Tick()", TICKRATE);
}

function OnPressed()
{
	if (g_hButton == null)
	{
		g_hButton = caller;
	}

	if (!g_bTicking)
	{
		g_bTicking = true;
		Tick();
	}
}
function OnUnpressed()
{
	if (g_hButton == null)
	{
		g_hButton = caller;
	}

	g_bTicking = false;
}
