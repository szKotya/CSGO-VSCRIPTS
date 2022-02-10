/*
Moving NPC by Luffaren[STEAM_0:1:22521282]
NPC by Kotya[STEAM_1:1:124348087]
update 07.12.2020

　　　　　／＞　 フ
　　　　　| 　_　 _|
　 　　　／`ミ _x 彡
　　 　 /　　　 　 |
　　　 /　 ヽ　　 ﾉ
　／￣|　　 |　|　|
　| (￣ヽ＿_ヽ_)_)
　＼二つ
*/
TICKRATE 	<- 	0.25;
TICKRATE_IDLE <- 0.5;
TARGET_DISTANCE <- 	1524;
RETARGET_TIME 	<- 	3.00;
SPEED_FORWARD 	<- 	1.00;
SPEED_TURNING 	<- 	0.50;
///////////////////
HpPerHuman <- 10;
HpBase <- 200;
///////////////////
HitBox <- null;
tf <- null;
ts <- null;
Kepper <- null;
Model <- null;
//////////////////
attact_CASTTIME <- 1.5;
attact_CASTTIME_POWER <- 3;
//////////////////
idleing <- false;
flying <- false;
//////////////////
target <- null;
ttime <- 0.00;
ticking <- false;
canmove <- true;
counter <- 0.00;
stopcounter <- 2;
dontTakehp <- true;
Scounter<-0.00;
MIN_SPEED<-3;
MAX_STOP_TIME<-1.00;
lastpos<-self.GetOrigin();
debag <- false;
///////////////////
function SetHandleModel()Model = caller;
function SetHandleTs()ts = caller;
function SetHandleTf()tf = caller;
function SetHandleKepper()Kepper = caller;
function SetHandleHitBox()HitBox = caller;
//////////////////////////////////////
function Start()
{
	if(!ticking)
	{
		ticking = true;
		if(RandomInt(0,5)>=4)
		{
			HpBase = 250;
			SPEED_FORWARD = 0.8;
			flying = false;
		}
		else
		{
			HpBase = 400;
			SPEED_FORWARD = 1.1;
			EntFireByHandle(Model,"SetAnimation","h2hequip",0.00,null,null);
			EntFireByHandle(Model,"SetDefaultAnimation","h2haim",0.01,null,null);
			flying = true;
		}
		EntFireByHandle(self,"RunScriptCode","Tick()",2,null,null);
	}
}
function Stop()
{
    if(ticking)
    {
			if(debag)ScriptPrintMessageChatAll("Stop");
			EntFireByHandle(tf,"Deactivate","",0.00,null,null);
			EntFireByHandle(ts,"Deactivate","",0.00,null,null);
			EntFireByHandle(tf,"Kill","",0.50,null,null);
			EntFireByHandle(ts,"Kill","",0.50,null,null);
			if(flying)
			{
				EntFireByHandle(self,"Kill","",0.50,null,null);
				EntFireByHandle(Model,"ClearParent","",0.45,null,null);
				EntFireByHandle(tf,"AddOutput","force 5000",0.01,null,null);
				EntFireByHandle(tf,"Activate","",0.02,null,null);
				EntFireByHandle(tf,"Deactivate","",0.05,null,null);
				EntFireByHandle(Model,"SetAnimation","h2hhitwings",0.00,null,null);
				EntFireByHandle(Model,"FadeAndKill","",1.15,null,null);
			}
			else
			{
				EntFireByHandle(self,"Kill","",0.8,null,null);
				EntFireByHandle(Model,"ClearParent","",0.75,null,null);
				EntFireByHandle(tf,"AddOutput","force 1500",0.01,null,null);
				EntFireByHandle(tf,"Activate","",0.02,null,null);
				EntFireByHandle(tf,"Deactivate","",0.6,null,null);
				EntFireByHandle(Model,"FadeAndKill","",1.0,null,null);
				EntFireByHandle(Model,"SetAnimation","h2hforward_hurt",0.00,null,null);
			}
			EntFireByHandle(Kepper,"Kill","",0.50,null,null);
			ticking = false;
    }
}

