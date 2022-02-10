IncludeScript("kotya/doom2016/support/models.nut");
//IncludeScript("kotya/doom2016/support/math.nut");

////////////////////////////////////////////////////////////////////
//Moving NPC by Luffaren[STEAM_0:1:22521282]
////////////////////////////////////////////////////////////////////
//NPC by Kotya[STEAM_1:1:124348087]
//update 22.11 version 0.99b
////////////////////////////////////////////////////////////////////
TICKRATE 	    <- 0.15;
TICKRATE_IDLE 	<- 5;
SPEED_FORWARD 	<- 1;
SPEED_TURNING   <- 1;
Ticking         <- false;
TARGET          <- null;
RETARGET        <- 0;

Laying          <- false;
Attacking       <- false;
Idling          <- false;
Walking         <- false;

Jumping         <- false;
Jumptime        <- 0;
JumpCast        <- false;
Airblock        <- false;

CanForward      <- true;
CanSide         <- true;
//////////////////////
//  Settings block  //
//////////////////////
CHANCE_SLEEP    <- 30;

TAR_DISTANCE    <- 512;
TAR_DISTANCE_Lay<- 126;

RETARGET_TIME 	<- 6.00;
debug           <- false;
//////////////////////
//   Handle block   //
//////////////////////
Hurt             <- null;
Model            <- null;
Keeper           <- null;
tf               <- null;
ts               <- null;
tu               <- null;
Hbox             <- null;
Soundattaks		 <- null;
function SetHandle()
{
    local name = caller.GetName();
    if(caller.GetClassname() == "func_physbox_multiplayer")Hbox = caller;
    if(caller.GetClassname() == "trigger_hurt")Hurt = caller;
    if(caller.GetClassname() == "prop_dynamic")Model = caller;
    if(caller.GetClassname() == "phys_keepupright")Keeper = caller;
    if(caller.GetClassname() == "phys_thruster" && name.find("npc_zombiesc_thruster_forward") == 0)tf = caller;
    if(caller.GetClassname() == "phys_thruster" && name.find("npc_zombiesc_thruster_side") == 0)ts = caller;
    if(caller.GetClassname() == "phys_thruster" && name.find("npc_zombiesc_thruster_up") == 0)tu = caller;
	if(caller.GetClassname() == "ambient_generic" && name.find("item_zmsc_sound_attack") == 0)Soundattaks = caller;
}
//////////////////////
// Handle Block End //
//////////////////////

//////////////////////
//    Sounds Block  //
//////////////////////

SoundPath   <-  "*doom2016\\npc\\zombies\\";
s_agr  <-  SoundPath+"random1";
s_agr1  <-  SoundPath+"random2";
s_agr2  <-  SoundPath+"random4";
s_agr3  <-  SoundPath+"random5";
s_agr4  <-  SoundPath+"random6";
s_agr5  <-  SoundPath+"random8";
s_shoot  <-  SoundPath+"trybasognem";
s_die  <-  SoundPath+"random10";
s_die  <-  SoundPath+"random9";
s_die  <-  SoundPath+"random7";

