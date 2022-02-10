IncludeScript("kotya/doom2016/support/models.nut");
IncludeScript("kotya/doom2016/items/support/items.nut");
IncludeScript("kotya/doom2016/support/math.nut");

Forward <- false;
Back    <- false;
Right   <- false;
Left    <- false;
Attack1 <- false;
Attack2 <- false;

ButtonS <- false;
TICKRATE <- 0.05
Dist <- 0;
Hit <- 0;
Owner   <- null;
//////////////////////
//  Settings block  //
//////////////////////
PUSH_SCALE <- 35;

RSPAM_COUNT<-3;
RSPAM_CD <-10;
RSPAM_CAN<-true;
RSPAM_TOFUEL_MIN<-5;
RSPAM_FUEL_MINUS<-5;
RSPAM_INT_MAX<-0.20;
RSPAM_INT_MIN<-0.05;

R_CD <-5;
R_FUEL_MINUS<-1;
R_CAN<-true;

SIEGETICK <- 0;
SIEGE_TIME<- 3;

FUEL <- 15;
FUEL_TOFLY_MIN <- 2;
FUELTICK_UP <- 0;
FUELTICK_DOWN <- 0;
FUEL_MAX <- FUEL;
//////////////////////
//   Handle block   //
//////////////////////
Model   <- null;
Freeze  <- Entities.FindByName(null, "speedMod");
ArmHurt <- null;
FlyMod  <- null;
MeasureEye <- null;
Eye     <- null;
Sound   <- null;
HitPos  <- null;
Rocket_l<- null;
Rocket_r<- null;
Laser   <- [];
JetPack <- [];
Button  <- null;
Hbox             <- null;
function SetHandle()
{
    local name = caller.GetName();
    if(caller.GetClassname() == "func_physbox_multiplayer"){Hbox = caller;caller.SetOwner(self);}
    if(caller.GetClassname() == "prop_dynamic_glow")Model = caller;
    if(caller.GetClassname() == "trigger_hurt")ArmHurt = caller;
    if(caller.GetClassname() == "ambient_generic")Sound = caller;
    if(caller.GetClassname() == "func_water_analog")
    {
        FlyMod = caller;
        caller.SetOrigin(Vector(-9999,-9999,-9999));
    }
    if(caller.GetClassname() == "info_particle_system")JetPack.push(caller);
    if(caller.GetClassname() == "env_beam")Laser.push(caller);
    if(caller.GetClassname() == "func_button")Button = caller;
    if(name.find("item_revenant_rocket_l") == 0)Rocket_l = caller;
    if(name.find("item_revenant_rocket_r") == 0)Rocket_r = caller;
    if(caller.GetClassname() == "func_door" && name.find("item_revenant_eye") == 0)Eye = caller;
    if(caller.GetClassname() == "func_door" && name.find("item_revenant_eye_pos") == 0)HitPos = caller;
    if(caller.GetClassname() == "logic_measure_movement" && name.find("item_revenant_measure_eye") == 0)MeasureEye = caller;
}

