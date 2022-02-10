class VortexPlayer
{
    handle = null;
    place = 0;
}

g_avSpiralOrigin <- [];
g_avSpiralAngles <- [];
g_ahPlayers <- [];
g_iPower <- 0;
g_fRadius <- 0;

function Tick()
{
    if (g_ahPlayers.len() > 0)
    {
        foreach (p in g_ahPlayers)
        { 
            if (p.handle.IsValid() && p.handle.GetTeam() == 2 && p.handle.GetHealth() > 0)
            {
                local spos = g_avSpiralOrigin[p.place];
                local apos = p.handle.GetOrigin();

                local dist = GetDistance2D(spos, apos);
                while (p.place > 0)
                {
                    if (dist < 16)
                    {
                       p.place--;
                    }
                    else 
                    {
                        break;
                    }

                    spos = g_avSpiralOrigin[p.place];
                    dist = GetDistance2D(spos, apos);
                }

                local power = g_iPower;
                local vec = (apos - spos) * -1;

                vec.Norm();

                vec = Vector(vec.x * power, vec.y * power, vec.z * power);
                p.handle.SetVelocity(vec);

                local ang = p.handle.GetAngles();
                p.handle.SetAngles(ang.x, ang.y + g_avSpiralAngles[p.place], 0);
            }
        }
    }
}

function Touch()
{
    local obj = VortexPlayer();
    obj.handle = activator;
    local iBest = 0;
    local iDis0 = GetDistance2D(g_avSpiralOrigin[iBest], activator.GetOrigin());
    local iDis1;
    for(local i = 1; i < g_avSpiralOrigin.len(); i++)
    {
        iDis1 = GetDistance2D(g_avSpiralOrigin[i], activator.GetOrigin());
        if (iDis0 > iDis1)
        {
            iDis0 = iDis1;
            iBest = i;
        }
    }
    obj.place = iBest;
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
                g_ahPlayers.remove(i);
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

function Init()
{
    local vec = self.GetOrigin();
    local ang = 0.0;
    local size = 0.75;

    for (local i = 0; i < 160; i++)
    {
        ang = 0.1 * i;
        vec = Vector(vec.x + (2 * size * ang) * cos(ang), 
        vec.y + (2 * size * ang) * sin(ang), vec.z);
        g_avSpiralAngles.push(ang);
        g_avSpiralOrigin.push(vec);
    }

    for (local i = 0; i < g_avSpiralOrigin.len(); i++)
    {
        DebugDrawAxis(g_avSpiralOrigin[i], 8, 3);
        if(i < g_avSpiralOrigin.len()-1){DebugDrawLine(g_avSpiralOrigin[i], g_avSpiralOrigin[i+1], 0, 255, 0, true, 3);}
        //else{DebugDrawLine(g_avSpiralOrigin[i], g_avSpiralOrigin[0], 0, 255, 0, true, 3);}
    }
}

function Disable()
{
    foreach (p in g_ahPlayers)
    {
        if (p.handle.IsValid() && p.handle.GetTeam() == 2 && p.handle.GetHealth() > 0)
        {
            p.handle.SetVelocity(Vector(0, 0, 0));
        }
    }
}