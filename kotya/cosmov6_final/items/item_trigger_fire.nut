
class FirePlayer
{
	handle = null;
	time = 0;
}

g_ahPlayers <- [];
g_iDamage <- 0;
g_fFireRate <- 0;

function Tick()
{
	if (g_ahPlayers.len() > 0)
	{
		local fDamage;
		foreach (p in g_ahPlayers)
		{
			if (p.handle.IsValid() && p.handle.GetTeam() == 2 && p.handle.GetHealth() > 0 )
			{
				local spos = self.GetOrigin();
				local apos = p.handle.GetOrigin();

				local dist = GetDistance2D(spos, apos);

				if (dist < self.GetBoundingMaxs().x)
				{
					EF(p.handle, "IgniteLifeTime", "3.0");
					fDamage = (g_iDamage * (1.00 + p.time));
					printl("dAMAGE : " + fDamage);
					DamagePlayer(p.handle, fDamage, damagetype_item);
					p.time += g_fFireRate;
				}
			}
		}
	}
}


function Touch()
{
	local obj = FirePlayer();
	obj.handle = activator;
	g_ahPlayers.push(obj);
}

function EndTouch()
{
	if (g_ahPlayers.len() > 0)
	{
		for (local i = 0; i < g_ahPlayers.len(); i++)
		{
			if (g_ahPlayers[i].handle == activator)
			{
				return g_ahPlayers.remove(i);
			}
		}
	}
}

function OnPostSpawn()
{
	Enable();
}

function Enable()
{
	EF(self, "Disable", "", 0);
	self.ConnectOutput("OnStartTouch", "Touch");
	self.ConnectOutput("OnEndTouch", "EndTouch");
	EF(self, "Enable", "", 0.01);
}