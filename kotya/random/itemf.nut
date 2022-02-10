
////////////////////////////////////////////////////////////////////
//Script by Kotya[STEAM_1:1:124348087]
//update 06.07 version 0.95
////////////////////////////////////////////////////////////////////
battery <- 2;
batteryMax <- SpawnBatteryCount+battery;

CD <- 10;

iTime <- 1;
WorkNow <- false;
canUse <- true;
Act <- null;

PushHandle <- null;
HudHandle <- null;

Ticking <- true;
Limit_dist <- 50;
Center_T <- Entities.FindByName(null, "distance_lantern");
Center_M <- Entities.FindByName(null, "center_move");

Level <- 1;

SpawnBatteryCount <- 3; //Гарантированный спавн RandomInt(1,8) 1-минимальное кол-во. 8 макс кол-во

SpawnPosBatteryLevelOne <- [
"1",
"2",
"3",
"4",
"5",
"6",
"7",
"8",
"9",
"0"
];
SpawnPosBatteryLevelTwo <- [
"q",
"w",
"e",
"r",
"t",
"y",
"u",
"i",
"o",
"p"
];
SpawnPosBatteryLevelThree <- [
"z",
"x",
"c",
"v",
"b",
"n",
"m"
];

function SpawnBatteryRandom() 
{
  local spawn = null;
  local spawnsto = [];
  local timertospawn = 0.0;
  if (Level==1)spawn = SpawnPosBatteryLevelOne;
  else if (Level==2)spawn = SpawnPosBatteryLevelTwo;
  else if (Level==3)spawn = SpawnPosBatteryLevelThree;
  else break;
  for(local i=0; i<=SpawnBatteryCount)
  {
    local j = RandomInt(0,spawn.len());
    for (local a=0; a<=spawnsto.len(); a++)
    {
      if (spawn[j] != spawnsto[a])
      {
        spawnsto.push(spawn[j]);
        //EntFire("Template_Batterys", "addoutput", "origin "+spawn[j], timertospawn++;, null);
        //EntFire("Template_Batterys", "forcespawn", "", timertospawn++;i+0.1, null);
        ScriptPrintMessageChatAll(spawn[j].tostring());
        i++
        timertospawn++;
      }
    }
  }
  ScriptPrintMessageChatAll("SpawnRandom");
  for(local i=0; i<=spawn.len() ; i++)
  {
    local nespawn = false;
    for (local a=0; a<=spawnsto.len();)
    {
      if(spawn[i] = spawnsto[a])nespawn = true;
    }
    if(!nespawn)
    {
      ScriptPrintMessageChatAll(spawn[i].tostring());
      //EntFire("Template_Batterys", "addoutput", "origin "+spawn[i], timertospawn, null);
      //EntFire("Template_Batterys", "forcespawn", "", timertospawn+0.1, null);
      timertospawn++;
    }
  }
}

function filter() 
{
  if (self.GetMoveParent().GetOwner() == activator && battery != 0)
  {
    EntFireByHandle(self, "FireUser1", "", 0.0, activator, activator);
    battery--;
    Work(); 
  }
}

function Pick()
{
  Act = activator;
  Ticking = true;
  CheckItem();
}

function batteryPickUp() 
{
  if(battery < batteryMax)
  {
    battery++;
  }
}

function sethandle(i)
{
  if(i==2)HudHandle = caller;
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
                if(!WorkNow)EntFireByHandle(HudHandle, "SetText", "Battery["+battery.tostring()+"/"+10+"]",0.00, Act, Act);
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

function OnPostSpawn() 
{
  SpawnBatteryRandom()
}

