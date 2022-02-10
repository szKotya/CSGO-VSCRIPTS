 //-----------SCRIPT BY DEMON-----------\\
//ANIM NAMES:
//PUT IN VARRIABLES FOR EASE OF USE\\
IdleAnim <- "idle";
Idle2Anim <- "idle2";
Attack1Anim <- "attack1";
Attack2Anim <- "attack2";
Attack3Anim <- "attack3";
Attack4Anim <- "attack4";
Attack5Anim <- "attack5";
Attack6Anim <- "attack6";
Attack7Anim <- "attack7";
Attack8Anim <- "attack8";
JumpAnim <- "jump";
RunAnim <- "go";
DieAnim <- "die";

BossModel <- self;
FireMaker <- Entities.FindByName(null, "sephiroth_npc_fire_maker");
BossMover <- Entities.FindByName(null, "sephiroth_npc_physbox");
canAttack <- true;
TICKRATE <- 0.5;
ticking <- false;
sphereRadius <- 128;
Target <- null;
defaultSpeed <- 0.8;
debug <- true;
//attack hurt's
SlashSound <- Entities.FindByName(null, "sephiroth_npc_slash_sound");
wideHurt <- Entities.FindByName(null,"sephiroth_npc_hurt_wide");
frontHurt <- Entities.FindByName(null,"sephiroth_npc_hurt_front");