//////////////////////
//    Anims Block   //
//////////////////////
Run         <- "walk";      //походка
Wake1       <- "spawn";     //встал уебал1
Wake2       <- "spawn1";    //встал уебал2
JumpUp1     <- "jumpscrap"; //перепрыгнул вверх
JumpUp2     <- "jump3";     //перепрыгнул вверх
JumpDone    <- "jump3_ot";  //анимка после залезания вверх
Jump1       <- "jump2";     //перепрыгнул дырку1
Jump2       <- "jump";      //перепрыгнул дырку2
Idle        <- "idle";      //айдал
Lay         <- "disapear";  //прилег
LayIdle     <- "disapear_loop";  //прилег idl
Die1        <- "die3";      //смерть1
Die2        <- "die";       //смерть2
Attack1     <- "attack";    //атака1
Attack2     <- "attack2";   //атака2
//////////////////////
//    Main Block    //
//////////////////////
function Start()
{
  if(!Ticking)
	{
		//if(debug)ScriptPrintMessageChatAll("Start");
		Ticking = true;
		Tick();
        if(RandomInt(0,1))
        {
            Laying = true;
            SetAnimation(Lay);
            SetDefAnimation(LayIdle);
        }
	}
}
function Tick()
{
    if(!Ticking)return;
    if(Jumping)
	{
		if(TraceLine(GVO(self.GetOrigin(),0,0,-8),GVO((self.GetOrigin()+(self.GetForwardVector()*128)),0,0,-8),Hbox)<1.00)
			Airblock = true;
		else Airblock = false;
		if(TraceLine(self.GetOrigin(),GVO(self.GetOrigin(),0,0,-32),Hbox)<1.00)
		{
			Jumping = false;
			Jumptime = 0;
		}
		else
		{
			if(Jumptime<10)Jumptime++;
            EntFireByHandle(tu,"AddOutput","force "+((-Jumptime)*200),0.00,null,null);
            EntFireByHandle(tu,"Activate","",0.01,null,null);
		}
	}

    EntFireByHandle(tf,"Deactivate","",0.00,null,null);
	EntFireByHandle(ts,"Deactivate","",0.00,null,null);
    if(!JumpCast)EntFireByHandle(tu,"Deactivate","",0.00,null,null);
    if(TARGET==null||!TARGET.IsValid()||TARGET.GetHealth()<=0.00||TARGET.GetTeam()!=3||RETARGET>=RETARGET_TIME)SearchTARGET()
    if(TARGET==null||!TARGET.IsValid()||TARGET.GetHealth()<=0.00||TARGET.GetTeam()!=3||RETARGET>=RETARGET_TIME)
        EntFireByHandle(self,"RunScriptCode"," Tick() ",TICKRATE_IDLE,null,null);
    else
    {
        local sa=self.GetAngles().y;
        local ta=GetTargetYaw(self.GetOrigin(),TARGET.GetOrigin());
        local ang=abs((sa-ta+360)%360);

        if(ang>=180)EntFireByHandle(ts,"AddOutput","angles 0 270 0",0.00,null,null);
        else EntFireByHandle(ts,"AddOutput","angles 0 90 0",0.00,null,null);

        local angdif=(sa-ta-180);
        while(angdif>360){angdif-=180;}
        while(angdif< -180){angdif+=360;}
        angdif=abs(angdif);

        local tdist = GetDistance(self.GetOrigin(),TARGET.GetOrigin());
        local tdist2d = GetDistance2D(self.GetOrigin(),TARGET.GetOrigin());
		local tdistz = (TARGET.GetOrigin().z-self.GetOrigin().z);

        if(!Attacking)EntFireByHandle(tf,"AddOutput","force "+(1100*SPEED_FORWARD).tostring(),0.00,null,null);

        EntFireByHandle(ts,"AddOutput","force "+(20*angdif*SPEED_TURNING).tostring(),0.00,null,null);

        if(!Attacking && !Laying && !Airblock)EntFireByHandle(tf,"Activate","",0.02,null,null);

        if(!Attacking && !Laying)EntFireByHandle(ts,"Activate","",0.02,null,null);
        if(!Jumping && !Attacking)
        {
            Airblock = false;
            Jumptime = 0;
            if(TraceLine(self.GetOrigin(),GVO(self.GetOrigin(),0,0,-64),Hbox)==1.00)Jumping = true;
            else if(tdist>50)
            {
                if(CheckPit())SetJump()

                else if(CheckHurdle())SetJump()
            }
        }
        if(!Attacking && !Jumping)SetAttack()
        if(!Attacking)RETARGET+=TICKRATE;
        if(RETARGET>=RETARGET_TIME)TARGET = null;
        EntFireByHandle(self,"RunScriptCode","Tick();",TICKRATE,null,null);
    }
}

