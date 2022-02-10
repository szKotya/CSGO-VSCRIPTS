function KnifeModStrip()
{
	local p = null;
	while(null != (p = Entities.FindByClassname(p,"player")))
	{
    if (p.GetHealth()!=0)
    {
      EntFire("stripper_strip", "Strip", "", 0, p);
      EntFire("stripper_knife", "Use", "", 0.1, p);
    }
	}	
}

allowitem <- ["magia_rayo","magia_gravedad"];

function NoItem()
{
	local i = null;
	while(null != (i = Entities.FindByClassname(i,"weapon_*")))
	{
        local iname = i.GetName();
        if(iname!="")
        {
            for(local A == 0; A < allowitem.len(); A++)
            {
                if(iname.find(allowitem[A]) != 0)
                {
                    EntFireByHandle(i, "KillHierarchy", "", 0, null, null);
                }
            }
        }
	}	
}