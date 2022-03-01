::PLAYERS <- [];
PL_HANDLE <- [];
MAPPER_SID <- ["STEAM_1:1:124348087"];

TEMP_HANDLE <- null;
T_Player_Check <- 5.00;

::MAP_PREF <- "[Map] ";

// ADMIN_ROOM_ORIGIN <- Vector(0, 0, 0);
ADMIN_ROOM_ORIGIN <- null;
SCRIPT_VERSION <- "07.02.22 - 0:12";
COMMAND_PREF <- "!mc_"

class class_player
{
	userid = null;
	name = null;
	steamid = null;
	handle = null;
	mapper = false;
	pl_checked_r = 0;

	constructor(_userid,_name,_steamid)
	{
		userid = _userid;
		name = _name;
		steamid = _steamid;
	}

	function ValidThisH()
	{
		if (this.handle == null || !this.handle.IsValid()){return false;}
		else{return true;}
	}

	function ClearClassData()
	{
		this.pl_checked_r++;
		if (this.pl_checked_r > 3){this.pl_checked_r = 3;}
	}

	function GetCheckedCPl(){return this.pl_checked_r;}
	function IsMapper()
	{
		if (this.mapper){return true;}
		else{return false;}
	}

	function SetMapperData()
	{
		if (!this.mapper){return this.mapper = true;}
		else{return;}
	}

	function ReturnMapper()
	{
		if (this.mapper){return true;}
		return false;
	}
}

EVENT_INFO <- null;
EVENT_PROXE <- null;
EVENT_LIST <- null;
EVENT_SAY <- null;
EVENT_PLAYER_SPAWNED <- null;
GLOBAL_ZONE <- null;

function RoundStart()
{
	if (EVENT_PLAYER_SPAWNED == null || EVENT_PLAYER_SPAWNED != null && !EVENT_PLAYER_SPAWNED.IsValid()){EVENT_PLAYER_SPAWNED = Entities.FindByName(null, "map_eventlistener_player_spawned");}
	if (EVENT_SAY == null || EVENT_SAY != null && !EVENT_SAY.IsValid()){EVENT_SAY = Entities.FindByName(null, "map_eventlistener_player_say");}
	if (EVENT_LIST == null || EVENT_LIST != null && !EVENT_LIST.IsValid()){EVENT_LIST = Entities.FindByName(null, "map_eventlistener_player_connect");}
	if (GLOBAL_ZONE == null || GLOBAL_ZONE != null && !GLOBAL_ZONE.IsValid()){GLOBAL_ZONE = Entities.FindByName(null, "map_eventlistener_zone");}
	if (EVENT_INFO == null || EVENT_INFO != null && !EVENT_INFO.IsValid()){EVENT_INFO = Entities.FindByName(null, "map_eventlistener_player_info");}
	if (EVENT_PROXE == null || EVENT_PROXE != null && !EVENT_PROXE.IsValid())
	{
		EVENT_PROXE = Entities.CreateByClassname("info_game_event_proxy");
		EVENT_PROXE.__KeyValueFromString("event_name", "player_info");
		EVENT_PROXE.__KeyValueFromInt("range", 0);
		EVENT_PROXE.__KeyValueFromInt("spawnflags", 1);
		EVENT_PROXE.__KeyValueFromInt("StartDisabled", 0);
	}

	for(local i = 0; i < PLAYERS.len(); i++){PLAYERS[i].ClearClassData();}

	LoopPlayerCheck();
}

function LoopPlayerCheck()
{
	EntFireByHandle(self, "RunScriptCode", "LoopPlayerCheck();", T_Player_Check, null, null);
	if (PL_HANDLE.len() > 0){PL_HANDLE.clear();}
	EntFireByHandle(GLOBAL_ZONE, "FireUser1", "", 0.00, null, null);
	EntFireByHandle(self, "RunScriptCode", "CheckValidInArr();", T_Player_Check*1.5, null, null);
}

function CheckValidInArr()
{
	if (PLAYERS.len() > 0)
	{
		for(local i = 0; i < PLAYERS.len(); i++)
		{
			if (!PLAYERS[i].ValidThisH() && PLAYERS[i].GetCheckedCPl() >= 3){PLAYERS.remove(i);}
		}
	}
	SetDataAM();
}

