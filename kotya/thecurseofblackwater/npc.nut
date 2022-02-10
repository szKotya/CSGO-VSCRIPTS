////////////////////////////////////////////////////////////////////
//Moving NPC by Luffaren[STEAM_0:1:22521282]
////////////////////////////////////////////////////////////////////
//NPC by Kotya[STEAM_1:1:124348087]
//update 04.09 version 0.98b
////////////////////////////////////////////////////////////////////
TICKRATE 	<- 	0.10;
TICKRATE_IDLE <- 0.50;
TARGET_DISTANCE <- 	1024;
RETARGET_TIME 	<- 	6.00;
SPEED_FORWARD 	<- 	1.00;
SPEED_TURNING 	<- 	1.00;
///////////////////
HeadShot <- 2;
BodyShot <- 1;
///////////////////
HpPerHuman <- 5;
HpBase <- 60;
///////////////////
HitBox_body <- null;
HitBox_head <- null;
tf <- null;
ts <- null;
Kepper <- null;
Sound0 <- null; //random
Sound1 <- null;
///////////////////
RandomSoundCD <- true;
RandomSoundCDBACK <- 5;
PlayRandomSoundCDBACK <- 6;
PlayRandomSoundCD <- true;
///////////////////
girl <- false;
BlackRoomPos <- "-4750 15284.5 6194";
Players <- [];
BLACKROOM_MAXPLAYER <- 2; //Максимум 2х человек тпшнит потом будет бить рукой
BLACKROOM_CDBACK <- 3;    //перерыв между телепортами(в этот момент бьет рукой)
GIRL_DAMAGE <- 10;        //Урон рукой(сквозь броню)
GIRL_DAMAGE_CDBACK <- 1;  //Перезарядка ударом рукой
///////////////////
decayed <- false;
DECAYED_DAMAGE <- 15;     //Удар рукой
DECAYED_DAMAGECDBACK <- 2;//Откат удара рукой(в этот момент не двигается вообще\убрать или оставить)
DECAYED_PUSHPOWER <- 500;//Отброс от удара руки
///////////////////
pincher <- false;
PINCHER_DAMAGE <- 20;    //Удар рукой
PINCHER_DAMAGECDBACK <- 1.5; //Перезарядка удара рукой
///////////////////
fade <- true;
target <- null;
ttime <- 0.00;
HP <- 100;
ticking <- false;
canmove <- true;
counter <- 0.00;
stopcounter <- 1;
DECAYED_DAMAGECD <- true; 	
PINCHER_DAMAGECD <- true;
BLACKROOM_CD <- true;
GIRL_DAMAGE_CD <- true;   
dontTakehp <- true;
debag <- true;
///////////////////
function SetHandleTs()ts = caller;
function SetHandleTf()tf = caller;
function SetHandleKepper()Kepper = caller;
function SetHandleHitBox_body()HitBox_body = caller;
function SetHandleHitBox_head()HitBox_head = caller;
function SetHandleSound0()Sound0 = caller;
function SetHandleSound1()Sound1 = caller;
///////////////////
ArraySounds <- [];
RandomSoundPincher <- [
	"Blackwater_sound/pincher/hunting1.mp3",
	"Blackwater_sound/pincher/hunting2.mp3",
	"Blackwater_sound/pincher/hunting3.mp3",
];
RandomSoundDecayed <- [
	"Blackwater_sound/decayed/creature01_vocal06.mp3",
	"Blackwater_sound/decayed/creature01_vocal03.mp3",
	"Blackwater_sound/decayed/creature01_vocal05.mp3",
];
RandomSoundGirl <- [
	"Blackwater_sound/girl/Angry2.mp3",
	"Blackwater_sound/girl/Angry3.mp3",
	"Blackwater_sound/girl/Angry4.mp3",
	"Blackwater_sound/girl/Angry5.mp3",
	"Blackwater_sound/girl/Angry6.mp3",
];

