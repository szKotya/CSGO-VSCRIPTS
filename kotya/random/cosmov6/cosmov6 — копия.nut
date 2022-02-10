Warmup <- false;
Stage  <- 0;
allow_invalid <- true;
PlayerText <- null;
ItemText <- null;
ShopHud <- null;
SpeedMod <- null;
function MapStart()
{
    if(eventjump == null || eventjump != null && !eventjump.IsValid())
    {
        eventjump = Entities.FindByName(null, "pl_jump");
    }
    if(eventdeath == null || eventdeath != null && !eventdeath.IsValid())
    {
        eventdeath = Entities.FindByName(null, "pl_death");
    }
    if(SpeedMod == null || SpeedMod != null && !SpeedMod.IsValid())
    {
        SpeedMod = Entities.FindByName(null, "speedMod");
    }
    if(eventinfo == null || eventinfo != null && !eventinfo.IsValid())
    {
        eventinfo = Entities.FindByName(null, "pl_ginfo");
    }
    if(eventdisconnect == null || eventdisconnect != null && !eventdisconnect.IsValid())
    {
        eventdisconnect = Entities.FindByName(null, "pl_disconnect");
    }
    if(eventproxy == null || eventproxy != null && !eventproxy.IsValid())
    {
        eventproxy = Entities.FindByClassname(null, "info_game_event_proxy");
    }
    if(g_zone == null || g_zone != null && !g_zone.IsValid())
    {
        g_zone = Entities.FindByName(null, "check_players");
    }
    if(ItemText == null || ItemText != null && !ItemText.IsValid())
    {
        ItemText = Entities.FindByName(null, "ItemText");
    }
    if(ShopHud == null || ShopHud != null && !ShopHud.IsValid())
    {
        ShopHud = Entities.FindByName(null, "hud_shop");
    }
    if(PlayerText == null || PlayerText != null && !PlayerText.IsValid())
    {
        PlayerText = Entities.FindByName(null, "playerText");
    }
    once_check = true;
    LoopPlayerCheck();
    ShowItems();
    EntFire("fovcamhandle", "Kill", "", 0, null);
    if(Stage == 0)
    {
        Precache();
        SetSettingServer();
        local g_round = Entities.FindByName(null, "round_end");
        local time = 10;
        ScriptPrintMessageChatAll(::Mes_Warmup)
        for (local i=0; i<4; i++)
        {
            EntFireByHandle(self, "RunScriptCode", "ScriptPrintMessageChatAll(::Mes_Warmup);", time, null, null);
            time+=10;
        }
        if(g_round != null && g_round.IsValid())
        {
            EntFireByHandle(g_round, "EndRound_Draw", "3", time+5, null, null);
        }
        EntFireByHandle(self, "RunScriptCode", "SetStage(1);", time, null, null);
    }
    else
    {
        if(Stage == 1)
        {

        }
        else if(Stage == 2)
        {

        }
        else if(Stage == 3) //zm
        {

        }
        else if(Stage == 4)
        {

        }
        else if(Stage == 5)
        {

        }
    }

    EntFireByHandle(self, "RunScriptCode", "allow_invalid = false;", 15, null, null);
    if(PLAYERS.len() > 0)
    {
        foreach(p in PLAYERS)
        {
            if(p.handle != null)
            {
                if(p.handle.IsValid())
                {
                    local hp = 10000 + p.perkhp_hm_lvl * p.perkhp_hm_hpperlvl;
                    (p.handle).SetHealth(hp);
                    (p.handle).SetMaxHealth(hp);
                    EntFireByHandle(SpeedMod, "ModifySpeed", "1", 0, p.handle, p.handle);
                    EntFireByHandle(p.handle, "AddOutput", "rendermode 0", 0, p.handle, p.handle);
                    EntFireByHandle(p.handle, "AddOutput", "renderamt 255", 0.05, p.handle, p.handle);

                    //if(p.vip)
                    //{
                        //CreatePet(p.handle,1);
                    //}

                    for(local a = 0; a < INVALID_STEAM_ID.len(); a++)
                    {
                        local steamid = split(INVALID_STEAM_ID[a]," ");
                        if(p.steamid == steamid[0])
                        {
                            SetInvalid(p.handle);
                        }
                    }
                }
            }
        }
    }
    //EntFireByHandle(self, "RunScriptCode", "SavePos();", 5, null, null);
}

function MapReset()
{
    user_bio = null;
    button_bio = true;
    cd_bio = 0;

    user_ice = null;
    button_ice = true;
    cd_ice = 0;

    user_poison = null;
    button_poison = true;
    cd_poison = 0;

    user_wind = null;
    button_wind = true;
    cd_wind = 0;

    user_summon = null;
    button_summon = true;
    cd_summon = 0;

    user_fire = null;
    button_fire = true;
    cd_fire = 0;

    user_electro = null;
    button_electro = true;
    cd_electro = 0;

    user_gravity = null;
    button_gravity = true;
    cd_gravity = 0;

    user_earth = null;
    button_earth = true;
    cd_earth = 0;

    user_ultimate = null;
    button_ultimate = true;

    user_heal = null;
    button_heal = true;
    cd_heal = 0;

    allow_invalid = true;
    if(PLAYERS.len() > 0)
    {
        foreach(p in PLAYERS)
        {
            p.invalid = false;
            p.setPerks = false;
            p.pet = null;
            p.petstatus = null;
            p.maxlvluping = 3;
            //if(Warmup)return;
            p.PassIncome();
            p.GetNewStock();

            //teleportitem
            // p.lastang.clear();
            // p.lastpos.clear();
            // p.teleporting = false;

            p.bio_count = 2;
            p.ice_count = 2;
            p.poison_count = 2;
            p.wind_count = 2;
            p.summon_count = 2;
            p.fire_count = 2;
            p.electro_count = 2;
            p.earth_count = 2;
            p.gravity_count = 2;
            p.ultimate_count = 2;
            p.heal_count = 2;

            p.speed = p.defspeed;
        }
    }
}

function SetStage(i)
{
    Stage = i;
}
function AdminSetStage(i)
{
    if(g_round != null && g_round.IsValid())
    {
        EntFireByHandle(g_round, "EndRound_Draw", "3", time+5, null, null);
    }
    Stage = i;
}
///////////////////////////////////////////////////////////
//events chat commands for admin room
PLAYERS <- [];
PLAYERS_SAVE <- [];
PL_HANDLE <- [];
TEMP_HANDLE <- null;
MAPPER_STEAM_ID <- [
"STEAM_1:1:124348087",  //kotya
"STEAM_1:1:120927227",  //kondik
"STEAM_1:0:58001308",   //Mike
"STEAM_1:1:20206338"];  //HaRyDe

VIP_STEAM_ID <-[
//"STEAM_1:0:54446629"    //FPT
];

INVALID_STEAM_ID <- [
"STEAM_1:1:124348087 1",  //kotya
//"STEAM_1:1:98076432 1"    //xmin
//"STEAM_1:1:17775692 1",//memes
"STEAM_1:0:561327146 1",  //INSIDE
"STEAM_1:0:205165205 1",  //waffle
//"STEAM_1:0:32966106 1",   //extrim
"STEAM_1:0:53585397 1",   //Imma
"STEAM_1:1:183225255 1",   //Ponya
"STEAM_1:0:16144131 1"];  //Malgo

eventinfo   <- null;
eventproxy  <- null;
eventlist   <- null;
eventdisconnect <- null;
eventsay    <- null;
eventdeath  <- null;
eventjump   <- null;

g_zone      <- null;
once_check  <- false;

user_bio    <- null;
user_ice    <- null;
user_poison <- null;
user_wind   <- null;
user_summon <- null;
user_fire   <- null;
user_electro<- null;
user_gravity<- null;
user_earth  <- null;
user_ultimate<- null;
user_heal   <- null;

button_bio      <- true;
button_ice      <- true;
button_poison   <- true;
button_wind     <- true;
button_summon   <- true;
button_fire     <- true;
button_electro  <- true;
button_gravity  <- true;
button_earth    <- true;
button_ultimate <- true;
button_heal     <- true;

cd_bio      <- 0;
cd_ice      <- 0;
cd_poison   <- 0;
cd_wind     <- 0;
cd_summon   <- 0;
cd_fire     <- 0;
cd_electro  <- 0;
cd_gravity  <- 0;
cd_earth    <- 0;
cd_ultimate <- "E";
cd_heal     <- 0;

T_Player_Check <- 5.00;

function LoopPlayerCheck()
{
    EntFireByHandle(self, "RunScriptCode", "LoopPlayerCheck();", T_Player_Check, null, null);
    if(PL_HANDLE.len() > 0){PL_HANDLE.clear();}
    EntFireByHandle(g_zone, "FireUser1", "", 0.00, null, null);
    EntFireByHandle(self, "RunScriptCode", "CheckValidInArr();", T_Player_Check*1.5, null, null);
}


///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
//RPG
moneyPerWin <- 100;
lvlcost <- [25,50,75];

perkhp_zm_cost <- 75;
perkhp_hm_cost <- 25;
perkhuckster_cost <- 50;
perkspeed_cost <- 75;
perksteal_cost <- 50;
perkchameleon_cost <- 75;
perkresist_zm_cost <- 100;
perkresist_hm_cost <- 100;
perkluck_cost <- 100;

VIP_BONUS_M <- 50;

class Item
{
    name = "";
    effect = "";

    radius1 = 0;
    radius2 = 0;
    radius3 = 0;

    duration1 = 0;
    duration2 = 0;
    duration3 = 0;

    cd1 = 0;
    cd2 = 0;
    cd3 = 0;

    damage1 = 0;
    damage2 = 0;
    damage3 = 0;

    time1 = 0;
    time2 = 0;
    time3 = 0;
    constructor(_name,_effect,_radius,_duration,_cd,_damage,_time)
    {
        name = _name;

        effect = _effect;

        local array = split(_radius," ");
        if(array.len() > 0)
        radius1 = array[0].tofloat();
        if(array.len() > 1)
        radius2 = array[1].tofloat();
        if(array.len() > 2)
        radius3 = array[2].tofloat();

        array = split(_duration," ");
        if(array.len() > 0)
        duration1 = array[0].tofloat();
        if(array.len() > 1)
        duration2 = array[1].tofloat();
        if(array.len() > 2)
        duration3 = array[2].tofloat();

        array = split(_cd," ");
        if(array.len() > 0)
        cd1 = array[0].tofloat();
        if(array.len() > 1)
        cd2 = array[1].tofloat();
        if(array.len() > 2)
        cd3 = array[2].tofloat();

        array = split(_damage," ");
        if(array.len() > 0)
        damage1 = array[0].tofloat();
        if(array.len() > 1)
        damage2 = array[1].tofloat();
        if(array.len() > 2)
        damage3 = array[2].tofloat();

        array = split(_time," ");
        if(array.len() > 0)
        time1 = array[0].tofloat();
        if(array.len() > 1)
        time2 = array[1].tofloat();
        if(array.len() > 2)
        time3 = array[2].tofloat();
    }
    function GetRadius(i)
    {
        if(i <= 1)return this.radius1;
        if(i == 2)return this.radius2;
        if(i >= 3)return this.radius3;
    }
    function GetDuration(i)
    {
        if(i <= 1)return this.duration1;
        if(i == 2)return this.duration2;
        if(i >= 3)return this.duration3;
    }
    function GetCD(i)
    {
        if(i <= 1)return this.cd1;
        if(i == 2)return this.cd2;
        if(i >= 3)return this.cd3;
    }
    function GetDamage(i)
    {
        if(i <= 1)return this.damage1;
        if(i == 2)return this.damage2;
        if(i >= 3)return this.damage3;
    }
    function GetTime(i)
    {
        if(i <= 1)return this.time1;
        if(i == 2)return this.time2;
        if(i >= 3)return this.time3;
    }
}

Item_Preset <- [];
obj <- null;
//           name  effect           radius        duration       cd                 damage              time
obj = Item("bio","slow zm"       ,"190 223 512"  ,"5 6 7"    ,"80 75 70"        ,"100 200 300"    ,"0.3 0.35 0.4");
Item_Preset.push(obj) //bio
obj = Item("ice","slow zm"       ,"360 512 600"  ,"5 6 7"    ,"80 75 70"        ,"1.1 1.2 1.3"  ,"1 2 3");
Item_Preset.push(obj) //Ice
obj = Item("poison","slow zm"    ,"360 430 512"  ,"5 6 7"    ,"5 4 3"           ,"500 750 1000"    ,"0.5 0.5 0.5");
Item_Preset.push(obj) //poison
obj = Item("wind","push zm"      ,"360 512 600"  ,"5 6 7"    ,"80 75 70"        ,"512 768 1024" ,"0.5 0.5 0.5");
Item_Preset.push(obj) //wind
obj = Item("summon","spawn chocobo","360 430 512","20 25 30" ,"80 75 70"        ,"512 768 1024" ,"4 5 6");
Item_Preset.push(obj) //summon
obj = Item("fire","burn zm"      ,"360 512 600"  ,"5 6 7"    ,"80 75 70"        ,"300 400 500"    ,"0.15 0.2 0.25");
Item_Preset.push(obj) //fire
obj = Item("electro","slow zm"   ,"360 430 512"  ,"5 6 7"    ,"80 75 70"        ,"300 400 500"    ,"0.15 0.2 0.25");
Item_Preset.push(obj) //electro
obj = Item("earth","make shield" ,"360 512 600"  ,"5 6 7"    ,"80 75 70"        ,"500 1000 2000"    ,"0.5 0.5 0.5");
Item_Preset.push(obj) //earth
obj = Item("gravity","pulls zm"  ,"360 430 512"  ,"5 6 7"    ,"80 75 70"        ,"512 768 1024" ,"0.5 0.5 0.5");
Item_Preset.push(obj) //gravity
obj = Item("ultimate","kill zm"  ,"740 920 1024"  ,"15 15 15","" ,"75 80 90"    ,"500 1000 1500");
Item_Preset.push(obj) //ultimate
obj = Item("heal","give hp"      ,"360 512 600"  ,"5 6 7"    ,"80 75 70" ,"1 2 3"    ,"0.5 0.5 0.5");
Item_Preset.push(obj) //heal

class Player
{
    invalid = false;

	userid = null;
	name = null;
	steamid = null;
	handle = null;
    mapper = false;
    vip = false;

    pet = null;
    petstatus = null;

    person_stock_one = [];

    item_buff_radius = false;
    item_buff_last = false;
    item_buff_recovery = false;
    item_buff_turbo = false;
    item_buff_doble = false;

    MaxLevel = 3;
    maxlvluping = 3;
    money = 50;

    bio_count = 2;
    ice_count = 2;
    poison_count = 2;
    wind_count = 2;
    summon_count = 2;
    fire_count = 2;
    electro_count = 2;
    earth_count = 2;
    gravity_count = 2;
    ultimate_count = 2;
    heal_count = 2;

    bio_lvl = 0;
    ice_lvl = 0;
    poison_lvl = 0;
    wind_lvl = 0;
    summon_lvl = 0;
    fire_lvl = 0;
    electro_lvl = 0;
    earth_lvl = 0;
    gravity_lvl = 0;
    ultimate_lvl = 0;
    heal_lvl = 0;

    perkhp_zm_maxlvl = 5; // 300hp
    perkhp_zm_hpperlvl = 4500;
    perkhp_zm_lvl = 0;

    perkhp_hm_maxlvl = 8; // 300hp
    perkhp_hm_hpperlvl = 25;
    perkhp_hm_lvl = 0;

    perkhuckster_maxlvl = 5; // 50%
    perkhuckster_hucksterperlvl = 10;
    perkhuckster_lvl = 0;

    perksteal_maxlvl = 3; // 15%
    perksteal_stilleperlvl = 5;
    perksteal_lvl = 0;

    perkresist_hm_maxlvl = 3;
    perkresist_hm_resistperlvl = 25;
    perkresist_hm_lvl = 0;

    setPerks = false;

    slow = false;
    defspeed = 1;
    speed = 1;

    perkspeed_maxlvl = 5; // 10%
    perkspeed_speedperlvl = 4;
    perkspeed_lvl = 0;

    perkluck_maxlvl = 5; // 50% dont touch
    perkluck_luckperlvl = 10;
    perkluck_lvl = 0;

    perkchameleon_maxlvl = 3; // 75%
    perkchameleon_chameleonperlvl = 35;
    perkchameleon_lvl = 0;

    perkresist_zm_maxlvl = 5; // 25%
    perkresist_zm_resistslowperlvl = 5;
    perkresist_zm_lvl = 0;

    // teleporting = false;
    // lastpos = [Vector(0,0,0)];
    // lastang = [Vector(0,0,0)];
    // function SetLastPos()
    // {
    //     if(this.teleporting)return;
    //     if(this.handle.IsValid())
    //     {
    //         if(this.handle.GetHealth() > 0 && this.handle.GetTeam() != 1)
    //         {
    //             if(this.lastpos.len() >= 250)
    //             {
    //                 this.lastpos.remove(0);
    //                 this.lastang.remove(0);
    //             }
    //             if(this.lastpos.len() > 2)
    //             {
    //                 local a1 = this.lastpos[this.lastpos.len() - 1];
    //                 local a2 = this.handle.GetOrigin();
    //                 if(a1.x != a2.x || a1.y != a2.y || a1.z != a2.z)
    //                 {
    //                     this.lastpos.push(a2);
    //                     this.lastang.push(this.handle.GetAngles());
    //                 }
    //             }
    //             else
    //             {
    //                 this.lastpos.push(this.handle.GetOrigin());
    //                 this.lastang.push(this.handle.GetAngles());
    //             }
    //         }
    //     }
    //     return;
    // }

    function Set_money(i)
    {
        this.money = i;
        return
    }
    function Add_money(i)
    {
        local MoneyText = Entities.FindByName(null, "pl_add_money");
        EntFireByHandle(MoneyText, "SetText", "+ "+i+"$", 0, this.handle, this.handle);
        EntFireByHandle(MoneyText, "Display", "", 0, this.handle, this.handle);
        this.money += i;
        return
    }
    function Minus_money(i)
    {
        local MoneyText = Entities.FindByName(null, "pl_minus_money");
        EntFireByHandle(MoneyText, "SetText", "- "+i+"$", 0, this.handle, this.handle);
        EntFireByHandle(MoneyText, "Display", "", 0, this.handle, this.handle);
        if(this.money - i <= 0)
        {
            this.money = 0;
            return
        }
        this.money -= i;
        return;
    }

    function Set_Speed(i)
    {
        this.speed = i;
        return
    }
    function Add_speed(i)
    {
        if(this.defspeed <= this.speed + i)return this.speed = this.defspeed;
        return this.speed += i;
    }
    function Remove_speed(i)
    {
        this.slow = true;
        if(this.handle.GetTeam() == 2)
        {
            local minspeed = this.perkresist_zm_lvl * this.perkresist_zm_resistslowperlvl * 0.008
            if(this.speed - i <= minspeed)return this.speed = minspeed;
        }
        else
        {
            local minspeed = this.perkresist_hm_resistperlvl * 0.008
            if(this.speed - i <= minspeed)return this.speed = minspeed;
        }
        return this.speed -= i;
    }
    function ReturnSpeed()
    {
        if(slow)
        {
            this.slow = false;
            this.speed = this.defspeed;
            return this.defspeed;
        }
    }

