Show <- false;
hp <- 0;
HpBase <- 300; //базовое хп
HpAdd <- 300; //Хп за кт
dis <- 2000; //детект кт в радиусе
//формула хп HpBase + кол-во кт в радиусе 2000 * HpAdd)
dontTakehp <-true;


function GetHp()if (self!=null && self.IsValid())hp = self.GetHealth();

function Start()
{
  Show = true;
  FirstTakeDamage()
  EntFireByHandle(self, "RunScriptCode", "ShowHud()", 0.01, null, null);
}

function ShowHud() 
{
  local Showtxt = "WALL HP : Break";
  if(Show) Showtxt = "WALL HP : "+hp;
  ScriptPrintMessageCenterTeam(3,Showtxt);
  EntFireByHandle(self, "RunScriptCode", "ShowHud()", 0.05, null, null);
}

function FirstTakeDamage()
{
	if(dontTakehp)
	{
		local Counter = 0;
		local ct = null;
		while(null!=(ct=Entities.FindInSphere(ct,self.GetOrigin(),dis)))
		{
      if(ct.GetClassname() == "player" && ct.GetTeam() == 3 && ct.GetHealth() > 0)Counter++;
    }
		dontTakehp = false;
		EntFireByHandle(self,"SetHealth",(HpBase + Counter * HpAdd).tostring(),0.00,null,null);
	}		
}

