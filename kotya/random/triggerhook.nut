self.ConnectOutput("OnStartTouch", "StartTouch")
self.ConnectOutput("OnEndTouch", "EndTouch")


myname <- self.GetName();
if(myname == "")myname = "NULL" 
myclass <- self.GetClassname();
myorigin <- self.GetOrigin();
mycolor <- Vector(255,255,255);
mysize <- self.GetBoundingMaxs().x * 2 + self.GetBoundingMaxs().y * 2 + self.GetBoundingMaxs().z * 2;

MesT_Can <- true;
MesT_CD <- 5;
MesE_Can <- true;
MesE_CD <- 5;
switch (myclass)
{
    case "trigger_once":
    {
        self.ConnectOutput("OnStartTouch", "ShowPos")
        mycolor = Vector(255,128,0); //orange
        break;
    }
    case "trigger_multiple":
    {
        self.ConnectOutput("OnStartTouch", "ShowPos")
        mycolor = Vector(255,255,0); //yellow
        break;
    }
    case "trigger_hurt":
    {
        self.ConnectOutput("OnStartTouch", "ShowPos")
        mycolor = Vector(255,0,0); //red
        break;
    }
    case "trigger_teleport":
    {
        self.ConnectOutput("OnStartTouch", "ShowPos")
        mycolor = Vector(0,255,0); //green
        break;
    }
}

const glowTick = 2;
SPAWN <- true;
if(mysize >= 2048) SPAWN = false;
EntFireByHandle(self, "RunScriptCode", "OnPostSpawn()", 0.1, null, null);

function OnPostSpawn()
{
    if(SPAWN)DebugDrawBox(myorigin, self.GetBoundingMins(), self.GetBoundingMaxs(), mycolor.x, mycolor.y, mycolor.z, 100, glowTick+0.1);
    EntFireByHandle(self, "RunScriptCode", "OnPostSpawn()", glowTick, null, null);
}

function Toggle() 
{
    if(SPAWN)SPAWN = false;
    else SPAWN = true;    
}

function StartTouch() 
{
    local howtrigger = activator;

    ScriptPrintMessageCenterAll("StartTouch\nName: "+myname+"\nClass: "+myclass+"\nOrigin: "+myorigin.x+" "+myorigin.y+" "+myorigin.z+"\nSize: "+mysize+"\nCaller: "+howtrigger);
    if(MesT_Can)
    {
        MesT_Can = false;
        ScriptPrintMessageChatAll("StartTouch");
        Sup();
        ScriptPrintMessageChatAll("Caller: "+howtrigger);
        ScriptPrintMessageChatAll("================================");
        if(myclass != "trigger_once")EntFireByHandle(self, "RunScriptCode", "MesT_Can = true;", MesT_CD, null, null);
    }
    
}

function EndTouch() 
{
    local howtrigger = activator;

    ScriptPrintMessageCenterAll("EndTouch\nName: "+myname+"\nClass: "+myclass+"\nOrigin: "+myorigin.x+" "+myorigin.y+" "+myorigin.z+"\nSize: "+mysize+"\nCaller: "+howtrigger);
    if(MesE_Can)
    {
        MesE_Can = false;
        ScriptPrintMessageChatAll("StartTouch");
        Sup();
        ScriptPrintMessageChatAll("Caller: "+howtrigger);
        ScriptPrintMessageChatAll("================================");
        if(myclass != "trigger_once")EntFireByHandle(self, "RunScriptCode", "MesE_Can = true;", MesE_CD, null, null);
    }
}

function Sup() 
{
    ScriptPrintMessageChatAll("Name: "+myname);
    ScriptPrintMessageChatAll("Class: "+myclass);
    ScriptPrintMessageChatAll("Origin: "+myorigin.x+" "+myorigin.y+" "+myorigin.z);
    ScriptPrintMessageChatAll("Size: "+mysize);
}

function PrintInfo(center = true) 
{
    if(center)ScriptPrintMessageCenterAll("Name: "+myname+"\nClass: "+myclass+"\nOrigin: "+myorigin.x+" "+myorigin.y+" "+myorigin.z+"\nSize: "+mysize);
    Sup();
    ScriptPrintMessageChatAll("================================");
}

