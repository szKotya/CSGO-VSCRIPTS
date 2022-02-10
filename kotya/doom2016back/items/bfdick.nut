

IncludeScript("kotya/doom2016/support/models.nut");
IncludeScript("kotya/doom2016/support/items.nut");
IncludeScript("kotya/doom2016/support/math.nut");

Ticking <- false;
TICKRATE <- 0.1;
Limit_dist <- 50;
Idling <- false;
Prepering  <- false;
Shoot   <- false;
Shooting   <- false;
Reloading  <- false;
//////////////////////
//  Settings block  //
//////////////////////
Ammo        <- 1;
AmmoBackPack<- Ammo;
AmmoMax     <- 5;


Power       <- 0;
PowerMax    <- 3;
PowerTick   <- 0;

StatusBack  <- ["Reload","Ready","No ammo","Prepare"]
Status      <- StatusBack[1]
//////////////////////
//    Anims Block   //
//////////////////////
a_Idle      <- "idle";
a_Reload    <- "intro";
a_PreShoot  <- "preparetoshoot";
a_Shoot     <- "shoot";
//////////////////////
//    Main Block    //
//////////////////////
function filter()
{
    //printl("ti123cks Shot+ can");
    if(self.GetMoveParent().GetMoveParent() == activator)
    {
        if(Ammo == AmmoBackPack || Reloading || Prepering || AmmoMax == 0)return;
        SetAnimation(a_Reload);
        Reloading = true;
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
    //P();
    //testpaintred(Maker_h.GetOrigin(),Maker_h.GetOrigin()+Vector(0,0,5));
    if(Reloading)
    {
        Status = StatusBack[0];
    }
    else
    {
        if(Shoot && !HaveVelocity(Owner))
        {
            if(Ammo > 0)
            {

                if(!Prepering)
                {
                    SetAnimation(a_PreShoot);
                    EntFireByHandle(Model, "SetPlaybackRate", "0.7", 0, null, null);
                }
                Prepering = true;
                Idling = false
                if(PowerTick >= 1)
                {
                    PowerTick = 0;
                    if(Power + 1 <= PowerMax)Power++;
                    if(Power >=PowerMax )
                    {
                        //printl("Max")
                        EntFireByHandle(Model, "SetPlaybackRate", "8", 0, null, null);
                    }
                }
                else PowerTick += TICKRATE/2;
                if(Power >= 1 && !Shooting)
                {
                    EntFireByHandle(Effect, "Start", "", 0, null, null);
                    EntFireByHandle(Light, "TurnOn", "", 0, null, null);
                }
            }
        }
        else
        {
            Shoot = false;
            if(Power >=1)EntFireByHandle(Model, "SetPlaybackRate", "8", 0, null, null);
            else if(Prepering)
            {
                if(!Idling)
                {
                    SetAnimation(a_Idle);
                }
                Idling = true;
                Shooting = false;
                //printl("Dist")
                Prepering = false;
                Power = 0;
                PowerTick = 0;
                EntFireByHandle(Effect, "Stop", "", 0, null, null);
                EntFireByHandle(Light, "TurnOff", "", 0, null, null);
            }

        }

        if(Prepering)Status = StatusBack[3];
        else if(Ammo != 0)Status = StatusBack[1];
        else Status = StatusBack[2];
    }


    if(Ticking)
    {
        if(CheakItem())
        {
            if(GetDistance(Owner.GetOrigin(),Center_T.GetOrigin()) > Limit_dist || Owner.GetHealth() <= 0)
            {
                EntFireByHandle(Center_M, "ClearParent", "", 0, Owner, Owner);
                EntFireByHandle(Ui, "Deactivate", "", 0, Owner, Owner);
                EntFireByHandle(Effect, "Stop", "", 0, null, null);
                EntFireByHandle(Light, "TurnOff", "", 0, null, null);
                Owner = null;
                Ticking = false;
                Reloading = false;
                //printl("clearpar");
                Shoot = false;
                Shooting = false;
                Prepering = false;
                if(!Idling)
                {
                    SetAnimation(a_Idle);
                }
                Idling = true;

                SetPosM();
            }
            else
            {
                Text.__KeyValueFromString("message","[Ammo] "+Ammo+"/"+AmmoMax+"\n[Power] "+Power+"/"+PowerMax+"\n[Status] "+Status);
                EntFireByHandle(Text, "Display", "",0.01, Owner, Owner);
            }
        }
    }
}


//////////////////////
//   Handle block   //
//////////////////////
Owner   <- null;
Model   <- null;
Text   <- null;
Ui  <- null;
Effect  <- null;

Light  <- null;

Maker_e  <- null;
Maker_m  <- null;
Maker_h  <- null;

Center_T <- null;
Center_M <- null;

function SetHandle()
{
    local name = caller.GetName();
    if(name.find("item_bfg_effect") == 0)Effect = caller;
    if(caller.GetClassname() == "light_dynamic")Light = caller;
    if(name.find("item_bfg_maker_easy") == 0)Maker_e = caller;
    if(name.find("item_bfg_maker_medium") == 0)Maker_m = caller;
    if(name.find("item_bfg_maker_hard") == 0)Maker_h = caller;
    if(caller.GetClassname() == "prop_dynamic_glow")Model = caller;
    if(caller.GetClassname() == "game_ui")Ui = caller;
    if(caller.GetClassname() == "game_text")
    {
        Text = caller;
        //Ammo = AmmoBackPack;
    }
    if(name.find("item_bfg_center_move") == 0)Center_M = caller;
    if(name.find("item_bfg_distance") == 0)Center_T = caller;
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
    if(Prepering)
    {
        //printl("AnimComplete")
        local Velocity = Model.GetOrigin() - Owner.GetOrigin();
        Prepering = false;
        Shooting = false;
        Shoot = false;
        Idling = false;
        Velocity.Norm();
        EntFireByHandle(Owner,"AddOutput","basevelocity "+(-Velocity.x*Power*400).tostring()+" "+(-Velocity.y*Power*400).tostring()+" 50",0,null,null);
        EntFireByHandle(Effect, "Stop", "", 0, null, null);

        EntFireByHandle(Light, "TurnOff", "", 0, null, null);
        SetAnimation(a_Shoot);
        switch (Power)
        {
            case 1:
            {
                if(Ammo-1 >= 0)Ammo--;
                //Maker_e.SpawnEntityAtLocation(Shoot_Pos.GetOrigin(), Shoot_Pos.GetAngles())
                EntFireByHandle(Maker_e, "Forcespawn", "",0.01, null, null);
                break;
            }
            case 2:
            {
                if(Ammo-1 >= 0)Ammo--;
                //Maker_m.SpawnEntityAtLocation(Shoot_Pos.GetOrigin(), Shoot_Pos.GetAngles())
                EntFireByHandle(Maker_m, "Forcespawn", "",0.01, null, null);
                break;
            }
            case 3:
            {
                if(Ammo-1 >= 0)Ammo--;
                //Maker_h.SpawnEntityAtLocation(Shoot_Pos.GetOrigin(), Shoot_Pos.GetAngles())
                EntFireByHandle(Maker_h, "Forcespawn", "",0.01, null, null);
                break;
            }
        }
        Power = 0;
        PowerTick = 0;
    }
}
//////////////////////
// Handle Block End //
//////////////////////
function P()
{
    testpaintblue(Light.GetOrigin(),Light.GetOrigin()+Vector(0,0,5));
    ScriptPrintMessageCenterAll("Idling "+Idling.tostring()+"\nPrepering "+Prepering.tostring()+
    "\nShoot "+Shoot.tostring()+"\nReloading "+Reloading.tostring())
}

function testpaintblue(start,end) {DebugDrawLine(start,end, 0, 0, 255, true, 1)}
function testpaintred(start,end) {DebugDrawLine(start,end, 255, 0, 0, true, 4)}