//////////////////////////////////////
function Start(type)
{
	if(!ticking)
	{
		if(type == 1)
		{
			RETARGET_TIME = 6.00;
			SPEED_FORWARD = 0.85;
			HpPerHuman = 15;
			HpBase = 500;
			HeadShot = 5;
			BodyShot = 1;
			pincher = true;
			PushSounds(RandomSoundPincher);
			if(debag)ScriptPrintMessageChatAll("pincher");
		}
		else if(type == 2)
		{
			RETARGET_TIME = 10.00;
			SPEED_FORWARD = 0.80;
			HpPerHuman = 20;
			HpBase = 600;
			HeadShot = 3;
			BodyShot = 1;
			decayed = true;
			PushSounds(RandomSoundDecayed);
			if(debag)ScriptPrintMessageChatAll("decayed");
		}
		else if(type == 3)
		{
			RETARGET_TIME = 5.00;
			SPEED_FORWARD = 0.95;
			HpPerHuman = 10;
			HpBase = 400;
			HeadShot = 8;
			BodyShot = 1;
			girl = true;
			PushSounds(RandomSoundGirl);
			if(debag)ScriptPrintMessageChatAll("girl");
		}
		ticking = true;
		Tick();
		if(debag)ScriptPrintMessageChatAll("Start");
		if(!Sound0)Sound0 = Sound1;
	}
}

function Stop()
{
    if(ticking)
    {
			if(girl)NowYouFree();
			ticking = false;
			if(debag)ScriptPrintMessageChatAll("Stop");
			EntFireByHandle(Sound0,"Voice","0",0.00,null,null);
			EntFireByHandle(Sound0,"StopSound","",0.00,null,null);
			EntFireByHandle(Sound1,"Playsound","",0.00,null,null);
			EntFireByHandle(tf,"Kill","",0.00,null,null);
			EntFireByHandle(ts,"Kill","",0.00,null,null);
			EntFireByHandle(Kepper,"Kill","",0.00,null,null);
			EntFireByHandle(HitBox_body,"Kill","",0.00,null,null);
			EntFireByHandle(HitBox_head,"Kill","",0.00,null,null);
			EntFireByHandle(Sound0,"Kill","",0.01,null,null);
			EntFireByHandle(Sound1,"Kill","",3,null,null);
			EntFireByHandle(self,"Kill","",0.02,null,null);
    }
}

