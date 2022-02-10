/*
Script by Kotya[STEAM_1:1:124348087]
update 07.12.2020

　　　　　　iヽ　　　　　　/ヽ
　　　 　 　|　ﾞヽ、　　　　/ 　ﾞi
　 　 　 　 |　　　ﾞ''─‐'''''''''"　 　 l
　　　　　,/　　　 　 　 　 　　 ﾞヽ
　　　　 ,iﾞ 　　　／　 　 　 　 　　＼
　　　 　i!　　　　　●　 　 　　●　　,l
　　　　 ﾞi,,　　　* 　 （__人__）　　,/
　　　　　 ヾ､,,　　　　　　　 　 ,／
　　 　　 /ﾞ "　　　　　　　　　ヽ
　　　　/　　　　　　　　　　　　 i!
　　(　) 　　　　　　　i　　　!　　 i!.,
　　　　γ"　⌒ﾞヽ　　　l　　　l　　γ'.ヽ
　　　　 i　　 　 i,__,,ﾉ　　　i,__,,ﾉ_,, 丿
　　　　 ヽ,＿,,ノ"~´　

*/
nullVector <- Vector(0,0,0)
TeleportPos <- Entities.FindByName(null, "demon_sephiroth_boss_falloff_teleport_destination").GetOrigin();
debug <- false;

BeeMaker 		<- Entities.FindByName(null, "npc_bee_maker");
//UltimateMaker 	<- Entities.FindByName(null, "sephiroth_npc_ultimate_mirror_maker1");
FireMaker 		<- Entities.FindByName(null, "sephiroth_npc_fire_maker");
GravityMaker 	<- Entities.FindByName(null, "sephiroth_npc_gravity_maker");
PoisonMaker 	<- Entities.FindByName(null, "sephiroth_npc_poison_maker");
MakoMaker 	    <- Entities.FindByName(null, "sephiroth_npc_mako_maker");

BossMover 		<- Entities.FindByName(null, "sephiroth_npc_physbox");

IfritModel 		<- Entities.FindByName(null, "Shinra_Ifrit");
ShivaModel 		<- Entities.FindByName(null, "Shinra_Shiva");
JenovaModel 	<- Entities.FindByName(null, "Jenova_Model");
//attack hurt"s
SlashSound 		<- Entities.FindByName(null, "sephiroth_npc_slash_sound");
wideHurt 		<- Entities.FindByName(null, "sephiroth_npc_hurt_wide");
frontHurt 		<- Entities.FindByName(null, "sephiroth_npc_hurt_front");

class Boss
{
    Alive = true;
    Focus = 0;
    ResetAbb = -1;
    constructor(){}
	function GetAlive() {
		return this.Alive;
	}
	function GetFocus() {
		return this.Focus;
	}
	function GetResetAbb() {
		return this.ResetAbb;
	}
	function SetResetAbb(i) {
		this.ResetAbb = i;
		return
	}
    	function SetDeath() {
		this.Alive = false;
		return
	}
	function PrintStats() {
		ScriptPrintMessageChatAll("Alive "+(this.Alive).tostring())
		ScriptPrintMessageChatAll("Focus "+(this.Focus).tostring())
		ScriptPrintMessageChatAll("ResetAbb "+(this.ResetAbb).tostring())
		return
	}
}
function PrintHero()
{
	ScriptPrintMessageChatAll("Sephiroth");
	Sephiroth.PrintStats();
	if(WindUse)ScriptPrintMessageChatAll("1\x04  Wind");
	else ScriptPrintMessageChatAll("1\x02 Wind");
	if(GravityUse)ScriptPrintMessageChatAll("1\x04  Gravity");
	else ScriptPrintMessageChatAll("1\x02 Gravity");
	if(UltimaUse)ScriptPrintMessageChatAll("1\x04  Ultima");
	else ScriptPrintMessageChatAll("1\x02 Ultima");
	ScriptPrintMessageChatAll("----------");
	ScriptPrintMessageChatAll("Ifrit");
	Ifrit.PrintStats();
	if(BeeUse)ScriptPrintMessageChatAll("1\x04  Bee");
	else ScriptPrintMessageChatAll("1\x02 Bee");
	if(FireUse)ScriptPrintMessageChatAll("1\x04  Fire");
	else ScriptPrintMessageChatAll("1\x02 Fire");
	if(BerserkUse)ScriptPrintMessageChatAll("1\x04  Berserk");
	else ScriptPrintMessageChatAll("1\x02 Berserk");
	ScriptPrintMessageChatAll("----------");
	ScriptPrintMessageChatAll("Shiva");
	Shiva.PrintStats();
	if(ShieldUse)ScriptPrintMessageChatAll("1\x04  Shield");
	else ScriptPrintMessageChatAll("1\x02 Shield");
	if(HealUse)ScriptPrintMessageChatAll("1\x04  Heal");
	else ScriptPrintMessageChatAll("1\x02 Heal");
	if(AspilUse)ScriptPrintMessageChatAll("1\x04  Aspil");
	else ScriptPrintMessageChatAll("1\x02 Aspil");
	ScriptPrintMessageChatAll("----------");
	ScriptPrintMessageChatAll("Jenova");
	Jenova.PrintStats();
	if(PoisonUse)ScriptPrintMessageChatAll("1\x04  Poison");
	else ScriptPrintMessageChatAll("1\x02 Poison");
	if(MimicUse)ScriptPrintMessageChatAll("1\x04  Mimic");
	else ScriptPrintMessageChatAll("1\x02 Mimic");
	if(MakoUse)ScriptPrintMessageChatAll("1\x04  Mako");
	else ScriptPrintMessageChatAll("1\x02 Mako");
	ScriptPrintMessageChatAll("----------");
}
Sephiroth <- Boss();
Ifrit <- Boss();
Shiva <- Boss();
Jenova <- Boss();

Attacking 	<- false;
Stage <- 0;
canAttack 	<- true;
Global_CD   <- 10;
Global_CAN  <- false;
///////////////
//  UseBLOCK //
///////////////
BeeCD <- 15;
BeeUse <- true;
///////////////
FireCD <- 15;
FireUse <- true;
///////////////
BerserkCD <- 15;
BerserkUse <- true;
///////////////
WindCD <- 15;
WindUse <- true;
///////////////

//unlock 10 stage
UltimaCD <- 15;
UltimaUse <- false;

//////////////

//unlock 4 stage
GravityCD <- 15;
GravityUse <- false;

