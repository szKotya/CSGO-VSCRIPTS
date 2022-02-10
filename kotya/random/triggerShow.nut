SPAWN <- true;
GLOW <- true;
Message <- false;

minusAlpha <- null;
COLOR <- null;

const glowTick = 0.2;
const alphaTick = 1.00;
const mTick = 0.50;
const minAlpha = 5;
const chatTick = 0.75;

chatCounter <- 0;
Alpha <- 100;
//Settings↑----------------------------------------------

mPrint <- ["Shoot the button",
"Shoot the door",
"Defend your position",
"Shoot the boss"];

//Message print↑-----------------------------------------
function OnPostSpawn()
{
    if(SPAWN)
    {
        DrawGlow();
        EntFireByHandle(self, "RunScriptCode", "OnPostSpawn()", glowTick, null, null);
    }
}

function DrawGlow() //Свечение
{
    if(GLOW && !SPAWN)
    {
        DebugDrawBox(Vector(self.GetOrigin().x.tointeger(),self.GetOrigin().y.tointeger(),self.GetOrigin().z.tointeger()), self.GetBoundingMins(), self.GetBoundingMaxs(), GetColor().x, GetColor().y, GetColor().z, Alpha, glowTick+0.10);
        EntFireByHandle(self, "RunScriptCode", "DrawGlow()", glowTick, null, null);
    }
    else
        DebugDrawBox(Vector(self.GetOrigin().x.tointeger(),self.GetOrigin().y.tointeger(),self.GetOrigin().z.tointeger()), self.GetBoundingMins(), self.GetBoundingMaxs(), GetColor().x, GetColor().y, GetColor().z, Alpha, glowTick+0.10);
}

function GetAlpha() //Уменьшение альфы от 100 до 0 к концу таймера 
{
    if(Alpha - minAlpha >= minAlpha)
    {
        Alpha = Alpha - minusAlpha;                                                  //Вычитание альфы по шагу 
        EntFireByHandle(self, "RunScriptCode", "GetAlpha()", alphaTick, null, null); //Рекурсия по таймеру
    }
}
function StopGlow(){GLOW = false;}

function GetColor()
{
    if(COLOR == null){return Vector(RandomInt(1,255),RandomInt(1,255),RandomInt(1,255));}
    else{return Vector(COLOR.x,COLOR.y,COLOR.z);}
}

function GlowSettings(r,g,b)
{
    Color(r,g,b);
    if(r == 256 && g == 256 && b == 256){COLOR = null}
}

function StartGlow(t)  //Старт
{
    SPAWN = false;
    GLOW = true;
    if(t!=-1)    //Если таймер свечения
    {
        minusAlpha = Alpha / t ;  //От макс альвы находит шаг, чтобы вычетать его
        DrawGlow();
        GetAlpha();   //Уменьшение альфы от 100 до 0 к концу таймера
        EntFireByHandle(self, "RunScriptCode", "Alpha = minAlpha", t-1, null, null); //Dыключение по таймеру t
        EntFireByHandle(self, "RunScriptCode", "GLOW = false;", t, null, null); //Dыключение по таймеру t
    }
    else    //Если нет таймера свечения, то будет просто светиться 
    {
        EntFireByHandle(self, "RunScriptCode", "DrawGlow();", 0.00, null, null);
    }
}

function Color(r,g,b){COLOR = Vector(r,g,b);}
//Glow↑----------------------------------------------------------

function StartMessageCt(iMes,t)
{   
    Message = true;
    if (t!=-1)
    {   
        SpamMessage(iMes);
        EntFireByHandle(self, "RunScriptCode", "Message = false;", t, null, null);
    }
    else
    {
        SpamMessage(iMes);    
    }
}

function SpamMessage(iMes)
{
    if (Message)
    {   
        local SpamMsg = "SpamMessage("+iMes+")";
        local hudPrint = ">>> "+mPrint[iMes]+" <<<";
        ScriptPrintMessageCenterTeam(3,hudPrint);
        EntFireByHandle(self, "RunScriptCode", SpamMsg, mTick, null, null);
    }
}   
function EndMessage(){Message = false;}
//MessageHud↑------------------------------------------

function chatMsg(iMes)
{
    if(chatCounter!=3)
    {   
        local chatMessage = "chatMsg("+iMes+")";
        local chatPrint = "say <<< "+mPrint[iMes]+" >>>";
        EntFire("cmd","Command",chatPrint,0,null);
        EntFireByHandle(self, "RunScriptCode", chatMessage, chatTick, null, null);
        chatCounter++;  
    }
}
//ChatMsg
function sButtonSet(t)
{
    colorGreen();
    chatMsg(0)
    StartMessageCt(0,t);
    StartGlow(t)
}

function sDoorSet(t)
{
    colorYellow();
    chatMsg(1)
    StartMessageCt(1,t);
    StartGlow(t)
}

function sDefSet(t)
{
    colorRed();
    chatMsg(2)
    StartMessageCt(2,t);
    StartGlow(t)
}

function sBossSet(t)
{
    colorRed();
    chatMsg(3)
    StartMessageCt(3,t);
    StartGlow(t)
}

function EndMsgnGlow()
{
    EndMessage();
    StopGlow();
}

function colorGreen(){GlowSettings(0,255,0);}
function colorYellow(){GlowSettings(255,255,0);}
function colorBlue(){GlowSettings(0,0,255);}
function colorRed(){GlowSettings(255,0,0);}
//Glow+Messagehud setup↑--------------------------------