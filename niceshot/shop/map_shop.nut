PLAYER_SHOP <- null;
map_shop_hud <- null;
map_shop_ent <- self;
SHOP_MAX_SLOTS_F <- 6;
map_shop_menu_selected <- 0;
map_shop_max_menu_slots <- SHOP_MAX_SLOTS_F;
map_shop_tick_buy_item <- 0;
map_shop_max_tick_bi <- 20;
map_shop_text_buy_item <- "";

another_menu <- false;
PLAYERS_LIST <- [];

PLAYER_SLAY_MENU <- false;
PLAYER_SLAY <- null;

PLAYER_KICK_MENU <- false;
PLAYER_KICK <- null;

PLAYER_ADD_SELF_MONEY <- false;

PLAYER_ADD_P_MONEY <- false;
PLAYER_ADD_MONEY_COUNT <- 0;
PLAYER_ADDM <- null;

PLAYERS_ADD_MONEY_A <- false;

SKIP_WAVES <- false;

RUN_BOSS_FIGHT <- false;
BOSS_FIGHT_C <- 0;
BOSS_ENT_F_TABLE <- {
    first_boss = "adm_button_boss1"
    second_boss = "adm_button_boss2"
    third_boss = "adm_button_boss3"
    fourth_boss = "adm_button_boss4"
    fifth_boss = "adm_button_boss5"
}

PLAYERS_UP_HEAL_L <- false;
PLAYERS_HEAL_UP_C <- 0;
PLAYER_UPH <- null;

PLAYERS_UP_AMMO_L <- false;
PLAYERS_AMMO_UP_C <- 0;
PLAYER_UPAMMO <- null;

PLAYERS_UP_SPEED_L <- false;
PLAYERS_SPEED_UP_C <- 0;
PLAYER_UPSPEED <- null;

SHOP_MENU_SLOTS <- [
    ["Weapon Menu",false,"Kevlar (50$)","Desert Eagle (30$)","Elite (30$)","Five-SeveN (35$)","Tec9 (50$)","Mp9 (75$)","Bizon (75$)","P90 (100$)","Ak47 (200$)","M4a1 (200$)","Aug (250$)","Negev (500$)","BuyWeapon()"],
    ["Health Menu",false,"FULL (1HP = 1$)","10 HP (10$)","25 HP (25$)","50 HP (50$)","75 HP (75$)","100 HP (100$)","BuyHealth()"],
    ["Upgrade Heal",false,"UPGRADE HEAL LEVEL","BuyHealthUpGrade()"],
    ["Upgrade Ammo",false,"UPGRADE AMMO LEVEL","BuyAmmoUpGrade()"],
    ["Upgrade Speed",false,"UPGRADE SPEED LEVEL","BuySpeedUpGrade()"],
    ["Lucky Money",false,"YES (Do you want to set all your money for a\n50 % chance to win the double or loose all? (MOUSE 2 (NO))","LuckyMoney()"],
]

//     Main Menu, action, slot00, slot01..., function to call,access (MAPPER OR ANYTHING (null disable)),
ADDITIONAL_SLOTS <- [
    ["Mapper Menu",false,"Slay","Kick","Add Money for yourself","Add Money","Add Money All Players","Skip Wave","Run Boss Fight","Up Heal Level","Up Ammo Level","Up Speed Level", "MapperAction()", "MAPPER"],
    ["TEST M",false,"slot00","slot01","slot02","slot03","slot04","slot05","slot06","Slot()", null]
] 

function CheckOnAddSlots()
{
    if(ADDITIONAL_SLOTS.len() > 0)
    {
        if(PLAYER_SHOP != null)
        {
            for(local i = 0; i < ADDITIONAL_SLOTS.len(); i++)
            {
                if(ADDITIONAL_SLOTS[i][ADDITIONAL_SLOTS[i].len() - 1] == "MAPPER")
                {
                    ADDITIONAL_SLOTS[i].remove(ADDITIONAL_SLOTS[i].len() - 1);
                    if(PLAYER_SHOP.IsMapper())
                    {
                        local new_arr = ADDITIONAL_SLOTS[i].slice(0, ADDITIONAL_SLOTS[i].len());
                        SHOP_MENU_SLOTS.push(new_arr);
                    }
                }
                else if(ADDITIONAL_SLOTS[i][ADDITIONAL_SLOTS[i].len() - 1] != null)
                {
                    ADDITIONAL_SLOTS[i].remove(ADDITIONAL_SLOTS[i].len() - 1);
                    local new_arr = ADDITIONAL_SLOTS[i].slice(0, ADDITIONAL_SLOTS[i].len());
                    SHOP_MENU_SLOTS.push(new_arr);
                }
            }
            return;
        }
        else{EntFireByHandle(self, "RunScriptCode", "CheckOnAddSlots();", 0.10, null, null);}
    }
}

