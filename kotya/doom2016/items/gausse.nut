
IncludeScript("kotya/doom2016/support/models.nut");
IncludeScript("kotya/doom2016/items/support/items.nut");
IncludeScript("kotya/doom2016/support/math.nut");

Shoot   <- false;

Ticking <- false;
TICKRATE <- 0.1;

Idling <- false;
Reloading  <- false;
Scoping    <- false;
//////////////////////
//  Settings block  //
//////////////////////
Scope_CD    <- 10;
Def_CD      <- 4;

StatusBack  <- ["Reload","Ready"]
Status       <- StatusBack[1]

//////////////////////
//    Anims Block   //
//////////////////////
a_Idle      <- "idle";
a_ToIdle    <- "to_idle";
a_PickUp    <- "intro";

a_Shoot    <- "shoot_delay";       //слабый выстрел

a_ShootScope   <- "shoot_to_ballista"; //стреляем
a_OutScope    <- "fire_into";         //Выход из фулл зарядки
a_InScope    <- "fire_out";          //Вход в фулл зарядку
a_IdleScope <- "";


//////////////////////
//    Main Block    //
//////////////////////
function Reload()
{
    Reloading = false;
    Shoot = false;
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
    EntFireByHandle(Scope, "Disable", "", 0, Owner, Owner);
    Owner = null;
    Scoping = false;
    Ticking = false;
    Shoot = false;
    if(!Idling)
    {
        SetDefAnimation(a_Idle);
        SetAnimation(a_ToIdle);
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
        Status = StatusBack[1];
        if(Shoot && !Reloading)
        {
            if(Scoping)
            {
                SetAnimation(a_ShootScope);
                PlayNewSound(Sound,s_shoot,0.00);
                EntFireByHandle(MakerSniper, "ForceSpawn", "", 0.1, null, null);
                EntFireByHandle(self, "RunScriptCode", "Reload();", Scope_CD, null, null);
            }
            else
            {
                SetAnimation(a_Shoot);
                PlayNewSound(Sound,s_shoot,0.00);
                EntFireByHandle(Maker, "ForceSpawn", "", 0.25, null, null);
                EntFireByHandle(self, "RunScriptCode", "Reload();", Def_CD, null, null);
            }
            Idling = false;
            Reloading = true;
        }
    }
    Text.__KeyValueFromString("message","[Status]"+Status)
    EntFireByHandle(Text, "Display", "",0.01, Owner, Owner);
    EntFireByHandle(self, "RunScriptCode", "Tick();", TICKRATE, null, null);
}


function ScopeToggle()
{
    if(Scoping)
    {
        EntFireByHandle(Scope, "Disable", "", 0, Owner, Owner);
        SetDefAnimation(a_Idle);
        EntFireByHandle(self, "RunScriptCode", "SetAnimation(a_ToIdle);", 0.5, null, null);
        Scoping = false;
    }
    else
    {
        EntFireByHandle(Scope, "Enable", "", 0, Owner, Owner);
        SetAnimation(a_InScope);
        SetDefAnimation(a_IdleScope);
        Scoping = true;
    }
}

//////////////////////
//   Handle block   //
//////////////////////
Scope <- Entities.CreateByClassname("point_viewcontrol");
    Scope.__KeyValueFromString("targetname", "Scope"+(self.GetName().slice(self.GetPreTemplateName().len(),self.GetName().len())).tostring());
    Scope.__KeyValueFromString("fov", "15");
    Scope.__KeyValueFromString("fov_rate", "2");
    Scope.__KeyValueFromString("spawnflags", "128");
    Scope.SetOrigin(self.GetOrigin());
Measure <- null;
Owner   <- null;
Model   <- null;
Text    <- null;
Maker   <- null;
MakerSniper<- null;
Sound   <- null;

function SetHandle()
{
    local clas = caller.GetClassname();
    if(clas == "logic_measure_movement")
    {
        Measure = caller;
        EntFireByHandle(Measure, "SetTarget", Scope.GetName(), 0.02, null, null);
    }

    if(clas == "prop_dynamic_glow")Model = caller;
    if(clas == "env_entity_maker")
    {
        local name = caller.GetName();
        if(name.find("item_gausse_sniper_maker") == 0)MakerSniper  = caller;
        else Maker  = caller;
    }

    if(clas == "ambient_generic")Sound = caller;
	if(clas == "game_text")
    {
        Text = caller;
    }
}
//////////////////////
// Handle Block End //
//////////////////////

//////////////////////
//    Sounds Block  //
//////////////////////

SoundPath   <-  "*doom2016\\items\\hm\\ballista\\";
s_pickedup  <-  SoundPath+"pickedup";
s_reload  <-  SoundPath+"reload";
s_shoot  <-  SoundPath+"shoot";