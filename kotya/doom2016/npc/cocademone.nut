
IncludeScript("kotya/doom2016/support/models.nut");
IncludeScript("kotya/doom2016/support/math.nut");



TICKRATE 	    <- 0.10;
TICKRATE_IDLE 	<- 1;
TARGET          <- null;
TARGET_TOMOVE   <- null;
RETARGET        <- 0;
//////////////////////
//  Settings block  //
//////////////////////
HP_BASE         <- 10000;
HP_PERHUMAN     <- 700;
TAR_DISTANCE    <- 1200;
RETARGET_TIME 	<- 12.00;
//////////////////////
//   Handle block   //
//////////////////////
class position
{
    handle = null;
    dist = 0;
    constructor(_handle)
    {
        handle = _handle;
    }
    function GetDist(TARGET,Mover)
    {
        if(TARGET != null && TARGET.IsValid() && TARGET.GetHealth() > 0)
        {
            if(TraceLine(this.handle.GetOrigin(),Mover.GetOrigin(),this.handle)==1.00 &&
            TraceLine(this.handle.GetOrigin(),TARGET.GetOrigin(),this.handle)==1.00)
            {
                return this.dist =
                sqrt(
                (this.handle.GetOrigin().x-TARGET.GetOrigin().x)*(this.handle.GetOrigin().x-TARGET.GetOrigin().x)
                +(this.handle.GetOrigin().y-TARGET.GetOrigin().y)*(this.handle.GetOrigin().y-TARGET.GetOrigin().y)
                +(this.handle.GetOrigin().z-TARGET.GetOrigin().z)*(this.handle.GetOrigin().z-TARGET.GetOrigin().z));

            }
        }
        return this.dist = 999999;
    }
}

Model  <- null;
Path   <- null;
Hbox   <- null;
Pos <- [];
function SetHandle()
{
    local name = caller.GetName();
    if(caller.GetClassname() == "prop_dynamic")
    {
        local me = position(caller);
        Pos.push(me);
    }

    if(caller.GetClassname() == "func_physbox_multiplayer")Hbox = caller;
    if(caller.GetClassname() == "path_track")Path = caller;
    if(caller.GetClassname() == "prop_dynamic_glow")Model = caller;
}

function PrintPos()
{
    if(Pos.len()==0)return printl("ziro");
    for (local i=0; i<Pos.len(); i++)
    {
        printl("HANDLE: "+Pos[i].handle+" Dist: "+Pos[i].dist);
    }
}

function CheckDist()
{
    local min = Pos[0];
    for (local i=1; i<Pos.len(); i++)
    {
        local a = min.GetDist(TARGET,self);
        local b = Pos[i].GetDist(TARGET,self);
        if(a > b){min = Pos[i]}
    }
    return min.handle;
}

function SearchTarget()
{
	//ScriptPrintMessageChatAll("SearchTARGET");
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
    if(candidates.len()==0)return;
    return TARGET = candidates[RandomInt(0,candidates.len()-1)];
}

function Tick()
{
    EntFireByHandle(self,"RunScriptCode","Tick();",TICKRATE,null,null);
    if(TARGET==null||!TARGET.IsValid()||TARGET.GetHealth()<=0.00||TARGET.GetTeam()!=3||RETARGET>=RETARGET_TIME)SearchTarget();
    if(TARGET==null||!TARGET.IsValid()||TARGET.GetHealth()<=0.00||TARGET.GetTeam()!=3||RETARGET>=RETARGET_TIME)
    {
        EntFireByHandle(self,"RunScriptCode"," Tick() ",TICKRATE_IDLE,null,null);
    }
    else
    {

        local gto = CheckDist();
        Path.SetOrigin(gto.GetOrigin());

        local tm_ang = GetTartgetYaw(TARGET.GetOrigin(),Model.GetOrigin());
        EntFireByHandle(self, "StartForward", "", 0.00, null, null);
        Model.SetAngles(-90,tm_ang,0);
    }
}
//////////////////////
//    Anims Block   //
//////////////////////
Spawning <- true;
A_attack    <- "atk01"
A_move     <- "move"
A_fly       <- "polet"
A_spawn     <- "spawn"
A_idle1     <- "idle1"
A_idle2     <- "idle2"


function AnimComplete()
{
    // if(Spawning)
    // {
    //     local h = null;
    //     local Count = 0;
    //     while(null!=(h=Entities.FindInSphere(h,self.GetOrigin(),TAR_DISTANCE*2)))
    //     {
    //         if(h.GetClassname()=="player" && h.GetTeam()==3 && h.GetHealth()>0)Count++;
    //     }
    //     EntFireByHandle(Hbox, "SetHealth", (HP_BASE+HP_PERHUMAN*Count).tostring(), 0, null, null);
    //     EntFireByHandle(Hbox, "Enable", "", 0.2, null, null);
    //     Spawning = false;
    //     Ticking = true;
	// 	Tick();
    // }
}
