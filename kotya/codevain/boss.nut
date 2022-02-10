////////////////////////////////////////////////////////////////////
//Moving NPC by Luffaren[STEAM_0:1:22521282]
////////////////////////////////////////////////////////////////////
//NPC by Kotya[STEAM_1:1:124348087]
//update 22.11 version 0.99b
////////////////////////////////////////////////////////////////////
TICKRATE 	    <- 0.10;
TICKRATE_DEF	<- TICKRATE;
SPEED_FORWARD 	<- 1.00;
SPEED_TURNING   <- 1.00;
Ticking         <- false;
AnimDoing       <- false;
TARGET          <- null;
RETARGET        <- 0;
Ultimate_CANCAST<- false;
//////////////////////
//  Settings block  //
//////////////////////
UNLOCK_ULTIMATE <- 5;
TARGET_DISTANCE <- 1024;
RETARGET_TIME 	<- 6.00;
debug           <- true;

Hoch_CANCAST    <- true;
Hoch_CD         <- 12;

Flame_CANCAST   <- true;
Flame_CD        <- 30;

GLOBAL_CANCAST  <- true;
GLOBAL_CD       <- 15;
//////////////////////
//   Handle block   //
//////////////////////
Model            <- null;
FlameTrigger     <- null;
FlameParticle    <- null;
FlameSound       <- null;
UltimateParticle <- null;
UltimateTrigger  <- null;
UltimateSound    <- null;
Hit1Trigger      <- null;
Hit1Sound        <- null;
DeathTrigger     <- null;
DeathSound       <- null;
ShootMaker       <- null;
ShootSound       <- null;
Keeper           <- null;
tf               <- null;
ts               <- null;





function SetHandle()
{
    local name = caller.GetName();
    if(caller.GetClassname() == "prop_dynamic")Model = caller;
    if(caller.GetClassname() == "info_particle_system" && name.find("flame") == 0)FlameParticle = caller;
    if(caller.GetClassname() == "info_particle_system" && name.find("ultimate") == 0)UltimateParticle = caller;
    if(caller.GetClassname() == "trigger_hurt" && name.find("flame") == 0)FlameTrigger = caller;
    if(caller.GetClassname() == "trigger_hurt" && name.find("Hit1") == 0)Hit1Trigger = caller;
    if(caller.GetClassname() == "trigger_hurt" && name.find("ultimate") == 0)UltimateTrigger = caller;
    if(caller.GetClassname() == "trigger_hurt" && name.find("deathtrig") == 0)DeathTrigger = caller;
    if(caller.GetClassname() == "env_entity_maker" && name.find("maker_shoot") == 0)ShootMaker = caller;

    if(caller.GetClassname() == "phys_keepupright")Keeper = caller;
    if(caller.GetClassname() == "phys_thruster" && name.find("tf") == 0)tf = caller;
    if(caller.GetClassname() == "phys_thruster" && name.find("ts") == 0)ts = caller;

    if(caller.GetClassname() == "ambient_generic" && name.find("sound_death") == 0)DeathSound = caller;
    if(caller.GetClassname() == "ambient_generic" && name.find("sound_flame") == 0)FlameSound = caller;
    if(caller.GetClassname() == "ambient_generic" && name.find("sound_ultima") == 0)UltimateSound = caller;
    if(caller.GetClassname() == "ambient_generic" && name.find("sound_hit") == 0)Hit1Sound = caller;
    if(caller.GetClassname() == "ambient_generic" && name.find("sound_shoot") == 0)ShootSound = caller;
}
//////////////////////
// Handle Block End //
//////////////////////

