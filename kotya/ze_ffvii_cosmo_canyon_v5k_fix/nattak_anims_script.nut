/*
Script by Kotya[STEAM_1:1:124348087]
update 07.12.2020

　　　　　　　　　　　　　　;' ':;,,　　　　 ,;'':;,
　　　　　　　　　　　　　;'　　 ':;,.,.,.,.,.,,,;'　　';,
　　ー　　　　　　　　 ,:'　　　　　　　　 　::::::::､
　_＿　　　　　　　　,:' ／ 　 　　　　＼ 　　::::::::', Have A Good day
　　　　　二　　　　:'　 ●　　　　　 ●　 　　 ::::::::i.
　　￣　　　　　　　i　 '''　(__人_)　　'''' 　　 ::::::::::i
　　　　-‐　　　　　 :　 　　　　　　　　　 　::::::::i
　　　　　　　　　　　`:,､ 　　　　　 　 　 :::::::::: /
　　　　／　　　　　　 ,:'　　　　　　　 : ::::::::::::｀:､
　　　　　　　　　　　 ,:'　　　　　　　　 : : ::::::::::｀:､
*/
IdleAnim <- "idle";
Attack1Anim <- "attack1";
Attack2Anim <- "attack2";
Attack3Anim <- "attack3";

TeleportPos <- Entities.FindByName(null, "nattak_npc_falloff_tp_destination").GetOrigin();
BossMover <- Entities.FindByName(null, "nattak_npc_physbox");

canAttack <- true;
//CanCast <- false;
CanCast <- true;
Casting <- false;
///////////////
//  UseBLOCK //
///////////////
FireCD <- 15;
FireUse <- true;
FireCastTime <- 8;
///////////////
WindCD <- 15;
WindUse <- true;
WindCastTime <- 8;
///////////////
HealCD <- 15;
HealUse <- true;
///////////////
AspilCD <- 15;
AspilUse <- true;
AspilCastTime <- 8;
///////////////
SilenceCD <- 15;
SilenceUse <- true;
///////////////
ShieldCD <- 15;
ShieldUse <- true;
///////////////
GravityCD <- 15;
GravityUse <- true;
GravityCastTime <- 6;
///////////////
//	  END	 //
///////////////
TICKRATE <- 1;
temp <- -1;

ticking <- false;

sphereRadius <- 576;
defaultSpeed <- 0.75;

Target <- null;
//--------Attack1--------\\
attack1Hurt <- Entities.FindByName(null, "nattak_npc_attack1_hurt");
//-----------------------\\

//--------Attack2--------\\
novaTemplate <- Entities.FindByName(null, "nattak_npc_attack2_maker");
//-----------------------\\

//--------Attack3--------\\
explosionTemplate <- Entities.FindByName(null, "nattak_npc_attack3_maker");
//-----------------------\\


function Start()
{
	if(!ticking)
	{
		//EntFireByHandle(self,"RunScriptCode","CanCast = true",10,null,null);
		ticking = true;
		Tick();
	}
}

function Stop()
{
	if(ticking)
	{
		ticking = false;
	}
}

function Tick()
{
	if(ticking)
	{
		EntFireByHandle(self,"RunScriptCode","Tick();",TICKRATE,null,null);
		Target = Entities.FindByClassnameWithin(null,"player",self.GetOrigin(),sphereRadius);

		if(Target!=null)
		{
			//printl(Target);
			if(Target.GetTeam()==3&&Target.GetHealth()>0)
			{
				Attack();
				Target = null;
			}
		}
		else
		{
			//printl(Target);
		}
	}
}


