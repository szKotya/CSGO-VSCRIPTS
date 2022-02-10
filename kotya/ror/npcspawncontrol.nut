////////////////////////////////////////
//Script by Kotya[STEAM_1:1:124348087]//
///////update 02.09 version 0.8b////////
////////////////////////////////////////
debag <- false;

g_Spawn <- [

];
TemplateList <- [
  "Maker_decayed", //0
  "Maker_pincher",    //1
  "Maker_creepygirl",    //2
];

function SpawnRandomNPC(NPC_Handle,NPC_Max) 
{ 
  if(g_Spawn.len()==0)return; 
  local HandleTemplate = Entities.FindByName(null, TemplateList[NPC_Handle]);
  local spawn = g_Spawn.slice(0,g_Spawn.len());
  if(debag)AllSpawn();
  for (local i=0; i<NPC_Max; i++)
  {
    local randomPos = RandomInt(0,spawn.len()-1);
    if(debag)ScriptPrintMessageChatAll("Random pos :"+spawn[randomPos].tostring());
    HandleTemplate.SpawnEntityAtLocation(spawn[randomPos],Vector(0,0,0));
    //EntFireByHandle(HandleTemplate, "addoutput", "origin "+spawn[randomPos].x+" "+spawn[randomPos].y+" "+spawn[randomPos].z, timertospawn, null, null)
    //EntFireByHandle(HandleTemplate, "forcespawn", " ", timertospawn+0.1, null, null)
    if(NPC_Max - i < spawn.len())
    {
      spawn.remove(randomPos);
    }
  }
  g_Spawn = [];
}

function AddPos(x,y,z)
{
  local pos = Vector(x,y,z);
  g_Spawn.push(pos);
}

function AllSpawn()
{
  for (local i=0; i<=g_Spawn.len()-1; i++)
  ScriptPrintMessageChatAll("All location :"+g_Spawn[i]+" "+i+"/"+(g_Spawn.len()-1).tostring());
}

