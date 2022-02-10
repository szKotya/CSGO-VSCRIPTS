
IncludeScript("kotya/doom2016/support/models.nut");
IncludeScript("kotya/doom2016/support/items.nut");
IncludeScript("kotya/doom2016/support/math.nut");

Shoot   <- false;

Ticking <- false;
TICKRATE <- 0.1;
Limit_dist <- 50;
Idling <- false;
Shooting   <- false;
Reloading  <- false;
OverHeating <- false;
//////////////////////
//  Settings block  //
//////////////////////
Ammo        <- 100;
AmmoBackPack<- Ammo;
AmmoMax     <- 500;
AmmoTick    <- 0;

OverHeat_DMG <- 2;
OverHeat     <- 0;
OverHeatMax  <- 10;
OverTick     <- 0;
OverTickShoot<- 0;

StatusBack  <- ["Reload","Ready","No ammo","Overheat"]
Status       <- StatusBack[1]

//////////////////////
//    Anims Block   //
//////////////////////
a_Idle      <- "idle";
a_Reload    <- "reload";
a_Shoot     <- "shoot";

//////////////////////
//    Main Block    //
//////////////////////
function filter()
{
    printl("ti123cks Shot+ can");
    if(self.GetMoveParent().GetMoveParent() == activator)
    {
        if(Ammo == AmmoBackPack || Reloading || AmmoMax == 0)return;
        SetAnimation(a_Reload);
        Reloading = true;
        Shooting = false;
        Idling = false;
    }
}

function Pick()
{
    Owner = activator;
    Ticking = true;
    EntFireByHandle(Ui, "Activate", "", 0.01, Owner, Owner);
    EntFireByHandle(Text, "Display", "",0.01, Owner, Owner);
}
function Tick()
{
    EntFireByHandle(self, "RunScriptCode", "Tick();", TICKRATE, null, null);
    if(Reloading)
    {
        Status = StatusBack[0];
    }
    else
    {

        if(Shoot && !OverHeating && Ammo > 0)
        {
            if(Ammo-1 >= 0)Ammo--;

            Idling = false;
            if(!Shooting)
            {
                SetDefAnimation(a_Shoot);
                SetAnimation(a_Shoot);
            }
            EntFireByHandle(Hurt, "Enable", "", 0, null, null);
            EntFireByHandle(Effect, "Start", "", 0, null, null);
            ScriptPrintMessageCenterAll("Start");
            Shooting = true;

            OverTickShoot = 0;
            if(OverTick >= 1)
            {
                OverTick = 0;
                if(OverHeat+1<=OverHeatMax)OverHeat++;
                else
                {
                    Shooting = false;
                    if(!Idling)
                    {
                        SetDefAnimation(a_Idle);
                        SetAnimation(a_Idle);
                    }
                    EntFireByHandle(Hurt, "Disable", "", 0, null, null);
                    EntFireByHandle(Effect, "Stop", "", 0, null, null);
                    ScriptPrintMessageCenterAll("Stop");
                    Idling = true;
                    OverHeating = true;
                    EntFireByHandle(self, "RunScriptCode", "OverHeating = false;", 15, null, null);
                }
            }
            else OverTick += TICKRATE;
        }
        if(Ammo != 0 && !OverHeating)Status = StatusBack[1];
        else if (Ammo == 0)Status = StatusBack[2];
        else Status = StatusBack[3];

    }

    if(!Shoot || Ammo == 0)
    {
        EntFireByHandle(Hurt, "Disable", "", 0, null, null);
        EntFireByHandle(Effect, "Stop", "", 0, null, null);
        ScriptPrintMessageCenterAll("Stop");
        Shooting = false;
        if(!OverHeating)
        {
            if(OverTickShoot >= 1)
            {
                OverTickShoot = 0;
                if(OverHeat - 1 >= 0)OverHeat--;
            }
            else OverTickShoot+= 0.1;
            if(!Reloading)
            {
                if(!Idling)
                {
                    SetDefAnimation(a_Idle);
                    SetAnimation(a_Idle);
                }
                Idling = true;
            }
        }

    }

    if(Ticking)
    {
        if(CheakItem())
        {
            if(GetDistance(Owner.GetOrigin(),Center_T.GetOrigin()) > Limit_dist || Owner.GetHealth() <= 0)
            {
                EntFireByHandle(Center_M, "ClearParent", "", 0.00, Owner, Owner);
                EntFireByHandle(Ui, "Deactivate", "", 0, Owner, Owner);
                EntFireByHandle(Hurt, "Disable", "", 0, null, null);
                EntFireByHandle(Effect, "Stop", "", 0, null, null);
                ScriptPrintMessageCenterAll("Stop");
                Owner = null;
                Ticking = false;
                Reloading = false;
                Shoot = false;
                Shooting = false;
                if(!Idling)
                {
                    SetDefAnimation(a_Idle);
                    SetAnimation(a_Idle);
                }
                Idling = true;
                SetPosM();
            }
            else
            {
                Text.__KeyValueFromString("message","[Ammo] "+Ammo+"/"+AmmoMax+"\n[Overheat] "+OverHeat+"/"+OverHeatMax+"\n[Status] "+Status)
                EntFireByHandle(Text, "Display", "",0.01, Owner, Owner);
            }

        }
    }
}

function AnimComplete()
{
    if(Reloading)
    {
        if(AmmoMax - AmmoBackPack - Ammo < 0)
        {
            Ammo += AmmoMax;
            AmmoMax = 0;
        }
        else
        {
           AmmoMax -= AmmoBackPack - Ammo;
           Ammo = AmmoBackPack;
        }
        Shoot = false;
        Reloading = false;
        EntFireByHandle(Text, "Display", "",0.01, Owner, Owner);
    }

}

//////////////////////
//   Handle block   //
//////////////////////
Owner   <- null;
Model   <- null;
Text   <- null;
Hurt <- null;
Ui  <- null;
Effect  <- null;

Center_T <- null;
Center_M <- null;

function SetHandle()
{
    local name = caller.GetName();
    if(caller.GetClassname() == "info_particle_system")Effect = caller;
    if(caller.GetClassname() == "prop_dynamic_glow")Model = caller;
    if(caller.GetClassname() == "game_ui")Ui = caller;
    if(caller.GetClassname() == "trigger_hurt")Hurt = caller;
    if(caller.GetClassname() == "game_text")
    {
        Text = caller;
        //Ammo = AmmoBackPack;
    }
    if(name.find("item_chaingun_center_move") == 0)Center_M = caller;
    if(name.find("item_chaingun_distance") == 0)Center_T = caller;
}
//////////////////////
// Handle Block End //
//////////////////////
