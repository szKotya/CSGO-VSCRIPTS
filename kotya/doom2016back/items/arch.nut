
IncludeScript("kotya/doom2016/support/models.nut");
IncludeScript("kotya/doom2016/support/items.nut");
IncludeScript("kotya/doom2016/support/math.nut");

Forward <- false;
Back    <- false;
Right   <- false;
Left    <- false;
Attack1 <- false;
Attack2 <- false;

Casting <- false;
Attacking <-false;
Running  <- false;
Idling  <- false;
Spawning   <- false;

PUSH_SCALE <- 40;

Buff_Speed <- "1.5";
Buff_Time  <- 5;
Buff_Work  <- false;
Buff_CD    <- "30";
Buff_CAN   <- true;

FireBall_CD    <- "10";
FireBall_CAN   <- true;

FireLake_DIST <- 768
FireLake_CD    <- "45";
FireLake_CAN   <- true;

FireWave_CD <- "30";
FireWave_CAN <- true;

Sound_CD <- 12;
Sound_CAN <- true;

Dist <- 0;
Hit <- 0;
Owner   <- null;
//////////////////////
//   Handle block   //
//////////////////////
Model   <- null;
Sound   <- null;
SoundAttack  <- null;
Freeze  <- Entities.FindByName(null, "speedMod");
ArmHurt <- null;
FireBall <- null;
FireWave <- null;
FireLake <- null;
Parent  <- null;
Measure <- null;
MeasureEye <- null;
Eye <- null;
Hbox  <- null;
function SetHandle()
{
    local name = caller.GetName();
    if(caller.GetClassname() == "func_physbox_multiplayer"){Hbox = caller;caller.SetOwner(self);}
    if(caller.GetClassname() == "func_door" && name.find("item_arch_parent") == 0)Parent = caller;
    if(caller.GetClassname() == "func_door" && name.find("item_arch_eye") == 0)Eye = caller;
    if(caller.GetClassname() == "ambient_generic" && name.find("item_arch_sound_attack") == 0)SoundAttack = caller;
    if(caller.GetClassname() == "ambient_generic" && name.find("item_arch_sound") == 0)Sound = caller;
    if(caller.GetClassname() == "logic_measure_movement" && name.find("item_arch_measure") == 0)Measure = caller;
    if(caller.GetClassname() == "logic_measure_movement" && name.find("item_arch_measure_eye") == 0)MeasureEye = caller;
    if(caller.GetClassname() == "prop_dynamic_glow")Model = caller;
    if(caller.GetClassname() == "trigger_hurt")ArmHurt = caller;
    if(caller.GetClassname() == "env_entity_maker" && name.find("item_arch_fireball_maker") == 0)FireBall = caller;
    if(caller.GetClassname() == "env_entity_maker" && name.find("item_arch_firewave_maker") == 0)FireWave = caller;
    if(caller.GetClassname() == "env_entity_maker" && name.find("item_arch_firelake") == 0)FireLake = caller;
}


function AnimComplete()
{
    if(Owner == null)return;
    if(Spawning){Spawning = false;EntFireByHandle(Freeze, "ModifySpeed", "1", 0, Owner, Owner);}
    if(Casting)Casting = false;
}

//////////////////////
// Handle Block End //
//////////////////////
function Start()
{
    Owner = activator;
    Owner.__KeyValueFromString("targetname", "arch_owner"+(self.GetName().slice(self.GetPreTemplateName().len(),self.GetName().len())).tostring());
    Spawning = true
    EntFireByHandle(Freeze, "ModifySpeed", "0", 0, Owner, Owner);
    SetAnimation(a_Spawn1);
    Casting = true;
    SetNewParent(array = [ArmHurt,FireBall]);
    EntFireByHandle(Measure, "SetMeasureTarget", Owner.GetName().tostring(), 0.02, Owner, Owner);
    EntFireByHandle(MeasureEye, "SetMeasureTarget", Owner.GetName().tostring(), 0.02, Owner, Owner);
    Tick();
}

