
IncludeScript("kotya/doom2016/support/models.nut");
IncludeScript("kotya/doom2016/items/support/items.nut");
IncludeScript("kotya/doom2016/support/math.nut");

Shoot   <- false;

Ticking <- false;
TICKRATE <- 0.1;
Limit_dist <- 50;
Idling <- false;
Reloading  <- false;
//////////////////////
//  Settings block  //
//////////////////////
Ammo        <- 1;
AmmoBackPack<- Ammo;
AmmoMax     <- 20;

StatusBack  <- ["Reload","Ready","No ammo"]
Status       <- StatusBack[1]

//////////////////////
//    Anims Block   //
//////////////////////
a_Idle      <- "idle";
a_PickUp    <- "intro";
a_Shoot     <- "shoot_delay";
a_Reload    <- "cycle";
//////////////////////
//    Main Block    //
//////////////////////
function Reload()
{
    if(Ammo == AmmoBackPack || Reloading || AmmoMax == 0)return;
    SetAnimation(a_Reload);
    Reloading = true;
    Idling = false;
    PlayNewSound(Sound,s_reload,0.00);
}

function Pick()
{
    Owner = activator;
    Ticking = true;
    EntFireByHandle(self, "Activate", "", 0, Owner, Owner);
    EntFireByHandle(Text, "Display", "",0, Owner, Owner);
    SetAnimation(a_PickUp);
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
        if(Shoot)
        {
            if(Ammo > 0)
            {
                if(Ammo-1 >= 0)Ammo--;
                Idling = false;
                SetAnimation(a_Shoot);
                EntFireByHandle(Maker, "ForceSpawn", "", 0.25, null, null);
                PlayNewSound(Sound,s_shoot,0.00);
                Shoot = false;
            }
            else
            {
                if(Rocket != null && Rocket.IsValid())
                {
                    EntFireByHandle(Rocket, "FireUser1", "",0.01, Owner, Owner);
                    Rocket = null;
                }
            }
        }
        else
        {
            if(!Idling)
            {
                SetDefAnimation(a_Idle);
            }
            Idling = true;
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
Rocket  <- null;
Owner   <- null;
Model   <- null;
Text    <- null;
Maker   <- null;
Sound   <- null;

function SetRocket()
{
    Rocket = activator;
}

function SetHandle()
{
    local clas = caller.GetClassname();
    if(clas == "prop_dynamic_glow")Model = caller;
    if(clas == "env_entity_maker")Maker = caller;
    if(clas == "ambient_generic")Sound = caller;
	if(clas == "game_text")
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

SoundPath   <-  "*doom2016\\items\\hm\\rocket\\";
s_pickedup  <-  SoundPath+"pickedup";
s_reload  <-  SoundPath+"reload";
s_shoot  <-  SoundPath+"shoot";