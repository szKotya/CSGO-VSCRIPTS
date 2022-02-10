menuPointer <- 0;
menuSelect  <- -1;

TriggersName <- ["once",
"multiple",
"hurt",
"teleport"
"other triggers"];

MenuOptionName <- [
"Show Box[ALL]",
"Hide Box[ALL]",
"Show Box[BIG]",
"Hide Box[BIG]",
"Print All info"

"Back"
];

self.ConnectOutput("OnUser1", "Plus")
self.ConnectOutput("OnUser2", "Minus")
self.ConnectOutput("OnUser3", "Enter")

EntFireByHandle(self, "RunScriptCode", "Start()", 0.1, null, null);
function Start()
{
    local handle = null;
    while(null != (handle = Entities.FindByClassname(handle,"trigger_*")))
    {
        EntFireByHandle(handle, "RunScriptFile", "triggerhook", 0, null, null);
    }
}

function Plus()
{
    if(menuSelect == -1)
    {
        if(menuPointer+1 > TriggersName.len()-1)menuPointer = 0;
        else menuPointer++;
    }
    else
    {
        if(menuPointer+1 > MenuOptionName.len()-1)menuPointer = 0;
        else menuPointer++;
    }
    Print();
}

function Minus()
{
    if(menuSelect == -1)
    {
        if(menuPointer-1 < 0)menuPointer = TriggersName.len()-1;
        else menuPointer--;
    }
    else
    {
        if(menuPointer-1 < 0)menuPointer = MenuOptionName.len()-1;
        else menuPointer--;
    }
    Print();
}

function Enter()
{
    if(menuSelect == -1)
    {
        menuSelect = menuPointer;
        menuPointer = 0
    }
    else
    {
        if(menuPointer == MenuOptionName.len()-1)
        {
            menuSelect = -1;
            menuPointer = 0;
        }
        else
        {
            switch (menuPointer)
            {
                case 0:
                {
                    AllEnable(menuSelect)
                    break;
                }
                case 1:
                {
                    AllDisable(menuSelect)
                    break;
                }
                case 2:
                {
                    Enable(menuSelect)
                    break;
                }
                case 3:
                {
                    Disable(menuSelect)
                    break;
                }
                case 4:
                {
                    PrintInfo(menuSelect)
                    break;
                }
            }
        }
    }
    Print();
}

function Print()
{
    local n = "";
    if(menuSelect == -1)
    {
        n += "Main menu: ";
        for (local i=0; i<TriggersName.len(); i++)
        {
            if(i == menuPointer) n += "\n["+(i+1).tostring()+"]";
            else n += "\n"+(i+1).tostring();
            n += " "+TriggersName[i];
        }
    }
    else
    {
        if(menuSelect >= 0 && menuSelect <= 4)n += "trigger_"+TriggersName[menuSelect];
        else n += "Other";
        n += " menu: ";
        for (local i=0; i<MenuOptionName.len(); i++)
        {
            if(i == menuPointer) n += "\n["+(i+1).tostring()+"]";
            else n += "\n"+(i+1).tostring();
            n += " "+MenuOptionName[i];
        }
    }

    ScriptPrintMessageCenterAll(n);
}

function PrintInfo(i)
{
    if(i != TriggersName.len()-1)EntFire("trigger_"+TriggersName[i], "RunScriptCode", "PrintInfo(false);", 0, null)
    else
    {
        local handle = null;
        while(null != (handle = Entities.FindByClassname(handle,"trigger_*")))
        {
            if(handle.GetClassname() != "trigger_once" &&
            handle.GetClassname() != "trigger_teleport" &&
            handle.GetClassname() != "trigger_hurt" &&
            handle.GetClassname() != "trigger_multiple")
            EntFireByHandle(handle, "RunScriptCode", "PrintInfo(false);", 0, null, null);
        }
    }
}

function AllDisable(i)
{
    if(i != TriggersName.len()-1)EntFire("trigger_"+TriggersName[i], "RunScriptCode", "SPAWN = false;", 0, null)
    else
    {
        local handle = null;
        while(null != (handle = Entities.FindByClassname(handle,"trigger_*")))
        {
            if(handle.GetClassname() != "trigger_once" &&
            handle.GetClassname() != "trigger_teleport" &&
            handle.GetClassname() != "trigger_hurt" &&
            handle.GetClassname() != "trigger_multiple")
            EntFireByHandle(handle, "RunScriptCode", "SPAWN = false;", 0, null, null);
        }
    }
}

function AllEnable(i)
{
    if(i != TriggersName.len()-1)EntFire("trigger_"+TriggersName[i], "RunScriptCode", "SPAWN = true;", 0, null)
    else
    {
        local handle = null;
        while(null != (handle = Entities.FindByClassname(handle,"trigger_*")))
        {
            if(handle.GetClassname() != "trigger_once" &&
            handle.GetClassname() != "trigger_teleport" &&
            handle.GetClassname() != "trigger_hurt" &&
            handle.GetClassname() != "trigger_multiple")
            EntFireByHandle(handle, "RunScriptCode", "SPAWN = true;", 0, null, null);
        }
    }
}

function Disable(i)
{

    local name = "trigger_"
    if(i != TriggersName.len()-1)name += TriggersName[i];
    else name += "*";

    printl(name);
    local handle = null;
    while(null != (handle = Entities.FindByClassname(handle,name)))
    {
        if(name == "trigger_*")
        {
            if(handle.GetClassname() != "trigger_once" &&
            handle.GetClassname() != "trigger_teleport" &&
            handle.GetClassname() != "trigger_hurt" &&
            handle.GetClassname() != "trigger_multiple")
            if(handle.GetBoundingMaxs().x * 2 + handle.GetBoundingMaxs().y * 2 + handle.GetBoundingMaxs().z * 2 >= 2048)
            EntFireByHandle(handle, "RunScriptCode", "SPAWN = false;", 0, null, null);
        }
        else
        {
            if(handle.GetBoundingMaxs().x * 2 + handle.GetBoundingMaxs().y * 2 + handle.GetBoundingMaxs().z * 2 >= 2048)
            EntFireByHandle(handle, "RunScriptCode", "SPAWN = false;", 0, null, null);
        }
    }
}


function Enable(i)
{
    local name = "trigger_"
    if(i != TriggersName.len()-1)name += TriggersName[i];
    else name += "*";

    local handle = null;
    while(null != (handle = Entities.FindByClassname(handle,name)))
    {
        if(name == "trigger_*")
        {
            if(handle.GetClassname() != "trigger_once" &&
            handle.GetClassname() != "trigger_teleport" &&
            handle.GetClassname() != "trigger_hurt" &&
            handle.GetClassname() != "trigger_multiple")
            if(handle.GetBoundingMaxs().x * 2 + handle.GetBoundingMaxs().y * 2 + handle.GetBoundingMaxs().z * 2 >= 2048)
            EntFireByHandle(handle, "RunScriptCode", "SPAWN = true;", 0, null, null);
        }
        else
        {
            if(handle.GetBoundingMaxs().x * 2 + handle.GetBoundingMaxs().y * 2 + handle.GetBoundingMaxs().z * 2 >= 2048)
            EntFireByHandle(handle, "RunScriptCode", "SPAWN = true;", 0, null, null);
        }
    }
}