    function Set_level_perkluck(i)
    {
        return this.perkluck_lvl = i;
    }
    function level_up_perkluck()
    {
        if(this.perkluck_lvl < this.perkluck_maxlvl)
        {
            this.perkluck_lvl++;
        }
    }



    function Set_level_perkchameleon(i)
    {
        return this.perkchameleon_lvl = i;
    }
    function level_up_perkchameleon()
    {
        if(this.perkchameleon_lvl < this.perkchameleon_maxlvl)
        {
            this.setPerks = false;
            this.perkchameleon_lvl++;
        }
    }

    function Set_level_perkresist_hm(i)
    {
        return this.perkresist_hm_lvl = i;
    }
    function level_up_perkresist_hm()
    {
        if(this.perkresist_hm_lvl < this.perkresist_hm_maxlvl)
        {
            this.perkresist_hm_lvl++;
        }
    }

    function Get_Resist_From_First_lvl(i)
    {
       if(this.perkresist_hm_lvl < 1)return i;
       return i - i * 0.01 * perkresist_hm_resistperlvl;
    }

    function Get_Resist_From_Second_lvl(i)
    {
       if(this.perkresist_hm_lvl < 2)return i;
       return i - i * 0.01 * perkresist_hm_resistperlvl;
    }

    function Get_Resist_From_Third_lvl(i)
    {
       if(this.perkresist_hm_lvl < 3)return i;
       return i - i * 0.01 * perkresist_hm_resistperlvl;
    }

    function Set_level_perkresist_zm(i)
    {
        return this.perkresist_zm_lvl = i;
    }
    function level_up_perkresist_zm()
    {
        if(this.perkresist_zm_lvl < this.perkresist_zm_maxlvl)
        {
            this.setPerks = false;
            this.perkresist_zm_lvl++;
        }
    }

    function Get_Resist_From_Slow(i)
    {
        if(this.handle.GetTeam() == 2)
        {
            if(this.perkresist_zm_lvl == 0)return i;
            return i - i * 0.01 * this.perkresist_zm_lvl * this.perkresist_zm_resistslowperlvl;
        }
        else
        {
            if(this.perkresist_hm_lvl < 3)return i;
            return i - i * 0.01 * this.perkresist_hm_resistperlvl;
        }
    }
    function Get_Resist_From_ItemDamage(i)
    {
        if(this.perkresist_zm_lvl == 0)return i;
        return i - i * 0.01 * this.perkresist_zm_lvl * this.perkresist_zm_resistslowperlvl;
    }


    // function GetNewPatern(array)
    // {
    //     local array_sum_all = 0;
    //     for(local i = 0; i < patern.len(); i++)
    //     {
    //         array_sum_all += patern[i];
    //     }
    //     local midle = array_sum_all / patern.len()
    //     local min_index = [];
    //     local max_index = [];
    //     for (local i = 0; i < patern.len(); i++)
    //     {
    //         if(patern[i] >= midle)min_index.push(i);
    //         else max_index.push(i);
    //     }
    //     if(min_index.len() > 1)patern[0] -= midle;
    //     else
    //     {
    //         local loc_midle = midle;
    //         for (local i = 0; i < min_index.len(); i++)
    //         {
    //             patern[min_index[i]] -= midle;
    //             loc_midle /= 2;
    //         }
    //     }
    //     if(max_index.len() > 1)patern[patern.len()-1] += midle;
    //     else
    //     {
    //         local loc_midle = midle;
    //         for (local i = 0; i < max_index.len(); i++)
    //         {
    //             patern[max_index[i]] += midle;
    //             loc_midle /= 2;
    //         }
    //     }
    //     return array;
    // }

    function GetChance(array)
    {
        local total_chance_sum = 0;
        for (local i = 0; i < array.len(); i++)
        {
            total_chance_sum += array[i];
        }
        local r = RandomInt(0, total_chance_sum);
        local current_sum = 0;
        for(local i = 0; i < array.len(); i++)
        {
            if (current_sum <= r && r < current_sum + array[i])return i;
            current_sum += array[i];
        }
    }
    function PassIncome()
    {
        local luck_level = perkluck_lvl;
        local p_money = 25;
        local chance = [0,0,0,0,0];
        if(luck_level > 0)
        {
            if(luck_level == 1)chance = [45,35,30,20,10];
            if(luck_level == 2)chance = [35,45,35,25,20];
            if(luck_level == 3)chance = [30,35,45,35,30];
            if(luck_level == 4)chance = [20,25,35,45,35];
            if(luck_level == 5)chance = [10,20,30,35,45];
            p_money * luck_level;

            local index = GetChance(chance);
            if(index != null)
            {
                p_money += 5 * index;
            }
        }

        Add_money(p_money)
    }
    function GetNewStock()
    {
        this.person_stock_one.clear();
        local count = [0,1,2,3];
        local chance = [60,30,10,0];
        local luck_level = perkluck_lvl;
        if(luck_level > 0)
        {
            local bonus = [-12,-4,11,5];
            for (local i = 0; i<chance.len(); i++)
            {
                chance[i] += bonus[i] * luck_level;
            }
            // if(luck_level == 1)chance = [48,26,21,5];
            // if(luck_level == 2)chance = [36,22,32,10];
            // if(luck_level == 3)chance = [24,18,43,15];
            // if(luck_level == 4)chance = [12,14,54,20];
            // if(luck_level == 5)chance = [0,10,65,25];
        }
        local index = GetChance(chance);
        if(index != null)
        {
            local array = ["bio","ice",
            "poison","wind","summon",
            "fire","electro","earth",
            "gravity","ultimate","heal"];

            local arraylen = array.len() - index;
            for(local i = 0; i < arraylen; i++)
            {
                local random = RandomInt(0,array.len() - 1);
                array.remove(random);
            }
            for(local i = 0; i < array.len(); i++)
            {
                this.person_stock_one.push(array[i]);
            }
        }

    }
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
    function SetMapper()
    {
        if(!this.mapper)
        {
            return this.mapper = true;
        }
    }
    function SetVip()
    {
        if(!this.vip)
        {
            return this.vip = true;
        }
    }
    function Set_level_perkhp_zm(i)
    {
        return this.perkhp_zm_lvl = i;
    }
    function level_up_perkheal_zm()
    {
        if(this.perkhp_zm_lvl < this.perkhp_zm_maxlvl)
        {
            this.setPerks = false;
            this.perkhp_zm_lvl++;
        }
    }
    function Set_level_perkhp_hm(i)
    {
        return this.perkhp_hm_lvl = i;
    }
    function level_up_perkheal_hm()
    {
        if(this.perkhp_hm_lvl < this.perkhp_hm_maxlvl)
        {
            this.perkhp_hm_lvl++;
        }
    }
    function GetNewPrice(i)
    {
        if(this.perkhuckster_lvl == 0)return i;
        return i - (i * this.perkhuckster_hucksterperlvl * this.perkhuckster_lvl * 0.01);
    }

    function Set_level_perkhuck(i)
    {
        return this.perkhuckster_lvl = i;
    }
    function level_up_perkhuck()
    {
        if(this.perkhuckster_lvl < this.perkhuckster_maxlvl)
        {
            this.perkhuckster_lvl++;
        }
    }
    function Set_level_perkspeed(i)
    {
        return this.perkspeed_lvl = i;
    }
    function level_up_perkspeed()
    {
        if(this.perkspeed_lvl < perkspeed_maxlvl)
        {
            this.setPerks = false;
            this.perkspeed_lvl++;
            this.defspeed = 1 + (this.perkspeed_lvl * this.perkspeed_speedperlvl * 0.01);
        }
    }
    function Set_level_perksteal(i)
    {
        return this.perksteal_lvl = i;
    }
    function level_up_perksteal()
    {
        if(this.perksteal_lvl < this.perksteal_maxlvl)
        {
            this.perksteal_lvl++;
        }
    }
    function Set_level_bio(i)return this.bio_lvl = i;
    function Set_level_ice(i)return this.ice_lvl = i;
    function Set_level_poison(i)return this.poison_lvl = i;
    function Set_level_wind(i)return this.wind_lvl = i;
    function Set_level_summon(i)return this.summon_lvl = i;
    function Set_level_fire(i)return this.fire_lvl = i;
    function Set_level_electro(i)return this.electro_lvl = i;
    function Set_level_earth(i)return this.earth_lvl = i;
    function Set_level_gravity(i)return this.gravity_lvl = i;
    function Set_level_ultimate(i)return this.ultimate_lvl = i;
    function Set_level_heal(i)return this.heal_lvl = i;
    function level_up_bio()
    {
        if(this.bio_lvl < this.MaxLevel)
        {
            this.bio_lvl++;
            return false;
        }
        return true;
    }
    function level_up_ice()
    {
        if(this.ice_lvl < this.MaxLevel)
        {
            this.ice_lvl++;
            return false;
        }
        return true;
    }
    function level_up_poison()
    {
        if(this.poison_lvl < this.MaxLevel)
        {
            this.poison_lvl++;
            return false;
        }
        return true;
    }
    function level_up_wind()
    {
        if(this.wind_lvl < this.MaxLevel)
        {
            this.wind_lvl++;
            return false;
        }
        return true;
    }
    function level_up_summon()
    {
        if(this.summon_lvl < this.MaxLevel)
        {
            this.summon_lvl++;
            return false;
        }
        return true;
    }
    function level_up_fire()
    {
        if(this.fire_lvl < this.MaxLevel)
        {
            this.fire_lvl++;
            return false;
        }
        return true;
    }
    function level_up_electro()
    {
        if(this.electro_lvl < this.MaxLevel)
        {
            this.electro_lvl++;
            return false;
        }
        return true;
    }
    function level_up_earth()
    {
        if(this.earth_lvl < this.MaxLevel)
        {
            this.earth_lvl++;
            return false;
        }
        return true;
    }
    function level_up_gravity()
    {
        if(this.gravity_lvl < this.MaxLevel)
        {
            this.gravity_lvl++;
            return false;
        }
        return true;
    }
    function level_up_ultimate()
    {
        if(this.ultimate_lvl < this.MaxLevel)
        {
            this.ultimate_lvl++;
            return false;
        }
        return true;
    }
    function level_up_heal()
    {
        if(this.heal_lvl < this.MaxLevel)
        {
            this.heal_lvl++;
            return false;
        }
        return true;
    }
}

function tick()
{
    local pl = GetPlayerClassByHandle(activator);
    ScriptPrintMessageCenterAll(button_heal.tostring());
    EntFireByHandle(self, "RunScriptCode", "tick()", 0.1, activator, activator);
}

function DamagePlayer(i,typedamage = null)
{
    local pl = GetPlayerClassByHandle(activator);
    local newi = i;
    printl(typedamage);
    if(typedamage != null)
    {
        if(typedamage == "item")
        {
            newi = pl.Get_Resist_From_ItemDamage(i);
        }
        else if (typedamage == "lvl1")
        {
            newi = pl.Get_Resist_From_First_lvl(i);
        }
        else if (typedamage == "lvl2")
        {
            newi = pl.Get_Resist_From_Second_lvl(i);
        }
        else if (typedamage == "lvl3")
        {
            newi = pl.Get_Resist_From_Third_lvl(i);
        }
    }


    local hp = activator.GetHealth() - newi;
    if(hp <= 0)
    {
        EntFireByHandle(activator,"SetHealth","0",0.00,null,null);
    }
    else
    {
        activator.SetHealth(hp);
    }
}

function SlowPlayer(i,time = 0)
{
    local pl = GetPlayerClassByHandle(activator);
    local newi = pl.Get_Resist_From_Slow(i);

    EntFireByHandle(SpeedMod, "ModifySpeed", (pl.Remove_speed(newi)).tostring(), 0, activator, activator);
    if(time == 0)return;
    EntFireByHandle(self, "RunScriptCode", "ReturnPlayerSpeed("+i.tostring()+")", time, activator, activator);
}

function ReturnPlayerSpeed(i)
{
    local pl = GetPlayerClassByHandle(activator);
    local newi = pl.Get_Resist_From_Slow(i);

    if(!(pl.slow))return;
    EntFireByHandle(SpeedMod, "ModifySpeed", (pl.Add_speed(newi)).tostring(), 0, activator, activator);
}

function UnSlowPlayer()
{
    local pl = GetPlayerClassByHandle(activator);
    if(!(pl.slow))return;
    EntFireByHandle(SpeedMod, "ModifySpeed", (pl.ReturnSpeed()).tostring(), 0, activator, activator);
}

function MoveKnife()
{
   	local oldKnife = null;
	while((oldKnife = Entities.FindByClassname(oldKnife,"weapon_knife*")) != null)
	{
		if(oldKnife.GetOwner() == null)
		{
			oldKnife.__KeyValueFromString("classname","weapon_knifegg");
            return;
		}
	}
}

function PrintText_Item(pl)
{
    local text = "";
    if(pl.bio_lvl > 0)text += "Bio <- ["+pl.bio_lvl+"/"+pl.MaxLevel+"]\n";
    if(pl.ice_lvl > 0)text += "Ice <- ["+pl.ice_lvl+"/"+pl.MaxLevel+"]\n";
    if(pl.poison_lvl > 0)text += "Poison <- ["+pl.poison_lvl+"/"+pl.MaxLevel+"]\n";
    if(pl.wind_lvl > 0)text += "Wind <- ["+pl.wind_lvl+"/"+pl.MaxLevel+"]\n";
    if(pl.summon_lvl > 0)text += "Summon <- ["+pl.summon_lvl+"/"+pl.MaxLevel+"]\n";
    if(pl.fire_lvl > 0)text += "Fire <- ["+pl.fire_lvl+"/"+pl.MaxLevel+"]\n";
    if(pl.electro_lvl > 0)text += "Electro <- ["+pl.electro_lvl+"/"+pl.MaxLevel+"]\n";
    if(pl.earth_lvl > 0)text += "Earth <- ["+pl.earth_lvl+"/"+pl.MaxLevel+"]\n";
    if(pl.gravity_lvl > 0)text += "Gravity <- ["+pl.gravity_lvl+"/"+pl.MaxLevel+"]\n";
    if(pl.ultimate_lvl > 0)text += "Ultima <- ["+pl.ultimate_lvl+"/"+pl.MaxLevel+"]\n";
    if(pl.heal_lvl > 0)text += "Heal <- ["+pl.heal_lvl+"/"+pl.MaxLevel+"]\n";
    if(text == "")text += "No item lvl";
    return text;
}

function PrintText_Info(pl)
{
    local text = "";
    text += "NAME <- "+pl.name+"\n";
    text += "STEAMID <- "+pl.steamid+"\n";
    text += "MONEY <- "+pl.money+"\n";
    text += "MAPPER <- ";
    if(pl.mapper){text += "Yes";}else{text += "No";}
    text += "\nVIP <- ";
    if(pl.vip){text +="Yes";}else{text += "No";}
    text += "\nINVALID <- ";
    if(pl.invalid){text +="Yes";}else{text += "No";}
    text += "\nLVLup <- ";
    if(pl.maxlvluping == 0){text +="No";}else{text += pl.maxlvluping;}

    return text;
}

function PrintText_Perk(pl)
{
    local text = "";
    if(pl.perkhuckster_lvl > 0)text += "Huckster <- ["+pl.perkhuckster_lvl+"/"+pl.perkhuckster_maxlvl+"]\n";
    if(pl.perksteal_lvl > 0)text += "Steal <- ["+pl.perksteal_lvl+"/"+pl.perksteal_maxlvl+"]\n";
    if(pl.perkchameleon_lvl > 0)text += "Chameleon <- ["+pl.perkchameleon_lvl+"/"+pl.perkchameleon_maxlvl+"]\n";
    if(pl.perkluck_lvl > 0)text += "Luck <- ["+pl.perkluck_lvl+"/"+pl.perkluck_maxlvl+"]\n";
    if(text == "")text += "No perk";
    return text;
}

function PrintText_Perk_zm(pl)
{
    local text = "";
    if(pl.perkhp_zm_lvl > 0)text += "HP <- ["+pl.perkhp_zm_lvl+"/"+pl.perkhp_zm_maxlvl+"]\n";
    if(pl.perkspeed_lvl > 0)text += "Speed <- ["+pl.perkspeed_lvl+"/"+pl.perkspeed_maxlvl+"]\n";
    if(pl.perkchameleon_lvl > 0)text += "Chameleon <- ["+pl.perkchameleon_lvl+"/"+pl.perkchameleon_maxlvl+"]\n";
    if(pl.perkresist_zm_lvl > 0)text += "Item resist <- ["+pl.perkresist_zm_lvl+"/"+pl.perkresist_zm_maxlvl+"]\n";
    if(text == "")text += "No perk";
    return text;
}

function PrintText_Perk_hm(pl)
{
    local text = "";
    if(pl.perkhp_hm_lvl > 0)text += "HP <- ["+pl.perkhp_hm_lvl+"/"+pl.perkhp_hm_maxlvl+"]\n";
    if(pl.perkresist_hm_lvl > 0)text += "Resist <- ["+pl.perkresist_hm_lvl+"/"+pl.perkresist_hm_maxlvl+"]\n";
    if(pl.item_buff_radius)text += "Increased radius <- Yes\n";
    if(pl.item_buff_last)text += "Last chance radius <- Yes\n";
    if(pl.item_buff_recovery)text += "Fast recovery <- Yes\n";
    if(pl.item_buff_turbo)text += "Increased duration <- Yes\n";
    if(pl.item_buff_doble)text += "Double charge <- Yes\n";

    if(text == "")text += "No perk";
    return text;
}

class Pet
{
    originx = null;
    originy = null;
    originz = null;

    anglesx = null;
    anglesy = null;
    anglesz = null;

    model_path = null;
    anim_run = null;
    anim_jump = null;
    anim_idle = null;

    color_rmi = null;
    color_rmx = null;

    color_gmi = null;
    color_gmx = null;

    color_bmi = null;
    color_bmx = null;

    scale = null;
    anim_toidle = null;

    constructor(_origin,_model_path,_anim_run,_anim_jump,_anim_idle,_toanim_idle,_color_r,_color_g,_color_b,_angles,_scale)
    {
        local _origin = split(_origin," ");
        originx = _origin[0].tointeger();
        originy = _origin[1].tointeger();
        originz = _origin[2].tointeger();

        model_path = _model_path;
        anim_run = _anim_run;
        anim_jump = _anim_jump;
        anim_idle = _anim_idle;
        anim_toidle = _toanim_idle;

        local _color_r = split(_color_r,"-");
        color_rmi = _color_r[0].tointeger();
        color_rmx = _color_r[1].tointeger();

        local _color_g = split(_color_g,"-");
        color_gmi = _color_g[0].tointeger();
        color_gmx = _color_g[1].tointeger();

        local _color_b = split(_color_b,"-");
        color_bmi = _color_b[0].tointeger();
        color_bmx = _color_b[1].tointeger();

        local _angles = split(_angles," ");
        anglesx = _angles[0].tointeger();
        anglesy = _angles[1].tointeger();
        anglesz = _angles[2].tointeger();

        scale = _scale;
    }
}

Pet_Preset <- [];

