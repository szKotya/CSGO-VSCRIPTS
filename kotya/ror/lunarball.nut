Counter<-2;
Circle<-3;
function OnPostSpawn()EntFireByHandle(self,"StartForWard","",0.00,null,null);
function Check()
{
  if(Counter<Circle)
  {
    DebugDrawLine(self.GetOrigin()+Vector(0,0,50), self.GetOrigin()+Vector(0,0,-50), 255, 255, 255, true, 1)
    Counter++
  }
  else
  {
    EntFireByHandle(caller,"addoutput","OnPass !activator:kill::0.1:1",0.00,null,null);
    EntFireByHandle(caller,"addoutput","OnPass !self:FireUser1::0.6:1",0.00,null,null);
  }
}