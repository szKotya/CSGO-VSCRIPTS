g_ahPlayers <- [];
g_iPower <- 0;
g_fRadius <- 0;
g_iLimit <- 512;

function Tick()
{
	if (g_ahPlayers.len() > 0)
	{
		foreach (p in g_ahPlayers)
		{
			if (p.IsValid() && p.GetTeam() == 2 && p.GetHealth() > 0)
			{
				local spos = self.GetOrigin();
				local apos = p.GetOrigin();

				local dist = GetDistance2D(spos, apos);

				if (dist < self.GetBoundingMaxs().x)
				{
					local power = g_iPower;
					local vec = apos - spos;
					local addplayervelocity = false;

					vec.Norm();
					vec = Vector(vec.x, vec.y, 0);
					if (g_fRadius < dist)
					{
						power *= 1.0 - ((dist - g_fRadius) / (self.GetBoundingMaxs().x - g_fRadius));
						addplayervelocity = true;
					}
					else
					{
						power = g_iLimit;
						vec = Vector(vec.x, vec.y, 256);
					}
					vec = Vector(vec.x * power, vec.y * power, vec.z);

					if (addplayervelocity)
					{
						vec += p.GetVelocity();
					}

					p.SetVelocity(vec);
				}
			}
		}
	}
}

function Touch()
{
	g_ahPlayers.push(activator);
}

function EndTouch()
{
	if (g_ahPlayers.len() > 0)
	{
		for (local i = 0; i < g_ahPlayers.len(); i++)
		{
			if (g_ahPlayers[i] == activator)
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
	EF(self, "Enable", "", 0.75);
}