function CreatePet(Handle,i)
{
    local pl = GetPlayerClassByHandle(Handle)
    if(GetPlayerClassByHandle(Handle).pet != null)GetPlayerClassByHandle(Handle).pet.Destroy();

    local pet = Entities.CreateByClassname("prop_dynamic");

    pet.SetModel(Pet_Preset[i].model_path)

    pet.__KeyValueFromString("modelscale", Pet_Preset[i].scale)

    pet.__KeyValueFromString("rendercolor",
    RandomInt(Pet_Preset[i].color_rmi,Pet_Preset[i].color_rmx).tostring()+" "+
    RandomInt(Pet_Preset[i].color_gmi,Pet_Preset[i].color_gmx).tostring()+" "+
    RandomInt(Pet_Preset[i].color_bmi,Pet_Preset[i].color_bmx).tostring());

    local ang = Handle.GetAngles().y;
    pet.SetAngles(
    0 + Pet_Preset[i].anglesx,
    ang + Pet_Preset[i].anglesy,
    0 + Pet_Preset[i].anglesz);

    pet.SetOrigin(Handle.GetOrigin()
    + Handle.GetForwardVector() * Pet_Preset[i].originx
    + Handle.GetLeftVector() * Pet_Preset[i].originy
    + Handle.GetUpVector() * Pet_Preset[i].originz)

    EntFireByHandle(pet, "SetParent", "!activator", 0, Handle, Handle);
    pl.pet = pet;
    pl.petstatus = "IDLE";

    EntFireByHandle(pet, "SetDefaultAnimation", Pet_Preset[i].anim_idle, 0, Handle, Handle);
    EntFireByHandle(pet, "SetAnimation", Pet_Preset[i].anim_idle, 0, Handle, Handle);
}
///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
//Shop manager

function BuyReRollStock()
{
    local pl = GetPlayerClassByHandle(activator);
    local needmoney = null;

    local money = 10;

    if(pl.money >= pl.GetNewPrice(money))
    {
        pl.Minus_money(pl.GetNewPrice(money));
        pl.GetNewStock();
        local itemtext = "";
        local stock = pl.person_stock_one;
        if(stock.len() > 0)
        {
            for (local i = 0; i < stock.len(); i++)
            {
                if(stock[i] == "bio")itemtext += "|bio|";
                else if(stock[i] == "ice")itemtext += "|ice|";
                else if(stock[i] == "poison")itemtext += "|poison|";
                else if(stock[i] == "wind")itemtext += "|wind|";
                else if(stock[i] == "summon")itemtext += "|summon|";
                else if(stock[i] == "electro")itemtext += "|electro|";
                else if(stock[i] == "earth")itemtext += "|earth|";
                else if(stock[i] == "gravity")itemtext += "|gravity|";
                else if(stock[i] == "ultimate")itemtext += "|ultima|";
                else if(stock[i] == "heal")itemtext += "|heal|";
            }
        }
        else itemtext = "nope"
        local text = "You buy reroll Stock\n"+itemtext+"\nYour balance "+pl.money+"$";
        ShopHud.__KeyValueFromString("message",text);
        EntFireByHandle(ShopHud, "ShowHudHint", "", 0, activator, activator);
        return;
    }
    needmoney = pl.GetNewPrice(money);
    local text = "You don't have enough money! \nReroll cost "+needmoney+"$\nYour balance "+pl.money+"$";
    ShopHud.__KeyValueFromString("message",text);
    EntFireByHandle(ShopHud, "ShowHudHint", "", 0, activator, activator);
}

function BuyStock()
{
    local pl = GetPlayerClassByHandle(activator);
    local stocklen = pl.person_stock_one.len();
    if(stocklen == 0)return BuyStockNo(activator);
    local needmoney = 0;

    local lvlprice = 0;
    for (local i = 0; i < lvlcost.len(); i++)lvlprice += lvlcost[i];

    local money = stocklen * (lvlprice - lvlprice * 0.2);

    if(pl.money >= pl.GetNewPrice(money))
    {
        pl.Minus_money(pl.GetNewPrice(money));
        local itemtext = "";
        local item_array = pl.person_stock_one;
        for (local i = 0; i < stocklen; i++)
        {
            if(item_array[i] == "bio")
            {
                pl.Set_level_bio(3);
                itemtext += "|bio|";
            }
            else if(item_array[i] == "ice")
            {
                pl.Set_level_ice(3);
                itemtext += "|ice|";
            }
            else if(item_array[i] == "poison")
            {
                pl.Set_level_poison(3);
                itemtext += "|poison|";
            }
            else if(item_array[i] == "wind")
            {
                pl.Set_level_wind(3);
                itemtext += "|wind|";
            }
            else if(item_array[i] == "summon")
            {
                pl.Set_level_summon(3);
                itemtext += "|summon|";
            }
            else if(item_array[i] == "electro")
            {
                pl.Set_level_electro(3);
                itemtext += "|electro|";
            }
            else if(item_array[i] == "earth")
            {
                pl.Set_level_earth(3);
                itemtext += "|earth|";
            }
            else if(item_array[i] == "gravity")
            {
                pl.Set_level_gravity(3);
                itemtext += "|gravity|";
            }
            else if(item_array[i] == "ultimate")
            {
                pl.Set_level_ultimate(3);
                itemtext += "|ultima|";
            }
            else if(item_array[i] == "heal")
            {
                pl.Set_level_heal(3);
                itemtext += "|heal|";
            }
        }
        if(itemtext == "")itemtext = "nope";
        local text = "You buy Stock\n"+itemtext+"\nYour balance "+pl.money+"$";
        ShopHud.__KeyValueFromString("message",text);
        EntFireByHandle(ShopHud, "ShowHudHint", "", 0, activator, activator);
        return;
    }
    needmoney = pl.GetNewPrice(money);

    local text = "You don't have enough money! \nStock cost "+needmoney+"$\nYour balance "+pl.money+"$";
    ShopHud.__KeyValueFromString("message",text);
    EntFireByHandle(ShopHud, "ShowHudHint", "", 0, activator, activator);
}

function BuyPerk()
{
    local name = caller.GetName();
    local pl = GetPlayerClassByHandle(activator);
    local needmoney = null;

    if(name.find("hp_hm") != null)
    {
        local lvl = pl.perkhp_hm_lvl;
        if(lvl == pl.perkhp_hm_maxlvl)return BuyPerkMax(activator)
        if(pl.money >= pl.GetNewPrice(perkhp_hm_cost))
        {
            pl.level_up_perkheal_hm();
            pl.Minus_money(pl.GetNewPrice(perkhp_hm_cost));

            if(activator.GetTeam() == 3)
            {
                activator.SetHealth(activator.GetHealth() + pl.perkhp_hm_hpperlvl);
                activator.SetMaxHealth(100 + pl.perkhp_hm_lvl * pl.perkhp_hm_hpperlvl);
            }

            local text = "You buy "+pl.perkhp_hm_lvl+" level hm hp \nYour balance "+pl.money+"$";
            ShopHud.__KeyValueFromString("message",text);
            EntFireByHandle(ShopHud, "ShowHudHint", "", 0, activator, activator);
            return;
        }
        needmoney = pl.GetNewPrice(perkhp_hm_cost);
    }
    else if(name.find("hp_zm") != null)
    {
        local lvl = pl.perkhp_zm_lvl;
        if(lvl == pl.perkhp_zm_maxlvl)return BuyPerkMax(activator)
        if(pl.money >= pl.GetNewPrice(perkhp_zm_cost))
        {
            pl.level_up_perkheal_zm();
            pl.Minus_money(pl.GetNewPrice(perkhp_zm_cost));

            if(activator.GetTeam() == 2 && activator.GetHealth() >= 600)
            {
                activator.SetHealth(activator.GetHealth() + pl.perkhp_zm_hpperlvl);
                activator.SetMaxHealth(7500 + pl.perkhp_zm_lvl * pl.perkhp_zm_hpperlvl);
            }

            local text = "You buy "+pl.perkhp_zm_lvl+" level zm hp \nYour balance "+pl.money+"$";
            ShopHud.__KeyValueFromString("message",text);
            EntFireByHandle(ShopHud, "ShowHudHint", "", 0, activator, activator);
            return;
        }
        needmoney = pl.GetNewPrice(perkhp_zm_cost);
    }
    else if(name.find("huckster") != null)
    {
        local lvl = pl.perkhuckster_lvl;
        if(lvl == pl.perkhuckster_maxlvl)return BuyPerkMax(activator)
        if(pl.money >= perkhuckster_cost)
        {
            pl.level_up_perkhuck();
            pl.Minus_money(perkhuckster_cost);

            local text = "You buy "+pl.perkhuckster_lvl+" level huckster \nYour balance "+pl.money+"$";
            ShopHud.__KeyValueFromString("message",text);
            EntFireByHandle(ShopHud, "ShowHudHint", "", 0, activator, activator);
            return;
        }
        needmoney = perkhuckster_cost;
    }
     else if(name.find("speed") != null)
    {
        local lvl = pl.perkspeed_lvl;
        if(lvl == pl.perkspeed_maxlvl)return BuyPerkMax(activator)
        if(pl.money >= pl.GetNewPrice(perkspeed_cost))
        {
            pl.level_up_perkspeed();
            pl.Minus_money(pl.GetNewPrice(perkspeed_cost));

            local text = "You buy "+pl.perkspeed_lvl+" level speed \nYour balance "+pl.money+"$";
            ShopHud.__KeyValueFromString("message",text);
            EntFireByHandle(ShopHud, "ShowHudHint", "", 0, activator, activator);
            return;
        }
        needmoney = pl.GetNewPrice(perkspeed_cost);
    }
    else if(name.find("steal") != null)
    {
        local lvl = pl.perksteal_lvl;
        if(lvl == pl.perksteal_maxlvl)return BuyPerkMax(activator)
        if(pl.money >= pl.GetNewPrice(perksteal_cost))
        {
            pl.level_up_perksteal();
            pl.Minus_money(pl.GetNewPrice(perksteal_cost));

            local text = "You buy "+pl.perksteal_lvl+" level steal \nYour balance "+pl.money+"$";
            ShopHud.__KeyValueFromString("message",text);
            EntFireByHandle(ShopHud, "ShowHudHint", "", 0, activator, activator);
            return;
        }
        needmoney = pl.GetNewPrice(perksteal_cost);
    }
    else if(name.find("chameleon") != null)
    {
        local lvl = pl.perkchameleon_lvl;
        if(lvl == pl.perkchameleon_maxlvl)return BuyPerkMax(activator)
        if(pl.money >= pl.GetNewPrice(perkchameleon_cost))
        {
            pl.level_up_perkchameleon();
            pl.Minus_money(pl.GetNewPrice(perkchameleon_cost));

            local text = "You buy "+pl.perkchameleon_lvl+" level chameleon \nYour balance "+pl.money+"$";
            ShopHud.__KeyValueFromString("message",text);
            EntFireByHandle(ShopHud, "ShowHudHint", "", 0, activator, activator);
            return;
        }
        needmoney = pl.GetNewPrice(perkchameleon_cost);
    }
    else if(name.find("resist_zm") != null)
    {
        local lvl = pl.perkresist_zm_lvl;
        if(lvl == pl.perkresist_zm_maxlvl)return BuyPerkMax(activator)
        if(pl.money >= pl.GetNewPrice(perkresist_zm_cost))
        {
            pl.level_up_perkresist_zm();
            pl.Minus_money(pl.GetNewPrice(perkresist_zm_cost));

            local text = "You buy "+pl.perkresist_zm_lvl+" level resist items \nYour balance "+pl.money+"$";
            ShopHud.__KeyValueFromString("message",text);
            EntFireByHandle(ShopHud, "ShowHudHint", "", 0, activator, activator);
            return;
        }
        needmoney = pl.GetNewPrice(perkresist_zm_cost);
    }
    if(name.find("resist_hm") != null)
    {
        local lvl = pl.perkresist_hm_lvl;
        if(lvl == pl.perkresist_hm_maxlvl)return BuyPerkMax(activator)
        if(pl.money >= pl.GetNewPrice(perkresist_hm_cost))
        {
            pl.level_up_perkresist_hm();
            pl.Minus_money(pl.GetNewPrice(perkresist_hm_cost));

            local text = "You buy "+pl.perkresist_hm_lvl+" level resist \nYour balance "+pl.money+"$";
            ShopHud.__KeyValueFromString("message",text);
            EntFireByHandle(ShopHud, "ShowHudHint", "", 0, activator, activator);
            return;
        }
        needmoney = pl.GetNewPrice(perkresist_hm_cost);
    }
    else if(name.find("luck") != null)
    {
        local lvl = pl.perkluck_lvl;
        if(lvl == pl.perkluck_maxlvl)return BuyPerkMax(activator)
        if(pl.money >= pl.GetNewPrice(perkluck_cost))
        {
            pl.level_up_perkluck();
            pl.Minus_money(pl.GetNewPrice(perkluck_cost));

            local text = "You buy "+pl.perkluck_lvl+" level luck \nYour balance "+pl.money+"$";
            ShopHud.__KeyValueFromString("message",text);
            EntFireByHandle(ShopHud, "ShowHudHint", "", 0, activator, activator);
            return;
        }
        needmoney = pl.GetNewPrice(perkluck_cost);
    }
    local text = "You don't have enough money! \nLevel of perk cost "+needmoney+"$\nYour balance "+pl.money+"$";
    ShopHud.__KeyValueFromString("message",text);
    EntFireByHandle(ShopHud, "ShowHudHint", "", 0, activator, activator);
}

function BuyLevelMax(handle)
{
    local text = "You have already max level of your item";
    ShopHud.__KeyValueFromString("message",text);
    EntFireByHandle(ShopHud, "ShowHudHint", "", 0, handle, handle);
}

function BuyLevelUpItem()
{
    local name = caller.GetName();
    local pl = GetPlayerClassByHandle(activator);
    local needmoney = null;

    if(name.find("bio") != null)
    {
        local lvl = pl.bio_lvl;
        if(lvl == 3)return BuyLevelMax(activator)
        if(pl.money >= pl.GetNewPrice(lvlcost[lvl]))
        {
            pl.level_up_bio();
            pl.Minus_money(pl.GetNewPrice(lvlcost[lvl]));
            local text = "You buy "+pl.bio_lvl+" level Bio \nYour balance "+pl.money+"$";
            ShopHud.__KeyValueFromString("message",text);
            EntFireByHandle(ShopHud, "ShowHudHint", "", 0, activator, activator);
            return;
        }
        needmoney = pl.GetNewPrice(lvlcost[lvl]);
    }
    else if(name.find("ice") != null)
    {
        local lvl = pl.ice_lvl;
        if(lvl == 3)return BuyLevelMax(activator)
        if(pl.money >= pl.GetNewPrice(lvlcost[lvl]))
        {
            pl.level_up_ice();
            pl.Minus_money(pl.GetNewPrice(lvlcost[lvl]));
            local text = "You buy "+pl.ice_lvl+" level Ice \nYour balance "+pl.money+"$";
            ShopHud.__KeyValueFromString("message",text);
            EntFireByHandle(ShopHud, "ShowHudHint", "", 0, activator, activator);
            return;
        }
        needmoney = pl.GetNewPrice(lvlcost[lvl]);
    }
    else if(name.find("poison") != null)
    {
        local lvl = pl.poison_lvl;
        if(lvl == 3)return BuyLevelMax(activator)
        if(pl.money >= pl.GetNewPrice(lvlcost[lvl]))
        {
            pl.level_up_poison();
            pl.Minus_money(pl.GetNewPrice(lvlcost[lvl]));
            local text = "You buy "+pl.poison_lvl+" level Poison \nYour balance "+pl.money+"$";
            ShopHud.__KeyValueFromString("message",text);
            EntFireByHandle(ShopHud, "ShowHudHint", "", 0, activator, activator);
            return;
        }
        needmoney = pl.GetNewPrice(lvlcost[lvl]);
    }
    else if(name.find("wind") != null)
    {
        local lvl = pl.wind_lvl;
        if(lvl == 3)return BuyLevelMax(activator)
        if(pl.money >= pl.GetNewPrice(lvlcost[lvl]))
        {
            pl.level_up_wind();
            pl.Minus_money(pl.GetNewPrice(lvlcost[lvl]));
            local text = "You buy "+pl.wind_lvl+" level Wind \nYour balance "+pl.money+"$";
            ShopHud.__KeyValueFromString("message",text);
            EntFireByHandle(ShopHud, "ShowHudHint", "", 0, activator, activator);
            return;
        }
        needmoney = pl.GetNewPrice(lvlcost[lvl]);
    }
    else if(name.find("summon") != null)
    {
        local lvl = pl.summon_lvl;
        if(lvl == 3)return BuyLevelMax(activator)
        if(pl.money >= pl.GetNewPrice(lvlcost[lvl]))
        {
            pl.level_up_summon();
            pl.Minus_money(pl.GetNewPrice(lvlcost[lvl]));
            local text = "You buy "+pl.summon_lvl+" level Summon \nYour balance "+pl.money+"$";
            ShopHud.__KeyValueFromString("message",text);
            EntFireByHandle(ShopHud, "ShowHudHint", "", 0, activator, activator);
            return;
        }
        needmoney = pl.GetNewPrice(lvlcost[lvl]);
    }
    else if(name.find("fire") != null)
    {
        local lvl = pl.fire_lvl;
        if(lvl == 3)return BuyLevelMax(activator)
        if(pl.money >= pl.GetNewPrice(lvlcost[lvl]))
        {
            pl.level_up_fire();
            pl.Minus_money(pl.GetNewPrice(lvlcost[lvl]));
            local text = "You buy "+pl.fire_lvl+" level Fire \nYour balance "+pl.money+"$";
            ShopHud.__KeyValueFromString("message",text);
            EntFireByHandle(ShopHud, "ShowHudHint", "", 0, activator, activator);
            return;
        }
        needmoney = pl.GetNewPrice(lvlcost[lvl]);
    }
    else if(name.find("electro") != null)
    {
        local lvl = pl.electro_lvl;
        if(lvl == 3)return BuyLevelMax(activator)
        if(pl.money >= pl.GetNewPrice(lvlcost[lvl]))
        {
            pl.level_up_electro();
            pl.Minus_money(pl.GetNewPrice(lvlcost[lvl]));
            local text = "You buy "+pl.electro_lvl+" level Electro \nYour balance "+pl.money+"$";
            ShopHud.__KeyValueFromString("message",text);
            EntFireByHandle(ShopHud, "ShowHudHint", "", 0, activator, activator);
            return;
        }
        needmoney = pl.GetNewPrice(lvlcost[lvl]);
    }
    else if(name.find("earth") != null)
    {
        local lvl = pl.earth_lvl;
        if(lvl == 3)return BuyLevelMax(activator)
        if(pl.money >= pl.GetNewPrice(lvlcost[lvl]))
        {
            pl.level_up_earth();
            pl.Minus_money(pl.GetNewPrice(lvlcost[lvl]));
            local text = "You buy "+pl.earth_lvl+" level Earth \nYour balance "+pl.money+"$";
            ShopHud.__KeyValueFromString("message",text);
            EntFireByHandle(ShopHud, "ShowHudHint", "", 0, activator, activator);
            return;
        }
        needmoney = pl.GetNewPrice(lvlcost[lvl]);
    }
    else if(name.find("gravity") != null)
    {
        local lvl = pl.gravity_lvl;
        if(lvl == 3)return BuyLevelMax(activator)
        if(pl.money >= pl.GetNewPrice(lvlcost[lvl]))
        {
            pl.level_up_gravity();
            pl.Minus_money(pl.GetNewPrice(lvlcost[lvl]));
            local text = "You buy "+pl.gravity_lvl+" level Gravity \nYour balance "+pl.money+"$";
            ShopHud.__KeyValueFromString("message",text);
            EntFireByHandle(ShopHud, "ShowHudHint", "", 0, activator, activator);
            return;
        }
        needmoney = pl.GetNewPrice(lvlcost[lvl]);
    }
    else if(name.find("ultimate") != null)
    {
        local lvl = pl.ultimate_lvl;
        if(lvl == 3)return BuyLevelMax(activator)
        if(pl.money >= pl.GetNewPrice(lvlcost[lvl]))
        {
            pl.level_up_ultimate();
            pl.Minus_money(pl.GetNewPrice(lvlcost[lvl]));
            local text = "You buy "+pl.ultimate_lvl+" level Ultima \nYour balance "+pl.money+"$";
            ShopHud.__KeyValueFromString("message",text);
            EntFireByHandle(ShopHud, "ShowHudHint", "", 0, activator, activator);
            return;
        }
        needmoney = pl.GetNewPrice(lvlcost[lvl]);
    }
    else if(name.find("heal") != null)
    {
        local lvl = pl.heal_lvl;
        if(lvl == 3)return BuyLevelMax(activator)
        if(pl.money >= pl.GetNewPrice(lvlcost[lvl]))
        {
            pl.level_up_heal();
            pl.Minus_money(pl.GetNewPrice(lvlcost[lvl]));
            local text = "You buy "+pl.heal_lvl+" level Heal \nYour balance "+pl.money+"$";
            ShopHud.__KeyValueFromString("message",text);
            EntFireByHandle(ShopHud, "ShowHudHint", "", 0, activator, activator);
            return;
        }
        needmoney = pl.GetNewPrice(lvlcost[lvl]);
    }
    local text = "You don't have enough money! \nLevel of item cost "+needmoney+"$\nYour balance "+pl.money+"$";
    ShopHud.__KeyValueFromString("message",text);
    EntFireByHandle(ShopHud, "ShowHudHint", "", 0, activator, activator);
}

