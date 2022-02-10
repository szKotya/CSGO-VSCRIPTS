

IncludeScript("kotya/doom2016/support/models.nut");
IncludeScript("kotya/doom2016/items/support/items.nut");
IncludeScript("kotya/doom2016/support/math.nut");

Ticking <- false;
TICKRATE <- 0.1;

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
function Reload()
{
    if(Ammo == AmmoBackPack || Reloading || Prepering || AmmoMax == 0)return;
    SetAnimation(a_Reload);
    Reloading = true;
    Idling = false;
}

function Pick()
{
    Owner = activator;
    Ticking = true;
    EntFireByHandle(self, "Activate", "", 0, Owner, Owner);
    EntFireByHandle(Text, "Display", "",0, Owner, Owner);
    PlayNewSound(Sound,s_pickedup,0.00);
    Tick()
}

function Drop()
{
    EntFireByHandle(self, "Deactivate", "", 0, Owner, Owner);
    EntFireByHandle(Effect, "Stop", "", 0, null, null);
    EntFireByHandle(Light, "TurnOff", "", 0, null, null);
    Owner = null;
    Ticking = false;
    Reloading = false;
    Shoot = false;
    Shooting = false;
    Prepering = false;
    Power = 0;
    PowerTick = 0;
    if(!Idling)
    {
        SetAnimation(a_Idle);
    }
    Idling = true;
}


function Tick()
{
    if(!Ticking)return

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
    EntFireByHandle(self, "RunScriptCode", "Tick();", TICKRATE, null, null);
    Text.__KeyValueFromString("message","[Ammo] "+Ammo+"/"+AmmoMax+"\n[Power] "+Power+"/"+PowerMax+"\n[Status] "+Status);
    EntFireByHandle(Text, "Display", "",0.01, Owner, Owner);
}


//////////////////////
//   Handle block   //
//////////////////////
Owner   <- null;
Model   <- null;
Text   <- null;
Effect  <- null;

Light  <- null;

Maker_e  <- null;
Maker_m  <- null;
Maker_h  <- null;
Sound <- null;

function SetHandle()
{
    local name = caller.GetName();
    if(name.find("item_bfg_effect") == 0)Effect = caller;
    if(caller.GetClassname() == "light_dynamic")Light = caller;
    if(name.find("item_bfg_maker_easy") == 0)Maker_e = caller;
    if(name.find("item_bfg_maker_medium") == 0)Maker_m = caller;
    if(name.find("item_bfg_maker_hard") == 0)Maker_h = caller;
    if(caller.GetClassname() == "prop_dynamic_glow")Model = caller;
    if(caller.GetClassname() == "ambient_generic")Sound = caller;
	if(caller.GetClassname() == "game_text")
    {
        Text = caller;
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
    if(Prepering)
    {
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
				PlayNewSound(Sound,s_shoot,0.00);
                break;
            }
            case 2:
            {
                if(Ammo-1 >= 0)Ammo--;
                //Maker_m.SpawnEntityAtLocation(Shoot_Pos.GetOrigin(), Shoot_Pos.GetAngles())
                EntFireByHandle(Maker_m, "Forcespawn", "",0.01, null, null);
				PlayNewSound(Sound,s_shoot,0.00);
                break;
            }
            case 3:
            {
                if(Ammo-1 >= 0)Ammo--;
                //Maker_h.SpawnEntityAtLocation(Shoot_Pos.GetOrigin(), Shoot_Pos.GetAngles())
                EntFireByHandle(Maker_h, "Forcespawn", "",0.01, null, null);
				PlayNewSound(Sound,s_shoot,0.00);
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

//////////////////////
//    Sounds Block  //
//////////////////////

SoundPath   <-  "*doom2016\\items\\hm\\bfg\\";
s_pickedup  <-  SoundPath+"pickedup";
s_shoot  <-  SoundPath+"shoot";