//////////////////////
//  Attacks Block   //
//////////////////////
function SetBown()
{
    Laying = true;
    SetAnimation(Lay);
    SetDefAnimation(LayIdle);
}
function SetDeath()
{
    Ticking = false;
    if(RandomInt(0,1))
    {
        EntFireByHandle(tf,"Deactivate","",0.00,null,null);
        EntFireByHandle(ts,"Deactivate","",0.00,null,null);
        EntFireByHandle(tu,"Deactivate","",0.00,null,null);

        EntFireByHandle(tf,"AddOutput","angles 0 0 0",0.00,null,null);
        EntFireByHandle(tf,"AddOutput","force 1500",0.00,null,null);
        EntFireByHandle(tf,"Activate","",0.01,null,null);
        EntFireByHandle(tf,"Deactivate","",0.1,null,null);

        EntFireByHandle(Model,"FadeAndKill","",3.4,null,null);

        EntFireByHandle(self,"Kill","",3.5,null,null);
        EntFireByHandle(Keeper,"Kill","",3.5+0.01,null,null);

        EntFireByHandle(ts,"Kill","",3.5+0.01,null,null);
        EntFireByHandle(tf,"Kill","",3.5+0.01,null,null);
        EntFireByHandle(tu,"Kill","",3.5+0.01,null,null);
        SetAnimation(Die1);
    }
    else
    {
        EntFireByHandle(tf,"Deactivate","",0.00,null,null);
        EntFireByHandle(ts,"Deactivate","",0.00,null,null);
        EntFireByHandle(tu,"Deactivate","",0.00,null,null);

        EntFireByHandle(tf,"AddOutput","angles 0 180 0",0.00,null,null);
        EntFireByHandle(tf,"AddOutput","force 2500",0.00,null,null);
        EntFireByHandle(tf,"Activate","",0.01,null,null);
        EntFireByHandle(tf,"Deactivate","",0.1,null,null);

        EntFireByHandle(Model,"FadeAndKill","",1.8,null,null);

        EntFireByHandle(self,"Kill","",1.9,null,null);
        EntFireByHandle(Keeper,"Kill","",1.9+0.01,null,null);

        EntFireByHandle(ts,"Kill","",1.9+0.01,null,null);
        EntFireByHandle(tf,"Kill","",1.9+0.01,null,null);
        EntFireByHandle(tu,"Kill","",1.9+0.01,null,null);
        SetAnimation(Die2);
    }

}