function ShowPos() 
{ 
    local holdtime = 20;
    local Origin = self.GetOrigin();
    local Maxs = self.GetBoundingMaxs();
    local Angles = activator.GetAngles();

    local pos1 = Origin + Maxs;
    local pos2 = Origin + Vector(Maxs.x,-Maxs.y,Maxs.z);
    local pos3 = Origin + Vector(-Maxs.x,-Maxs.y,Maxs.z);
    local pos4 = Origin + Vector(-Maxs.x,Maxs.y,Maxs.z);

    local pos5 = Origin + Vector(Maxs.x,Maxs.y,-Maxs.z);
    local pos6 = Origin + Vector(Maxs.x,-Maxs.y,-Maxs.z);
    local pos7 = Origin + Vector(-Maxs.x,-Maxs.y,-Maxs.z);
    local pos8 = Origin + Vector(-Maxs.x,Maxs.y,-Maxs.z);

    DebugDrawLine(pos1, pos2, mycolor.x, mycolor.y, mycolor.z, true, holdtime)
    DebugDrawLine(pos2, pos3, mycolor.x, mycolor.y, mycolor.z, true, holdtime)
    DebugDrawLine(pos3, pos4, mycolor.x, mycolor.y, mycolor.z, true, holdtime)
    DebugDrawLine(pos4, pos1, mycolor.x, mycolor.y, mycolor.z, true, holdtime)

    DebugDrawLine(pos5, pos6, mycolor.x, mycolor.y, mycolor.z, true, holdtime)
    DebugDrawLine(pos6, pos7, mycolor.x, mycolor.y, mycolor.z, true, holdtime)
    DebugDrawLine(pos7, pos8, mycolor.x, mycolor.y, mycolor.z, true, holdtime)
    DebugDrawLine(pos8, pos5, mycolor.x, mycolor.y, mycolor.z, true, holdtime)


    DebugDrawLine(pos1, pos5, mycolor.x, mycolor.y, mycolor.z, true, holdtime)
    DebugDrawLine(pos2, pos6, mycolor.x, mycolor.y, mycolor.z, true, holdtime)
    DebugDrawLine(pos3, pos7, mycolor.x, mycolor.y, mycolor.z, true, holdtime)
    DebugDrawLine(pos4, pos8, mycolor.x, mycolor.y, mycolor.z, true, holdtime)

    if(Maxs.z < 128)Origin += Vector(0,0,64);

    local text = Entities.CreateByClassname("point_worldtext");
    EntFireByHandle(text, "AddOutPut", "color "+mycolor.x.tostring()+" "+mycolor.y.tostring()+" "+mycolor.z.tostring(), 0, null, null);
    text.__KeyValueFromString("message", "Name: "+myname);
    text.SetOrigin(Origin);
    text.SetAngles(Angles.x,Angles.y,Angles.z);
    EntFireByHandle(text, "kill", "", holdtime, null, null);

    local text1 = Entities.CreateByClassname("point_worldtext");
    EntFireByHandle(text1, "AddOutPut", "color "+mycolor.x.tostring()+" "+mycolor.y.tostring()+" "+mycolor.z.tostring(), 0, null, null);
    text1.__KeyValueFromString("message", "Class: "+myclass);
    text1.SetOrigin(Origin-Vector(0,0,15));
    text1.SetAngles(Angles.x,Angles.y,Angles.z);
    EntFireByHandle(text1, "kill", "", holdtime, null, null);

    local text2 = Entities.CreateByClassname("point_worldtext");
    EntFireByHandle(text2, "AddOutPut", "color "+mycolor.x.tostring()+" "+mycolor.y.tostring()+" "+mycolor.z.tostring(), 0, null, null);
    text2.__KeyValueFromString("message", "Origin: "+myorigin.x+" "+myorigin.y+" "+myorigin.z);
    text2.SetOrigin(Origin-Vector(0,0,30));
    text2.SetAngles(Angles.x,Angles.y,Angles.z);
    EntFireByHandle(text2, "kill", "", holdtime, null, null);

    local text3 = Entities.CreateByClassname("point_worldtext");
    EntFireByHandle(text3, "AddOutPut", "color "+mycolor.x.tostring()+" "+mycolor.y.tostring()+" "+mycolor.z.tostring(), 0, null, null);
    text3.__KeyValueFromString("message", "Size: "+mysize);
    text3.SetOrigin(Origin-Vector(0,0,45));
    text3.SetAngles(Angles.x,Angles.y,Angles.z);
    EntFireByHandle(text3, "kill", "", holdtime, null, null);
    
}