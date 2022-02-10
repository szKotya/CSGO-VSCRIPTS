g_hOwner <- null;
g_hTarget <- null;
g_icItem <- null;
g_hModel <- null;

g_fRadius <- 0;
g_iSpeed <- 0;

g_vDir <- Vector(0, 0, 0);
g_vSpos <- Vector(0, 0, 0);
g_bMove <- true;

//LAST!!!
function Tick()
{
    if (g_bMove)
    {
        if (!InSight(self.GetOrigin(), self.GetOrigin() + self.GetForwardVector() * g_iSpeed))
        {
            ReturnBack();
            return Tick();
        }

        self.SetOrigin(self.GetOrigin() + self.GetForwardVector() * g_iSpeed);
        g_fRadius -= g_iSpeed;
        if (g_fRadius < 0)
        {
            ReturnBack();
            return Tick();
        }
    }
    else
    {
        self.SetOrigin(self.GetOrigin() + g_vDir * g_iSpeed);
        
        if (GetDistance3D(self.GetOrigin(), g_vSpos) < 20)
        {
            if (TargerValid(g_hTarget) && g_hTarget.GetHealth() > 0)
            {
                EF(g_hTarget, "ClearParent");
                AOP(g_hTarget, "movetype", 1);
            }

            EF(self, "Kill", "", 0.05);
            UseHookAfter(g_icItem);
            return;
        }
    }

    EF(self, "RunScriptCode", "Tick()", 0.01);
}


function Touch()
{
    if (activator == g_hOwner)
    {
        return;
    }
    g_hTarget = activator;
    self.SetOrigin(g_hTarget.EyePosition());

    AOP(g_hTarget, "movetype", 7);
    EntFireByHandle(g_hTarget, "SetParent", "!activator", 0.00, self, self);

    ReturnBack();
}

function ReturnBack()
{
    g_vDir = (g_vSpos - self.GetOrigin());
    g_vDir.Norm();

    self.DisconnectOutput("OnStartTouch", "Touch");
    g_bMove = false;
}

// function OnPostSpawn()
// {
//     Enable();
// }

function Enable()
{
    EF(self, "Disable", "", 0);
    self.ConnectOutput("OnStartTouch", "Touch");
    EF(self, "Enable", "", 0.01);
    
    g_vSpos = self.GetOrigin() + Vector(0, 0, 16);
    Tick();
}