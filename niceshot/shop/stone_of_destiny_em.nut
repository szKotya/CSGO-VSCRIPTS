DEBUG <- false;
LEVEL_R <- 1;
TOWER_D_HEALTH <- 100; 
TOWER_D_NODAMAGE <- false;
LEVEL_SAY <- [
    "[Armor Lvl-1] [Speed-200] [Typ-Ground Unit]",
    "[Armor Lvl-1] [Speed-400] [Typ-Air Unit]",
    "[Armor Lvl-1] [Speed-250] [Typ-Ground Unit]",
    "[Armor Lvl-1] [Typ-Boss]",
    "[Armor Lvl-1] [Speed-250] [Typ-Ground Unit]",
    "[Armor Lvl-1] [Speed-400] [Typ-Air Unit]",
    "[Armor Lvl-2] [Speed-200] [Typ-Tank Unit]",
    "[Armor Lvl-?] [Typ-Boss]",
    "[Armor Lvl-1] [Speed-275] [Typ-Ground Unit]",
    "[Armor Lvl-1] [Speed-375] [Typ-Air Unit]",
    "[Armor Lvl-3] [Speed-275] [Typ-Tank Unit]",
    "[Armor Lvl-?] [Typ-Boss]",
    "[Armor Lvl-1] [Speed-275] [Typ-Ground Unit]",
    "[Armor Lvl-3] [Speed-350] [Typ-Air Tank Unit]",
    "[Armor Lvl-3] [Speed-300] [Typ-Tank Unit]",
    "[Armor Lvl-?] [Typ-Boss]",
    "[Armor Lvl-2] [Speed-300] [Typ-Ground Unit]",
    "[Armor Lvl-2] [Speed-325] [Typ-Ground Unit]",
    "[Armor Lvl-3] [Speed-400] [Typ-Tank Unit]"
];

LEVEL_HP <- [
    [0,0],
    [50,18],
    [50,15],
    [75,15],
    [5000,575], //first boss 
    [100,25],
    [125,10],
    [325,25],
    [6500,1500], //second boss
    [225,30],
    [180,20],
    [350,30],
    [30000,2500], //three boss
    [275,25],
    [335,28],
    [375,25],
    [45000,1250], //four boss
    [250,32],
    [250,34],
    [125,40],
    [1,1],
    [900,25], // boss_4_1_hit_box //21
    [350,30], // boss_4_2_hit_box //22
    [500,40],// boss_4_3_hit_box //23
    [20000,3250] //last boss
];

::WeaponClass <- {
    function getweaponammo(w){foreach (i,v in this){if(w == i){return v;}}}
    weapon_glock = 20
    weapon_ak47 = 30
    weapon_aug = 30
    weapon_bizon = 64
    weapon_m4a1 = 30
    weapon_mp9 = 30
    weapon_negev = 150
    weapon_p90 = 50
    weapon_elite = 30
    weapon_fiveseven = 20
    weapon_tec9 = 25
    weapon_deagle = 7
};

::WEAPONS_ARR_GE <- [
    ["item_assaultsuit", null],
    ["weapon_deagle", null],
    ["weapon_elite", null],
    ["weapon_fiveseven", null],
    ["weapon_tec9", null],
    ["weapon_mp9", null],
    ["weapon_bizon", null],
    ["weapon_p90", null],
    ["weapon_ak47", null],
    ["weapon_m4a1", null],
    ["weapon_aug", null],
    ["weapon_negev", null]
]

::BOSS_4_1 <- 0;
::BOSS_4_2 <- 0;
::BOSS_4_3 <- 0;

::CURRENT_UNIT_HP <- 0;
// ::SHOP_MAX_SLOTS_F <- 5;
::SHOP_SCRIPT_PATH <- "stone_of_destiny/map_shop.nut";
BOSS_ENT_GLOBAL <- null;
TOTAL_KILLS <- 0;

MAPPER_SID <- ["STEAM_1:0:161274095","STEAM_1:1:30274704"]; 
::PLAYERS <- [];
// ::BACKUP_DATA <- []; // NOT USED
PL_HANDLE <- [];
TEMP_HANDLE <- null;
MAPPER_COMMANDS <- true;
AUTO_RETRY <- true;

eventinfo <- null;
eventproxy <- null;
eventlist <- null;
eventdis <- null;
eventsay <- null;
g_zone <- null;
client_ent <- null;
round_end_ent <- null;
personal_text <- null;
::hud_w_text <- null;
::speed_ent <- null;
::IsBossFight <- false;
boss_hp_text <- null;
::shop_control_gtext <- null;

T_Player_Check <- 5.00;

function MapStart()
{
    BOSS_ENT_GLOBAL = null;
    LEVEL_R = 1;
    TOWER_D_HEALTH = 100;
    TOWER_D_NODAMAGE = false;
    SendToConsoleServer("sv_disable_radar 1");
	SendToConsoleServer("sv_infinite_ammo 2");
    for(local i = 0; i < WEAPONS_ARR_GE.len(); i++)
    {
        local gm_e = Entities.FindByName(null, WEAPONS_ARR_GE[i][0]);
        if(gm_e != null && gm_e.IsValid()){WEAPONS_ARR_GE[i][1] = gm_e;}
    }
    for(local i = 0; i < PLAYERS.len(); i++){PLAYERS[i].ClearClassData();}
    if(personal_text == null || personal_text != null && !personal_text.IsValid()){personal_text = Entities.FindByName(null, "personal_text");}
    if(boss_hp_text == null || boss_hp_text != null && !boss_hp_text.IsValid())
    {
        boss_hp_text = Entities.FindByName(null, "boss_hptextbar");
        // boss_hp_text = Entities.CreateByClassname("game_text");
        // boss_hp_text.__KeyValueFromString("targetname", "boss_hptextbar");
        // boss_hp_text.__KeyValueFromInt("channel", 0);
        // boss_hp_text.__KeyValueFromVector("color", Vector(200, 50, 50));
        // boss_hp_text.__KeyValueFromFloat("y", 0.20);
        // boss_hp_text.__KeyValueFromFloat("x", -1.00);
        // boss_hp_text.__KeyValueFromInt("effect", 0);
        // boss_hp_text.__KeyValueFromInt("spawnflags", 1);
        // boss_hp_text.__KeyValueFromInt("fadein", 0);
        // boss_hp_text.__KeyValueFromInt("fadeout", 0);
        // boss_hp_text.__KeyValueFromInt("fxtime", 0);
        // boss_hp_text.__KeyValueFromFloat("holdtime", 1.00);
        // boss_hp_text.__KeyValueFromString("message", "TEST");
    }
    if(shop_control_gtext == null || shop_control_gtext != null && !shop_control_gtext.IsValid())
    {
        shop_control_gtext = Entities.CreateByClassname("game_text");
        shop_control_gtext.__KeyValueFromString("targetname", "shop_control_gtext");
        shop_control_gtext.__KeyValueFromInt("channel", 0);
        shop_control_gtext.__KeyValueFromVector("color", Vector(127, 255, 212));
        shop_control_gtext.__KeyValueFromFloat("y", 0.50);
        shop_control_gtext.__KeyValueFromFloat("x", -1.00);
        shop_control_gtext.__KeyValueFromInt("effect", 0);
        shop_control_gtext.__KeyValueFromInt("spawnflags", 0);
        shop_control_gtext.__KeyValueFromInt("fadein", 0);
        shop_control_gtext.__KeyValueFromInt("fadeout", 0);
        shop_control_gtext.__KeyValueFromInt("fxtime", 0);
        shop_control_gtext.__KeyValueFromFloat("holdtime", 10.00);
        shop_control_gtext.__KeyValueFromString("message", "SHOP CONTROL\n"+
        "W/S - MOVE (UP / DOWN)\n"+
        "RIGHT CLICK BUTTON - SELECT\n"+
        "LEFT CLICK BUTTON - UNSELECT\n"+
        "TURN OFF SHOP - JUMP/E/LEFT CLICK BUTTON ON MAIN MENU");
    }
    if(eventinfo == null || eventinfo != null && !eventinfo.IsValid()){eventinfo = Entities.FindByName(null, "pl_ginfo");}
    if(eventsay == null || eventsay != null && !eventsay.IsValid()){eventsay = Entities.FindByName(null, "pl_say");}
    if(eventproxy == null || eventproxy != null && !eventproxy.IsValid()){eventproxy = Entities.FindByClassname(null, "info_game_event_proxy");}
    if(g_zone == null || g_zone != null && !g_zone.IsValid()){g_zone = Entities.FindByName(null, "check_players");}
    if(speed_ent == null || speed_ent != null && !speed_ent.IsValid())
    {
        speed_ent = Entities.FindByClassname(null, "player_speedmod");
        if(speed_ent == null){speed_ent = Entities.CreateByClassname("player_speedmod");}
    }
    if(hud_w_text == null || hud_w_text != null && !hud_w_text.IsValid()){hud_w_text = Entities.CreateByClassname("env_hudhint");}
    if(round_end_ent == null || round_end_ent != null && !round_end_ent.IsValid())
    {
        round_end_ent = Entities.FindByClassname(null, "game_round_end");
        if(round_end_ent == null){round_end_ent = Entities.CreateByClassname("game_round_end")}
    }
    local honk_ent = null;
    while((honk_ent = Entities.FindByName(honk_ent, "honk")) != null)
    {
        honk_ent.__KeyValueFromString("glowcolor", "0 255 0");
        honk_ent.__KeyValueFromInt("glowenabled", 1);
        honk_ent.__KeyValueFromInt("glowstyle", 0);
        honk_ent.__KeyValueFromInt("glowdist", 1024);
    }
    UpdatePersonalText();
    LoopPlayerCheck();
    UpdateAmmo();
    UpdateSpeed();
    MapShopUpdateCheck();
}

