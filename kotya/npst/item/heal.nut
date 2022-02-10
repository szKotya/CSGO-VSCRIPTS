g_iHP_Set <- 225;
g_iUses <- 3;
g_fDuration <- 2.0;
g_fCD <- 5.0;
g_iRadius <- 128;

const TICKRATE_HEAL = 0.2;
const TICKRATE_CHECK = 0.25;

g_hOwner <- null;
g_hGun <- self.GetMoveParent();
g_bTicking_Heal <- false;


g_hModel <- CreateProp(g_hGun.GetOrigin(), type_heal_prop);
EntFireByHandle(g_hModel, "SetParent", "!activator", 0.00, g_hGun, g_hGun);
g_hModel.SetAngles(g_hGun.GetAngles().x,g_hGun.GetAngles().y,0)
function OnPressed()
{
    if(g_hGun.GetMoveParent() == activator)
    {
        if(g_iUses > 0)
        {
            g_iUses--

            EntFireByHandle(self, "Lock", "", 0, null, null);
            EntFireByHandle(self, "UnLock", "", g_fCD, null, null);

            g_bTicking_Heal = true;
            TickHeal();
            EntFireByHandle(self, "RunScriptCode", "g_bTicking_Heal = false", g_fDuration, null, null);
        }
    }
}

function OnPickUp()
{
    g_hOwner = activator;

    g_hModel.ValidateScriptScope();
    EntFireByHandle(g_hModel, "ClearParent", "", 0, g_hOwner, g_hOwner);
    EntFireByHandle(g_hModel, "RunScriptCode", "self.SetOrigin(activator.GetOrigin()+activator.GetForwardVector()*1-activator.GetLeftVector()*2+Vector(0,0,45));self.SetAngles(0,activator.GetAngles().y-90,90)", 0.02, g_hOwner, g_hOwner);
    EntFireByHandle(g_hModel, "SetParent", "!activator", 0.02, g_hGun, g_hGun);

    TickCheck();
}

function TickCheck()
{
    if(g_hGun.GetMoveParent() != g_hOwner)
    {
        EntFireByHandle(g_hModel, "ClearParent", "", 0.00, null, null);
        EntFireByHandle(g_hModel, "RunScriptCode", "self.SetOrigin(activator.GetOrigin());self.SetAngles(activator.GetAngles().x,activator.GetAngles().y,0)", 0.02, g_hGun, g_hGun);
        EntFireByHandle(g_hModel, "SetParent", "!activator", 0.02, g_hGun, g_hGun);
    }
    else
        EntFireByHandle(self, "RunScriptCode", "TickCheck()", TICKRATE_CHECK, null, null);
}

function TickHeal()
{
    if(!g_bTicking_Heal)
        return;
    //HEAL
    {
        local h = null;
        while(null != (h = Entities.FindInSphere(h, self.GetOrigin(), g_iRadius)))
        {
            if(h.GetClassname() == "player" && 
                h.IsValid() &&
                h.GetHealth() > 0 &&
                h.GetTeam() == 3)
            {
                h.SetHealth(g_iHP_Set)
            }
        }
    }

    EntFireByHandle(self, "RunScriptCode", "TickHeal()", TICKRATE_HEAL, null, null);
}