///////////////
ShieldCD <- 15;
ShieldUse <- true;
///////////////
HealHPperHuman <- 25;
HealCD <- 15;
HealUse <- true;
///////////////
AspilCD <- 15;
AspilUse <- true;
///////////////
PoisonCD <- 15;
PoisonUse <- true;
///////////////

//unlock 8 stage
MakoCD <- 15;
MakoUse <- false;

///////////////

//unlock 6 stage
MimicCD <- 15;
MimicUse <- false;

m_Bee <- false;
m_Fire <- false;
m_Wind <- false;
m_Gravity <- false;
m_Heal <- false;
m_Poison <- false;
m_Aspil <- false;
m_Berserk <- false;
m_Shield <- false;
m_Ultimate <- false;
///////////////
//    END    //
///////////////
LastPos <- [];
TICKRATE <- 0.5;

ticking <- false;

sphereRadius <- 140;
defaultSpeed <- 0.85;
Target <- null;
function Start(){
	if(!ticking)
	{
        EntFireByHandle(self,"SetDefaultAnimation",RunAnim,0.01,null,null);
        EntFireByHandle(self,"SetAnimation",RunAnim,0.00,null,null);
        EntFireByHandle(self,"RunScriptCode","Global_CAN = true;",10,null,null);
        EntFireByHandle(self,"RunScriptCode","ChangeSpeedForward(defaultSpeed)",0.05,null,null);
        ticking = true;
        Tick();
	}
}

function Tick(){
    if(ticking)
    {
        EntFireByHandle(self,"RunScriptCode","Tick();",TICKRATE,null,null);
        Target = Entities.FindByClassnameWithin(null,"player",self.GetOrigin(),sphereRadius);
        if(!Attacking && Global_CAN)PickSpellAttack()
        if(Target!=null)
        {
            //printl(Target);
            if(Target.GetTeam()==3&&Target.GetHealth()>0)
            {
            Attack();
            Target = null;
            }
        }
    }
}

function Attack(){
    local randomNumber = RandomInt(0,6);
    if(canAttack && !Attacking)
    {
        canAttack = false;
        Attacking = true;
        if(randomNumber == 0)
        {
            Attack1();
        }
        else if(randomNumber == 1)
        {
            Attack2();
        }
        else if(randomNumber == 2)
        {
            Attack3();
        }
        else if(randomNumber == 3)
        {
            Attack4();
        }
        else if(randomNumber == 4)
        {
            Attack5();
        }
        else if(randomNumber == 5)
        {
            Attack6();
        }
        else if(randomNumber == 6)
        {
            Attack7();
        }
    }
}

function PickSpellAttack()
{
	local WhoCanAttack = [];
	Stage++;
	if(debug)ScriptPrintMessageChatAll("Stage "+Stage.tostring())
    if(Sephiroth.GetAlive())
    {
		if(Stage==8){GravityUse = true;}
		if(Stage==5){UltimaUse = true;}
		if(WindUse || GravityUse || UltimaUse)
		{
			Sephiroth.SetResetAbb(-1);
			WhoCanAttack.push("Sephiroth");
		}
		if(Sephiroth.GetResetAbb() > 0)Sephiroth.ResetAbb--;
		if(Sephiroth.GetResetAbb() == 0)
		{
			Sephiroth.SetResetAbb(-1);
			if(Stage>=5){GravityUse = true;}
			WindUse = true;

			if(debug)ScriptPrintMessageChatAll("Reset Seph")
		}
		if(WindUse || GravityUse || UltimaUse)
		{
			if(UltimaUse)EntFire("sephiroth_npc_visual_ultima", "Start","", 0, null);
			if(GravityUse)EntFire("sephiroth_npc_visual_gravity", "Start","", 0, null);
			if(WindUse)EntFire("sephiroth_npc_visual_wind", "Start","", 0, null);
		}
    }
    if(Ifrit.GetAlive())
    {
        if(BeeUse || FireUse || BerserkUse)
		{
			Ifrit.SetResetAbb(-1);
			WhoCanAttack.push("Ifrit");
		}
		if(Ifrit.GetResetAbb() > 0)Ifrit.ResetAbb--;
		if(Ifrit.GetResetAbb() == 0)
		{
			Ifrit.SetResetAbb(-1);
			BeeUse = true;
			FireUse = true;
			BerserkUse = true;
			if(debug)ScriptPrintMessageChatAll("Reset Ifrit")
		}
    }
    if(Shiva.GetAlive())
    {
        if(Stage==8)MakoUse = true;
        if(HealUse || MakoUse || AspilUse)
		{
			Shiva.SetResetAbb(-1);
			WhoCanAttack.push("Shiva");
		}
		if(Shiva.GetResetAbb() > 0)Shiva.ResetAbb--;
		if(Shiva.GetResetAbb() == 0)
		{
			Shiva.SetResetAbb(-1);
			HealUse = true;
			AspilUse = true;
			if(debug)ScriptPrintMessageChatAll("Reset Shiva")
		}
    }
    if(Jenova.GetAlive())
    {
		if(Stage==2)MimicUse = true;
        if(PoisonUse || MimicUse || ShieldUse)
		{
			Jenova.SetResetAbb(-1);
			WhoCanAttack.push("Jenova");
		}
		if(Jenova.GetResetAbb() > 0)Jenova.ResetAbb--;
		if(Jenova.GetResetAbb() == 0)
		{
			Jenova.SetResetAbb(-1);
			PoisonUse = true;
            ShieldUse = true;
			if(debug)ScriptPrintMessageChatAll("Reset Jenova")
		}
    }
//random pick
	if(WhoCanAttack.len==0)return PickSpellAttack();
    switch (WhoCanAttack[RandomInt(0,WhoCanAttack.len()-1)])
    {
        case "Sephiroth":
            local WhatCast = [];
            if(WindUse)
			{
				WhatCast.push("Wind");
			}
            if(GravityUse)
			{
				WhatCast.push("Gravity");
			}

            if(UltimaUse)
			{
				WhatCast.push("Ultima");
			}
            if(WhatCast.len() <= 1)
			{
				Sephiroth.SetResetAbb(3);
				//ScriptPrintMessageChatAll("Sephiroth reset start");
			}
            switch (WhatCast[RandomInt(0,WhatCast.len()-1)])
            {
            	case "Wind":
					WindUse = false;
					EntFire("sephiroth_npc_visual_wind", "Stop","", 2, null);
					SetMimic(2)
					ScriptPrintMessageChatAll(::WindMes);
					Wind();
					break;
                case "Gravity":
					GravityUse = false;
					EntFire("sephiroth_npc_visual_gravity", "Stop","", 2, null);
					SetMimic(3)
					ScriptPrintMessageChatAll(::GravityMes);
					Gravity();
					break;
                case "Ultima":
					UltimaUse = false;
					EntFire("sephiroth_npc_visual_ultima", "Stop","", 2, null);
					ScriptPrintMessageChatAll(::UltimateMes);
					Ultimate();
					break;
            }
            break;
        case "Ifrit":
            local WhatCast = [];
            if(BeeUse)WhatCast.push("Bee");
            if(FireUse)WhatCast.push("Fire");
            if(BerserkUse)WhatCast.push("Berserk");
            if(WhatCast.len() <= 1)
			{
				Ifrit.SetResetAbb(3);
				//ScriptPrintMessageChatAll("Ifrit reset start");
			}
            switch (WhatCast[RandomInt(0,WhatCast.len()-1)])
            {
                case "Bee":
					BeeUse = false;
					SetMimic(0)
					ScriptPrintMessageChatAll(::BeeMes);
					Bee();
					break;
                case "Fire":
					FireUse = false;
					SetMimic(1)
					ScriptPrintMessageChatAll(::FireMes);
					Fire();
					break;
                case "Berserk":
					BerserkUse = false;
					SetMimic(8)
					ScriptPrintMessageChatAll(::BerserkMes);
					Berserk();
					break;
            }
            break;
        case "Shiva":
            local WhatCast = [];
            if(MakoUse)WhatCast.push("Mako");
            if(HealUse)WhatCast.push("Heal");
            if(AspilUse)WhatCast.push("Aspil");
            if(WhatCast.len() <= 1)
			{
				//ScriptPrintMessageChatAll("Shiva reset start");
				Shiva.SetResetAbb(3);
			}
            switch (WhatCast[RandomInt(0,WhatCast.len()-1)])
            {
                case "Mako":
					SetMimic(6);
    				MakoUse = false
					Mako();
					ScriptPrintMessageChatAll(::MakoMes);
					break;
                case "Heal":
					HealUse = false
					SetMimic(4);
					ScriptPrintMessageChatAll(::HealMes);
					Heal();
					break;
                case "Aspil":
					AspilUse = false;
					SetMimic(7);
					ScriptPrintMessageChatAll(::AspilMes);
					Aspil();
					break;
            }
            break;
        case "Jenova":
            local WhatCast = [];
            if(PoisonUse)WhatCast.push("Poison");
            if(MimicUse)WhatCast.push("Mimic");
            if(ShieldUse)WhatCast.push("Shield");
            if(WhatCast.len() <= 1)
			{
				Jenova.SetResetAbb(3);
				//ScriptPrintMessageChatAll("Shiva reset start");
			}
            switch (WhatCast[RandomInt(0,WhatCast.len()-1)])
            {
                case "Poison":
					PoisonUse = false;
					SetMimic(5)
					ScriptPrintMessageChatAll(::PoisonMes);
					Poison();
					break;
                case "Mimic":
                    MimicUse = false;
					Mimic();
                    ScriptPrintMessageChatAll(::MimicMes);
					break;
                case "Shield":
					ShieldUse = false
					SetMimic(9);
					ScriptPrintMessageChatAll(::ShieldMes);
					Shield();
					break;
            }
            break;
    }
    //last work
}