function SetAttack()
{
    local tdist = GetDistance(self.GetOrigin(),TARGET.GetOrigin());
    if(Laying)
    {
        if(tdist<100)
        {
            Attacking = true;
            SetDefAnimation(Run);
            local time = 0;
            if(RandomInt(0,1))
            {
                time = 1.2;
                EntFireByHandle(Hurt,"Enable","",time,null,null);
                EntFireByHandle(Hurt,"Disable","",time+0.1,null,null);
                EntFireByHandle(Hurt,"Enable","",time+0.8,null,null);
                EntFireByHandle(Hurt,"Disable","",time+0.8+0.1,null,null);
                SetAnimation(Wake1);
            }
            else
            {
                time = 2;
                EntFireByHandle(Hurt,"Enable","",time,null,null);
                EntFireByHandle(Hurt,"Disable","",time+0.1,null,null);
                EntFireByHandle(Hurt,"Enable","",time+0.8,null,null);
                EntFireByHandle(Hurt,"Disable","",time+0.8+0.1,null,null);
                SetAnimation(Wake2);
            }
            EntFireByHandle(self,"RunScriptCode","Laying = false;",time-1,null,null);
            //EntFireByHandle(self,"RunScriptCode","SPEED_FORWARD = 1;",time+0.5,null,null);
            //EntFireByHandle(self,"RunScriptCode","SPEED_TURNING = 1;",time+0.5,null,null);
        }
    }
    else
    {
        if(tdist<50)
        {
            Attacking = true;
            if(RandomInt(0,1))
            {
                EntFireByHandle(Hurt,"Enable","",0.6,null,null);
                EntFireByHandle(Hurt,"Disable","",0.6+0.1,null,null);
                SetAnimation(Attack1);
            }
            else
            {
                EntFireByHandle(Hurt,"Enable","",0.95,null,null);
                EntFireByHandle(Hurt,"Disable","",0.95+0.1,null,null);
                SetAnimation(Attack2);
            }
        }
    }
}
function SetJump()
{
    if(!Jumping && !JumpCast && !Attacking)
    {
        Jumping = true;
        JumpCast = true;
        //ScriptPrintMessageChatAll("low");
        if(RandomInt(0,1))
        {
            SetAnimation(Jump1);
            EntFireByHandle(tu,"AddOutput","force 6000",0.05-0.01,null,null);
            EntFireByHandle(tu,"Activate","",0.05,null,null);
            EntFireByHandle(tu,"Deactivate","",0.1,null,null);
            EntFireByHandle(self,"RunScriptCode","JumpCast = false",2,null,null);
        }
        else
        {
            SetAnimation(Jump2);
            EntFireByHandle(tu,"AddOutput","force 6000",0.15-0.01,null,null);
            EntFireByHandle(tu,"Activate","",0.15,null,null);
            EntFireByHandle(tu,"Deactivate","",0.2,null,null);
            EntFireByHandle(self,"RunScriptCode","JumpCast = false",2,null,null);
        }
    }
}

function SetHighJump()
{
    if(!Jumping && !JumpCast)
    {
        //ScriptPrintMessageChatAll("high");
        Jumping = true;
        JumpCast = true;
        if(RandomInt(0,1))SetAnimation(JumpUp1);
        else SetAnimation(JumpUp2);
        EntFireByHandle(tu,"AddOutput","force 10000",3.7-0.01,null,null);
        EntFireByHandle(tu,"Activate","",3.7,null,null);
        EntFireByHandle(tu,"Deactivate","",3.8,null,null);
        EntFireByHandle(self,"RunScriptCode","JumpCast = false",5,null,null);
    }
}

function Upping()
{
    if(!JumpCast && Jumping)return;
    local dir = self.GetOrigin()-(caller.GetOrigin()+Vector(0,0,48));
    dir.Norm();
    self.SetForwardVector(dir);
    //if(debug)ScriptPrintMessageChatAll("Upping");
    local zup = caller.GetBoundingMaxs().z*2;
    EntFireByHandle(self,"DisableMotion","",0,null,null);
    for(local i = 0;i < zup;i++)self.SetOrigin(self.GetOrigin()-(self.GetForwardVector()*2));
    EntFireByHandle(self,"EnableMotion","",1.5,null,null);
}
//////////////////////
// Attacks Block End//
//////////////////////

function SearchTARGET()
{
	//if(debug)ScriptPrintMessageChatAll("SearchTARGET");
    RETARGET = 0;
	TARGET = null;
	local h = null;
	local candidates = [];
    local Radius = TAR_DISTANCE;
    local spos = GVO(self.GetOrigin(),0,0,80);
    if(Laying)Radius = TAR_DISTANCE_Lay;
	while(null!=(h=Entities.FindInSphere(h,self.GetOrigin(),Radius)))
	{
		if(h.GetClassname()=="player" && h.GetTeam()==3 && h.GetHealth()>0)
		{
            if(InSight(spos,GVO(h.GetOrigin(),0,0,48)))
			candidates.push(h);
		}
	}
	if(candidates.len()==0)
    {
        if(!Laying)
        {
            if(RandomInt(1,100)>100-CHANCE_SLEEP)
            {
                Laying = true;
                SetAnimation(Lay);
                SetDefAnimation(LayIdle);
            }
            else
            {
                Walking = false;
                if(!Idling)
                {
                    SetDefAnimation(Idle);
                    SetAnimation(Idle);
                }
                Idling = true;
            }
            CHANCE_SLEEP=-1;
        }
    }
    else
    {
        TARGET=candidates[RandomInt(0,candidates.len()-1)];
        if(!Laying)
        {
            Idling = false;
            if(!Walking)
            {
                SetDefAnimation(Run);
                SetAnimation(Run);
            }
            Walking = true;
        }
    }
}

