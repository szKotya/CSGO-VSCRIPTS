::g_hTeleport_Manager <- self;
::g_hArray_Teleport <- [];
g_hReset <- null;
g_tdGlobal <- null;

class class_teleport_destination
{
    pTeleport = null;

    bSaveVelocity = false;
    iRemoveCount = -1;
    bRandom = false;

    iCount = -1;

    pTeleportSave = null;
    pLast = null;

    constructor(_pTeleport, _iRemoveCount = -1, _bRandom = true, _bSaveVelocity = false)
    {
        
        this.bRandom = _bRandom;
        this.bSaveVelocity = _bSaveVelocity;
        this.iRemoveCount = _iRemoveCount;

        if (typeof _pTeleport == "array")
        {
            this.pTeleport = _pTeleport.slice();

            if (this.bRandom)
            {
                this.pTeleportSave = _pTeleport.slice();
            }
        }
        else
        {
            this.pTeleport = _pTeleport;
        }
    }

    function GetLocation() 
    {   
        local TP;
        if (typeof this.pTeleport == "array")
        {
            if (this.bRandom)
            {
                if (this.pTeleport.len() < 1)
                {
                    this.pTeleport = this.pTeleportSave.slice();
                }

                while (true)
                {
                    this.iCount = RandomInt(0, this.pTeleport.len() - 1);
                    TP = this.pTeleport[this.iCount];

                    if (this.pLast != TP)
                    {
                        break;
                    }
                }
                
                this.pTeleport.remove(this.iCount);
            }
            else
            {
                this.iCount = ((this.iCount++ >= this.pTeleport.len() - 1) ? (this.iCount = 0) : this.iCount)
                TP = this.pTeleport[iCount];
            }
        }
        else
        {
            TP = this.pTeleport;
        }

        this.pLast = TP;

        if (this.iRemoveCount > 0)
        {
            this.iRemoveCount--;
        }

        return TP;
    }

    function CheckRemove() 
    {
        if (this.iRemoveCount == 0)
        {
            return true;
        }
        return false;    
    }
}

/*

    0 - Телепорт всех кто не проходил тригер
    1 - Телепорт всех кто прошел тригер
    2 - Телепорт всех кто вышел за тригер

*/

class class_teleport_trigger
{
    hHandle = null;
    pTeleport = null;
    hPlayers = null;
    vSide = null;
    iMode = null;

    bEnable = false;

    constructor(_hHandle, _pTeleport, _vSide = Vector(0, 0, 0), _iMode = 0)
    {
        this.hHandle = _hHandle;
        this.pTeleport = _pTeleport;
        this.vSide = _vSide;
        // if (VectorEqul(this.vSide, Vector(0, 0, 0)))
        this.iMode = _iMode;
        // else
        //     this.iMode = _iMode;

        this.hPlayers = [];
    }

    function Enable() 
    {
        this.bEnable = true;
        if(this.iMode == 0 || this.iMode == 2)
        {
            for (local i = 0, player, ID; i < PLAYERS.len(); i++)
            {
                player = PLAYERS[i].handle;
                ID = this.GetPlayer(player);
                if (ID != -1)
                    continue;

                if (this.iMode == 2)
                    this.hPlayers.push(player);

                if (ValidTarget(player))
                {
                    this.TeleportPlayer(player);
                }
            }
        }
        else if (this.iMode == 1)
        {
            for (local i = 0, player; i < hPlayers.len(); i++)
            {
                player = hPlayers[i];
                if (ValidTarget(player))
                {
                    this.TeleportPlayer(player);
                }
            }
        }

        if (this.iMode != 2)
            hPlayers.clear();
    }

    function TeleportPlayer(player) 
    {
        if (!(this.pTeleport.bSaveVelocity))
            player.SetVelocity(Vector(0, 0, 0));
        local TP = this.pTeleport.GetLocation();
        player.SetOrigin(TP.origin);
        player.SetAngles(TP.ax, TP.ay, TP.az);

        if (this.pTeleport.CheckRemove())
        {
            CheckRemoveTeleports(this.pTeleport);
        }
    }

    function Disable() 
    {
        this.bEnable = false;
    }

    function CheckPush(hHandle) 
    {
        if (bEnable)
            return; 

        local vVecocity = hHandle.GetVelocity();
        if (this.vSide.x == 1)
        {
            if (vVecocity.x < 0)
            {
                return GetPlayer(hHandle, true);
            }
        }
        else if (this.vSide.x == -1)
        {
            if (vVecocity.x > 0)
            {
                return GetPlayer(hHandle, true);
            }
        }

        if (this.vSide.y == 1)
        {
            if (vVecocity.y < 0)
            {
                return GetPlayer(hHandle, true);
            }
        }
        else if (this.vSide.y == -1)
        {
            if (vVecocity.y > 0)
            {
                return GetPlayer(hHandle, true);
            }
        }

        if (this.vSide.z == 1)
        {
            if (vVecocity.z < 0)
            {
                return GetPlayer(hHandle, true);
            }
        }
        else if (this.vSide.z == -1)
        {
            if (vVecocity.z > 0)
            {
                return GetPlayer(hHandle, true);
            }
        }

        this.hPlayers.push(hHandle);
    }

