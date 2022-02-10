model <- ["models/player/custom_player/kaesar/n4a/bp04012021/ghostface.mdl", //last
"models/player/custom_player/kuristaja/pyramid_head/pyramid_head.mdl",  //second
"models/player/custom_player/tlou/ventoz/azur_lane/prinz_eugen.mdl",
"models/player/custom_player/tlou/kuristaja/harry_potter/harry.mdl",
"models/player/custom_player/tlou/kuristaja/nanosuit/nanosuitv31.mdl",
];


counter <- 0;
self.ConnectOutput("OnUser1", "Plus")
self.ConnectOutput("OnUser2", "Minus")
function OnPostSpawn()
{
  if(model.len() < 3)
  {
    ScriptPrintMessageCenterAll(">> >> ERROR << <<");
    return;
  }
  for (local i=0; i<model.len(); i++)
  {
    self.PrecacheModel(model[i]);
  }
}

function Plus()
{
  if(counter+1 > model.len()-1)counter = 0;
  else counter++;
  Print();
}
function Minus()
{
  if(counter-1 < 0)counter = model.len()-1;
  else counter--;
  Print();
}

function SetSkin(i = -1)
{
  if(caller.IsValid() && caller != 0 && caller.GetClassname() == "player" && caller.GetHealth() >0)
  {
    if(i == -1)caller.SetModel(model[counter]);
    else if(i >=0 && i >= model.len()-1) caller.SetModel(model[i]);
    else ScriptPrintMessageCenterAll(">> >> ERROR << <<");
  }
  else if (activator.IsValid() && activator != 0 && activator.GetClassname() == "player" && activator.GetHealth() >0)
  {
    if(i == -1)activator.SetModel(model[counter]);
    else if(i >=0 && i >= model.len()-1) activator.SetModel(model[i]);
    else ScriptPrintMessageCenterAll(">> >> ERROR << <<");
  }
  else ScriptPrintMessageCenterAll(">> >> ERROR << <<");
}

function Print()
{
  local n = "";
  if(model.len() == 1)
  {
    local first = model[0];
    n+= "\n>>> "+ConvertString(first)+" <<<";
    n+= "\n==> "+ConvertString(first)+" <==";
    n+= "\n>>> "+ConvertString(first)+" <<<";
  }
  else if(model.len() == 2)
  {
    local first = model[0];
    local second = model[1];
    if(counter == 1)
    {
      n+= "\n>>> "+ConvertString(first)+" <<<";
      n+= "\n==> "+ConvertString(second)+" <==";
      n+= "\n>>> "+ConvertString(first)+" <<<";
    }
    else
    {
      n+= "\n>>> "+ConvertString(second)+" <<<";
      n+= "\n==> "+ConvertString(first)+" <==";
      n+= "\n>>> "+ConvertString(second)+" <<<";
    }
  }
  else if(counter == 0)
  {
    local first = model[model.len()-1];
    local second = model[0];
    local third = model[1];
    n+= "\n>>> "+ConvertString(first)+" <<<";
    n+= "\n==> "+ConvertString(second)+" <==";
    n+= "\n>>> "+ConvertString(third)+" <<<";
  }
  else if(counter == model.len()-1)
  {
    local first = model[model.len()-2];
    local second = model[model.len()-1];
    local third = model[0];
    n+= "\n>>> "+ConvertString(first)+" <<<";
    n+= "\n==> "+ConvertString(second)+" <==";
    n+= "\n>>> "+ConvertString(third)+" <<<";
  }
  else
  {
    local first = model[counter-1];
    local second = model[counter];
    local third = model[counter+1];
    n+= "\n>>> "+ConvertString(first)+" <<<";
    n+= "\n==> "+ConvertString(second)+" <==";
    n+= "\n>>> "+ConvertString(third)+" <<<";
  }
  ScriptPrintMessageCenterAll(n);
}

function PrintInfo()
{
  local n = "";
  if(caller.IsValid() && caller != 0 && caller.GetClassname() == "player" && caller.GetHealth() >0)
  {
    n = caller.GetModelName();
  }
  else if (activator.IsValid() && activator != 0 && activator.GetClassname() == "player" && activator.GetHealth() >0)
  {
    n = activator.GetModelName();
  }
  else
  {
    ScriptPrintMessageCenterAll(">> >> ERROR << <<");
    return;
  }
  ScriptPrintMessageChatAll(">>  >>  >>  >> Model path <<  <<  <<  <<");
  ScriptPrintMessageChatAll(n);
  ScriptPrintMessageChatAll("----------------------------------------------");
}

function ConvertString(String)
{
  local newString = split(String,"/");
  local LasString = newString[newString.len()-1];
  return LasString;
}