::DataEnt_S <- function()
{
    printl(format("Ent Name: %s | Ent Index: %d | Ent Health: %d", self.GetName(), self.entindex(), self.GetHealth()));
}

function DamageTower()
{
    if(!TOWER_D_NODAMAGE && TOWER_D_HEALTH > 0)
    {
        TOWER_D_HEALTH--;
        ScriptPrintMessageChatAll(RandomColorChat()+" [-"+TOWER_D_HEALTH+"-] Lifes left ...");
        if(TOWER_D_HEALTH <= 0)
        {
            local b_end_ent = Entities.FindByName(null, "Death_button");
            EntFireByHandle(b_end_ent, "UnLock", "", 0.00, null, null);
            TOWER_D_HEALTH = 0;
            EntFireByHandle(b_end_ent, "Press", "", 0.02, null, null);
        }
    }
}

function ToggleDamageTower()
{
    if(!TOWER_D_NODAMAGE){TOWER_D_NODAMAGE = true;}
    else{TOWER_D_NODAMAGE = false;}
}

function XIX_START(n)
{
    local ExtraCash = 0;
	LEVEL_R = n;
    local LastLevel = LEVEL_R - 1;
    if(LastLevel >= 1 && LastLevel <= 3){ExtraCash = 20;}
    else if(LastLevel >= 4 && LastLevel <= 7){ExtraCash = 25;}
    else if(LastLevel >= 9 && LastLevel <= 11){ExtraCash = 30;}
    else if(LastLevel >= 13 && LastLevel <= 15){ExtraCash = 35;}
    else if(LastLevel >= 17 && LastLevel <= 19){ExtraCash = 40;}
    if(LastLevel > 0){AddMoneyAllPlayers(ExtraCash);}
    if(LEVEL_R <= 0 || LEVEL_R > 25){return;}
    local PLAYERS_A = GetAlivePlayersCount();
    if(PLAYERS_A < 1){PLAYERS_A = 1;}
    local Multiplicator = LEVEL_HP[LEVEL_R][0] - LEVEL_HP[LEVEL_R][0] / (PLAYERS_A / 100 + 2);
    CURRENT_UNIT_HP = Multiplicator + (LEVEL_HP[LEVEL_R][1] * PLAYERS_A);
    if(CURRENT_UNIT_HP <= 0){CURRENT_UNIT_HP = 1;}
    if(LEVEL_R <= 19)
    {
        ScriptPrintMessageChatAll(" \x04 [XIX Tower Defense v2] [Lvl-"+LEVEL_R+"] "+"[HP-"+CURRENT_UNIT_HP+"]"+RandomColorChat()+" "+LEVEL_SAY[LEVEL_R-1]);
    }
    local Boss_Ent = null;
    if(LEVEL_R == 4)
    {
        ToggleBossFight();
        if(Boss_Ent == null || Boss_Ent != null && !Boss_Ent.IsValid()){Boss_Ent = Entities.FindByName(null, "boss_1_hitpoint*");}
        if(DEBUG){printl("FOUND BOSS HITBOX: "+Boss_Ent+" | ROUND: "+LEVEL_R);}
    }
    else if(LEVEL_R == 8)
    {
        if(Boss_Ent == null || Boss_Ent != null && !Boss_Ent.IsValid()){Boss_Ent = Entities.FindByName(null, "boss_2_hitpoints*");}
        if(DEBUG){printl("FOUND BOSS HITBOX: "+Boss_Ent+" | ROUND: "+LEVEL_R);}
    }
    else if(LEVEL_R == 12)
    {
        ToggleBossFight();
        if(Boss_Ent == null || Boss_Ent != null && !Boss_Ent.IsValid()){Boss_Ent = Entities.FindByName(null, "boss_3_hit_box*");}
        if(DEBUG){printl("FOUND BOSS HITBOX: "+Boss_Ent+" | ROUND: "+LEVEL_R);}
    }
    else if(LEVEL_R == 16)
    {
        if(Boss_Ent == null || Boss_Ent != null && !Boss_Ent.IsValid()){Boss_Ent = Entities.FindByName(null, "bossxy_hitpoints*");}
        if(DEBUG){printl("FOUND BOSS HITBOX: "+Boss_Ent+" | ROUND: "+LEVEL_R);}
    }
    else if(LEVEL_R >= 20 && LEVEL_R < 24)
    {
        local players_c = 0;
        for(local i = 0; i < PLAYERS.len(); i++){if(PLAYERS[i].handle != null && PLAYERS[i].handle.IsValid() && PLAYERS[i].handle.GetHealth() > 0){players_c++;}}
        BOSS_4_1 = LEVEL_HP[21][0] + (LEVEL_HP[21][1] * players_c);
        BOSS_4_2 = LEVEL_HP[22][0] + (LEVEL_HP[22][1] * players_c);
        BOSS_4_3 = LEVEL_HP[23][0] + (LEVEL_HP[23][1] * players_c);
        printl("BOSS_4_1 = "+BOSS_4_1+" | BOSS_4_2 = "+BOSS_4_2+" | BOSS_4_3 = "+BOSS_4_3);
    }
    else if(LEVEL_R == 24)
    {
        if(Boss_Ent == null || Boss_Ent != null && !Boss_Ent.IsValid()){Boss_Ent = Entities.FindByName(null, "boss_4_4_hit_box*");}
        if(DEBUG){printl("FOUND BOSS HITBOX: "+Boss_Ent+" | ROUND: "+LEVEL_R);}
    }
    if(Boss_Ent != null && Boss_Ent.IsValid())
    {
        EntFireByHandle(Boss_Ent, "SetHealth", ""+CURRENT_UNIT_HP, 0.00, null, null);
        BOSS_ENT_GLOBAL = Boss_Ent;
        ShowBossHpBar();
    }
}

function BreakNpc()
{
    try
    {
        if(activator.IsValid() && activator.GetHealth() > 0)
        {
            TOTAL_KILLS++;
            local Earning = 0;
            if(LEVEL_R >= 1 && LEVEL_R <= 3){Earning = 1;}
            else if(LEVEL_R >= 5 && LEVEL_R <= 7){Earning = 2;}
            else if(LEVEL_R >= 9 && LEVEL_R <= 11){Earning = 3;}
            else if(LEVEL_R >= 13 && LEVEL_R <= 15){Earning = 4;}
            else if(LEVEL_R >= 17 && LEVEL_R <= 19){Earning = 5;}
            if(Earning <= 0)return;
            AddMoneyByActivator(Earning);
        }
    }
    catch(error)
    {
        if(DEBUG){printl("error: "+error);}
        return;
    }
}

function UpdatePersonalText()
{
    if(personal_text == null || personal_text != null && !personal_text.IsValid())return;
    EntFireByHandle(self, "RunScriptCode", "UpdatePersonalText();", 1.00, null, null);
    if(PLAYERS.len() <= 0){return;}
    for(local i = 0; i < PLAYERS.len(); i++)
    {
        if(PLAYERS[i].handle != null && PLAYERS[i].handle.IsValid())
        {
            local text = "money: "+PLAYERS[i].money+"$"//+"\nUSER_ID:"+PL_BASE[i].userid;
            EntFireByHandle(personal_text, "SetText", text.tostring(), 0.00, null, null);
            EntFireByHandle(personal_text, "Display", "", 0.00, PLAYERS[i].handle, null);
        }
    }
}

function RandomChestUP()
{
    local rnd_p = RandomInt(0, 200);
    if(rnd_p <= 50)
    {
        EntFire("win_ammo_temp", "ForceSpawn", "", 0.00, null);
		EntFire("truhen_light", "Color", "255 255 0", 0.00, null);
        EntFireByHandle(self, "RunScriptCode", "ExtraLvlUpAmmo();", 30.00, null, null);
    }
    else if(rnd_p > 50 && rnd_p <= 100)
    {
        EntFire("win_extra_cash_temp", "ForceSpawn", "", 0.00, null);
		EntFire("truhen_light", "Color", "0 255 0", 0.00, null);
        local rnd_c = RandomInt(0, 100);
        local cash_n = 0;
        if(rnd_c <= 30){cash_n = 25;}
        else if(rnd_c > 30 && rnd_c <= 50){cash_n = 50;}
        else if(rnd_c > 50 && rnd_c <= 80){cash_n = 75;}
        else if(rnd_c > 80 && rnd_c <= 90){cash_n = 100;}
        else if(rnd_c > 90 && rnd_c <= 99){cash_n = 200;}
        else if(rnd_c > 99 && rnd_c <= 100){cash_n = 500;}
        EntFire("win_extra_cash", "AddOutput", "message +"+cash_n+"$ EXTRA CASH!", 3.00, null);
        EntFireByHandle(self, "RunScriptCode", "ExtraCash("+cash_n+");", 30.00, null, null);
    }
    else if(rnd_p > 100 && rnd_p <= 150)
    {
        EntFire("win_hitpoints_temp", "ForceSpawn", "", 0.00, null);
		EntFire("truhen_light", "Color", "255 0 0", 0.00, null);
        EntFireByHandle(self, "RunScriptCode", "ExtraLvlUpHeal();", 30.00, null, null);
    }
    else if(rnd_p > 150 && rnd_p <= 200)
    {
        EntFire("win_speedup_temp", "ForceSpawn", "", 0.00, null);
		EntFire("truhen_light", "Color", "128 128 255", 0.00, null);
        EntFireByHandle(self, "RunScriptCode", "ExtraLvlUpSpeed();", 30.00, null, null);
    }
}

