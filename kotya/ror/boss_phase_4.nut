TICKRATE 	<- 	0.10;
TARGET_DISTANCE <- 	2048;
RETARGET_TIME 	<- 	15.00;
MIN_SPEED		<- 	2;
MAX_STOP_TIME	<- 	2.00;
///////////////////
HitBox <- null;
Model <- null;
tf <- null;
ts <- null;
Kepper <- null;
Sound0 <- null; //run
Sound1 <- null; //Cast
BallMaker <- null;
Part <- null;

///////////////////
function SetHandlePart()Part = caller;
function SetHandleTs()ts = caller;
function SetHandleTf()tf = caller;
function SetHandleKepper()Kepper = caller;
function SetHandleModel()Model = caller;
function SetHandleBallMaker(){BallMaker = caller;ScriptPrintMessageChatAll("ball");printball()}
function SetHandleHitbox()HitBox = caller;
function SetHandleSound0()Sound0 = caller;
function SetHandleSound1()Sound1 = caller;
///////////////////
target <- null;
ttime <- 0.00;
ticking <- false;
canmove <- true;
counter <- 0.00;
lastpos <- self.GetOrigin();
//////////////////
//Phase 4/////////
//////////////////
Lunar_Ball <- false;
//////////////////
//////////////////
LUNAR_BALL_CD <- true;
LUNAR_BALL_CDBACK <- 20;
LUNAR_BALL_CASTTIME <- 3.5;
//LUNAR_BALL_CASTTIME <- 10.5;
//////////////////
CHAT_CD <- true;
CHAT_CDBACK <- 15;
//////////////////
//////////////////////////////////////
function Start()
{
  if(!ticking)
	{
		ScriptPrintMessageChatAll("Start");
		EntFireByHandle(Sound1,"PlaySound","",0.00,null,null);
		EntFireByHandle(Model,"SetAnimation","phase_loop",5.50,null,null);
		EntFireByHandle(Part,"Start","",5.4,null,null);
		EntFireByHandle(Part,"kill","",8,null,null);
		EntFireByHandle(Model,"SetDefaultAnimation","phase_loop",5.55,null,null);
		EntFireByHandle(Model,"SetAnimation","phase_toidle",8.00,null,null);
		EntFireByHandle(Sound1,"StopSound","",8.00,null,null);
		EntFireByHandle(self,"RunScriptCode","StartTICK();",11.00,null,null);
	}
}
function StartTICK()
{
	if(!ticking)
	{
		ticking = true;
		EntFireByHandle(Sound0,"PlaySound","",0.00,null,null);
		EntFireByHandle(Model,"SetAnimation","walk",0.01,null,null);
		EntFireByHandle(Model,"SetDefaultAnimation","walk",1.00,null,null);
		EntFire("HPCONTROL", "Runscriptcode", "Start(2)", 0.00,null)
		Tick();
	}
}

function Stop()
{
    if(ticking)
    {
			ScriptPrintMessageChatAll("MITHRIX: "+DeadMessage[RandomInt(0,DeadMessage.len()-1)].tostring());
			EntFireByHandle(Sound0,"Voice","0",0.00,null,null);
			EntFireByHandle(Sound0,"StopSound","",0.00,null,null);
			EntFireByHandle(Sound1,"Voice","0",0.01,null,null);
			EntFireByHandle(Sound1,"StopSound","",0.01,null,null);
			ScriptPrintMessageChatAll("Stop");
			ticking = false;
			EntFireByHandle(tf,"Kill","",0.00,null,null);
			EntFireByHandle(Model,"ClearParent","",0.00,null,null);
			EntFireByHandle(Model,"SetAnimation","death_start",0.00,null,null);
			EntFireByHandle(Model,"SetDefaultAnimation","death_channel",0.01,null,null);
			EntFireByHandle(Model,"FadeAndKill","",15.40,null,null);
			EntFireByHandle(Kepper,"Kill","",0.00,null,null);
			EntFireByHandle(ts,"Kill","",0.00,null,null);
			EntFireByHandle(HitBox,"Kill","",0.00,null,null);
			EntFireByHandle(Sound0,"Kill","",0.01,null,null);
			EntFireByHandle(Sound1,"Kill","",0.01,null,null);
			EntFireByHandle(self,"Kill","",0.02,null,null);
    }
}
function Tick()
{
	if(ticking)
		EntFireByHandle(self,"RunScriptCode","Tick();",TICKRATE,null,null);
	else
	{
		EntFireByHandle(tf,"Deactivate","",0.00,null,null);
		EntFireByHandle(ts,"Deactivate","",0.00,null,null);
		return;
	}
	SpawnRandMessage();
	if(canmove)
	{
		if(GetDistance(self.GetOrigin(),lastpos) < MIN_SPEED)
			counter += 0.10;
		else counter = 0.00;

		if(counter > MAX_STOP_TIME)
		{
			EntFireByHandle(ts,"Deactivate","",0.00,null,null);
			EntFireByHandle(ts,"AddOutput","force 4000",0.01,null,null);
			EntFireByHandle(ts,"Activate","",0.02,null,null);
		}
		lastpos = self.GetOrigin();
		EntFireByHandle(tf,"Deactivate","",0.00,null,null);
		EntFireByHandle(ts,"Deactivate","",0.00,null,null);
		if(target==null||!target.IsValid()||target.GetHealth()<=0.00||target.GetTeam()!=3||ttime>=RETARGET_TIME)
		return SearchTarget();
		ttime+=TICKRATE;
		EntFireByHandle(tf,"Activate","",0.02,null,null);
		EntFireByHandle(ts,"Activate","",0.02,null,null);
		local sa = self.GetAngles().y;
		local ta = GetTargetYaw(self.GetOrigin(),target.GetOrigin());
		local ang = abs((sa-ta+360)%360);
		if(ang>=180)EntFireByHandle(ts,"AddOutput","angles 0 270 0",0.00,null,null);
		else EntFireByHandle(ts,"AddOutput","angles 0 90 0",0.00,null,null);
		local angdif = (sa-ta-180);
		while(angdif>360){angdif-=180;}
		while(angdif< -180){angdif+=360;}
		angdif=abs(angdif);
		local tdist = GetDistance(self.GetOrigin(),target.GetOrigin());
		EntFireByHandle(tf,"AddOutput","force 1900",0.00,null,null);
		EntFireByHandle(ts,"AddOutput","force "+(3*angdif).tostring(),0.00,null,null);
		if(LUNAR_BALL_CD)lunar_ball_cast();
	}
}
function lunar_ball_cast()
{
	if(!Lunar_Ball)
	{
		Lunar_Ball = true;
		canmove = false;
		LUNAR_BALL_CD = false;
		EntFireByHandle(Model,"SetAnimation","attack",0.00,null,null);
		EntFireByHandle(self,"DisableMotion","",0,null,null);
		EntFireByHandle(self,"EnableMotion","",LUNAR_BALL_CASTTIME,null,null);
		EntFireByHandle(BallMaker,"Forcespawn","",1.4,null,null);
		EntFireByHandle(self,"RunScriptCode","canmove = true;",LUNAR_BALL_CASTTIME,null,null);
		EntFireByHandle(self,"RunScriptCode","Lunar_Ball = false;",LUNAR_BALL_CASTTIME,null,null);
		EntFireByHandle(self,"RunScriptCode","LUNAR_BALL_CD = true;",LUNAR_BALL_CDBACK,null,null);
	}
}
function lunar_ball_spawn()BallMaker.SpawnEntityAtLocation(self.GetOrigin(),Vector(0,0,0))