//////////////////////
//    Anims Block   //
//////////////////////
Attack1 <- "atack1";//Взмах руки
Attack2 <- "atack4";//Уебал пушкой
Ultimate <- "atack2";//Выпускает огонь
Stomped <- "atack3";//Топнул
Shoot <- "boss_shoot";
Flame <- "boss_flame";
Run <- "run";
Death <- "death";
//////////////////////
//    Main Block    //
//////////////////////
function Start()
{
  if(!Ticking)
	{
		if(debug)ScriptPrintMessageCenterAll("Start");
        EntFireByHandle(self,"RunScriptCode","Ultimate_CANCAST = true;",UNLOCK_ULTIMATE,null,null);
		Ticking = true;
        AnimDoing = false;
		Tick();
	}
}
function Tick()
{
    if(!Ticking)return;
    EntFireByHandle(tf,"Deactivate","",0.00,null,null);
	EntFireByHandle(ts,"Deactivate","",0.00,null,null);
    EntFireByHandle(self,"RunScriptCode","Tick();",TICKRATE,null,null);
    if(TARGET==null||!TARGET.IsValid()||TARGET.GetHealth()<=0.00||TARGET.GetTeam()!=3||RETARGET>=RETARGET_TIME)return SearchTARGET()

    if(!AnimDoing)EntFireByHandle(tf,"Activate","",0.02,null,null);
	EntFireByHandle(ts,"Activate","",0.02,null,null);
	local sa=self.GetAngles().y;
    local ta=GetTARGETYaw(self.GetOrigin(),TARGET.GetOrigin());
    local ang=abs((sa-ta+360)%360);
    if(ang>=180)EntFireByHandle(ts,"AddOutput","angles 0 270 0",0.00,null,null);
    else EntFireByHandle(ts,"AddOutput","angles 0 90 0",0.00,null,null);
    local angdif=(sa-ta-180);
    while(angdif>360){angdif-=180;}
    while(angdif< -180){angdif+=360;}
    angdif=abs(angdif);
    if(!AnimDoing)EntFireByHandle(tf,"AddOutput","force "+(1500*SPEED_FORWARD).tostring(),0.00,null,null);
	EntFireByHandle(ts,"AddOutput","force "+(50*angdif*SPEED_TURNING).tostring(),0.00,null,null);
    if(AnimDoing){return ScriptPrintMessageCenterAll("AnimDoing");}
    RETARGET+=TICKRATE;
    local tdist=GetDistance(self.GetOrigin(),TARGET.GetOrigin());
    if(GLOBAL_CANCAST && Ultimate_CANCAST)return AllBurn();
    if(GLOBAL_CANCAST && Hoch_CANCAST && tdist>500)return HendeHoch()
    if(GLOBAL_CANCAST && Flame_CANCAST && tdist<500 && tdist>250)return Flamethrower();
    if(tdist < 200)return Hit1()
}



//////////////////////
//  Attacks Block   //
//////////////////////
function Flamethrower()
{
    Flame_CANCAST = false;
    GLOBAL_CANCAST = false;
    AnimDoing = true;
    SPEED_TURNING = 0.6;
    TICKRATE = 0.2;
    EntFireByHandle(Model,"AddOutPut","OnAnimationDone move:RunScriptCode:Flame_CANCAST = true;:"+Flame_CD.tostring()+":1",0,null,null);
    //EntFireByHandle(self,"RunScriptCode","Flame_CANCAST = true;" ,Flame_CD,null,null);

    EntFireByHandle(FlameSound,"PlaySound","",2,null,null);
    EntFireByHandle(FlameSound,"PlaySound","",5,null,null);
    EntFireByHandle(FlameSound,"PlaySound","",8,null,null);
    EntFireByHandle(FlameParticle,"Start","",1.9,null,null);
    EntFireByHandle(FlameParticle,"Stop","",11,null,null);
    EntFireByHandle(FlameTrigger,"Enable","",1.9,null,null);
    EntFireByHandle(FlameTrigger,"Disable","",11,null,null);
    EntFireByHandle(self,"RunScriptCode","SPEED_TURNING = 0;" ,11,null,null);
    SetAnimation(Flame);
}

function AllBurn()
{
    Ultimate_CANCAST = false;
    GLOBAL_CANCAST = false;
    AnimDoing = true;
    SPEED_TURNING = 0;
    EntFireByHandle(UltimateSound,"PlaySound","",2,null,null);
    EntFireByHandle(UltimateParticle,"Start","",1.75,null,null);
    EntFireByHandle(UltimateParticle,"Stop","",5,null,null);
    EntFireByHandle(UltimateTrigger,"Enable","",1.75+0.05,null,null);
    EntFireByHandle(UltimateTrigger,"Disable","",5+0.05,null,null);
    SetAnimation(Ultimate);
}

function Hit1()
{
    AnimDoing = true;
    SPEED_TURNING = 0.6;
    TICKRATE = 0.2;
    EntFireByHandle(Hit1Sound,"PlaySound","",2.4,null,null);
    EntFireByHandle(Hit1Trigger,"Disable","",2.4,null,null);
    EntFireByHandle(Hit1Trigger,"Enable","",2.32,null,null);
    EntFireByHandle(Hit1Trigger,"Disable","",2.4,null,null);
    EntFireByHandle(self,"RunScriptCode","SPEED_TURNING = 0;" ,2.2,null,null);
    SetAnimation(Attack1);
}