function UpdateAmmo()
{
    EntFireByHandle(self, "RunScriptCode", "UpdateAmmo();", 15.00, null, null);
    if(PLAYERS.len() <= 0){return;}
    for(local i = 0; i < PLAYERS.len(); i++)
    {
        if(PLAYERS[i].handle != null && PLAYERS[i].handle.IsValid() && PLAYERS[i].GetAmmoLevel() > 0){PLAYERS[i].SetAmmo();}
    }
}

function UpdateSpeed()
{
    EntFireByHandle(self, "RunScriptCode", "UpdateSpeed();", 5.00, null, null);
    if(PLAYERS.len() <= 0){return;}
    for(local i = 0; i < PLAYERS.len(); i++){PLAYERS[i].SetSpeed();}
}

function ExtraCash(n)
{
    if(PLAYERS.len() <= 0){return;}
    for(local i = 0; i < PLAYERS.len(); i++){PLAYERS[i].AddMoney(n);}
}

function ExtraLvlUpAmmo()
{
    if(PLAYERS.len() <= 0){return;}
    for(local i = 0; i < PLAYERS.len(); i++){PLAYERS[i].UpAmmoLevel();}
}

function ExtraLvlUpHeal()
{
    if(PLAYERS.len() <= 0){return;}
    for(local i = 0; i < PLAYERS.len(); i++){PLAYERS[i].UpHealLevel();}
}

function ExtraLvlUpSpeed()
{
    if(PLAYERS.len() <= 0){return;}
    for(local i = 0; i < PLAYERS.len(); i++){PLAYERS[i].UpSpeedLevel();}
}

