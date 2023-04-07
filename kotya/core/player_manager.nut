::PLAYERSINFO <- [];
PL_HANDLE <- [];

TEMP_HANDLE <- null;
T_Player_Check <- 5.00;

class class_playerinfo
{
	userid = null;
	name = null;
	steamid = null;
	handle = null;

	pl_checked_r = 0;

	constructor(_userid, _name, _steamid)
	{
		this.userid = _userid;
		this.name = _name;
		this.steamid = _steamid;
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
}

EVENT_INFO <- null;
EVENT_PROXE <- null;
EVENT_LIST <- null;
GLOBAL_ZONE <- null;

function RoundStart()
{
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

	for(local i = 0; i < PLAYERSINFO.len(); i++){PLAYERSINFO[i].ClearClassData();}

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
	if (PLAYERSINFO.len() > 0)
	{
		for(local i = 0; i < PLAYERSINFO.len(); i++)
		{
			if (!PLAYERSINFO[i].ValidThisH() && PLAYERSINFO[i].GetCheckedCPl() >= 3){PLAYERSINFO.remove(i);}
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
	foreach(p in PLAYERSINFO)
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
	local p = class_playerinfo(userid,name,steamid);
	PLAYERSINFO.push(p);
}

function PlayerInfo()
{
	local userid = EVENT_INFO.GetScriptScope().event_data.userid;
	if (PLAYERSINFO.len() > 0)
	{
		for(local i=0; i < PLAYERSINFO.len(); i++)
		{
			if (PLAYERSINFO[i].userid == userid)
			{
				PLAYERSINFO[i].handle = TEMP_HANDLE;
				return;
			}
		}
	}
	local p = class_playerinfo(userid,"NOT GETED","NOT GETED");
	p.handle = TEMP_HANDLE;
	PLAYERSINFO.push(p);
}

::GetPlayerInfoClassByHandle <- function(handle)
{
	foreach(p in PLAYERSINFO)
	{
		if (p.handle == handle)
		{
			return p;
		}
	}
	return null;
}

::GetPlayerInfoClassByUserID <- function(uid)
{
	foreach(p in PLAYERSINFO)
	{
		if (p.userid == uid)
		{
			return p;
		}
	}
	return null;
}