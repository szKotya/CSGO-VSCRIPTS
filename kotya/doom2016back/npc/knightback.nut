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
AnimDoing       <- false;
TARGET          <- null;
RETARGET        <- 0;

Attacking       <- false;
JumpAttacking   <- false;
Idling          <- false;
Triggering      <- false;

Jumping         <- false;
Jumptime        <- 0;
JumpCast        <- false;
Airblock        <- false;

CanForward      <- true;
CanSide         <- true;
//////////////////////
//  Settings block  //
//////////////////////
TAR_DISTANCE    <- 1024;

RETARGET_TIME 	<- 12.00;
debug           <- true;

JAA_CAN         <- true;
JAA_CD          <- 12;
JAA_DMG         <- 40;
JAA_RAD         <- 200;
JAA_PUSH        <- 400;

AE_DMG          <- 40;
AE_RAD          <- 150;
AE_PUSH         <- 400;
//////////////////////
//   Handle block   //
//////////////////////
Hurt             <- null;
Model            <- null;
Keeper           <- null;
tf               <- null;
ts               <- null;
tu               <- null;
function SetHandle()
{
    local name = caller.GetName();
    if(caller.GetClassname() == "trigger_hurt")Hurt = caller;
    if(caller.GetClassname() == "prop_dynamic_glow")Model = caller;
    if(caller.GetClassname() == "phys_keepupright")Keeper = caller;
    if(caller.GetClassname() == "phys_thruster" && name.find("npc_knight_thruster_forward") == 0)tf = caller;
    if(caller.GetClassname() == "phys_thruster" && name.find("npc_knight_thruster_side") == 0)ts = caller;
    if(caller.GetClassname() == "phys_thruster" && name.find("npc_knight_thruster_up") == 0)tu = caller;
}
//////////////////////
// Handle Block End //
//////////////////////

