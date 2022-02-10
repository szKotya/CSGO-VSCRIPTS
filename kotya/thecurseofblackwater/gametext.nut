
////////////////////////////////////////////////////////////////////
//Script by Kotya[STEAM_1:1:124348087]
//update 28.06 version 0.95
////////////////////////////////////////////////////////////////////
show <- false;

needFind <- 0;
youHave <- 0;

whatFind <- 0;
whatFindText <- ["crowbar", //0 = crowbar
"keycard",                  //1 = keycard
"key",                 //2 = key
"casket",             //3 = casket
"lever",             //4 = lever
"chemical",          //5 = chemical
"meat",             //6 = meat
"pot",             //7 = pot
"drill",             //8 = drill
"barrel",             //9 = barrel
"button"];             //10 = button
//                                      
function StartShow(i,Cheiscat) //что искать смотри выше = 0,1,2 можно добавлять свое 
{
  if(!show)
  {
    needFind = i;
    youHave = 0;
    whatFind = Cheiscat;
    show = true;
    EntFireByHandle(self, "SetText", "Find the "+whatFindText[whatFind]+" "+youHave+"/"+needFind, 0.00, null, null);
    EntFireByHandle(self, "display", "", 0.10, null, null);
    EntFireByHandle(self, "RunScriptCode", "ShowText()", 1.00, null, null);
  }
}


function EndShow()
{
  if(show)
  {
    EntFireByHandle(self, "RunScriptCode", "show = false", 2.00, null, null);
  }
}

function FindKey()
{
  if(youHave < needFind)
  {
    youHave++;
    EntFireByHandle(self, "SetText", "Find the "+whatFindText[whatFind]+" "+youHave+"/"+needFind, 0.00, null, null);
    EntFireByHandle(self, "display", "", 0.10, null, null);
    if(youHave >= needFind)EndShow()
  }
}

function ShowText()
{
  if(show)
  {
    EntFireByHandle(self, "display", "", 0.10, null, null);
    EntFireByHandle(self, "RunScriptCode", "ShowText()", 1.00, null, null);
  }
}