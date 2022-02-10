////////////////////////////////////////////////////////////////////
//Script by Kotya[STEAM_1:1:124348087]
//update 13.07 version 0.98b
////////////////////////////////////////////////////////////////////
heal <- 2;
HealMax <- 0;

CD <- 10;

iTime <- 1;
WorkNow <- false;
Act <- null;

HudHandle <- null;

CHAT_CD <- true;
CHAT_CDBACK <- 4;
function filter() 
{
  if (self.GetMoveParent().GetOwner() == activator && heal != 0)
  {
    EntFireByHandle(self, "FireUser1", "", 0.0, activator, activator);
    heal--;
    Work(); 
  }
}

function Pick()
{
  Act = activator;
  CheckItem();
}

function healPickUp() 
{
  heal++;
  HealMax--;
  if(CHAT_CD)
  {
    CHAT_CD = false;
    ScriptPrintMessageChatAll("[Pills]\x03 have : \x02"+heal+"\x03 can find : \x02"+HealMax);
    EntFireByHandle(self, "RunScriptCode", "CHAT_CD=true",CHAT_CDBACK, null, null);
  }
}

function maxitemcounter(max)HealMax = max;

function sethandle(i)
{
  if(i==1)HudHandle = caller;
}

function Work()
{
  WorkNow = true;
  EntFireByHandle(HudHandle, "SetText", "Heal["+CD.tostring()+"]",0.00, null, null);
  for(local i=1; i<=CD ; i++) EntFireByHandle(HudHandle, "SetText", "Heal["+(CD-i).tostring()+"]",i, null, null);
  EntFireByHandle(self, "RunScriptCode", "WorkNow=false",CD, null, null);
}

function CheckItem()
{
  if(self.GetMoveParent().GetOwner() != Act)Act=null;
  if(!WorkNow)EntFireByHandle(HudHandle, "SetText", "Heal["+heal.tostring()+"/"+HealMax.tostring()+"]",0.00, Act, Act);
  EntFireByHandle(HudHandle, "Display", "",0.03, Act, Act);
  EntFireByHandle(self, "RunScriptCode", "CheckItem();", 0.05, null, null);
}