function AddCash(i,a = 0)
{
    local pl = GetPlayerClassByHandle(activator);
    local money = 0;
    if(a == 0)money = i;
    else
    {
        local lvl_luck = pl.perkluck_lvl
        local per_luck = pl.perkluck_luckperlvl
        if(lvl_luck > 0)money = RandomInt(i+  a * lvl_luck * per_luck * 0.01,a + a * lvl_luck * per_luck * 0.002);
        else money = RandomInt(i,a);
    }
    pl.Add_money(money);
}

function RemoveCash(i)
{
    local pl = GetPlayerClassByHandle(activator);
    pl.Minus_money(i);
}

function BuyPerkMax(handle)
{
    local text = "You have already max level of your perk";
    ShopHud.__KeyValueFromString("message",text);
    EntFireByHandle(ShopHud, "ShowHudHint", "", 0, handle, handle);
}

function BuyStockNo(handle)
{
    local text = "0 stocks";
    ShopHud.__KeyValueFromString("message",text);
    EntFireByHandle(ShopHud, "ShowHudHint", "", 0, handle, handle);
}

function InfoPerk()
{
    local name = caller.GetName();
    local pl = GetPlayerClassByHandle(activator);
    local perktext = "";
    local lvl = 0;
    local lvlMax = 0;
    local price = 0;
    if(name.find("hp_hm") != null){lvl = pl.perkhp_hm_lvl;lvlMax = pl.perkhp_hm_maxlvl;price = perkhp_hm_cost;perktext += "hm hp";}
    else if(name.find("hp_zm") != null){lvl = pl.perkhp_zm_lvl;lvlMax = pl.perkhp_zm_maxlvl;price = perkhp_zm_cost;perktext += "zm hp";}
    else if(name.find("huckster") != null){lvl = pl.perkhuckster_lvl;lvlMax = pl.perkhuckster_maxlvl;price = perkhuckster_cost;perktext += "huckster";}
    else if(name.find("speed") != null){lvl = pl.perkspeed_lvl;lvlMax = pl.perkspeed_maxlvl;price = perkspeed_cost;perktext += "speed";}
    else if(name.find("steal") != null){lvl = pl.perksteal_lvl;lvlMax = pl.perksteal_maxlvl;price = perksteal_cost;perktext += "steal";}
    else if(name.find("chameleon") != null){lvl = pl.perkchameleon_lvl;lvlMax = perkchameleon_maxlvl;price = perkchameleon_cost;perktext += "chameleon";}
    else if(name.find("resist_zm") != null){lvl = pl.perkresist_zm_lvl;lvlMax = pl.perkresist_zm_maxlvl;price = perkresist_zm_cost;perktext += "resist";}
    else if(name.find("resist_hm") != null){lvl = pl.perkresist_hm_lvl;lvlMax = pl.perkluck_maxlvl;price = perkresist_hm_cost;perktext += "resist";}
    else if(name.find("luck") != null){lvl = pl.perkluck_lvl;lvlMax = pl.perkluck_maxlvl;price = perkluck_cost;perktext += "luck";}
    perktext += " level ["+lvl+"/"+lvlMax+"]\n";
    if(lvl == lvlMax)perktext += "You cant upgrade more";
    else perktext += "Upgrade will cost "+pl.GetNewPrice(price)+"$";
    local text = "Your "+perktext+"\nYour balance "+pl.money+"$";
    ShopHud.__KeyValueFromString("message",text);
    EntFireByHandle(ShopHud, "ShowHudHint", "", 0, activator, activator);

}

function InfoItem()
{
    local name = caller.GetName();
    local pl = GetPlayerClassByHandle(activator);
    local itemtext = "";
    local lvl = "";
    if(name.find("bio") != null){lvl = pl.bio_lvl;itemtext += "Bio";}
    else if(name.find("ice") != null){lvl = pl.ice_lvl;itemtext += "Ice";}
    else if(name.find("poison") != null){lvl = pl.poison_lvl;itemtext += "Poison";}
    else if(name.find("wind") != null){lvl = pl.wind_lvl;itemtext += "Wind";}
    else if(name.find("summon") != null){lvl = pl.summon_lvl;itemtext += "Summon";}
    else if(name.find("fire") != null){lvl = pl.fire_lvl;itemtext += "Fire";}
    else if(name.find("electro") != null){lvl = pl.electro_lvl;itemtext += "Electro";}
    else if(name.find("earth") != null){lvl = pl.earth_lvl;itemtext += "Earth";}
    else if(name.find("gravity") != null){lvl = pl.gravity_lvl;itemtext += "Gravity";}
    else if(name.find("ultimate") != null){lvl = pl.ultimate_lvl;itemtext += "Ultima";}
    else if(name.find("heal") != null){lvl = pl.heal_lvl;itemtext += "Heal";}
    itemtext += " level ["+lvl+"/"+pl.MaxLevel+"]\n";
    if(lvl == pl.MaxLevel)itemtext += "You cant upgrade more";
    else itemtext += "Upgrade will cost "+pl.GetNewPrice(lvlcost[lvl])+"$";

    local text = "Your "+itemtext+"\nYour balance "+pl.money+"$";
    ShopHud.__KeyValueFromString("message",text);
    EntFireByHandle(ShopHud, "ShowHudHint", "", 0, activator, activator);
}

function InfoStock()
{
    //local name = caller.GetName();
    local pl = GetPlayerClassByHandle(activator);
    local stock = pl.person_stock_one;
    if(stock.len() == 0)return BuyStockNo(activator);
    local itemtext = "";

    local lvlprice = 0;
    for (local i = 0; i < lvlcost.len(); i++)lvlprice += lvlcost[i];
    local money = stock.len() * (lvlprice - lvlprice * 0.2);

    for (local i = 0; i < stock.len(); i++)
    {
        if(stock[i] == "bio")itemtext += "|bio|";
        else if(stock[i] == "ice")itemtext += "|ice|";
        else if(stock[i] == "poison")itemtext += "|poison|";
        else if(stock[i] == "wind")itemtext += "|wind|";
        else if(stock[i] == "summon")itemtext += "|summon|";
        else if(stock[i] == "electro")itemtext += "|electro|";
        else if(stock[i] == "earth")itemtext += "|earth|";
        else if(stock[i] == "gravity")itemtext += "|gravity|";
        else if(stock[i] == "ultimate")itemtext += "|ultima|";
        else if(stock[i] == "heal")itemtext += "|heal|";
    }
    local text = "Your personal Stock cost "+pl.GetNewPrice(money)+"$\n"+itemtext+"\nYour balance "+pl.money+"$";
    ShopHud.__KeyValueFromString("message",text);
    EntFireByHandle(ShopHud, "ShowHudHint", "", 0, activator, activator);
}

///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
//Item manager
function LevelUpItem()
{
    local name = caller.GetName();
    local pl = GetPlayerClassByHandle(activator);

    if(pl.maxlvluping == 0)
    {
        EntFireByHandle(caller, "AddOutPut", "OnUser1 map_brush:RunScriptCode:LevelUpItem():0:1", 0.05, null, null);
        return;
    }
    else pl.maxlvluping--;

    if(name.find("bio") != null)
    {
        if(pl.level_up_bio())EntFireByHandle(caller, "AddOutPut", "OnUser1 map_brush:RunScriptCode:LevelUpItem():0:1", 0.05, null, null);
    }
    else if(name.find("ice") != null)
    {
        if(pl.level_up_ice())EntFireByHandle(caller, "AddOutPut", "OnUser1 map_brush:RunScriptCode:LevelUpItem():0:1", 0.05, null, null);
    }
    else if(name.find("poison") != null)
    {
        if(pl.level_up_poison())EntFireByHandle(caller, "AddOutPut", "OnUser1 map_brush:RunScriptCode:LevelUpItem():0:1", 0.05, null, null);
    }
    else if(name.find("wind") != null)
    {
        if(pl.level_up_wind())EntFireByHandle(caller, "AddOutPut", "OnUser1 map_brush:RunScriptCode:LevelUpItem():0:1", 0.05, null, null);
    }
    else if(name.find("summon") != null)
    {
        if(pl.level_up_summon())EntFireByHandle(caller, "AddOutPut", "OnUser1 map_brush:RunScriptCode:LevelUpItem():0:1", 0.05, null, null);
    }
    else if(name.find("fire") != null)
    {
        if(pl.level_up_fire())EntFireByHandle(caller, "AddOutPut", "OnUser1 map_brush:RunScriptCode:LevelUpItem():0:1", 0.05, null, null);
    }
    else if(name.find("electro") != null)
    {
        if(pl.level_up_electro())EntFireByHandle(caller, "AddOutPut", "OnUser1 map_brush:RunScriptCode:LevelUpItem():0:1", 0.05, null, null);
    }
    else if(name.find("earth") != null)
    {
        if(pl.level_up_earth())EntFireByHandle(caller, "AddOutPut", "OnUser1 map_brush:RunScriptCode:LevelUpItem():0:1", 0.05, null, null);
    }
    else if(name.find("gravity") != null)
    {
        if(pl.level_up_gravity())EntFireByHandle(caller, "AddOutPut", "OnUser1 map_brush:RunScriptCode:LevelUpItem():0:1", 0.05, null, null);
    }
    else if(name.find("ultimate") != null)
    {
        if(pl.level_up_ultimate())EntFireByHandle(caller, "AddOutPut", "OnUser1 map_brush:RunScriptCode:LevelUpItem():0:1", 0.05, null, null);
    }
    else if(name.find("heal") != null)
    {
        if(pl.level_up_heal())EntFireByHandle(caller, "AddOutPut", "OnUser1 map_brush:RunScriptCode:LevelUpItem():0:1", 0.05, null, null);
    }
}

function PickUpItem()
{
    local name = caller.GetName();
    local pl = GetPlayerClassByHandle(activator);
    local lvl = 1;
    local color = ::GREEN;
    local text = "Item: ";
    if(name.find("bio") != null)
    {
        lvl = pl.bio_lvl;
        local item = GetItemPresetByName("bio");
        user_bio = pl;

        if(lvl == 0)lvl++;
        text += item.name;
        text += "\nLevel: "+lvl.tostring();
        text += "\nEffect: "+item.effect;
        text += "\nRadius: "+item.GetRadius(lvl);
        if(pl.item_buff_radius)text += " + "+ (item.GetRadius(lvl) * 0.1).tostring();
        text += "\nDuration: "+item.GetDuration(lvl);
        if(pl.item_buff_turbo)text += " + 2";
        text += " seconds";
        text += "\nCD: "+item.GetCD(lvl);
        if(pl.item_buff_recovery)text += " - 10";
        text += " seconds";
        text += "\nDamage: "+item.GetDamage(lvl);

        ScriptPrintMessageChatAll("***\x0A Bio\x01 pickup "+pl.name+" "+color+""+lvl+"\x01 level ***")
    }
    else if(name.find("ice") != null)
    {
        lvl = pl.ice_lvl;
        local item = GetItemPresetByName("ice");
        user_ice = pl;

        if(lvl == 0)lvl++;
        text += item.name;
        text += "\nLevel: "+lvl.tostring();
        text += "\nEffect: "+item.effect;
        text += "\nRadius: "+item.GetRadius(lvl);
        if(pl.item_buff_radius)text += " + "+ (item.GetRadius(lvl) * 0.1).tostring();
        text += "\nDuration: "+item.GetDuration(lvl);
        if(pl.item_buff_turbo)text += " + 2";
        text += " seconds";
        text += "\nCD: "+item.GetCD(lvl);
        if(pl.item_buff_recovery)text += " - 10";
        text += " seconds";
        ScriptPrintMessageChatAll("***\x0B Ice\x01 pickup "+pl.name+" "+color+""+lvl+"\x01 level ***")
    }
    else if(name.find("poison") != null)
    {
        lvl = pl.poison_lvl;
        local item = GetItemPresetByName("poison");
        user_poison = pl;

        if(lvl == 0)lvl++;
        text += item.name;
        text += "\nLevel: "+lvl.tostring();
        text += "\nEffect: "+item.effect;
        text += "\nRadius: "+item.GetRadius(lvl);
        if(pl.item_buff_radius)text += " + "+ (item.GetRadius(lvl) * 0.1).tostring();
        text += "\nDuration: "+item.GetDuration(lvl);
        if(pl.item_buff_turbo)text += " + 2";
        text += " seconds";
        text += "\nCD: "+item.GetCD(lvl);
        if(pl.item_buff_recovery)text += " - 10";
        text += " seconds";
        text += "\nDamage: "+item.GetDamage(lvl);

        ScriptPrintMessageChatAll("***\x06 Poison\x01 pickup "+pl.name+" "+color+""+lvl+"\x01 level ***")
    }
    else if(name.find("wind") != null)
    {
        lvl = pl.wind_lvl;
        local item = GetItemPresetByName("wind");
        user_wind = pl;

        if(lvl == 0)lvl++;
        text += item.name;
        text += "\nLevel: "+lvl.tostring();
        text += "\nEffect: "+item.effect;
        text += "\nRadius: "+item.GetRadius(lvl);
        if(pl.item_buff_radius)text += " + "+ (item.GetRadius(lvl) * 0.1).tostring();
        text += "\nDuration: "+item.GetDuration(lvl);
        if(pl.item_buff_turbo)text += " + 2";
        text += " seconds";
        text += "\nCD: "+item.GetCD(lvl);
        if(pl.item_buff_recovery)text += " - 10";
        text += " seconds";

        ScriptPrintMessageChatAll("***\x05 Wind\x01 pickup "+pl.name+" "+color+""+lvl+"\x01 level ***")
    }
    else if(name.find("summon") != null)
    {
        lvl = pl.summon_lvl;
        local item = GetItemPresetByName("summon");
        user_summon = pl;

        if(lvl == 0)lvl++;
        text += item.name;
        text += "\nLevel: "+lvl.tostring();
        text += "\nEffect: "+item.effect;
        text += "\nRadius: "+item.GetRadius(lvl);
        if(pl.item_buff_radius)text += " + "+ (item.GetRadius(lvl) * 0.1).tostring();
        text += "\nDuration: "+item.GetDuration(lvl);
        if(pl.item_buff_turbo)text += " + 2";
        text += " seconds";
        text += "\nCD: "+item.GetCD(lvl);
        if(pl.item_buff_recovery)text += " - 10";
        text += " seconds";

        ScriptPrintMessageChatAll("***\x09 Summon\x01 pickup "+pl.name+" "+color+""+lvl+"\x01 level ***")
    }
    else if(name.find("fire") != null)
    {
        lvl = pl.fire_lvl;
        local item = GetItemPresetByName("fire");
        user_fire = pl;

        if(lvl == 0)lvl++;
        text += item.name;
        text += "\nLevel: "+lvl.tostring();
        text += "\nEffect: "+item.effect;
        text += "\nRadius: "+item.GetRadius(lvl);
        if(pl.item_buff_radius)text += " + "+ (item.GetRadius(lvl) * 0.1).tostring();
        text += "\nDuration: "+item.GetDuration(lvl);
        if(pl.item_buff_turbo)text += " + 2";
        text += " seconds";
        text += "\nCD: "+item.GetCD(lvl);
        if(pl.item_buff_recovery)text += " - 10";
        text += " seconds";
        text += "\nDamage: "+item.GetDamage(lvl);

        ScriptPrintMessageChatAll("***\x02 Fire\x01 pickup "+pl.name+" "+color+""+lvl+"\x01 level ***")
    }
    else if(name.find("electro") != null)
    {
        lvl = pl.electro_lvl;
        local item = GetItemPresetByName("electro");
        user_electro = pl;

        if(lvl == 0)lvl++;
        text += item.name;
        text += "\nLevel: "+lvl.tostring();
        text += "\nEffect: "+item.effect;
        text += "\nRadius: "+item.GetRadius(lvl);
        if(pl.item_buff_radius)text += " + "+ (item.GetRadius(lvl) * 0.1).tostring();
        text += "\nDuration: "+item.GetDuration(lvl);
        if(pl.item_buff_turbo)text += " + 2";
        text += " seconds";
        text += "\nCD: "+item.GetCD(lvl);
        if(pl.item_buff_recovery)text += " - 10";
        text += " seconds";
        text += "\nDamage: "+item.GetDamage(lvl);

        ScriptPrintMessageChatAll("***\x0C Lightning \x01 pickup "+pl.name+" "+color+""+lvl+"\x01 level ***")
    }
    else if(name.find("earth") != null)
    {
        lvl = pl.earth_lvl;
        local item = GetItemPresetByName("earth");
        user_earth = pl;

        if(lvl == 0)lvl++;
        text += item.name;
        text += "\nLevel: "+lvl.tostring();
        text += "\nEffect: "+item.effect;
        text += "\nRadius: "+item.GetRadius(lvl);
        if(pl.item_buff_radius)text += " + "+ (item.GetRadius(lvl) * 0.1).tostring();
        text += "\nDuration: "+item.GetDuration(lvl);
        if(pl.item_buff_turbo)text += " + 2";
        text += " seconds";
        text += "\nCD: "+item.GetCD(lvl);
        if(pl.item_buff_recovery)text += " - 10";
        text += " seconds";
        ScriptPrintMessageChatAll("***\x10 Earth\x01 pickup "+pl.name+" "+color+""+lvl+"\x01 level ***")
    }
    else if(name.find("gravity") != null)
    {
        lvl = pl.gravity_lvl;
        local item = GetItemPresetByName("gravity");
        user_gravity = pl;

        if(lvl == 0)lvl++;
        text += item.name;
        text += "\nLevel: "+lvl.tostring();
        text += "\nEffect: "+item.effect;
        text += "\nRadius: "+item.GetRadius(lvl);
        if(pl.item_buff_radius)text += " + "+ (item.GetRadius(lvl) * 0.1).tostring();
        text += "\nDuration: "+item.GetDuration(lvl);
        if(pl.item_buff_turbo)text += " + 2";
        text += " seconds";
        text += "\nCD: "+item.GetCD(lvl);
        if(pl.item_buff_recovery)text += " - 10";
        text += " seconds";
        text += "\nDamage: "+item.GetDamage(lvl);

        ScriptPrintMessageChatAll("***\x0E Gravity\x01 pickup "+pl.name+" "+color+""+lvl+"\x01 level ***")
    }
    else if(name.find("ultimate") != null)
    {
        lvl = pl.ultimate_lvl;
        local item = GetItemPresetByName("ultimate");
        user_ultimate = pl;

        if(lvl == 0)lvl++;
        text += item.name;
        text += "\nLevel: "+lvl.tostring();
        text += "\nEffect: "+item.effect;
        text += "\nRadius: "+item.GetRadius(lvl);
        if(pl.item_buff_radius)text += " + "+ (item.GetRadius(lvl) * 0.1).tostring();
        text += "\nDuration: "+item.GetDuration(lvl);
        if(pl.item_buff_turbo)text += " + 2";
        text += " seconds";
        text += "\nDamage: "+item.GetDamage(lvl)+"% - "+item.GetTime(lvl);

        ScriptPrintMessageChatAll("***\x04 Ultima\x01 pickup "+pl.name+" "+color+""+lvl+"\x01 level ***")
    }
    else if(name.find("heal") != null)
    {
        lvl = pl.heal_lvl;
        local item = GetItemPresetByName("heal");
        user_heal = pl;

        if(lvl == 0)lvl++;
        text += item.name;
        text += "\nLevel: "+lvl.tostring();
        text += "\nEffect: "+item.effect;
        text += "\nRadius: "+item.GetRadius(lvl);
        if(pl.item_buff_radius)text += " + "+ (item.GetRadius(lvl) * 0.1).tostring();
        text += "\nDuration: "+item.GetDuration(lvl);
        if(pl.item_buff_turbo)text += " + 2";
        text += " seconds";
        text += "\nCD: "+item.GetCD(lvl);
        if(pl.item_buff_recovery)text += " - 10";
        text += " seconds";
        ScriptPrintMessageChatAll("*** Cure pickup "+pl.name+" "+color+""+lvl+"\x01 level ***")
    }
    if(lvl == 2)color = ::YELLOW;
    else if(lvl == 3)color = ::RED;
    caller.__KeyValueFromString("message",text);
    EntFireByHandle(caller, "Display", "", 0, activator, activator);
}

