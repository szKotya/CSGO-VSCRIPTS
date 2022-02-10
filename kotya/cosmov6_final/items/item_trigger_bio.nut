g_ahPlayers <- [];
g_iDamage <- 0;

function Tick()
{
    if (g_ahPlayers.len() > 0)
    {
        foreach (p in g_ahPlayers)
        {
            if (p.IsValid() && p.GetTeam() == 2 && p.GetHealth() > 0 )
            {
                local spos = self.GetOrigin();
                local apos = p.GetOrigin();

                local dist = GetDistance2D(spos, apos);

                if (dist < self.GetBoundingMaxs().x)
                {
                    DamagePlayer(p, g_iDamage, damagetype_item);
                    
                    if (dist >= self.GetBoundingMaxs().z * 0.025)
                    {
                        p.SetVelocity(Vector(0, 0, 450));
                    }
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
    EF(self, "Enable", "", 0.01);
}