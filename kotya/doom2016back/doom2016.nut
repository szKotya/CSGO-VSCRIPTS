Warmup <- false;

function MapStart()
{
    if(eventinfo == null || eventinfo != null && !eventinfo.IsValid())
    {
        eventinfo = Entities.FindByName(null, "pl_ginfo");
    }
    if(eventproxy == null || eventproxy != null && !eventproxy.IsValid())
    {
        eventproxy = Entities.FindByClassname(null, "info_game_event_proxy");
    }
    if(g_zone == null || g_zone != null && !g_zone.IsValid())
    {
        g_zone = Entities.FindByName(null, "check_players");
    }
        if(Freeze == null || Freeze != null && !Freeze.IsValid())
    {
        Freeze = Entities.FindByName(null, "speedMod");
    }
    once_check = true;
    LoopPlayerCheck();
    foreach(p in PLAYERS)
	{
        p.plasmaCount = 0;
    }
    local Text = Entities.FindByName(null, "gtext1");
    ScriptPrintMessageChatAll(::Mes_Welcome1);
    ScriptPrintMessageChatAll(::Mes_Welcome2);
    ScriptPrintMessageChatAll(::Mes_Welcome3);
    if(Text != null && Text.IsValid())
    {
        Text.__KeyValueFromString("message","DOOM2016\n-------------------------\nMap by kondik & Microsoft\nvscripts by Kotya\nThx For Help:\nWaffel & Friend")
        EntFireByHandle(Text, "Display", "",0.01, null, null);
    }

    if(Warmup)
    {
        Precache()
        SetSettingServer();
        local g_round = Entities.FindByName(null, "round_end");
        local time = 10;
        ScriptPrintMessageChatAll(::Mes_Warmup)
        for (local i=0; i<2; i++)
        {
            EntFireByHandle(self, "RunScriptCode", "ScriptPrintMessageChatAll(::Mes_Warmup);", time, null, null);
            time+=10;
        }
        if(g_round != null && g_round.IsValid())
        {
            EntFireByHandle(g_round, "EndRound_Draw", "3", time+5, null, null);
        }
    }
    else
    {
        ScriptPrintMessageChatAll(::Mes_FirstLevel)
        EntFire("main_teleport", "enable", "", 15.00, null);
        EntFire("s1_Spawn_Main_Door", "Open", "", 40.00, null);
        EntFireByHandle(self, "RunScriptCode", "ScriptPrintMessageChatAll(::Mes_DoorOpen+"+(20).tostring()+"+::Mes_Sec)", 20.00, null, null);
        EntFire("s1_logo_move*", "Open", "", 0.00, null);
    }
    Warmup = false;
}

///////////////////////////////////////////////////////////
//events chat commands for admin room
PLAYERS <- [];
PL_HANDLE <- [];
TEMP_HANDLE <- null;
M_STEAM_ID <- [
"STEAM_1:1:124348087", //kotya
"STEAM_0:1:120927227", //kondik
"STEAM_0:0:58001308"]; //Mike

NPC <- ["zombiesc","knight","zombieallah","zombiecy"];
eventinfo <- null;
Freeze <- null;
eventproxy <- null;
eventlist <- null;
eventsay <- null;
g_zone <- null;
once_check <- false;

T_Player_Check <- 5.00;

function LoopPlayerCheck()
{
    EntFireByHandle(self, "RunScriptCode", "LoopPlayerCheck();", T_Player_Check, null, null);
    if(PL_HANDLE.len() > 0){PL_HANDLE.clear();}
    EntFireByHandle(g_zone, "FireUser1", "", 0.00, null, null);
    EntFireByHandle(self, "RunScriptCode", "CheckValidInArr();", T_Player_Check*1.5, null, null);
}