function Attack1(){
    //animation speed = 25
    // front
    SetAnimation(Attack1Anim);
    EntFireByHandle(self,"RunScriptCode","ChangeSpeedForward(0.2)",0.4,null,null);
    EntFireByHandle(SlashSound,"PlaySound","",0.4,null,null);
    EntFireByHandle(frontHurt,"Enable","",0.4,null,null);
    EntFireByHandle(frontHurt,"Disable","",0.7,null,null);
    EntFireByHandle(self,"RunScriptCode","Attacking = false;",2.08-0.05,null,null);
    EntFireByHandle(self,"RunScriptCode","ChangeSpeedForward(defaultSpeed)",2.08,null,null);
}

function Attack2(){
    //animation speed = 25
    // wide
    SetAnimation(Attack2Anim);
    EntFireByHandle(self,"RunScriptCode","ChangeSpeedForward(0.2)",0.68,null,null);
    EntFireByHandle(SlashSound,"PlaySound","",0.68,null,null);
    EntFireByHandle(wideHurt,"Enable","",0.68,null,null);
    EntFireByHandle(wideHurt,"Disable","",0.9,null,null);
    EntFireByHandle(self,"RunScriptCode","Attacking = false;",2-0.05,null,null);
    EntFireByHandle(self,"RunScriptCode","ChangeSpeedForward(defaultSpeed)",2,null,null);
}

function Attack3(){
    //animation speed = 25
    // front
    SetAnimation(Attack3Anim);
    EntFireByHandle(self,"RunScriptCode","ChangeSpeedForward(0.4)",0.4,null,null);
    EntFireByHandle(SlashSound,"PlaySound","",0.4,null,null);
    EntFireByHandle(frontHurt,"Enable","",0.4,null,null);
    EntFireByHandle(frontHurt,"Disable","",0.7,null,null);
    EntFireByHandle(self,"RunScriptCode","Attacking = false;",2.4-0.05,null,null);
    EntFireByHandle(self,"RunScriptCode","ChangeSpeedForward(defaultSpeed)",2.4,null,null);
}

function Attack4(){
    //animation speed = 25
    // front
    SetAnimation(Attack4Anim);
    EntFireByHandle(self,"RunScriptCode","ChangeSpeedForward(0.4)",0.88,null,null);
    EntFireByHandle(SlashSound,"PlaySound","",0.88,null,null);
    EntFireByHandle(frontHurt,"Enable","",0.88,null,null);
    EntFireByHandle(frontHurt,"Disable","",1.12,null,null);
    EntFireByHandle(self,"RunScriptCode","Attacking = false;",2.88-0.05,null,null);
    EntFireByHandle(self,"RunScriptCode","ChangeSpeedForward(defaultSpeed)",2.88,null,null);
}

function Attack5(){
    //animation speed = 25
    // wide
    SetAnimation(Attack5Anim);
    EntFireByHandle(self,"RunScriptCode","ChangeSpeedForward(0.2)",0.0,null,null);
    EntFireByHandle(SlashSound,"PlaySound","",0.36,null,null);
    EntFireByHandle(wideHurt,"Enable","",0.36,null,null);
    EntFireByHandle(wideHurt,"Disable","",0.5,null,null);
    EntFireByHandle(self,"RunScriptCode","Attacking = false;",2.16-0.05,null,null);
    EntFireByHandle(self,"RunScriptCode","ChangeSpeedForward(defaultSpeed)",2.16,null,null);
}

