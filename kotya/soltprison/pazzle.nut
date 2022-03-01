g_iSize <- 0;
g_AField <- [
    
]
g_AField_Need <- [

]
g_AOrigin <- [

]
g_bDone <- false;

g_hLast <- null;
g_hOwner <- null;

g_hGameUI <- Entities.CreateByClassname("game_ui");
g_hGameUI.__KeyValueFromInt("spawnflags", 480);
g_hGameUI.__KeyValueFromFloat("FieldOfView", -1.0);

EntFireByHandle(g_hGameUI, "AddOutPut", "PressedForward " + self.GetName() + ":RunScriptCode:MoveUp():0:-1", 0.01, null, null);
EntFireByHandle(g_hGameUI, "AddOutPut", "PressedBack " + self.GetName() + ":RunScriptCode:MoveDown():0:-1", 0.01, null, null);
EntFireByHandle(g_hGameUI, "AddOutPut", "PressedMoveLeft " + self.GetName() + ":RunScriptCode:MoveLeft():0:-1", 0.01, null, null);
EntFireByHandle(g_hGameUI, "AddOutPut", "PressedMoveRight " + self.GetName() + ":RunScriptCode:MoveRight():0:-1", 0.01, null, null);

g_iShaffle_Delay <- [50, 70];
g_iMoves <- 0;

function Press() 
{
    g_hOwner = activator;
    g_hOwner.SetOrigin(Vector(164, 241, 128));
    g_hOwner.SetAngles(0, -90, 0);

    g_bDone = false;

    g_AField.clear();
    g_AField_Need.clear();
    for (local i = 0; i < pow(g_iSize, 2); i++)
    {
        g_AField.push(Entities.FindByName(null, "puzzle_block_" + i));
        g_AField_Need.push(g_AField[i]);
        g_AField[i].SetOrigin(g_AOrigin[i]);
    }
    g_hLast = g_AField[g_AField.len() - 1];
    g_iMoves = RandomInt(g_iShaffle_Delay[0], g_iShaffle_Delay[1]);

    Shaffle();
}

function Init() 
{
    local hHandle = null;

    while ((hHandle = Entities.FindByName(null, "puzzle_block_" + g_iSize)) != null)
    {
        g_AOrigin.push(hHandle.GetOrigin());
        g_iSize++;
    }
    for (local i = 1; i < g_iSize; i++)
    {
        if ((g_iSize / i) == i)
        {
            g_iSize = i;
            break;
        }
    }
}

function Shaffle() 
{
    if (g_iMoves > 0)
    {
        local bResult = false;
        switch (RandomInt(0, 3))
        {
            case 0:
            {
                bResult = MoveUp();
                break;
            }
            case 1:
            {
                bResult = MoveDown();
                break;
            }
            case 2:
            {
                bResult = MoveRight();
                break;
            }
            case 3:
            {
                bResult = MoveLeft();
                break;
            }
        }

        if (bResult)
        {
            g_iMoves--
            EntFireByHandle(self, "RunScriptCode", "Shaffle();", 0.01, null, null);
        }
        else
        {
            Shaffle();
        }
    }
    else
    {
        EntFireByHandle(g_hGameUI, "Activate", "", 0.05, g_hOwner, g_hOwner);
    }
}

function Draw() 
{
    for (local i = 0; i < g_AField.len(); i++)
    {
        g_AField[i].SetOrigin(g_AOrigin[i]);
    }

    if (Check())
    {
        g_bDone = true;
        ScriptPrintMessageChatAll("GOOD");
    }

    return;
    ScriptPrintMessageChatAll("--- DRAW ---");
    local message = "";
    for (local i = 0; i < g_AField.len(); i++)
    {
        message += g_AField[i] + " ";
        if (i % g_iSize == g_iSize - 1)
        {
            ScriptPrintMessageChatAll(message + "\n");
            message = "";
        }
    }
    ScriptPrintMessageChatAll("--- END ---");
}

function MoveUp() 
{
    if (g_bDone)
    {
        return false;
    }
    local iX = GetId();
    if (iX < g_iSize)
    {
        ScriptPrintMessageChatAll("CAN'T MOVE");
        return false;
    }
    local iY = iX - g_iSize;

    local iTemp = g_AField[iY];
    g_AField[iY] = g_AField[iX];
    g_AField[iX] = iTemp;
    
    Draw();
    return true;
}

function MoveDown() 
{
    if (g_bDone)
    {
        return false;
    }
    local iX = GetId();

    if (iX >= pow(g_iSize, 2) - g_iSize)
    {
        ScriptPrintMessageChatAll("CAN'T MOVE");
        return false;
    }
    local iY = iX + g_iSize;

    local iTemp = g_AField[iY];
    g_AField[iY] = g_AField[iX];
    g_AField[iX] = iTemp;
    
    Draw();  
    return true;
}

function MoveRight() 
{
    if (g_bDone)
    {
        return false;
    }
    local iX = GetId();
    
    if (iX % g_iSize == g_iSize - 1)
    {
        ScriptPrintMessageChatAll("CAN'T MOVE");
        return false;
    }
    local iY = iX + 1;

    local iTemp = g_AField[iY];
    g_AField[iY] = g_AField[iX];
    g_AField[iX] = iTemp;
    
    Draw();
    return true;
}

function MoveLeft() 
{
    if (g_bDone)
    {
        return false;
    }
    local iX = GetId();
    
    if (iX % g_iSize == 0)
    {
        ScriptPrintMessageChatAll("CAN'T MOVE");
        return false;
    }
    local iY = iX - 1;

    local iTemp = g_AField[iY];
    g_AField[iY] = g_AField[iX];
    g_AField[iX] = iTemp;
    
    Draw();
    return true;
}

function GetId() 
{
    foreach (index, item in g_AField) 
    {
        if (item == g_hLast)  
        {
            return index;
        }
    }
}

function Check() 
{
    if (g_iMoves <= 0)
    {
        for (local i = 0; i < g_AField_Need.len(); i++)
        {
            if (g_AField[i] != g_AField_Need[i])
            {
                return false;
            }
        }
        return true;
    }
    return false;
}

Init();