function HendeHoch()
{
    Hoch_CANCAST = false;
    GLOBAL_CANCAST = false;
    AnimDoing = true;
    TICKRATE = 0.2;
    SPEED_TURNING = 0.6;

    EntFireByHandle(ShootSound,"PlaySound","" ,1.4,null,null);
    EntFireByHandle(Model,"AddOutPut","OnAnimationDone move:RunScriptCode:Hoch_CANCAST = true;:"+Hoch_CD.tostring()+":1",0,null,null);
    //EntFireByHandle(self,"RunScriptCode","Hoch_CANCAST = true;" ,Hoch_CD,null,null);

    EntFireByHandle(self,"RunScriptCode","ShootMaker.SpawnEntity();" ,1.55,null,null);
    EntFireByHandle(self,"RunScriptCode","SPEED_TURNING = 0;" ,1.55,null,null);
    SetAnimation(Shoot);
}

//////////////////////
// Attacks Block End//
//////////////////////
function AnimComplete()
{
    if(!Ticking)return;
    AnimDoing = false;
    SPEED_TURNING = 1;
    TICKRATE = TICKRATE_DEF;
    EntFireByHandle(self,"RunScriptCode","GLOBAL_CANCAST = true;" ,GLOBAL_CD,null,null);
}

function SearchTARGET()
{
	if(debug)ScriptPrintMessageCenterAll("SearchTARGET");
    RETARGET = 0;
	TARGET = null;
	local h = null;
	local candidates = [];
	while(null!=(h=Entities.FindInSphere(h,self.GetOrigin(),TARGET_DISTANCE)))
	{
		if(h.GetClassname()=="player" && h.GetTeam()==3 && h.GetHealth()>0)
		{
			candidates.push(h);
		}
	}
	if(candidates.len()==0)return;
	else
	TARGET=candidates[RandomInt(0,candidates.len()-1)];
}

function Dying()
{
    if(!Ticking)return;
    EntFireByHandle(DeathSound,"PlaySound","",1,null,null);
    EntFireByHandle(Model,"FadeAndKill","",9.8,null,null);
    EntFireByHandle(Model,"ClearParent","",0,null,null);
    EntFireByHandle(self,"Kill","",0.01,null,null);
    EntFireByHandle(Keeper,"Kill","",0.01,null,null);
    EntFireByHandle(ts,"Kill","",0.01,null,null);
    EntFireByHandle(tf,"Kill","",0.01,null,null);
    EntFireByHandle(DeathTrigger,"ClearParent","",0,null,null);
    EntFireByHandle(DeathTrigger,"Enable","",6.35,null,null);
    EntFireByHandle(DeathTrigger,"Kill","",7,null,null);

    EntFireByHandle(FlameSound,"Kill","",0.01,null,null);
    EntFireByHandle(UltimateSound,"Kill","",0.01,null,null);
    EntFireByHandle(Hit1Sound,"Kill","",0.01,null,null);
    EntFireByHandle(ShootSound,"Kill","",0.01,null,null);
    EntFireByHandle(DeathSound,"Kill","",5.01,null,null);
    SetAnimation(Death);
}

function Push(Power)
{
    local vec=self.GetOrigin() - activator.GetOrigin();
    vec.Norm();
    EntFireByHandle(activator,"AddOutput","basevelocity "+
    (-vec.x*Power).tostring()+" "+
    (-vec.y*Power).tostring()+" "+
    (Power-(Power/3)).tostring(),0,null,null);
}

function SetAnimation(animationName)EntFireByHandle(Model,"SetAnimation",animationName.tostring(),0.00,null,null);

function GetTARGETYaw(start,TARGET)
{
	local yaw=0.00;
	local v=Vector(start.x-TARGET.x,start.y-TARGET.y,start.z-TARGET.z);
	local vl=sqrt(v.x*v.x+v.y*v.y);
	yaw=180*acos(v.x/vl)/3.14159;
	if(v.y<0)yaw=-yaw;
	return yaw;
}

function GetDistance(v1,v2)return sqrt((v1.x-v2.x)*(v1.x-v2.x)+(v1.y-v2.y)*(v1.y-v2.y)+(v1.z-v2.z)*(v1.z-v2.z));
