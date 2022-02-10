::PLAYERS <- [];
PL_HANDLE <- [];
MAPPER_SID <- [
    "STEAM_1:1:124348087",  //kotya
    "STEAM_1:0:77682040",	//Friend
    "STEAM_1:0:56405847",	//Vishnya

    "STEAM_1:1:54097234",	//Stone
    "STEAM_1:1:76518687",   //Tupu
];

TEMP_HANDLE <- null;
T_Player_Check <- 5.00;

::MAP_PREF <- "[Map] ";

// ADMIN_ROOM_ORIGIN <- Vector(0, 0, 0);
ADMIN_ROOM_ORIGIN <- null;
SCRIPT_VERSION <- "17.10.21 - 13:12";
COMMAND_PREF <- "!mc_"

class PlayerInfo
{
	userid = null;
	name = null;
	steamid = null;
	handle = null;
    mapper = false;
    pl_checked_r = 0;

    infects = 0;
    
	constructor(_userid,_name,_steamid)
	{
		userid = _userid;
		name = _name;
		steamid = _steamid;
	}

    function ValidThisH()
    {
        if(this.handle == null || this.handle != null && !this.handle.IsValid()){return false;}
        else{return true;}
    }

    function ClearClassData()
    {
        this.infects = 0;
        
        this.pl_checked_r++;
        if(this.pl_checked_r > 3){this.pl_checked_r = 3;}
    }

    function GetCheckedCPl(){return this.pl_checked_r;}
    function IsMapper()
    {
        if(this.mapper){return true;}
        else{return false;}
    }


    function SetMapperData()
    {
        if(!this.mapper){return this.mapper = true;}
        else{return;}
    }

    function ReturnMapper()
    {
        if(this.mapper){return true;}
        return false;
    }
}

eventinfo <- null;
eventproxy <- null;
eventlist <- null;
eventsay <- null;
eventdeath <- null;
g_zone <- null;

function MapStart()
{
    if(eventdeath == null || eventdeath != null && !eventdeath.IsValid()){eventdeath = Entities.FindByName(null, "pl_death");}
    if(eventsay == null || eventsay != null && !eventsay.IsValid()){eventsay = Entities.FindByName(null, "pl_say");}
    if(eventlist == null || eventlist != null && !eventlist.IsValid()){eventlist = Entities.FindByName(null, "pl_connect");}
	if(g_zone == null || g_zone != null && !g_zone.IsValid()){g_zone = Entities.FindByName(null, "pl_zone");}
    if(eventinfo == null || eventinfo != null && !eventinfo.IsValid()){eventinfo = Entities.FindByName(null, "pl_info");}
    if(eventproxy == null || eventproxy != null && !eventproxy.IsValid())
    {
        eventproxy = Entities.CreateByClassname("info_game_event_proxy");
        eventproxy.__KeyValueFromString("event_name", "player_info");
        eventproxy.__KeyValueFromInt("range", 0);
        eventproxy.__KeyValueFromInt("spawnflags", 1);
        eventproxy.__KeyValueFromInt("StartDisabled", 0);
    }
    
    for(local i = 0; i < PLAYERS.len(); i++){PLAYERS[i].ClearClassData();}

    LoopPlayerCheck();
}

function LoopPlayerCheck()
{
    EntFireByHandle(self, "RunScriptCode", "LoopPlayerCheck();", T_Player_Check, null, null);
    if(PL_HANDLE.len() > 0){PL_HANDLE.clear();}
    EntFireByHandle(g_zone, "FireUser1", "", 0.00, null, null);
    EntFireByHandle(self, "RunScriptCode", "CheckValidInArr();", T_Player_Check*1.5, null, null);
}

function CheckValidInArr()
{
    if(PLAYERS.len() > 0)
    {
        for(local i = 0; i < PLAYERS.len(); i++)
        {
            if(!PLAYERS[i].ValidThisH() && PLAYERS[i].GetCheckedCPl() >= 3){PLAYERS.remove(i);}
        }
    }
    SetDataAM();
}

function SetDataAM()
{
    if(PLAYERS.len() > 0 && MAPPER_SID.len() > 0)
    {
        for(local i = 0; i < PLAYERS.len(); i++)
        {
            for(local a = 0; a < MAPPER_SID.len(); a++)
            {
                if(PLAYERS[i].steamid == MAPPER_SID[a])
                {
                    PLAYERS[i].SetMapperData();
                }
            }
        }
    }
}

function PlayerConnect()
{
    if(eventlist == null || eventlist != null && !eventlist.IsValid())
    {
        eventlist = Entities.FindByName(null, "pl_connect");
        if(eventlist == null)return;
    }
	local userid = eventlist.GetScriptScope().event_data.userid;
    local name = eventlist.GetScriptScope().event_data.name;
	local steamid = eventlist.GetScriptScope().event_data.networkid;
    local p = PlayerInfo(userid,name,steamid);
    PLAYERS.push(p);
}

