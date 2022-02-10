
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
Owner   <- null;
Model   <- null;
Text   <- null;
Maker <- null;
Sound  <- null;

function SetHandle()
{
    local name = caller.GetName();
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

SoundPath   <-  "*doom2016\\items\\hm\\plasma\\";
s_pickedup  <-  SoundPath+"pickedup";
s_reload  <-  SoundPath+"reload";