function ShowBossHpBar()
{
    if(boss_hp_text == null || !boss_hp_text.IsValid())return;
    if(BOSS_ENT_GLOBAL != null && BOSS_ENT_GLOBAL.IsValid() && BOSS_ENT_GLOBAL.GetHealth() > 0)
    {
        local percent = 100 * BOSS_ENT_GLOBAL.GetHealth() / CURRENT_UNIT_HP;
        boss_hp_text.__KeyValueFromString("message", "BOSS HP: "+BOSS_ENT_GLOBAL.GetHealth()+" | ("+percent+"%)");
        EntFireByHandle(boss_hp_text, "Display", "", 0.00, null, null);
        EntFireByHandle(self, "RunScriptCode", "ShowBossHpBar();", 0.75, null, null);
    }
    else
    {
        boss_hp_text.__KeyValueFromString("message", "BOSS HP: 0 | (0%)");
        EntFireByHandle(boss_hp_text, "Display", "", 0.00, null, null);
        return BOSS_ENT_GLOBAL=null;
    }
}

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
    constructor(_userid,_name,_steamid)
	{
		userid = _userid;
		name = _name;
		steamid = _steamid;
	}
    pl_checked_r = 0;
    function ValidThisH()
    {
        if(this.handle == null || this.handle != null && !this.handle.IsValid()){return false;}
        else{return true;}
    }
    function GetCheckedCPl(){return this.pl_checked_r;}
    function ClearClassData()
    {
        this.pl_checked_r++;
        this.noclip = false;
        this.money = 0;
        this.ammo_level = 0;
        this.heal_level = 0;
        this.max_health = 100;
        this.speed_level = 0;
        this.IsInShop = false;
        this.map_shop_hud = null;
        this.map_shop_ent = null;
        this.purchased_weapon_slot_1 = null;
        this.purchased_weapon_slot_2 = null;
        this.tick_money = 0;
        this.max_tick_money = 10;
        // this.map_shop_menu_selected = 0;
        // this.map_shop_tick_buy_item = 0;
        // this.map_shop_max_tick_bi = 20;
        // this.map_shop_text_buy_item = "";
        this.map_shop_colldown = 60;
        this.map_shop_colldown_tick = 0.00;
        // for(local i = 0; i < this.SHOP_MENU_SLOTS.len(); i++){if(this.SHOP_MENU_SLOTS[i][1]){this.SHOP_MENU_SLOTS[i][1] = false;}}
        if(this.pl_checked_r > 3){this.pl_checked_r = 3;}
    }
    handle = null;
    mapper = false;
    noclip = false;
    tick_money = 0;
    max_tick_money = 10;
    money = 0;
    max_money = 1000;
    ammo_level = 0;
    max_ammo_level = 10;
    heal_level = 0;
    max_health = 100;
    max_heal_level = 5;
    speed_level = 0;
    max_speed_level = 10;
    purchased_weapon_slot_1 = null;
    purchased_weapon_slot_2 = null;
    purchased_weapon_slot_3 = null; //for kevlar
    //////////////////////////
    ///////////SHOP///////////
    //////////////////////////

    ////////////////////////////////////////////////////////
    ///////////////////////...........//////////////////////
    ////////////////////////////////////////////////////////
    IsInShop = false;
    map_shop_hud = null;
    map_shop_ent = null;
    // map_shop_menu_selected = 0;
    // map_shop_max_menu_slots = SHOP_MAX_SLOTS_F;
    // map_shop_tick_buy_item = 0;
    // map_shop_max_tick_bi = 20;
    // map_shop_text_buy_item = "";
    map_shop_colldown = 60;
    map_shop_colldown_tick = 0.00;

    // SHOP_MENU_SLOTS = [
    //     ["Weapon Menu",false,"Desert Eagle (30$)","Elite (30$)","Five-SeveN (35$)","Tec9 (50$)","Mp9 (75$)","Bizon (75$)","P90 (100$)","Ak47 (200$)","M4a1 (200$)","Aug (250$)","Negev (500$)"],
    //     ["Health Menu",false,"FULL (1HP = 1$)","10 HP (10$)","25 HP (25$)","50 HP (50$)","75 HP (75$)","100 HP (100$)"],
    //     ["Upgrade Heal",false,"UPGRADE HEAL LEVEL"],
    //     ["Upgrade Ammo",false,"UPGRADE AMMO LEVEL"],
    //     ["Upgrade Speed",false,"UPGRADE SPEED LEVEL"],
    //     ["Lucky Money",false,"YES (Do you want to set all your money for a\n50 % chance to win the double or loose all? (MOUSE 2 (NO))"],
    // ]

    // SHOP_SELECTED_S <- [
    //     "deagle (30$)",
    //     "elite (30$)",
    //     "fiveseven (35$)",
    //     "tec9 (50$)",
    //     "mp9 (75$)",
    //     "bizon (75$)",
    //     "p90 (100$)",
    //     "ak47 (200$)",
    //     "m4a1 (200$)",
    //     "aug (250$)",
    //     "negev (500$)",
    //     "10 HP (10$)",
    //     "25 HP (25$)",
    //     "50 HP (50$)",
    //     "75 HP (75$)",
    //     "100 HP (100$)",
    //     "FULL (1HP = 1$)",
    //     "UPGRADE HEAL LEVEL",
    //     "UPGRADE AMMO LEVEL",
    //     "UPGRADE SPEED LEVEL",
    //     "YES (Do you want to set all your money for a\n50 % chance to win the double or loose all? (MOUSE 2 (NO))"
    // ]

    // function this.map_shop_ent.GetScriptScope().GetArrPByS(arr_i=null, arr_bs=null, buy_i=null)
    // {
    //     local arr_s = []
    //     if(buy_i != null)
    //     {
    //         if(this.map_shop_tick_buy_item == 0)
    //         {
    //             this.map_shop_tick_buy_item = this.map_shop_max_tick_bi;
    //             this.map_shop_text_buy_item = buy_i;
    //         }
    //     }
    //     if(this.map_shop_tick_buy_item > 0)
    //     {
    //         arr_s.push(this.map_shop_text_buy_item);
    //         this.map_shop_menu_selected = 0;
    //         for(local i = 0; i < this.SHOP_MENU_SLOTS.len(); i++){if(this.SHOP_MENU_SLOTS[i][1]){this.SHOP_MENU_SLOTS[i][1] = false;}}
    //         this.map_shop_tick_buy_item--;
    //         return arr_s;
    //     }
    //     this.map_shop_text_buy_item = "";
    //     if(arr_i != null, arr_bs != null)
    //     {
    //         this.SHOP_MENU_SLOTS[arr_i][1] = arr_bs;
    //     }
    //     if(this.SHOP_MENU_SLOTS.len() > 0)
    //     {
    //         local exist_t = false;
    //         for(local i = 0; i < this.SHOP_MENU_SLOTS.len(); i++)
    //         {
    //             if(this.SHOP_MENU_SLOTS[i][1])
    //             {
    //                 exist_t = true;
    //                 for(local a = 0; a < this.SHOP_MENU_SLOTS[i].len(); a++)
    //                 {
    //                     if(a != 0 && type(this.SHOP_MENU_SLOTS[i][a]) != "bool")
    //                     {
    //                         if(this.SHOP_MENU_SLOTS[i][a].find("UPGRADE HEAL LEVEL") != null)
    //                         {
    //                             this.SHOP_MENU_SLOTS[i][a] = "UPGRADE HEAL LEVEL | YOUR LEVEL "+this.GetHealLevel()+" | NEXT LEVEL COSTS "+this.GetHealCost()+" | MAX LEVEL "+this.max_heal_level;
    //                         }
    //                         if(this.SHOP_MENU_SLOTS[i][a].find("UPGRADE AMMO LEVEL") != null)
    //                         {
    //                             this.SHOP_MENU_SLOTS[i][a] = "UPGRADE AMMO LEVEL | YOUR LEVEL "+this.GetAmmoLevel()+" | NEXT LEVEL COSTS "+this.GetAmmoCost()+" | MAX LEVEL "+this.max_ammo_level;
    //                         }
    //                         if(this.SHOP_MENU_SLOTS[i][a].find("UPGRADE SPEED LEVEL") != null)
    //                         {
    //                             this.SHOP_MENU_SLOTS[i][a] = "UPGRADE SPEED LEVEL | YOUR LEVEL "+this.GetSpeedLevel()+" | NEXT LEVEL COSTS "+this.GetSpeedCost()+" | MAX LEVEL "+this.max_speed_level;
    //                         }
    //                         arr_s.push(this.SHOP_MENU_SLOTS[i][a]);
    //                     }
    //                 }
    //             }
    //         }
    //         if(!exist_t){for(local i = 0; i < this.SHOP_MENU_SLOTS.len(); i++){arr_s.push(this.SHOP_MENU_SLOTS[i][0]);}}
    //         return arr_s;
    //     }
    //     return null;
    // }

    // function BuyStuff()
    // {
        // "deagle (30$)",
    //     "elite (30$)",
    //     "fiveseven (35$)",
    //     "tec9 (50$)",
    //     "mp9 (75$)",
    //     "bizon (75$)",
    //     "p90 (100$)",
    //     "ak47 (200$)",
    //     "m4a1 (200$)",
    //     "aug (250$)",
    //     "negev (500$)",
    //     "10 HP (10$)",
    //     "25 HP (25$)",
    //     "50 HP (50$)",
    //     "75 HP (75$)",
    //     "100 HP (100$)",
    //     "FULL (1HP = 1$)",
    //     "UPGRADE HEAL LEVEL",
    //     "UPGRADE AMMO LEVEL",
    //     "UPGRADE SPEED LEVEL",
    //     "YES (Do you want to set all your money for a\n50 % chance to win the double or loose all? (MOUSE 2 (NO))"
    //     if(this.SHOP_MENU_SLOTS[0][1]){this.BuyWeapon(this.map_shop_menu_selected, this.GetWeaponCost(this.map_shop_menu_selected+2));}
    //     if(this.SHOP_MENU_SLOTS[1][1]){this.BuyHealth(this.map_shop_menu_selected);}
    //     if(this.SHOP_MENU_SLOTS[2][1]){this.BuyHealthUpGrade(this.SHOP_MENU_SLOTS[2][this.map_shop_menu_selected+2], this.GetHealCost());}
    //     if(this.SHOP_MENU_SLOTS[3][1]){this.BuyAmmoUpGrade(this.SHOP_MENU_SLOTS[3][this.map_shop_menu_selected+2], this.GetAmmoCost());}
    //     if(this.SHOP_MENU_SLOTS[4][1]){this.BuySpeedUpGrade(this.SHOP_MENU_SLOTS[4][this.map_shop_menu_selected+2], this.GetSpeedCost());}
    //     if(this.SHOP_MENU_SLOTS[5][1]){this.LuckyMoney();}
    // }

    function OpenShop()
    {
        if(this.map_shop_colldown_tick > 0 && !this.IsMapper())
        {
            if(hud_w_text != null && hud_w_text.IsValid())
            {
                hud_w_text.__KeyValueFromString("message", "Shop is not available yet | Wait "+map_shop_colldown_tick.tointeger()+" more sec");
                EntFireByHandle(hud_w_text, "ShowHudHint", "", 0.00, this.handle, null);
                return;
            }
        }
        if(!this.IsInShop && this.handle != null && this.handle.IsValid() && this.handle.GetHealth() > 0 && this.map_shop_ent == null && this.map_shop_hud == null)
        {
            this.IsInShop = true;
            if(shop_control_gtext != null && shop_control_gtext.IsValid()){EntFireByHandle(shop_control_gtext, "Display", "", 0.00, this.handle, null);}
            this.map_shop_colldown_tick = this.map_shop_colldown;
            this.map_shop_hud = Entities.CreateByClassname("env_hudhint");
            this.map_shop_hud.__KeyValueFromString("targetname", "shop_hud_"+split(this.handle.tostring(), "([])")[0]);
            this.map_shop_ent = Entities.CreateByClassname("game_ui");
            this.map_shop_ent.__KeyValueFromString("targetname", "shop_ui_"+split(this.handle.tostring(), "([])")[0]);
            this.map_shop_ent.__KeyValueFromInt("FieldOfView", -1);
            this.map_shop_ent.__KeyValueFromInt("spawnflags", 448);
            this.map_shop_ent.ValidateScriptScope();
            this.handle.__KeyValueFromInt("movetype", 0);
            EntFireByHandle(this.map_shop_ent, "RunScriptFile", SHOP_SCRIPT_PATH, 0.00, null, null);
            this.map_shop_ent.ConnectOutput("PressedForward", "ShopMoveUp");
            this.map_shop_ent.ConnectOutput("PressedBack", "ShopMoveDown");
            this.map_shop_ent.ConnectOutput("PlayerOff", "ShopPlOff");
            this.map_shop_ent.ConnectOutput("PlayerOn", "ShopPlOn");
            this.map_shop_ent.ConnectOutput("PressedAttack", "ShopPlSelected");
            this.map_shop_ent.ConnectOutput("PressedAttack2", "ShopPlUSelected");
            EntFireByHandle(this.map_shop_ent, "Activate", "", 0.00, this.handle, null);
        }
    }
    function MapShopSubColl(t)
    {
        map_shop_colldown_tick -= t;
        if(map_shop_colldown_tick < 0){map_shop_colldown_tick = 0;}
    }
    // function MapShopUpdateHud()
    // {
    //     if(this.map_shop_hud != null && 
    //     this.map_shop_hud.IsValid() && 
    //     this.map_shop_ent != null && 
    //     this.map_shop_ent.IsValid() && 
    //     this.handle != null &&
    //     this.handle.IsValid() &&
    //     this.handle.GetHealth() > 0)
    //     {
    //         local shop_message = "";
    //         local arr_s = this.map_shop_ent.GetScriptScope().GetArrPByS();
    //         if(arr_s == null || arr_s.len() <= 0)return;
    //         local scroll = this.map_shop_menu_selected >= this.map_shop_max_menu_slots ? abs(this.map_shop_menu_selected - this.map_shop_max_menu_slots) : 0;
    //         for(local i = scroll; i < arr_s.len(); i++)
    //         {
    //             if(i <= (this.map_shop_max_menu_slots + scroll))
    //             {
    //                 if(i == this.map_shop_menu_selected){shop_message += "> "+arr_s[i]+" <\n";}
    //                 else{shop_message += arr_s[i]+"\n";}
    //             }
    //         }
    //         this.map_shop_hud.__KeyValueFromString("message", shop_message);
    //         EntFireByHandle(this.map_shop_hud, "ShowHudHint", "", 0.00, this.handle, null);
    //     }
    //     else
    //     {
    //         if(this.map_shop_hud != null && this.map_shop_hud.IsValid()){this.map_shop_hud.Destroy();}
    //         if(this.map_shop_ent != null && this.map_shop_ent.IsValid()){this.map_shop_ent.Destroy();}
    //         for(local i = 0; i < this.SHOP_MENU_SLOTS.len(); i++){if(this.SHOP_MENU_SLOTS[i][1]){this.SHOP_MENU_SLOTS[i][1] = false;}}
    //         this.map_shop_hud = null;
    //         this.map_shop_ent = null;
    //         this.map_shop_menu_selected = 0;
    //         this.map_shop_max_menu_slots = SHOP_MAX_SLOTS_F;
    //         this.map_shop_text_buy_item = "";
    //         this.map_shop_tick_buy_item = 0;
    //         this.map_shop_max_tick_bi = 20;
    //         this.IsInShop = false;
    //         return;
    //     }
    // }
    ////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////
    
    // function ShopMoveUp()
    // {
    //     this.map_shop_menu_selected--;
    //     if(this.map_shop_menu_selected < 0)
    //     {
    //         this.map_shop_menu_selected = this.map_shop_ent.GetScriptScope().GetArrPByS().len() - 1;
    //     }
    // }

    // function ShopMoveDown()
    // {
    //     this.map_shop_menu_selected++;
    //     if(this.map_shop_menu_selected > this.map_shop_ent.GetScriptScope().GetArrPByS().len() - 1)
    //     {
    //         this.map_shop_menu_selected = 0;
    //     }
    // }

    // function ShopPlOff()
    // {
    //     if(this.map_shop_ent != null && this.map_shop_ent.IsValid()){this.map_shop_ent.Destroy();}
    //     if(this.map_shop_hud != null && this.map_shop_hud.IsValid())
    //     {
    //         EntFireByHandle(this.map_shop_hud, "HideHudHint", "", 0.00, this.handle, null);
    //         this.map_shop_hud.Destroy();
    //     }
    //     for(local i = 0; i < this.SHOP_MENU_SLOTS.len(); i++){if(this.SHOP_MENU_SLOTS[i][1]){this.SHOP_MENU_SLOTS[i][1] = false;}}
    //     this.map_shop_text_buy_item = "";
    //     this.map_shop_tick_buy_item = 0;
    //     this.map_shop_max_tick_bi = 20;
    //     this.map_shop_hud = null;
    //     this.map_shop_ent = null;
    //     this.map_shop_menu_selected = 0;
    //     this.map_shop_max_menu_slots = SHOP_MAX_SLOTS_F;
    //     this.IsInShop = false;
    // }

    // function ShopPlSelected()
    // {
    //     local exist_t = false;
    //     for(local i = 0; i < this.SHOP_MENU_SLOTS.len(); i++)
    //     {
    //         if(this.SHOP_MENU_SLOTS[i][1])
    //         {
    //             exist_t = true;
    //             BuyStuff();
    //         }
    //     }
    //     if(!exist_t){this.map_shop_ent.GetScriptScope().GetArrPByS(this.map_shop_menu_selected, true);}
    //     this.map_shop_menu_selected = 0;
    // }

    // function ShopPlUSelected()
    // {
    //     for(local i = 0; i < this.SHOP_MENU_SLOTS.len(); i++){if(this.SHOP_MENU_SLOTS[i][1]){this.map_shop_ent.GetScriptScope().GetArrPByS(i, false);}}
    //     this.map_shop_menu_selected = 0;
    // }

    //////////////////////////
    //////////////////////////
    //////////////////////////
    
    function GetHealCost()
    {
        if(this.GetHealLevel() < this.max_heal_level)
        {
            return 50;
        }
        return 0;
    }

    function GetAmmoCost()
    {
        switch(this.GetAmmoLevel())
        {
            case 0:{return 5;}
            case 1:{return 15;}
            case 2:{return 35;}
            case 3:{return 65;}
            case 4:{return 105;}
            case 5:{return 155;}
            case 6:{return 215;}
            case 7:{return 285;}
            case 8:{return 365;}
            case 9:{return 455;}
            case 10:{return 0;}
        }
    }
    
    function GetSpeedCost()
    {
        if(this.GetSpeedLevel() < this.max_speed_level)
        {
            return 50;
        }
        return 0;
    }

    function IsMapper()
    {
        if(this.mapper){return true;}
        else{return false;}
    }
    function GetNickName()
    {
        if(this.name == null){return "NULL";}
        else if(this.name == "NOT GETED"){return "uid: "+this.userid;}
        else{return name;}
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
    function GetNoclipThis(){return this.noclip;}
    function ToggleNoclip()
    {
        if(this.noclip){return this.noclip = false;}
        else{return this.noclip = true;}
    }
    function GetMoney(){return this.money;}
    function AddMoney(n)
    {
        if(n <= 0)return;
        this.money += n;
        if(this.money > this.max_money){this.money = this.max_money;}
    }
    function AddTickMoney()
    {
        this.tick_money++;
        if(this.tick_money >= this.max_tick_money)
        {
            this.money++;
            this.tick_money = 0;
            if(this.money > this.max_money){this.money = this.max_money;}
        }
    }
    function SubMoney(n)
    {
        if(n <= 0)return;
        this.money -= n;
        if(this.money < 0){this.money = 0;}
    }
    function SetMoney(n)
    {
        if(n <= 0)return;
        this.money = n;
        if(this.money > this.max_money){this.money = 1000;}
    }
    function SetAmmo()
    {
        local ammo_c = this.GetAmmoLevel() * 20;
        if(this.handle != null && this.handle.IsValid() && this.handle.GetHealth() > 0)
        {
            local list = this.handle.FirstMoveChild();
            local next_w = list.NextMovePeer();
            while(next_w != null)
            {
                if(next_w.GetClassname() in WeaponClass)
                {
                    EntFireByHandle(next_w, "SetAmmoAmount", ""+(WeaponClass.getweaponammo(next_w.GetClassname()) + ammo_c), 0.00, null, null);
                }
                next_w = next_w.NextMovePeer();
            }
        }
    }
    function SetReserveAmmo()
    {
        if(this.handle != null && this.handle.IsValid() && this.handle.GetHealth() > 0)
        {
            local list = this.handle.FirstMoveChild();
            local next_w = list.NextMovePeer();
            while(next_w != null)
            {
                if(next_w.GetClassname() in WeaponClass)
                {
                    EntFireByHandle(next_w, "SetReserveAmmoAmount", "150", 0.00, null, null);
                }
                next_w = next_w.NextMovePeer();
            }
        }
    }
    function AddAmmoLevel(n)
    {
        if(n <= 0)return;
        this.ammo_level += n;
        if(this.ammo_level > this.max_ammo_level){this.ammo_level = this.max_ammo_level;}
    }
    function UpAmmoLevel()
    {
        this.ammo_level++;
        if(this.ammo_level > this.max_ammo_level){this.ammo_level = this.max_ammo_level;}
    }
    function SetAmmoLevel(n)
    {
        if(n <= 0)return;
        this.ammo_level = n;
        if(this.ammo_level > this.max_ammo_level){this.ammo_level = this.max_ammo_level;}
    }
    function GetAmmoLevel()
    {
        return this.ammo_level;
    }
    function AddHealLevel(n)
    {
        if(n <= 0)return;
        this.heal_level += n;
        if(this.heal_level > this.max_heal_level){this.heal_level = this.max_heal_level;}
        this.SetHealthT();
    }
    function SetHealLevel(n)
    {
        if(n <= 0)return;
        this.heal_level = n;
        if(this.heal_level > this.max_heal_level){this.heal_level = this.max_heal_level;}
        this.SetHealthT();
    }
    function UpHealLevel()
    {
        this.heal_level++;
        printl("UP HEAL LEVEL: "+this.GetNickName());
        if(this.heal_level > this.max_heal_level){this.heal_level = this.max_heal_level;}
        this.SetHealthT();
    }
    function GetHealLevel()
    {
        return this.heal_level;
    }
    function RestoreHealth(p)
    {
        if(this.handle.GetHealth() >= this.max_health)
        {
            this.map_shop_ent.GetScriptScope().GetArrPByS(null, null, "You already have max health.");
            return;
        }
        local Restored_Health = 0; //0 = FULL, 1 = 10HP, 2 = 25HP, 3 = 50HP, 4 = 75HP, 5 = 100HP
        if(p == 0){Restored_Health = this.max_health - this.handle.GetHealth();}
        if(p == 1){Restored_Health = 10;}
        if(p == 2){Restored_Health = 25;}
        if(p == 3){Restored_Health = 50;}
        if(p == 4){Restored_Health = 75;}
        if(p == 5){Restored_Health = 100;}
        if(Restored_Health <= 0){return;}
        if(this.GetMoney() < Restored_Health)
        {
            this.map_shop_ent.GetScriptScope().GetArrPByS(null, null, "Not Enough Money, you need "+(Restored_Health-this.GetMoney())+"$");
            return;
        }
        else
        {
            if(p == 0)
            {
                this.SubMoney(Restored_Health);
                this.handle.SetHealth(this.handle.GetHealth() + Restored_Health);
                this.map_shop_ent.GetScriptScope().GetArrPByS(null, null, "Restored "+Restored_Health+" HP");
            }
            else
            {
                this.SubMoney(Restored_Health);
                if(this.handle.GetHealth() + Restored_Health > this.max_health)
                {
                    this.handle.SetHealth(this.max_health);
                }
                else{this.handle.SetHealth(this.handle.GetHealth() + Restored_Health);}
                this.map_shop_ent.GetScriptScope().GetArrPByS(null, null, "Restored "+Restored_Health+" HP");
            }
        }
    }
    function SetHealthT()
    {
        if(this.GetHealLevel() <= 0)return;
        local heal_c = heal_level * 20;
        this.max_health = 100 + heal_c;
        if(this.handle != null && this.handle.IsValid() && this.handle.GetHealth() > 0)
        {
            this.handle.SetMaxHealth(this.max_health);
            if(this.handle.GetHealth() + heal_c > this.max_health){this.handle.SetHealth(this.max_health);}
            else{this.handle.SetHealth(this.handle.GetHealth()+heal_c);}
        }
    }
    function AddSpeedLevel(n)
    {
        if(n <= 0)return;
        this.speed_level += n;
        if(this.speed_level > this.max_speed_level){this.speed_level = this.max_speed_level;}
    }
    function SetSpeedLevel(n)
    {
        if(n <= 0)return;
        this.speed_level = n;
        if(this.speed_level > this.max_speed_level){this.speed_level = this.max_speed_level;}
    }
    function UpSpeedLevel()
    {
        this.speed_level++;
        if(this.speed_level > this.max_speed_level){this.speed_level = this.max_speed_level;}
    }
    function GetSpeedLevel()
    {
        return this.speed_level;
    }
    function SetSpeed()
    {
        if(!IsBossFight && this.GetSpeedLevel() > 0 && this.handle != null && this.handle.IsValid() && this.handle.GetHealth() > 0)
        {
            local speed_m = ((this.GetSpeedLevel() * 10.00) / 100.00 + 1.00).tofloat();
            EntFireByHandle(speed_ent, "ModifySpeed", ""+speed_m, 0.00, this.handle, null);
        }
    }
    function ReturnPurchWeapon()
    {
        if(this.handle != null && this.handle.IsValid() && this.handle.GetHealth() > 0)
        {
            if(this.purchased_weapon_slot_1 != null && this.purchased_weapon_slot_1.IsValid())
            {
                EntFireByHandle(this.purchased_weapon_slot_1, "Use", "", 0.00, this.handle, null);
            }
            if(this.purchased_weapon_slot_2 != null && this.purchased_weapon_slot_2.IsValid())
            {
                EntFireByHandle(this.purchased_weapon_slot_2, "Use", "", 0.00, this.handle, null);
            }
            if(this.purchased_weapon_slot_3 != null && this.purchased_weapon_slot_3.IsValid())
            {
                EntFireByHandle(this.purchased_weapon_slot_3, "Use", "", 0.00, this.handle, null);
            }
        }
    }
    function BuyWeapon(i, m)
    {
        if(this.GetMoney() >= m)
        {
            if(WEAPONS_ARR_GE[i][1] != null && WEAPONS_ARR_GE[i][1].IsValid())
            {   
                local text_w = split(WEAPONS_ARR_GE[i][0], "_");
                if(text_w.len() == 2)
                {
                    this.SubMoney(m);
                    this.map_shop_ent.GetScriptScope().GetArrPByS(null, null, "You bought a "+text_w[0]+" "+text_w[1]+" for "+m+"$")
                    if(WEAPONS_ARR_GE[i][0] == "weapon_deagle" ||
                    WEAPONS_ARR_GE[i][0] == "weapon_elite" ||
                    WEAPONS_ARR_GE[i][0] == "weapon_fiveseven" ||
                    WEAPONS_ARR_GE[i][0] == "weapon_tec9"){this.purchased_weapon_slot_2 = WEAPONS_ARR_GE[i][1];}
                    else if(WEAPONS_ARR_GE[i][0] == "item_assaultsuit"){this.purchased_weapon_slot_3 = WEAPONS_ARR_GE[i][1];}
                    else{this.purchased_weapon_slot_1 = WEAPONS_ARR_GE[i][1];}
                    EntFireByHandle(WEAPONS_ARR_GE[i][1], "Use", "", 0.00, this.handle, null);
                }
                
            }
        }
        else
        {
            this.map_shop_ent.GetScriptScope().GetArrPByS(null, null, "Not Enough Money, you need "+(m-this.GetMoney())+"$");
        }
    }
    function GetWeaponCost(w)
    {
        local weapons = [];
        for(local i = 0; i < this.map_shop_ent.GetScriptScope().SHOP_MENU_SLOTS[0].len(); i++)
        {
            if(type(this.map_shop_ent.GetScriptScope().SHOP_MENU_SLOTS[0][i]) == "string" && this.map_shop_ent.GetScriptScope().SHOP_MENU_SLOTS[0][i].find("$)") != null)
            {
                weapons.push(this.map_shop_ent.GetScriptScope().SHOP_MENU_SLOTS[0][i]);
            }
        }
        for(local i = 0; i < weapons.len(); i++)
        {
            if(this.map_shop_ent.GetScriptScope().SHOP_MENU_SLOTS[0][w] == weapons[i])
            {
                local cv_s = split(weapons[i], "()");
                return cv_s[1].tointeger();
            }
        }
    }
    function BuyHealth(i){RestoreHealth(i)}
    function BuyHealthUpGrade(i, m)
    {
        if(this.GetHealLevel() >= this.max_heal_level)
        {
            this.map_shop_ent.GetScriptScope().GetArrPByS(null, null, "Your heal level is maxed out");
            return;
        }
        if(this.GetMoney() >= m)
        {
            this.SubMoney(m);
            this.UpHealLevel();
            local sp_t = split(i, "|")[0]
            this.map_shop_ent.GetScriptScope().GetArrPByS(null, null, "You bought a "+sp_t.tolower()+" for "+m+"$")
        }
        else{this.map_shop_ent.GetScriptScope().GetArrPByS(null, null, "Not Enough Money, you need "+(m-this.GetMoney())+"$");}
    }
    function BuyAmmoUpGrade(i, m)
    {
        if(this.GetAmmoLevel() >= this.max_ammo_level)
        {
            this.map_shop_ent.GetScriptScope().GetArrPByS(null, null, "Your ammo level is maxed out");
            return;
        }
        if(this.GetMoney() >= m)
        {
            this.SubMoney(m);
            this.UpAmmoLevel();
            local sp_t = split(i, "|")[0]
            this.map_shop_ent.GetScriptScope().GetArrPByS(null, null, "You bought a "+sp_t.tolower()+" for "+m+"$")
        }
        else{this.map_shop_ent.GetScriptScope().GetArrPByS(null, null, "Not Enough Money, you need "+(m-this.GetMoney())+"$");}
    }
    function BuySpeedUpGrade(i, m)
    {
        if(this.GetSpeedLevel() >= this.max_speed_level)
        {
            this.map_shop_ent.GetScriptScope().GetArrPByS(null, null, "Your speed level is maxed out");
            return;
        }
        if(this.GetMoney() >= m)
        {
            this.SubMoney(m);
            this.UpSpeedLevel();
            local sp_t = split(i, "|")[0]
            this.map_shop_ent.GetScriptScope().GetArrPByS(null, null, "You bought a "+sp_t.tolower()+" for "+m+"$")
        }
        else{this.map_shop_ent.GetScriptScope().GetArrPByS(null, null, "Not Enough Money, you need "+(m-this.GetMoney())+"$");}
    }
    function LuckyMoney()
    {
        if(this.GetMoney() <= 0){this.map_shop_ent.GetScriptScope().GetArrPByS(null, null, "You don't have enough money");}
        else if(this.GetMoney() > 500){this.map_shop_ent.GetScriptScope().GetArrPByS(null, null, "You can't use Lucky Money when you have more than 500$");}
        else
        {
            local rnd = RandomInt(0, 100);
            if(rnd <= 50)
            {
                this.map_shop_ent.GetScriptScope().GetArrPByS(null, null, "You lose: "+this.GetMoney()+"$");
                this.SubMoney(100000);
            }
            else
            {
                if(this.GetMoney()*2 < this.max_money)
                {
                    this.map_shop_ent.GetScriptScope().GetArrPByS(null, null, "You've won: "+(this.GetMoney()*2)+"$");
                }
                else
                {
                    if(this.GetMoney() > 1000)
                    {
                        this.map_shop_ent.GetScriptScope().GetArrPByS(null, null, "You've won: 0$ (Max count money 1000$)");
                    }
                    this.map_shop_ent.GetScriptScope().GetArrPByS(null, null, "You've won: "+(this.max_money - this.GetMoney())+"$ (Max count money 1000$)");
                }
                this.SetMoney(this.GetMoney()*2);
            }
        }
    }
    function NoEnoughMoney()
    {
        printl("TEST: No Enough Money");
    } 
}