function DropItem()
{
    local name = caller.GetName();
    local pl = GetPlayerClassByHandle(activator);
    if(name.find("bio") != null)
    {
        user_bio = null;
        if(pl.bio_count == 1)
        {
            EntFire("item_button_bio", "RunScripCode", "loc = false;", 0, null);
            EntFire("item_button_bio", "RunScripCode", "loc = true;", 80, null);
        }
    }
    else if(name.find("ice") != null)
    {
        user_ice = null;
        if(pl.ice_count == 1)
        {
            EntFire("item_button_ice", "RunScripCode", "loc = false;", 0, null);
            EntFire("item_button_ice", "RunScripCode", "loc = true;", 80, null);
        }
    }
    else if(name.find("poison") != null)
    {
        user_poison = null;
        if(pl.poison_count == 1)
        {
            EntFire("item_button_poison", "RunScripCode", "loc = false;", 0, null);
            EntFire("item_button_poison", "RunScripCode", "loc = true;", 80, null);
        }
    }
    else if(name.find("wind") != null)
    {
        user_wind = null;
        if(pl.wind_count == 1)
        {
            EntFire("item_button_wind", "RunScripCode", "loc = false;", 0, null);
            EntFire("item_button_wind", "RunScripCode", "loc = true;", 80, null);
        }
    }
    else if(name.find("summon") != null)
    {
        user_summon = null;
        if(pl.summon_count == 1)
        {
            EntFire("item_button_summon", "RunScripCode", "loc = false;", 0, null);
            EntFire("item_button_summon", "RunScripCode", "loc = true;", 80, null);
        }
    }
    else if(name.find("fire") != null)
    {
        user_fire = null;
        if(pl.fire_count == 1)
        {
            EntFire("item_button_fire", "RunScripCode", "loc = false;", 0, null);
            EntFire("item_button_fire", "RunScripCode", "loc = true;", 80, null);
        }
    }
    else if(name.find("electro") != null)
    {
        user_electro = null;
        if(pl.electro_count == 1)
        {
            EntFire("item_button_electro", "RunScripCode", "loc = false;", 0, null);
            EntFire("item_button_electro", "RunScripCode", "loc = true;", 80, null);
        }
    }
    else if(name.find("earth") != null)
    {
        user_earth = null;
        if(pl.earth_count == 1)
        {
            EntFire("item_button_earth", "RunScripCode", "loc = false;", 0, null);
            EntFire("item_button_earth", "RunScripCode", "loc = true;", 80, null);
        }
    }
    else if(name.find("gravity") != null)
    {
        user_gravity = null;
        if(pl.gravity_count == 1)
        {
            EntFire("item_button_gravity", "RunScripCode", "loc = false;", 0, null);
            EntFire("item_button_gravity", "RunScripCode", "loc = true;", 80, null);
        }
    }
    else if(name.find("ultimate") != null)
    {
        user_ultimate = null;
        if(pl.ultimate_count == 1)
        {
            EntFire("item_button_ultimate", "RunScripCode", "loc = false;", 0, null);
            EntFire("item_button_ultimate", "RunScripCode", "loc = true;", 80, null);
        }
    }
    else if(name.find("heal") != null)
    {
        user_heal = null;
        if(pl.heal_count == 1)
        {
            EntFire("item_button_heal", "RunScripCode", "loc = false;", 0, null);
            EntFire("item_button_heal", "RunScripCode", "loc = true;", 80, null);
        }
    }
}

function ShowItems()
{
    local text = "";
    if(user_bio != null)
    {
        if(user_bio.handle.IsValid())
        {
            text += "\nBio";
            local lvl = user_bio.bio_lvl;
            if(lvl == 0)lvl++
            text += "["+lvl+"]";
            local button = Entities.FindByName(null, "item_button_bio");
            if(button != null)
            {
                if(button_bio)
                {
                    if(!button.GetScriptScope().GetStatus())
                    {
                        text += "[L]";
                    }
                    else
                    {
                        if(user_bio.item_buff_doble)text += "("+user_bio.bio_count.tostring()+")";
                        else text += "[R]";
                    }
                }
                else text += "["+cd_bio.tostring()+"]";
            }
            text += "uid: "+user_bio.userid;
        }
    }
    if(user_ice != null)
    {
        if(user_ice.handle.IsValid())
        {
            text += "\nIce";
            local lvl = user_ice.ice_lvl;
            if(lvl == 0)lvl++
            text += "["+lvl+"]";
            local button = Entities.FindByName(null, "item_button_ice");
            if(button != null)
            {
                if(button_ice)
                {
                    if(!button.GetScriptScope().GetStatus())
                    {
                        text += "[L]";
                    }
                    else
                    {
                        if(user_ice.item_buff_doble)text += "("+user_ice.ice_count.tostring()+")";
                        else text += "[R]";
                    }
                }
                else text += "["+cd_ice.tostring()+"]";
            }
            text += "uid: "+user_ice.userid;
        }
    }
    if(user_poison != null)
    {
        if(user_poison.handle.IsValid())
        {
            text += "\nPoison";
            local lvl = user_poison.poison_lvl;
            if(lvl == 0)lvl++
            text += "["+lvl+"]";
            local button = Entities.FindByName(null, "item_button_poison");
            if(button != null)
            {
                if(button_poison)
                {
                    if(!button.GetScriptScope().GetStatus())
                    {
                        text += "[L]";
                    }
                    else
                    {
                        if(user_poison.item_buff_doble)text += "("+user_poison.poison_count.tostring()+")";
                        else text += "[R]";
                    }
                }
                else text += "["+cd_poison.tostring()+"]";
            }
            text += "uid: "+user_poison.userid;
        }
    }
    if(user_wind != null)
    {
        if(user_wind.handle.IsValid())
        {
            text += "\nWind";
            local lvl = user_wind.wind_lvl;
            if(lvl == 0)lvl++
            text += "["+lvl+"]";
            local button = Entities.FindByName(null, "item_button_wind");
            if(button != null)
            {
                if(button_wind)
                {
                    if(!button.GetScriptScope().GetStatus())
                    {
                        text += "[L]";
                    }
                    else
                    {
                        if(user_wind.item_buff_doble)text += "("+user_wind.wind_count.tostring()+")";
                        else text += "[R]";
                    }
                }
                else text += "["+cd_wind.tostring()+"]";
            }
            text += "uid: "+user_wind.userid;
        }
    }
    if(user_summon != null)
    {
        if(user_summon.handle.IsValid())
        {
            text += "\nSummon";
            local lvl = user_summon.summon_lvl;
            if(lvl == 0)lvl++
            text += "["+lvl+"]";
            local button = Entities.FindByName(null, "item_button_summon");
            if(button != null)
            {
                if(button_summon)
                {
                    if(!button.GetScriptScope().GetStatus())
                    {
                        text += "[L]";
                    }
                    else
                    {
                        if(user_summon.item_buff_doble)text += "("+user_summon.summon_count.tostring()+")";
                        else text += "[R]";
                    }
                }
                else text += "["+cd_summon.tostring()+"]";
            }
            text += "uid: "+user_summon.userid;
        }
    }
    if(user_fire != null)
    {
        if(user_fire.handle.IsValid())
        {
            text += "\nFire";
            local lvl = user_fire.fire_lvl;
            if(lvl == 0)lvl++
            text += "["+lvl+"]";
            local button = Entities.FindByName(null, "item_button_fire");
            if(button != null)
            {
                if(button_fire)
                {
                    if(!button.GetScriptScope().GetStatus())
                    {
                        text += "[L]";
                    }
                    else
                    {
                        if(user_fire.item_buff_doble)text += "("+user_fire.fire_count.tostring()+")";
                        else text += "[R]";
                    }
                }
                else text += "["+cd_fire.tostring()+"]";
            }
            text += "uid: "+user_fire.userid;
        }
    }
    if(user_electro != null)
    {
        if(user_electro.handle.IsValid())
        {
            text += "\nElectro";
            local lvl = user_electro.electro_lvl;
            if(lvl == 0)lvl++
            text += "["+lvl+"]";
            local button = Entities.FindByName(null, "item_button_electro");
            if(button != null)
            {
                if(button_electro)
                {
                    if(!button.GetScriptScope().GetStatus())
                    {
                        text += "[L]";
                    }
                    else
                    {
                        if(user_electro.item_buff_doble)text += "("+user_electro.electro_count.tostring()+")";
                        else text += "[R]";
                    }
                }
                else text += "["+cd_electro.tostring()+"]";
            }
            text += "uid: "+user_electro.userid;
        }
    }
    if(user_gravity != null)
    {
        if(user_gravity.handle.IsValid())
        {
            text += "\nGravity";
            local lvl = user_gravity.gravity_lvl;
            if(lvl == 0)lvl++
            text += "["+lvl+"]";
            local button = Entities.FindByName(null, "item_button_gravity");
            if(button != null)
            {
                if(button_gravity)
                {
                    if(!button.GetScriptScope().GetStatus())
                    {
                        text += "[L]";
                    }
                    else
                    {
                        if(user_gravity.item_buff_doble)text += "("+user_gravity.gravity_count.tostring()+")";
                        else text += "[R]";
                    }
                }
                else text += "["+cd_gravity.tostring()+"]";
            }
            text += "uid: "+user_gravity.userid;
        }
    }
    if(user_earth != null)
    {
        if(user_earth.handle.IsValid())
        {
            text += "\nEarth";
            local lvl = user_earth.earth_lvl;
            if(lvl == 0)lvl++
            text += "["+lvl+"]";
            local button = Entities.FindByName(null, "item_button_earth");
            if(button != null)
            {
                if(button_earth)
                {
                    if(!button.GetScriptScope().GetStatus())
                    {
                        text += "[L]";
                    }
                    else
                    {
                        if(user_earth.item_buff_doble)text += "("+user_earth.earth_count.tostring()+")";
                        else text += "[R]";
                    }
                }
                else text += "["+cd_earth.tostring()+"]";
            }
            text += "uid: "+user_earth.userid;
        }
    }
    if(user_ultimate != null)
    {
        if(user_ultimate.handle.IsValid())
        {
            text += "\nUltima";
            local lvl = user_ultimate.ultimate_lvl;
            if(lvl == 0)lvl++
            text += "["+lvl+"]";
            local button = Entities.FindByName(null, "item_button_ultimate");
            if(button != null)
            {
                if(button_ultimate)
                {
                    if(!button.GetScriptScope().GetStatus())
                    {
                        text += "[L]";
                    }
                    else
                    {
                        if(user_ultimate.item_buff_doble)text += "("+user_ultimate.ultimate_count.tostring()+")";
                        else text += "[R]";
                    }
                }
                else text += "["+cd_ultimate.tostring()+"]";
            }
            text += "uid: "+user_ultimate.userid;
        }
    }
    if(user_heal != null)
    {
        if(user_heal.handle.IsValid())
        {
            text += "\nHeal";
            local lvl = user_heal.heal_lvl;
            if(lvl == 0)lvl++
            text += "["+lvl+"]";
            local button = Entities.FindByName(null, "item_button_heal");
            if(button != null)
            {
                if(button_heal)
                {
                    if(!button.GetScriptScope().GetStatus())
                    {
                        text += "[L]";
                    }
                    else
                    {
                        if(user_heal.item_buff_doble)text += "("+user_heal.heal_count.tostring()+")";
                        else text += "[R]";
                    }
                }
                else text += "["+cd_heal.tostring()+"]";
            }
            text += "uid: "+user_heal.userid;
        }
    }
    if(text != "")
    {
        ItemText.__KeyValueFromString("message",text);
        EntFireByHandle(ItemText, "Display", "", 0.01, null, null);
    }
    EntFireByHandle(self, "RunScriptCode", "ShowItems();", 0.5, null, null);
}

function UseUltimate()
{
    local pl = GetPlayerClassByHandle(activator);
    local item = GetItemPresetByName("ultimate");

    local lvl = pl.ultimate_lvl;
    if(lvl == 0)lvl++;

    if(pl.item_buff_doble)
    {
        if(pl.ultimate_count == 0)return;
        pl.ultimate_count--;
        if(pl.ultimate_count == 0)
        {
            button_ultimate = false;
            EntFire("item_effect_ultimate", "Stop", "", 0, null);
            EntFire("item_button_ultimate", "Lock", "", 0, null);
            //EntFire("item_button_ultimate", "Unlock", "", 160, null);
            //EntFire("item_effect_ultimate", "Start", "", 160, null);
        }
    }
    else
    {
        local cd = item.GetCD(lvl);
        if(pl.item_buff_recovery)cd -= 10;
        button_ultimate = false;
        EntFire("item_effect_ultimate", "Stop", "", 0, null);
        EntFire("item_button_ultimate", "Lock", "", 0, null);
        // EntFire("item_button_ultimate", "Unlock", "", cd, null);
        // EntFire("item_effect_ultimate", "Start", "", cd, null);
    }

    local worktime = item.GetDuration(lvl);
    local radius = item.GetRadius(lvl);
    local damage = item.GetDamage(lvl);
    local timehp = item.GetTime(lvl);

    if(pl.item_buff_turbo)worktime += 2;
    if(pl.item_buff_radius)radius *= 1.1;

    EntFire("item_sound_ultimate", "PlaySound", "", 0, null);

    EntFire("item_effect_trigger_ultimate", "Start", "", 0, null);

    EntFireByHandle(self, "RunScriptCode", "UltimateHurt("+damage.tostring()+","+radius.tostring()+","+timehp.tostring()+")", worktime, null, null);
    EntFire("item_effect_trigger_ultimate", "Stop", "", worktime, null);
}

weapon_ultimate <- null;

function UltimateHurt(damage,radius,timehp)
{
    local h = null;
    while(null != (h = Entities.FindByClassnameWithin(h, "player", weapon_ultimate.GetOrigin(), radius)))
    {
        if(h != null && h.IsValid() && h.GetHealth() > 0 && h.GetTeam() == 2)
        {
            local hhp = h.GetHealth();
            local ph = hhp * damage * 0.01;
            //local p = GetPlayerClassByHandle(h);
            local hp = hhp - ph - timehp;
            if(hp <= 0)
            {
                EntFireByHandle(h, "SetHealth", "-1", 0, null, null);
                EntFireByHandle(h, "SetDamageFilter", "", 0.00, null, null);
            }
            else h.SetHealth(hp);
        }
    }
}


function UseWind()
{
    local trigger = Entities.FindByName(null, "item_trigger_wind");
    if(trigger.GetScriptScope().ticking)return;

    local pl = GetPlayerClassByHandle(activator);
    local item = GetItemPresetByName("wind");

    local lvl = pl.wind_lvl;
    if(lvl == 0)lvl++;

    if(pl.item_buff_doble)
    {
        if(pl.wind_count == 0)return;
        pl.wind_count--;
        EntFireByHandle(self, "RunScriptCode", "GetPlayerClassByHandle(activator).wind_count++", 100, pl.handle, pl.handle);
        if(pl.wind_count == 0)
        {
            button_wind = false
            EntFireByHandle(self, "RunScriptCode", "button_wind = true", 160, null, null);
            EntFire("item_effect_wind", "Stop", "", 0, null);
            EntFire("item_button_wind", "Lock", "", 0, null);
            EntFire("item_button_wind", "Unlock", "", 160, null);
            EntFire("item_effect_wind", "Start", "", 160, null);
            StartCDwind(160);
        }
    }
    else
    {
        local cd = item.GetCD(lvl);
        if(pl.item_buff_recovery)cd -= 10;
        button_wind = false
        EntFireByHandle(self, "RunScriptCode", "button_wind = true", cd, null, null);
        EntFire("item_effect_wind", "Stop", "", 0, null);
        EntFire("item_button_wind", "Lock", "", 0, null);
        EntFire("item_button_wind", "Unlock", "", cd, null);
        EntFire("item_effect_wind", "Start", "", cd, null);
        StartCDwind(cd);
    }

    local worktime = item.GetDuration(lvl);
    local radius = item.GetRadius(lvl);

    if(pl.item_buff_turbo)worktime += 2;
    if(pl.item_buff_radius)radius *= 1.1;

    trigger.GetScriptScope().dist = radius;
    trigger.GetScriptScope().power = item.GetDamage(lvl);

    EntFire("item_sound_wind", "PlaySound", "", 0, null);

    EntFire("item_effect_trigger_wind", "Start", "", 0, null);
    EntFire("item_trigger_wind", "RunScriptCode", "Enable()", 0.01, null);

    EntFire("item_trigger_wind", "RunScriptCode", "Disable()", worktime, null);
    EntFire("item_effect_trigger_wind", "Stop", "", worktime, null);
}

