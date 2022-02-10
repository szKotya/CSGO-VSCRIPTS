boss_model <- null;
tick <- true;

function Start()
{
    BossCandidate();
    EntFireByHandle(self, "RunScriptCode", "StartCheck();", 5.00, null, null);
}

function BossCandidate()
{
	if(ReturnPlayerT() <= 0)
	{
		ScriptPrintMessageChatAll("No Zombies Alive");
		tick = false;
        EntFire("Counter_heal", "Subtract", "100000", 0.00, null);
	}
	local Fplzm = null;
	local Rn = 0;
	local num = RandomInt(1, ReturnPlayerT());
	while(null != (Fplzm = Entities.FindByClassname(Fplzm, "player")))
	{
		if(Fplzm.GetTeam() == 2 && Fplzm.GetHealth() > 0 && Fplzm.IsValid())
		{
			Rn++;
		    if(Rn >= num)
			{
                EntFireByHandle(Fplzm, "AddOutput", "origin 10621 5431 264.5", 0.05, Fplzm, Fplzm);
			    return;
			}
		}
	}
}

function ReturnPlayerT()
{
    local zmpl = null;
	local zmlc = 0;
	while(null != (zmpl = Entities.FindByClassname(zmpl, "player")))
	{
		if(zmpl.GetTeam() == 2 && zmpl.GetHealth() > 0 && zmpl.IsValid())
		{
			zmlc++;
		}
	}
	return zmlc;
}

function StartCheck()
{
    if(tick)
    {
        boss_model = Entities.FindByName(null, "Sofya");
        if(boss_model == null)
        {
            tick = false;
            EntFire("Counter_heal", "Subtract", "100000", 0.00, null);
        }
        EntFireByHandle(self, "RunScriptCode", "StartCheck()", 1.00, null, null);
    }
}

function BossDead()
{
	local pl_t = Entities.FindByName(null, "Sofya")
	if(pl_t != null && pl_t.IsValid() && pl_t.GetTeam() == 2)
	{
		EntFireByHandle(pl_t, "SetDamageFilter", "", 0.00, null, null);
		EntFireByHandle(pl_t, "AddOutput", "rendermode 0", 0.00, null, null);
		EntFire("Map_Speed", "ModifySpeed", "1", 0.00, pl_t);
		EntFireByHandle(pl_t, "SetHealth", "-1", 0.02, null, null);
	}
}