texture <- [];
texture1 <- [];

math <- null;
HP <- 60
function SetHandle()
{
    local ClassName = caller.GetClassname();
    local Name = caller.GetName();

    if(ClassName == "material_modify_control")
    {
        local sp_text = split(Name,"_");
        for (local i = 1; i <= sp_text[sp_text.len() - 1].tointeger(); i++)
        {
            local name = "";
            for(local a = 0; a < sp_text.len() - 1; a++)
            {
                //printl(name);
                name += sp_text[a];
                if(a < sp_text.len() - 1)
                {
                    name += "_";
                }
            }

            texture.push(Entities.FindByName(null, name + i));
        }

        texture.reverse();
        tick();
    }
    else
    {
        math = caller;
        EntFireByHandle(caller, "SetValue", ""+HP, 0, null, null);
    }
}

function SetTime()
{
    local Name = caller.GetName();
    local sp_text = split(Name,"_");

    for (local i = 1; i <= sp_text[sp_text.len() - 1].tointeger(); i++)
    {
        local name = "";
        for(local a = 0; a < sp_text.len() - 1; a++)
        {
            //printl(name);
            name += sp_text[a];
            if(a < sp_text.len() - 1)
            {
                name += "_";
            }
        }
        printl(name + i);
        texture1.push(Entities.FindByName(null, name + i));
        EntFire(name + i, "SetMaterialVar", "0", 0, null);
    }

    texture1.reverse();
}

FirstTime <- null;
LastTime <- null;
nTime <- null;

function StartTick1()
{
    FirstTime = Time();
    tick1()
}

function tick1()
{
    if(!math.IsValid())
    {
        LastTime = Time();
        ScriptPrintMessageChatAll((LastTime - FirstTime).tostring());
        return;
    }

    nTime = Time() - FirstTime;

    // EntFireByHandle(texture1[0], "SetMaterialVar", time % 1 + "", 0, null, null);
    // EntFireByHandle(texture1[1], "SetMaterialVar", time % 10 + "", 0, null, null);

    // EntFireByHandle(texture1[2], "SetMaterialVar", time % 10 + "", 0, null, null);
    // EntFireByHandle(texture1[3], "SetMaterialVar", time % 10 + "", 0, null, null);

    // EntFireByHandle(texture1[4], "SetMaterialVar", time % 10 + "", 0, null, null);
    // EntFireByHandle(texture1[5], "SetMaterialVar", time % 10 + "", 0, null, null);

    local min = (nTime / 60).tointeger();
    local sec = (nTime % 60).tointeger();

    local split = split(nTime.tostring(),".");
    local dsec = 0;
    if(split.len() >= 2)
    {
        dsec = split[1];
        if(dsec.len() > 1)
        {
            dsec = dsec.slice(0,2);
        }
    }

    local lim = 10;
	local temp_num = min.tointeger();

	for (local i = 4; i <= 5; i++)
	{
		local set = (temp_num % lim) + "";

        EntFireByHandle(texture1[i], "SetMaterialVar", set, 0, null, null);

		temp_num = temp_num / lim;
	}

    temp_num = sec.tointeger();

	for (local i = 2; i <= 3; i++)
	{
		local set = (temp_num % lim) + "";

        EntFireByHandle(texture1[i], "SetMaterialVar", set, 0, null, null);

		temp_num = temp_num / lim;
	}

    temp_num = dsec.tointeger();

	for (local i = 0; i <= 1; i++)
	{
		local set = (temp_num % lim) + "";

        EntFireByHandle(texture1[i], "SetMaterialVar", set, 0, null, null);

		temp_num = temp_num / lim;
	}

    EntFireByHandle(self, "RunScriptCode", "tick1()", 0.01, null, null);
}

function tick()
{
    printl("message");
    if(!math.IsValid())
        return;

    local lim = 10;
	local temp_num = HP--;

	for (local i = 0; i < texture.len(); i++)
	{
		local set = (temp_num % lim) + "";

        EntFireByHandle(texture[i], "SetMaterialVar", set, 0, null, null);

		temp_num = temp_num / lim;
	}
}

function dead()
{
    for (local i = 0; i < texture.len(); i++)
	{
        EntFireByHandle(texture[i], "SetMaterialVar", "0", 0, null, null);
    }
}