function Start()
{
	if(!ticking)
	{
		EntFireByHandle(BossModel,"SetDefaultAnimation",RunAnim,0.01,null,null);
		EntFireByHandle(BossModel,"SetAnimation",RunAnim,0.00,null,null);
		EntFireByHandle(self,"RunScriptCode","ChangeSpeedForward(defaultSpeed)",0.05,null,null);
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
	local randomNumber = RandomInt(0,6);
	if(canAttack)
	{
		if(randomNumber == 0)
		{
			Attack1();
			canAttack = false;
		}
		else if(randomNumber == 1)
		{
			Attack2();
			canAttack = false;
		}
		else if(randomNumber == 2)
		{
			Attack3();
			canAttack = false;
		}
		else if(randomNumber == 3)
		{
			Attack4();
			canAttack = false;
		}
		else if(randomNumber == 4)
		{
			Attack5();
			canAttack = false;
		}
		else if(randomNumber == 5)
		{
			Attack6();
			canAttack = false;
		}
		else if(randomNumber == 6)
		{
			Attack7();
			canAttack = false;
		}
	}

}

function Attack1()
{
	//animation speed = 25
	// front
	SetBossAnimation(Attack1Anim);
	EntFireByHandle(self,"RunScriptCode","ChangeSpeedForward(0.2)",0.4,null,null);
	EntFireByHandle(SlashSound,"PlaySound","",0.4,null,null);
	EntFireByHandle(frontHurt,"Enable","",0.4,null,null);
	EntFireByHandle(frontHurt,"Disable","",0.7,null,null);
	EntFireByHandle(self,"RunScriptCode","ChangeSpeedForward(defaultSpeed)",2.08,null,null);
}
function Attack2()
{
	//animation speed = 25
	// wide
	SetBossAnimation(Attack2Anim);
	EntFireByHandle(self,"RunScriptCode","ChangeSpeedForward(0.2)",0.68,null,null);
	EntFireByHandle(SlashSound,"PlaySound","",0.68,null,null);
	EntFireByHandle(wideHurt,"Enable","",0.68,null,null);
	EntFireByHandle(wideHurt,"Disable","",0.9,null,null);
	EntFireByHandle(self,"RunScriptCode","ChangeSpeedForward(defaultSpeed)",2,null,null);
}
function Attack3()
{
	//animation speed = 25
	// front
	SetBossAnimation(Attack3Anim);
	EntFireByHandle(self,"RunScriptCode","ChangeSpeedForward(0.4)",0.4,null,null);
	EntFireByHandle(SlashSound,"PlaySound","",0.4,null,null);
	EntFireByHandle(frontHurt,"Enable","",0.4,null,null);
	EntFireByHandle(frontHurt,"Disable","",0.7,null,null);
	EntFireByHandle(self,"RunScriptCode","ChangeSpeedForward(defaultSpeed)",2.4,null,null);
}
function Attack4()
{
	//animation speed = 25
	// front
	SetBossAnimation(Attack4Anim);
	EntFireByHandle(self,"RunScriptCode","ChangeSpeedForward(0.4)",0.88,null,null);
	EntFireByHandle(SlashSound,"PlaySound","",0.88,null,null);
	EntFireByHandle(frontHurt,"Enable","",0.88,null,null);
	EntFireByHandle(frontHurt,"Disable","",1.12,null,null);
	EntFireByHandle(self,"RunScriptCode","ChangeSpeedForward(defaultSpeed)",2.88,null,null);
}
function Attack5()
{
	//animation speed = 25
	// wide
	SetBossAnimation(Attack5Anim);
	EntFireByHandle(self,"RunScriptCode","ChangeSpeedForward(0.2)",0.0,null,null);
	EntFireByHandle(SlashSound,"PlaySound","",0.36,null,null);
	EntFireByHandle(wideHurt,"Enable","",0.36,null,null);
	EntFireByHandle(wideHurt,"Disable","",0.5,null,null);
	EntFireByHandle(self,"RunScriptCode","ChangeSpeedForward(defaultSpeed)",2.16,null,null);
}
function Attack6()
{
	//animation speed = 18
	// wide
	SetBossAnimation(Attack6Anim);
	EntFireByHandle(self,"RunScriptCode","ChangeSpeedForward(0.2)",0.44,null,null);
	EntFireByHandle(SlashSound,"PlaySound","",0.44,null,null);
	EntFireByHandle(wideHurt,"Enable","",0.44,null,null);
	EntFireByHandle(wideHurt,"Disable","",0.64,null,null);
	EntFireByHandle(self,"RunScriptCode","ChangeSpeedForward(defaultSpeed)",3.11,null,null);
}
function Attack7()
{
	//animation speed = 12
	// wide
	SetBossAnimation(Attack7Anim);
	EntFireByHandle(self,"RunScriptCode","ChangeSpeedForward(0.2)",0.1,null,null);
	EntFireByHandle(SlashSound,"PlaySound","",0.5,null,null);
	EntFireByHandle(wideHurt,"Enable","",0.5,null,null);
	EntFireByHandle(wideHurt,"Disable","",0.7,null,null);
	EntFireByHandle(SlashSound,"PlaySound","",1,null,null);
	EntFireByHandle(wideHurt,"Enable","",1,null,null);
	EntFireByHandle(wideHurt,"Disable","",1.3,null,null);
	EntFireByHandle(self,"RunScriptCode","ChangeSpeedForward(defaultSpeed)",3,null,null);

}
FirePos <- [Vector(-13155 12543 1300),
Vector(-12777 12543 1300),
Vector(-12399 12543 1300),
Vector(-12021 12543 1300)];
/*
-13155 12543 1300
-12777 12543 1300
-12399 12543 1300
-12021 12543 1300
*/
function Fire()
{
	local delay = 2.0;
	local time = 0;
	local Pos = FirePos.slice(0,FirePos.len());
	//FireUse = false;
	for(local i=0;i<FirePos.len();i++)
	{
		local random = RandomInt(0,Pos.len()-1);
		EntFireByHandle(self,"RunScriptCode","FireSpawn("+Pos[random].tostring()+")",delay+time,null,null);
		ScriptPrintMessageChatAll(Pos[random].tostring());
		Pos.remove(random);
		time+=2;
	}
	ScriptPrintMessageChatAll(::FireMes);
}

function FireSpawn(vec)FireMaker.SpawnEntityAtLocation(vec,Vector(0 0 0))
function FireGetType()
{
	if(RandomInt(0,1))
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

function SetBossAnimation(animationName)
{
	EntFireByHandle(BossModel,"SetAnimation",animationName,0.00,null,null);
}

function HandleAnims()
{
	canAttack = true;
	EntFireByHandle(wideHurt,"Disable","",0,null,null);
	EntFireByHandle(frontHurt,"Disable","",0,null,null);
}

function SetAttackTrue()
{
	canAttack = true;
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


function Die()
{
	Stop();
	EntFireByHandle(self,"ClearParent","",0.05,null,null);
	EntFireByHandle(self,"AddOutPut","HoldAnimation 1",0.05,null,null);
	EntFireByHandle(BossMover,"Kill","",0.06,null,null);
	EntFireByHandle(self,"SetDefaultAnimation",DieAnim,0.06,null,null);
	EntFireByHandle(self,"SetAnimation",DieAnim,0.07,null,null);
	EntFireByHandle(self,"SetAnimation",DieAnim,0.07,null,null);
	EntFireByHandle(self,"FadeandKill","",8,null,null);
	EntFireByHandle(self,"SetAnimation",DieAnim,0.07,null,null);

}

::FireMes <- "**\x02 Ifrit\x01 is using\x02 fire **";


//wide mins -60 -134 -36
//     maxs 60 134 36


//front mins -72 -24 -36
//      maxs 72 24 36


// hitbox model *134


// mover model *353