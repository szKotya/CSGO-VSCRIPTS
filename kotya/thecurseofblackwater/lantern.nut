////////////////////////////////////////////////////////////////////
//Script by Kotya[STEAM_1:1:124348087]
//update 13.07 version 0.98b
////////////////////////////////////////////////////////////////////
battery <- 2;
batteryMax <- 0;

CD <- 10;

iTime <- 1;
WorkNow <- false;
Act <- null;

HudHandle <- null;

Ticking <- true;
Limit_dist <- 50;
Center_T <- Entities.FindByName(null, "distance_lantern");
Center_M <- Entities.FindByName(null, "center_move");
CHAT_CD <- true;
CHAT_CDBACK <- 4;


function filter()
{
  if (self.GetMoveParent().GetOwner() == activator && battery != 0)
  {
    EntFireByHandle(self, "FireUser1", "", 0.0, activator, activator);
    battery--;
    Work();
  }
}
function maxitemcounter(max)batteryMax = max;
function Pick()
{
  Act = activator;
  Ticking = true;
  CheckItem();
}

function batteryPickUp()
{
  battery++;
  batteryMax--;
  if(CHAT_CD)
  {
    CHAT_CD = false;
    ScriptPrintMessageChatAll("[Battery]\x03 have : \x02"+battery+"\x03 can find : \x02"+batteryMax);
    EntFireByHandle(self, "RunScriptCode", "CHAT_CD=true",CHAT_CDBACK, null, null);
  }
}

function sethandle(i)
{
  if(i==1)HudHandle = caller;
}

function Work()
{
  WorkNow = true;
  EntFireByHandle(HudHandle, "SetText", "Battery["+CD.tostring()+"]",0.00, null, null);
  for(local i=1; i<=CD ; i++) EntFireByHandle(HudHandle, "SetText", "Battery["+(CD-i).tostring()+"]",i, null, null);
  EntFireByHandle(self, "RunScriptCode", "WorkNow=false",CD, null, null);
}

function CheckItem()
{
    if(Ticking)
    {
        if(CheckLanternItem())
        {
            if(DistanceCheck() > Limit_dist || Act.GetHealth() <= 0)
            {
                EntFireByHandle(Center_M, "ClearParent", "", 0.00, null, null);
                Act = null;
                Ticking = false;
                SetPosM();
            }
            else
            {
                if(!WorkNow)EntFireByHandle(HudHandle, "SetText", "Battery["+battery.tostring()+"/"+batteryMax.tostring()+"]",0.00, Act, Act);
                EntFireByHandle(HudHandle, "Display", "",0.03, Act, Act);
                EntFireByHandle(self, "RunScriptCode", "CheckItem();", 0.05, null, null);
            }
        }
    }
}

function SetPosM()
{
    if(!Ticking)
    {
        local CurentPos = Center_M.GetOrigin();
        Center_M.SetAngles(Center_T.GetAngles().x,Center_T.GetAngles().y,Center_T.GetAngles().z);
        Center_M.SetOrigin(Center_T.GetOrigin());
        if(CompareCoordinates(CurentPos.x,CurentPos.y,CurentPos.z)){return;}
        EntFireByHandle(self, "RunScriptCode", "SetPosM();", 0.01, null, null);
    }
}

function CompareCoordinates(x1,y1,z1)
{
  local CurentPos = Center_M.GetOrigin();
	if(x1 == CurentPos.x && y1 == CurentPos.y && z1 == CurentPos.z)
	{
		return true;
	}
    else
    {
      return false;
    }
}

function CheckLanternItem()
{
    if(self != null && Center_T != null && Act != null && self.IsValid() && Center_T.IsValid())
    {
        return true;
    }
    else
    {
        return false;
    }
}

function DistanceCheck()
{
  local dist = (Act.GetOrigin().x-Center_T.GetOrigin().x)*(Act.GetOrigin().x-Center_T.GetOrigin().x)+(Act.GetOrigin().y-Center_T.GetOrigin().y)*(Act.GetOrigin().y-Center_T.GetOrigin().y)+(Act.GetOrigin().z-Center_T.GetOrigin().z)*(Act.GetOrigin().z-Center_T.GetOrigin().z);
  return sqrt(dist);
}


