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
    ReplaceWeapon();
    foreach(p in PLAYERS)
	{
        p.plasmaCount = 0;
        p.havegravity = false;
    }
    local Text = Entities.FindByName(null, "mgame_text");
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
    plasmaCount = 0;
    havegravity = false;
	constructor(_userid,_name,_steamid)
	{
		userid = _userid;
		name = _name;
		steamid = _steamid;
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
    function SetHaveGravity(b)
    {
        if(b) this.havegravity = true;
        else this.havegravity = false;
    }
    function HaveGravityNow()
    {
        if(this.havegravity)
        {
            return true;
        }
        return false;
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

function ReplaceWeapon()
{
    local BizonEq = Entities.FindByName(null, "gravy_bizon_replace");
    if(BizonEq == null || !(BizonEq.IsValid()))return;

    local ammo = null;
    while(null != (ammo = Entities.FindByClassnameWithin(ammo,"weapon_*",self.GetOrigin(),36000)))
    {
        if(ammo.GetOwner() != null &&

            (ammo.GetClassname() == "weapon_negev" ||

            ammo.GetClassname() == "weapon_nova" ||

            ammo.GetClassname() == "weapon_awp" ||

            ammo.GetClassname() == "weapon_m249" ||

            ammo.GetClassname() == "weapon_mac10" ||

            ammo.GetClassname() == "weapon_mag7" ||

            ammo.GetClassname() == "weapon_scar20" ||

            ammo.GetClassname() == "weapong_g3sg1" ||

            ammo.GetClassname() == "weapon_ssg08" ||

            ammo.GetClassname() == "weapon_xm1014"))
        {
            local Owner = ammo.GetMoveParent();
            EntFireByHandle(BizonEq, "Use", "", 0, Owner, Owner);
        }
    }
    EntFireByHandle(self, "RunScriptCode", "ReplaceWeapon();", 1, null, null);
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
            "\nHaveGravity: "+GetPlayerClassByHandle(activator).havegravity+
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
        "\nHaveGravity: "+GetPlayerClassByUserID(uid).havegravity+
        "\nPlasmaCount: "+GetPlayerClassByUserID(uid).plasmaCount);
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

function GetGravityStatusByHandle(activator)
{
    foreach(p in PLAYERS)
	{
		if(p.handle == activator)
		{
            return p.HaveGravityNow();
		}
	}
	return null;
}

function SetGravityStatusByHandle(b,activator)
{
    foreach(p in PLAYERS)
	{
		if(p.handle == activator)
		{
            p.SetHaveGravity(b);
		}
	}
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
            return;
		}
	}
}


function CheckNade()
{
    if(true)
    {
        local event = Entities.FindByName(null, "pl_nade");
        local us = event.GetScriptScope().event_data.userid;

        local handle = GetPlayerByUserID(us);
        if(GetGravityStatusByHandle(handle))
        {
            SetGravityStatusByHandle(false,handle);
            EntFireByHandle(self, "RunScriptCode", "CheckNadeNext();", 0.05, handle, handle);
        }
    }
}

function CheckNadeNext()
{
    local nade = null;
    while(null != (nade = Entities.FindByClassnameWithin(nade,"hegrenade_projectile", activator.GetOrigin()+Vector(0,0,50), 100)))
    {
        if(nade!=null && nade.IsValid())
        {
            if(nade.GetModelName() != "models/microrost/doom16/items/grenade.mdl")
            {
                local time = 1.55;
                nade.SetModel("models/microrost/doom16/items/grenade.mdl");
                //EntFireByHandle(nade, "AddOutPut", "targetname ", 0.00, null, null);
                //EntFireByHandle(nade, "Kill", "", time+0.05, null, null);
                EntFireByHandle(nade, "RunScriptCode", "Entities.FindByName(null, 'n'.tochar()+'m'.tochar()).SpawnEntityAtLocation(self.GetOrigin(),Vector(0,0,0));", time, null, null);
                return;
            }
        }
    }
}