CheckOnAddSlots();

function GetArrPByS(arr_i=null, arr_bs=null, buy_i=null)
{
    local arr_s = [];
    if(buy_i != null)
    {
        if(map_shop_tick_buy_item == 0)
        {
            map_shop_tick_buy_item = map_shop_max_tick_bi;
            map_shop_text_buy_item = buy_i;
        }
    }
    if(map_shop_tick_buy_item > 0)
    {
        arr_s.push(map_shop_text_buy_item);
        map_shop_menu_selected = 0;
        for(local i = 0; i < SHOP_MENU_SLOTS.len(); i++){if(SHOP_MENU_SLOTS[i][1]){SHOP_MENU_SLOTS[i][1] = false;}}
        map_shop_tick_buy_item--;
        return arr_s;
    }
    map_shop_text_buy_item = "";
    if(arr_i != null && arr_bs != null)
    {
        SHOP_MENU_SLOTS[arr_i][1] = arr_bs;
    }
    if(SHOP_MENU_SLOTS.len() > 0)
    {
        local exist_t = false;
        for(local i = 0; i < SHOP_MENU_SLOTS.len(); i++)
        {
            if(SHOP_MENU_SLOTS[i][1])
            {
                exist_t = true;
                local new_arr = SHOP_MENU_SLOTS[i].slice(0, SHOP_MENU_SLOTS[i].len() - 1);
                for(local a = 0; a < new_arr.len(); a++)
                {
                    
                    if(a != 0 && type(new_arr[a]) != "bool")
                    {
                        if(new_arr[a].find("UPGRADE HEAL LEVEL") != null)
                        {
                            new_arr[a] = "UPGRADE HEAL LEVEL | YOUR LEVEL "+PLAYER_SHOP.GetHealLevel()+" | NEXT LEVEL COSTS "+PLAYER_SHOP.GetHealCost()+" | MAX LEVEL "+PLAYER_SHOP.max_heal_level;
                        }
                        if(new_arr[a].find("UPGRADE AMMO LEVEL") != null)
                        {
                            new_arr[a] = "UPGRADE AMMO LEVEL | YOUR LEVEL "+PLAYER_SHOP.GetAmmoLevel()+" | NEXT LEVEL COSTS "+PLAYER_SHOP.GetAmmoCost()+" | MAX LEVEL "+PLAYER_SHOP.max_ammo_level;
                        }
                        if(new_arr[a].find("UPGRADE SPEED LEVEL") != null)
                        {
                            new_arr[a] = "UPGRADE SPEED LEVEL | YOUR LEVEL "+PLAYER_SHOP.GetSpeedLevel()+" | NEXT LEVEL COSTS "+PLAYER_SHOP.GetSpeedCost()+" | MAX LEVEL "+PLAYER_SHOP.max_speed_level;
                        }
                        arr_s.push(new_arr[a]);
                    }
                }
            }
        }
        if(!exist_t){for(local i = 0; i < SHOP_MENU_SLOTS.len(); i++){arr_s.push(SHOP_MENU_SLOTS[i][0]);}}
        return arr_s;
    }
    return null;
}

function BuyStuff()
{
    for(local i = 0; i < SHOP_MENU_SLOTS.len(); i++)
    {
        if(SHOP_MENU_SLOTS[i][1])
        {
            EntFireByHandle(self, "RunScriptCode", ""+SHOP_MENU_SLOTS[i][SHOP_MENU_SLOTS[i].len()-1], 0.00, null, null);
        }
    }
    // if(SHOP_MENU_SLOTS[0][1]){PLAYER_SHOP.BuyWeapon(map_shop_menu_selected, PLAYER_SHOP.GetWeaponCost(map_shop_menu_selected+2));}
    // else if(SHOP_MENU_SLOTS[1][1]){PLAYER_SHOP.BuyHealth(map_shop_menu_selected);}
    // else if(SHOP_MENU_SLOTS[2][1]){PLAYER_SHOP.BuyHealthUpGrade(SHOP_MENU_SLOTS[2][map_shop_menu_selected+2], PLAYER_SHOP.GetHealCost());}
    // else if(SHOP_MENU_SLOTS[3][1]){PLAYER_SHOP.BuyAmmoUpGrade(SHOP_MENU_SLOTS[3][map_shop_menu_selected+2], PLAYER_SHOP.GetAmmoCost());}
    // else if(SHOP_MENU_SLOTS[4][1]){PLAYER_SHOP.BuySpeedUpGrade(SHOP_MENU_SLOTS[4][map_shop_menu_selected+2], PLAYER_SHOP.GetSpeedCost());}
    // else if(SHOP_MENU_SLOTS[5][1]){PLAYER_SHOP.LuckyMoney();}
}