class PlayerInfo
{
	userid = null;
	name = null;
	steamid = null;
	handle = null;
    mapper = false;
    plasmaCount = null;
	constructor(_userid,_name,_steamid)
	{
		userid = _userid;
		name = _name;
		steamid = _steamid;
        plasmaCount = 0;
	}
    function ReturnMapper()
    {
        if(this.mapper)
        {
            return true;
        }
        return false;
    }
    function SetVip()
    {
        if(!this.mapper)
        {
            return this.mapper = true;
        }
    }
}


function SetMapper()
{
    if(PLAYERS.len() > 0 && M_STEAM_ID.len() > 0)
    {
        for(local i = 0; i < PLAYERS.len(); i++)
        {
            if(M_STEAM_ID.len() == 1)
            {
                if(PLAYERS[i].steamid == M_STEAM_ID[0])
                {
                    PLAYERS[i].mapper = true;
                }
            }
            else
            {
                for(local a = 0; a < M_STEAM_ID.len(); a++)
                {
                    if(PLAYERS[i].steamid == M_STEAM_ID[a])
                    {
                        PLAYERS[i].mapper = true;
                    }
                }
            }
        }
    }
}


function PlayerConnect()
{
    if(eventlist == null || eventlist != null && !eventlist.IsValid())
    {
        SendToConsoleServer("sv_disable_immunity_alpha 1");
        eventlist = Entities.FindByName(null, "event_player_connect");
    }
    if(eventsay == null || eventsay != null && !eventsay.IsValid())
    {
        eventsay = Entities.FindByName(null, "pl_say");
    }
	local userid = eventlist.GetScriptScope().event_data.userid;
    local name = eventlist.GetScriptScope().event_data.name;
	local steamid = eventlist.GetScriptScope().event_data.networkid;
    local p = PlayerInfo(userid,name,steamid);
    PLAYERS.push(p);
}