function GetGravityNade()
{
    local NADEM = Entities.FindByName(null, "gravy_nade_equip");
    if(!(NADEM.IsValid()) || NADEM == null) return;
    EntFireByHandle(NADEM, "Use", "", 0, activator, activator);
    SetGravityStatusByHandle(true,activator);
    //EntFireByHandle(self, "RunScriptCode", "GetGravityNadeName();", 0.1, activator, activator);
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
function SetAmb(Name)
{
    local ambient_sounds = Entities.FindByName(null, "ambient_sounds");
    if(ambient_sounds != null && ambient_sounds.IsValid())
    {
        local time = 0.1;
        for (local i=1; i<11; i++)
        {
            EntFireByHandle(ambient_sounds,"Volume",(10-i).tostring(),time,null,null);
            time+=0.1;
        }
        EntFireByHandle(ambient_sounds,"StopSound", "",0,null,null);
        EntFireByHandle(ambient_sounds,"AddOutput", "message *"+Name,0.1,null,null);
        EntFireByHandle(ambient_sounds,"Volume", "10",0.15,null,null);
        EntFireByHandle(ambient_sounds,"PlaySound", "",0.2,null,null);
    }
}
///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
::Mes_Welcome1 <- " \x10 *** *** \x08 Welcome to the map \x02 Doom 2016 \x10 ***";
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
::M_RipTear <- M_Path+"Rip_Tear.mp3";//вход в туннель после джамп пада
::M_TowerAscension <- M_Path+"Tower_Ascension.mp3";//выживание, где турбины
::M_Win <- M_Path+"humanwin.mp3";//звук победы

D_Path <- "doom2016\\ambient\\doctor\\"
::D_Control <- D_Path+"primary_control.mp3";// где-то поблизости был активирован первичный контрольный прогон, это могла быть Оливия
::D_PDA <- D_Path+"found_pda.mp3";// VEGA попытался получить доступ к Olivia Smiles, если вы можете перейти к ближайшему терминалу.
::D_Choise <- D_Path+"i_not_have_choise.mp3";// Я не злодей в этой истории, чтобы делать то, что я делаю, потому что выбора нет
::D_Portal <- D_Path+"if_not_closed_portal.mp3";// если вы выберете этот аккумулятор рядом с источником, вы сможете открыть портал в их мир, который мы никогда не сможем закрыть.
::D_Killall <- D_Path+"kill_all_exit.mp3";// единственные способы убить их всех не оставляют ничего позади, что, возможно, вы правы, но мы можем просто закрыть все это без э нергии, будет хуже,  если я не ожидаю, что вы согласитесь
::D_Ammmos <- D_Path+"office_doctor.mp3";// Я доктор Samuel trade У меня в офисе есть припасы
::D_OPortal <- D_Path+"olivia_activated_portal.mp3";// Оливия активировала, черт возьми, откуда-то в этом объекте Я действительно надеялся, что она сможет подняться над их влиянием  Я ошибался, она оказалась слабее меня
::D_UPortal <- D_Path+"olivia_used_portal.mp3";// используя башню, чтобы построить дверной проем в их мир,  вы можете предотвратить открытие ворот или отключение индукционных фильтров башни
::D_Otvet <- D_Path+"otvetstvennost.mp3";// Я готов взять на себя полную ответственность за ужасные события последних 24 часов.  Вы должны понимать: Мировое облегчение для улучшения человечества.
::D_Tkill <- D_Path+"tryed_to_kill.mp3";// Я пытался убить тебя, но я не хочу, чтобы ты стоял у нас на пути
::D_PWA <- D_Path+"portal_with_accum.mp3";// арки кумулятивного она несёт Щиты пишут пользователю открыть портал мужчины готовы к черту

V_Path <- "doom2016\\ambient\\vega\\"
::V_ADenied <- V_Path+"acces_denied1.mp3";// Доступ заблокирован
::V_ADoors <- V_Path+"all_doors_closed.mp3";// все двери и закрыты и доступ к терминалам закрыт. вам необходимо разблокировать доступ.
::V_ACore <- V_Path+"core_temperature.mp3";// Температура ядра превышена

G_Path <- "doom2016\\ambient\\girl\\"
::G_ADenied <- G_Path+"acces_denied.mp3";// доступ заблокирован
::G_AGrant <- G_Path+"acces_grandted.mp3";// Доступ разрешен
::G_Demonm <- G_Path+"demonic_snijeno.mp3";// Демоническое присутствие снижено
::G_FDemon <- G_Path+"demons_obnarusj.mp3";// Обнаружена демоническая угроза
::G_TCore <- G_Path+"temperature_core.mp3";// Температура ядра растет
::G_TActive <- G_Path+"terminal_activated.mp3";// Терминалы активированы

O_Path <- "doom2016\\ambient\\olivia\\"
::O_About <- O_Path+"about_doomguy.mp3";// рассказывает что то о дум гае

U_Path <- "doom2016\\ambient\\uac\\"
::U_About <- U_Path+"about_uac.mp3";// о юак
::U_Nabor <- U_Path+"nabor_v_uac.mp3";// набор в команду
::U_Uac <- U_Path+"uac.mp3";// о уак
::U_Uact <- U_Path+"uac_the_best.mp3";// уак лучшие
::U_Work <- U_Path+"working_uac.mp3";// работа в  уак

B_Path <- "doom2016\\sounds\\"
::B_Button <- B_Path+"pdapick.mp3";// нажатие на кнопку
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

    "*doom2016\\items\\zm\\revenant\\revenant_aim.mp3",
    "*doom2016\\items\\zm\\revenant\\revenant_pickedup.mp3",
    "*doom2016\\items\\zm\\revenant\\startfly.mp3",
    "*doom2016\\items\\zm\\revenant\\rocket.mp3",
    "*doom2016\\items\\zm\\revenant\\shootlaser.mp3",
    //revenant

    "*doom2016\\items\\zm\\mancubus\\endflame.mp3",
    "*doom2016\\items\\zm\\mancubus\\fireball.mp3",
    "*doom2016\\items\\zm\\mancubus\\flame.mp3",
    "*doom2016\\items\\zm\\mancubus\\smoke.mp3",
    "*doom2016\\items\\zm\\mancubus\\random1.mp3",
    "*doom2016\\items\\zm\\mancubus\\random2.mp3",
    "*doom2016\\items\\zm\\mancubus\\random3.mp3",
    "*doom2016\\items\\zm\\mancubus\\random4.mp3",
    "*doom2016\\items\\zm\\mancubus\\random5.mp3",
    "*doom2016\\items\\zm\\mancubus\\random6.mp3",
    "*doom2016\\items\\zm\\mancubus\\random7.mp3",
    "*doom2016\\items\\zm\\mancubus\\random8.mp3",
    "*doom2016\\items\\zm\\mancubus\\random9.mp3",
    "*doom2016\\items\\zm\\mancubus\\random10.mp3",
    "*doom2016\\items\\zm\\mancubus\\random11.mp3",
    "*doom2016\\items\\zm\\mancubus\\random12.mp3",
    "*doom2016\\items\\zm\\mancubus\\random13.mp3",
    "*doom2016\\items\\zm\\mancubus\\random14.mp3",
    "*doom2016\\items\\zm\\mancubus\\random15.mp3",
    "*doom2016\\items\\zm\\mancubus\\random16.mp3",
    "*doom2016\\items\\zm\\mancubus\\random17.mp3",
    "*doom2016\\items\\zm\\mancubus\\random18.mp3",
    "*doom2016\\items\\zm\\mancubus\\random19.mp3",
    "*doom2016\\items\\zm\\mancubus\\random20.mp3",
    //mancubus

    "*doom2016\\music\\Argent_Facility.mp3",
	"*doom2016\\music\\The_Beginning.mp3",
	"*doom2016\\music\\Combat_UAC_C.mp3",
	"*doom2016\\music\\Violence.mp3",
	"*doom2016\\music\\Hell_Guard.mp3",
	"*doom2016\\music\\Blood_Gore.mp3",
	"*doom2016\\music\\lazarus.mp3",
    "*doom2016\\music\\Rip_Tear.mp3",
	"*doom2016\\music\\Tower_Ascension.mp3",
	"*doom2016\\music\\humanwin.mp3",
    //music

	//bfg
	"*doom2016\\items\\hm\\bfg\\pickedup.mp3",
	"*doom2016\\items\\hm\\bfg\\shoot.mp3",
	"*doom2016\\items\\hm\\bfg\\explode.mp3",

    //riffle
	"*doom2016\\items\\hm\\heavycannon\\pickedup.mp3",
	"*doom2016\\items\\hm\\heavycannon\\shoot.mp3",
	"*doom2016\\items\\hm\\heavycannon\\reload.mp3",

	//chaingun
	"*doom2016\\items\\hm\\minigun\\pickedup.mp3",
	"*doom2016\\items\\hm\\minigun\\shoot.mp3",
	"*doom2016\\items\\hm\\minigun\\reload.mp3",

	//totem
	"*doom2016\\sounds\\hearts1.mp3",

	//plasmagun
	"*doom2016\\items\\hm\\plasma\\pickedup.mp3",
	"*doom2016\\items\\hm\\plasma\\shoot.mp3",
	"*doom2016\\items\\hm\\plasma\\reload.mp3",

	//heal
	"*doom2016\\items\\hm\\heal\\pickedup.mp3",
	"*doom2016\\items\\hm\\heal\\heal.mp3",

    //rocket
	"*doom2016\\items\\hm\\rocket\\pickedup.mp3",
    "*doom2016\\items\\hm\\rocket\\shoot.mp3",
	"*doom2016\\items\\hm\\rocket\\reload.mp3",

    //shootgun
	"*doom2016\\items\\hm\\shootgun\\pickedup.mp3",
    "*doom2016\\items\\hm\\shootgun\\shoot.mp3",

    //ballista
	"*doom2016\\items\\hm\\ballista\\pickedup.mp3",
    "*doom2016\\items\\hm\\ballista\\shoot.mp3",


	//Ambient sounds
	"*doom2016\\ambient\\doctor\\disable_argent_tower.mp3",
	"*doom2016\\ambient\\doctor\\found_pda.mp3",
	"*doom2016\\ambient\\doctor\\i_not_have_choise.mp3",
	"*doom2016\\ambient\\doctor\\if_not_closed_portal.mp3",
	"*doom2016\\ambient\\doctor\\kill_all_exit.mp3",
	"*doom2016\\ambient\\doctor\\office_doctor.mp3",
	"*doom2016\\ambient\\doctor\\olivia_activated_portal.mp3",
	"*doom2016\\ambient\\doctor\\olivia_used_portal.mp3",
	"*doom2016\\ambient\\doctor\\otvetstvennost.mp3",
	"*doom2016\\ambient\\doctor\\portal_with_accum.mp3",
	"*doom2016\\ambient\\doctor\\primary_control.mp3",
	"*doom2016\\ambient\\doctor\\tryed_to_kill.mp3",
	"*doom2016\\ambient\\girl\\acces_denied.mp3",
	"*doom2016\\ambient\\girl\\acces_grandted.mp3",
	"*doom2016\\ambient\\girl\\demonic_snijeno.mp3",
	"*doom2016\\ambient\\girl\\demons_obnarusj.mp3",
	"*doom2016\\ambient\\girl\\temperature_core.mp3",
	"*doom2016\\ambient\\girl\\terminal_activated.mp3",
	"*doom2016\\ambient\\olivia\\about_doomguy.mp3",
	"*doom2016\\ambient\\uac\\about_uac.mp3",
	"*doom2016\\ambient\\uac\\nabor_v_uac.mp3",
	"*doom2016\\ambient\\uac\\uac.mp3",
	"*doom2016\\ambient\\uac\\uac_the_best.mp3",
	"*doom2016\\ambient\\uac\\working_uac.mp3",
	"*doom2016\\ambient\\vega\\acces_denied1.mp3",
	"*doom2016\\ambient\\vega\\all_doors_closed.mp3",
	"*doom2016\\ambient\\vega\\core_temperature.mp3",
	"*doom2016\\music\\pdapick.mp3",
];
function Precache()
{
    for (local i=0; i<SoundsPrecache.len(); i++)
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


function test()
{
  local handle = null;
  local c = 0;
	while (null != (handle = Entities.FindByClassname(handle , "water_lod_control")))
	{
		ScriptPrintMessageChatAll(c.tostring()+") "+handle.GetName()+" : "+handle.GetOrigin().x+" "+handle.GetOrigin().y+" "+handle.GetOrigin().z.tostring())
    //ScriptPrintMessageChatAll("Model : "+handle.GetModelName().tostring())
    ScriptPrintMessageChatAll("------------");
    c++;
	}
}