function SearchTarget()
{
	ScriptPrintMessageChatAll("SearchTarget");
	ttime = 0.00;
	target = null;
	local h = null;
	local candidates = [];
	while(null!=(h=Entities.FindInSphere(h,self.GetOrigin(),TARGET_DISTANCE)))
	{
		if(h.GetClassname()=="player" && h.GetTeam()==3 && h.GetHealth()>0)
		{
			candidates.push(h);
		}
	}
	if(candidates.len()==0){Stop();return;}
	else
	target = candidates[RandomInt(0,candidates.len()-1)];
}
function printball()
{
	DebugDrawLine(BallMaker.GetOrigin(), BallMaker.GetOrigin()+Vector(0,50,0), 255,255,255, true, 0.1)
	EntFireByHandle(self,"RunScriptCode","printball()",0.05,null,null);
}

function SpawnRandMessage()
{
	if(CHAT_CD)
	{
		CHAT_CD = false;
		EntFireByHandle(self,"RunScriptCode","CHAT_CD = true;",CHAT_CDBACK,null,null);
		ScriptPrintMessageChatAll("MITHRIX: "+Message[RandomInt(0,Message.len()-1)].tostring());
	}
}

function GetTargetYaw(start,target)
{
	local yaw = 0.00;
	local v = Vector(start.x-target.x,start.y-target.y,start.z-target.z);
	local vl = sqrt(v.x*v.x+v.y*v.y);
	yaw = 180*acos(v.x/vl)/3.14159;
	if(v.y<0)yaw=-yaw;
	return yaw;
}
function InSight(start,target){if(TraceLine(start,target,self)<1.00)return false;return true;}
function GetDistance(v1,v2)return sqrt((v1.x-v2.x)*(v1.x-v2.x)+(v1.y-v2.y)*(v1.y-v2.y)+(v1.z-v2.z)*(v1.z-v2.z));
//function TakeDamage()ScriptPrintMessageChatAll(HitBox.GetHealth().tostring());
Message <- [
	"BLEED.",
	"SCREAM.",
	"WHERE'S YOUR INFLUENCE?",
	"FLEETING STRENGTH.",
	"FRAIL.",
	"BREAK.",
	"FALSE STRENGTH.",
	"DRAIN.",
	"DIE, VERMIN.",
	"WEAK, WITHOUT YOUR BAUBLES AND TRINKETS.",
	"DIE.",
	"WEAK.",
	"USELESS.",
	"AS I THOUGHT...",
	"VERMIN."
];
DeadMessage <- [
	"NO... NOT NOW...",
	"WHY... WHY NOW...?",
	"NO... NO...!",
	"BROTHER... HELP ME...!",
	"THIS PLANE GROWS DARK... BROTHER... I CANNOT SEE YOU... WHERE ARE YOU...?",
	"BROTHER... PERHAPS... WE WILL GET IT RIGHT... NEXT TIME..."
];