function MapShopUpdateHud()
{
    if(map_shop_hud != null && 
    map_shop_hud.IsValid() && 
    map_shop_ent != null && 
    map_shop_ent.IsValid() && 
    PLAYER_SHOP.handle != null &&
    PLAYER_SHOP.handle.IsValid() &&
    PLAYER_SHOP.handle.GetHealth() > 0)
    {
        local shop_message = "";
        local scroll = map_shop_menu_selected >= map_shop_max_menu_slots ? abs(map_shop_menu_selected - map_shop_max_menu_slots) : 0;
        if(!another_menu)
        {
            local arr_s = GetArrPByS();
            if(arr_s == null || arr_s.len() <= 0)return;
            for(local i = scroll; i < arr_s.len(); i++)
            {
                if(i <= (map_shop_max_menu_slots + scroll))
                {
                    if(i == map_shop_menu_selected){shop_message += "> "+arr_s[i]+" <\n";}
                    else{shop_message += arr_s[i]+"\n";}
                }
            }
        }
        else
        {
            try
            {
                local arr_s = GetMenuS();
                for(local i = scroll; i < arr_s.len(); i++)
                {
                    if(i <= (map_shop_max_menu_slots + scroll))
                    {
                        if(type(arr_s[i]) == "instance")
                        {
                            if(i == map_shop_menu_selected){shop_message += "> "+arr_s[i].name+" <\n";}
                            else{shop_message += arr_s[i].name+"\n";}
                        }
                        else
                        {
                            if(i == map_shop_menu_selected){shop_message += "> "+arr_s[i]+" <\n";}
                            else{shop_message += arr_s[i]+"\n";}
                        }
                    }
                }
            }
            catch(e){ToMapperMenu();}
        }
        map_shop_hud.__KeyValueFromString("message", shop_message);
        EntFireByHandle(map_shop_hud, "ShowHudHint", "", 0.00, PLAYER_SHOP.handle, null);
    }
    else
    {
        if(map_shop_hud != null && map_shop_hud.IsValid()){map_shop_hud.Destroy();}
        if(map_shop_ent != null && map_shop_ent.IsValid()){map_shop_ent.Destroy();}
        if(PLAYER_SHOP.handle != null && PLAYER_SHOP.handle.IsValid()){PLAYER_SHOP.handle.__KeyValueFromInt("movetype", 2);}
        PLAYER_SHOP.map_shop_hud = null;
        PLAYER_SHOP.map_shop_ent = null;
        PLAYER_SHOP.IsInShop = false;
        return;
    }
}

function ShopMoveUp()
{
    map_shop_menu_selected--;
    if(!another_menu)
    {
        if(map_shop_menu_selected < 0)
        {
            map_shop_menu_selected = GetArrPByS().len() - 1;
        }
    }
    else
    {
        if(map_shop_menu_selected < 0)
        {
            map_shop_menu_selected = GetMenuS().len() - 1;
        }
    }
}

function ShopMoveDown()
{
    map_shop_menu_selected++;
    if(!another_menu)
    {
        if(map_shop_menu_selected > GetArrPByS().len() - 1)
        {
            map_shop_menu_selected = 0;
        }
    }
    else
    {
        if(map_shop_menu_selected > GetMenuS().len() - 1)
        {
            map_shop_menu_selected = 0;
        }
    }
}

function ShopPlOn()
{
    foreach(p in PLAYERS)
    {
        if(p.handle == activator)
        {
            PLAYER_SHOP = p;
        }
    }
    map_shop_hud = PLAYER_SHOP.map_shop_hud;
}

function ShopPlOff()
{
    if(map_shop_ent != null && map_shop_ent.IsValid()){map_shop_ent.Destroy();}
    if(map_shop_hud != null && map_shop_hud.IsValid())
    {
        EntFireByHandle(map_shop_hud, "HideHudHint", "", 0.00, PLAYER_SHOP.handle, null);
        map_shop_hud.Destroy();
    }
    PLAYER_SHOP.handle.__KeyValueFromInt("movetype", 2);
    PLAYER_SHOP.map_shop_hud = null;
    PLAYER_SHOP.map_shop_ent = null;
    PLAYER_SHOP.IsInShop = false;
}

function ShopPlSelected()
{
    local exist_t = false;
    for(local i = 0; i < SHOP_MENU_SLOTS.len(); i++)
    {
        if(SHOP_MENU_SLOTS[i][1])
        {
            exist_t = true;
            BuyStuff();
        }
    }
    if(!exist_t)
    {
        GetArrPByS(map_shop_menu_selected, true);
        map_shop_menu_selected = 0;
    }
    if(another_menu)
    {
        MapperStuff();
    }
}

