IncludeScript("kotya/doom2016/items/support/items.nut");
IncludeScript("kotya/doom2016/support/math.nut");
IncludeScript("kotya/doom2016/support/models.nut");
Ticking <- false;
TICKRATE <- 0.5;

//////////////////////
//   Handle block   //
//////////////////////
Model   <- null;
Effect   <- null;
Sound  <- null;

Heal_CD <- 50;
Heal_CAN <- true;
Heal_HPMAX <- 200;
Heal_HPTICK <- 5;
HealTick <- 0;


function SetHandle()
{
    local name = caller.GetName();
    if(caller.GetClassname() == "prop_dynamic_glow")Model = caller;
    if(caller.GetClassname() == "ambient_generic")Sound = caller;
    if(caller.GetClassname() == "info_particle_system")Effect = caller;
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
        EntFireByHandle(Effect, "Start", "",0, null, null);
        EntFireByHandle(Effect, "Stop", "",2, null, null);
        EntFireByHandle(self, "RunScriptCode", "Heal_CAN = true;", Heal_CD, null, null);
		PlayNewSound(Sound,s_heal,0.00);
    }
}

function Pick()
{
    Ticking = true;
	PlayNewSound(Sound,s_pickedup,0.00);
}

function Tick()
{
    if(Heal_CAN)
    {
        if(HealTick >= 10)
        {
            HealTick = 0;
            HealAll(Heal_HPTICK,128);
        }
        else HealTick += TICKRATE;
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

SoundPath   <-  "*doom2016\\items\\hm\\heal\\";
s_pickedup  <-  SoundPath+"pickedup";
s_heal  <-  SoundPath+"heal";