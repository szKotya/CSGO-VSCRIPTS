g_fShow_Dead <- 3.0;
g_fTickrate <- 0.5;

g_aShowHP_CT <- [];
g_aShowHP_T <- [];

::g_sDog <- "Dog";
::g_sGendalf <- "Gendalf"
class class_showHP
{
    name = "";
    handle = null;
    stopcheck = false;

    constructor(handle_, name_)
    {
        this.handle = handle_;
        this.name = name_;
    }

    function GetName() 
    {
        return this.name;    
    }

    function GetHeath() 
    {
        if(this.handle.IsValid())
            return this.handle.GetHealth().tostring();
        return "Dead";
    }
}

function AddShowHP(team, name) 
{
    if(team == 2)
    {
        g_aShowHP_T.push(class_showHP(caller, name))
    }
    else if(team == 3)
    {
        g_aShowHP_CT.push(class_showHP(caller, name))
    }

    if((g_aShowHP_CT.len() == 1 && g_aShowHP_T.len() == 0) ||
        g_aShowHP_CT.len() == 0 && g_aShowHP_T.len() == 1)
        ShowHP();
}

function ShowHP() 
{
    if(g_aShowHP_CT.len() <= 0 && g_aShowHP_T.len() <= 0)
        return;
    
    local hp = null;
    local name = ""

    local text = "";

    if(g_aShowHP_CT.len() > 0)
    {
        text = "";
        for(local i = 0; i < g_aShowHP_CT.len(); i++)
        {
            hp = g_aShowHP_CT[i].GetHeath();
            name = g_aShowHP_CT[i].GetName();

            if(hp == "Dead" && !g_aShowHP_CT[i].stopcheck)
                RemoveID(g_aShowHP_CT[i]);
            text += name + " : " + hp;

            if(i <= g_aShowHP_CT.len())
                text += "\n"
        }
        ScriptPrintMessageCenterTeam(3, text);
    }
    if(g_aShowHP_T.len() > 0)
    {
        text = "";

        for(local i = 0; i < g_aShowHP_T.len(); i++)
        {
            hp = g_aShowHP_T[i].GetHeath();
            name = g_aShowHP_T[i].GetName();

            if(hp == "Dead" && !g_aShowHP_T[i].stopcheck)
                RemoveID(g_aShowHP_T[i]);
            text += name + " : " + hp;

            if(i <= g_aShowHP_T.len())
                text += "\n"
        }
        ScriptPrintMessageCenterTeam(2, text);
    }

    EntFireByHandle(self, "RunScriptCode", "ShowHP()", g_fTickrate, null, null);
}

g_aDelete_Class <- [];
g_aDelete_Time <- [];
function RemoveID(class_showHP_obj) 
{
    class_showHP_obj.stopcheck = true;
    g_aDelete_Class.push(class_showHP_obj);
    g_aDelete_Time.push(Time());
    EntFireByHandle(self, "RunScriptCode", "RemoveIDNext()", g_fShow_Dead, null, null);
}

function RemoveIDNext() 
{
    for(local a = 0; a < g_aDelete_Class.len(); a++)
    {
        if(g_aDelete_Time[a] + g_fShow_Dead < Time())
            continue;

        for(local i = 0; i < g_aShowHP_CT.len(); i++)
        {
            if(g_aShowHP_CT[i] == g_aDelete_Class[a])
            {
                g_aDelete_Time.remove(a);
                g_aDelete_Class.remove(a);
                g_aShowHP_CT.remove(i);
                return;
            }
        }

        for(local i = 0; i < g_aShowHP_T.len(); i++)
        {
            if(g_aShowHP_T[i] == g_aDelete_Class[a])
            {
                g_aDelete_Time.remove(a);
                g_aDelete_Class.remove(a);
                g_aShowHP_T.remove(i);
                return;
            }
        }
    }
}