function Attack()
{
	if(CanCast)
	{
		if(FireUse || WindUse || AspilUse || HealUse || SilenceUse)
		{
			local Random;
			while(true)
			{
				Random = RandomInt(0,6);
				if(Random != temp)
				{
					if((FireUse && Random == 0) || (FireUse && InArena() > OutArena()))
					{
						CastingAnim();
						Casting = true;
						canAttack = false;
						CanCast = false;
						Fire();
					}
					else if((GravityUse && Random == 1) ||(GravityUse && NearBoss() >= (AllCT()/5)))
					{
						CastingAnim();
						CanCast = false;
						canAttack = false;
						Casting = true;
						Gravity();
					}
					else if((WindUse && Random == 2) || (WindUse && OutArena() >= ((AllCT()*30)/100)))
					{
						CastingAnim();
						canAttack = false;
						CanCast = false;
						Wind();
					}
					else if((SilenceUse && Random == 3) || (SilenceUse && HPCT() <= 80))
					{
						SetBossAnimation(Attack3Anim);
						canAttack = false;
						CanCast = false;
						Silence();
					}
					else if(AspilUse && Random == 4)
					{
						CastingAnim();
						Casting = true;
						canAttack = false;
						CanCast = false;
						Aspil();
					}
					else if(HealUse && Random == 5)
					{
						SetBossAnimation(Attack3Anim);
						canAttack = false;
						CanCast = false;
						Heal();
					}
					else if(ShieldUse && Random == 6)
					{
						SetBossAnimation(Attack3Anim);
						canAttack = false;
						CanCast = false;
						Shield();
					}
					temp = Random;
					break;
				}
			}

		}
		else
		{
			FireUse = true;
			WindUse = true;
			AspilUse = true;
			HealUse = true;
			SilenceUse = true;
			ShieldUse = true;
			GravityUse = true;
			Attack()
		}
	}
	else
	{
		if(canAttack)
		{
			local randomNumber = RandomInt(0,4);
			if(randomNumber <= 2)
			{
				Attack1();
				canAttack = false; // to ensure that animations dont spam
			}
			else if(randomNumber == 3)
			{
				Explosion();
				canAttack = false;
			}
			else
			{
				Nova();
				canAttack = false;
			}
		}
	}
}

function Attack1()
{
	SetBossAnimation(Attack1Anim);
	EntFireByHandle(attack1Hurt,"Enable","",1.26,null,null);
	EntFireByHandle(attack1Hurt,"Disable","",1.46,null,null);
}

function Explosion()
{
	SetBossAnimation(Attack3Anim);
	EntFireByHandle(explosionTemplate,"ForceSpawn","",2.53,null,null);
	EntFireByHandle(self,"RunScriptCode","ChangeSpeedForward(0.2)",0.2,null,null);
	EntFireByHandle(self,"RunScriptCode","ChangeSpeedForward(defaultSpeed)",3.13,null,null);
	//2.53
}

function Nova()
{
	SetBossAnimation(Attack2Anim);
	EntFireByHandle(novaTemplate,"ForceSpawn","",2.8,null,null);
	EntFireByHandle(self,"RunScriptCode","ChangeSpeedForward(0.2)",0.2,null,null);
	EntFireByHandle(self,"RunScriptCode","ChangeSpeedForward(defaultSpeed)",3.13,null,null);
	//2.8
}

function Fire()
{
	local delay = 2.0;
	FireUse = false;
	BossMover.SetOrigin(TeleportPos);
	ScriptPrintMessageChatAll(::FireMes);
	EntFireByHandle(self,"RunScriptCode","ChangeSpeedForward(0)",0,null,null);
	EntFireByHandle(self,"RunScriptCode","ChangeSpeedForward(defaultSpeed)",FireCastTime+delay,null,null);
	EntFireByHandle(self,"RunScriptCode","Casting = false;",FireCastTime+delay,null,null);
	EntFireByHandle(self,"RunScriptCode","CanCast = true;",FireCD,null,null);

	EntFire("GiBoss_Fire_Effect", "Start","", 0+delay, null);
	EntFire("GiBoss_Fire_Hurt", "Enable","", 0+delay, null);
	EntFire("GiBoss_Fire_Hurt", "Disable","", 3.5+delay, null);
	EntFire("GiBoss_Fire_Effect", "Stop","", 3.5+delay, null);
	EntFire("GiBoss_Fire_Sound", "PlaySound","", 0+delay, null);
}

function Wind()
{
	local delay = 2.0;
	WindUse = false;
	BossMover.SetOrigin(TeleportPos);
	ScriptPrintMessageChatAll(::WindMes);
	EntFireByHandle(self,"RunScriptCode","ChangeSpeedForward(0)",0,null,null);
	EntFireByHandle(self,"RunScriptCode","ChangeSpeedForward(defaultSpeed)",WindCastTime+delay,null,null);
	EntFireByHandle(self,"RunScriptCode","Casting = false;",WindCastTime+delay,null,null);
	EntFireByHandle(self,"RunScriptCode","CanCast = true;",WindCD,null,null);

	EntFire("GiBoss_Wind_Effect", "Start","", 0+delay, null);
	EntFire("GiBoss_Wind_Effect", "Stop","", 4.75+delay, null);
	EntFire("GiBoss_Wind_Push", "Enable","", 1.25+delay, null);
	EntFire("GiBoss_Wind_Push", "Disable","", 4.75+delay, null);
	EntFire("GiBoss_Wind_Flow", "Start","", 0+delay, null);
	EntFire("GiBoss_Wind_Flow", "Stop","", 4.5+delay, null);

	EntFire("nattak_npc_model_particles", "Start","", 4.75+delay, null);
	EntFire("nattak_npc_model_particles", "Stop","", 0+delay, null);
	EntFire("nattak_npc_hurt", "Enable","", 4.75+delay, null);
	EntFire("nattak_npc_hurt", "Disable","", 0+delay, null);
}

