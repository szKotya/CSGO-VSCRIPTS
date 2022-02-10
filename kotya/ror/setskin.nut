model <- ["models/player/custom_player/kaesar/ghostface/ghostface.mdl", //last
"models/player/custom_player/kuristaja/pyramid_head/pyramid_head.mdl",  //second
"models/player/custom_player/darnias/hunk/hunk.mdl",
"models/player/custom_player/owston/narutoshippuden/sasuke/sasukewar.mdl", //hm
"models/player/custom_player/2020x/ump9_v1/tm_pirate.mdl",
"models/player/custom_player/arcaea/ifox/amiya.mdl",
"models/player/custom_player/possession/isa/neptunia/nextblackheart_attach_wing_v2.mdl"];

first <- false;
counter <- 0;
function OnPostSpawn()
{
  for (local i=0; i<model.len(); i++)
  {
    self.PrecacheModel(model[i]);
  }
  first = true;
}

function Plus() 
{
  if(!first)OnPostSpawn()
  if(counter+1 > model.len()-1)counter = 0
  else counter++
  Print();
}
function Minus() 
{
  if(!first)OnPostSpawn()
  if(counter-1 < 0)model.len()-1
  else counter--
  Print();
}

function SetSkin()
{
  if(!first)OnPostSpawn()
  if(caller.IsValid() && caller != 0 && caller.GetClassname() == "player" && caller.GetHealth() >0)
  {
    caller.SetModel(model[counter]);
  }
  else if (activator.IsValid() && activator != 0 && activator.GetClassname() == "player" && activator.GetHealth() >0)
  {
    activator.SetModel(model[counter]);
  }
  else ScriptPrintMessageCenterAll(">> >> ERROR << <<")
}

function Print() 
{
  local n = "";
  if(counter == 0)
  {
    n+= "\n"+model[0];
    n+= "\n"+model[1];
  }
  else if(counter == model.len()-1)
  {
    n+= "\n"+model.len()-2;
    n+= "\n"+model.len()-1;
  }
  else
  {
    n+= "\n"+model[counter-1];
    n+= "\n"+model[counter];
    n+= "\n"+model[counter+1];
  }
  ScriptPrintMessageCenterAll(n)
}