////////////////////////////////////////////
///////////////////SHOP/////////////////////
////////////////////////////////////////////

// function ShopMoveUp()
// {
//     foreach(p in PLAYERS){if(p.handle == activator){return p.ShopMoveUp();}}
// 	return null;
// }

// function ShopMoveDown()
// {
//     foreach(p in PLAYERS){if(p.handle == activator){return p.ShopMoveDown();}}
// 	return null;
// }

// function ShopPlOff()
// {
//     foreach(p in PLAYERS){if(p.handle == activator){return p.ShopPlOff();}}
// 	return null;
// }

// function ShopPlSelected()
// {
//     foreach(p in PLAYERS){if(p.handle == activator){return p.ShopPlSelected();}}
// 	return null;
// }

// function ShopPlUSelected()
// {
//     foreach(p in PLAYERS){if(p.handle == activator){return p.ShopPlUSelected();}}
// 	return null;
// }

::UPDATE_SHOP_HUD <- 0.10;

function MapShopUpdateCheck()
{
    foreach (p in PLAYERS) {if(p.IsInShop && p.map_shop_ent != null && p.map_shop_ent.IsValid() && "PLAYER_SHOP" in p.map_shop_ent.GetScriptScope()){p.map_shop_ent.GetScriptScope().MapShopUpdateHud();}}
    foreach (p in PLAYERS) {if(p.handle != null && p.handle.IsValid() && p.map_shop_colldown_tick > 0.00){p.MapShopSubColl(UPDATE_SHOP_HUD);}}
    EntFireByHandle(self, "RunScriptCode", "MapShopUpdateCheck();", UPDATE_SHOP_HUD, null, null);
}