function Tick()
{
	if(!ticking)return;
	EntFireByHandle(tf,"Deactivate","",0.00,null,null);
	EntFireByHandle(ts,"Deactivate","",0.00,null,null);
	if(target==null||target.GetClassname()!="player"||target.GetTeam()!=3||target.GetHealth()<=0)SearchTarget();
	if(target==null||target.GetClassname()!="player"||target.GetTeam()!=3||target.GetHealth()<=0)
	{

		EntFireByHandle(self,"RunScriptCode","Tick()",TICKRATE_IDLE,null,null);
		if(flying)
		{
			if(!idleing)EntFireByHandle(Model,"SetAnimation","h2hidle",0.00,null,null);
			EntFireByHandle(Model,"SetDefaultAnimation","h2hidle",0.01,null,null);
		}
		else
		{
			if(!idleing)EntFireByHandle(Model,"SetAnimation","mtagitated",0.00,null,null);
			EntFireByHandle(Model,"SetDefaultAnimation","mtagitated",0.01,null,null);
		}
		idleing = true;
	}
	else
	{
		if(canmove)
		{
			if(GetDistance(self.GetOrigin(),lastpos) < MIN_SPEED)Scounter+=0.10;
			else Scounter=0.00;
			if(Scounter > MAX_STOP_TIME)
			{
				EntFireByHandle(ts,"Deactivate","",0.00,null,null);
				EntFireByHandle(ts,"AddOutput","force 5000",0.01,null,null);
				EntFireByHandle(ts,"Activate","",0.02,null,null);
			}
			lastpos=self.GetOrigin();
			EntFireByHandle(tf,"Activate","",0.02,null,null);
			EntFireByHandle(ts,"Activate","",0.02,null,null);
			local sa = self.GetAngles().y;
			local ta = GetTargetYaw(self.GetOrigin(),target.GetOrigin());
			if(abs((sa-ta+360)%360)>=180)EntFireByHandle(ts,"AddOutput","angles 0 270 0",0.00,null,null);
			else EntFireByHandle(ts,"AddOutput","angles 0 90 0",0.00,null,null);
			local angdif = (sa-ta-180);while(angdif>360){angdif-=180;}while(angdif< -180){angdif+=360;}angdif=abs(angdif);
			EntFireByHandle(tf,"AddOutput","force "+(2000*SPEED_FORWARD).tostring(),0.00,null,null);
			EntFireByHandle(ts,"AddOutput","force "+((3*SPEED_TURNING)*angdif).tostring(),0.00,null,null);
			if(GetDistance(self.GetOrigin(),target.GetOrigin())<100)Attact();
			if((GetDistance(self.GetOrigin(),target.GetOrigin())<400) && !flying)StartFly();
			ttime+=TICKRATE;
			if(TraceLine(HitBox.GetOrigin(),target.GetOrigin()+Vector(0,0,45),self)!=1.00)counter+=0.10;
			if(counter>=stopcounter)
			{
				if(debag)ScriptPrintMessageChatAll("Stopcounter");
				target = null;
			}
			if(ttime>=RETARGET_TIME)
			{
				if(debag)ScriptPrintMessageChatAll("Retarget");
				target = null;
			}
		}
		EntFireByHandle(self,"RunScriptCode","Tick();",TICKRATE,null,null);
	}
}

function SearchTarget()
{
	if(debag)ScriptPrintMessageChatAll("SearchTarget");
	ttime = 0.00;
	target = null;
	counter = 0.00;
	local h = null;
	local candidates = [];
	local counterCT = 0;
	while(null!=(h=Entities.FindInSphere(h,self.GetOrigin(),TARGET_DISTANCE)))
	{
		if(h.GetClassname()=="player" && h.GetTeam()==3 && h.GetHealth()>0)
		{
			counterCT++;
			if(TraceLine(HitBox.GetOrigin(),h.GetOrigin()+Vector(0,0,45),self)==1.00)
			{
				candidates.push(h);
			}
		}
	}
	if(candidates.len()==0)return;
	if(flying)
	{
		EntFireByHandle(Model,"SetAnimation","h2hforward",0.00,null,null);
		EntFireByHandle(Model,"SetDefaultAnimation","h2hforward",0.01,null,null);
	}
	else
	{
		EntFireByHandle(Model,"SetAnimation","mtforward",0.00,null,null);
		EntFireByHandle(Model,"SetDefaultAnimation","mtforward",0.01,null,null);
	}
	idleing = false;
	if(debag)ScriptPrintMessageChatAll("Find Target");
	target = candidates[RandomInt(0,candidates.len()-1)];
	if(dontTakehp)
	{
		dontTakehp = false;
		EntFireByHandle(HitBox,"SetHealth",(HpBase+HpPerHuman*counterCT).tostring(),0.00,null,null);
	}
}
function FirstTimeHit()
{
		if(target==null)
		{
			if(activator!=null&&activator.IsValid()&&activator.GetClassname()=="player"&&activator.GetTeam()==3&&activator.GetHealth()>0)
			{
				ttime = 0.00;
				target = activator;
				idleing = false;
				if(flying)
				{
					EntFireByHandle(Model,"SetAnimation","h2hforward",0.00,null,null);
					EntFireByHandle(Model,"SetDefaultAnimation","h2hforward",0.01,null,null);
				}
				else
				{
					EntFireByHandle(Model,"SetAnimation","mtforward",0.00,null,null);
					EntFireByHandle(Model,"SetDefaultAnimation","mtforward",0.01,null,null);
				}
				if(dontTakehp)
				{
					local ctcount=0;
					local hlist=[];
					local h=null;
					while(null!=(h=Entities.FindInSphere(h,self.GetOrigin(),TARGET_DISTANCE*1.5)))
					{if(h.GetClassname()=="player"&&h.GetTeam()==3&&h.GetHealth()>0){ctcount++;}}
					dontTakehp = false;
					EntFireByHandle(HitBox,"SetHealth",(HpBase+HpPerHuman*ctcount).tostring(),0.00,null,null);
				}
			}
		}
}

