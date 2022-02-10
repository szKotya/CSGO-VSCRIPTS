////////////////////////////////////////////////////////////////////
//Script by Kotya[STEAM_1:1:124348087]
//Put here scripts\vscripts\stripper\kotya\ze_lotr_minas_tirith_p5\
//update 08.06.2021
////////////////////////////////////////////////////////////////////
Alpha <- 120;
BackColor <- true;

function StartAlpha()
{
  AlphaTicker()
}

function AlphaTicker()
{
  if(self.IsValid() && self.GetMoveParent().GetMoveParent().GetOwner() != null)
  {
    local MaxAlpha = 140;
    local MinAlpha = 100;
    local TickAlpha = 20;
    if(Alpha<=MinAlpha){BackColor = false};
    if(Alpha>=MaxAlpha){BackColor = true};
    if((Alpha>MinAlpha) && (BackColor)) {EntFireByHandle(self,"Alpha",Alpha.tostring(),0.00,null,null);;Alpha-=TickAlpha};
    if((Alpha<MaxAlpha) && (!BackColor)) {EntFireByHandle(self,"Alpha",Alpha.tostring(),0.00,null,null);;Alpha+=TickAlpha};
    EntFireByHandle(self,"RunScriptCode", "AlphaTicker();",1.00, null, null);
  }
  else EntFireByHandle(self,"Alpha","200",0.00,null,null)
}