///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
DATA_PL_MENU_SELECTION <- [];
DATA_PL_GAME_UI_ENT <- null;
DATA_PL_MENU_SELECTED <- 0;
DATA_PL_MAX_MENU_SLOTS <- 6;
DATA_PL_S <- false;

function DataPlayersHud() // map_shop to map_brush
{
    if(DEBUG)
    {
        // local sl_name = PLAYERS[i].GetNickName().find("name: ") == 0 ? split(PLAYERS[i].GetNickName(), "name: ")[0] : PLAYERS[i].GetNickName();
        DATA_PL_MENU_SELECTION = PLAYERS.slice(0);
        DATA_PL_GAME_UI_ENT = Entities.CreateByClassname("game_ui");
        DATA_PL_GAME_UI_ENT.__KeyValueFromInt("FieldOfView", -1);
        DATA_PL_GAME_UI_ENT.__KeyValueFromInt("spawnflags", 480);
        EntFireByHandle(DATA_PL_GAME_UI_ENT, "AddOutput", "PressedForward map_brush:RunScriptCode:DataPlMoveUp():0:-1", 0.00, null, null);
        EntFireByHandle(DATA_PL_GAME_UI_ENT, "AddOutput", "PressedBack map_brush:RunScriptCode:DataPlMoveDown():0:-1", 0.00, null, null);
        EntFireByHandle(DATA_PL_GAME_UI_ENT, "AddOutput", "PlayerOff map_brush:RunScriptCode:DataPlOff():0:-1", 0.00, null, null);
        EntFireByHandle(DATA_PL_GAME_UI_ENT, "AddOutput", "PressedAttack map_brush:RunScriptCode:DataPlSelected():0:-1", 0.00, null, null);
        EntFireByHandle(DATA_PL_GAME_UI_ENT, "AddOutput", "PressedAttack2 map_brush:RunScriptCode:DataPlUnSelected():0:-1", 0.00, null, null);
        EntFireByHandle(DATA_PL_GAME_UI_ENT, "Activate", "", 0.00, activator, null);
        DataPlUpDateHud();
    }
}

