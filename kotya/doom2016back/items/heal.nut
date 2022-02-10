IncludeScript("kotya/doom2016/support/items.nut");
IncludeScript("kotya/doom2016/support/math.nut");

Ticking <- false;
TICKRATE <- 0.1;
Limit_dist <- 50;
//////////////////////
//   Handle block   //
//////////////////////
Owner   <- null;
Model   <- null;
Text   <- null;

Heal_CD <- 50;
Heal_CAN <- true;
Heal_HPMAX <- 200;
Heal_HPTICK <- 5;
HealTick <- 0;

Center_T <- null;
Center_M <- null;

function SetHandle()
{
    local name = caller.GetName();
    if(caller.GetClassname() == "prop_dynamic_glow")Model = caller;
    if(caller.GetClassname() == "game_text")
    {
        Text = caller;
        //Ammo = AmmoBackPack;
    }
    if(name.find("item_plasma_center_move") == 0)Center_M = caller;
    if(name.find("item_plasma_distance") == 0)Center_T = caller;
}

//////////////////////
//    Main Block    //
//////////////////////
function filter()
{
    if(self.GetMoveParent().GetMoveParent() == activator && Heal_CAN)
    {
        Heal_CAN = false;
        HealTick = 0;
        HealAll(Heal_HPMAX,256);
        EntFireByHandle(self, "RunScriptCode", "Heal_CAN = true;", Heal_CD, null, null);
    }
}

function Pick()
{
    Owner = activator;
    Ticking = true;
    EntFireByHandle(Text, "Display", "",0, Owner, Owner);
}

function Tick()
{
    if(Owner == null)return;
    if(Heal_CAN)
    {
        if(HealTick >= 10)
        {
            HealTick = 0;
            HealAll(Heal_HPTICK,128);
        }
        else HealTick += TICKRATE;
    }

    if(Ticking)
    {
        if(CheakItem())
        {
            if(GetDistance(Owner.GetOrigin(),Center_T.GetOrigin()) > Limit_dist || Owner.GetHealth() <= 0)
            {
                EntFireByHandle(Center_M, "ClearParent", "", 0.00, Owner, Owner);
                Owner = null;
                Ticking = false;
                SetPosM();
            }
        }
    }
    EntFireByHandle(self, "RunScriptCode", "Tick();", TICKRATE, null, null);
}
function HealAll(HP,RAD)
{
	local h = null;
	while(null!=(h=Entities.FindInSphere(h,self.GetOrigin(),RAD)))
	{
		if(h.GetClassname()=="player" && h.GetTeam()==3 && h.GetHealth()>0)
		{
			local hp = h.GetHealth()+HP;
            if(hp >= Heal_HPMAX)
            {
                hp = Heal_HPMAX;
            }
            h.SetHealth(hp);
		}
	}
}