function StartCDwind(cd = 0)
{
    if(cd != 0)cd_wind = cd;
    else cd_wind -= 1;
    if(cd_wind > 1)
    {
        EntFireByHandle(self, "RunScriptCode", "StartCDwind()", 1, null, null);
    }
}

function StartCDice(cd = 0)
{
    if(cd != 0)cd_ice = cd;
    else cd_ice -= 1;
    if(cd_ice > 1)
    {
        EntFireByHandle(self, "RunScriptCode", "StartCDice()", 1, null, null);
    }
}

function UseIce()
{
    local pl = GetPlayerClassByHandle(activator);
    local item = GetItemPresetByName("ice");

    local lvl = pl.ice_lvl;
    if(lvl == 0)lvl++;

    if(pl.item_buff_doble)
    {
        if(pl.ice_count == 0)return;
        pl.ice_count--;
        EntFireByHandle(self, "RunScriptCode", "GetPlayerClassByHandle(activator).ice_count++", 100, pl.handle, pl.handle);
        if(pl.ice_count == 0)
        {
            button_ice = false
            EntFireByHandle(self, "RunScriptCode", "button_ice = true", 160, null, null);
            EntFire("item_effect_ice", "Stop", "", 0, null);
            EntFire("item_button_ice", "Lock", "", 0, null);
            EntFire("item_button_ice", "Unlock", "", 160, null);
            EntFire("item_effect_ice", "Start", "", 160, null);
            StartCDice(160);
        }
    }
    else
    {
        local cd = item.GetCD(lvl);
        if(pl.item_buff_recovery)cd -= 10;
        button_ice = false
        EntFireByHandle(self, "RunScriptCode", "button_ice = true", cd, null, null);
        EntFire("item_effect_ice", "Stop", "", 0, null);
        EntFire("item_button_ice", "Lock", "", 0, null);
        EntFire("item_button_ice", "Unlock", "", cd, null);
        EntFire("item_effect_ice", "Start", "", cd, null);
        StartCDice(cd);
    }
    Entities.FindByName(null, "item_spawner_ice").SpawnEntity();


    local trigger = Entities.FindByName(null, "item_temp_ice_trigger");

    local Worktime = item.GetDuration(lvl);
    local radius = item.GetRadius(lvl);
    local time = item.GetTime(lvl);

    if(pl.item_buff_turbo)time += 2;
    if(pl.item_buff_turbo)Worktime += 2;
    if(pl.item_buff_radius)radius *= 1.1;

    trigger.GetScriptScope().slow = time;
    trigger.GetScriptScope().dist = radius;
    trigger.GetScriptScope().power = item.GetDamage(lvl);

    local name = Time().tointeger()
    EntFire("item_temp_ice_trigger", "AddOutPut", "targetname item_temp_ice_trigger"+name, 0, null);
    EntFire("item_temp_ice_effect", "AddOutPut", "targetname item_temp_ice_effect"+name, 0, null);

    EntFire("item_temp_ice_trigger"+name, "Kill", "", Worktime, null);
    EntFire("item_temp_ice_effect"+name, "Kill", "", Worktime, null);
}

function UseElectro()
{
    local pl = GetPlayerClassByHandle(activator);
    local item = GetItemPresetByName("electro");

    local lvl = pl.electro_lvl;
    if(lvl == 0)lvl++;

    if(pl.item_buff_doble)
    {
        if(pl.electro_count == 0)return;
        pl.electro_count--;
        EntFireByHandle(self, "RunScriptCode", "GetPlayerClassByHandle(activator).electro_count++", 100, pl.handle, pl.handle);
        if(pl.electro_count == 0)
        {
            button_electro = false
            EntFireByHandle(self, "RunScriptCode", "button_electro = true", 160, null, null);
            EntFire("item_effect_electro", "Stop", "", 0, null);
            EntFire("item_button_electro", "Lock", "", 0, null);
            EntFire("item_button_electro", "Unlock", "", 160, null);
            EntFire("item_effect_electro", "Start", "", 160, null);
            StartCDelectro(160);
        }
    }
    else
    {
        local cd = item.GetCD(lvl);
        if(pl.item_buff_recovery)cd -= 10;
        button_electro = false
        EntFireByHandle(self, "RunScriptCode", "button_electro = true", cd, null, null);
        EntFire("item_effect_electro", "Stop", "", 0, null);
        EntFire("item_button_electro", "Lock", "", 0, null);
        EntFire("item_button_electro", "Unlock", "", cd, null);
        EntFire("item_effect_electro", "Start", "", cd, null);
        StartCDelectro(cd);
    }
    Entities.FindByName(null, "item_spawner_electro").SpawnEntity();


    local trigger = Entities.FindByName(null, "item_temp_electro_trigger");

    local worktime = item.GetDuration(lvl);
    local radius = item.GetRadius(lvl);

    if(pl.item_buff_turbo)worktime += 2;
    if(pl.item_buff_radius)radius *= 1.1;


    trigger.GetScriptScope().dist = radius;
    trigger.GetScriptScope().damage = item.GetDamage(lvl) * 0.05;
    trigger.GetScriptScope().slow = item.GetTime(lvl);

    local name = Time().tointeger()
    EntFire("item_temp_electro_trigger", "AddOutPut", "targetname item_temp_electro_trigger"+name, 0, null);
    EntFire("item_temp_electro_effect", "AddOutPut", "targetname item_temp_electro_effect"+name, 0, null);

    EntFire("item_temp_electro_trigger"+name, "Kill", "", worktime, null);
    EntFire("item_temp_electro_effect"+name, "Kill", "", worktime, null);
}

function StartCDelectro(cd = 0)
{
    if(cd != 0)cd_electro = cd;
    cd_electro -= 1;
    if(cd_electro > 1)
    {
        EntFireByHandle(self, "RunScriptCode", "StartCDelectro()", 1, null, null);
    }
}

function StartCDsummon(cd = 0)
{
    if(cd != 0)cd_summon = cd;
    else cd_summon -= 1;
    if(cd_summon > 1)
    {
        EntFireByHandle(self, "RunScriptCode", "StartCDsummon()", 1, null, null);
    }
}

function UseSummon()
{
    local pl = GetPlayerClassByHandle(activator);
    local item = GetItemPresetByName("summon");

    local lvl = pl.summon_lvl;
    if(lvl == 0)lvl++;

    if(pl.item_buff_doble)
    {
        if(pl.summon_count == 0)return;
        pl.summon_count--;
        EntFireByHandle(self, "RunScriptCode", "GetPlayerClassByHandle(activator).summon_count++", 100, pl.handle, pl.handle);
        if(pl.summon_count == 0)
        {
            button_summon = false
            EntFireByHandle(self, "RunScriptCode", "button_summon = true", 160, null, null);
            EntFire("item_effect_summon", "Stop", "", 0, null);
            EntFire("item_button_summon", "Lock", "", 0, null);
            EntFire("item_button_summon", "Unlock", "", 160, null);
            EntFire("item_effect_summon", "Start", "", 160, null);
            StartCDsummon(160);
        }
    }
    else
    {
        local cd = item.GetCD(lvl);
        if(pl.item_buff_recovery)cd -= 10;
        button_summon = false
        EntFireByHandle(self, "RunScriptCode", "button_summon = true", cd, null, null);
        EntFire("item_effect_summon", "Stop", "", 0, null);
        EntFire("item_button_summon", "Lock", "", 0, null);
        EntFire("item_button_summon", "Unlock", "", cd, null);
        EntFire("item_effect_summon", "Start", "", cd, null);
        StartCDsummon(cd);
    }
    Entities.FindByName(null, "item_spawner_summon").SpawnEntity();


    local trigger = Entities.FindByName(null, "item_temp_summon_trigger");

    local Worktime = item.GetDuration(lvl);
    local radius = item.GetRadius(lvl);

    if(pl.item_buff_turbo)Worktime += 2;
    if(pl.item_buff_radius)radius *= 1.1;


    trigger.GetScriptScope().dist = radius;
    trigger.GetScriptScope().power = item.GetDamage(lvl);
    trigger.GetScriptScope().worktime = item.GetTime(lvl);

    local name = Time().tointeger()
    EntFire("item_temp_summon_trigger", "AddOutPut", "targetname item_temp_summon_trigger"+name, 0, null);
    EntFire("item_temp_summon_effect", "AddOutPut", "targetname item_temp_summon_effect"+name, 0, null);

    EntFire("item_temp_summon_trigger"+name, "Kill", "", Worktime, null);
    EntFire("item_temp_summon_effect"+name, "Kill", "", Worktime, null);
}

function UseBio()
{
    local pl = GetPlayerClassByHandle(activator);
    local item = GetItemPresetByName("bio");

    local lvl = pl.bio_lvl;
    if(lvl == 0)lvl++;

    if(pl.item_buff_doble)
    {
        if(pl.bio_count == 0)return;
        pl.bio_count--;
        EntFireByHandle(self, "RunScriptCode", "GetPlayerClassByHandle(activator).bio_count++", 100, pl.handle, pl.handle);
        if(pl.bio_count == 0)
        {
            button_bio = false
            EntFireByHandle(self, "RunScriptCode", "button_bio = true", 160, null, null);
            EntFire("item_effect_bio", "Stop", "", 0, null);
            EntFire("item_button_bio", "Lock", "", 0, null);
            EntFire("item_button_bio", "Unlock", "", 160, null);
            EntFire("item_effect_bio", "Start", "", 160, null);
            StartCDbio(160);
        }
    }
    else
    {
        local cd = item.GetCD(lvl);
        if(pl.item_buff_recovery)cd -= 10;
        EntFire("item_effect_bio", "Stop", "", 0, null);
        EntFire("item_button_bio", "Lock", "", 0, null);
        EntFire("item_button_bio", "Unlock", "", cd, null);
        EntFire("item_effect_bio", "Start", "", cd, null);
        button_bio = false
        EntFireByHandle(self, "RunScriptCode", "button_bio = true", cd, null, null);
        StartCDbio(cd);
    }
    Entities.FindByName(null, "item_spawner_bio").SpawnEntity();


    local trigger = Entities.FindByName(null, "item_temp_bio_trigger");

    local worktime = item.GetDuration(lvl);
    local radius = item.GetRadius(lvl);

    if(pl.item_buff_turbo)worktime += 2;
    if(pl.item_buff_radius)radius *= 1.1;

    trigger.GetScriptScope().dist = radius;
    trigger.GetScriptScope().damage = item.GetDamage(lvl) * 0.05;
    trigger.GetScriptScope().slow = item.GetTime(lvl);

    local name = Time().tointeger()
    EntFire("item_temp_bio_trigger", "AddOutPut", "targetname item_temp_bio_trigger"+name, 0, null);
    EntFire("item_temp_bio_effect", "AddOutPut", "targetname item_temp_bio_effect"+name, 0, null);

    EntFire("item_temp_bio_trigger"+name, "Kill", "", worktime, null);
    EntFire("item_temp_bio_effect"+name, "Kill", "", worktime, null);
}

function StartCDbio(cd = 0)
{
    if(cd != 0)cd_bio = cd;
    else cd_bio -= 1;
    if(cd_bio > 1)
    {
        EntFireByHandle(self, "RunScriptCode", "StartCDbio()", 1, null, null);
    }
}

function StartCDpoison(cd = 0)
{
    if(cd != 0)cd_poison = cd;
    else cd_poison -= 1;
    if(cd_poison > 1)
    {
        EntFireByHandle(self, "RunScriptCode", "StartCDpoison()", 1, null, null);
    }
}

function UsePoison()
{
    local pl = GetPlayerClassByHandle(activator);
    local item = GetItemPresetByName("poison");

    local lvl = pl.poison_lvl;
    if(lvl == 0)lvl++;

    if(pl.item_buff_doble)
    {
        if(pl.poison_count == 0)return;
        pl.poison_count--;
        EntFireByHandle(self, "RunScriptCode", "GetPlayerClassByHandle(activator).poison_count++", 100, pl.handle, pl.handle);
        if(pl.poison_count == 0)
        {
            button_poison = false
            EntFireByHandle(self, "RunScriptCode", "button_poison = true", 160, null, null);
            EntFire("item_effect_poison", "Stop", "", 0, null);
            EntFire("item_button_poison", "Lock", "", 0, null);
            EntFire("item_button_poison", "Unlock", "", 160, null);
            EntFire("item_effect_poison", "Start", "", 160, null);
            StartCDpoison(160);
        }
    }
    else
    {
        local cd = item.GetCD(lvl);
        if(pl.item_buff_recovery)cd -= 10;
        button_poison = false
        EntFireByHandle(self, "RunScriptCode", "button_poison = true", cd, null, null);
        EntFire("item_effect_poison", "Stop", "", 0, null);
        EntFire("item_button_poison", "Lock", "", 0, null);
        EntFire("item_button_poison", "Unlock", "", cd, null);
        EntFire("item_effect_poison", "Start", "", cd, null);
        StartCDpoison(cd);
    }
    Entities.FindByName(null, "item_spawner_poison").SpawnEntity();


    local trigger = Entities.FindByName(null, "item_temp_poison_trigger");

    local Worktime = item.GetDuration(lvl);
    local radius = item.GetRadius(lvl);

    if(pl.item_buff_turbo)Worktime += 2;
    if(pl.item_buff_radius)radius *= 1.1;

    trigger.GetScriptScope().lvl = lvl;
    trigger.GetScriptScope().dist = radius;
    trigger.GetScriptScope().damage = item.GetDamage(lvl) * 0.05;
    trigger.GetScriptScope().slow = item.GetTime(lvl);
    trigger.GetScriptScope().worktime = Worktime;

    local name = Time().tointeger()
    EntFire("item_temp_poison_trigger", "AddOutPut", "targetname item_temp_poison_trigger"+name, 0, null);
    EntFire("item_temp_poison_effect", "AddOutPut", "targetname item_temp_poison_effect"+name, 0, null);

    EntFire("item_temp_poison_trigger"+name, "Kill", "", Worktime, null);
    EntFire("item_temp_poison_effect"+name, "Kill", "", Worktime, null);
}

function UseEarth()
{
    local pl = GetPlayerClassByHandle(activator);
    local item = GetItemPresetByName("earth");

    local lvl = pl.earth_lvl;
    if(lvl == 0)lvl++;

    if(pl.item_buff_doble)
    {
        if(pl.earth_count == 0)return;
        pl.earth_count--;
        EntFireByHandle(self, "RunScriptCode", "GetPlayerClassByHandle(activator).earth_count++", 100, pl.handle, pl.handle);
        if(pl.earth_count == 0)
        {
            button_earth = false
            EntFireByHandle(self, "RunScriptCode", "button_earth = true", 160, null, null);
            EntFire("item_effect_earth", "Stop", "", 0, null);
            EntFire("item_button_earth", "Lock", "", 0, null);
            EntFire("item_button_earth", "Unlock", "", 160, null);
            EntFire("item_effect_earth", "Start", "", 160, null);
            StartCDearth(160);
        }
    }
    else
    {
        local cd = item.GetCD(lvl);
        if(pl.item_buff_recovery)cd -= 10;
        button_earth = false
        EntFireByHandle(self, "RunScriptCode", "button_earth = true", cd, null, null);
        EntFire("item_effect_earth", "Stop", "", 0, null);
        EntFire("item_button_earth", "Lock", "", 0, null);
        EntFire("item_button_earth", "Unlock", "", cd, null);
        EntFire("item_effect_earth", "Start", "", cd, null);
        StartCDearth(cd);
    }
    Entities.FindByName(null, "item_spawner_earth").SpawnEntity();

    local trigger = Entities.FindByName(null, "item_temp_earth_trigger");

    local worktime = item.GetDuration(lvl);

    if(pl.item_buff_turbo)worktime += 2;

    trigger.SetHealth(item.GetDamage(lvl));

    local name = Time().tointeger()
    EntFire("item_temp_earth_trigger", "AddOutPut", "targetname item_temp_earth_trigger"+name, 0, null);

    EntFire("item_temp_earth_trigger"+name, "Break", "", worktime, null);
}

function StartCDearth(cd = 0)
{
    if(cd != 0)cd_earth = cd;
    else cd_earth -= 1;
    if(cd_earth > 1)
    {
        EntFireByHandle(self, "RunScriptCode", "StartCDearth()", 1, null, null);
    }
}

function StartCDgravity(cd = 0)
{
    if(cd != 0)cd_gravity = cd;
    else cd_gravity -= 1;
    if(cd_gravity > 1)
    {
        EntFireByHandle(self, "RunScriptCode", "StartCDgravity()", 1, null, null);
    }
}

function StartCDultimate(cd = 0)
{
    if(cd != 0)cd_ultimate = cd;
    else cd_ultimate -= 1;
    if(cd_ultimate > 1)
    {
        EntFireByHandle(self, "RunScriptCode", "StartCDultimate()", 1, null, null);
    }
}

function UseGravity()
{
    local pl = GetPlayerClassByHandle(activator);
    local item = GetItemPresetByName("gravity");

    local lvl = pl.gravity_lvl;
    if(lvl == 0)lvl++;
    if(pl.item_buff_doble)
    {
        if(pl.gravity_count == 0)return;
        pl.gravity_count--;
        EntFireByHandle(self, "RunScriptCode", "GetPlayerClassByHandle(activator).gravity_count++", 100, pl.handle, pl.handle);
        if(pl.gravity_count == 0)
        {
            button_gravity = false
            EntFireByHandle(self, "RunScriptCode", "button_gravity = true", 160, null, null);
            EntFire("item_effect_gravity", "Stop", "", 0, null);
            EntFire("item_button_gravity", "Lock", "", 0, null);
            EntFire("item_button_gravity", "Unlock", "", 160, null);
            EntFire("item_effect_gravity", "Start", "", 160, null);
            StartCDgravity(160);
        }
    }
    else
    {
        local cd = item.GetCD(lvl);
        if(pl.item_buff_recovery)cd -= 10;
        button_gravity = false
        EntFireByHandle(self, "RunScriptCode", "button_gravity = true", cd, null, null);
        EntFire("item_effect_gravity", "Stop", "", 0, null);
        EntFire("item_button_gravity", "Lock", "", 0, null);
        EntFire("item_button_gravity", "Unlock", "", cd, null);
        EntFire("item_effect_gravity", "Start", "", cd, null);
        StartCDgravity(cd);
    }
    Entities.FindByName(null, "item_spawner_gravity").SpawnEntity();


    local trigger = Entities.FindByName(null, "item_temp_gravity_trigger");

    local worktime = item.GetDuration(lvl);
    local radius = item.GetRadius(lvl);

    if(pl.item_buff_turbo)worktime += 2;
    if(pl.item_buff_radius)radius *= 1.1;

    trigger.GetScriptScope().dist = radius;
    trigger.GetScriptScope().power = item.GetDamage(lvl);

    local name = Time().tointeger()
    EntFire("item_temp_gravity_trigger", "AddOutPut", "targetname item_temp_gravity_trigger"+name, 0, null);
    EntFire("item_temp_gravity_effect", "AddOutPut", "targetname item_temp_gravity_effect"+name, 0, null);
    EntFire("Item_temp_gravity_sound", "AddOutPut", "targetname Item_temp_gravity_sound"+name, 0, null);


    EntFire("item_temp_gravity_trigger"+name, "Kill", "", worktime, null);
    EntFire("item_temp_gravity_effect"+name, "Kill", "", worktime, null);
    EntFire("Item_temp_gravity_sound"+name, "Kill", "", worktime, null);
}