function DataPlUpDateHud()
{
    if(DATA_PL_GAME_UI_ENT != null && DATA_PL_GAME_UI_ENT.IsValid())
    {
        EntFireByHandle(self, "RunScriptCode", "DataPlUpDateHud();", 0.50, null, null);
        local dump_message = "";
        for(local i = DATA_PL_MENU_SELECTED; i < DATA_PL_MENU_SELECTION.len(); i++)
        {
            if(!DATA_PL_S)
            {
                if(i < DATA_PL_MAX_MENU_SLOTS)
                {
                    if(i == DATA_PL_MENU_SELECTED){dump_message += "> "+DATA_PL_MENU_SELECTION[i].GetNickName()+" <\n";}
                    else{dump_message += DATA_PL_MENU_SELECTION[i].GetNickName()+"\n";}
                }
            }
            else
            {
                dump_message = "userid: "+DATA_PL_MENU_SELECTION[DATA_PL_MENU_SELECTED].userid+
                "\nname: "+DATA_PL_MENU_SELECTION[DATA_PL_MENU_SELECTED].name+
                "\nsid: "+DATA_PL_MENU_SELECTION[DATA_PL_MENU_SELECTED].steamid+
                "\nmoney: "+DATA_PL_MENU_SELECTION[DATA_PL_MENU_SELECTED].money+
                "\nammo_level: "+DATA_PL_MENU_SELECTION[DATA_PL_MENU_SELECTED].GetAmmoLevel()+
                "\nheal_level: "+DATA_PL_MENU_SELECTION[DATA_PL_MENU_SELECTED].GetHealLevel()+
                "\nspeed_level: "+DATA_PL_MENU_SELECTION[DATA_PL_MENU_SELECTED].GetSpeedLevel();
            }
        }
        ScriptPrintMessageCenterAll(dump_message);
    }
}

function DataPlMoveUp()
{
    printl("PRESSED UP");
    if(DATA_PL_S)return;
    DATA_PL_MENU_SELECTED--;
    DATA_PL_MAX_MENU_SLOTS--;
    if(DATA_PL_MENU_SELECTED < 0)
    {
        DATA_PL_MENU_SELECTED = DATA_PL_MENU_SELECTION.len()-1;
        DATA_PL_MAX_MENU_SLOTS += DATA_PL_MENU_SELECTED;
    }
}

function DataPlMoveDown()
{
    printl("PRESSED DOWN");
    if(DATA_PL_S)return;
    DATA_PL_MENU_SELECTED++;
    DATA_PL_MAX_MENU_SLOTS++;
    if(DATA_PL_MENU_SELECTED > DATA_PL_MENU_SELECTION.len()-1)
    {
        DATA_PL_MENU_SELECTED = 0;
        DATA_PL_MAX_MENU_SLOTS = 6;
    }
}

function DataPlSelected(){DATA_PL_S = true;}

function DataPlUnSelected(){DATA_PL_S = false;}

function DataPlOff()
{
    printl("UI OFF");
    if(DATA_PL_GAME_UI_ENT != null && DATA_PL_GAME_UI_ENT.IsValid())
    {
        DATA_PL_GAME_UI_ENT.Destroy();
        ScriptPrintMessageCenterAll("");
    }
    if(DATA_PL_MENU_SELECTION.len() > 0){DATA_PL_MENU_SELECTION.clear();}
    DATA_PL_GAME_UI_ENT = null;
    DATA_PL_MENU_SELECTED = 0;
    DATA_PL_MAX_MENU_SLOTS = 6;
    DATA_PL_S = false;
}

function DataPlUpDateList(){DATA_PL_MENU_SELECTION = PLAYERS.slice(0);}

///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////

function ToggleBossFight()
{
    if(IsBossFight){IsBossFight = false;}
    else{IsBossFight = true;}
}

function SetMapper()
{
    if(PLAYERS.len() > 0 && MAPPER_SID.len() > 0)
    {
        for(local i = 0; i < PLAYERS.len(); i++)
        {
            for(local a = 0; a < MAPPER_SID.len(); a++){if(PLAYERS[i].steamid == MAPPER_SID[a]){PLAYERS[i].SetMapperData();}}
        }
    }
}

function CheckValidInArr()
{
    if(PLAYERS.len() > 0)
    {
        for(local i = 0; i < PLAYERS.len(); i++)
        {
            if(!PLAYERS[i].ValidThisH() && PLAYERS[i].GetCheckedCPl() >= 3)
            {
                if(DEBUG){printl("removed index: "+i+" | Handle not valid | Player "+PLAYERS[i].GetNickName()+" | sid: "+PLAYERS[i].steamid);}
                PLAYERS.remove(i);
            }
        }
    }
    SetMapper();
    // ReturnDataPlayer();
}

function DumpPlayers()
{
    if(DEBUG && PLAYERS.len() > 0)
    {
        for(local i = 0; i < PLAYERS.len(); i++)
        {
            printl("index: "+i+" | "+PLAYERS[i].GetNickName()+" | sid: "+PLAYERS[i].steamid);
        }
    }
}

function PlayerConnect()
{
    if(eventlist == null || eventlist != null && !eventlist.IsValid()){eventlist = Entities.FindByName(null, "event_player_connect");}
	local userid = eventlist.GetScriptScope().event_data.userid;
    local name = eventlist.GetScriptScope().event_data.name;
	local steamid = eventlist.GetScriptScope().event_data.networkid;
    local p = PlayerInfo(userid,name,steamid);
    PLAYERS.push(p);
}

function EventInfo()
{
    if(eventinfo == null || eventinfo != null && !eventinfo.IsValid()){eventinfo = Entities.FindByName(null, "pl_ginfo");}
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
    if(client_ent == null || client_ent != null && !client_ent.IsValid())
    {
        client_ent = Entities.FindByClassname(null, "point_clientcommand");
        if(client_ent == null){client_ent = Entities.CreateByClassname("point_clientcommand")}
    }
    if(AUTO_RETRY && client_ent != null && client_ent.IsValid())
    {
        EntFireByHandle(client_ent, "Command", "retry", RandomFloat(0.00, 3.00), TEMP_HANDLE, null);
        return;
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
    }
}

// "player_disconnect"			// a client was disconnected
// {
//     "userid"	"short"		// user ID on server
//     "reason"	"string"	// "self", "kick", "ban", "cheat", "error"
//     "name"		"string"	// player name
//     "networkid"	"string"	// player network (i.e steam) id
// }

// function ReserveData()
// {
//     if(eventdis == null || eventdis != null && !eventdis.IsValid()){eventdis = Entities.FindByName(null, "event_player_disconnect");}
//     local userid = eventdis.GetScriptScope().event_data.userid;
//     local steamid = eventdis.GetScriptScope().event_data.networkid;
//     local pl_data = GetPlayerClassByUserID(userid);
//     if(pl_data != null && pl_data.GetMoney() > 0)
//     {
//         if(DEBUG){printl("Reserved data | uid: "+userid+" | sid: "+steamid+" | money: "+pl_data.GetMoney());}
//         BACKUP_DATA.push(pl_data);
//     }
// }