//////////////////////
// Handle Block End //
//////////////////////
function filter()
{
    if(Button.GetMoveParent().GetMoveParent() == activator)
    {
        if(FlyIng)
        {

            SetFlyEnd();
        }
        else
        {
            if(FUEL >= FUEL_TOFLY_MIN)SetFly()
        }
    }
}
function Start()
{
    Owner = activator;
    Owner.__KeyValueFromString("targetname", "revenant_owner"+(self.GetName().slice(self.GetPreTemplateName().len(),self.GetName().len())).tostring());
    Spawning = true
    PlayNewSound(Sound,s_Pick,0.2);
    EntFireByHandle(Freeze, "ModifySpeed", "0", 0, Owner, Owner);
    if(RandomInt(0,1))SetAnimation(a_Spawn1);
    else SetAnimation(a_Spawn2);
    Casting = true;
    EntFireByHandle(MeasureEye, "SetMeasureTarget", Owner.GetName().tostring(), 0.02, Owner, Owner);
    Tick();
}
function Tick()
{
    try
    {
        if(Owner == null || !(Owner.IsValid()) || Owner.GetHealth() <= 0)return SetDeath();
        if(!Casting)
        {
            if(!FlyIng)
            {
                if(Forward || Back || Right || Left)
                {
                    if(!Running)
                    {
                        SetDefAnimation(a_Run);
                        SetAnimation(a_Run);
                    }
                    Running = true;
                    Idling = false;
                    if(Siege)LaserToggle(0,0.2);
                    Siege = false;
                    SIEGETICK = 0;
                }
                else if(Siege)
                {
                    if(SIEGETICK>=SIEGE_TIME)
                    {
                        SIEGETICK = 0;
                        PlayNewSound(Sound,s_Shoot,1);
                        EntFireByHandle(Rocket_l, "Forcespawn", "", 1, null, null);
                        EntFireByHandle(Rocket_r, "Forcespawn", "", 1, null, null);
                    }
                    else SIEGETICK += TICKRATE;
                }
                else
                {
                    SetIdel()
                }
                if(FUELTICK_UP >= 10)
                {
                    FUELTICK_UP = 0;
                    if(FUEL+1<=FUEL_MAX)FUEL++;
                }
                else if(FUEL_MAX != FUEL) FUELTICK_UP += TICKRATE;
            }
            else
            {
                if(FUELTICK_DOWN >= 1)
                {
                    FUELTICK_DOWN = 0;
                    if(FUEL-1>0)FUEL--;
                    else SetFlyEnd();
                }
                else FUELTICK_DOWN += TICKRATE;
                if(TraceLine(Owner.GetOrigin(),GVO(Owner.GetOrigin(),0,0,-48),Hbox)!=1.00)
                {
                SetFlyEnd()
                FreezeOwner(1,1.4);
                }
            }
            TraceDir(Owner.EyePosition(),Eye.GetForwardVector(),4096.00,Hbox);
            DebugDrawBox(Hit, Vector(-16,-16,-16), Vector(16,16,16), 0, 255, 255, 5, 0.50);
            HitPos.SetOrigin(Vector((Hit.x).tointeger(),(Hit.y).tointeger(),(Hit.z).tointeger()));
            local b_ar = Model.LookupAttachment("bone01");
            local b_al = Model.LookupAttachment("bone02");
            local pos_b_ar = Model.GetAttachmentOrigin(b_ar);
            local pos_b_al = Model.GetAttachmentOrigin(b_al);
            local ang_b_ar = Model.GetAttachmentAngles(b_ar);
            local ang_b_al = Model.GetAttachmentAngles(b_al);
            Rocket_l.SetOrigin(pos_b_al);
            Rocket_r.SetOrigin(pos_b_ar);
            Rocket_l.SetAngles(Eye.GetAngles().x,Eye.GetAngles().y,ang_b_al.z);
            Rocket_r.SetAngles(Eye.GetAngles().x,Eye.GetAngles().y,ang_b_ar.z);
            if(Attack1 || Attack2)EntFireByHandle(self, "RunScriptCode", "Attack();", TICKRATE, null, null);
        }
        if(Owner.GetBoundingMaxs().z<=56)
        {
            if(!ButtonS)
            {
                EntFireByHandle(Button, "Unlock", "", 0, null, null);
            }
            ButtonS = true;
        }
        else
        {
            if(ButtonS)
            {
                EntFireByHandle(Button, "Lock", "", 0, null, null);
            }
            ButtonS = false;
        }
        EntFireByHandle(self, "RunScriptCode", "Tick();", TICKRATE, null, null);
    }
    catch(error)
    {
        return SetDeath();
    }
}
function SetFly()
{
    local time = 1.4;
    FUELTICK_DOWN = 0;
    FlyIng = true;
    Idling = false;
    Siege = false;
    Running = false;
    Casting = true;
    SetAnimation(a_Up);
    SetDefAnimation(a_Fly);
    PlayNewSound(Sound,s_StartFly,time-0.5);
    JetPuckToggle(time+0.3,0)
    FreezeOwner(0,time);
    EntFireByHandle(self, "RunScriptCode", "FlyMod.SetOrigin(GVO(Owner.GetOrigin(),0,0,24));", time, null, null);
    EntFireByHandle(FlyMod, "SetParent", "!activator", time+0.01, Owner, Owner);
    EntFireByHandle(Owner,"AddOutput","basevelocity 0 0 370",time-0.5,null,null);
}

function SetFlyEnd()
{
    FUELTICK_UP = 0;
    FlyIng = false;
    Idling = false;
    Siege = false;
    Running = false;
    Casting = true;
    JetPuckToggle(0,0.01)
    SetAnimation(a_Down);
    EntFireByHandle(self, "RunScriptCode", "FlyMod.SetOrigin(Vector(-9999,-9999,-9999));", 0.01, null, null);
    EntFireByHandle(FlyMod, "ClearParent", "", 0, null, null);
}
function SetDeath()
{
    Owner.__KeyValueFromString("targetname", "player");
    EntFireByHandle(Owner, "SetDamageFilter", "", 0.00, null, null);
    EntFireByHandle(Owner, "AddOutput", "rendermode 0", 0.00, null, null);
    EntFireByHandle(Freeze, "ModifySpeed", "1", 0, Owner, Owner);
    EntFireByHandle(Owner, "SetHealth", "-1", 0.02, null, null);
    Casting = true;
    Owner = null;
    local Clean = [Rocket_l,Rocket_r,FlyMod,Eye,HitPos,Eye];
    for (local i=0; i<Clean.len(); i++)
    {
        Clean[i].Destroy()
    }
}
function SetIdel()
{
    Running = false;
    if(!Idling)
    {
        switch (RandomInt(0,2))
        {
            case 0:
            SetDefAnimation(a_Idle1);
            SetAnimation(a_Idle1);
            break;
            case 1:
            SetDefAnimation(a_Idle2);
            SetAnimation(a_Idle2);
            break;
            case 2:
            SetDefAnimation(a_Idle3);
            SetAnimation(a_Idle3);
            break;
        }
    }
    Idling = true;
}