function StartFly()
{
	flying = true;
	SPEED_FORWARD = 0.2;
	EntFireByHandle(self,"RunScriptCode","SPEED_FORWARD = 1.1",0.8,null,null);
	EntFireByHandle(Model,"SetAnimation","h2hequip",0.00,null,null);
	EntFireByHandle(Model,"SetDefaultAnimation","h2hforward",0.01,null,null);
}

function Attact()
{
	idleing = false;
	if(RandomInt(0,3) > 0)
	{
		EntFireByHandle(self,"RunScriptCode","canmove = true",attact_CASTTIME,null,null);
		if(RandomInt(0,1))EntFireByHandle(Model,"SetAnimation","h2hattackright",0.00,null,null);
		else EntFireByHandle(Model,"SetAnimation","h2hattackleft",0.00,null,null);
		EntFireByHandle(target,"IgniteLifetime","1.5",0.5,null,null);
		TargetTakeDamage(5,0.5)
		EntFireByHandle(tf,"Deactivate","",0.3,null,null);
		EntFireByHandle(ts,"Deactivate","",0.3,null,null);
		EntFireByHandle(self,"RunScriptCode","canmove = false;",0.25,null,null);
		EntFire("speed","ModifySpeed","0.8",0.5,target);
		EntFire("speed","ModifySpeed","1",1,target);
		if(debag)ScriptPrintMessageChatAll("Fast");
	}
	else
	{
		EntFireByHandle(self,"RunScriptCode","canmove = true",attact_CASTTIME_POWER,null,null);
		if(RandomInt(0,1))
		{
			EntFireByHandle(Model,"SetAnimation","h2hattackforwardpower",0.00,null,null);
			EntFireByHandle(target,"IgniteLifetime","4",0.6,null,null);
			TargetTakeDamage(15,0.6)
			EntFireByHandle(tf,"Deactivate","",0.4,null,null);
			EntFireByHandle(ts,"Deactivate","",0.4,null,null);
			EntFireByHandle(self,"RunScriptCode","canmove = false;",0.35,null,null);
			EntFire("speed","ModifySpeed","0.4",0.6,target);
			EntFire("speed","ModifySpeed","1",2.1,target);
			if(debag)ScriptPrintMessageChatAll("slow1");
		}
		else
		{
			EntFireByHandle(target,"IgniteLifetime","4",1.2,null,null);
			EntFireByHandle(Model,"SetAnimation","h2hattackpower",0.00,null,null);
			TargetTakeDamage(15,0.9)
			EntFireByHandle(tf,"Deactivate","",0.7,null,null);
			EntFireByHandle(ts,"Deactivate","",0.7,null,null);
			EntFireByHandle(self,"RunScriptCode","canmove = false;",0.65,null,null);
			EntFire("speed","ModifySpeed","0.4",0.9,target);
			EntFire("speed","ModifySpeed","1",3,target);
			if(debag)ScriptPrintMessageChatAll("slow2");
		}
	}
}

function TargetTakeDamage(i,timer)
{
	local hp = target.GetHealth()-i;
	if(hp<=0){EntFireByHandle(target,"SetHealth","0",timer,null,null);}
	else {EntFireByHandle(target,"SetHealth",hp.tostring(),timer,null,null);}

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
function GetDistance(v1,v2)return sqrt((v1.x-v2.x)*(v1.x-v2.x)+(v1.y-v2.y)*(v1.y-v2.y)+(v1.z-v2.z)*(v1.z-v2.z));