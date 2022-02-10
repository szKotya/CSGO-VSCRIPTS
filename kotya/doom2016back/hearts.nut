
MIN <- 8;
MAX <- 15;

mePos <- self.GetOrigin()+Vector(0,0,50);
n <- 150;
Origins <-
[
    mePos+Vector(n,n,0),
    mePos+Vector(-n,-n,0),
    mePos+Vector(-n,n,0),
    mePos+Vector(n,-n,0),
];

function Start()
{
    local Who = RandomInt(0,TemplateList.len()-1);
    local count = 3;
    local time = MIN;
    for (local i=0; i<Origins.len(); i++)
    {
        AddPos(Origins[i].x,Origins[i].y,Origins[i].z,0,0,0)
    }
    if(Who == 1)
    {
        count = 2;
        time = MAX;
    }
    EntFireByHandle(self, "RunScriptCode", "SpawnRandomNPC("+Who+","+count+");", 0.01, null, null);
    EntFireByHandle(self, "RunScriptCode", "Start();", time, null, null);
}
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
g_Spawn <- [

];
TemplateList <- [
  "maker_shkololo", //0
  "maker_pidars",
  "maker_kiborg",
];

function SpawnRandomNPC(NPC_Handle,NPC_Max)
{
    if(g_Spawn.len()==0)return;
    local HandleTemplate = Entities.FindByName(null, TemplateList[NPC_Handle]);
    local spawn = g_Spawn.slice(0,g_Spawn.len());
    g_Spawn = [];
    for (local i=0; i<NPC_Max; i++)
    {
        local randomPos = RandomInt(0,spawn.len()-1);
        HandleTemplate.SpawnEntityAtLocation((spawn[randomPos].origin),(spawn[randomPos].angles));
        if(NPC_Max - i < spawn.len())
        {
        spawn.remove(randomPos);
        }
    }
}

function AddPos(x,y,z,xa,ya,za)g_Spawn.push(FullPos(Vector(x,y,z),Vector(xa,ya,za)));