sethp           <- true;
HPBASE          <- 150;
HPPERHUMAN      <- 80;
function Target()
{

	if(activator!=null&&activator.IsValid()&&activator.GetClassname()=="player"&&activator.GetTeam()==3&&activator.GetHealth()>0)
    {
        if(TARGET==null)
        {
            RETARGET = 0;
            TARGET = activator;
            if(!Laying)
            {
                Idling = false;
                if(!Walking)
                {
                    SetDefAnimation(Run);
                    SetAnimation(Run);
                }
                Walking = true;
            }
        }
        if(sethp)
        {
            local ctcount=0;
            local hlist=[];
            local h=null;
            while(null!=(h=Entities.FindInSphere(h,self.GetOrigin(),TAR_DISTANCE*2)))
            {
                if(h.GetClassname()=="player"&&h.GetTeam()==3&&h.GetHealth()>0){ctcount++;}
            }
            sethp = false;
            EntFireByHandle(caller,"SetHealth",(HPBASE+(ctcount*HPPERHUMAN)).tostring(),0.1,null,null);
        }
    }
}


function AnimComplete()
{
    if(!Ticking)return;
    //ScriptPrintMessageChatAll("AnimComplete");
    if(Attacking)Attacking = false;
}

function CheckHurdle()
{
    local a = GVO(self.GetOrigin(),0,0,-7);
    local b = GVO((self.GetOrigin()+(self.GetForwardVector()*200)),0,0,-7);
    local c = GVO((self.GetOrigin()+(self.GetForwardVector()*32)),0,0,-7);


    //if(debug)ScriptPrintMessageCenterAll("Blue : "+TraceLine(a,b,Model)+"\nRed : "+TraceLine(a,c,Model));

    if(TraceLine(a,b,Hbox)<=0.4 && TraceLine(a,c,Hbox)>=0.8)return true;
    else return false;
}

function CheckPit()
{
    local a = GVO(self.GetOrigin(),0,0,-7);
    local b = GVO((self.GetOrigin()+(self.GetForwardVector()*100)),0,0,-16);
    //testpaintred(b,c);
    //ScriptPrintMessageCenterAll("Blue : "+TraceLine(b,b+Vector(0,0,-30),Model));
    if(TraceLine(b,b+Vector(0,0,-30),Hbox)==1)return true;
    else return false;
}


function testpaintblue(start,end) {DebugDrawLine(start,end, 0, 0, 255, true, 1)}
function testpaintred(start,end) {DebugDrawLine(start,end, 255, 0, 0, true, 1)}

function GetTargetYaw(start,TARGET)
{
	local yaw=0.00;
	local v=Vector(start.x-TARGET.x,start.y-TARGET.y,start.z-TARGET.z);
	local vl=sqrt(v.x*v.x+v.y*v.y);
	yaw=180*acos(v.x/vl)/3.14159;
	if(v.y<0)yaw=-yaw;
	return yaw;
}
function GetDistance2D(v1,v2)return sqrt((v1.x-v2.x)*(v1.x-v2.x)+(v1.y-v2.y)*(v1.y-v2.y));

function GetDistance(v1,v2)return sqrt((v1.x-v2.x)*(v1.x-v2.x)+(v1.y-v2.y)*(v1.y-v2.y)+(v1.z-v2.z)*(v1.z-v2.z));

function InSight(start,target){if(TraceLine(start,target,Hbox)<1.00)return false;return true;}

function GVO(vec,_x,_y,_z){return Vector(vec.x+_x,vec.y+_y,vec.z+_z);}