function UseFire()
{
    local trigger = Entities.FindByName(null, "item_trigger_fire");
    if(trigger.GetScriptScope().ticking)return;

    local pl = GetPlayerClassByHandle(activator);
    local item = GetItemPresetByName("fire");

    local lvl = pl.fire_lvl;
    if(lvl == 0)lvl++;
    if(pl.item_buff_doble)
    {
        if(pl.fire_count == 0)return;
        pl.fire_count--;
        EntFireByHandle(self, "RunScriptCode", "GetPlayerClassByHandle(activator).fire_count++", 100, pl.handle, pl.handle);
        if(pl.fire_count == 0)
        {
            button_fire = false
            EntFireByHandle(self, "RunScriptCode", "button_fire = true", 160, null, null);
            EntFire("item_effect_fire", "Stop", "", 0, null);
            EntFire("item_button_fire", "Lock", "", 0, null);
            EntFire("item_button_fire", "Unlock", "", 160, null);
            EntFire("item_effect_fire", "Start", "", 160, null);
            StartCDfire(160);
        }
    }
    else
    {
        local cd = item.GetCD(lvl);
        if(pl.item_buff_recovery)cd -= 10;
        button_fire = false
        EntFireByHandle(self, "RunScriptCode", "button_fire = true", cd, null, null);
        EntFire("item_effect_fire", "Stop", "", 0, null);
        EntFire("item_button_fire", "Lock", "", 0, null);
        EntFire("item_button_fire", "Unlock", "", cd, null);
        EntFire("item_effect_fire", "Start", "", cd, null);
        StartCDfire(cd);
    }

    local worktime = item.GetDuration(lvl);
    local radius = item.GetRadius(lvl);

    if(pl.item_buff_turbo)worktime += 2;
    if(pl.item_buff_radius)radius *= 1.1;

    trigger.GetScriptScope().dist = radius;
    trigger.GetScriptScope().damage = item.GetDamage(lvl) * 0.05;
    trigger.GetScriptScope().flametime = item.GetTime(lvl);

    EntFire("item_sound_fire", "PlaySound", "", 0, null);

    EntFire("item_effect_trigger_fire", "Start", "", 0, null);
    EntFire("item_trigger_fire", "RunScriptCode", "Enable()", 0.01, null);

    EntFire("item_trigger_fire", "RunScriptCode", "Disable()", worktime, null);
    EntFire("item_effect_trigger_fire", "Stop", "", worktime, null);
}

function StartCDfire(cd = 0)
{
    if(cd != 0)cd_fire = cd;
    else cd_fire -= 1;
    if(cd_fire > 1)
    {
        EntFireByHandle(self, "RunScriptCode", "StartCDfire()", 1, null, null);
    }
}

function StartCDheal(cd = 0)
{
    if(cd != 0)cd_heal = cd;
    else cd_heal -= 1;
    if(cd_heal > 1)
    {
        EntFireByHandle(self, "RunScriptCode", "StartCDheal()", 1, null, null);
    }
}

function UseHeal()
{
    local trigger = Entities.FindByName(null, "item_trigger_heal");
    if(trigger.GetScriptScope().ticking)return;

    local pl = GetPlayerClassByHandle(activator);
    local item = GetItemPresetByName("heal");

    local lvl = pl.heal_lvl;
    if(lvl == 0)lvl++;
    if(pl.item_buff_doble)
    {
        if(pl.heal_count == 0)return;
        pl.heal_count--;
        EntFireByHandle(self, "RunScriptCode", "GetPlayerClassByHandle(activator).heal_count++", 100, pl.handle, pl.handle);
        if(pl.heal_count == 0)
        {
            button_heal = false
            EntFireByHandle(self, "RunScriptCode", "button_heal = true", 160, null, null);
            EntFire("item_effect_heal", "Stop", "", 0, null);
            EntFire("item_button_heal", "Lock", "", 0, null);
            EntFire("item_button_heal", "Unlock", "", 160, null);
            EntFire("item_effect_heal", "Start", "", 160, null);
            StartCDheal(160);
        }
    }
    else
    {
        local cd = item.GetCD(lvl);
        if(pl.item_buff_recovery)cd -= 10;
        button_heal = false
        EntFireByHandle(self, "RunScriptCode", "button_heal = true", cd, null, null);
        EntFire("item_effect_heal", "Stop", "", 0, null);
        EntFire("item_button_heal", "Lock", "", 0, null);
        EntFire("item_button_heal", "Unlock", "", cd, null);
        EntFire("item_effect_heal", "Start", "", cd, null);
        StartCDheal(cd);
    }

    local worktime = item.GetDuration(lvl);
    local radius = item.GetRadius(lvl);

    if(pl.item_buff_turbo)worktime += 2;
    if(pl.item_buff_radius)radius *= 1.1;

    trigger.GetScriptScope().dist = radius;
    trigger.GetScriptScope().worktime = worktime;
    trigger.GetScriptScope().lvl = lvl;

    EntFire("item_sound_heal", "PlaySound", "", 0, null);

    EntFire("item_effect_trigger_heal", "Start", "", 0, null);
    EntFire("item_trigger_heal", "RunScriptCode", "Enable()", 0.01, null);

    EntFire("item_trigger_heal", "RunScriptCode", "Disable()", worktime, null);
    EntFire("item_effect_trigger_heal", "Stop", "", worktime, null);
}

function CheckItem(pl)
{
    if(pl == user_bio)
    {
        user_bio = null;
        if(pl.item_buff_last)
        {
            EntFire("item_button_bio", "Press", "", 0, pl.handle);
            //EntFireByHandle(self, "RunScriptCode", "UseBio();", 0, pl.handle, pl.handle);
        }
    }
    else if(pl == user_ice)
    {
        user_ice = null;
        if(pl.item_buff_last)
        {
            EntFire("item_button_ice", "Press", "", 0, pl.handle);
            //EntFireByHandle(self, "RunScriptCode", "UseIce();", 0, pl.handle, pl.handle);
        }
    }
    else if(pl == user_poison)
    {
        user_poison = null;
        if(pl.item_buff_last)
        {
            EntFire("item_button_poison", "Press", "", 0, pl.handle);
            //EntFireByHandle(self, "RunScriptCode", "UsePoison();", 0, pl.handle, pl.handle);
        }
    }
    else if(pl == user_wind)
    {
        user_wind = null;
        if(pl.item_buff_last)
        {
            EntFire("item_button_wind", "Press", "", 0, pl.handle);
            //EntFireByHandle(self, "RunScriptCode", "UseWind();", 0, pl.handle, pl.handle);
        }
    }
    else if(pl == user_summon)
    {
        user_summon = null;
        if(pl.item_buff_last)
        {
            EntFire("item_button_summon", "Press", "", 0, pl.handle);
            //EntFireByHandle(self, "RunScriptCode", "UseSummon();", 0, pl.handle, pl.handle);
        }
    }
    else if(pl == user_fire)
    {
        user_fire = null;
        if(pl.item_buff_last)
        {
            EntFire("item_button_fire", "Press", "", 0, pl.handle);
            //EntFireByHandle(self, "RunScriptCode", "UseFire();", 0, pl.handle, pl.handle);
        }
    }
    else if(pl == user_electro)
    {
        user_electro = null;
        if(pl.item_buff_last)
        {
            EntFire("item_button_electro", "Press", "", 0, pl.handle);
            //EntFireByHandle(self, "RunScriptCode", "UseElectro();", 0, pl.handle, pl.handle);
        }
    }
    else if(pl == user_earth)
    {
        user_earth = null;
        if(pl.item_buff_last)
        {
            EntFire("item_button_earth", "Press", "", 0, pl.handle);
            //EntFireByHandle(self, "RunScriptCode", "UseEarth();", 0, pl.handle, pl.handle);
        }
    }
    else if(pl == user_gravity)
    {
        user_gravity = null;
        if(pl.item_buff_last)
        {
            EntFire("item_button_gravity", "Press", "", 0, pl.handle);
            //EntFireByHandle(self, "RunScriptCode", "UseGravity();", 0, pl.handle, pl.handle);
        }
    }
    else if(pl == user_ultimate)
    {
        user_ultimate = null;
        if(pl.item_buff_last)
        {
            EntFire("item_button_ultimate", "Press", "", 0, pl.handle);
            //EntFireByHandle(self, "RunScriptCode", "UseUltimate();", 0, pl.handle, pl.handle);
        }
    }
    else if(pl == user_heal)
    {
        user_heal = null;
        if(pl.item_buff_last)
        {
            EntFire("item_button_heal", "Press", "", 0, pl.handle);
            //EntFireByHandle(self, "RunScriptCode", "UseHeal();", 0, pl.handle, pl.handle);
        }
    }
}

SilenceTime <- 20;
function UseSilence(time = SilenceTime)
{
    local hm_itemlist = [
    "bio","ice","poison","wind",
    "summon","fire","electro","earth",
    "gravity","ultimate","heal"];

    //local button_ice = Entities.FindByName(null, "item_button_ice");

    for (local i = 0; i < hm_itemlist.len(); i++)
    {
        local button = Entities.FindByName(null, "item_button_"+hm_itemlist[i]);
        if(button != null)
        {

            local root_parent = button.GetRootMoveParent();
            local EnableTime = time;
            EntFireByHandle(button, "RunScriptCode", "au = false", 0, null, null);
            if(root_parent != null && root_parent.GetClassname() == "player")
            {
                local pl = GetPlayerClassByHandle(activator);
                EnableTime = pl.Get_Resist_From_First_lvl(EnableTime);
            }
            local stop_praticle = false;
            if(hm_itemlist[i] == "bio"){if(button_bio){stop_praticle = true;}}
            else if(hm_itemlist[i] == "ice"){if(button_ice){stop_praticle = true;}}
            else if(hm_itemlist[i] == "poison"){if(button_poison){stop_praticle = true;}}
            else if(hm_itemlist[i] == "wind"){if(button_wind){stop_praticle = true;}}
            else if(hm_itemlist[i] == "summon"){if(button_summon){stop_praticle = true;}}
            else if(hm_itemlist[i] == "fire"){if(button_fire){stop_praticle = true;}}
            else if(hm_itemlist[i] == "electro"){if(button_electro){stop_praticle = true;}}
            else if(hm_itemlist[i] == "earth"){if(button_earth){stop_praticle = true;}}
            else if(hm_itemlist[i] == "gravity"){if(button_gravity){stop_praticle = true;}}
            else if(hm_itemlist[i] == "ultimate"){if(button_ultimate){stop_praticle = true;}}
            else if(hm_itemlist[i] == "heal"){if(button_heal){stop_praticle = true;}}
            if(stop_praticle)
            {
                EntFire("item_effect_"+hm_itemlist[i], "Stop", "", 0, null);
                EntFire("item_effect_"+hm_itemlist[i], "Start", "", EnableTime, null);
            }
            EntFireByHandle(button, "RunScriptCode", "au = true", EnableTime, null, null);
        }
    }
}

///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
//Player manager

function ElseCheck()
{
    if(PLAYERS.len() > 0)
    {
        for(local i = 0; i < PLAYERS.len(); i++)
        {
            local pl = PLAYERS[i].handle;
            if(MAPPER_STEAM_ID.len() > 0)
            {
                if(!PLAYERS[i].mapper)
                {
                    for(local a = 0; a < MAPPER_STEAM_ID.len(); a++)
                    {
                        if(PLAYERS[i].steamid == MAPPER_STEAM_ID[a])
                        {
                            PLAYERS[i].mapper = true;
                            PLAYERS[i].vip = true;
                            ShowPlayerText(pl,"Спасибо за карту")
                        }
                    }
                }
            }
            if(VIP_STEAM_ID.len() > 0)
            {
                if(!PLAYERS[i].vip)
                {
                    for(local a = 0; a < VIP_STEAM_ID.len(); a++)
                    {
                        if(PLAYERS[i].steamid == VIP_STEAM_ID[a])
                        {
                            PLAYERS[i].vip = true;
                            PLAYERS[i].Add_money(VIP_BONUS_M);
                            ShowPlayerText(pl,"Thanks for supporting")
                        }
                    }
                }
            }
            if(pl != null)
            {
                if(pl.IsValid())
                {
                    if(pl.GetHealth() >= 600 && pl.GetTeam() == 2)
                    {
                        if(PLAYERS[i].setPerks == false)
                        {
                            local alldone = true;
                            if(PLAYERS[i].perkspeed_lvl != 0)
                            {
                                if(PLAYERS[i].slow == false)
                                {
                                    PLAYERS[i].speed = PLAYERS[i].defspeed;
                                    EntFireByHandle(SpeedMod, "ModifySpeed", (PLAYERS[i].defspeed).tostring(), 0.1, pl, pl);
                                }
                                else alldone = false;
                            }
                            if(PLAYERS[i].perkchameleon_lvl != 0)
                            {
                                EntFireByHandle(pl, "AddOutput", "rendermode 1", 0, pl, pl);
                                EntFireByHandle(pl, "AddOutput", "renderamt "+(160 - PLAYERS[i].perkchameleon_lvl * PLAYERS[i].perkchameleon_chameleonperlvl).tostring(), 0.05, pl, pl);
                            }
                            if(PLAYERS[i].perkhp_zm_lvl != 0)
                            {
                                local hp = 7500 + PLAYERS[i].perkhp_zm_lvl * PLAYERS[i].perkhp_zm_maxlvl;
                                pl.SetHealth(hp);
                                pl.SetMaxHealth(hp);
                            }
                            if(alldone)PLAYERS[i].setPerks = true;
                        }
                    }
                }
            }
        }
    }
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
    return ElseCheck();
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
            "\nMAPPER: "+GetPlayerClassByHandle(activator).ReturnMapper());
            printl(
            "\nMONEY: "+GetPlayerClassByHandle(activator).money+
            "\nCANLVLUP: "+GetPlayerClassByHandle(activator).maxlvluping+
            "\nBIO: "+GetPlayerClassByHandle(activator).bio_lvl+
            "\nICE: "+GetPlayerClassByHandle(activator).ice_lvl+
            "\nPOISON: "+GetPlayerClassByHandle(activator).poison_lvl+
            "\nWIND: "+GetPlayerClassByHandle(activator).wind_lvl+
            "\nSUMMON: "+GetPlayerClassByHandle(activator).summon_lvl+
            "\nFIRE: "+GetPlayerClassByHandle(activator).fire_lvl+
            "\nELECTRO: "+GetPlayerClassByHandle(activator).electro_lvl+
            "\nEARTH: "+GetPlayerClassByHandle(activator).earth_lvl+
            "\nGRAVITY: "+GetPlayerClassByHandle(activator).gravity_lvl+
            "\nULTIMATE: "+GetPlayerClassByHandle(activator).ultimate_lvl+
            "\nHEAL: "+GetPlayerClassByHandle(activator).heal_lvl
            );
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
        "\nMAPPER: "+GetPlayerClassByUserID(uid).ReturnMapper());
        printl(
        "\nMONEY: "+GetPlayerClassByUserID(uid).money+
        "\nCANLVLUP: "+GetPlayerClassByUserID(uid).maxlvluping+
        "\nBIO: "+GetPlayerClassByUserID(uid).bio_lvl+
        "\nICE: "+GetPlayerClassByUserID(uid).ice_lvl+
        "\nPOISON: "+GetPlayerClassByUserID(uid).poison_lvl+
        "\nWIND: "+GetPlayerClassByUserID(uid).wind_lvl+
        "\nSUMMON: "+GetPlayerClassByUserID(uid).summon_lvl+
        "\nFIRE: "+GetPlayerClassByUserID(uid).fire_lvl+
        "\nELECTRO: "+GetPlayerClassByUserID(uid).electro_lvl+
        "\nEARTH: "+GetPlayerClassByUserID(uid).earth_lvl+
        "\nGRAVITY: "+GetPlayerClassByUserID(uid).gravity_lvl+
        "\nULTIMATE: "+GetPlayerClassByUserID(uid).ultimate_lvl+
        "\nHEAL: "+GetPlayerClassByUserID(uid).heal_lvl
        );
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

function GetPlayerInvalidStatusByHandle(handle)
{
	foreach(p in PLAYERS)
	{
		if(p.handle == handle)
		{
            if(p.steamid != null)
            {
                for(local a = 0; a < INVALID_STEAM_ID.len(); a++)
                {
                    local steamid = split(INVALID_STEAM_ID[a]," ");
                    if(steamid.len() > 1)
                    {
                        if(p.steamid == steamid[0])
                        return steamid[1];
                    }
                }
            }
            return null;
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
            return p.SetMapper();
		}
	}
	return null;
}