// function ReturnDataPlayer()
// {
//     if(BACKUP_DATA.len() > 0)
//     {
//         try
//         {
//             for(local i = 0; i < BACKUP_DATA.len(); i++)
//             {
//                 for(local a = 0; a < PLAYERS.len(); a++)
//                 {
//                     if(BACKUP_DATA[i].GetMoney() > 0 && 
//                     PLAYERS[a].handle != null &&
//                     PLAYERS[a].handle.IsValid() &&
//                     PLAYERS[a].steamid != "NOT GETED" &&
//                     BACKUP_DATA[i].steamid == PLAYERS[a].steamid)
//                     {
//                         PLAYERS[a].money += BACKUP_DATA[i].GetMoney();
//                         if(DEBUG)
//                         {
//                             printl("RETURN DATA TO: "+PLAYERS[a].GetNickName()+" | money: "+BACKUP_DATA[i].GetMoney());
//                             printl("REMOVED DATA: "+BACKUP_DATA[i].GetNickName()+
//                             " | sid: "+BACKUP_DATA[i].steamid+
//                             " | money: "+BACKUP_DATA[i].GetMoney()+
//                             " | index: "+i+
//                             " | ARRAY LEN: "+BACKUP_DATA.len());
//                         }
//                         if(BACKUP_DATA.len() == 1){BACKUP_DATA[i].steamid == null;}
//                         else{BACKUP_DATA.remove(i);}
//                     }
//                 }
//             }
//         }
//         catch(error)
//         {
//             if(DEBUG)
//             {
//                 printl("----------------------");
//                 printl("WARNING: DATA OVERFLOW");
//                 printl("----------------------");
//                 printl("ERROR: "+error+" | CLEAR ARRAY");
//             }
//             BACKUP_DATA.clear();
//         }
//     }
// }

// function DumpBackUpData()
// {
//     foreach(p in BACKUP_DATA)
//     {
//         printl(""+p.GetNickName()+" | sid: "+p.steamid+" | money: "+p.GetMoney());
//     }
// }

function PlayerSay()
{
    try
    {
        if(eventsay == null || eventsay != null && !eventsay.IsValid()){eventsay = Entities.FindByName(null, "pl_say");}
        local userid = eventsay.GetScriptScope().event_data.userid;
        local msg = eventsay.GetScriptScope().event_data.text;
        if(msg.find("!map_ef") != 0){msg = msg.tolower();}
        if(msg.find("!map_shop") == 0)
        {
            local pl_class = GetPlayerClassByUserID(userid);
            if(!pl_class.IsInShop){pl_class.OpenShop();}
            else{return;}
        }
        local get_mapper = GetMapperByUserId(userid);
        if(get_mapper == null || !get_mapper || !MAPPER_COMMANDS)return;
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
                EntFireByHandle(GetPlayerByUserID(userid), ""+input, ""+parameters, 0.00, GetPlayerByUserID(userid), null);
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
            else if(sp_text[1].find("id") == 0)
            {
                local id_tar = split(sp_text[1].tostring(),"id");
                if(sp_text.len() > 3)
                {
                    for(local i = 4; i < sp_text.len(); i++){parameters += " "+sp_text[i];}
                }
                InputPlayerUserid(id_tar[0].tointeger(), input, parameters)
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
        if(msg.find("!map_noclip") == 0)
        {
            local sp_text = split(msg," ")
            if(sp_text.len() < 2)return;
            if(sp_text[1] == "@me")
            {
                SetNoclipM(userid);
                return;
            }
            local uid_m = sp_text[1].tointeger();
            if(uid_m != null)
            {
                SetNoclipM(uid_m);
            }
        }
        if(msg == "!map_playersdata")
        {
            EntFireByHandle(self, "RunScriptCode", "DataPlayersHud();", 0.00, GetPlayerByUserID(userid), null);
        }
        if(msg == "!map_rr")
        {
            if(round_end_ent != null && round_end_ent.IsValid())
            {
                EntFireByHandle(round_end_ent, "EndRound_Draw", "3", 0.00, null, null);
            }
        }
    }
    catch(error)
    {
        return;
    }
}

function RestartRound(n=0, time=3) //n = team | n = 0 Draw | n = 1 CT | n = 2 T, time = Parameter is how long until the next round starts.
{
    if(n == 0)
    {
        EntFireByHandle(round_end_ent,"EndRound_Draw",""+time, 0.00,null,null);
    }
    else if(n == 1)
    {
        EntFireByHandle(round_end_ent,"EndRound_CounterTerroristsWin",""+time, 0.00,null,null);
    }
    else if(n == 2)
    {
        EntFireByHandle(round_end_ent,"EndRound_TerroristsWin",""+time, 0.00,null,null);
    }
}


function SetNoclipM(id)
{
    if(GetPlayerClassByUserID(id).handle.IsValid())
    {
        if(GetPlayerClassByUserID(id).GetNoclipThis())
        {
            GetPlayerClassByUserID(id).ToggleNoclip();
            EntFireByHandle(GetPlayerClassByUserID(id).handle, "AddOutput", "movetype 8", 0.00, GetPlayerClassByUserID(id).handle, null);
        }
        else if(!GetPlayerClassByUserID(id).GetNoclipThis())
        {
            GetPlayerClassByUserID(id).ToggleNoclip();
            EntFireByHandle(GetPlayerClassByUserID(id).handle, "AddOutput", "movetype 2", 0.00, GetPlayerClassByUserID(id).handle, null);
        }
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
            "\nMAPPER: "+GetPlayerClassByHandle(activator).IsMapper()+
            "\nMoney: "+GetPlayerClassByHandle(activator).GetMoney());
        }
        catch(error)
        {
            ScriptPrintMessageCenterAll("ERROR: "+error);
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
        try
        {
            ScriptPrintMessageCenterAll("ARRAY LEN: "+PLAYERS.len()+
            "\nPL NAME: "+GetPlayerClassByUserID(uid).name+
            "\nPL UID: "+GetPlayerClassByUserID(uid).userid+
            "\nPL STEAMID: "+GetPlayerClassByUserID(uid).steamid+
            "\nHANDLE: "+GetPlayerClassByUserID(uid).handle+
            "\nMAPPER: "+GetPlayerClassByUserID(uid).IsMapper()+
            "\nMoney: "+GetPlayerClassByUserID(uid).GetMoney());
        }
        catch(error)
        {
            ScriptPrintMessageCenterAll("ERROR: "+error);
        }
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

::GetPlayerNameOrUidByHandle <- function(handle)
{
    foreach(p in PLAYERS)
	{
		if(p.handle == handle)
		{
            if(p.name == "NOT GETED")
            {
                return "UID: "+p.userid;
            }
            else
            {
                return ""+p.name;
            }
		}
	}
	return null;
}

function GetAlivePlayersCount()
{
    local pl = 0;
    foreach(p in PLAYERS)
	{
		if(p.handle != null && p.handle.IsValid() && p.handle.GetHealth() > 0){pl++;}
	}
    return pl;
}

function GetAlivePlayersCTCount()
{
    local pl = 0;
    foreach(p in PLAYERS)
	{
		if(p.handle != null && p.handle.IsValid() && p.handle.GetTeam() == 3 && p.handle.GetHealth() > 0){pl++;}
	}
    return pl;
}

function GetAlivePlayersTCount()
{
    local pl = 0;
    foreach(p in PLAYERS)
	{
		if(p.handle != null && p.handle.IsValid() && p.handle.GetTeam() == 2 && p.handle.GetHealth() > 0){pl++;}
	}
    return pl;
}

function AddMoneyByActivator(amount)
{
    foreach(p in PLAYERS)
	{
		if(p.handle == activator)
		{
            return p.AddMoney(amount);
		}
	}
	return null;
}

function AddMoneyAllPlayers(amount)
{
    foreach(p in PLAYERS)
	{
		if(p.handle != null && p.handle.IsValid())
		{
            return p.AddMoney(amount);
		}
	}
	return null;
}

function DumpMoneyAllPlayers()
{
    foreach(p in PLAYERS)
	{
		printl(""+p.GetNickName()+" | money: "+p.GetMoney());
	}
}

function DumpMoneyActPlayer()
{
    foreach(p in PLAYERS)
	{
        if(p.handle == activator)
        {
            printl(""+p.GetNickName()+" | money: "+p.GetMoney());
        }
	}
}

function AddTickMoneyByActivator()
{
    foreach(pl in PLAYERS)
    {
        if(pl.handle == activator)
        {
            pl.AddTickMoney();
        }
    }
}

::GetIndexByValue <- function(arr, v)
{
    for(local i = 0; i < arr.len(); i++)
    {
        if(arr[i] == v)
        {
            return i;
        }
    }
}

function RandomColorChat()
{
    local colors = "\x01 \x02 \x03 \x04 \x05 \x06 \x07 \x08 \x09 \x10 \x0A \x0B \x0C"
    local sp_text = split(colors," ");
    if(sp_text.len() > 0)
    {
        local rnd_color = " "+sp_text[rndint(sp_text.len())];
        return rnd_color;
    }
}

function rndint(max) 
{
    local roll = 1 * max * rand() / RAND_MAX;
    return roll;
}

function RespawnDead()
{
    SendToConsoleServer("mp_respawn_on_death_ct 1");
    EntFireByHandle(self, "RunScriptCode", "ReturnWeapons();", 10.00, null, null);
    EntFireByHandle(self, "RunScriptCode", "DisableRespawn();", 10.00, null, null);
}

function DisableRespawn()
{
    SendToConsoleServer("mp_respawn_on_death_ct 0");
}

function ReturnWeapons()
{
    for(local i = 0; i < PLAYERS.len(); i++){PLAYERS[i].ReturnPurchWeapon();}
}

function OpenShopByActivator()
{
    foreach(p in PLAYERS)
    {
        if(p.handle == activator)
        {
            p.OpenShop();
        }
    }
}