//////////////////////
//    Anims Block   //
//////////////////////
Run         <- "charge";    //бег
HitAndJump  <- "jumpattack";
Idle        <- "idle";      //айдал
Attack      <- "attack";    //атака1
Taunt       <- "taunt";    //берсер мод
FindTarget  <- "reaction"; //нашел врага
Attack2     <- "ydarvebalo";//Удар в пол
Die1        <- "die";      //смерть1
Die2        <- "die2";       //смерть2
//////////////////////
//    Main Block    //
//////////////////////
function Start()
{
  if(!Ticking)
	{
		if(debug)ScriptPrintMessageChatAll("Start");
		Ticking = true;
        AnimDoing = false;
		Tick();
        // if(RandomInt(0,1))
        // {
        //     Laying = true;
        //     SetAnimation(Lay);
        //     SetDefAnimation(LayIdle);
        // }
	}
}
function Tick()
{
    if(!Ticking)return;

    if(Jumping)
	{
		if(TraceLine(GVO(self.GetOrigin(),0,0,-8),GVO((self.GetOrigin()+(self.GetForwardVector()*128)),0,0,-8),self)<1.00)
			Airblock = true;
		else Airblock = false;
		if(TraceLine(self.GetOrigin(),GVO(self.GetOrigin(),0,0,-32),self)<1.00)
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
    if(!JumpCast && !JumpAttacking)EntFireByHandle(tu,"Deactivate","",0.00,null,null);
    if(TARGET==null||!TARGET.IsValid()||TARGET.GetHealth()<=0.00||TARGET.GetTeam()!=3||RETARGET>=RETARGET_TIME)SearchTARGET()
    if(TARGET==null||!TARGET.IsValid()||TARGET.GetHealth()<=0.00||TARGET.GetTeam()!=3||RETARGET>=RETARGET_TIME)
        EntFireByHandle(self,"RunScriptCode"," Tick() ",TICKRATE_IDLE,null,null);
    else
    {
        if(CanSide)
        {
            local sa=self.GetAngles().y;
            local ta=GetTARGETYaw(self.GetOrigin(),TARGET.GetOrigin());
            local ang=abs((sa-ta+360)%360);

            if(ang>=180)EntFireByHandle(ts,"AddOutput","angles 0 270 0",0.00,null,null);
            else EntFireByHandle(ts,"AddOutput","angles 0 90 0",0.00,null,null);

            local angdif=(sa-ta-180);
            while(angdif>360){angdif-=180;}
            while(angdif< -180){angdif+=360;}
            angdif=abs(angdif);
            EntFireByHandle(ts,"AddOutput","force "+(20*angdif*SPEED_TURNING).tostring(),0.00,null,null);
            EntFireByHandle(ts,"Activate","",0.02,null,null);
        }

        local tdist = GetDistance(self.GetOrigin(),TARGET.GetOrigin());
        local tdist2d = GetDistance2D(self.GetOrigin(),TARGET.GetOrigin());
		local tdistz = (TARGET.GetOrigin().z-self.GetOrigin().z);

        if(CanForward && !Airblock)
        {
            EntFireByHandle(tf,"AddOutput","force "+(2000*SPEED_FORWARD).tostring(),0.00,null,null);
            EntFireByHandle(tf,"Activate","",0.02,null,null);
        }
        if(!Attacking && !Triggering && !JumpAttacking && !Jumping)
        {
            Airblock = false;
            Jumptime = 0;
            if(TraceLine(self.GetOrigin(),GVO(self.GetOrigin(),0,0,-64),self)==1.00)Jumping = true;
            else if(tdist>50)
            {
                if(CheckPit())SetJump()

                else if(CheckHurdle())SetJump()
            }
            if(tdistz<80)
            {
                if(tdist2d < 110)
                {
                    SetAttack()
                }
                else if (tdist2d < 800 && tdist2d > 600 && JAA_CAN)
                {
                    SetJumpAttack()
                }
            }
        }
        if(!Attacking && !Jumping && !JumpAttacking)RETARGET+=TICKRATE;
        if(RETARGET>=RETARGET_TIME)TARGET = null;
        EntFireByHandle(self,"RunScriptCode","Tick();",TICKRATE,null,null);
    }
}
//////////////////////
//  Attacks Block   //
//////////////////////
function Dying()
{
    if(Ticking)return;
    EntFireByHandle(ts,"Kill","",0,null,null);
    EntFireByHandle(tf,"Kill","",0,null,null);
    EntFireByHandle(tu,"Kill","",0,null,null);
    EntFireByHandle(Model,"SetGlowEnabled","",3,null,null);
    EntFireByHandle(Model,"ClearParent","",4.1,null,null);
    EntFireByHandle(Model,"FadeAndKill","",4.2,null,null);

    EntFireByHandle(self,"Kill","",4.2+0.1,null,null);
    EntFireByHandle(Keeper,"Kill","",4.2+0.1+0.01,null,null);


    if(RandomInt(0,1))SetAnimation(Die1);
    else SetAnimation(Die2);
}

function SetAttack()
{
    CanForward = false;
    Attacking = true;
    SetAnimation(Attack2);
    local loc = (self.GetOrigin()+self.GetForwardVector()*40);
    EntFireByHandle(self,"RunScriptCode","Detect("+AE_RAD.tostring()+","+AE_PUSH.tostring()+","+AE_DMG.tostring()+")",1,null,null);
}

function SetJumpAttack()
{
    SPEED_FORWARD = 1.3;
    CanSide = false;
    JAA_CAN = false;
    JumpAttacking = true;
    EntFireByHandle(tu,"AddOutput","force 3000",0.2-0.01,null,null);
    EntFireByHandle(tu,"Activate","",0.2,null,null);
    EntFireByHandle(tu,"Deactivate","",0.4,null,null);
    EntFireByHandle(ts,"Deactivate","",0.01,null,null);
    SetAnimation(HitAndJump);
    EntFireByHandle(tf,"AddOutput","force -200",1,null,null);
    EntFireByHandle(tf,"AddOutput","force -200",1,null,null);
    EntFireByHandle(tf,"Activate","",1.01,null,null);
    EntFireByHandle(tf,"Deactivate","",1.12,null,null);
    EntFireByHandle(self,"RunScriptCode","CanForward = false",0.99,null,null)
    EntFireByHandle(self,"RunScriptCode","SPEED_FORWARD = 1;",1.12,null,null);
    //EntFireByHandle(self,"RunScriptCode","CanForward = true",1.6,null,null);
    EntFireByHandle(self,"RunScriptCode","Detect("+JAA_RAD.tostring()+","+JAA_PUSH.tostring()+","+JAA_DMG.tostring()+")",1.3,null,null);
}

function Detect(radius,Push,Health)
{
    local loc = Vector(0,0,0);
    if(JumpAttacking)loc = (self.GetOrigin()+self.GetForwardVector()*60);
    else if(Attacking)loc = (self.GetOrigin()+self.GetForwardVector()*40);

    if(debug)testpaintblue(loc,loc+Vector(0,0,100));
    local h = null;
	while(null!=(h=Entities.FindInSphere(h,loc,radius)))
    {
        if(h.GetClassname()=="player"&&h.GetTeam()==3&&h.GetHealth()>0)
        EntFireByHandle(self,"RunScriptCode","DamageAndPush("+loc.x+","+loc.y+","+loc.z+","+Push.tostring()+","+Health.tostring()+");",0,h,h);
    }
}

function DamageAndPush(locx,locy,locz,Power,Health)
{
    local hp=activator.GetHealth()-Health;
    if(hp<=0)
	{
		EntFireByHandle(activator,"SetHealth","0",0.00,null,null);
        return;
	}
    EntFireByHandle(activator,"SetHealth",hp.tostring(),0.00,null,null);
    local vec = Vector(locx,locy,locz) - activator.GetOrigin();
    vec.Norm();
    EntFireByHandle(activator,"AddOutput","basevelocity "+
    (-vec.x*Power).tostring()+" "+
    (-vec.y*Power).tostring()+" "+
    (Power*0.8).tostring(),0,null,null);
}


function SetJump()
{
    if(!Jumping && !JumpCast && !Attacking)
    {
        Jumping = true;
        JumpCast = true;
        if(debug)ScriptPrintMessageChatAll("low");
        if(RandomInt(0,1))
        {
            //SetAnimation(Jump1);
            EntFireByHandle(tu,"AddOutput","force 6000",0.05-0.01,null,null);
            EntFireByHandle(tu,"Activate","",0.05,null,null);
            EntFireByHandle(tu,"Deactivate","",0.2,null,null);
            EntFireByHandle(self,"RunScriptCode","JumpCast = false",2,null,null);
        }
        else
        {
            //SetAnimation(Jump2);
            EntFireByHandle(tu,"AddOutput","force 6000",0.15-0.01,null,null);
            EntFireByHandle(tu,"Activate","",0.15,null,null);
            EntFireByHandle(tu,"Deactivate","",0.3,null,null);
            EntFireByHandle(self,"RunScriptCode","JumpCast = false",2,null,null);
        }
    }
}

function SetHighJump()
{
    if(!Jumping && !JumpCast)
    {
        if(debug)ScriptPrintMessageChatAll("high");
        Jumping = true;
        JumpCast = true;
        EntFireByHandle(tu,"AddOutput","force 10000",3.7-0.01,null,null);
        EntFireByHandle(tu,"Activate","",3.7,null,null);
        EntFireByHandle(tu,"Deactivate","",3.8,null,null);
        EntFireByHandle(self,"RunScriptCode","JumpCast = false",5,null,null);
    }
}
//////////////////////
// Attacks Block End//
//////////////////////

function SearchTARGET()
{
	if(debug)ScriptPrintMessageChatAll("SearchTARGET");
    RETARGET = 0;
	TARGET = null;
	local h = null;
	local candidates = [];
	while(null!=(h=Entities.FindInSphere(h,self.GetOrigin(),TAR_DISTANCE)))
	{
		if(h.GetClassname()=="player" && h.GetTeam()==3 && h.GetHealth()>0)
		{
			candidates.push(h);
		}
	}
	if(candidates.len()==0)
    {
        Triggering = false;
        if(!Idling)
        {
            SetDefAnimation(Idle);
            SetAnimation(Idle);
        }
        Idling = true;
    }
    else
    {
        TARGET=candidates[RandomInt(0,candidates.len()-1)];
        Idling = false;
        EntFireByHandle(self,"RunScriptCode","CanSide = false;",0.1,null,null);
        CanForward = false;
        if(!Triggering)
        {
            SetDefAnimation(Run);
            SetAnimation(FindTarget);
        }
        Triggering = true;
    }
}

function AnimComplete()
{
    if(Idling)return;
    if(!Ticking)return;
    if(debug)ScriptPrintMessageChatAll("AnimComplete");
    if(Attacking)
    {
        Attacking = false;
        CanForward = true;
    }

    if(Triggering)
    {
        CanSide = true;
        CanForward = true;
        Triggering = false;
    }
    if(JumpAttacking)
    {
        EntFireByHandle(self,"RunScriptCode","JAA_CAN = true",JAA_CD,null,null);
        CanSide = true;
        CanForward = true;
        JumpAttacking = false;
    }

}
/*

if(TraceLine(GVO((self.GetOrigin()+(self.GetForwardVector()*100)),0,0,-16),GVO((self.GetOrigin()+(self.GetForwardVector()*100)),0,0,-45),Model)==1 && tdist<100)

*/
function CheckPit()
{
    local a = GVO(self.GetOrigin(),0,0,-7);
    local b = GVO((self.GetOrigin()+(self.GetForwardVector()*100)),0,0,-16);
    testpaintblue(b,b+Vector(0,0,-30));
    //testpaintred(b,c);
    ScriptPrintMessageCenterAll("Blue : "+TraceLine(b,b+Vector(0,0,-30),Model));
    if(TraceLine(b,b+Vector(0,0,-30),Model)==1)return true;
    else return false;

}
/*

if(TraceLine(GVO(self.GetOrigin(),0,0,-7),GVO((self.GetOrigin()+(self.GetForwardVector()*200)),0,0,-7),Model)<=0.4
&& TraceLine(GVO(self.GetOrigin(),0,0,-7),GVO((self.GetOrigin()+(self.GetForwardVector()*32)),0,0,-7),Model)>=0.8)

*/

function CheckHurdle()
{
    local a = GVO(self.GetOrigin(),0,0,-7);
    local b = GVO((self.GetOrigin()+(self.GetForwardVector()*200)),0,0,-7);
    local c = GVO((self.GetOrigin()+(self.GetForwardVector()*32)),0,0,-7);

    if(debug)testpaintblue(GVO(self.GetOrigin(),0,0,-7),b);
    if(debug)testpaintred(GVO(self.GetOrigin(),0,0,-7),c);
    if(debug)ScriptPrintMessageCenterAll("Blue : "+TraceLine(a,b,Model)+"\nRed : "+TraceLine(a,c,Model));

    if(TraceLine(a,b,Model)<=0.4 && TraceLine(a,c,Model)>=0.8)return true;
    else return false;
}

function SetDefAnimation(animationName)EntFireByHandle(Model,"SetDefaultAnimation",animationName.tostring(),0.01,null,null);
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

function testpaintblue(start,end) {DebugDrawLine(start,end, 0, 0, 255, true, 1)}
function testpaintred(start,end) {DebugDrawLine(start,end, 255, 0, 0, true, 1)}
function GVO(vec,_x,_y,_z){return Vector(vec.x+_x,vec.y+_y,vec.z+_z);}
function GetDistance2D(v1,v2)return sqrt((v1.x-v2.x)*(v1.x-v2.x)+(v1.y-v2.y)*(v1.y-v2.y));
function GetDistance(v1,v2)return sqrt((v1.x-v2.x)*(v1.x-v2.x)+(v1.y-v2.y)*(v1.y-v2.y)+(v1.z-v2.z)*(v1.z-v2.z));
function InSight(start,target){if(TraceLine(start,target,self)<1.00)return false;return true;}