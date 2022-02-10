
IncludeScript("kotya/doom2016/support/models.nut");
IncludeScript("kotya/doom2016/items/support/items.nut");
IncludeScript("kotya/doom2016/support/math.nut");

Shoot   <- false;

Ticking <- false;
TICKRATE <- 0.1;

Idling <- false;
Shooting   <- false;
Reloading  <- false;
OverHeating <- false;
//////////////////////
//  Settings block  //
//////////////////////
Ammo        <- 1000;
AmmoBackPack<- Ammo;
AmmoMax     <- 1500;
AmmoTick    <- 0;

OverHeat_DMG <- 2;
OverHeat     <- 0;
OverHeatMax  <- 10;
OverTick     <- 0;
OverTickShoot<- 0;
SoundTick    <- 0;

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
function Reload()
{
    if(Ammo == AmmoBackPack || Reloading || AmmoMax == 0)return;
    SetAnimation(a_Reload);
    Reloading = true;
    Shooting = false;
    Idling = false;
    PlayNewSound(Sound,s_reload,0.00);
}

function Pick()
{
    Owner = activator;
    Ticking = true;
    EntFireByHandle(self, "Activate", "", 0.01, Owner, Owner);
    EntFireByHandle(Text, "Display", "",0.01, Owner, Owner);
	PlayNewSound(Sound,s_pickedup,0.00);
    Tick()
}
function Drop()
{
    EntFireByHandle(self, "Deactivate", "", 0, Owner, Owner);
    EntFireByHandle(Hurt, "Disable", "", 0, null, null);
    EntFireByHandle(Effect, "Stop", "", 0, null, null);
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
        if(Shoot && !OverHeating && Ammo > 0)
        {
            if(Ammo-1 >= 0)Ammo--;

            Idling = false;
            if(!Shooting)
            {
                SoundTick = 1;
                SetDefAnimation(a_Shoot);
                SetAnimation(a_Shoot);
            }
            if(SoundTick >= 1*0.6)
            {
                SoundTick = 0
                PlayNewSound(Sound,s_shoot,0.00);
            }
            else SoundTick += TICKRATE;
            EntFireByHandle(Hurt, "Enable", "", 0, null, null);
            EntFireByHandle(Effect, "Start", "", 0, null, null);
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
                    Idling = true;
                    OverHeating = true;
                    EntFireByHandle(self, "RunScriptCode", "OverHeating = false;", 15, null, null);
                }
            }
            else OverTick += TICKRATE*2;
        }
        if(Ammo != 0 && !OverHeating)Status = StatusBack[1];
        else if (Ammo == 0)Status = StatusBack[2];
        else Status = StatusBack[3];

    }

    if(!Shoot || Ammo == 0)
    {
        EntFireByHandle(Hurt, "Disable", "", 0, null, null);
        EntFireByHandle(Effect, "Stop", "", 0, null, null);
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
    EntFireByHandle(self, "RunScriptCode", "Tick();", TICKRATE, null, null);
    Text.__KeyValueFromString("message","[Ammo] "+Ammo+"/"+AmmoMax+"\n[Overheat] "+OverHeat+"/"+OverHeatMax+"\n[Status] "+Status)
    EntFireByHandle(Text, "Display", "",0.01, Owner, Owner);
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
Effect  <- null;
Sound <- null;

function SetHandle()
{
    local name = caller.GetName();
    if(caller.GetClassname() == "info_particle_system")Effect = caller;
    if(caller.GetClassname() == "prop_dynamic_glow")Model = caller;
    if(caller.GetClassname() == "trigger_hurt")Hurt = caller;
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

SoundPath   <-  "*doom2016\\items\\hm\\minigun\\";
s_pickedup  <-  SoundPath+"pickedup";
s_shoot  <-  SoundPath+"shoot";
s_reload  <-  SoundPath+"reload";