function Tick()
{
	if(!ticking)return;
	if(debag)ScriptPrintMessageChatAll("Tick");
	RandomSound();
	EntFireByHandle(tf,"Deactivate","",0.00,null,null);
	EntFireByHandle(ts,"Deactivate","",0.00,null,null);
	if(target==null||target.GetClassname()!="player"||target.GetTeam()!=3||target.GetHealth()<=0)SearchTarget();
	if(target==null||target.GetClassname()!="player"||target.GetTeam()!=3||target.GetHealth()<=0)
	EntFireByHandle(self,"RunScriptCode","Tick()",TICKRATE_IDLE,null,null);
	else
	{
		if(canmove)
		{
			EntFireByHandle(tf,"Activate","",0.02,null,null);
			EntFireByHandle(ts,"Activate","",0.02,null,null);
			local sa = self.GetAngles().y;
			local ta = GetTargetYaw(self.GetOrigin(),target.GetOrigin());
			local spos = GVO(self.GetOrigin(),0,0,80);
			if(abs((sa-ta+360)%360)>=180)EntFireByHandle(ts,"AddOutput","angles 0 270 0",0.00,null,null);
			else EntFireByHandle(ts,"AddOutput","angles 0 90 0",0.00,null,null);
			local angdif = (sa-ta-180);while(angdif>360){angdif-=180;}while(angdif< -180){angdif+=360;}angdif=abs(angdif);
			EntFireByHandle(tf,"AddOutput","force "+(2000*SPEED_FORWARD).tostring(),0.00,null,null);
			EntFireByHandle(ts,"AddOutput","force "+(35*angdif).tostring(),0.00,null,null);
			if(GetDistance(self.GetOrigin(),target.GetOrigin())<100)Attact(); 
			ttime+=TICKRATE;
			if(!InSight(spos,GVO(target.GetOrigin(),0,0,80)))counter+=0.10;
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
	counter = 0.00;
	local h = null;
	local candidates = [];
	local counterCT = 0;
	local spos = GVO(self.GetOrigin(),0,0,80);
	while(null!=(h=Entities.FindInSphere(h,self.GetOrigin(),TARGET_DISTANCE)))
	{
		if(h.GetClassname()=="player" && h.GetTeam()==3 && h.GetHealth()>0)
		{
			counterCT++;
			
			if(InSight(spos,h.GetOrigin()))
			{
				if(debag)TestLine(spos,h.GetOrigin());
				candidates.push(h);
			}
		} 
	}
	if(candidates.len()==0)return;
	else
	{
		target = candidates[RandomInt(0,candidates.len()-1)];
		PlayRandomSound()
		if(dontTakehp)
		{
			dontTakehp = false;
			HP = HpBase+(counterCT*HpPerHuman);
		}
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
				PlayRandomSound()
				if(dontTakehp)
				{
					local ctcount=0;
					local hlist=[];
					local h=null;
					while(null!=(h=Entities.FindInSphere(h,self.GetOrigin(),TARGET_DISTANCE*1.5)))
					{if(h.GetClassname()=="player"&&h.GetTeam()==3&&h.GetHealth()>0){ctcount++;}}dontTakehp = false;
					HP = HpBase+(ctcount*HpPerHuman);
				}
			}
		}
}

function RandomSound() 
{
	if(RandomSoundCD)
	{
		RandomSoundCD = false;
		EntFireByHandle(self,"RunScriptCode","RandomSoundCD = true;",RandomSoundCDBACK,null,null);
		EntFireByHandle(Sound0,"AddOutput","message *"+ArraySounds[RandomInt(0,ArraySounds.len()-1)],0.00,null,null);
	}
}

function PushSounds(Array)for(local i=0; i<Array.len(); i++)ArraySounds.push(Array[i]);

function PlayRandomSound() 
{
	if(PlayRandomSoundCD)
	{
		PlayRandomSoundCD = false;
		EntFireByHandle(Sound0,"Volume","0",0.00,null,null);
		EntFireByHandle(Sound0,"StopSound","",0.00,null,null);
		EntFireByHandle(Sound0,"Volume","10",0.01,null,null);
		EntFireByHandle(Sound0,"PlaySound","",0.01,null,null);
		EntFireByHandle(self,"RunScriptCode","PlayRandomSoundCD = true;",PlayRandomSoundCDBACK,null,null);
	}
}

function TakeDamageHead(){TakeDamage(HeadShot);}
function TakeDamageBody(){TakeDamage(BodyShot);}
function TakeDamage(i) 
{
	if(ticking)
	{
		if(HP > 0)
		{
			local l_HP = HP - i;
			if(l_HP<=0)Stop();
			else 
			{
				HP = l_HP;
			}
		}
		else 
		{
			Stop();
		}
	}
}
function Attact()
{
	if(pincher)
	{
		if(PINCHER_DAMAGECD)
		{
			PINCHER_DAMAGECD = false;
			EntFireByHandle(self,"RunScriptCode","PINCHER_DAMAGECD = true;",PINCHER_DAMAGECDBACK,null,null);
			local h=null;
			while(null!=(h=Entities.FindInSphere(h,target.GetOrigin()+Vector(0,0,48),120)))
			{
				if(h.GetClassname()=="player"&&h.GetTeam()==3&&h.GetHealth()>0)
				{
					TargetTakeDamage(PINCHER_DAMAGE,h);
					EntFire("pincher_fade","fade","",0.01,h);
				}
			}
		}
	}
	else if(girl)
	{
		if(BLACKROOM_MAXPLAYER > Players.len() && BLACKROOM_CD)
		{
			
			Players.push(target);
			EntFireByHandle(target,"RunScriptCode","savepos <- self.GetOrigin();",0.00,null,null);
			EntFireByHandle(target,"addoutput","origin "+BlackRoomPos,0.01,null,null);
			EntFire("creepygirl_fade","fade","",0.01,target);
			EntFireByHandle(self,"RunScriptCode","BLACKROOM_CD = true;",BLACKROOM_CDBACK,null,null);
			EntFireByHandle(self,"RunScriptCode","target = null;",0.02,null,null);
		}
		else
		{
			if(GIRL_DAMAGE_CD)
			{
				GIRL_DAMAGE_CD = false;
				EntFire("pincher_fade","fade","",0.01,target);
				EntFireByHandle(self,"RunScriptCode","GIRL_DAMAGE_CD = true;",GIRL_DAMAGE_CDBACK,null,null);
				TargetTakeDamage(GIRL_DAMAGE,target);
			}
		}
	}
	else if(decayed)
	{
		canmove = false;
		EntFireByHandle(tf,"Deactivate","",0.00,null,null);
		EntFireByHandle(ts,"Deactivate","",0.00,null,null);	
		EntFireByHandle(self,"RunScriptCode","canmove = true;",DECAYED_DAMAGECDBACK,null,null);
		local h=null;
		while(null!=(h=Entities.FindInSphere(h,target.GetOrigin()+Vector(0,0,48),120)))
		{
			if(h.GetClassname()=="player"&&h.GetTeam()==3&&h.GetHealth()>0)
			{
				local vec = (self.GetOrigin()-target.GetOrigin());
				vec.Norm();
				TargetTakeDamage(DECAYED_DAMAGE,h);
				EntFire("decayed_fade","fade","",0.01,h);
				EntFireByHandle(h,"AddOutput","basevelocity "+(-vec.x*DECAYED_PUSHPOWER).tostring()+" "+(-vec.y*DECAYED_PUSHPOWER).tostring()+" "+(DECAYED_PUSHPOWER/2).tostring(),0.00,null,null);
			}
		}
	}
}
function TargetTakeDamage(i,who) 
{
	local hp = who.GetHealth()-i;
	if(hp<=0)EntFireByHandle(who,"SetHealth","0",0.00,null,null);
	EntFireByHandle(who,"SetHealth",hp.tostring(),0.00,null,null);	
}

function NowYouFree() 
{
	if(Players.len()==0)return;
	for(local i=0; i<=Players.len()-1;i++)
	{
		EntFireByHandle(Players[i],"RunScriptCode","self.SetOrigin(savepos);",0.00,null,null);
		EntFireByHandle(Players[i],"RunScriptCode","savepos <- null;",0.01,null,null);
	}
}
function TestLine(start,end)DebugDrawLine(start, end, 255, 255, 255, true, 5)
	
function GetTargetYaw(start,target)
{
	local yaw = 0.00;
	local v = Vector(start.x-target.x,start.y-target.y,start.z-target.z);
	local vl = sqrt(v.x*v.x+v.y*v.y);
	yaw = 180*acos(v.x/vl)/3.14159;
	if(v.y<0)yaw=-yaw;
	return yaw;
}
function GVO(vec,_x,_y,_z){return Vector(vec.x+_x,vec.y+_y,vec.z+_z);}
function InSight(start,target){if(TraceLine(start,target,self)<1.00)return false;return true;}
function GetDistance(v1,v2)return sqrt((v1.x-v2.x)*(v1.x-v2.x)+(v1.y-v2.y)*(v1.y-v2.y)+(v1.z-v2.z)*(v1.z-v2.z));
//function TakeDamage()ScriptPrintMessageChatAll(HitBox.GetHealth().tostring());