function Heal()
{
	local delay = 2.0;
	HealUse = false;
	ScriptPrintMessageChatAll(::HealMes);

	EntFireByHandle(self,"RunScriptCode","CanCast = true;",HealCD,null,null);

	EntFire("GiBoss_Heal_Effect", "Start","", 0+delay, null);
	EntFire("GiBoss_Heal_Effect", "Stop","", 3+delay, null);
	EntFire("GiBoss_Heal_Sound", "PlaySound","", 3+delay, null);
	EntFire("demon_nattak_boss_health", "Add","75", 0+delay, null);
	EntFire("demon_nattak_boss_health", "Add","75", 1.5+delay, null);

	EntFire("nattak_npc_model_particles", "Start","", 3+delay, null);
	EntFire("nattak_npc_model_particles", "Stop","", 0+delay, null);
	EntFire("nattak_npc_hurt", "Enable","", 3+delay, null);
	EntFire("nattak_npc_hurt", "Disable","", 0+delay, null);
}

function Aspil()
{
	local delay = 2.0;
	AspilUse = false;
	BossMover.SetOrigin(TeleportPos);
	ScriptPrintMessageChatAll(::AspilMes);
	EntFireByHandle(self,"RunScriptCode","ChangeSpeedForward(0)",0,null,null);
	EntFireByHandle(self,"RunScriptCode","ChangeSpeedForward(defaultSpeed)",delay+AspilCastTime,null,null);
	EntFireByHandle(self,"RunScriptCode","CanCast = true;",AspilCD,null,null);
	EntFireByHandle(self,"RunScriptCode","Casting = false;",delay+AspilCastTime,null,null);

	EntFire("GiBoss_Aspil_Hurt", "Enable","", 0+delay, null);
	EntFire("GiBoss_Aspil_Hurt", "Disable","", 3.5+delay, null);
	EntFire("GiBoss_Aspil_Effect", "Start","", 0+delay, null);
	EntFire("GiBoss_Aspil_Effect", "Stop","", 3.5+delay, null);
}

function Silence()
{
	local delay = 2.0;
	SilenceUse = false;
	ScriptPrintMessageChatAll(::SilenceMes);

	EntFireByHandle(self,"RunScriptCode","CanCast = true;",SilenceCD,null,null);
	EntFire("GiBoss_Silence_Effect", "Start","", 0+delay, null);
	EntFire("GiBoss_Silence_Effect", "Stop","", 7.5+delay, null);
	EntFire("Item_Relay*", "Disable","", 0+delay, null);
	EntFire("Item_Relay*", "Enable","", 7.5+delay, null);

	EntFire("nattak_npc_model_particles", "Start","", 7.5+delay, null);
	EntFire("nattak_npc_model_particles", "Stop","", 0+delay, null);
	EntFire("nattak_npc_hurt", "Enable","", 7.5+delay, null);
	EntFire("nattak_npc_hurt", "Disable","", 0+delay, null);
}

function Shield()
{
	local delay = 2.0;
	ShieldUse = false;
	ScriptPrintMessageChatAll(::ShieldMes);

	EntFire("GiBoss_Shield_Effect", "Start","", 0+delay, null);
	EntFire("GiBoss_Shield_Effect", "Stop","", 7.5+delay, null);
	EntFire("nattak_npc_bullet_branch", "toggle","", 0+delay, null);
	EntFire("nattak_npc_bullet_branch", "toggle","", 7.5+delay, null);
	EntFireByHandle(self,"RunScriptCode","CanCast = true;",ShieldCD,null,null);

	EntFire("nattak_npc_model_particles", "Start","", 7.5+delay, null);
	EntFire("nattak_npc_model_particles", "Stop","", 0+delay, null);
	EntFire("nattak_npc_hurt", "Enable","", 7.5+delay, null);
	EntFire("nattak_npc_hurt", "Disable","", 0+delay, null);
}