function Attack6(){
    //animation speed = 18
    // wide
    SetAnimation(Attack6Anim);
    EntFireByHandle(self,"RunScriptCode","ChangeSpeedForward(0.2)",0.44,null,null);
    EntFireByHandle(SlashSound,"PlaySound","",0.44,null,null);
    EntFireByHandle(wideHurt,"Enable","",0.44,null,null);
    EntFireByHandle(wideHurt,"Disable","",0.64,null,null);
    EntFireByHandle(self,"RunScriptCode","Attacking = false;",3.11-0.05,null,null);
    EntFireByHandle(self,"RunScriptCode","ChangeSpeedForward(defaultSpeed)",3.11,null,null);
}

function Attack7(){
    //animation speed = 12
    // wide
    SetAnimation(Attack7Anim);
    EntFireByHandle(self,"RunScriptCode","ChangeSpeedForward(0.2)",0.1,null,null);
    EntFireByHandle(SlashSound,"PlaySound","",0.5,null,null);
    EntFireByHandle(wideHurt,"Enable","",0.5,null,null);
    EntFireByHandle(wideHurt,"Disable","",0.7,null,null);
    EntFireByHandle(SlashSound,"PlaySound","",1,null,null);
    EntFireByHandle(wideHurt,"Enable","",1,null,null);
    EntFireByHandle(wideHurt,"Disable","",1.3,null,null);
    EntFireByHandle(self,"RunScriptCode","Attacking = false;",3-0.05,null,null);
    EntFireByHandle(self,"RunScriptCode","ChangeSpeedForward(defaultSpeed)",3,null,null);
}

BeeSpawnPos <-[
Vector(-13155 12543 1300),
Vector(-12777 12543 1300),
Vector(-12399 12543 1300),
Vector(-12021 12543 1300)];
function Bee()
{
    Global_CAN = false;
    BeeUse = false;
    local IfritDefPos = IfritModel.GetOrigin();
    local delay = 2.0;
    local time = 0;
    local Pos = BeeSpawnPos.slice(0,BeeSpawnPos.len());
    local count = RandomInt(3,6);
    EntFire("Shinra_Ifrit_Effect", "Start","", 0, null);
    for(local i=0;i<count;i++)
    {
        if(Pos.len()==0)Pos = BeeSpawnPos.slice(0,BeeSpawnPos.len());
        local random = RandomInt(0,Pos.len()-1);
        EntFire("Shinra_Ifrit_Effect", "DestroyImmediately","", delay+time-1.1, null);
        EntFire("Shinra_Ifrit_Effect", "Start","", delay+time-1, null);
        EntFireByHandle(IfritModel,"SetAnimation","kulak1",delay+time-0.5,null,null);
        EntFireByHandle(IfritModel,"SetAnimation","idle1",delay+time+1,null,null);
        EntFireByHandle(self,"RunScriptCode","IfritPos("+Pos[random].x.tostring()+","+(Pos[random].y-350).tostring()+","+(Pos[random].z+25).tostring()+")",delay+time-1,null,null);
        EntFireByHandle(self,"RunScriptCode","BeeSpawn("+Pos[random].x.tostring()+","+Pos[random].y.tostring()+","+Pos[random].z.tostring()+")",delay+time,null,null);
        Pos.remove(random);
        time+=RandomFloat(1.8,2.4);
    }
    EntFireByHandle(self,"RunScriptCode","Global_CAN = true;",delay+time+Global_CD-5,null,null);
    EntFire("Shinra_Ifrit_Effect", "DestroyImmediately","", delay+time, null);
    EntFireByHandle(self,"RunScriptCode","IfritPos("+IfritDefPos.x.tostring()+","+IfritDefPos.y.tostring()+","+IfritDefPos.z.tostring()+")",delay+time,null,null);
}

function BeeSpawn(x,y,z){BeeMaker.SpawnEntityAtLocation(Vector(x,y,z),nullVector)}

FireSpawnPos <- [Vector(-13155 12543 1300),
    Vector(-12777 12543 1300),
    Vector(-12399 12543 1300),
    Vector(-12021 12543 1300)];

function Fire(){
    Global_CAN = false;
    local IfritDefPos = IfritModel.GetOrigin();
    local delay = 2.0;
    local time = 0;
    local Pos = FireSpawnPos.slice(0,FireSpawnPos.len());
    EntFire("Shinra_Ifrit_Effect", "Start","", 0, null);
    FireUse = false;
    for(local i=0; i<FireSpawnPos.len(); i++)
    {
        local random = RandomInt(0,Pos.len()-1);
        EntFire("Shinra_Ifrit_Effect", "DestroyImmediately","", delay+time-1.1, null);
        EntFire("Shinra_Ifrit_Effect", "Start","", delay+time-1, null);
        EntFireByHandle(IfritModel,"SetAnimation","kulak1",delay+time-0.5,null,null);
        EntFireByHandle(IfritModel,"SetAnimation","idle1",delay+time+1,null,null);
        EntFireByHandle(self,"RunScriptCode","IfritPos("+Pos[random].x.tostring()+","+(Pos[random].y-350).tostring()+","+(Pos[random].z+25).tostring()+")",delay+time-1,null,null);
        EntFireByHandle(self,"RunScriptCode","FireSpawn("+Pos[random].x.tostring()+","+Pos[random].y.tostring()+","+Pos[random].z.tostring()+")",delay+time,null,null);
        Pos.remove(random);
        time+=RandomFloat(1.9,2.4);
    }
    EntFireByHandle(self,"RunScriptCode","Global_CAN = true;",delay+time+Global_CD+5,null,null);
    EntFire("Shinra_Ifrit_Effect", "DestroyImmediately","", delay+time, null);
    EntFireByHandle(self,"RunScriptCode","IfritPos("+IfritDefPos.x.tostring()+","+IfritDefPos.y.tostring()+","+IfritDefPos.z.tostring()+")",delay+time,null,null);
}

function FireSpawn(x,y,z){FireMaker.SpawnEntityAtLocation(Vector(x,y,z),nullVector)}

function IfritPos(x,y,z){IfritModel.SetOrigin(Vector(x,y,z))}

