
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
//////////////////////
//  Settings block  //
//////////////////////
Ammo        <- 100;
AmmoBackPack<- Ammo;
AmmoMax     <- 500;
AmmoTick    <- 0;


StatusBack  <- ["Reload","Ready","No ammo"]
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
    EntFireByHandle(Ui, "Activate", "", 0, Owner, Owner);
    EntFireByHandle(Text, "Display", "",0, Owner, Owner);
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
        if(Shoot && Ammo > 0)
        {
            if(Ammo-1 >= 0)Ammo--;

            Idling = false;
            if(!Shooting)
            {
                SetDefAnimation(a_Shoot);
                SetAnimation(a_Shoot);
            }
            EntFireByHandle(Maker, "ForceSpawn", "", 0, null, null);

            Shooting = true;
        }
        if(Ammo != 0)Status = StatusBack[1];
        else if (Ammo == 0)Status = StatusBack[2];
    }

    if(!Shoot || Ammo == 0)
    {

        Shooting = false;
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

    if(Ticking)
    {
        if(CheakItem())
        {
            if(GetDistance(Owner.GetOrigin(),Center_T.GetOrigin()) > Limit_dist || Owner.GetHealth() <= 0)
            {
                EntFireByHandle(Center_M, "ClearParent", "", 0.00, Owner, Owner);
                EntFireByHandle(Ui, "Deactivate", "", 0, Owner, Owner);
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
                Text.__KeyValueFromString("message","[Ammo] "+Ammo+"/"+AmmoMax+"\n[Status] "+Status)
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
Maker <- null;
Ui  <- null;

Center_T <- null;
Center_M <- null;

function SetHandle()
{
    local name = caller.GetName();
    if(caller.GetClassname() == "info_particle_system")Effect = caller;
    if(caller.GetClassname() == "prop_dynamic_glow")Model = caller;
    if(caller.GetClassname() == "game_ui")Ui = caller;
    if(caller.GetClassname() == "env_entity_maker")Maker = caller;
    if(caller.GetClassname() == "game_text")
    {
        Text = caller;
        //Ammo = AmmoBackPack;
    }
    if(name.find("item_plasma_center_move") == 0)Center_M = caller;
    if(name.find("item_plasma_distance") == 0)Center_T = caller;
}
//////////////////////
// Handle Block End //
//////////////////////