function GetItemPresetByName(name)
{
    foreach (i in Item_Preset)
    {
        if(name == i.name)
        {
            return i;
        }
    }
    return null;
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

///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
//event manager
function PlayerJump()
{
    local userid = eventjump.GetScriptScope().event_data.userid;
    local pl = GetPlayerClassByUserID(userid);
    if(pl != null)
    {
        if(pl.pet != null)
        {
            local pet_index = GetPetIndexByHandle(pl.pet);
            if(pet_index != null)
            {
                pl.petstatus = "JUMP"
                EntFireByHandle(pl.pet, "SetAnimation", Pet_Preset[pet_index].anim_jump, 0, null, null);
                EntFireByHandle(pl.pet, "AddOutPut", "OnAnimationDone map_brush:RunScriptCode:PetStatus("+userid.tostring()+");:0:1", 0, pl.handle, pl.handle);
            }
        }
        if(pl.invalid)
        {
            local handle = pl.handle;
            handle.SetVelocity(Vector(handle.GetVelocity().x,handle.GetVelocity().y,0));
        }
    }
}

function PetStatus(userid)
{
    GetPlayerClassByUserID(userid).petstatus = "";
}

function GetPetIndexByHandle(handle)
{
    local model = handle.GetModelName()
    for(local i = 0;i < Pet_Preset.len() ;i++)
	{
        if(model == Pet_Preset[i].model_path)
        return i;
    }
    return null;
}

function PlayerDisconnect()
{
	local userid = eventdisconnect.GetScriptScope().event_data.userid;
	local steamid = eventdisconnect.GetScriptScope().event_data.networkid;
    local pl = GetPlayerClassByUserID(userid);
    if(pl != null)
    {
        if(pl.steamid == steamid && pl.steamid != "BOT")
        {
            PLAYERS_SAVE.push(pl);
        }
    }
}

function PlayerDeath()
{
    local userid = eventdeath.GetScriptScope().event_data.userid;
    local attacker = eventdeath.GetScriptScope().event_data.attacker;
    local b = GetPlayerClassByUserID(userid);
    if(b == null)return;
    if(b.handle.GetTeam() == 2)b.setPerks = false;
    if(b.pet != null)b.pet.Destroy();
    if(b.handle.GetModelName() == ModelPrecache[0])EntFire("sound_sephiroth_death", "PlaySound", "", 0, null);
    b.invalid = false;
    CheckItem(b);
    if(attacker == 0)return;
    local a = GetPlayerClassByUserID(attacker);
    if(a.handle == b.handle)return;

    if(a.perksteal_lvl == 0)return;
    local a_lvl_steal = a.perksteal_lvl;
    local a_lvl_luck = a.perkluck_lvl;
    local integer = a_lvl_steal * a.perksteal_stilleperlvl;
    local still_money = RandomInt(integer - a.perksteal_stilleperlvl + a_lvl_luck + 1,integer + a_lvl_luck);
    local target_money = b.money;
    if(a.handle.GetTeam() == 3)still_money = still_money * 0.5;
    if(target_money >= still_money)
    {
        b.Minus_money(still_money);
        a.Add_money(still_money);
    }
    else
    {
        b.Minus_money(still_money);
        a.Add_money(target_money);
    }
}

function PlayerSay()
{
    // try
    // {
        if(eventsay == null || eventsay != null && !eventsay.IsValid())
        {
            eventsay = Entities.FindByName(null, "pl_say");
        }
        if(PlayerText == null || PlayerText != null && !PlayerText.IsValid())
        {
            PlayerText = Entities.FindByName(null, "playerText");
        }
        local userid = eventsay.GetScriptScope().event_data.userid;
        local msg = eventsay.GetScriptScope().event_data.text;
        if(msg.find("!map_knife") != 0){msg = msg.tolower();}
        if(msg.find("!map_stats") != 0){msg = msg.tolower();}
        if(msg.find("!map_model") != 0){msg = msg.tolower();}
        if(msg.find("!map_ef") != 0){msg = msg.tolower();}
        if(msg.find("!map_stats") == 0)
        {
            local sp_text = split(msg," ");
            local len = sp_text.len();
            if(len > 4)return;
            local handle = GetPlayerByUserID(userid);
            local target = GetPlayerClassByUserID(userid);
            local Info = PrintText_Info(target);
            if(len > 1)
            {
                if(sp_text[1] == "info" || sp_text[1] == "i" || sp_text[1] == "1")Info = PrintText_Info(target);
                else if(sp_text[1] == "item" || sp_text[1] == "m" || sp_text[1] == "materia"|| sp_text[1] == "2")Info = PrintText_Item(target);
                else if(sp_text[1] == "perk" || sp_text[1] == "p" || sp_text[1] == "3")Info = PrintText_Perk(target);
                else if(sp_text[1] == "hm" || sp_text[1] == "h" || sp_text[1] == "human" || sp_text[1] == "4")Info = PrintText_Perk_hm(target);
                else if(sp_text[1] == "zm" || sp_text[1] == "z" || sp_text[1] == "zombie" || sp_text[1] == "5")Info = PrintText_Perk_zm(target);
                else return;
                if(len > 2)
                {
                    if(sp_text[2] != "@me")target = GetPlayerClassByUserID(sp_text[2].tointeger());
                    if(target == null)return
                }
            }
            ShowPlayerText(handle,Info)
        }
        if(msg == "!map_invalid")
        {
            if(!allow_invalid)return;
            local pl = GetPlayerClassByUserID(userid);
            if(!(pl.handle.IsValid()) || pl.handle.GetTeam() != 3)return;
            if(pl.invalid)
            {
                local oldKnife = null;
                while((oldKnife = Entities.FindByClassname(oldKnife,"weapon_knife*")) != null)
                {
                    if(oldKnife.GetOwner() == pl.handle)
                    {
                        oldKnife.Destroy();
                        pl.invalid = false;
                        EntFireByHandle(pl.handle, "AddOutput", "MoveType 2", 0, null, null);

                        local Equip = Entities.CreateByClassname("game_player_equip");
                        Equip.__KeyValueFromString("weapon_knife","1");
                        EntFireByHandle(Equip,"Use","",0.00,pl.handle,pl.handle);
                        Equip.Destroy();
                        EntFireByHandle(SpeedMod, "ModifySpeed", "1", 0, pl.handle, pl.handle);
                        return;
                    }
                }
            }
            else SetInvalid(pl.handle)
        }
        if(msg.find("!map_knife") == 0)
        {
            local sp_text = split(msg," ");
            local len = sp_text.len();
            if(len > 2)return;

            local handle = GetPlayerByUserID(userid);
            if(!handle.IsValid() || handle.GetTeam() != 3 || handle.GetHealth() <= 0)return;
            local array = ["bayonet",
            "m9_bayonet","karambit",
            "butterfly","widowmaker","flip",
            "gut","tactical","falchion",
            "push","survival_bowie","stiletto",
            "gypsy_jackknife","ursus","css",
            "skeleton","cord","canis","outdoor"];

            local knife = null;
            if(len > 1)
            {
                for (local i = 0; i < array.len(); i++)
                {
                    if(array[i] == sp_text[1])
                    {
                        knife = array[i];
                        break;
                    }
                }
            }
            local oldKnife = null;
            while((oldKnife = Entities.FindByClassname(oldKnife,"weapon_knife*")) != null)
            {
                if(oldKnife.GetOwner() == handle)
                {
                    oldKnife.Destroy();
                    local Equip = Entities.CreateByClassname("game_player_equip");
                    if(knife == null)Equip.__KeyValueFromString("weapon_knife","1");
                    else Equip.__KeyValueFromString("weapon_knife_"+knife,"1");
                    EntFireByHandle(Equip,"Use","",0.00,handle,handle);
                    Equip.Destroy();
                    //EntFireByHandle(Equip,"Kill","",0.05,null,null);
                    EntFireByHandle(self,"RunScriptCode","MoveKnife();",0.05,handle,handle);
                    return;
                }
            }
        }
        if(msg.find("!map_model") == 0)
        {
            local sp_text = split(msg," ");
            local len = sp_text.len();
            if(len != 2)return;

            local handle = GetPlayerByUserID(userid);
            if(!handle.IsValid() || handle.GetTeam() != 3 || handle.GetHealth() <= 0)return;

            if(sp_text[1] == "0" || sp_text[1] == "sephiroth")
            {
                if(handle.GetModelName() == ModelPrecache[0])return;
                handle.SetModel(ModelPrecache[0]);
            }
        }
        local get_mapper = GetMapperByUserId(userid);
        if(get_mapper != null && get_mapper)
        {
            if(msg == "!map_rr")
            {
                local g_round = Entities.FindByName(null, "round_end");
                if(g_round != null && g_round.IsValid())
                {
                    EntFireByHandle(g_round, "EndRound_Draw", "3", 0.00, null, null);
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
    // }
    // catch(error)
    // {
    //     return;
    // }
}

function PlayerConnect()
{
    if(eventlist == null || eventlist != null && !eventlist.IsValid())
    {
        SendToConsoleServer("sv_disable_immunity_alpha 0");
        eventlist = Entities.FindByName(null, "event_player_connect");
    }
    if(eventsay == null || eventsay != null && !eventsay.IsValid())
    {
        eventsay = Entities.FindByName(null, "pl_say");
    }
	local userid = eventlist.GetScriptScope().event_data.userid;
    local name = eventlist.GetScriptScope().event_data.name;
	local steamid = eventlist.GetScriptScope().event_data.networkid;
    local p = LoadSave(steamid);
    if(p == null)
    {
        p = Player(userid,name,steamid);
    }
    else
    {
        p.userid = userid;
        p.name = name;
    }
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
    local p = Player(userid,"NULL","NULL");
    p.handle = TEMP_HANDLE;
    PLAYERS.push(p);
}

function LoadSave(steamid)
{
    if(PLAYERS_SAVE.len() > 0)
    {
        for(local i = 0; i < PLAYERS_SAVE.len(); i++)
        {
            if(PLAYERS_SAVE[i].steamid == steamid && PLAYERS_SAVE[i].steamid != "BOT")
            {
                local data = PLAYERS_SAVE[i];
                PLAYERS_SAVE.remove(i);
                return data;
            }
        }
        return null;
    }
    return null;
}

function ShowPlayerText(handle,text)
{
    if(PlayerText == null || PlayerText != null && !PlayerText.IsValid())
    {
        PlayerText = Entities.FindByName(null, "playerText");
    }
    if(PlayerText == null || PlayerText != null && !PlayerText.IsValid())return;

    EntFireByHandle(PlayerText, "SetText", text, 0, handle, handle);
    EntFireByHandle(PlayerText, "Display", "", 0, handle, handle);
}

function SetInvalid(handle)
{
    local invalid_maker = Entities.FindByName(null, "waffel_template");
    if(invalid_maker == null)return;
    local handlepos = handle.GetOrigin();

    local makerpos = invalid_maker.GetOrigin();
    EntFireByHandle(invalid_maker, "ForceSpawn", "", 0, null, null);
    EntFireByHandle(handle, "AddOutPut", "origin "+makerpos.x.tostring()+" "+makerpos.y.tostring()+" "+makerpos.z.tostring(), 0.01, null, null);
    EntFireByHandle(handle, "AddOutPut", "origin "+handlepos.x.tostring()+" "+handlepos.y.tostring()+" "+handlepos.z.tostring(), 0.2, null, null);
}

function IsInvalid()
{
    local pl = GetPlayerClassByHandle(activator);
    if(pl != null)
    {
        if(!pl.invalid)
        {
            local oldKnife = null;
            while((oldKnife = Entities.FindByClassname(oldKnife,"weapon_knife*")) != null)
            {
                if(oldKnife.GetOwner() == activator)
                {
                    oldKnife.Destroy();
                    caller.Destroy();
                    return;
                }
            }
        }
    }
}

///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
//Music manager

M_Path <- "doom2016\\music\\"
::M_Argent <- M_Path+"Argent_Facility.mp3";//после телепорта	Argent_Facility
::M_Beginning <- M_Path+"The_Beginning.mp3";// После 2ой двери	The_Beginning	s1_Spawn_Hold1_Trigger

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
        EntFireByHandle(Music,"AddOutPut", "message *"+Name,2.1,null,null);
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
::item <- "item";
::lvl1 <- "lvl1";
::lvl2 <- "lvl2";
::lvl3 <- "lvl3";

::Mes_Warmup <- " \x02 *** \x10 Разминка \x02 ***";
::RED <- "\x02"
::GREEN <- "\x04"
::YELLOW <- "\x09"
::IDLE <- "IDLE";
ModelPrecache <-
[
"models/player/custom_player/microrost/sephiroth/sephiroth.mdl"
];
SoundsPrecache <-
[
"Seph_I_Will..._Never"
];
function Precache()
{
    if(SoundsPrecache.len() > 0)
    {
        for (local i=0; i<SoundsPrecache.len(); i++)
        {
            self.PrecacheScriptSound(SoundsPrecache[i]);
        }
    }

    local structure = null;
    structure = Pet("0 50 0","models/kmodels/petux1.mdl","","","","","100-255","100-255","100-255","0 0 0","0.6");
    Pet_Preset.push(structure);
    structure = Pet("0 -50 0","models/microrost/cosmov6/ff7r/chokobo.mdl","run","idle2","idle","stoprun","0-150","0-150","0-150","-90 270 0","0.5");
    Pet_Preset.push(structure);

    if(Pet_Preset.len() > 0)
    {
        for (local i=0; i<Pet_Preset.len(); i++)
        {
            self.PrecacheModel(Pet_Preset[i].model_path);
        }
    }
    if(ModelPrecache.len() > 0)
    {
        for (local i=0; i<ModelPrecache.len(); i++)
        {
            self.PrecacheModel(ModelPrecache[i]);
        }
    }
}
ServerSettings <-[
"mp_freezetime 0",
"mp_startmoney 16000",
"mp_roundtime 25",
"sv_airaccelerate 12",
"zr_infect_mzombie_ratio 6",
"zr_infect_spawntime_min 18",
"zr_infect_spawntime_max 18",
"zr_ztele_zombie 1",
"zr_ztele_max_human 0",
"zr_ztele_max_zombie 3",
"zr_class_modify zombies health_infect_gain 250",
"zr_class_modify zombies health 7500",
"zr_class_modify zombies health_regen_interval 0.15",
"zr_class_modify zombies health_regen_amount 50",
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

// teleportitem
// function SavePos()
// {
//     if(PLAYERS.len() > 0)
//     {
//         foreach(p in PLAYERS)
//         {
//             if(p.handle != null)
//             {
//                 if(p.handle.IsValid() && p.handle.GetHealth() > 0)
//                 {
//                     p.SetLastPos();
//                     if(p.pet != null)
//                     {
//                         local pet_index = GetPetIndexByHandle(p.pet);
//                         local velocity = p.handle.GetVelocity();
//                         if(velocity.x == 0 && velocity.y == 0 && velocity.z == 0)
//                         {
//                             if(p.petstatus != "IDLE" && p.petstatus != "JUMP")
//                             {
//                                 p.petstatus = "IDLE";
//                                 EntFireByHandle(p.pet, "SetDefaultAnimation", Pet_Preset[pet_index].anim_idle, 0, null, null);
//                                 EntFireByHandle(p.pet, "SetAnimation", Pet_Preset[pet_index].anim_toidle, 0, null, null);
//                             }
//                         }
//                         else
//                         {
//                             if(p.petstatus != "RUN" && p.petstatus != "JUMP")
//                             {
//                                 p.petstatus = "RUN";
//                                 EntFireByHandle(p.pet, "SetDefaultAnimation", Pet_Preset[pet_index].anim_run, 0, null, null);
//                                 EntFireByHandle(p.pet, "SetAnimation", Pet_Preset[pet_index].anim_run, 0, null, null);
//                             }
//                         }
//                     }
//                 }
//             }
//         }
//     }
//     EntFireByHandle(self, "RunScriptCode", "SavePos();", 0.1, null, null);
// }
// function Teleport()
// {
//     local pl = GetPlayerClassByHandle(activator);
//     if(pl == null)return;
//     if(pl.teleporting)return;

//     // local model_name = activator.GetModelName();
//     // local model = Entities.CreateByClassname("prop_dynamic_glow");
//     // model.SetModel(model_name);
//     // model.SetOrigin(activator.GetOrigin());
//     // model.SetAngles(activator.GetAngles().x,activator.GetAngles().y,activator.GetAngles().z);
//     // model.__KeyValueFromString("glowenabled","1");
//     // model.__KeyValueFromString("glowstyle","1");
//     // model.__KeyValueFromString("glowdist","1024");
//     // model.__KeyValueFromString("glowcolor","244 0 0");

//     pl.teleporting = true;
//     local array = pl.lastpos.slice(0,pl.lastpos.len());
//     local array1 = pl.lastang.slice(0,pl.lastang.len());
//     pl.lastpos.clear();
//     pl.lastang.clear();
//     Revers(array);
//     Revers(array1);
//     local i = 0;
//     local iter = 0.02;

//     for (i; i < array.len() - 1; i++)
//     {
//         local time = i * iter;
//         EntFireByHandle(self, "RunScriptCode", "test1();", time + 0.1, activator, activator);
//         EntFireByHandle(activator, "RunScriptCode", "self.SetOrigin(Vector("+array[i].x+","+array[i].y+","+array[i].z+"));", time, null, null);
//         EntFireByHandle(activator, "RunScriptCode", "self.SetAngles("+array1[i].x+","+array1[i].y+","+array1[i].z+");", time, null, null);
//     }
//     i++;
//     EntFireByHandle(self, "RunScriptCode", "GetPlayerClassByHandle(activator).teleporting = false;", i * iter, activator, activator);
// }
// function Revers(array)
// {
//     local start = 0;
//     local end = array.len() -1;
//     while (start < end)
//     {
//         local temp = array[start];
//         array[start] = array[end];
//         array[end] = temp;
//         start++;
//         end--;
//     }
//     return array;
// }
// function test1()
// {
//     local model_name = activator.GetModelName();
//     local model = Entities.CreateByClassname("prop_dynamic_glow");
//     model.SetModel(model_name);
//     model.SetOrigin(activator.GetOrigin());
//     model.SetAngles(activator.GetAngles().x,activator.GetAngles().y,activator.GetAngles().z);
//     model.__KeyValueFromString("glowenabled","1");
//     model.__KeyValueFromString("glowstyle","1");
//     model.__KeyValueFromString("rendermode","2");
//     model.__KeyValueFromString("renderamt","225");
//     EntFireByHandle(model, "Alpha", "120", 0, null, null);
//     // model.__KeyValueFromString("renderamt","150");
//     model.__KeyValueFromString("glowdist","1024");
//     model.__KeyValueFromString("glowcolor","255 0 0");

//     EntFireByHandle(model, "RunScriptCode", "self.Destroy();", 0.1, null, null);
// }

// function SpawnExplosion(origin,radius,damage,team = -1)
// {
//     local sound = Entities.CreateByClassname("ambient_generic");
//     sound.__KeyValueFromInt("radius",radius * 1.5);
//     sound.__KeyValueFromString("message","weapons/flashbang/flashbang_explode1.wav");
//     sound.SetOrigin(origin);

//     local shake = Entities.CreateByClassname("env_shake");
//     shake.__KeyValueFromInt("radius",radius);
//     shake.__KeyValueFromString("duration","2");
//     shake.__KeyValueFromString("frequency","0.25");
//     shake.__KeyValueFromString("spawnflags","28");
//     shake.__KeyValueFromString("amplitude","25");
//     shake.SetOrigin(origin);

//     local sprite = Entities.CreateByClassname("env_sprite");
//     sprite.__KeyValueFromString("rendermode","5");
//     sprite.__KeyValueFromString("sprites/zerogxplode.vmt","5");
//     sprite.SetOrigin(origin);

//     EntFireByHandle(shake, "StartShake", "", 0, null, null);
//     EntFireByHandle(sound, "PlaySound", "", 0, null, null);
//     EntFireByHandle(sprite, "ShowSprite", "", 0, null, null);
//     local h = null;
//     while(null != (h = Entities.FindByClassnameWithin(h, "player", origin, radius)))
//     {
//         if(h != null && h.IsValid() && h.GetHealth() > 0)
//         {
//             local hp = h.GetHealth();
//             hp = hp - damage;
//             if(hp <= 0)
//             {
//                 EntFireByHandle(h, "SetHealth", "-1", 0, null, null);
//             }
//             else h.SetHealth(hp);
//         }
//     }
    //EntFireByHandle(shake, "Kill", "", 1, null, null);
    //EntFireByHandle(sound, "Kill", "", 1, null, null);
    //EntFireByHandle(sprite, "Kill", "", 1, null, null);
// }

// function test(i)
// {
//     local pet = CreateProp("prop_dynamic", activator.GetOrigin()"models/microrost/cosmov6/ff7r/chokobo.mdl", i);
// }

// function SetInvalid()
// {
//     local pl = GetPlayerClassByHandle(activator);
//     if(pl != null)
//     {
//         pl.invalid = true;
//     }
// }