function SetDataAM()
{
	if (PLAYERS.len() > 0 && MAPPER_SID.len() > 0)
	{
		for(local i = 0; i < PLAYERS.len(); i++)
		{
			for(local a = 0; a < MAPPER_SID.len(); a++)
			{
				if (PLAYERS[i].steamid == MAPPER_SID[a])
				{
					PLAYERS[i].SetMapperData();
				}
			}
		}
	}
}

function Set_Player()
{
	if (!ValidHandleArr(activator))
	{
		PL_HANDLE.push(activator);
	}
}

function ValidHandleArr(h)
{
	foreach(p in PLAYERS)
	{
		if (p.handle == h)
		{
			return true;
		}
	}
	return false;
}

function Reg_Player()
{
	if (PL_HANDLE.len() > 0)
	{
		EntFireByHandle(self, "RunScriptCode", "Reg_Player();", 0.10, null, null);
		TEMP_HANDLE = PL_HANDLE[0];
		PL_HANDLE.remove(0);
		if (TEMP_HANDLE.IsValid())
		{
			if (EVENT_PROXE == null || EVENT_PROXE != null  && !EVENT_PROXE.IsValid())return;
			EntFireByHandle(EVENT_PROXE, "GenerateGameEvent", "", 0.00, TEMP_HANDLE, null);
		}
	}
}

function PlayerConnect()
{
	if (EVENT_LIST == null || EVENT_LIST != null && !EVENT_LIST.IsValid())
	{
		EVENT_LIST = Entities.FindByName(null, "map_eventlistener_player_connect");
		if (EVENT_LIST == null)return;
	}
	local userid = EVENT_LIST.GetScriptScope().event_data.userid;
	local name = EVENT_LIST.GetScriptScope().event_data.name;
	local steamid = EVENT_LIST.GetScriptScope().event_data.networkid;
	local p = class_player(userid,name,steamid);
	PLAYERS.push(p);
}

function PlayerInfo()
{
	local userid = EVENT_INFO.GetScriptScope().event_data.userid;
	if (PLAYERS.len() > 0)
	{
		for(local i=0; i < PLAYERS.len(); i++)
		{
			if (PLAYERS[i].userid == userid)
			{
				PLAYERS[i].handle = TEMP_HANDLE;
				return;
			}
		}
	}
	local p = class_player(userid,"NOT GETED","NOT GETED");
	p.handle = TEMP_HANDLE;
	PLAYERS.push(p);
}

function PlayerSay()
{
	try
	{
		if (EVENT_SAY == null || EVENT_SAY != null && !EVENT_SAY.IsValid()){EVENT_SAY = Entities.FindByName(null, "map_eventlistener_player_say");}
		local userid = EVENT_SAY.GetScriptScope().event_data.userid;
		local msg = EVENT_SAY.GetScriptScope().event_data.text;
		local player_class = GetPlayerClassByUserID(userid);

		if (player_class == null)
			return;

		if (player_class.ReturnMapper())
		{
			if (COMMAND_PREF + "version" == msg)
			{
				Version();
			}
			else if (COMMAND_PREF + "entityreport" == msg)
			{
				EntityReport();
			}
			else if (COMMAND_PREF + "adminroom" == msg)
			{
				TeleportAdminRoom(player_class);
			}
		}
	}
	catch(error){return;}
}

function PlayerSpawned()
{

}

::GetPlayerClassByHandle <- function(handle)
{
	foreach(p in PLAYERS)
	{
		if (p.handle == handle)
		{
			return p;
		}
	}
	return null;
}

::GetPlayerClassByUserID <- function(uid)
{
	foreach(p in PLAYERS)
	{
		if (p.userid == uid)
		{
			return p;
		}
	}
	return null;
}

function TeleportAdminRoom(player_class = null)
{
	if (ADMIN_ROOM_ORIGIN == null){return;}
	if (player_class == null)
	{
		player_class = GetPlayerClassByHandle(activator);
		if (player_class == null){return;}
		if (!player_class.ReturnMapper()){return;}
	}

	local handle = player_class.handle;

	if (handle == null || (handle != null && handle.IsValid() && handle.GetHealth() > 0)){return;}

	handle.SetOrigin(ADMIN_ROOM_ORIGIN);
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
		if (next_ent.entindex() != 0){edict_c++;}
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