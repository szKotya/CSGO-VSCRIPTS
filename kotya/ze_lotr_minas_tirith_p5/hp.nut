////////////////////////////////////////////////////////////////////
//Script by Kotya[STEAM_1:1:124348087]
//Put here scripts\vscripts\stripper\kotya\ze_lotr_minas_tirith_p5\
//update 08.06
////////////////////////////////////////////////////////////////////
ShowHpWhite <- false;
ShowHpBalrog <- false;
ShowHpGandalf <- false;

AliveWhite <- false;
AliveBalrog <- false;
AliveGandalf <- false;

PickUpWhite <- false;
PickUpGandalf <- false;

HpWhite <- 0;
HpBalrog <- 0;
HpGandalf <- 0;

function PickUp(i)
{
  if(i==1)
  {
    AliveWhite = true;
    ShowHpWhite = true;
    PickUpWhite = true;
    GetHpWhite();
    if(!PickUpGandalf || !AliveGandalf)EntFireByHandle(self, "RunScriptCode", "ShopHpHuman()", 1.00, null, null);
  }

  if(i==2)
  {
    AliveGandalf = true;
    ShowHpGandalf = true;
    PickUpGandalf = true;
    GetHpGandalf();
    if(!PickUpWhite || !AliveWhite)EntFireByHandle(self, "RunScriptCode", "ShopHpHuman()", 1.00, null, null);
  }
  if(i==3)
  {
    AliveBalrog = true;
    ShowHpBalrog = true;
    GetHpBalrog();
    EntFireByHandle(self, "RunScriptCode", "ShopHpZombie()", 1.00, null, null);
  }
}

function GetHpWhite()
{
	local white = Entities.FindByName(null,"ph_item_goliath_2");
	if (white!=null && white.IsValid())
	{
		HpWhite = white.GetHealth();
	}
}

function GetHpBalrog()
{
	local balrog = Entities.FindByName(null,"ph_item_balrog_hp");
	if (balrog!=null && balrog.IsValid())
	{
    HpBalrog = balrog.GetHealth();
	}
}

function GetHpGandalf()
{
	local gandalf = Entities.FindByName(null,"ph_item_gandalf_15");
	if (gandalf!=null && gandalf.IsValid())
	{
    HpGandalf = gandalf.GetHealth();
	}
}

function ShopHpHuman()
{
  if(ShowHpWhite || ShowHpGandalf)
  {
    local Show = "";
    if(ShowHpWhite && ShowHpGandalf)
    {
      if(AliveGandalf && AliveWhite)Show = "White Knight HP : "+HpWhite.tostring()+"\nGandalf HP : "+HpGandalf.tostring();
      else if (!AliveWhite){Show = "White Knight HP : DEAD \nGandalf HP : "+HpGandalf.tostring();}
      else if (!AliveGandalf){Show = "White Knight HP : "+HpWhite.tostring()+" \nGandalf HP : DEAD";}
    }
    else if(ShowHpWhite)
    {
      if(AliveWhite)Show = "White Knight HP : "+HpWhite.tostring();
      else Show = "White Knight HP : DEAD"
    }
    else if(ShowHpGandalf)
    {
      if(AliveGandalf)Show = "Gandalf HP : "+HpGandalf.tostring();
      else Show = "Gandalf HP : DEAD";
    }
    ScriptPrintMessageCenterTeam(3,Show)
    EntFireByHandle(self, "RunScriptCode", "ShopHpHuman()", 1.00, null, null);
  }
}

function ShopHpZombie()
{
  if(ShowHpBalrog)
  {
    if(AliveBalrog)ScriptPrintMessageCenterTeam(2,"Balrog HP : "+HpBalrog);
    else ScriptPrintMessageCenterTeam(2,"Balrog HP : DEAD");
    EntFireByHandle(self, "RunScriptCode", "ShopHpZombie()", 1.00, null, null);
  }
}