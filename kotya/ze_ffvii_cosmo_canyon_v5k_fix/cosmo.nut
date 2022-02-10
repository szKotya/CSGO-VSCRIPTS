/*
Script by Kotya[STEAM_1:1:124348087]
update 07.12.2020
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
class FullPos
{
  origin = null;
  angles = null;
  constructor(_origin,_angles)
  {
    origin = _origin;
    angles = _angles;
  }
}

Gen_Model <- null;
Sep_Model <- null;
LaserCounter <- 0;
Path <- [];
Angles <- [];
BadEnd <- false;
debag <- false;

function StartBadEnd()
{
  if(!LaserCounter)
  {
    BadEnd = true
    if(RandomInt(0,1)){Path = LeftVersion;Angles = LeftAng}
    else {Path = RightVersion;Angles = RightAng}
  }
  Sep_Model.SetOrigin(Path[LaserCounter]);
  Sep_Model.SetAngles(Angles[LaserCounter].x,Angles[LaserCounter].y,Angles[LaserCounter].z);
  switch (RandomInt(0,4)){
  case 0:{SepLaser1();break;}
  case 1:{SepLaser2();break;}
  case 2:{SepLaser3();break;}
  case 3:{SepLaser4();break;}
  case 4:{SepLaser5();break;}
  }
  LaserCounter++;
}
Side <- null;
ang <- 0;

function SetSide()
{
  Side = RandomInt(0,1);
  if(Side)
  {
    EntFire("Zeddy_Text2", "AddOutput", "message Red-XIII just made it! It says LEFT SIDE!", 0, null);
  }
  else
  {
    EntFire("Zeddy_Text2", "AddOutput", "message Red-XIII just made it! It says RIGHT SIDE!", 0, null);
  }
  EntFire("Zeddy_Text2", "Display", "", 0.1, null);
}
function GetStatus()
{
  local ang = 15;
  if(RandomInt(0,1))ang = ang * -1;
  caller.SetAngles(caller.GetAngles().y+ang,caller.GetAngles().y,0)
}

function StartGoodEnd()
{
  local timer = RandomFloat(0.01,0.1);
  if(Side)ang += 90
  else ang -= 90
  EntFire("Van_rotating", "AddOutPut", "angles 0 "+(ang).tostring()+" 0", timer-0.5, null);
  EntFireByHandle(self,"RunScriptCode","VanPickAnim();",timer+0.2,null,null);
  LaserCounter++
}

function VanPickAnim() {
  switch (RandomInt(0,4))
  {
    case 0:{SepLaser1();break;}
    case 1:{SepLaser2();break;}
    case 2:{SepLaser3();break;}
    case 3:{SepLaser4();break;}
    case 4:{SepLaser5();break;}
  }
}
////////////////////////////////////////////
Sep_Idle <- "idle";
Sep_Attack1 <- "attack1"; //rotor
Sep_Attack2 <- "attack2"; //Power attack
Sep_Attack3 <- "attack4"; //vertuxa
Sep_Attack4 <- "attack5"; //Prost udar
Sep_Attack5 <- "attack6"; //Power attack
////////////////////////////////////////////
Gen_Idle <- "idle";
Gen_Idle1 <- "idle2";
Gen_Flying <- "atackbat14";
Gen_Run <- "run";
Gen_Dead <- "atackbat15"; //smert
Gen_ChangePosition <- "atackbat8";
Gen_Flying_Attack <- "atackbat4"; //udar v vosduhe
Gen_Flying_Attack1 <- "atackbat7"; //udar v vosduhe
Gen_Attack <- "atackbat6";
Gen_Attack1 <- "atackbat2";
Gen_Parry <- "atackbat10"; //pariroval
Gen_Summon <- "Summon";
Gen_Summon1 <- "Summon2";
////////////////////////////////////////////

RightVersion <-[
Vector(-12408 7440 2709),
Vector(-12688 7200 2709),
Vector(-12408 6960 2709),
Vector(-12688 6720 2709),
Vector(-12548 6668 2709)];
RightAng <-[
Vector(0 267 0),
Vector(0 273 0),
Vector(0 267 0),
Vector(0 273 0),
Vector(0 270 0)
];
////////////////////////////////////////////
LeftVersion <- [
Vector(-12688 7440 2709),
Vector(-12408 7200 2709),
Vector(-12688 6960 2709),
Vector(-12408 6720 2709),
Vector(-12548 6668 2709)];
LeftAng <-[
Vector(0 273 0),
Vector(0 267 0),
Vector(0 273 0),
Vector(0 267 0),
Vector(0 270 0)
];
function GetPosPotion()
{
  local Potion = Entities.FindByName(null, "Potion_Temp")
  switch (RandomInt(0,3))
  {
    case 0:
    EntFireByHandle(Potion,"AddOutPut","origin -2140 -3687 128",0,null,null)
    EntFireByHandle(Potion,"ForceSpawn","",0.1,null,null)
    break;
    case 1:
    EntFireByHandle(Potion,"AddOutPut","origin -3006 -4035 2085",0,null,null)
    EntFireByHandle(Potion,"ForceSpawn","",0.1,null,null)
    break;
    case 2:
    EntFireByHandle(Potion,"AddOutPut","origin -7191 -181 1888",0,null,null)
    EntFireByHandle(Potion,"ForceSpawn","",0.1,null,null)
    break;
    case 3:
    EntFireByHandle(Potion,"AddOutPut","origin -446 -1362 737",0,null,null)
    EntFireByHandle(Potion,"ForceSpawn","",0.1,null,null)
    break;
  }
}

function DoneAnim()
{
  if(LaserCounter==Path.len()-1)
  {
    EntFireByHandle(Sep_Model,"SetAnimation",Sep_Idle,0,null,null)
  }
}
RandomSim<-[
"!",
"@",
"#",
"?",
"%",
"/",
"=",
"+",
"-",
"&"];
KotyaText <- ["!","o","t","y","a"];
function GenerateText()
{
  local timer = 0;
  for(local i=0; i < 29; i++)
  {
    local word = "";
    if(RandomInt(0,4)==0) word += "u̵̸n̸k҈n̶̷o̸̵w҈n̶"
    else
    {
      for (local i=0; i<KotyaText.len(); i++)
      {
        if(RandomInt(0,5)==0)word+=KotyaText[i];
        else word+=RandomSim[RandomInt(0,RandomSim.len()-1)];
      }
    }
    EntFire("Zeddy_Text2", "SetText", "Special Thanks to memories, "+word+" and Demon!", timer, null)
    EntFire("Zeddy_Text2", "Display", "", timer+0.01, null)
    timer+=RandomFloat(0.2,0.25);
  }
  EntFire("Zeddy_Text2", "SetText", "Special Thanks to memories, u̵̸n̸k҈n̶̷o̸̵w҈n̶  and Demon!", timer, null)
}
function SepLaser1()
{
  local timer = 0.32;
  local timer1 = 0.80;
  EntFire("Billy_Laser_Sound", "PlaySound", "", timer, null)
  EntFireByHandle(Sep_Model,"SetAnimation",Sep_Attack1,0,null,null)
  if(BadEnd)
  {
    EntFire("Laser_GachiMaker", "forcespawn", "", timer, null)//0.32
  }
  else EntFireByHandle(self,"RunScriptCode","VanPickRandomLaser();",timer,null,null);
  BackSep(timer1);
}

function SepLaser2()
{
  local timer = 0.62;
  local timer1 = 1.1;
  EntFire("Billy_Laser_Sound", "PlaySound", "", timer, null)
  EntFireByHandle(Sep_Model,"SetAnimation",Sep_Attack2,0,null,null)
  if(BadEnd)
  {
    EntFire("Laser_GachiMaker", "forcespawn", "", timer, null)//0.62
  }
  else EntFireByHandle(self,"RunScriptCode","VanPickRandomLaser();",timer,null,null);
  BackSep(timer1);
}

function SepLaser3()
{
  local timer = 1;
  local timer1 = 1.4;
  EntFire("Billy_Laser_Sound", "PlaySound", "", timer, null)
  EntFireByHandle(Sep_Model,"SetAnimation",Sep_Attack3,0,null,null)
  if(BadEnd)
  {
    EntFire("Laser_GachiMaker", "forcespawn", "", timer, null)//1
  }
  else EntFireByHandle(self,"RunScriptCode","VanPickRandomLaser();",timer,null,null);
  BackSep(timer1);
}

function SepLaser4()
{
  local timer = 0.4;
  local timer1 = 0.75;
  EntFire("Billy_Laser_Sound", "PlaySound", "", timer, null)
  EntFireByHandle(Sep_Model,"SetAnimation",Sep_Attack4,0,null,null)
  if(BadEnd)
  {
    EntFire("Laser_GachiMaker", "forcespawn", "", timer, null)//0.4
  }
  else EntFireByHandle(self,"RunScriptCode","VanPickRandomLaser();",timer,null,null);
  BackSep(timer1);
}

function SepLaser5()
{
  local timer = 0.5;
  local timer1 = 1.2;
  EntFire("Billy_Laser_Sound", "PlaySound", "", timer, null)
  EntFireByHandle(Sep_Model,"SetAnimation",Sep_Attack5,0,null,null)
  if(BadEnd)
  {
    EntFire("Laser_GachiMaker", "forcespawn", "", timer, null)//0.5
  }
  else EntFireByHandle(self,"RunScriptCode","VanPickRandomLaser();",timer,null,null);
  BackSep(timer1);
}

function BackSep(timer1)
{
  if(BadEnd)
  {
    if(LaserCounter!=Path.len()-1){
    EntFireByHandle(self,"RunScriptCode","StartBadEnd();",timer1+0.2,null,null);}
  }
  else
  {
    if(LaserCounter!=4){
    local delaybeforelasers = -0.1;
    EntFireByHandle(self,"RunScriptCode","StartGoodEnd();",timer1+delaybeforelasers,null,null);}
    else
    {
      EntFire("Van_sama", "FadeAndKill", "", timer1+1, null)//0.5
    }
  }
}

RandomShaffle <- ["Laser_Van1_Maker","Laser_Van2_Maker","Laser_Van3_Maker"];
RandomShaffleback <- ["Laser_Van1_Maker","Laser_Van2_Maker","Laser_Van3_Maker"];
function VanPickRandomLaser()
{
  local i;
  if(RandomShaffle.len() == 0)RandomShaffle = RandomShaffleback.slice(0,RandomShaffleback.len());
  if(RandomShaffle.len() == 1)i = 0;
  else i = RandomInt(0,RandomShaffle.len()-1);
  local Random = RandomShaffle[i];
  if (Random == "Laser_Van1_Maker")
  {
    EntFire("Zeddy_RedX_Model", "SetAnimation", "jump", 0.7, null);
    EntFire("Zeddy_RedX_Model", "SetAnimation", "idle", 1.35, null);
  }
  EntFire(Random, "forcespawn", "", 0, null);
  RandomShaffle.remove(i);
}

function SetModelHandle(a)
{
  if(a)Sep_Model = caller;
  else Gen_Model = caller;
}

function BackGenChopper(timer1)
{
  if(RandomInt(0,1))EntFireByHandle(Gen_Model,"SetAnimation",Gen_Idle,timer1,null,null);
  else EntFireByHandle(Gen_Model,"SetAnimation",Gen_Idle1,timer1,null,null);
  EntFireByHandle(self, "Runscriptcode", "Gen_Model.SetAngles(0,90,0);", timer1, null, null);
  if(Present)
  {
    EntFire("Billy_train", "startforward", "", timer1+1, null)//0.5
  }
  if(!Present)
  {
    Present = true;
    EntFireByHandle(self, "Runscriptcode", "GenesisPresent()", timer1, null, null);
  }
}

function BillyPickRandomLaser()
{
  switch (RandomInt(0,4))
  {
    case 0:
      EntFire("Laser_Billy1_Maker", "forcespawn", "", 0, null);
      break;
    case 1:
      EntFire("Laser_Billy2_Maker", "forcespawn", "", 0, null);
      break;
    case 2:
      EntFire("Laser_Billy3_Maker", "forcespawn", "", 0, null);
      break;
    case 3:
      EntFire("Laser_Billy4_Maker", "forcespawn", "", 0, null);
      break;
    case 4:
      EntFire("Laser_Billy5_Maker", "forcespawn", "", 0, null);
      break;
  }
}
Chopper <- ["Shinra_Props_chopperR1_train","Shinra_Props_chopperL1_train"];
ChopperAir <- ["Shinra_Props_chopperR2_train","Shinra_Props_chopperL2_train"];
ChopperPos <- [Vector(0,125,0),Vector(0,45,0)];
ChopperPosLaser <- [Vector(-12161 5911 2753),Vector(-12639 5491 2753)];
ChopperPosLaserAng <- [Vector(0,40,5),Vector(0,-20,5)];

function BillyPickRandomLaserChopper(i)
{
  local maker = null;
  switch (RandomInt(1,5))
  {
    case 1:
      maker = Entities.FindByName(null, "Laser_Billy1_Maker")
      break;
    case 2:
      maker = Entities.FindByName(null, "Laser_Billy2_Maker")
      break;
    case 3:
      maker = Entities.FindByName(null, "Laser_Billy3_Maker")
      break;
    case 4:
      maker = Entities.FindByName(null, "Laser_Billy4_Maker")
      break;
    case 5:
      maker = Entities.FindByName(null, "Laser_Billy5_Maker")
      break;
  }
  maker.SpawnEntityAtLocation(ChopperPosLaser[i],ChopperPosLaserAng[i]);
  EntFire(Chopper[i], "StartForWard", "", 1, null)
  EntFire(ChopperAir[i], "StartForWard", "", 4.5, null)
  Chopper.remove(i);
  ChopperAir.remove(i);
  ChopperPos.remove(i);
  ChopperPosLaser.remove(i);
  ChopperPosLaserAng.remove(i);
}
Present <- false;
function GenesisPresent()
{
  if(RandomInt(0,1))GenLaserInChopper1()
  else GenLaserInChopper2()
}

function GenLaserInChopper1() {
  local timer = 0.57;
  local timer1 = 1.45;
  local i = RandomInt(0,ChopperPos.len()-1);
  Gen_Model.SetAngles(ChopperPos[i].x,ChopperPos[i].y,ChopperPos[i].z);
  EntFire("Billy_Laser_Sound", "PlaySound", "", timer, null)
  EntFireByHandle(Gen_Model,"SetAnimation",Gen_Attack,0.01,null,null)
  EntFireByHandle(self, "Runscriptcode", "BillyPickRandomLaserChopper("+i.tostring()+")", timer, null, null);
  BackGenChopper(timer1);
}

function GenLaserInChopper2() {
  local timer = 0.29;
  local timer1 = 1.5;
  local i = RandomInt(0,ChopperPos.len()-1);
  Gen_Model.SetAngles(ChopperPos[i].x,ChopperPos[i].y,ChopperPos[i].z);
  EntFire("Billy_Laser_Sound", "PlaySound", "", timer, null)
  EntFireByHandle(Gen_Model,"SetAnimation",Gen_Attack1,0.01,null,null)
  EntFireByHandle(self, "Runscriptcode", "BillyPickRandomLaserChopper("+i.tostring()+")", timer, null, null);
  BackGenChopper(timer1);
}

function BackGen(timer1)
{
  if(!ticking)return;
  EntFireByHandle(Gen_Model,"SetAnimation",Gen_Flying,timer1,null,null);
  EntFireByHandle(self,"RunScriptCode","StartGenesisFight();",timer1+0.3,null,null);
}

function GenLaserPick()
{
  if(!ticking)return;
  if(RandomInt(0,1))GenLaser1();
  else GenLaser2();
}

function GenLaser1() {
  local timer = 0.53;
  local timer1 = 1.35;
  EntFire("Billy_Laser_Sound", "PlaySound", "", timer, null)
  EntFireByHandle(Gen_Model,"SetAnimation",Gen_Flying_Attack,0,null,null)
  EntFireByHandle(self, "Runscriptcode", "BillyPickRandomLaser()", timer, null, null);
  BackGen(timer1);
}

function GenLaser2() {
  local timer = 0.48;
  local timer1 = 1.6;
  EntFire("Billy_Laser_Sound", "PlaySound", "", timer, null)
  EntFireByHandle(Gen_Model,"SetAnimation",Gen_Flying_Attack1,0,null,null)
  EntFireByHandle(self, "Runscriptcode", "BillyPickRandomLaser()", timer, null, null);
  BackGen(timer1);
}

function SubLaserBilly()
{
  if(ticking)
  {
    for(local i=0;i<=3;i++)
    EntFire("Billy_boy_health", "Subtract", "40", 0+(i/4), null);
  }
}

ticking <- false;
GenPath <- [
"Billy_main_path_001","Billy_main_path_002",
"Billy_main_path_003","Billy_main_path_005",
"Billy_main_path_006","Billy_main_path_007"];

lastpos <- "Billy_main_path_004";
function StartGenesisFight()
{
  if(!ticking)return;
  if(RandomInt(0,5)>=0)
  {
    local random = RandomInt(0,GenPath.len()-1);
    EntFire("Billy_train", "MoveToPathNode", GenPath[random], 0, null);
    EntFire(GenPath[random], "AddOutPut", "OnPass epic_vscripts:runscriptcode:GenLaserPick():0.1:1", 0, null)
    GenPath.push(lastpos)
    lastpos = GenPath[random];
    GenPath.remove(random);
  }
  else
  {
    EntFireByHandle(self,"RunScriptCode","GenLaserPick();",0.2,null,null);
  }
}

function GenesisDeath()
{
  ticking = false;
  EntFire("Billy_main_path_*", "ToggleAlternatePath", "", 0, null)
  EntFire("Billy_train", "MoveToPathNode", "Billy_death_path_001", 0.01, null)
  EntFire("Billy_train", "AddOutPut", "startspeed 800", 0, null)
  EntFireByHandle(Gen_Model,"SetAnimation",Gen_Dead,0,null,null)
}

g_Spawn <- [

];
TemplateList <- [
  "npc_bee_maker", //0
];

function SpawnRandomNPC(NPC_Handle,NPC_Max)
{
  if(g_Spawn.len()==0)return;
  local HandleTemplate = Entities.FindByName(null, TemplateList[NPC_Handle]);
  local spawn = g_Spawn.slice(0,g_Spawn.len());
  g_Spawn = [];
  if(debag)AllSpawn();
  for (local i=0; i<NPC_Max; i++)
  {
    local randomPos = RandomInt(0,spawn.len()-1);
    if(debag)ScriptPrintMessageChatAll("Random pos & ang :"+(spawn[randomPos].origin).tostring()+" : "+(spawn[randomPos].angles).tostring());
    HandleTemplate.SpawnEntityAtLocation((spawn[randomPos].origin),(spawn[randomPos].angles));
    if(NPC_Max - i < spawn.len())
    {
      spawn.remove(randomPos);
    }
  }
}

function AddPos(x,y,z,xa,ya,za)g_Spawn.push(FullPos(Vector(x,y,z),Vector(xa,ya,za)));
function AllSpawn()
{
  for (local i=0; i<=g_Spawn.len()-1; i++)
  ScriptPrintMessageChatAll("All location :"+g_Spawn[i]+" "+i+"/"+(g_Spawn.len()-1).tostring());
}

function StartChopper()
{
  if(caller==null||!caller.IsValid())return;
  local CA = caller.GetAngles();
  CA.x-=RandomInt(0,2);
  CA.y-=4;
  CA.z-=RandomInt(0,2);
  caller.SetAngles(CA.x,CA.y,CA.z);
  EntFireByHandle(self, "Runscriptcode", "StartChopper()", 0.05, caller, caller);
}



function SpawnCameras(o1, a1, time1, o2, a2, time2, flytime)
{
  local viewcontrol = Entities.CreateByClassname("point_viewcontrol_multiplayer");
  local viewtarget = Entities.CreateByClassname("info_target");
  viewcontrol.__KeyValueFromString("targetname", "viewcontrol");
  viewtarget.__KeyValueFromString("targetname", "viewtarget");
  viewtarget.SetAngles(a2.x, a2.y, a2.z);
  viewtarget.SetOrigin(o2);
  viewcontrol.SetAngles(a1.x, a1.y, a1.z);
  viewcontrol.SetOrigin(o1);
  viewcontrol.__KeyValueFromString("target_entity", "viewtarget");
  EntFireByHandle(viewcontrol, "Enable", "", 0, viewcontrol, viewcontrol);
  viewcontrol.__KeyValueFromFloat("interp_time", flytime);
  EntFireByHandle(viewcontrol, "StartMovement", "", 0.01 + time1, viewcontrol, viewcontrol);
  EntFireByHandle(viewcontrol, "Disable", "", time1+time2+flytime - 0.01, viewcontrol, viewcontrol);
  EntFireByHandle(viewcontrol, "Kill", "", time1+time2+flytime, viewcontrol, viewcontrol);
  EntFireByHandle(viewtarget, "Kill", "", time1+time2+flytime, viewtarget, viewtarget);
}
function MinusHp(i)
{
  local hp=activator.GetHealth()-i;
  if(hp<=0)EntFireByHandle(activator,"SetHealth","0",0.00,null,null);
  else  EntFireByHandle(activator,"SetHealth",hp.tostring(),0.00,null,null);
}

function test()
{
  local handle = null;
  local c = 0;
	while (null != (handle = Entities.FindByClassname(handle , "trigger_once")))
	{
		ScriptPrintMessageChatAll(c.tostring()+") "+handle.GetName()+" : "+handle.GetOrigin().x+" "+handle.GetOrigin().y+" "+handle.GetOrigin().z.tostring())
    //ScriptPrintMessageChatAll("Model : "+handle.GetModelName().tostring())
    ScriptPrintMessageChatAll("------------");
    c++;
	}
}