function EventInfo()
{
	local userid = eventinfo.GetScriptScope().event_data.userid;
    if(PLAYERS.len() > 0)
    {
        for(local i=0; i < PLAYERS.len(); i++)
        {
            if(PLAYERS[i].userid == userid)
            {
                PLAYERS[i].handle = TEMP_HANDLE;
                return;
            }
        }
    }
    local p = PlayerInfo(userid,"NOT GETED","NOT GETED");
    p.handle = TEMP_HANDLE;
    PLAYERS.push(p);
}

function Set_Player()
{
    if(!ValidHandleArr(activator))
    {
        PL_HANDLE.push(activator);
    }
}

function ValidHandleArr(h)
{
    foreach(p in PLAYERS)
	{
		if(p.handle == h)
		{
            return true;
		}
	}
	return false;
}

function Reg_Player()
{
    if(PL_HANDLE.len() > 0)
    {
        EntFireByHandle(self, "RunScriptCode", "Reg_Player();", 0.10, null, null);
        TEMP_HANDLE = PL_HANDLE[0];
        PL_HANDLE.remove(0);
        if(TEMP_HANDLE.IsValid())
        {
            if(eventproxy == null || eventproxy != null  && !eventproxy.IsValid())return;
            EntFireByHandle(eventproxy, "GenerateGameEvent", "", 0.00, TEMP_HANDLE, null);
        }
    }
}

function GetPlayerClassByHandle(handle)
{
	foreach(p in PLAYERS)
	{
		if(p.handle == handle)
		{
            return p;
		}
	}
	return null;
}

function GetPlayerClassByUserID(uid)
{
    foreach(p in PLAYERS)
	{
		if(p.userid == uid)
		{
            return p;
		}
	}
	return null;
}

function PlayerSay()
{
    try
    {
        if(eventsay == null || eventsay != null && !eventsay.IsValid()){eventsay = Entities.FindByName(null, "pl_say");}
        local userid = eventsay.GetScriptScope().event_data.userid;
        local msg = eventsay.GetScriptScope().event_data.text;
        local player_class = GetPlayerClassByUserID(userid);
        
        if(player_class == null)
            return;

        if(player_class.ReturnMapper())
        {
            if(COMMAND_PREF + "version" == msg)
            {
                Version();
            }
            else if(COMMAND_PREF + "entityreport" == msg)
            {
                EntityReport();
            }
            else if(COMMAND_PREF + "secret" == msg)
            {
                Secret();
            }
            else if(COMMAND_PREF + "adminroom" == msg)
            {
                TeleportAdminRoom(player_class);
            }
        }
    }
    catch(error){return;}
}

{
    function TeleportAdminRoom(player_class = null)
    {
        if(ADMIN_ROOM_ORIGIN == null){return;}
        if(player_class == null)
        {
            player_class = GetPlayerClassByHandle(activator);
            if(player_class == null){return;}
            if(!player_class.ReturnMapper()){return;}
        }

        local handle = player_class.handle;

        if(handle == null || !handle.IsValid() || handle.GetHealth() <= 0){return;}
        
        handle.SetOrigin(ADMIN_ROOM_ORIGIN);
    }

    function Secret()
    {
        EntFire("ss", "FireUser1", "", 0);

        ScriptPrintMessageChatAll(MAP_PREF + "The secret ending was enabled");
    }

    function EntityReport()
    {
        local first_ent = Entities.First();
        local edict_c = 0;
        local iterations = 0;
        local next_ent = Entities.Next(first_ent);
        
        while(next_ent != null)
        {
            iterations++;
            if(next_ent.entindex() != 0){edict_c++;}
            next_ent = Entities.Next(next_ent);
        }

        local text;
        text = "Total "+iterations+" entities ("+edict_c+" edicts)";

        ScriptPrintMessageChatAll(MAP_PREF + text);
    }

    function Version()
    {
        local text;
        text = "Version: " + SCRIPT_VERSION;

        ScriptPrintMessageChatAll(MAP_PREF + text);  
    }
}

{
    function PlayerDeath()
    {
        if(eventdeath == null || eventdeath != null && !eventdeath.IsValid())
        {
            eventdeath = Entities.FindByName(null, "pl_death");
            if(eventdeath == null || eventdeath != null && !eventdeath.IsValid()){return;}
        }

        local attacker = eventdeath.GetScriptScope().event_data.attacker;
        local victim = eventdeath.GetScriptScope().event_data.userid;
        if(attacker == 0){return;}

        local p_c_attacker = GetPlayerClassByUserID(attacker);
        if(p_c_attacker == null){return;}

        local h_attacker = p_c_attacker.handle;
        if(h_attacker == null || h_attacker.GetTeam() != 2){return;}
        
        p_c_attacker.infects++;
    }
}