function Berserk(){
    Global_CAN = false;
    Attacking = true;
    local delay = 2.0;
    local time = 5;
    EntFireByHandle(self,"RunScriptCode","ChangeSpeedForward(0.1)",delay-0.5,null,null);
    EntFire("sephiroth_npc_rage_effect", "Start","", delay-0.5, null);
    EntFireByHandle(self,"RunScriptCode","SetAnimation(Idle2Anim)",delay,null,null);
    EntFireByHandle(frontHurt,"AddOutPut","damage 300",delay,null,null);
    EntFireByHandle(wideHurt,"AddOutPut","damage 150",delay,null,null);
    EntFireByHandle(self,"RunScriptCode","defaultSpeed = 1.2",delay+5-0.05,null,null);
    EntFireByHandle(self,"RunScriptCode","ChangeSpeedForward(defaultSpeed)",delay+5,null,null);
    for(local i=0;i<10;i++)
    {
        EntFire("demon_sephiroth_boss_health", "Subtract","5", delay+0.1+time, null);
        time+=1;
    }
    EntFireByHandle(frontHurt,"AddOutPut","damage 150",delay+time+6,null,null);
    EntFireByHandle(wideHurt,"AddOutPut","damage 75",delay+time+6,null,null);
    EntFire("sephiroth_npc_rage_effect", "Stop","", delay+time+6, null);
    EntFireByHandle(self,"RunScriptCode","defaultSpeed = 0.85",delay+time-0.05+6,null,null);
    EntFireByHandle(self,"RunScriptCode","Attacking = false",delay+5-0.05,null,null);
    EntFireByHandle(self,"RunScriptCode","Global_CAN = true;",delay+time+Global_CD-5,null,null);
    if(!Attacking)EntFireByHandle(self,"RunScriptCode","ChangeSpeedForward(defaultSpeed)",delay+time+6,null,null);
}

GravityPos <- [Vector(-12096 13584 1300),
        Vector(-12588 13584 1300),
        Vector(-13080 13584 1300)];
function Gravity(){
    Global_CAN = false;
    local delay = 2.0;
    local time = 0;
    local Pos = GravityPos.slice(0,GravityPos.len());
    local count = RandomInt(8,10);
    EntFire("zeddy_boss_hurt", "Enable","", 0, null);
    EntFire("sephiroth_npc_gravity_Effect", "Start","", 0, null);
    //GravityUse = false;
    for(local i=0;i<count;i++)
    {
        if(Pos.len()==0)Pos = GravityPos.slice(0,GravityPos.len());
        local random = RandomInt(0,Pos.len()-1);
        EntFireByHandle(self,"RunScriptCode","RandomPickAnim()",delay+time-0.5,null,null);
        EntFireByHandle(self,"RunScriptCode","GravitySpawn("+Pos[random].x.tostring()+","+Pos[random].y.tostring()+","+Pos[random].z.tostring()+")",delay+time,null,null);
        Pos.remove(random);
        time+=RandomFloat(2,2.4);
    }
    EntFire("zeddy_boss_hurt", "Disable","", delay+time, null);
    EntFireByHandle(BossMover,"DisableMotion","",0.02,null,null);
    EntFireByHandle(self,"SetDefaultAnimation",RunAnim,time,null,null);
    EntFireByHandle(self,"SetAnimation",RunAnim,time,null,null);
    EntFireByHandle(BossMover,"EnableMotion","",time,null,null);
    SetAnimation(IdleAnim);
    SetDefAnimation(IdleAnim);
    BossMover.SetAngles(0,270,0);
    BossMover.SetOrigin(Vector(-12601,14055,1325));
    EntFireByHandle(self,"RunScriptCode","BossMover.SetOrigin(TeleportPos);",delay+time-0.5,null,null);
    EntFire("sephiroth_npc_gravity_Effect", "Stop","", delay+time, null);
    EntFireByHandle(self,"RunScriptCode","Global_CAN = true;",delay+Global_CD+time+5,null,null);
}
function GravitySpawn(x,y,z){GravityMaker.SpawnEntityAtLocation(Vector(x,y,z),nullVector)}

function Ultimate(){
    Global_CAN = false;
    local delay = 2.0;
    EntFire("sephiroth_npc_ultimate_Effect", "Start","", delay, null);
    EntFire("Item_Ultima_Sound", "PlaySound","", delay, null);
    EntFire("Item_Ultima_Sound1", "PlaySound","", delay+3, null);
    EntFire("Item_Ultima_Sound2", "PlaySound","", delay+12.5, null);
    EntFire("Item_Ultima_Sound1", "StopSound","", delay+15, null);
    EntFire("Item_Ultima_Sound1", "Volume","0", delay+15, null);
    EntFire("Item_Ultima_Sound2", "PlaySound","", delay+15, null);
    EntFire("Item_Relay_Heal", "AddOutPut","OnTrigger !self:FireUser1::0:1", 0, null);

    EntFire("sephiroth_npc_ultimate_hurt", "Enable","", delay+15, null);
    EntFire("sephiroth_npc_ultimate_hurt", "Disable","", delay+16, null);
    EntFire("sephiroth_npc_ultimate_Effect", "Stop","", delay+15, null);
    for(local i=0;i<=15;i++)
    {
        EntFire("sephiroth_npc_ultimate_text", "SetText","[CASTING ULTIMA "+(15-i).tostring()+" s]", delay+i, null);
        EntFire("sephiroth_npc_ultimate_text", "Display","", delay+i+0.01, null);
    }
    EntFire("Map_Fade", "AddOutput","rendercolor 217 15 0", delay+15-0.05, null);
    EntFire("Map_Fade", "Fade","", delay+15, null);
    EntFire("Map_Shake", "StartShake","", delay+15, null);
    EntFireByHandle(self,"RunScriptCode","Global_CAN = true;",delay+Global_CD+15,null,null);
}

function Wind(){
    Global_CAN = false;
    local delay = 2.5;
    local time = 0;
    local i = 0
    EntFire("zeddy_boss_hurt", "Enable","", 0, null);
    EntFireByHandle(BossMover,"DisableMotion","",0.02,null,null);
    for(i;i < RandomInt(2,3);i++)
    {
        EntFireByHandle(self,"RunScriptCode","RandomPickAnim()",delay+time-0.5,null,null);
        EntFire("sephiroth_npc_wind_temp", "forcespawn","", delay+time, null);
        time+=RandomFloat(5.4,7.8);
    }
    EntFire("zeddy_boss_hurt", "Disable","", delay+time, null);
    EntFireByHandle(self,"SetDefaultAnimation",RunAnim,delay+time,null,null);
    EntFireByHandle(self,"SetAnimation",RunAnim,delay+time,null,null);
    EntFireByHandle(BossMover,"EnableMotion","",delay+time,null,null);
    SetAnimation(IdleAnim);
    SetDefAnimation(IdleAnim);
    BossMover.SetAngles(0,270,0);
    BossMover.SetOrigin(Vector(-12601,14055,1325));
    EntFireByHandle(self,"RunScriptCode","BossMover.SetOrigin(TeleportPos);",delay+time-0.5,null,null);
    EntFireByHandle(self,"RunScriptCode","Global_CAN = true;",delay+time+Global_CD,null,null);
}