function ShopPlUSelected()
{
    if(another_menu)
    {
        if(PLAYER_SLAY_MENU){PLAYER_SLAY_MENU = false;}
        else if(PLAYER_KICK_MENU){PLAYER_KICK_MENU = false;}
        else if(PLAYER_ADD_SELF_MONEY){PLAYER_ADD_SELF_MONEY = false;}
        else if(PLAYER_ADD_P_MONEY)
        {
            PLAYER_ADD_P_MONEY = false;
            PLAYER_ADD_MONEY_COUNT = 0;
            PLAYER_ADDM = null;
        }
        else if(PLAYERS_ADD_MONEY_A){PLAYERS_ADD_MONEY_A = false;}
        else if(RUN_BOSS_FIGHT)
        {
            RUN_BOSS_FIGHT = false;
            BOSS_FIGHT_C = 0;
        }
        else if(PLAYERS_UP_HEAL_L)
        {
            PLAYERS_UP_HEAL_L = false;
            PLAYERS_HEAL_UP_C = 0;
            PLAYER_UPH = null;
        }
        else if(PLAYERS_UP_AMMO_L)
        {
            PLAYERS_UP_AMMO_L = false;
            PLAYERS_AMMO_UP_C = 0;
            PLAYER_UPAMMO = null;
        }
        else if(PLAYERS_UP_SPEED_L)
        {
            PLAYERS_UP_SPEED_L = false;
            PLAYERS_SPEED_UP_C = 0;
            PLAYER_UPSPEED = null;
        }
        another_menu = false;
        map_shop_menu_selected = 0;
        return;
    }
    local af = true;
    for(local i = 0; i < SHOP_MENU_SLOTS.len(); i++)
    {
        if(SHOP_MENU_SLOTS[i][1])
        {
            GetArrPByS(i, false);
            af = false;
        }
    }
    if(af)
    {
        if(map_shop_ent != null && map_shop_ent.IsValid()){map_shop_ent.Destroy();}
        if(map_shop_hud != null && map_shop_hud.IsValid())
        {
            EntFireByHandle(map_shop_hud, "HideHudHint", "", 0.00, PLAYER_SHOP.handle, null);
            map_shop_hud.Destroy();
        }
        PLAYER_SHOP.handle.__KeyValueFromInt("movetype", 2);
        PLAYER_SHOP.map_shop_hud = null;
        PLAYER_SHOP.map_shop_ent = null;
        PLAYER_SHOP.IsInShop = false;
    }
    map_shop_menu_selected = 0;
}

function PlayerList()
{
    local arr_s = [];
    for(local i = 0; i < PLAYERS.len(); i++)
    {
        if(PLAYERS[i].handle != null && PLAYERS[i].handle.IsValid())
        {
            arr_s.push(PLAYERS[i]);
        }
    }
}

function BuyWeapon()
{
    PLAYER_SHOP.BuyWeapon(map_shop_menu_selected, PLAYER_SHOP.GetWeaponCost(map_shop_menu_selected+2));
    EntFireByHandle(self, "RunScriptCode", "SetReserveAmmoMs();", 0.05, null, null);
}

function SetReserveAmmoMs(){PLAYER_SHOP.SetReserveAmmo();}

function BuyHealth(){PLAYER_SHOP.BuyHealth(map_shop_menu_selected);}

function BuyHealthUpGrade(){PLAYER_SHOP.BuyHealthUpGrade(SHOP_MENU_SLOTS[2][map_shop_menu_selected+2], PLAYER_SHOP.GetHealCost());}

function BuyAmmoUpGrade(){PLAYER_SHOP.BuyAmmoUpGrade(SHOP_MENU_SLOTS[3][map_shop_menu_selected+2], PLAYER_SHOP.GetAmmoCost());}

function BuySpeedUpGrade(){PLAYER_SHOP.BuySpeedUpGrade(SHOP_MENU_SLOTS[4][map_shop_menu_selected+2], PLAYER_SHOP.GetSpeedCost());}

function LuckyMoney(){PLAYER_SHOP.LuckyMoney();}

function MapperAction()
{
    if(CheckActionB())
    {
        another_menu = true;
        if(map_shop_menu_selected == 0){PLAYER_SLAY_MENU = true;}
        else if(map_shop_menu_selected == 1){PLAYER_KICK_MENU = true;}
        else if(map_shop_menu_selected == 2){PLAYER_ADD_SELF_MONEY = true;}
        else if(map_shop_menu_selected == 3){PLAYER_ADD_P_MONEY = true;}
        else if(map_shop_menu_selected == 4){PLAYERS_ADD_MONEY_A = true;}
        else if(map_shop_menu_selected == 5){SKIP_WAVES = true;}
        else if(map_shop_menu_selected == 6){RUN_BOSS_FIGHT = true;}
        else if(map_shop_menu_selected == 7){PLAYERS_UP_HEAL_L = true;}
        else if(map_shop_menu_selected == 8){PLAYERS_UP_AMMO_L = true;}
        else if(map_shop_menu_selected == 9){PLAYERS_UP_SPEED_L = true;}
        map_shop_menu_selected = 0;
    }
}

