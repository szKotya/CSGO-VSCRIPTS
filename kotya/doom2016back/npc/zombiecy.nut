IncludeScript("kotya/doom2016/support/models.nut");
//////IncludeScript("kotya/doom2016/support/math.nut");

TICKRATE 	    <- 0.15;
TICKRATE_IDLE 	<- 5;
SPEED_FORWARD 	<- 1;
SPEED_TURNING   <- 1;
Ticking         <- false;
TARGET          <- null;
RETARGET        <- 0;

CanForward      <- true;
CanSide         <- true;
//////////////////////
//  Settings block  //
//////////////////////
TAR_DISTANCE    <- 512;

debug           <- true;
RETARGET_TIME 	<- 6.00;
//////////////////////
//   Handle block   //
//////////////////////
Effect           <- null;
Hurt             <- null;
Model            <- null;
Keeper           <- null;
tf               <- null;
ts               <- null;
Hbox             <- null;
function SetHandle()
{
    local name = caller.GetName();

    if(caller.GetClassname() == "func_physbox_multiplayer")Hbox = caller;
    if(caller.GetClassname() == "info_particle_system")Effect = caller;
    if(caller.GetClassname() == "trigger_hurt")Hurt = caller;
    if(caller.GetClassname() == "prop_dynamic")Model = caller;
    if(caller.GetClassname() == "phys_keepupright")Keeper = caller;
    if(caller.GetClassname() == "phys_thruster" && name.find("npc_zombiecy_thruster_forward") == 0)tf = caller;
    if(caller.GetClassname() == "phys_thruster" && name.find("npc_zombiecy_thruster_side") == 0)ts = caller;
    if(caller.GetClassname() == "phys_thruster" && name.find("npc_zombiecy_thruster_up") == 0)tu = caller;
}
//////////////////////
//    Main Block    //
//////////////////////
function Start()
{
  if(!Ticking)
	{
		if(debug)ScriptPrintMessageChatAll("Start");
		Ticking = true;
		Tick();
	}
}

function Tick()
{
    if(!Ticking)return;
    EntFireByHandle(tf,"Deactivate","",0.00,null,null);
	EntFireByHandle(ts,"Deactivate","",0.00,null,null);
     if(TARGET==null||!TARGET.IsValid()||TARGET.GetHealth()<=0.00||TARGET.GetTeam()!=3||RETARGET>=RETARGET_TIME)SearchTARGET()
    if(TARGET==null||!TARGET.IsValid()||TARGET.GetHealth()<=0.00||TARGET.GetTeam()!=3||RETARGET>=RETARGET_TIME)
        EntFireByHandle(self,"RunScriptCode"," Tick() ",TICKRATE_IDLE,null,null);
    else
    {
        if(CanSide)
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
            EntFireByHandle(ts,"AddOutput","force "+(20*angdif*SPEED_TURNING).tostring(),0.00,null,null);
            EntFireByHandle(ts,"Activate","",0.02,null,null);
        }

        local tdist = GetDistance(self.GetOrigin(),TARGET.GetOrigin());
        local tdist2d = GetDistance2D(self.GetOrigin(),TARGET.GetOrigin());
		local tdistz = (TARGET.GetOrigin().z-self.GetOrigin().z);

        if(CanForward)
        {
            EntFireByHandle(tf,"AddOutput","force "+(1200*SPEED_FORWARD).tostring(),0.00,null,null);
            EntFireByHandle(tf,"Activate","",0.02,null,null);
        }
        if(!Attacking && tdist2d < 320 && tdistz < 80)SetAttack()

        if(!Attacking)RETARGET+=TICKRATE;
        if(RETARGET>=RETARGET_TIME)TARGET = null;
        EntFireByHandle(self,"RunScriptCode","Tick();",TICKRATE,null,null);
    }
}

function SearchTARGET()
{
	//if(debug)ScriptPrintMessageChatAll("SearchTARGET");
    RETARGET = 0;
	TARGET = null;
	local h = null;
	local candidates = [];
    local spos = GVO(self.GetOrigin(),0,0,80);
	while(null!=(h=Entities.FindInSphere(h,self.GetOrigin(),TAR_DISTANCE)))
	{
		if(h.GetClassname()=="player" && h.GetTeam()==3 && h.GetHealth()>0)
		{
            if(InSight(spos,GVO(h.GetOrigin(),0,0,48)))
			candidates.push(h);
		}
	}
	if(candidates.len()==0)
    {
        SetIdel();
    }
    else
    {
        TARGET=candidates[RandomInt(0,candidates.len()-1)];
        SetRun();
    }
}

sethp           <- true;
HPBASE          <- 200;
HPPERHUMAN      <- 90;
function Target()
{
	if(activator!=null&&activator.IsValid()&&activator.GetClassname()=="player"&&activator.GetTeam()==3&&activator.GetHealth()>0)
    {
        if(TARGET==null)
        {
            RETARGET = 0;
	        TARGET = activator;
            SetRun();
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
    if(Attacking)
    {
        CanForward = true;
        Attacking = false;
    }

}

function SetAttack()
{
    Attacking = true;
    CanForward = false;
    EntFireByHandle(Effect, "Start", "", 1.3, null, null)
    EntFireByHandle(Hurt, "Enable", "", 1.3, null, null)
    EntFireByHandle(Effect, "Stop", "", 4, null, null)
    EntFireByHandle(Hurt, "Disable", "", 4, null, null)
    SetAnimation(a_Flame);
}


function SetIdel()
{
    Running = false;
    if(!Idling)
    {
        SetDefAnimation(a_Idle);
        SetAnimation(a_Idle);
    }
    Idling = true;
}

function SetRun()
{
    Idling = false;
    if(!Running)
    {
        if(RandomInt(0,1))
        {
            SetDefAnimation(a_Move);
            SetAnimation(a_Move);
        }
        else
        {
            SetDefAnimation(a_Walk);
            SetAnimation(a_Walk);
        }
    }
    Running = true;
}

function SetDeath()
{
    Ticking = false;
    EntFireByHandle(ts,"Kill","",0,null,null);
    EntFireByHandle(tf,"Kill","",0,null,null);
    EntFireByHandle(Model,"ClearParent","",0,null,null);
    switch(RandomInt(0,2))
    {
        case 0:
            EntFireByHandle(Model,"FadeAndKill","",7,null,null);
            SetAnimation(a_Death1);
            break;
        case 1:
            EntFireByHandle(Model,"FadeAndKill","",1.3,null,null);
            SetAnimation(a_Death2);
            break;
        case 2:
            EntFireByHandle(Model,"FadeAndKill","",1.4,null,null);
            SetAnimation(a_Death3);

            break;
    }
    EntFireByHandle(self,"Kill","",4.2+0.1,null,null);
    EntFireByHandle(Keeper,"Kill","",4.2+0.1+0.01,null,null);
}

//////////////////////
//    Anims Block   //
//////////////////////
Attacking       <- false;
Idling          <- false;
Running         <- false;

a_Walk         <- "walk";      //походка
a_Move         <- "move";      //походка

a_Idle      <- "idle";
a_Shoot     <- "shoot";
a_Flame     <- "flame";

a_Death1     <- "die"
a_Death2    <- "die1"
a_Death3     <- "die2"

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