function Gravity()
{
	local delay = 2.0;
	GravityUse = false;
	ScriptPrintMessageChatAll(::GravityMes);
	EntFire("nattak_npc_gravity_Effect", "Start","", delay, null);
	EntFire("nattak_npc_gravity_Sound", "PlaySound","", delay, null);
	EntFire("nattak_npc_gravity_Trigger", "Enable","", delay, null);
	EntFire("nattak_npc_gravity_Effect", "Stop","", delay+GravityCastTime, null);
	EntFire("nattak_npc_gravity_Trigger", "Disable","", delay+GravityCastTime, null);
	EntFireByHandle(self,"RunScriptCode","ChangeSpeedForward(0.4)",0,null,null);
	EntFireByHandle(self,"RunScriptCode","ChangeSpeedForward(defaultSpeed)",delay+GravityCastTime,null,null);
	EntFireByHandle(self,"RunScriptCode","Casting = true;",delay+GravityCastTime,null,null);
	EntFireByHandle(self,"RunScriptCode","CanCast = true;",GravityCD,null,null)
}

function NearBoss()
{
	local handle = null;
	local counter = 0;
	while (null != (handle = Entities.FindInSphere(handle , BossMover.GetOrigin(), 300)))
	{
		if(handle.GetTeam() == 3 && handle.GetHealth() > 0)counter++;
	}
	return counter;
}

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

function HPCT()
{
	local handle = null;
	local counter = 0;
	local hp = 0;
	while(null != (handle = Entities.FindByClassname(handle,"player")))
	{
		if(handle.GetTeam() == 3 && handle.GetHealth() > 0)
		{
			hp+=handle.GetHealth();
			counter++;
		}
	}
	return hp/counter;
}


function InArena()
{
	local handle = null;
	local counter = 0;
	while (null != (handle = Entities.FindInSphere(handle , TeleportPos, sphereRadius)))
	{
		if(handle.GetTeam() == 3 && handle.GetHealth() > 0)counter++;
	}
	return counter;
}
function OutArena()return AllCT()-InArena();

function CastingAnim()
{
	EntFireByHandle(self,"SetDefaultAnimation",Attack3Anim,0.01,null,null);
	EntFireByHandle(self,"SetAnimation",Attack3Anim,0.00,null,null);
}

function SetBossAnimation(animationName)
{
	EntFireByHandle(self,"SetAnimation",animationName,0.00,null,null);
}

function HandleAnims()
{
	if(!Casting)
	{
		canAttack = true;
		EntFireByHandle(self,"SetDefaultAnimation",IdleAnim,0.01,null,null);
		EntFireByHandle(self,"SetAnimation",IdleAnim,0.00,null,null);
	}
	else EntFireByHandle(self,"RunScriptCode","HandleAnims()",0.05,null,null);
}


// DEFAULT SPEEDS ARE
// FORWARD = 0.70
// TURNING = 0.50
function ChangeSpeedForward(Speed)//for easier speed change and cleanliness + must be a decimal
{
	EntFireByHandle(BossMover,"RunScriptCode","SPEED_FORWARD 	<-" + Speed,0.00,activator,activator);
}
function ChangeSpeedTurning(Speed)
{
	EntFireByHandle(BossMover,"RunScriptCode","SPEED_TURNING 	<-" + Speed,0.00,activator,activator);
}

::AspilMes <- "**\x02 Gi Nattak\x01 is using\x0C  aspil\x01 **";
::HealMes <- "**\x02 Gi Nattak\x01 has\x06 healed\x01 150 hp **";
::FireMes <- "**\x02 Gi Nattak\x01 is using\x02 fire **";
::WindMes <- "**\x02 Gi Nattak\x01 is using\x04 wind\x01 **";

::SilenceMes <- "**\x02 Gi Nattak\x01 is using\x0A silence\x01 **";
::ShieldMes <- "**\x02 Gi Nattak\x01 is using\x10 shield\x01 **";
::GravityMes <- "**\x02 Gi Nattak\x01 is using\x0E gravity\x01 **"
//model numbers
// nattak_npc_hurt & _hitbox = *53

// nattak_npc_physbox = *353

//	nattak_npc_attack1_hurt mins = -240 -32 -40
//							maxs = 240 32 40