function MapperStuff()
{
    if(PLAYER_SLAY_MENU){PLAYER_SLAY = map_shop_menu_selected;}
    else if(PLAYER_KICK_MENU){PLAYER_KICK = map_shop_menu_selected;}
    else if(PLAYER_ADD_SELF_MONEY)
    {
        switch(map_shop_menu_selected)
        {
            case 0:{PLAYER_SHOP.AddMoney(10);break;}
            case 1:{PLAYER_SHOP.AddMoney(50);break;}
            case 2:{PLAYER_SHOP.AddMoney(100);break;}
            case 3:{PLAYER_SHOP.AddMoney(250);break;}
            case 4:{PLAYER_SHOP.AddMoney(500);break;}
            case 5:{PLAYER_SHOP.AddMoney(1000);break;}
            default:{PLAYER_SHOP.AddMoney(0);break;}
        }
    }
    else if(PLAYER_ADD_P_MONEY)
    {
        if(PLAYER_ADD_MONEY_COUNT == 0)
        {
            switch(map_shop_menu_selected)
            {
                case 0:{PLAYER_ADD_MONEY_COUNT = 10;break;}
                case 1:{PLAYER_ADD_MONEY_COUNT = 50;break;}
                case 2:{PLAYER_ADD_MONEY_COUNT = 100;break;}
                case 3:{PLAYER_ADD_MONEY_COUNT = 250;break;}
                case 4:{PLAYER_ADD_MONEY_COUNT = 500;break;}
                case 5:{PLAYER_ADD_MONEY_COUNT = 1000;break;}
                default:{PLAYER_ADD_MONEY_COUNT = 0;break;}
            }
            map_shop_menu_selected = 0;
        }
        else{PLAYER_ADDM = map_shop_menu_selected;}
    }
    else if(PLAYERS_ADD_MONEY_A)
    {
        for(local i = 0; i < PLAYERS.len(); i++)
        {
            if(PLAYERS[i].handle != null && PLAYERS[i].handle.IsValid() && PLAYERS[i].handle.GetHealth() > 0)
            {
                switch(map_shop_menu_selected)
                {
                    case 0:{PLAYERS[i].AddMoney(10);break;}
                    case 1:{PLAYERS[i].AddMoney(50);break;}
                    case 2:{PLAYERS[i].AddMoney(100);break;}
                    case 3:{PLAYERS[i].AddMoney(250);break;}
                    case 4:{PLAYERS[i].AddMoney(500);break;}
                    case 5:{PLAYERS[i].AddMoney(1000);break;}
                    default:{PLAYERS[i].AddMoney(0);break;}
                }
            }
        }
        ToMapperMenu();
    }
    else if(RUN_BOSS_FIGHT)
    {
        BOSS_FIGHT_C = (map_shop_menu_selected + 1);
        printl("RUN BOSS: "+BOSS_FIGHT_C);
        if(BOSS_FIGHT_C != 0)
        {
            switch(BOSS_FIGHT_C)
            {
                case 1:
                {
                    local boss_start = Entities.FindByName(null, BOSS_ENT_F_TABLE.first_boss);
                    EntFireByHandle(boss_start, "Press", "", 0.00, null, null);
                    break;
                }
                case 2:
                {
                    local boss_start = Entities.FindByName(null, BOSS_ENT_F_TABLE.second_boss);
                    EntFireByHandle(boss_start, "Press", "", 0.00, null, null);
                    break;
                }
                case 3:
                {
                    local boss_start = Entities.FindByName(null, BOSS_ENT_F_TABLE.third_boss);
                    EntFireByHandle(boss_start, "Press", "", 0.00, null, null);
                    break;
                }
                case 4:
                {
                    local boss_start = Entities.FindByName(null, BOSS_ENT_F_TABLE.fourth_boss);
                    EntFireByHandle(boss_start, "Press", "", 0.00, null, null);
                    break;
                }
                case 5:
                {
                    local boss_start = Entities.FindByName(null, BOSS_ENT_F_TABLE.fifth_boss);
                    EntFireByHandle(boss_start, "Press", "", 0.00, null, null);
                    break;
                }
                default:{break;}
            }
        }
    }
    else if(PLAYERS_UP_HEAL_L)
    {
        if(PLAYERS_HEAL_UP_C == 0)
        {
            switch(map_shop_menu_selected)
            {
                case 0:{PLAYERS_HEAL_UP_C = 1;break;}
                case 1:{PLAYERS_HEAL_UP_C = 2;break;}
                case 2:{PLAYERS_HEAL_UP_C = 3;break;}
                case 3:{PLAYERS_HEAL_UP_C = 4;break;}
                case 4:{PLAYERS_HEAL_UP_C = 5;break;}
                default:{PLAYERS_HEAL_UP_C = 0;break;}
            }
            map_shop_menu_selected = 0;
        }
        else{PLAYER_UPH = map_shop_menu_selected;}
    }
    else if(PLAYERS_UP_AMMO_L)
    {
        if(PLAYERS_AMMO_UP_C == 0)
        {
            switch(map_shop_menu_selected)
            {
                case 0:{PLAYERS_AMMO_UP_C = 1;break;}
                case 1:{PLAYERS_AMMO_UP_C = 2;break;}
                case 2:{PLAYERS_AMMO_UP_C = 3;break;}
                case 3:{PLAYERS_AMMO_UP_C = 4;break;}
                case 4:{PLAYERS_AMMO_UP_C = 5;break;}
                default:{PLAYERS_AMMO_UP_C = 0;break;}
            }
            map_shop_menu_selected = 0;
        }
        else{PLAYER_UPAMMO = map_shop_menu_selected;}
    }
    else if(PLAYERS_UP_SPEED_L)
    {
        if(PLAYERS_SPEED_UP_C == 0)
        {
            switch(map_shop_menu_selected)
            {
                case 0:{PLAYERS_SPEED_UP_C = 1;break;}
                case 1:{PLAYERS_SPEED_UP_C = 2;break;}
                case 2:{PLAYERS_SPEED_UP_C = 3;break;}
                case 3:{PLAYERS_SPEED_UP_C = 4;break;}
                case 4:{PLAYERS_SPEED_UP_C = 5;break;}
                default:{PLAYERS_SPEED_UP_C = 0;break;}
            }
            map_shop_menu_selected = 0;
        }
        else{PLAYER_UPSPEED = map_shop_menu_selected;}
    }
}

