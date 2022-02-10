g_ahPlayers <- [];

class class_player_move
{
    angles = null;
    handle = null;

    constructor(_handle)
    {
        this.handle = _handle;
    }
}

const TICKRATE = 0.25;

g_hModel <- null;
g_hSound <- null;
g_bTicking <- false;
g_bKilling <- false;
g_bPreKilling <- false;
g_szAnim <- "";

g_fTimer_Killing <- 0.0;
g_fTimer_Check <- 0.0;

g_fAddTime_Killing <- 0.5;
g_fTime_Killing <- 5.0;
g_fTime_Check <- 1.0;
g_fRemoveTime_Check <- TICKRATE * 0.25;

function Init()
{
    g_hModel = Entities.FindByName(null, "matryoshka_prop");
    g_hSound = Entities.FindByName(null, "matryoshka_sound");

    g_fTimer_Killing = 0.00 + g_fTimer_Killing;
    g_fTimer_Check = 0.00 + g_fTimer_Check;
    g_fAddTime_Killing = 0.00 + g_fAddTime_Killing;
    g_fTime_Killing = 0.00 + g_fTime_Killing;
    g_fTime_Check = 0.00 + g_fTime_Check;
    g_fRemoveTime_Check = 0.00 + g_fRemoveTime_Check;
}

function Tick() 
{
    if (!g_bTicking)
        return;

    TickCheck();

    TickKillMovingPlayers();
    TickKillingPhase();

    TickReset();

    //TickDebug();

    EntFireByHandle(self, "RunScriptCode", "Tick()", TICKRATE, null, null);
}

function TickReset() 
{
    if (g_bKilling || g_bPreKilling)
        return;
    
    if (g_ahPlayers.len() < 1) {Reset();}    
}

function Reset() 
{
    g_bTicking = false;
    g_fTimer_Check = 0.0; 
    g_fTimer_Killing = 0.0;
}

function TickCheck() 
{
    if (g_ahPlayers.len() < 1)
    {
        g_fTimer_Check = 0.0;
    }


    if (g_bKilling || g_bPreKilling)
        return;

    {
        local bMove = false;
        for (local i = 0; i < g_ahPlayers.len(); i++)
        {
            if (g_ahPlayers[i].handle.IsValid() && g_ahPlayers[i].handle.GetHealth() > 0)
            {
                local vVelocity = g_ahPlayers[i].handle.GetVelocity(); 
                if (vVelocity.x != 0 || vVelocity.y != 0 || vVelocity.z != 0)
                {
                    bMove = true;
                    break;
                } 
                    
            }
        }

        if(!bMove) 
        {
            g_fTimer_Check -= g_fRemoveTime_Check;
            if (g_fTimer_Check <= 0.0) {g_fTimer_Check = 0.0;}
            
            return;
        }
    }
         
    g_fTimer_Check += TICKRATE;
    
    if (g_fTimer_Check >= g_fTime_Check)
    {
        g_fTimer_Check = 0.0;
        g_bPreKilling = true;

        SetForward();
        EntFireByHandle(self, "RunScriptCode", "SaveAngles();g_bKilling = true;g_bPreKilling = false;", 1.5, null, null);
    }
}

function SaveAngles()
{
    for (local i = 0; i < g_ahPlayers.len(); i++)
    {
        if (g_ahPlayers[i].handle.IsValid() && g_ahPlayers[i].handle.GetHealth() > 0)
        {
            g_ahPlayers[i].angles = g_ahPlayers[i].handle.GetAngles();
            continue;
        }

        g_ahPlayers.remove(i);
    }
}

function TickKillingPhase() 
{
    if (!g_bKilling)
        return;

    g_fTimer_Killing += TICKRATE;

    if (g_fTimer_Killing >= g_fTime_Killing)
    {
        g_fTimer_Killing = 0.0;
        g_bKilling = false;
        SetBackward();
    }
}

function TickKillMovingPlayers()
{
    if (!g_bKilling)
        return;

    for (local i = 0; i < g_ahPlayers.len(); i++)
    {
        if (g_ahPlayers[i].handle.IsValid() && g_ahPlayers[i].handle.GetHealth() > 0)
        {
            local vVelocity = g_ahPlayers[i].handle.GetVelocity();
            local vAngles1 = g_ahPlayers[i].handle.GetAngles();
            local vAngles2 = g_ahPlayers[i].angles;
            if ((vVelocity.x == 0 && vVelocity.y == 0 && vVelocity.z == 0) && (
                vAngles1.x == vAngles2.x && vAngles1.y == vAngles2.y && vAngles1.z == vAngles2.z))
                continue;
            local timetokill = RandomFloat(0, TICKRATE);
            g_fTimer_Killing -= g_fAddTime_Killing;
            EntFireByHandle(g_ahPlayers[i].handle, "SetHealth", "-1", timetokill, null, null);
            EntFireByHandle(g_hSound, "PlaySound", "", timetokill, null, null);
        }

        g_ahPlayers.remove(i);
    }
}

function TickDebug() 
{
    local text = "";
    text += g_fTimer_Killing + "\n";
    text += g_bKilling + "\n";
    text += g_fTimer_Check + "\n";
    text += g_ahPlayers.len()
    if (text != "")
        ScriptPrintMessageCenterAll(text);
}


function Tounch() 
{
    if (InArray(activator, g_ahPlayers) != -1) {return;}
    
    g_ahPlayers.push(class_player_move(activator));

    if (!g_bTicking) 
    {
        g_bTicking = true;
        Tick();
    }
        
}

Anim_Backward <- "start";
Anim_Backward_Idle <- "kill";

Anim_Forward <- "forward";
Anim_Forward_Idle <- "idle";

function SetForward()
{
    if (g_szAnim != "forward")
    {
        SetAnimation(Anim_Forward);
        SetDefaultAnimation(Anim_Forward_Idle);
    }

    g_szAnim = "forward";
}

function SetBackward()
{
    if (g_szAnim != "backward")
    {
        SetAnimation(Anim_Backward);
        SetDefaultAnimation(Anim_Backward_Idle);
    }

    g_szAnim = "backward";
}
function EndTounch() 
{
    local iActivator = InArray(activator, g_ahPlayers);
    
    if (iActivator != -1)
        g_ahPlayers.remove(iActivator);    
}

function InArray(value, array) 
{

    for (local i = 0; i < array.len(); i++)
    {
        if (value == array[i].handle)
            return i; 
    }    

    return -1;
}
EntFireByHandle(self, "RunScriptCode", "Init()", 0, null, null);

function SetAnimation(animationName,time = 0)
{
    EntFireByHandle(g_hModel, "SetAnimation", animationName, time, null, null);
}

function SetDefaultAnimation(animationName,time = 0)
{
    EntFireByHandle(g_hModel, "SetDefaultAnimation", animationName, time, null, null);
}