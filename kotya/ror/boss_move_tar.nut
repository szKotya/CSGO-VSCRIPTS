TICKRATE<-0.10;
TARGET_DISTANCE<-2048;
RETARGET_TIME<-6.00;
SPEED_BONUS<-1;
MIN_SPEED<-2;
MAX_STOP_TIME<-2.00;
SpawnPos<-null;
HitBox<-null;
Model<-null;
HammerTarget<-null;
tf<-null;
ts<-null;
tl<-null;
tr<-null;
tspeed<-null;
Kepper<-null;
Sound0<-null;
Sound1<-null;
ultrot<-null;
UltSpawner<-null;
EarthQuakeSpawner<-null;
HEbox<-null;

function SetHandleEarthQuakeSpawner()EarthQuakeSpawner=caller;
function SetHandleUltSpawner()UltSpawner=caller;
function SetHandleTs()ts=caller;
function SetHandleTf()tf=caller;
function SetHandleTr()tr=caller;
function SetHandleTspeed()tspeed=caller;
function SetHandleTl()tl=caller;
function SetHandleModel()Model=caller;
function SetHandleHammerTarget()HammerTarget=caller;
function SetHandleHitbox()HitBox=caller;
function SetHandleHEbox()HEbox=caller;
function SetHandleKepper()Kepper=caller;
function SetHandleSound0()Sound0=caller;
function SetHandleSound1()Sound1=caller;

target<-null;
ttime<-0.00;
ticking<-false;
canmove<-true;
counter<-0.00;
lastpos<-self.GetOrigin();


smash_run<-false;
smash_forward<-false;
dash<-false;
ultima<-false;
jump<-false;

JUMP_CD<-false;
JUMP_CDBACK<-25;
JUMP_CASTTIME<-7;

ULTIMA_CD<-true;
ULTIMA_CDBACK<-20;
ULTIMA_MINVAVECAST <-4;
ULTIMA_MAXVAVECAST <-6;
ULTIMA_CASTTIME<-0;

CHAT_CD<-true;
CHAT_CDBACK<-4;

DASH_CD<-true;
DASH_CDBACK<-8;
DASH_CASTTIME<-0.6;
DASH_MINDIST<-300;

SMASH_RUN_DAMAGE<-25;
SMASH_RUN_CASTTIME<-2.1;
SMASH_RUN_DAMAGERADIUS<-150;

SMASH_FORWARD_CD<-true;
SMASH_FORWARD_CDBACK<-5;
SMASH_FORWARD_SEARCH_FORCAST<-150;
SMASH_FORWARD_MINPLAYER_FORCAST<-1;