function CheckValidInArr()
{
    if(PLAYERS.len() > 0 && once_check)
    {
        local Temp_Player_Arr = [];
        for(local i = 0; i < PLAYERS.len(); i++)
        {
            if(PLAYERS[i].handle != null && PLAYERS[i].handle.IsValid())
            {
                Temp_Player_Arr.push(PLAYERS[i])
            }
        }
        PLAYERS.clear();
        for(local a = 0; a < Temp_Player_Arr.len(); a++)
        {
            PLAYERS.push(Temp_Player_Arr[a])
        }
        once_check = false;
    }
    return SetMapper();
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

function Reg_Player()
{
    if(PL_HANDLE.len() > 0)
    {
        EntFireByHandle(self, "RunScriptCode", "Reg_Player();", 0.10, null, null);
        TEMP_HANDLE = PL_HANDLE[0];
        PL_HANDLE.remove(0);
        if(TEMP_HANDLE.IsValid())
        {
            EntFireByHandle(eventproxy, "GenerateGameEvent", "", 0.00, TEMP_HANDLE, null);
        }
        else
        {
            return;
        }
    }
}


function PlayerSay()
{
    try
    {
        if(eventsay == null || eventsay != null && !eventsay.IsValid())
        {
            eventsay = Entities.FindByName(null, "pl_say");
        }
        local userid = eventsay.GetScriptScope().event_data.userid;
        local msg = eventsay.GetScriptScope().event_data.text;
        if(msg.find("!map_ef") != 0){msg = msg.tolower();}
        local get_mapper = GetMapperByUserId(userid);
        if(get_mapper == null || !get_mapper)return;
        if(msg == "!map_rr")
        {
            local g_round = Entities.FindByName(null, "round_end");
            if(g_round != null && g_round.IsValid())
            {
                EntFireByHandle(g_round, "EndRound_Draw", "3", 0.00, null, null);
            }
        }
        if(msg == "!map_npсkill")
        {
            for (local i=0; i<NPC.len(); i++)
            {
                EntFire("npc_"+NPC[i]+"_move_physbox*", "RunScriptCode", "Dying()", 0, null);
            }
        }
        if(msg.find("!map_ef") == 0) //ent_fire <classname or targetname> <input name> <optional parameter> <optional delay>
        {
            local sp_text = split(msg," ") //@ct addoutput rendermode 6
            if(sp_text.len() < 3)return;
            local input = sp_text[2];
            local parameters = "";
            if(sp_text.len() > 3){parameters = sp_text[3];}
            if(sp_text[1] == "@me")
            {
                if(sp_text.len() > 3)
                {
                    for(local i = 4; i < sp_text.len(); i++){parameters += " "+sp_text[i];}
                }
                EntFireByHandle(GetPlayerByUserID(userid), ""+input, ""+parameters, 0.00, activator, null);
            }
            else if(sp_text[1] == "@ct")
            {
                if(sp_text.len() > 3)
                {
                    for(local i = 4; i < sp_text.len(); ++i){parameters += " "+sp_text[i];}
                }
                InputPlayerCt(input, parameters);
            }
            else if(sp_text[1] == "@t")
            {
                if(sp_text.len() > 3)
                {
                    for(local i = 4; i < sp_text.len(); i++){parameters += " "+sp_text[i];}
                }
                InputPlayerT(input, parameters);
            }
            else
            {
                if(sp_text.len() > 3)
                {
                    for(local i = 4; i < sp_text.len(); i++){parameters += " "+sp_text[i];}
                }
                EntFire(""+sp_text[1], ""+sp_text[2], ""+parameters, 0.00, GetPlayerByUserID(userid));
            }
            ScriptPrintMessageChatAll(" \x04 target:"+sp_text[1]+" \x07 input:"+sp_text[2]+" \x03 par:"+parameters);
        }
    }
    catch(error)
    {
        return;
    }
}

function InputPlayerCt(_input, _parameter)
{
    local h = null;
	while(null != (h = Entities.FindByClassname(h, "player")))
	{
		if(h != null && h.IsValid() && h.GetHealth() > 0 && h.GetTeam() == 3)
		{
			EntFireByHandle(h, ""+_input, ""+_parameter, 0.00, h, null);
		}
	}
}

function InputPlayerUserid(_uid, _input, _parameter)
{
	EntFireByHandle(GetPlayerByUserID(_uid), ""+_input, ""+_parameter, 0.00, GetPlayerByUserID(_uid), null);
}

function InputPlayerT(_input, _parameter)
{
    local h = null;
	while(null != (h = Entities.FindByClassname(h, "player")))
	{
		if(h != null && h.IsValid() && h.GetHealth() > 0 && h.GetTeam() == 2)
		{
			EntFireByHandle(h, ""+_input, ""+_parameter, 0.00, h, null);
		}
	}
}

function ShowAdminMessage()
{
    local a_text = Entities.FindByName(null, "admin_message");
    if(a_text != null && a_text.IsValid())
    {
        a_text.__KeyValueFromString("message", "ADMIN COMMANDS:\n!map_setng <int>\n!map_setbonfire <int>\n!map_setitemlevel <int>\n!map_rr (restarts round)\n!map_bosskill (kills the boss)\n!map_ef <classname or targetname> <input name> <optional parameter>");
        EntFireByHandle(a_text, "Display", "", 0.00, activator, null);
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


function CheckPlInArr()
{
    if(PLAYERS.len() > 0)
    {
        try
        {
            ScriptPrintMessageCenterAll("ARRAY LEN: "+PLAYERS.len()+
            "\nPL NAME: "+GetPlayerClassByHandle(activator).name+
            "\nPL UID: "+GetPlayerClassByHandle(activator).userid+
            "\nPL STEAMID: "+GetPlayerClassByHandle(activator).steamid+
            "\nHANDLE: "+GetPlayerClassByHandle(activator).handle+
            "\nMAPPER: "+GetPlayerClassByHandle(activator).ReturnMapper()+
            "\nPlasmaCount: "+GetPlayerClassByHandle(activator).plasmaCount);
        }
        catch(error)
        {
            ScriptPrintMessageCenterAll("PLAYER ERROR, TRY RETRY");
        }

    }
    else
    {
        ScriptPrintMessageCenterAll("ARRAY CLEAR");
    }
}

function CheckPlInArrUid(uid)
{
    if(PLAYERS.len() > 0)
    {
        ScriptPrintMessageCenterAll("ARRAY LEN: "+PLAYERS.len()+
        "\nPL NAME: "+GetPlayerClassByUserID(uid).name+
        "\nPL UID: "+GetPlayerClassByUserID(uid).userid+
        "\nPL STEAMID: "+GetPlayerClassByUserID(uid).steamid+
        "\nHANDLE: "+GetPlayerClassByUserID(uid).handle+
        "\nMAPPER: "+GetPlayerClassByUserID(uid).ReturnMapper()+
        "\nPlasmaCount: "+GetPlayerClassByHandle(activator).plasmaCount);
    }
    else
    {
        ScriptPrintMessageCenterAll("ARRAY CLEAR");
    }
}

function GetMapperByUserId(userid)
{
    foreach(p in PLAYERS)
	{
		if(p.userid == userid)
		{
            return p.ReturnMapper();
		}
	}
	return null;
}

function GetPlayerByUserID(userid)
{
	foreach(p in PLAYERS)
	{
		if(p.userid == userid)
		{
            return p.handle;
		}
	}
	return null;
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

function SetVipByHandle()
{
    foreach(p in PLAYERS)
	{
		if(p.handle == activator)
		{
            return p.SetVip();
		}
	}
	return null;
}

function CheckPlasma()
{
    foreach(p in PLAYERS)
	{
		if(p.handle == activator)
		{
            if(p.plasmaCount+1>=5)
            {
                p.plasmaCount = 0;
                EntFireByHandle(Freeze, "ModifySpeed", "0.4", 0, activator, activator);
                EntFireByHandle(Freeze, "ModifySpeed", "1", 0.5, activator, activator);
            }
            else p.plasmaCount++;
		}
	}
}
///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
//HP manager
function SetHP(HP_BASE,HP_PERHUMAN,TAR_DISTANCE)
{
    local h = null;
    local Count = 0;
    while(null!=(h=Entities.FindInSphere(h,caller.GetOrigin(),TAR_DISTANCE)))
    {
        if(h.GetClassname()=="player" && h.GetTeam()==3 && h.GetHealth()>0)Count++;
    }
    EntFireByHandle(caller, "SetHealth", (HP_BASE+HP_PERHUMAN*Count).tostring(), 0, null, null);
}

class FullPos
{
  origin = null;
  angles = null;
  constructor(_origin,_angles)
  {
    origin = _origin;
    angles = _angles;
  }
}
g_Spawn <- [

];
TemplateList <- [
  "maker_shkololo", //0
  "maker_pidars",
  "maker_kiborg",
];

function SpawnRandomNPC(NPC_Handle,NPC_Max)
{
    if(g_Spawn.len()==0)return;
    local HandleTemplate = Entities.FindByName(null, TemplateList[NPC_Handle]);
    local spawn = g_Spawn.slice(0,g_Spawn.len());
    g_Spawn = [];
    for (local i=0; i<NPC_Max; i++)
    {
        local randomPos = RandomInt(0,spawn.len()-1);
        HandleTemplate.SpawnEntityAtLocation((spawn[randomPos].origin),(spawn[randomPos].angles));
        if(NPC_Max - i < spawn.len())
        {
        spawn.remove(randomPos);
        }
    }
}

function AddPos(x,y,z,xa,ya,za)g_Spawn.push(FullPos(Vector(x,y,z),Vector(xa,ya,za)));
///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
function quest()
{
    switch (RandomInt(0,10))
		{
			case 0:{EntFire("s1_temp_quest", "AddOutput", "origin -2808 -494 -56", 0.00, null);break;}
			case 1:{EntFire("s1_temp_quest", "AddOutput", "origin -2812 -566 -56", 0.00, null);break;}
			case 2:{EntFire("s1_temp_quest", "AddOutput", "origin -2654 -555 -56", 0.00, null);break;}
			case 3:{EntFire("s1_temp_quest", "AddOutput", "origin -2656 -757 -56", 0.00, null);break;}
			case 4:{EntFire("s1_temp_quest", "AddOutput", "origin -2651 -807 -56", 0.00, null);break;}
			case 5:{EntFire("s1_temp_quest", "AddOutput", "origin -4367 -1059 168", 0.00, null);break;}
			case 6:{EntFire("s1_temp_quest", "AddOutput", "origin -4623 -1173 -168", 0.00, null);break;}
			case 7:{EntFire("s1_temp_quest", "AddOutput", "origin -3076 -1075 -56", 0.00, null);break;}
			case 8:{EntFire("s1_temp_quest", "AddOutput", "origin -2930 -268 -56", 0.00, null);break;}
			case 9:{EntFire("s1_temp_quest", "AddOutput", "origin -2584 -251 -56", 0.00, null);break;}
			case 10:{EntFire("s1_temp_quest", "AddOutput", "origin -2662 -1202 -56", 0.00, null);break;}
        }
	EntFire("s1_temp_quest", "ForceSpawn", "", 0.10, null);
}

///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
//Music manager
function SetNewMusic(Name)
{
    local Music = Entities.FindByName(null, "Music");
    if(Music != null && Music.IsValid())
    {
        local time = 0.1;
        for (local i=1; i<11; i++)
        {
            EntFireByHandle(Music,"Volume",(10-i).tostring(),time,null,null);
            time+=0.1;
        }
        EntFireByHandle(Music,"StopSound", "",2,null,null);
        EntFireByHandle(Music,"AddOutput", "message *"+Name,2.1,null,null);
        EntFireByHandle(Music,"Volume", "10",2.15,null,null);
        EntFireByHandle(Music,"PlaySound", "",2.2,null,null);
    }
}
///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
::Mes_Welcome1 <- " \x10 *** \x08 Welcome to the map \x02 Doom 2016 \x10 ***";
::Mes_Welcome2 <- " \x10 *** \x08 Map by \x0eKondik \x10& \x0eMicrosoft\x10 ***";
::Mes_Welcome3 <- " \x10 *** \x08 vscripts by \x0eKotya \x10 ***";

// Первый Уровень - first level/stage
// ждите - wait
// мост поднимается - the bridge rises/goes up
// дверь откроется через - door will open in
// дверь закроется через - door will be closed in
// Дверь лифта откроется через - Elevator door will open in
// дверь лифта открывается - Elevator door is openning
// секунд - seconds
// найдите PDA - find PDA
// PDA найден - PDA found

::Mes_Warmup <- " \x02 *** \x10 Разминка \x02 ***";
::Mes_FirstLevel <- " \x02 *** \x10 Первый Уровень \x02 ***";

::Mes_Wait <- " \x09 *** \x10 Ждите \x09 ***";
::Mes_Bridge <- " \x09 *** \x10 Мост поднимается \x09 ***";

::Mes_DoorOpen <- " \x09 *** \x10 Дверь откроется через ";
::Mes_DoorClose <- " \x09 *** \x10 Дверь закроется через ";

::Mes_DoorLiftOpen <- " \x09 *** \x10 Дверь лифта откроестя через ";
::Mes_DoorLiftOpening <- " \x09 *** \x10 Дверь лифта открывается \x09 ***";

::Mes_Sec <- " секунд \x09 ***";

::Mes_PDAFind <- " \x09 *** \x10 Найдите PDA \x09 ***"
::Mes_PDAWasFind <- " \x09 *** \x10 PDA найден \x09 ***"


M_Path <- "doom2016\\music\\"
::M_Argent <- M_Path+"Argent_Facility.mp3";//после телепорта	Argent_Facility
::M_Beginning <- M_Path+"The_Beginning.mp3";// После 2ой двери	The_Beginning	s1_Spawn_Hold1_Trigger
::M_Combat <- M_Path+"Combat_UAC_C.mp3";// перед выходом в ангар	Combat_UAC_C.mp3	s1_Spawn_Hold2_Trigger
::M_Violence <- M_Path+"Violence.mp3";//после команты с первым нпс спавном	Violence	s2_Room1_DDoor_Trigger
::M_Guard <- M_Path+"Hell_Guard.mp3";//Лока майка начало	Hell_Guard	s3_adoor_trigger
::M_Blood <- M_Path+"Blood_Gore.mp3";//нажатие кнопки в румконтроле		Blood_Gore		s3_but
::M_Lazarus <- M_Path+"lazarus.mp3";//вход в ангар обратно	Lazaruss	3_door_b

SoundsPrecache <-
[
    "*doom2016\\items\\zm\\archville\\bust.mp3",
    "*doom2016\\items\\zm\\archville\\fireball.mp3",
    "*doom2016\\items\\zm\\archville\\firepol.mp3",
    "*doom2016\\items\\zm\\archville\\random1.mp3",
    "*doom2016\\items\\zm\\archville\\random2.mp3",
    "*doom2016\\items\\zm\\archville\\random3.mp3",
    "*doom2016\\items\\zm\\archville\\random4.mp3",
    "*doom2016\\items\\zm\\archville\\random5.mp3",
    "*doom2016\\items\\zm\\archville\\random6.mp3",
    "*doom2016\\items\\zm\\archville\\random7.mp3",
    "*doom2016\\items\\zm\\archville\\random8.mp3",
    "*doom2016\\items\\zm\\archville\\random9.mp3",
    "*doom2016\\items\\zm\\archville\\random10.mp3",
    "*doom2016\\items\\zm\\archville\\random11.mp3",
    "*doom2016\\items\\zm\\archville\\random12.mp3",
    "*doom2016\\items\\zm\\archville\\random13.mp3",
    "*doom2016\\items\\zm\\archville\\random14.mp3",
    "*doom2016\\items\\zm\\archville\\random15.mp3",
    //arch

    "*doom2016\\music\\Argent_Facility.mp3",
	"*doom2016\\music\\The_Beginning.mp3",
	"*doom2016\\music\\Combat_UAC_C.mp3",
	"*doom2016\\music\\Violence.mp3",
	"*doom2016\\music\\Hell_Guard.mp3",
	"*doom2016\\music\\Blood_Gore.mp3",
	"*doom2016\\music\\lazarus.mp3",

    "*doom2016\\music\\Rip_Tear.mp3",
	"*doom2016\\music\\Tower_Ascension.mp3",
	"*doom2016\\sounds\\humanwin.mp3",
    //music
];
function Precache()
{
    for (local i=0; i<SoundsPrecache.len()-1; i++)
    {
        self.PrecacheScriptSound(SoundsPrecache[i]);
    }
}
ServerSettings <-[
"mp_freezetime 1",
"mp_startmoney 16000",
"mp_roundtime 20",
"sv_airaccelerate 12",
"zr_infect_mzombie_ratio 6",
"zr_infect_spawntime_min 18",
"zr_infect_spawntime_max 18",
"zr_ztele_zombie 1",
"zr_ztele_max_human 0",
"zr_ztele_max_zombie 3",
"zr_class_modify zombies health_infect_gain 200",
"zr_class_modify zombies health 10000",
"zr_class_modify zombies health_regen_interval 0.15",
"zr_class_modify zombies health_regen_amount 10",
"zr_infect_mzombie_respawn 1",
"zr_zspawn 1",
"zr_zspawn_team_zombie 1",
"zr_zspawn_block_rejoin 0",
"zr_zspawn_timelimit 0",
"zr_respawn 1",
"zr_respawn_team_zombie 1",
"zr_respawn_team_zombie_world 1",
"zr_respawn_delay 2"];

function SetSettingServer()
{
    for (local i=0; i<ServerSettings.len()-1; i++)
    {
        SendToConsoleServer(ServerSettings[i]);
    }
}