function Attack()
{
    if(Casting)return;
    if(Attack2 && R_CAN && FUEL>0)
    {
        if(FlyIng)
        {
            if(FUEL-1>=0)FUEL--;
            else return;
            R_CAN = false;
            LaserToggle(0.01,1);
            PlayNewSound(Sound,s_Shoot,0.5);
            EntFireByHandle(self, "RunScriptCode", "R_CAN = true;", R_CD, null, null);
            EntFireByHandle(Rocket_l, "Forcespawn", "", 0.5, null, null);
            EntFireByHandle(Rocket_r, "Forcespawn", "", 0.5, null, null);
        }
        else if(TraceLine(Owner.GetOrigin(),GVO(Owner.GetOrigin(),0,0,-48),Hbox)!=1.00)
        {
            Idling = false;
            Running = false;
            if(!Siege)
            {
                FreezeOwner(0,1.5);
                Casting = true;
                SetDefAnimation(a_Shoot);
                SetAnimation(a_ShootPre);
                LaserToggle(0.01,0);
            }
            Siege = true;
        }
        return;
    }
    if(Attack1)
    {
        if(FlyIng)
        {
            if(RSPAM_CAN && FUEL>=RSPAM_TOFUEL_MIN)
            {
                if(FUEL-RSPAM_FUEL_MINUS>0)FUEL-=RSPAM_FUEL_MINUS;
                else FUEL=0;
                local time = 1;
                RSPAM_CAN = false;
                LaserToggle(0.01,0);
                PlayNewSound(Sound,s_RSPAM,0.45);
                for (local i=0; i<RSPAM_COUNT; i++)
                {
                    EntFireByHandle(self, "RunScriptCode", "SpawnRandomRocket() ", time, null, null);
                    time+=RandomFloat(RSPAM_INT_MIN,RSPAM_INT_MAX);
                }
                LaserToggle(0,time);
                EntFireByHandle(self, "RunScriptCode", "RSPAM_CAN = true;", time+RSPAM_CD, null, null);
            }
        }
        else
        {
            Idling = false;
            Running = false;
            Casting = true;
            SetAnimation(a_Attack);
            EntFireByHandle(ArmHurt,"Enable","",0.76,null,null);
            EntFireByHandle(ArmHurt,"Disable","",0.76+0.1,null,null);
        }
        return;
    }
}
function LaserToggle(a,b)
{
    for (local i=0; i<Laser.len(); i++)
    {
        if(a > 0)EntFireByHandle(Laser[i], "TurnOn", "", a, null, null)
        if(b > 0)EntFireByHandle(Laser[i], "TurnOff", "", b, null, null)
    }
}
function JetPuckToggle(a,b)
{
    for (local i=0; i<JetPack.len(); i++)
    {
        if(a > 0)EntFireByHandle(JetPack[i], "Start", "", a, null, null)
        if(b > 0)EntFireByHandle(JetPack[i], "Stop", "", b, null, null)
    }
}
function SpawnRandomRocket()
{
    local randomr = Vector(RandomInt(-2,2),RandomInt(-4,1),0);
    local randoml = Vector(RandomInt(-2,2),RandomInt(1,4),0);
    Rocket_l.SpawnEntityAtLocation(Rocket_l.GetOrigin(),Rocket_l.GetAngles()+randoml)
    Rocket_r.SpawnEntityAtLocation(Rocket_r.GetOrigin(),Rocket_r.GetAngles()+randomr)
}
//////////////////////
//    Anims Block   //
//////////////////////
Casting <- false;
Running  <- false;
Idling  <- false;
Spawning<- false;
FlyIng  <- false;
Siege<- false;

a_Shoot      <- "aim";      //Стреляет
a_ShootPre <- "aim_pre";    //Подготовка к стрельбе
a_Attack <- "attack";       //Атака лапкой

a_Jump   <- "dodje";        //Задоджил
a_Up      <- "preattackfly";//до полета
a_Fly     <- "flying";      //Летает
a_Down      <- "afterfly";  //После полета
a_Idle1         <- "idle";
a_Idle2         <- "idle_v2";
a_Idle3          <- "idle_v3";
a_Run         <- "run";
a_Spawn1       <- "rage"
a_Spawn2       <- "spawn"

function AnimComplete()
{
    if(Owner == null)return;
    if(Spawning)
    {
        Spawning = false;
        EntFireByHandle(Freeze, "ModifySpeed", "1", 0, Owner, Owner);
    }
    if(Casting)Casting = false;
}

SoundPath   <-  "*doom2016\\items\\zm\\revenant\\";
s_StartFly  <-  SoundPath+"startfly";
s_RSPAM     <-  SoundPath+"shootlaser";
s_Shoot     <-  SoundPath+"rocket";
s_Pick      <-  SoundPath+"revenant_pickedup";
s_AfterShoot<-  SoundPath+"revenant_aim";
