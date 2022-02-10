
IncludeScript("kotya/doom2016/support/models.nut");
IncludeScript("kotya/doom2016/items/support/items.nut");
IncludeScript("kotya/doom2016/support/math.nut");

Shoot   <- false;

Ticking <- false;
TICKRATE <- 0.1;
Idling <- false;
Shooting   <- false;
Reloading  <- false;
//////////////////////
//  Settings block  //
//////////////////////
Ammo        <- 8;
AmmoBackPack<- Ammo;
AmmoMax     <- 80;
AmmoTick    <- 0;

Sharapnel_count <- 10;
Sharapnel_min <- -1.5;
Sharapnel_max <- 1.5;

Delay_shoot <- 1.2;

StatusBack  <- ["Reload","Ready","No ammo"]
Status       <- StatusBack[1]

//////////////////////
//    Anims Block   //
//////////////////////
a_Idle      <- "idle";
a_Reload    <- "shoot2";
a_Shoot     <- "shoot";

//////////////////////
//    Main Block    //
//////////////////////
function Reload()
{
    if(Ammo == AmmoBackPack || Reloading || AmmoMax == 0)return;
    SetAnimation(a_Reload);
    Reloading = true;
    Shooting = false;
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
    Owner = null;
    Ticking = false;
    Reloading = false;
    Shoot = false;
    Shooting = false;
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
        if(!Shoot || Ammo == 0)
        {
            if(!Idling)
            {
                SetAnimation(a_Idle);
            }
            Idling = true;
        }

        if(Shoot && !Shooting && Ammo > 0)
        {
            if(Ammo -1 >= 0)Ammo--;

            Idling = false;
            SetAnimation(a_Shoot);
            Shooting = true;
            Shoot = false;
            PlayNewSound(Sound,s_shoot,0.00);
            EntFireByHandle(Effect, "Start", "", 0, null, null);
            EntFireByHandle(Effect, "Stop", "", 0.3, null, null);
            for (local i = 0; i<Sharapnel_count; i++)
            {
                Maker.SpawnEntityAtLocation(Maker.GetOrigin(),Maker.GetAngles()+Vector(RandomFloat(Sharapnel_min,Sharapnel_max),RandomFloat(Sharapnel_min,Sharapnel_max),0))
            }
            EntFireByHandle(self, "RunScriptCode", "Shooting = false", Delay_shoot, null, null);
        }
        if(Ammo != 0)Status = StatusBack[1];
        else Status = StatusBack[2];
    }

    Text.__KeyValueFromString("message","[Ammo] "+Ammo+"/"+AmmoMax+"\n[Status] "+Status)
    EntFireByHandle(Text, "Display", "",0.01, Owner, Owner);
    EntFireByHandle(self, "RunScriptCode", "Tick();", TICKRATE, null, null);
}

function AnimComplete()
{
    if(Reloading)
    {
        if(AmmoMax - AmmoBackPack - Ammo < 0)
        {
            AmmoMax = 0;
        }
        else
        {
           AmmoMax -= 1;
        }
        Ammo += 1;
        Shoot = false;
        Reloading = false;
        EntFireByHandle(Text, "Display", "",0.01, Owner, Owner);
        return;
    }
}

function Print()
{
    ScriptPrintMessageCenterAll("Shoot :"+Shoot+"\nShooting :"+Shooting);
}
//////////////////////
//   Handle block   //
//////////////////////
Owner   <- null;
Model   <- null;
Text   <- null;
Maker <- null;
Sound  <- null;
Effect  <- null;
function SetHandle()
{
    local name = caller.GetName();
    if(caller.GetClassname() == "info_particle_system")Effect = caller;
    if(caller.GetClassname() == "prop_dynamic_glow")Model = caller;
    if(caller.GetClassname() == "env_entity_maker")Maker = caller;
    if(caller.GetClassname() == "ambient_generic")Sound = caller;
	if(caller.GetClassname() == "game_text")
    {
        Text = caller;
        //Ammo = AmmoBackPack;
    }
}
//////////////////////
// Handle Block End //
//////////////////////

//////////////////////
//    Sounds Block  //
//////////////////////

SoundPath   <-  "*doom2016\\items\\hm\\shootgun\\";
s_pickedup  <-  SoundPath+"pickedup";
s_shoot  <-  SoundPath+"shoot";