function RandomPickAnim()
{
    switch (RandomInt(0,6))
    {
        case 0:SetAnimation(Attack1Anim);break;
        case 1:SetAnimation(Attack2Anim);break;
        case 2:SetAnimation(Attack3Anim);break;
        case 3:SetAnimation(Attack4Anim);break;
        case 4:SetAnimation(Attack5Anim);break;
        case 5:SetAnimation(Attack6Anim);break;
        case 6:SetAnimation(Attack7Anim);break;
    }
}

function Poison(){
    Global_CAN = false;
    PoisonUse = false;
	SetMimic(5)
    local delay = 2.5;
    local time = 0;
    ClearArray(LastPos)
    EntFire("Shinra_Jenova_Effect", "Start","", 0, null);
    EntFire("sephiroth_npc_poison_sound", "PlaySound","", delay, null);
    for(local i = 0;i < 12;i++)
    {
        EntFireByHandle(self,"RunScriptCode","FindPoisonTarget()",delay+time,null,null);
        time+=RandomFloat(0.1,0.25);
    }
    EntFire("sephiroth_npc_poison_hurt", "kill","", delay+time+2, null);
    EntFire("Shinra_Jenova_Effect", "Stop","", delay+time+2, null);
    EntFireByHandle(self,"RunScriptCode","Global_CAN = true;",delay+time+Global_CD,null,null);
}

function FindPoisonTarget()
{
    local handle = null;
    while (null != (handle = Entities.FindInSphere(handle, Vector(-12583,13111,1325), 720)))
    {
        if(handle.GetTeam() == 3 && handle.GetHealth() > 0)
        {
            local GOT = handle.GetOrigin();
            if(CheckDist(GOT,LastPos,140))
            {
				LastPos.push(GOT);
				PoisonMaker.SpawnEntityAtLocation(Vector(GOT.x,GOT.y,1370),nullVector);
				return;
            }
        }
    }
    local trying = 0;
    while (true)
    {
        local pos = Vector(RandomInt(-13088,-12088),RandomInt(12635,13592),1370);
        if(CheckDist(pos,LastPos,230))
        {
            LastPos.push(pos);
            PoisonMaker.SpawnEntityAtLocation(pos,nullVector);
            return;
        }
        if(trying<=128)
        {
            LastPos.push(pos);
            PoisonMaker.SpawnEntityAtLocation(pos,nullVector);
            return;
        }
        trying++;
    }
}

function FindMakoTarget()
{
    local handle = null;
    while(null != (handle = Entities.FindByClassname(handle,"player")))
    {
        if(handle.GetTeam() == 3 && handle.GetHealth() > 0)
        {
            local GOT = handle.GetOrigin();
            if(CheckDist(GOT,LastPos,140))
            {
				LastPos.push(GOT);
				MakoMaker.SpawnEntityAtLocation(Vector(GOT.x,GOT.y,1370),nullVector);
				return;
            }
        }
    }
}

function Mako(){
    local delay = 2;
    local time = 0;
    ClearArray(LastPos)
    Global_CAN = false;
    MakoUse = false;
    SetMimic(6)
    EntFire("Shinra_Jenova_Effect", "Start","", 0, null);
    for(local i = 0;i < 5;i++)
    {
        EntFireByHandle(self,"RunScriptCode","FindMakoTarget()",delay+time,null,null);
        time+=RandomFloat(0.5,2);
    }
    EntFire("Shinra_Jenova_Effect", "Stop","", delay+time+2, null);
    EntFireByHandle(self,"RunScriptCode","Global_CAN = true;",delay+time+Global_CD+5,null,null);
}

function Mimic(){
    local delay = 2;
	if(m_Bee)Bee();
	if(m_Fire)Fire();
	if(m_Wind)Wind();
	if(m_Gravity)Gravity();
	if(m_Heal)Heal();
	if(m_Poison)Poison();
	if(m_Aspil)Aspil();
	if(m_Berserk)Berserk();
	if(m_Shield)Shield();
	if(m_Ultimate)Ultimate();
}

function Heal(){
    Global_CAN = false;
    local whoTakeBuff = [];
    local delay = 2;
    local delay1 = 1.8;
    local HP = AllCT()*2.5;
	if(Sephiroth.GetAlive())whoTakeBuff.push("Sephiroth");
	// if(Shiva.GetAlive())whoTakeBuff.push("Shiva");
    // if(Ifrit.GetAlive())whoTakeBuff.push("Ifrit");
    // if(Jenova.GetAlive())whoTakeBuff.push("Jenova");
    if(debug)ScriptPrintMessageChatAll(HP.tostring())
    EntFire("demon_sephiroth_boss_heal_effect", "ClearParent", "", 0, null);
    EntFire("demon_sephiroth_boss_heal_effect", "Start", "", delay, null);
    switch (whoTakeBuff[RandomInt(0,whoTakeBuff.len()-1)])
    {
        case "Sephiroth":
            if(debug)ScriptPrintMessageChatAll("Sephiroth")
            EntFire("demon_sephiroth_boss_heal_effect", "AddOutPut", "origin "+self.GetOrigin().x+" "+self.GetOrigin().y+" "+(self.GetOrigin().z+50).tostring(), delay1, null);
            EntFire("demon_sephiroth_boss_heal_effect", "SetParent", "sephiroth_npc_model", delay1+0.01, null);
            EntFire("demon_sephiroth_boss_health", "Add", HP.tostring(), delay, null);
            EntFire("demon_sephiroth_boss_health", "Add", HP.tostring(), delay+0.5, null);
            EntFire("demon_sephiroth_boss_health", "Add", HP.tostring(), delay+1, null);
            EntFire("demon_sephiroth_boss_health", "Add", HP.tostring(), delay+1.5, null);
            break;
        case "Shiva":
            if(debug)ScriptPrintMessageChatAll("Shiva")
            EntFire("demon_sephiroth_boss_heal_effect", "AddOutPut", "origin "+ShivaModel.GetOrigin().x+" "+ShivaModel.GetOrigin().y+" "+ShivaModel.GetOrigin().z, delay1, null);
            EntFire("Shinra_Shiva_Counter", "Add", HP.tostring(), delay, null);
            EntFire("Shinra_Shiva_Counter", "Add", HP.tostring(), delay+0.5, null);
            EntFire("Shinra_Shiva_Counter", "Add", HP.tostring(), delay+1, null);
            EntFire("Shinra_Shiva_Counter", "Add", HP.tostring(), delay+1.5, null);
            break;
        case "Ifrit":
            if(debug)ScriptPrintMessageChatAll("Ifrit")
            EntFire("demon_sephiroth_boss_heal_effect", "AddOutPut", "origin "+IfritModel.GetOrigin().x+" "+IfritModel.GetOrigin().y+" "+IfritModel.GetOrigin().z, delay1, null);
            EntFire("Shinra_Ifrit_Counter", "Add", HP.tostring(), delay, null);
            EntFire("Shinra_Ifrit_Counter", "Add", HP.tostring(), delay+0.5, null);
            EntFire("Shinra_Ifrit_Counter", "Add", HP.tostring(), delay+1, null);
            EntFire("Shinra_Ifrit_Counter", "Add", HP.tostring(), delay+1.5, null);
            break;
        case "Jenova":
            if(debug)ScriptPrintMessageChatAll("Jenova")
            EntFire("demon_sephiroth_boss_heal_effect", "AddOutPut", "origin "+JenovaModel.GetOrigin().x+" "+JenovaModel.GetOrigin().y+" "+JenovaModel.GetOrigin().z, delay1, null);
            EntFire("Shinra_Jenova_Counter", "Add", HP.tostring(), delay, null);
            EntFire("Shinra_Jenova_Counter", "Add", HP.tostring(), delay+0.5, null);
            EntFire("Shinra_Jenova_Counter", "Add", HP.tostring(), delay+1, null);
            EntFire("Shinra_Jenova_Counter", "Add", HP.tostring(), delay+1.5, null);
            break;
    }
    EntFire("demon_sephiroth_boss_heal_effect", "Stop", "", delay+4, null);
    EntFireByHandle(self,"RunScriptCode","Global_CAN = true;",delay+Global_CD-5,null,null);
}