    function GetPlayer(ID, bDelete = false) 
    {
        for (local i = 0; i < hPlayers.len(); i++)
        {
            if (ID == hPlayers[i])
            {
                local hSave = hPlayers[i];
                
                if (bDelete)
                    hPlayers.remove(i);

                return hSave;
            }
        }
        return -1;
    }
}

function Init() 
{
    //RegTeleport(Vector(-112, -32, 256), Vector(48, 32, 192), class_pos(Vector(136, -257, 128), Vector(5, 34, 0)), Vector(0, -1, 0));
    local pTP = [];

    pTP.push(class_pos(Vector(431, -80, 128), Vector(5, -148, 0)));
    pTP.push(class_pos(Vector(-143, -431, 128), Vector(5, 31, 0)));
    pTP.push(class_pos(Vector(431, -431, 128), Vector(4, 143, 0)));
    pTP.push(class_pos(Vector(184, -431, 128), Vector(3, 91, 0)));
    pTP.push(class_pos(Vector(132, -80, 128), Vector(1, -90, 0)));
    pTP.push(class_pos(Vector(-143, -268, 128), Vector(0, 3, 0)));
    pTP.push(class_pos(Vector(431, -255, 128), Vector(-0, 177, 0)));
    
    local testTP = RegTeleportDes(pTP);
    g_tdGlobal = testTP;
    RegTeleport(Vector(-160, 416, 256), Vector(32, 32, 192), g_tdGlobal, Vector(0, 0, 0), 1, true);
    g_hReset.Enable();

    RegTeleport(Vector(-112, -32, 256), Vector(48, 32, 192), testTP, Vector(0, -1, 0), 0);

    RegTeleport(Vector(-112, -32, 256), Vector(48, 32, 192), RegTeleportDes(class_pos(Vector(-289, 67, 128), Vector(0, -2, 0))), Vector(0, -1, 0), 0);

    RegTeleport(Vector(0, 0, 0), Vector(48, 32, 192), testTP, Vector(0, -1, 0), 0);
}

function RegTeleport(vOrigin, vSize, vLoc, vSide, iMode = 0, bReset = false) 
{
    local triggerTP = CreateTrigger(vOrigin, type_teleport_trigger);
    triggerTP.SetSize(vinv(vSize), vSize);
    triggerTP.SetOrigin(vOrigin);
 
    g_hArray_Teleport.push(class_teleport_trigger(triggerTP, vLoc, vSide, iMode));
    
    if (bReset)
    {
        g_hReset = g_hArray_Teleport[g_hArray_Teleport.len() -1];
        EntFireByHandle(triggerTP, "AddOutPut", "OnStartTouch " + self.GetName() + ":RunScriptCode:Reset():0:-1", 0, null, null);
    }

    EntFireByHandle(triggerTP, "Enable", "", 0.01, null, null);
    EntFireByHandle(triggerTP, "AddOutPut", "OnStartTouch " + self.GetName() + ":RunScriptCode:StartTouch():0:-1", 0, null, null);
    EntFireByHandle(triggerTP, "AddOutPut", "OnEndTouch " + self.GetName() + ":RunScriptCode:EndTouch():0:-1", 0, null, null);    
}

function RegTeleportDes(pTeleport, iRemoveCount = -1, bRandom = true, bSaveVelocity = false)
{
    return class_teleport_destination(pTeleport, iRemoveCount, bRandom, bSaveVelocity);
}

function StartTouch() 
{
    local ID = GetTeleportByTeleport(caller);
    if (ID == -1)
        return;
    
    if(!g_hArray_Teleport[ID].bEnable)
        return;
    
    if (g_hArray_Teleport[ID].iMode != 2)
        g_hArray_Teleport[ID].TeleportPlayer(activator);
}

function EndTouch() 
{
    local ID = GetTeleportByTeleport(caller);
    if (ID == -1)
        return;

    if(!g_hArray_Teleport[ID].bEnable)
        g_hArray_Teleport[ID].CheckPush(activator);
    else if (g_hArray_Teleport[ID].iMode == 2)
        return g_hArray_Teleport[ID].TeleportPlayer(activator);
}

function Reset() 
{
    for (local i = 0; i < g_hArray_Teleport.len(); i++)
    {
        g_hArray_Teleport[i].GetPlayer(activator, true);
    }  
}

function GetTeleportByTeleport(hValue) 
{
    for (local i = 0; i < g_hArray_Teleport.len(); i++)
    {
        if (hValue == g_hArray_Teleport[i].hHandle)
            return i;
    }
    return -1;
}

::CheckRemoveTeleports <- function(pTeleport)
{
    for (local i = 0; i < g_hArray_Teleport.len(); i++)
    {
        if (g_hArray_Teleport[i].pTeleport == pTeleport)
        {
            g_hArray_Teleport[i].hHandle.Destroy();
            g_hArray_Teleport.remove(i);
        }
    }
}

EntFireByHandle(self, "RunScriptCode", "Init()", 0, null, null);