function GetMenuS()
{
    local array_text = [];
    class PLAYER_DATA
    {
        name = null;
        handle = null;
        constructor(_n, _h)
        {
            name = _n;
            handle = _h;
        }
    }
    if(PLAYER_SLAY_MENU || PLAYER_KICK_MENU)
    {
        PLAYERS_LIST = [];
        for(local i = 0; i < PLAYERS.len(); i++)
        {
            if(PLAYERS[i].handle != null && PLAYERS[i].handle.IsValid())
            {
                PLAYERS_LIST.push(PLAYER_DATA(PLAYERS[i].GetNickName(), PLAYERS[i].handle));
            }
        }
        if(PLAYER_SLAY_MENU && PLAYER_SLAY != null && type(PLAYER_SLAY) == "integer")
        {
            // local pl_c = GetPlayerByNickName(PLAYERS_LIST[PLAYER_SLAY]);
            if(PLAYERS_LIST[PLAYER_SLAY].handle != null && PLAYERS_LIST[PLAYER_SLAY].handle.IsValid())
            {
                EntFireByHandle(PLAYERS_LIST[PLAYER_SLAY].handle, "SetHealth", "0", 0.00, PLAYER_SHOP.handle, null);
            }
            PLAYER_SLAY = null;
        }
        else if(PLAYER_KICK_MENU && PLAYER_KICK != null && type(PLAYER_KICK) == "integer")
        {
            // local pl_c = GetPlayerByNickName(PLAYERS_LIST[PLAYER_KICK]);
            if(PLAYERS_LIST[PLAYER_KICK].handle != null && PLAYERS_LIST[PLAYER_KICK].handle.IsValid())
            {
                EntFireByHandle(PLAYERS_LIST[PLAYER_KICK].handle, "Kill", "", 0.00, PLAYER_SHOP.handle, null);
            }
            PLAYER_KICK = null;   
        }
        return PLAYERS_LIST;
    }
    else if(PLAYER_ADD_SELF_MONEY)
    {
        array_text.push("+10$");
        array_text.push("+50$");
        array_text.push("+100$");
        array_text.push("+250$");
        array_text.push("+500$");
        array_text.push("+1000$");
        return array_text;
    }
    else if(PLAYER_ADD_P_MONEY)
    {
        if(PLAYER_ADD_MONEY_COUNT == 0)
        {
            array_text.push("+10$");
            array_text.push("+50$");
            array_text.push("+100$");
            array_text.push("+250$");
            array_text.push("+500$");
            array_text.push("+1000$");
            return array_text;
        }
        else
        {
            PLAYERS_LIST = [];
            for(local i = 0; i < PLAYERS.len(); i++)
            {
                if(PLAYERS[i].handle != null && PLAYERS[i].handle.IsValid())
                {
                    PLAYERS_LIST.push(PLAYER_DATA(PLAYERS[i].GetNickName(), PLAYERS[i].handle));
                }
            }
            if(PLAYER_ADDM != null && type(PLAYER_ADD_MONEY_COUNT) == "integer")
            {
                local pl_c = GetPlayerClassByHandle(PLAYERS_LIST[PLAYER_ADDM].handle);
                if(pl_c != null && type(pl_c) == "instance")
                {
                    pl_c.AddMoney(PLAYER_ADD_MONEY_COUNT);
                }
                ToMapperMenu();
            }
            return PLAYERS_LIST;
        }
    }
    else if(PLAYERS_ADD_MONEY_A)
    {
        array_text.push("+10$");
        array_text.push("+50$");
        array_text.push("+100$");
        array_text.push("+250$");
        array_text.push("+500$");
        array_text.push("+1000$");
        return array_text;
    }
    else if(RUN_BOSS_FIGHT)
    {
        if(BOSS_FIGHT_C == 0)
        {
            array_text.push("BOSS: 1");
            array_text.push("BOSS: 2");
            array_text.push("BOSS: 3");
            array_text.push("BOSS: 4");
            array_text.push("BOSS: 5");
            return array_text;
        }
    }
    else if(SKIP_WAVES)
    {
        local main_scope = Entities.FindByName(null, "map_brush");
        local wave = main_scope.GetScriptScope().LEVEL_R;
        if(wave == 1)
        {
            local math_ent = Entities.FindByName(null, "unit_max_counter");
            EntFireByHandle(math_ent, "Add", "1000", 0.00, null, null);
        }
        else if(wave == 2)
        {
            local math_ent = Entities.FindByName(null, "unit_max_counter3");
            EntFireByHandle(math_ent, "Add", "1000", 0.00, null, null);
        }
        else if(wave == 3)
        {
            local math_ent = Entities.FindByName(null, "unit_max_counter4");
            EntFireByHandle(math_ent, "Add", "1000", 0.00, null, null);
        }
        else if(wave == 5)
        {
            local math_ent = Entities.FindByName(null, "unit_max_counter7");
            EntFireByHandle(math_ent, "Add", "1000", 0.00, null, null);
        }
        else if(wave == 6)
        {
            local math_ent = Entities.FindByName(null, "unit_max_counter9");
            EntFireByHandle(math_ent, "Add", "1000", 0.00, null, null);
        }
        else if(wave == 7)
        {
            local math_ent = Entities.FindByName(null, "unit_max_counter10");
            EntFireByHandle(math_ent, "Add", "1000", 0.00, null, null);
        }
        else if(wave == 9)
        {
            local math_ent = Entities.FindByName(null, "unit_max_counter13");
            EntFireByHandle(math_ent, "Add", "1000", 0.00, null, null);
        }
        else if(wave == 10)
        {
            local math_ent = Entities.FindByName(null, "unit_max_counter15");
            EntFireByHandle(math_ent, "Add", "1000", 0.00, null, null);
        }
        else if(wave == 11)
        {
            local math_ent = Entities.FindByName(null, "unit_max_counter16");
            EntFireByHandle(math_ent, "Add", "1000", 0.00, null, null);
        }
        else if(wave == 13)
        {
            local math_ent = Entities.FindByName(null, "unit_max_counter19");
            EntFireByHandle(math_ent, "Add", "1000", 0.00, null, null);
        }
        else if(wave == 14)
        {
            local math_ent = Entities.FindByName(null, "unit_max_counter21");
            EntFireByHandle(math_ent, "Add", "1000", 0.00, null, null);
        }
        else if(wave == 15)
        {
            local math_ent = Entities.FindByName(null, "unit_max_counter22");
            EntFireByHandle(math_ent, "Add", "1000", 0.00, null, null);
        }
        else if(wave == 17)
        {
            local math_ent = Entities.FindByName(null, "unit_max_counter25");
            EntFireByHandle(math_ent, "Add", "1000", 0.00, null, null);
        }
        else if(wave == 18)
        {
            local math_ent = Entities.FindByName(null, "unit_max_counter26");
            EntFireByHandle(math_ent, "Add", "1000", 0.00, null, null);
        }
        else if(wave == 19)
        {
            local math_ent = Entities.FindByName(null, "unit_max_counter29");
            EntFireByHandle(math_ent, "Add", "1000", 0.00, null, null);
        }
        ToMapperMenu();
        return array_text;
    }
    else if(PLAYERS_UP_HEAL_L)
    {
        if(PLAYERS_HEAL_UP_C == 0)
        {
            array_text.push("+1 LEVEL");
            array_text.push("+2 LEVEL");
            array_text.push("+3 LEVEL");
            array_text.push("+4 LEVEL");
            array_text.push("+5 LEVEL");
            return array_text;
        }
        else
        {
            PLAYERS_LIST = [];
            for(local i = 0; i < PLAYERS.len(); i++)
            {
                if(PLAYERS[i].handle != null && PLAYERS[i].handle.IsValid())
                {
                    PLAYERS_LIST.push(PLAYER_DATA(PLAYERS[i].GetNickName(), PLAYERS[i].handle));
                }
            }
            if(PLAYER_UPH != null && type(PLAYERS_HEAL_UP_C) == "integer")
            {
                local pl_c = GetPlayerClassByHandle(PLAYERS_LIST[PLAYER_UPH].handle);
                if(pl_c != null && type(pl_c) == "instance")
                {
                    pl_c.AddHealLevel(PLAYERS_HEAL_UP_C);
                }
                ToMapperMenu();
            }
            return PLAYERS_LIST;
        }
    }
    else if(PLAYERS_UP_AMMO_L)
    {
        if(PLAYERS_AMMO_UP_C == 0)
        {
            array_text.push("+1 LEVEL");
            array_text.push("+2 LEVEL");
            array_text.push("+3 LEVEL");
            array_text.push("+4 LEVEL");
            array_text.push("+5 LEVEL");
            return array_text;
        }
        else
        {
            PLAYERS_LIST = [];
            for(local i = 0; i < PLAYERS.len(); i++)
            {
                if(PLAYERS[i].handle != null && PLAYERS[i].handle.IsValid())
                {
                    PLAYERS_LIST.push(PLAYER_DATA(PLAYERS[i].GetNickName(), PLAYERS[i].handle));
                }
            }
            if(PLAYER_UPAMMO != null && type(PLAYERS_AMMO_UP_C) == "integer")
            {
                local pl_c = GetPlayerClassByHandle(PLAYERS_LIST[PLAYER_UPAMMO].handle);
                if(pl_c != null && type(pl_c) == "instance")
                {
                    pl_c.AddAmmoLevel(PLAYERS_AMMO_UP_C);
                }
                ToMapperMenu();
            }
            return PLAYERS_LIST;
        }
    }
    else if(PLAYERS_UP_SPEED_L)
    {
        if(PLAYERS_SPEED_UP_C == 0)
        {
            array_text.push("+1 LEVEL");
            array_text.push("+2 LEVEL");
            array_text.push("+3 LEVEL");
            array_text.push("+4 LEVEL");
            array_text.push("+5 LEVEL");
            return array_text;
        }
        else
        {
            PLAYERS_LIST = [];
            for(local i = 0; i < PLAYERS.len(); i++)
            {
                if(PLAYERS[i].handle != null && PLAYERS[i].handle.IsValid())
                {
                    PLAYERS_LIST.push(PLAYER_DATA(PLAYERS[i].GetNickName(), PLAYERS[i].handle));
                }
            }
            if(PLAYER_UPSPEED != null && type(PLAYERS_SPEED_UP_C) == "integer")
            {
                local pl_c = GetPlayerClassByHandle(PLAYERS_LIST[PLAYER_UPSPEED].handle);
                if(pl_c != null && type(pl_c) == "instance")
                {
                    pl_c.AddSpeedLevel(PLAYERS_SPEED_UP_C);
                }
                ToMapperMenu();
            }
            return PLAYERS_LIST;
        }
    }
}