function Shield(){
    Global_CAN = false;
    local whoTakeBuff = [];
    local delay = 2;
    local delay1 = 1.8;
	if(Sephiroth.GetAlive())whoTakeBuff.push("Sephiroth");
	// if(Shiva.GetAlive())whoTakeBuff.push("Shiva");
    // if(Ifrit.GetAlive())whoTakeBuff.push("Ifrit");
    // if(Jenova.GetAlive())whoTakeBuff.push("Jenova");
    EntFire("demon_sephiroth_boss_shield_effect", "ClearParent", "", 0, null);
    EntFire("demon_sephiroth_boss_shield_effect", "Start", "", delay-0.3, null);
    switch (whoTakeBuff[RandomInt(0,whoTakeBuff.len()-1)])
    {
        case "Sephiroth":
            if(debug)ScriptPrintMessageChatAll("Sephiroth")
            EntFire("demon_sephiroth_boss_shield_effect", "AddOutPut", "origin "+self.GetOrigin().x+" "+self.GetOrigin().y+" "+(self.GetOrigin().z+50).tostring(), delay1, null);
            EntFire("demon_sephiroth_boss_shield_effect", "SetParent", "sephiroth_npc_model", delay1+0.01, null);
            EntFire("demon_sephiroth_boss_bullet_branch", "toggle", "", delay, null);
            EntFire("demon_sephiroth_boss_bullet_branch", "toggle", "", delay+5, null);
            break;
        case "Shiva":
            if(debug)ScriptPrintMessageChatAll("Shiva")
            EntFire("demon_sephiroth_boss_shield_effect", "AddOutPut", "origin "+ShivaModel.GetOrigin().x+" "+ShivaModel.GetOrigin().y+" "+(ShivaModel.GetOrigin().z+75).tostring(), delay1, null);
            EntFire("Shinra_Shiva_Counter_bullet_branch", "toggle", "", delay, null);
            EntFire("Shinra_Shiva_Counter_bullet_branch", "toggle", "", delay+5, null);
            break;
        case "Ifrit":
            if(debug)ScriptPrintMessageChatAll("Ifrit")
            EntFire("demon_sephiroth_boss_shield_effect", "AddOutPut", "origin "+IfritModel.GetOrigin().x+" "+IfritModel.GetOrigin().y+" "+(IfritModel.GetOrigin().z+75).tostring(), delay1, null);
            EntFire("Shinra_Ifrit_bullet_branch", "toggle", "", delay, null);
            EntFire("Shinra_Ifrit_bullet_branch", "toggle", "", delay+5, null);
            break;
        case "Jenova":
            if(debug)ScriptPrintMessageChatAll("Jenova")
            EntFire("demon_sephiroth_boss_shield_effect", "AddOutPut", "origin "+JenovaModel.GetOrigin().x+" "+JenovaModel.GetOrigin().y+" "+(JenovaModel.GetOrigin().z+400).tostring(), delay1, null);
            EntFire("Shinra_Jenova_bullet_branch", "toggle", "", delay, null);
            EntFire("Shinra_Jenova_bullet_branch", "toggle", "", delay+5, null);
            break;
    }
    EntFire("demon_sephiroth_boss_shield_effect", "Stop", "", delay+5, null);
    EntFireByHandle(self,"RunScriptCode","Global_CAN = true;",delay+Global_CD-5,null,null);
}

function Aspil(){
    local delay = 2.0;
    Global_CAN = false;
    EntFire("Shinra_Shiva_Effect", "Start","", 0, null);
    EntFire("sephiroth_npc_aspil_Effect", "Start","", delay, null);
    EntFire("sephiroth_npc_aspil_hurt", "Enable","", delay+0.5, null);
    EntFire("sephiroth_npc_aspil_Effect", "Stop","", delay+4, null);
    EntFire("sephiroth_npc_aspil_hurt", "Disable","",delay+4+0.5, null);
    EntFire("Shinra_Shiva_Effect", "Stop","", delay+4, null);
    EntFireByHandle(self,"RunScriptCode","Global_CAN = true;",delay+Global_CD+5,null,null);

}

function GetTypeMove(){
    if(RandomInt(0,3))
    {
        EntFireByHandle(caller,"AddOutPut","OnFullyOpen !self:Close::0,1",0,null,null);
        EntFireByHandle(caller,"AddOutPut","OnFullyClosed !self:kill::0,1",0,null,null);
    }
    else
    {
        EntFireByHandle(caller,"AddOutPut","OnFullyOpen !self:kill::0,1",0,null,null);
    }
    EntFireByHandle(caller,"Open","",0.1,null,null);
}