SMASH_FORWARD_DAMAGE<-50;
SMASH_FORWARD_DAMAGERADIUS<-250;
SMASH_FORWARD_CASTTIME<-3.5;
HARD<-true;
function Start()
{
  if(!ticking)
	{
		ScriptPrintMessageCenterAll("Start");
		ticking=true;
		Tick();
		SpawnPos=self.GetOrigin();
		EntFireByHandle(Sound0,"PlaySound","",0.00,null,null);
		EntFireByHandle(Model,"SetDefaultAnimation","run",0.00,null,null);
		EntFireByHandle(Model,"SetAnimation","run",0.00,null,null);
		//EntFireByHandle(self,"Runscriptcode","JUMP_CD=true",3.00,null,null);
		EntFire("HPCONTROL", "Runscriptcode", "Start(0)", 0.00,null)
	}
}
function HardSettings() 
{
	HARD=true;
	SPEED_BONUS=1.1;
}
function Stop()
{
    if(ticking)
    {
			EntFireByHandle(Sound0,"Voice","0",0.00,null,null);
			EntFireByHandle(Sound0,"StopSound","",0.00,null,null);
			EntFireByHandle(Sound1,"Voice","0",0.01,null,null);
			EntFireByHandle(Sound1,"StopSound","",0.01,null,null);
			ScriptPrintMessageCenterAll("Stop");
			ticking=false;
			EntFireByHandle(tf,"Kill","",0.00,null,null);
			EntFireByHandle(Model,"ClearParent","",0.00,null,null);
			EntFireByHandle(Model,"SetAnimation","jump_up",0.52,null,null);
			EntFireByHandle(Model,"kill","",2.40,null,null);
			EntFireByHandle(HammerTarget,"Kill","",0.00,null,null);
			EntFireByHandle(Kepper,"Kill","",0.00,null,null);
			EntFireByHandle(ts,"Kill","",0.00,null,null);
			EntFireByHandle(HitBox,"Kill","",0.00,null,null);
			EntFireByHandle(tspeed,"Kill","",0.00,null,null);
			EntFireByHandle(tr,"Kill","",0.00,null,null);
			EntFireByHandle(tl,"Kill","",0.00,null,null);
			EntFireByHandle(tspeed,"Kill","",0.01,null,null);
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
	
	if(canmove)
	{
		if(GetDistance(self.GetOrigin(),lastpos) < MIN_SPEED)
			counter+=0.10;
		else counter=0.00;

		if(counter > MAX_STOP_TIME)
		{
			EntFireByHandle(ts,"Deactivate","",0.00,null,null);
			EntFireByHandle(ts,"AddOutput","force 4000",0.01,null,null);
			EntFireByHandle(ts,"Activate","",0.02,null,null);
		}
		lastpos=self.GetOrigin();
		EntFireByHandle(tf,"Deactivate","",0.00,null,null);
		EntFireByHandle(ts,"Deactivate","",0.00,null,null);	
		if(target==null||!target.IsValid()||target.GetHealth()<=0.00||target.GetTeam()!=3||ttime>=RETARGET_TIME)
		return SearchTarget();
		ttime+=TICKRATE;
		EntFireByHandle(tf,"Activate","",0.02,null,null);
		EntFireByHandle(ts,"Activate","",0.02,null,null);
		local sa=self.GetAngles().y;
		local ta=GetTargetYaw(self.GetOrigin(),target.GetOrigin());
		local ang=abs((sa-ta+360)%360);
		if(ang>=180)EntFireByHandle(ts,"AddOutput","angles 0 270 0",0.00,null,null);
		else EntFireByHandle(ts,"AddOutput","angles 0 90 0",0.00,null,null);
		local angdif=(sa-ta-180);
		while(angdif>360){angdif-=180;}
		while(angdif< -180){angdif+=360;}
		angdif=abs(angdif);
		local tdist=GetDistance(self.GetOrigin(),target.GetOrigin());
	
		EntFireByHandle(tf,"AddOutput","force "+(3000*SPEED_BONUS).tostring(),0.00,null,null);
		EntFireByHandle(ts,"AddOutput","force "+(3*angdif).tostring(),0.00,null,null);
		if(HARD)if(ULTIMA_CD)ultima_cast();
		if(JUMP_CD)jump_cast();
		if(DASH_CD)Dash_cast(tdist);
		if(SMASH_FORWARD_CD)smash_forward_cast();
		if(tdist<155)smash_run_cast();
	}
}
function EarthQuake(typeE) 
{
	if(!typeE)
	{
		local localang=EarthQuakeSpawner.GetAngles().y;
		local timer=0;
		local sides=12;
		local ang=360/sides;
		for(local i=0;i<sides;i++)
		{
			EntFireByHandle(EarthQuakeSpawner,"addoutput","angles 0 "+localang+" 0",timer,null,null);
			EntFireByHandle(EarthQuakeSpawner,"Forcespawn","",timer+0.01,null,null);
			ScriptPrintMessageChatAll(i.tostring());
			ScriptPrintMessageChatAll(localang.tostring());
			localang+=ang;
			timer+=0.02;
		}
		EntFireByHandle(EarthQuakeSpawner,"Fireuser2","",timer,null,null);
	}
	else
	{
		EntFireByHandle(EarthQuakeSpawner,"Fireuser2","",0.02,null,null);
		EarthQuakeSpawner.SpawnEntityAtLocation(HammerTarget.GetOrigin(),self.GetAngles()-Vector(0,-135,0));
		EarthQuakeSpawner.SpawnEntityAtLocation(HammerTarget.GetOrigin(),self.GetAngles()-Vector(0,135,0));
		EarthQuakeSpawner.SpawnEntityAtLocation(HammerTarget.GetOrigin(),self.GetAngles()-Vector(0,180,0));
	}
}
function Dash_cast(dist) 
{
	if(!smash_forward && !smash_run && !dash && dist>DASH_MINDIST && !ultima)
	{
		local DASH_SIDETIME=0.3;
		DASH_CD=false;
		dash=true;
		ttime -= 1;
		EntFireByHandle(Sound0,"StopSound","",0.01,null,null);
		EntFireByHandle(Sound0,"PlaySound","",DASH_SIDETIME,null,null);
		EntFireByHandle(Sound1,"AddOutput","message *music/ror/dash.wav",0.00,null,null);
		EntFireByHandle(Sound1,"PlaySound","",0.01,null,null);
		EntFireByHandle(tspeed,"Activate","",DASH_SIDETIME,null,null);
		EntFireByHandle(tspeed,"Deactivate","",DASH_SIDETIME+0.7,null,null);
		EntFireByHandle(tf,"Deactivate","",0.00,null,null);
		EntFireByHandle(ts,"Deactivate","",0.00,null,null);	
		if(RandomInt(0,1))
		{
			EntFireByHandle(Model,"SetAnimation","dash_right",0.00,null,null);
			EntFireByHandle(tr,"Activate","",0.00,null,null);
			EntFireByHandle(tr,"Deactivate","",DASH_SIDETIME,null,null);
		}
		else
		{
			EntFireByHandle(Model,"SetAnimation","dash_left",0.00,null,null);
			EntFireByHandle(tl,"Activate","",0.00,null,null);
			EntFireByHandle(tl,"Deactivate","",DASH_SIDETIME,null,null);
		}
		EntFireByHandle(self,"RunScriptCode","dash=false;",DASH_CASTTIME,null,null);
		EntFireByHandle(self,"RunScriptCode","DASH_CD=true;",DASH_CDBACK,null,null);
	}
}
function jump_cast() 
{
	if(Casting() && !dash)
	{
		jump=true;
		JUMP_CD=false;
		canmove=false;
		EntFireByHandle(HitBox,"Disable","",0,null,null);
		EntFireByHandle(HEbox,"Disable","",0,null,null);
		EntFireByHandle(Sound0,"StopSound","",0,null,null);

		EntFireByHandle(Sound1,"AddOutput","message *music/ror/jumpup.wav",0.00,null,null);
		EntFireByHandle(Sound1,"PlaySound","",0.5,null,null);
		
		EntFireByHandle(self,"DisableMotion","",0,null,null);
		EntFireByHandle(self,"EnableMotion","",0.5,null,null);

		EntFireByHandle(Model,"SetAnimation","jump_up",0.52,null,null);
		EntFireByHandle(Model,"disable","",2.40,null,null);

		EntFireByHandle(self,"RunScriptCode","self.SetOrigin(SpawnPos)",JUMP_CASTTIME-2.5,null,null);
		EntFireByHandle(Model,"SetAnimation","jump_down",JUMP_CASTTIME-2.6,null,null);
		EntFire("boss_smash_forward_shake", "startshake", "",JUMP_CASTTIME-2.45, null);
		EntFireByHandle(self,"RunScriptCode","EarthQuake(0)",JUMP_CASTTIME-2.45,null,null);

		EntFireByHandle(Model,"enable","",JUMP_CASTTIME-2.5,null,null);
		EntFireByHandle(HitBox,"Enable","",JUMP_CASTTIME-2.5,null,null);
		EntFireByHandle(HEbox,"Enable","",JUMP_CASTTIME-2.5,null,null);
		
		EntFireByHandle(self,"RunScriptCode","JumpText()",JUMP_CASTTIME-2.48,null,null);

		EntFireByHandle(HitBox,"Enable","",JUMP_CASTTIME,null,null);
		EntFireByHandle(HEbox,"Enable","",JUMP_CASTTIME,null,null);

		EntFireByHandle(Sound0,"PlaySound","",JUMP_CASTTIME,null,null);
		EntFireByHandle(self,"RunScriptCode","jump=false; ",JUMP_CASTTIME,null,null);
		EntFireByHandle(self,"RunScriptCode","canmove=true; ",JUMP_CASTTIME,null,null);
		EntFireByHandle(self,"RunScriptCode","JUMP_CD=true;",JUMP_CDBACK,null,null);
	}
}
function JumpText()ScriptPrintMessageChatAll("MITHRIX: "+JumpMessage[RandomInt(0,JumpMessage.len()-1)].tostring());
function smash_forward_cast() 
{ 
	if(Casting())
	{
		if(CanUseAb_smash_forward())
		{
			SMASH_FORWARD_CD=false;
			smash_forward=true;
			canmove=false;
			EntFireByHandle(Sound0,"StopSound","",0.01,null,null);
			EntFireByHandle(Sound0,"PlaySound","",SMASH_FORWARD_CASTTIME,null,null);
			EntFireByHandle(Sound1,"AddOutput","message *music/ror/smash_forward.wav",0.00,null,null);
			EntFireByHandle(Sound1,"PlaySound","",0.51,null,null);
			EntFireByHandle(tf,"Deactivate","",0.00,null,null);
			EntFireByHandle(ts,"Deactivate","",0.00,null,null);	
			EntFireByHandle(self,"DisableMotion","",0,null,null);
			EntFireByHandle(self,"EnableMotion","",SMASH_FORWARD_CASTTIME,null,null);
			EntFireByHandle(Model,"SetAnimation","smash_forward",0.00,null,null);
			if(HARD)EntFireByHandle(self,"RunScriptCode","EarthQuake(1)",1.6,null,null);
			if(HARD)EntFireByHandle(HammerTarget,"forcespawn","",1.6,null,null);
			EntFireByHandle(self,"RunScriptCode","smash_forward=false; ",SMASH_FORWARD_CASTTIME-0.5,null,null);
			EntFireByHandle(self,"RunScriptCode","canmove=true; ",SMASH_FORWARD_CASTTIME,null,null);
			EntFireByHandle(self,"RunScriptCode","SMASH_FORWARD_CD=true;",SMASH_FORWARD_CDBACK,null,null);
			EntFireByHandle(self,"RunScriptCode","smash_forward_target_search(); ",1.6,null,null);
		}
	}
}
function smash_forward_target_search() 
{
	local h=null;
	FadePL();
	local htorigin=HammerTarget.GetOrigin();
	if(HARD)EntFireByHandle(HammerTarget,"forcespawn","",0,null,null);
	EntFire("boss_smash_forward_shake", "startshake", "",0.0, null)
	while(null!=(h=Entities.FindInSphere(h,HammerTarget.GetOrigin(),SMASH_FORWARD_DAMAGERADIUS)))
	{
		if(h.GetClassname()=="player"&&h.GetTeam()==3&&h.GetHealth()>0)
		smash_forward_DAMAGE_CAST(h);
	}
}
function smash_forward_DAMAGE_CAST(_target)
{
	local hp=_target.GetHealth()-SMASH_FORWARD_DAMAGE;
	if(hp<=0)
	{
		EntFireByHandle(_target,"SetHealth","0",0.00,null,null);
		SpawnRandMessage(1); 
	}
	else
	{
		SpawnRandMessage(0);
		EntFireByHandle(_target,"SetHealth",hp.tostring(),0.00,null,null);
		local spos=target.GetOrigin();
		local tpos=_target.GetOrigin();
		local vec=spos-tpos;
		vec.Norm();
		EntFireByHandle(_target,"AddOutput","basevelocity "+
		(-vec.x*2000).tostring()+" "+
		(-vec.y*2000).tostring()+" "+
		(400).tostring(),0.00,null,null);
	}
}
function smash_run_cast() 
{
	if(Casting())
	{
		smash_run=true;
		canmove=false;
		EntFireByHandle(Sound0,"StopSound","",0.01,null,null);
		EntFireByHandle(Sound0,"PlaySound","",SMASH_RUN_CASTTIME,null,null);
		EntFireByHandle(Sound1,"AddOutput","message *music/ror/smash_run.wav",0.00,null,null);
		EntFireByHandle(Sound1,"PlaySound","",0.01,null,null);
		EntFireByHandle(tf,"Deactivate","",0.00,null,null);
		EntFireByHandle(ts,"Deactivate","",0.00,null,null);	
		EntFireByHandle(self,"DisableMotion","",0,null,null);
		EntFireByHandle(self,"EnableMotion","",SMASH_RUN_CASTTIME,null,null);
		EntFireByHandle(Model,"SetAnimation","smash_run",0.00,null,null);
		EntFireByHandle(self,"RunScriptCode","smash_run=false; ",SMASH_RUN_CASTTIME-0.5,null,null);
		EntFireByHandle(self,"RunScriptCode","canmove=true; ",SMASH_RUN_CASTTIME,null,null);
		EntFire("boss_smash_run_shake", "startshake", "",0.0, null)
		FadePL()
		local h=null;
		while(null!=(h=Entities.FindInSphere(h,target.GetOrigin(),SMASH_RUN_DAMAGERADIUS)))
		{
			if(h.GetClassname()=="player"&&h.GetTeam()==3&&h.GetHealth()>0)
			smash_run_DAMAGE_CAST(h);
		}
	}
}



function smash_run_DAMAGE_CAST(_target)
{
	local hp=_target.GetHealth()-SMASH_RUN_DAMAGE;
	if(hp<=0)
	{
		SpawnRandMessage(1);
		EntFireByHandle(_target,"SetHealth","0",0.20,null,null);
	}
	else
	{
		SpawnRandMessage(0);
		EntFireByHandle(_target,"SetHealth",hp.tostring(),0.20,null,null);
		local spos=self.GetOrigin();
		local tpos=_target.GetOrigin();
		local vec=spos-tpos;
		vec.Norm();
		EntFireByHandle(_target,"AddOutput","basevelocity "+
		(-vec.x*200).tostring()+" "+
		(-vec.y*200).tostring()+" "+
		(400).tostring(),0.20,null,null);
	}
}
function ultima_cast() 
{
	if(Casting() && !dash)
	{
		canmove=false;
		ultima=true;
		ULTIMA_CD=false;
		local timer=0;
		ULTIMA_CASTTIME=0;
		for(local i=0; i<=RandomInt(ULTIMA_MINVAVECAST,ULTIMA_MAXVAVECAST);i++)
		{
			ULTIMA_CASTTIME+=2;
			EntFireByHandle(UltSpawner,"forcespawn","",timer,null,null);
			timer+=2;
		}
		EntFireByHandle(Sound1,"AddOutput","message *music/ror/ultaexplo.wav",0.00,null,null);

		EntFireByHandle(Sound0,"StopSound","",0.00,null,null);
		EntFireByHandle(Sound0,"AddOutput","message *music/ror/ultaloop.wav",0.01,null,null);
		EntFireByHandle(Sound0,"PlaySound","",0.02,null,null);
		
		
		EntFireByHandle(Model,"SetAnimation","ult_start",0.00,null,null);
		EntFireByHandle(Model,"SetDefaultAnimation","ult_channel",0.00,null,null);

		EntFireByHandle(self,"DisableMotion","",0.00,null,null);
		EntFireByHandle(tf,"Deactivate","",0.00,null,null);
		EntFireByHandle(ts,"Deactivate","",0.00,null,null);	
		EntFireByHandle(tl,"Deactivate","",0.00,null,null);
		EntFireByHandle(tr,"Deactivate","",0.00,null,null);	
		EntFireByHandle(tspeed,"Deactivate","",0.00,null,null);

		EntFireByHandle(Sound0,"StopSound","",ULTIMA_CASTTIME,null,null);
		EntFireByHandle(Sound0,"AddOutput","message *music/ror/run.wav",ULTIMA_CASTTIME+0.01,null,null);
		EntFireByHandle(Sound0,"PlaySound","",ULTIMA_CASTTIME+0.02,null,null);

		EntFireByHandle(self,"EnableMotion","",ULTIMA_CASTTIME,null,null);
		EntFireByHandle(Model,"SetAnimation","ult_end",ULTIMA_CASTTIME-0.5,null,null);
		EntFireByHandle(Model,"SetDefaultAnimation","run",ULTIMA_CASTTIME,null,null);
		EntFireByHandle(self,"RunScriptCode","ULTIMA_CD=true;",ULTIMA_CDBACK,null,null);
		EntFireByHandle(self,"RunScriptCode","ultima=false; ",ULTIMA_CASTTIME,null,null);
		EntFireByHandle(self,"RunScriptCode","canmove=true; ",ULTIMA_CASTTIME,null,null);
	}
}

function FadePL() 
{
	local h=null;
	while(null!=(h=Entities.FindInSphere(h,self.GetOrigin(),600)))
	{
		if(h.GetClassname()=="player" && h.GetTeam()==3 && h.GetHealth()>0)
		{
			EntFire("boss_fade", "fade", "",0.1, h);
		}
	}	
}

function SetHandleUltrot()
{
	ultrot=caller;
	local randomTime=RandomFloat(1.3,1.8);
	EntFireByHandle(ultrot,"addoutput","maxspeed "+RandomInt(25,50).tostring(),0.4,null,null);
	if(RandomInt(0,1))EntFireByHandle(ultrot,"startforward","",0.5,null,null);
	else EntFireByHandle(ultrot,"startbackward","",0.5,null,null);
	if(RandomInt(0,1))EntFireByHandle(ultrot,"startforward","",1,null,null);
	else EntFireByHandle(ultrot,"startbackward","",1,null,null);
	EntFireByHandle(Sound1,"PlaySound","",randomTime,null,null);
	EntFireByHandle(ultrot,"fireuser2","",randomTime,null,null);
	EntFireByHandle(self,"RunScriptCode","FadePL();",randomTime,null,null);
	EntFireByHandle(ultrot,"kill","",randomTime+0.1,null,null);
	EntFire("boss_smash_forward_shake", "startshake", "",randomTime+0.1, null);
}


function SearchTarget()
{
	ScriptPrintMessageCenterAll("SearchTarget");	
	ttime=0.00;
	target=null;
	local h=null;
	local candidates=[];
	while(null!=(h=Entities.FindInSphere(h,self.GetOrigin(),TARGET_DISTANCE)))
	{
		if(h.GetClassname()=="player" && h.GetTeam()==3 && h.GetHealth()>0)
		{
			candidates.push(h);
		}
	}
	if(candidates.len()==0){Stop();return;}
	else
	target=candidates[RandomInt(0,candidates.len()-1)];
	if(DASH_CD)
	{
		DASH_CD=false;
		EntFireByHandle(self,"RunScriptCode","DASH_CD=true;",1.00,null,null);
	}
}

function CanUseAb_smash_forward() 
{
	local CTCounter=0;
	local ct=null;
	while(null!=(ct=Entities.FindInSphere(ct,self.GetOrigin(),SMASH_FORWARD_SEARCH_FORCAST)))
	if(ct.GetClassname() == "player" && ct.GetTeam() == 3 && ct.GetHealth() > 0)CTCounter++;
	if(CTCounter >= SMASH_FORWARD_MINPLAYER_FORCAST) return true;
	else
	return false
}

function Casting() 
{
	if(!smash_forward && !smash_run && !ultima && !jump)return true;
	return false;
}

function SpawnRandMessage(type) 
{
	if(CHAT_CD)
	{
		CHAT_CD=false;
		EntFireByHandle(self,"RunScriptCode","CHAT_CD=true;",CHAT_CDBACK,null,null);
		if(type)ScriptPrintMessageChatAll("MITHRIX: "+KillMessage[RandomInt(0,KillMessage.len()-1)].tostring());
		else ScriptPrintMessageChatAll("MITHRIX: "+DMGMessage[RandomInt(0,DMGMessage.len()-1)].tostring());
	}
}

function GetTargetYaw(start,target)
{
	local yaw=0.00;
	local v=Vector(start.x-target.x,start.y-target.y,start.z-target.z);
	local vl=sqrt(v.x*v.x+v.y*v.y);
	yaw=180*acos(v.x/vl)/3.14159;
	if(v.y<0)yaw=-yaw;
	return yaw;
}
function GetDistance(v1,v2)return sqrt((v1.x-v2.x)*(v1.x-v2.x)+(v1.y-v2.y)*(v1.y-v2.y)+(v1.z-v2.z)*(v1.z-v2.z));


JumpMessage<-[
	"Pray.",
	"Beg.",
	"Die.",
	"Be slaughtered."
];

KillMessage<-[
"Return to dirt.",
"Submit, vermin.",
"Die, vermin.",
"Die, weakling.",
"Become memories."
];

DMGMessage<-[
"Bleed.",
"Now is the time for fear.",
"Weak.",
"Frail - and soft.",
"You are nothing.",
"Mistake.",
"Scream, vermin.",
"Break beneath me.",
"Slow.",
"Your body will shatter."
];