function GetPlayerByNickName(name)
{
    foreach(p in PLAYERS)
    {
        if(p.name == name)
        {
            return p;
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

function CheckActionB()
{
    if(PLAYER_SLAY_MENU ||
    PLAYER_KICK_MENU ||
    PLAYER_ADD_SELF_MONEY ||
    PLAYER_ADD_P_MONEY ||
    PLAYERS_ADD_MONEY_A ||
    RUN_BOSS_FIGHT ||
    PLAYERS_UP_HEAL_L ||
    PLAYERS_UP_AMMO_L ||
    PLAYERS_UP_SPEED_L)
    {
        return false;
    }
    return true;
}

function ToMapperMenu()
{
    map_shop_menu_selected = 0;
    PLAYER_SLAY_MENU = false;
    PLAYER_SLAY = null;
    PLAYER_KICK_MENU = false;
    PLAYER_KICK = null;
    PLAYER_ADD_SELF_MONEY = false;
    PLAYER_ADD_P_MONEY = false;
    PLAYER_ADD_MONEY_COUNT = 0;
    PLAYER_ADDM = null;
    PLAYERS_ADD_MONEY_A = false;
    SKIP_WAVES = false;
    RUN_BOSS_FIGHT = false;
    BOSS_FIGHT_C = 0;
    PLAYERS_UP_HEAL_L = false;
    PLAYERS_HEAL_UP_C = 0;
    PLAYER_UPH = null;
    PLAYERS_UP_AMMO_L = false;
    PLAYERS_AMMO_UP_C = 0;
    PLAYER_UPAMMO = null;
    PLAYERS_UP_SPEED_L = false;
    PLAYERS_SPEED_UP_C = 0;
    PLAYER_UPSPEED = null;
    EntFireByHandle(self, "RunScriptCode", "PLAYER_SLAY_MENU = false;", 0.02, null, null);
    EntFireByHandle(self, "RunScriptCode", "another_menu = false;", 0.02, null, null);
}