// function Ultimate()
// {
//      //UltimaUse = false;
//      local delay = 2.0;
//      local time = 0;
//      for(local i=0;i<=40;i++)
//      {
//              EntFireByHandle(self,"RunScriptCode","MirorSpawn1()",delay+time,null,null);
//              time+=0.1;
//      }
//      EntFire("sephiroth_npc_ultimate_mirror_trail*", "kill","", time+delay+2, null);
//      ScriptPrintMessageChatAll(::UltimateMes);
// }
//function MirorSpawn1()UltimateMaker.SpawnEntityAtLocation(UltimateMaker.GetOrigin()+Vector(RandomInt(-25,25),RandomInt(-25,25),RandomInt(0,25)),UltimateMaker.GetAngles()+Vector(RandomInt(-5,15),RandomInt(-25,25),RandomInt(-25,25)))



function HandleAnims(){
    canAttack = true;
    EntFireByHandle(wideHurt,"Disable","",0,null,null);
    EntFireByHandle(frontHurt,"Disable","",0,null,null);
}

function SetAttackTrue()canAttack = true;
// DEFAULT SPEEDS ARE
// FORWARD = 0.70
// TURNING = 0.50
function ChangeSpeedForward(Speed)EntFireByHandle(BossMover,"RunScriptCode","SPEED_FORWARD      <-" + Speed,0.00,activator,activator);

function ChangeSpeedTurning(Speed)EntFireByHandle(BossMover,"RunScriptCode","SPEED_TURNING      <-" + Speed,0.00,activator,activator);

function GetDistance(v1, v2)return sqrt(pow((v1.x - v2.x), 2) + pow((v1.y - v2.y), 2) + pow((v1.z - v2.z), 2));


function SetDefAnimation(animationName)EntFireByHandle(self,"SetDefaultAnimation",animationName,0.01,null,null);
function SetAnimation(animationName)EntFireByHandle(self,"SetAnimation",animationName,0.00,null,null);

function Die(){
    ticking = false;
    EntFireByHandle(self,"ClearParent","",0.05,null,null);
    EntFireByHandle(self,"AddOutPut","HoldAnimation 1",0.05,null,null);
    EntFireByHandle(BossMover,"Kill","",0.06,null,null);
    EntFireByHandle(self,"SetDefaultAnimation",DieAnim,0.06,null,null);
    EntFireByHandle(self,"SetAnimation",DieAnim,0.07,null,null);
    EntFireByHandle(self,"SetAnimation",DieAnim,0.07,null,null);
    EntFireByHandle(self,"FadeandKill","",8,null,null);
    EntFireByHandle(self,"SetAnimation",DieAnim,0.07,null,null);
}

function CheckDist(Who,In,dist)
{
    for(local i=0;i<In.len();i++)
    {
        if(GetDistance(Who,In[i]) < dist)return false;
    }
    return true;
}

function ClearArray(array)if(array.len()>0){array.clear()}

function AllCT()
{
	local handle = null;
	local counter = 0;
	while(null != (handle = Entities.FindByClassname(handle,"player")))
	{
		if(handle.GetTeam() == 3 && handle.GetHealth() > 0)counter++;
	}
	return counter;
}

function InArea()
{
	local handle = null;
	local counter = 0;
    while (null != (handle = Entities.FindInSphere(handle, TeleportPos, 500)))
    {
        if(handle.GetTeam() == 3 && handle.GetHealth() > 0)counter++;
    }
    return counter;
}

function OutArea()return AllCT()-InArea()

function SetMimic(i){
    m_Bee 		= false; //SetMimic(0)
    m_Fire 		= false; //SetMimic(1)
    m_Wind 		= false; //SetMimic(2)
    m_Gravity 	= false; //SetMimic(3)
    m_Heal 		= false; //SetMimic(4)
    m_Poison	= false; //SetMimic(5)

    m_Aspil 	= false; //SetMimic(7)
    m_Berserk	= false; //SetMimic(8)
    m_Shield	= false; //SetMimic(9)
    m_Ultimate	= false; //SetMimic(10)
	switch (i)
	{
		case 0:m_Bee 		= true; break;
		case 1:m_Fire 		= true; break;
		case 2:m_Wind 		= true; break;
		case 3:m_Gravity	= true; break;
		case 4:m_Heal 		= true; break;
		case 5:m_Poison 	= true; break;

		case 7:m_Aspil 		= true; break;
		case 8:m_Berserk 	= true; break;
		case 9:m_Shield 	= true; break;
		case 10:m_Ultimate 	= true; break;
	}
}

::BeeMes 		<- "**\x02 Ifrit\x01 summons\x07 Fire Bees\x01 **";
::FireMes		<- "**\x02 Ifrit\x01 is using\x07 Fire Tornado \x01**";
::BerserkMes 	<- "**\x02 Ifrit\x01 is using\x07 Berserk \x01**";

::UltimateMes 	<- "**\x03 Sephiroth\x01 is using\x02 Ultimate \x01**";
::GravityMes 	<- "**\x03 Sephiroth\x01 is using\x0E Gravity \x01**";
::WindMes 		<- "**\x03 Sephiroth\x01 is using\x06 Wind \x01**";

::PoisonMes 	<- "**\x04 Jenova\x01 is using\x06 Poison \x01**";
::MimicMes 		<- "**\x04 Jenova\x01 is using\x05 Mimic \x01**";
::ShieldMes	 	<- "**\x04 Jenova\x01 is using\x0C Shield \x01**";


::HealMes 		<- "**\x0b Shiva\x01 is using\x06 Heal\x05 150 hp \x01**";
::AspilMes 		<- "**\x0b Shiva\x01 is using\x0C Aspil \x01**";
::MakoMes 		<- "**\x0b Shiva\x01 is using\x04 Mako \x01**";

//ANIM NAMES:
//PUT IN VARRIABLES FOR EASE OF USE\\
IdleAnim 	<- "idle";
Idle2Anim 	<- "idle2";
Attack1Anim <- "attack1";
Attack2Anim <- "attack2";
Attack3Anim <- "attack3";
Attack4Anim <- "attack4";
Attack5Anim <- "attack5";
Attack6Anim <- "attack6";
Attack7Anim <- "attack7";
Attack8Anim <- "attack8";
JumpAnim 	<- "jump";
RunAnim 	<- "go";
DieAnim 	<- "die";
//wide mins -60 -134 -36
//     maxs 60 134 36


//front mins -72 -24 -36
//      maxs 72 24 36


// hitbox model *134


// mover model *353