function Tick()
{
    if(Owner == null)return;
    if(!Casting)
    {
        if(Forward || Back || Right || Left)
        {
            if(!Running)
            {
                Running = true;
                if(Buff_Work)
                {
                    SetDefAnimation(a_Run2);
                    SetAnimation(a_Run2);
                }
                else
                {
                    SetDefAnimation(a_Run1);
                    SetAnimation(a_Run1);
                }
                Idling = false;
            }
        }
        else
        {
            Running = false;
            if(!Idling)
            {
                SetDefAnimation(a_Idle);
                SetAnimation(a_Idle);
            }
            Idling = true;
        }
        if(Attack1 || Attack2)EntFireByHandle(self, "RunScriptCode", "Attack();", 0.05, null, null);
    }
    if(Sound_CAN)PickRandomSound()
    // local Buff_Status;
    // local FireBall_Status;
    // local FireLake_Status;
    // local FireWave_Status;
    // if(Buff_CAN) Buff_Status = "[R]"
    // else Buff_Status = "[CD]"

    // if(FireBall_CAN) FireBall_Status = "[R]"
    // else FireBall_Status = "[CD]"

    // if(FireLake_CAN) FireLake_Status = "[R]"
    // else FireLake_Status = "[CD]"

    // if(FireWave_CAN) FireWave_Status = "[R]"
    // else FireWave_Status = "[CD]"

    // Text.__KeyValueFromString("message",
    //        "Buff "+Buff_Status
    // +"\nFireBall "+FireBall_Status
    // +"\nFireLake "+FireLake_Status
    // +"\nFireWave "+FireWave_Status);
    // EntFireByHandle(Text, "Display", "",0.01, Owner, Owner);
    EntFireByHandle(self, "RunScriptCode", "Tick();", 0.05, null, null);
}
function Attack()
{
    if(Casting)return;
    if(Attack1 && Attack2 && FireLake_CAN)
    {
        local time = 0.6;
        TraceDir(Owner.EyePosition(),Eye.GetForwardVector(),4096.00,Hbox);
        DebugDrawBox(Hit, Vector(-16,-16,-16), Vector(16,16,16), 0, 255, 255, 5, 0.50);
        //ScriptPrintMessageCenterAll("TRACE: "+Hit+"\nDIST: "+Dist)
        FireLake.SetOrigin(GVO(Hit,0,0,64));
        if(Dist > FireLake_DIST)return;
        Idling = false;
        Running = false;
        Casting = true;
        FireLake_CAN = false;
        PlayNewSound(SoundAttack,s_Bust,time);
        SetAnimation(a_FareLake);
        FreezeOwner(0,time)
        EntFireByHandle(FireLake, "Forcespawn", "", time, null, null);
        //EntFireByHandle(self, "RunScriptCode", "Running = false", time+Buff_Time, null, null);
        EntFireByHandle(Model,"AddOutPut","OnAnimationDone "+self.GetName().tostring()+":RunScriptCode:FireLake_CAN = true;:"+FireLake_CD+":1",0,null,null);
        return;
    }

    if(Back && Attack2 && Buff_CAN)
    {
        local time = 3.2;
        Idling = false;
        Running = false;
        Casting = true;
        Buff_CAN = false;
        Buff_Work = true;
        PlayNewSound(SoundAttack,s_Bust,time);
        SetAnimation(a_CastBuff);
        FreezeOwner(0,time)
        EntFireByHandle(Freeze, "ModifySpeed", Buff_Speed, time+0.01, Owner, Owner);
        EntFireByHandle(Freeze, "ModifySpeed", "1", time+Buff_Time, Owner, Owner);
        EntFireByHandle(self, "RunScriptCode", "Buff_Work = false", time+Buff_Time, null, null);
        //EntFireByHandle(self, "RunScriptCode", "Running = false", time+Buff_Time, null, null);
        EntFireByHandle(Model,"AddOutPut","OnAnimationDone "+self.GetName().tostring()+":RunScriptCode:Buff_CAN = true;:"+Buff_CD+":1",0,null,null);
        return;
    }

    if(Attack1 && (Left || Right) && FireWave_CAN)
    {
        local time = 0.1;
        local dir;
        Idling = false;
        Running = false;
        Casting = true;
        FireWave_CAN = false;
        FreezeOwner(0,2.1);
        PlayNewSound(SoundAttack,s_FireWave,time);
        if(Left)
        {
            dir = -50;
            SetAnimation(a_CastWaweLeft);
        }
        else
        {
            dir = 50
            SetAnimation(a_CastWaweRight);
        }
        EntFireByHandle(self,"RunScriptCode","FireWave.SpawnEntityAtLocation(FireWave.GetOrigin()+FireWave.GetLeftVector()*"+dir.tostring()+",FireWave.GetAngles())",time,null,null);
        EntFireByHandle(Model,"AddOutPut","OnAnimationDone "+self.GetName().tostring()+":RunScriptCode:FireWave_CAN = true;:"+FireWave_CD+":1",0,null,null);
        return;
    }

    if(Attack1)
    {
        Idling = false;
        Running = false;
        Casting = true;
        if(RandomInt(0,1))
        {
            Casting = true;
            SetAnimation(a_Attack1);
            EntFireByHandle(ArmHurt,"Enable","",0.1,null,null);
            EntFireByHandle(ArmHurt,"Disable","",0.1+0.1,null,null);
        }
        else
        {
            Casting = true;
            SetAnimation(a_Attack2);
            EntFireByHandle(ArmHurt,"Enable","",0.25,null,null);
            EntFireByHandle(ArmHurt,"Disable","",0.25+0.1,null,null);
        }
        return;
    }
    if(Attack2 && FireBall_CAN)
    {   Idling = false;
        Running = false;
        Casting = true;
        FireBall_CAN = false
        SetAnimation(a_CastFireBall);
        PlayNewSound(SoundAttack,s_FireBall,2);
        EntFireByHandle(Model,"AddOutPut","OnAnimationDone "+self.GetName().tostring()+":RunScriptCode:FireBall_CAN = true;:"+FireBall_CD+":1",0,null,null);
        EntFireByHandle(FireBall,"Forcespawn","",2,null,null);
        return;
    }
}
function SetDeath()
{
    local Clean = [Model,Sound,SoundAttack,ArmHurt,FireBall,FireWave,FireLake,Parent,Measure,MeasureEye,Eye];
    Owner.__KeyValueFromString("targetname", "");
    EntFireByHandle(Owner, "SetDamageFilter", "", 0.00, null, null);
    EntFireByHandle(Owner, "AddOutput", "rendermode 0", 0.00, null, null);
    EntFireByHandle(Freeze, "ModifySpeed", "1", 0, Owner, Owner);
    EntFireByHandle(Owner, "SetHealth", "-1", 0.02, null, null);
    Casting = true;
    Owner = null;
    for (local i=0; i<Clean.len(); i++)
    {
        Clean[i].Destroy()
    }
}
function PickRandomSound()
{
    if(RandomSound.len() <= 1) PushSounds(15);
    local Random = RandomInt(0,RandomSound.len()-1);
    Sound_CAN = false
    PlayNewSound(Sound,RandomSound[Random],0);
    EntFireByHandle(self, "RunScriptCode", "Sound_CAN = true", Sound_CD, null, null);
    RandomSound.remove(Random);
}
//////////////////////
//    Anims Block   //
//////////////////////
a_Attack1      <- "attack";           //Удар 2мя
a_Attack2      <- "attack2";          //Удар лапкой
a_CastFireBall <- "attackfire";       //Каст Фаербола
a_CastWaweLeft <- "attackfireleft";   //Каст волны
a_CastWaweRight<- "attackfireright";  //Каст волны
a_CastBuff     <- "buff";             //Баф себя
a_Idle         <- "idle";             //айдал
a_Run1         <- "run";              //бег
a_Run2         <- "run2";             //бег
a_Summon       <- "summons";
a_Spawn1       <- "spawn"
a_FareLake     <- "spawn1"
//////////////////////
//    Sounds Block  //
//////////////////////

SoundPath   <-  "*doom2016\\items\\zm\\archville\\";
s_Bust      <-  SoundPath+"bust";
s_FireBall  <-  SoundPath+"fireball";
s_FireWave  <-  SoundPath+"firepol";
s_Random    <-  SoundPath+"random";