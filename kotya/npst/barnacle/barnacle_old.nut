/*
Script by Kotya[STEAM_1:1:124348087] for npst
update 27.01.2021
　　　　　／＞　　フ
　　　　　| 　n　n 彡
　 　　　／`ミ＿xノ
　　 　 /　　　 　 |
　　　 /　 ヽ　　 ﾉ
　 　 │　　|　|　|
　／￣|　　 |　|　|
　| (￣ヽ＿_ヽ_)__)
　＼二つ
*/

cP <- null;
mJ <- null;
Ticking <- false;

Freeze  <- Entities.FindByName(null, "speedMod");
self.ConnectOutput("OnAnimationDone", "AnimDone")

HitBox <- Entities.FindByClassnameNearest("func_physbox_multiplayer", self.GetOrigin(), 150);
self.SetOwner(HitBox);

Target <- null;

Grab <- false;
Idling <- true;
Reseting <- false;
Attacking <- false;
VectorTp <- Vector(0,0,0)

/*Settings*/
TICKRATE <- 0.1;

Auto_KillTime <- 75;
Grab_dist_tokill <- 90;
Grab_dist <- 15;
HP_PerHUMAN <- 20;
HP_Base <- 400;
HP_Dist <- 2048;

/*End*/

a_death1 <- "death";
a_death2 <- "death2";

a_idle <- "idle01";
a_reset <- "reset_tongue";
a_attack <- "eat_humanoid";
a_grabing <- "slurp";

EntFireByHandle(self, "RunScriptCode", "GethP()", 0, null, null);
EntFireByHandle(HitBox, "RunScriptCode", "SetHp()", 0, null, null);
function GethP()
{
    local newMp = self.GetOrigin() //+ Vector(0,0,100);
    while(true)
    {
        //DrawAxis(newMp,16,true,5)
        if(TraceLine(newMp,newMp + Vector(0,0,1),self)<1.00)
        {
            //DrawBox(newMp);
            self.SetOrigin(newMp - Vector(0,0,1));
            EntFireByHandle(self, "RunScriptCode", "GetcP()", 0, null, null);
            break;
        }
        //printl(i);
        newMp = newMp + Vector(0,0,1);
    }
}

function GetcP()
{
    local oP = self.GetOrigin()// - Vector(0,0,60);
    mJ = oP;
    while(true)
    {
        //DrawAxis(oP,16,true,5)
        if(TraceLine(oP,oP - Vector(0,0,16),self)<1.00)
        {
            cP = oP;
            Ticking = true;
            EntFireByHandle(self, "RunScriptCode", "Tick();", 2, null, null);
            break;
        }
        oP = oP - Vector(0,0,16);
    }
}

function Stop()
{
    Ticking = false;
    if((Target != null && Target.GetHealth() > 1))
    {
        Target.SetVelocity(Vector(0,0,0));
        EntFireByHandle(Freeze, "ModifySpeed", "1", 0, Target, Target);
        Target = null;
    }
    if(RandomInt(0,1))
    {
        local time = 3;
        SetAnimation(a_death1);
        EntFireByHandle(self,"FadeAndKill","",time,null,null);
    }
    else
    {
        local time = 3;
        SetAnimation(a_death2);
        EntFireByHandle(self,"FadeAndKill","",time,null,null);
    }
}

function Tick()
{
    if(!Ticking)return;
    if(!Reseting && !Attacking)
    {
        if(Target == null || !(Target.IsValid()) || Target.GetHealth() <= 0)Search()
        if(Grab)
        {
            if(GetDistance(Target.GetOrigin(),mJ) >= Grab_dist_tokill)
            {
                VectorTp += Vector(0,0,4);
                Target.SetOrigin(VectorTp)
            }
            else
            {
                Attacking = true;
                SetAnimation(a_attack);
                EntFireByHandle(self,"RunScriptCode","SetDeath();",0.85,Target,Target);
            }
        }
    }
    //PrintInfo()
    EntFireByHandle(self,"RunScriptCode","Tick();",TICKRATE,null,null);
}

function PrintInfo()
{
    ScriptPrintMessageCenterAll("Target : "+Target);
    DrawAxis(cP,16,true,0.2)
    DrawBox(cP);
}

function SetDeath()
{
    if(!Target || Target == null || !(Target.IsValid()) || Target.GetHealth() <= 0 )return;
    EntFireByHandle(Target, "SetHealth", "0", 0, Target, Target);
    Target = null;
}

function AnimDone()
{
    if(Attacking)
    {
        Attacking = false;
        Idling = false
        Reseting = true;
        SetAnimation(a_reset);
        return;
    }
    if(Reseting)
    {
        Reseting = false;
        SetDefAnimation(a_idle);
        SetAnimation(a_idle);
        Idling = true;
        return;
    }
}

function Search()
{
    if(!Idling)
    {
        SetDefAnimation(a_idle);
        SetAnimation(a_idle);
    }
    Idling = true;
    Grab = false;
    local h = null;
    while(null != (h = Entities.FindInSphere(h, cP ,Grab_dist)))
    {
        if(h.GetClassname() == "player" && h.IsValid() && h.GetHealth() > 0)
		{
            Idling = false
            Reseting = false
            Grab = true;
            SetDefAnimation(a_grabing);
            SetAnimation(a_grabing);
            VectorTp = cP+Vector(0,0,20)
            h.SetOrigin(VectorTp);
            EntFireByHandle(Freeze, "ModifySpeed", "0", 0, h, h);
			return Target = h;
		}
    }
    return Target = null;
}

function SetHp()
{
    local ctcount=0;
    local hlist=[];
    local h=null;
    while(null!=(h=Entities.FindInSphere(h,self.GetOrigin(),HP_Dist)))
    {
        if(h.GetClassname() == "player" && h.GetTeam() == 3 && h.GetHealth() > 0){ctcount++;}
    }
    EntFireByHandle(HitBox,"SetHealth",(HP_Base+(ctcount*HP_PerHUMAN)).tostring(),0.1,null,null);
    EntFireByHandle(HitBox,"Break", "",Auto_KillTime,null,null);
}

function DrawAxis(pos,s,nocull,time)
{
	DebugDrawLine(Vector(pos.x-s,pos.y,pos.z), Vector(pos.x+s,pos.y,pos.z), 255, 0, 0, nocull, time);
	DebugDrawLine(Vector(pos.x,pos.y-s,pos.z), Vector(pos.x,pos.y+s,pos.z), 0, 255, 0, nocull, time);
	DebugDrawLine(Vector(pos.x,pos.y,pos.z-s), Vector(pos.x,pos.y,pos.z+s), 0, 0, 255, nocull, time);
}

function DrawBox(pos)
{
    DebugDrawBox(pos, Vector(-75,-75,-75), Vector(75,75,75), 0, 100, 255, 0, 1)
}

function GetDistance(v1,v2)return sqrt((v1.x-v2.x)*(v1.x-v2.x)+(v1.y-v2.y)*(v1.y-v2.y)+(v1.z-v2.z)*(v1.z-v2.z));
function SetDefAnimation(animationName,time = 0.01)EntFireByHandle(self,"SetDefaultAnimation",animationName.tostring(),time,null,null);
function SetAnimation(animationName,time = 0)EntFireByHandle(self,"SetAnimation",animationName.tostring(),time,null,null);