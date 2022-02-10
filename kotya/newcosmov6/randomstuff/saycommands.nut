//Main
{
    // Default: \x01
    // Dark Red: \x02
    // Purple: \x03
    // Green: \x04
    // Light Green: \x05
    // Lime Green: \x06
    // Red: \x07
    // Grey: \x08
    // Orange: \x09
    // Brownish Orange: \x10 
    // Gray: \x08 
    // Very faded blue: \x0A 
    // Faded blue: \x0B 
    // Dark blue: \x0C 
    ::SayScript <- self;

    Command_pref <- "!mc_"
    ::Chat_pref <- " \x07[\x04MAP\x07]\x01 "
    ::Tifa_pref <- " \x06(\x0E Tifa \x06) ➢ \x01 "
    ::RedX_pref <- " \x06(\x07 Red XIII \x06) ➢ \x01 "
    ::OldMan_pref <- " \x06(\x09 Old Man \x06) ➢ \x01 "
    ::ShinraSoldier_pref <- " \x06(\x02 Shinra Soldier \x06) ➢ \x01 "
    ::Scan_pref <- " \x06(\x05 Scan ability \x06) ➢ \x01 "
    ::Casino_pref <- " \x06(\x10 Cosmo Casino \x06) ➢ \x01 "
    function OnPostSpawn()
    {
        Start();
    }
    
    ::Allow_Waffel <- true;
    ::Allow_Knife <- true;

    function Start()
    {
        // Command_pref + "knife", "GetKnife", 1
        // +Command_pref + "stats", "GetStatus", 0

        // +Command_pref + "money", "Money", 1
        // +Command_pref + "stage", "Stage", 0
        EntFireByHandle(self,"RunScriptCode","Allow_Waffel = false; Allow_Knife = false", 30, null, null);
        EntFire("waffel_button*", "UnLock", "", 45, null);

    }

    map_brush <- Entities.FindByName(null, "map_brush");

    function PlayerSay()
    {
        // try
        {
            local userid = event_data.userid;
            
            local playerdata = map_brush.GetScriptScope().GetPlayerClassByUserID(userid);

            if(playerdata == null)
                return;
            
            local access = (playerdata.mapper) ? 2 : (playerdata.vip) ? 1 : 0;
            local msg = event_data.text;
            local args = "";

            //LAST !!!!!!
            msg.tolower();
            args = split(msg," ");
        
            if(Command_pref + "stage" == args[0])
            {
                Stage(userid, 
                (args.len() > 1) ? args[1] : "");
            }

            else if(Command_pref + "help" == args[0])
            {
                Help();
            }

            else if(Command_pref + "record" == args[0])
            {
                Record();
            }

            else if(Command_pref + "id" == args[0])
            {
                Id(userid, 
                (args.len() > 1) ? args[1] : "");
            }

            else if(Command_pref + "stats" == args[0])
            {
                GetStatus(userid, 
                (args.len() > 1) ? args[1] : "",
                (args.len() > 2) ? args[2] : "");
            }

            else if(Command_pref + "transfer" == args[0])
            {
                Transfer(userid, 
                (args.len() > 1) ? args[1] : "",
                (args.len() > 2) ? args[2] : "");
            }

            else if(Command_pref + "waffelcar" == args[0])
            {
                if(Allow_Waffel)
                    WaffelCar(userid);
            }

            if(access > 0)
            {
                if(Command_pref + "knife" == args[0])
                {
                    if(Allow_Knife)
                        Knife(userid, 
                        (args.len() > 1) ? args[1] : "");
                }

                if(access > 1)

                if(Command_pref + "money" == args[0])
                {
                    Money(userid, 
                    (args.len() > 1) ? args[1] : "",
                    (args.len() > 2) ? args[2] : "",
                    (args.len() > 3) ? args[3] : "");
                }

                else if(Command_pref + "admin" == args[0])
                {
                    TeleportAdminRoom(userid, 
                    (args.len() > 1) ? args[1] : "");
                }
            }


        }
        // catch(error)
        // {
        //     return;
        // }
    }
}
//targer value de
//sm_addvip <#steam_id|#name|#userid> <group> <time>
function Help() 
{
    local text;

    text = "\x09" + Command_pref + "id\x01 - shows your\x04 ID";
    ScriptPrintMessageChatAll(Chat_pref + text);  

    text = "\x09" + Command_pref + "stage\x01 - shows the current\x04 Stage";
    ScriptPrintMessageChatAll(Chat_pref + text);  

    text = "\x09" + Command_pref + "stats [@me|userid] [info|item|perk|hm|zm]\x01 - shows the selected\x04 info";
    ScriptPrintMessageChatAll(Chat_pref + text);

    text = "\x09" + Command_pref + "transfer <userid> <amount>\x01 - transfers your\x04 cash\x01 to the player";
    ScriptPrintMessageChatAll(Chat_pref + text);

    text = "\x09" + Command_pref + "waffelcar\x01 -\x04 get\x01 a Waffel Car";
    ScriptPrintMessageChatAll(Chat_pref + text);

    text = "\x01[\x04VIP\x01]\x09" + Command_pref + "knife <m9_bayonet|karambit|...>\x01 - switches the\x04 Knife";
    ScriptPrintMessageChatAll(Chat_pref + text);
}

function Record() 
{
    local text;
    if(GREEN_CHEST_RECORD_CLASS != null)
        text = "\x04Green\x01 Chest: \x04" + GREEN_CHEST_RECORD + "\x01 sec - " + "\x04" + GREEN_CHEST_RECORD_CLASS.name + "\x01 {\x07" + GREEN_CHEST_RECORD_CLASS.steamid + "\x01}";
    else 
        text = "\x04Green\x01 Chest: \x04Not set";
    ScriptPrintMessageChatAll(Chat_pref + text);

    if(GREEN_CHEST_RECORD_CLASS != null) 
        text = "\x02Red\x01 Chest: \x04" + RED_CHEST_RECORD + "\x01 sec - " + "\x04" + RED_CHEST_RECORD_CLASS.name + "\x01 {\x07" + RED_CHEST_RECORD_CLASS.steamid + "\x01}";
    else 
        text = "\x02Red\x01 Chest: \x04Not set";
    ScriptPrintMessageChatAll(Chat_pref + text);  

}
function Id(userid, arguments1 = "") 
{
    local player_class = null;
    if(arguments1 == "" ||arguments1 == "@me")
        player_class = map_brush.GetScriptScope().GetPlayerClassByUserID(userid);
    else
        player_class = TryGetUserID(arguments1);
    
    if(player_class == null)
        return;

    ScriptPrintMessageChatAll(Chat_pref + "\x04" + player_class.name + "\x01 {\x07" + player_class.steamid + "\x01} has ID \x04" + player_class.userid);  
}

function TryGetUserID(value) 
{
    local PLAYERS = map_brush.GetScriptScope().PLAYERS;

    if(value.find("STEAM_1:") != null)
    {
        foreach(pl in PLAYERS)
        {
            if(pl.steamid == value)
                return pl;
        }
    }
    else
    {
        foreach(pl in PLAYERS)
        {
            if(pl.name.find(value) != null)
                return pl;
        }
        foreach(pl in PLAYERS)
        {
            if(pl.userid == value.tointeger())
                return pl;
        }
    }

    return null;
}

function TeleportAdminRoom(userid, arguments1 = "")
{
    local player_class = map_brush.GetScriptScope().GetPlayerClassByUserID(userid);
    local target;
    if(arguments1 != "")
    {
        if(arguments1 != "@me")
        {
            target = map_brush.GetScriptScope().GetPlayerClassByUserID(arguments1.tointeger());
            if(target == null)
                return
        }
        else
        {
            target = player_class;
        }
    }
    else 
        target = player_class;
    
    if(target.handle == null)
        return;
    if(!target.handle.IsValid() && target.handle.GetHealth() <= 0)
        return;
    ScriptPrintMessageChatAll(Chat_pref + "\x04" + player_class.name + "\x01 {\x07" + player_class.steamid + "\x01} teleport \x04" + target.name + "\x01 to\x07 admin room");
    target.handle.SetOrigin(Entities.FindByName(null, "admoon_trigger").GetOrigin());
}
function WaffelCar(userid)
{
    if(!WAFFEL_CAR_ENABLE)
        return
    local handle = map_brush.GetScriptScope().GetPlayerByUserID(userid);
    if(handle == null)
        return;
    if(!handle.IsValid() && handle.GetHealth() <= 0 && handle.GetTeam() != 3)
        return;
    local waffel_car = Entities.FindByName(null, "waffel_controller");
    local car_class = waffel_car.GetScriptScope().GetClassByInvalid(handle);
    if(car_class == null)
    {
        MainScript.GetScriptScope().SetInvalid(handle);
    }
    else
    {
        waffel_car.GetScriptScope().DestroyCar(handle);
    }
}
function Knife(userid, arguments1 = "")
{
    if(arguments1 == "")
    {
        local text;
        text = "\x01[\x04VIP\x01]\x09!map_knife <m9_bayonet|karambit|bayonet|butterfly|widowmaker|flip|gut|tactical|falchion|push|survival_bowie|stiletto|gypsy_jackknife|ursus|css|skeleton|cord|canis|outdoor>";
        ScriptPrintMessageChatAll(Chat_pref + text);
        return;
    }
    local player_class = map_brush.GetScriptScope().GetPlayerClassByUserID(userid);

    if(player_class == null)
        return;
    local handle = player_class.handle;
    if(handle == null || !handle.IsValid() || handle.GetHealth() <= 0)
        return;

    local knifename =  null;
    local array = ["bayonet",
    "m9_bayonet","karambit",
    "butterfly","widowmaker","flip",
    "gut","tactical","falchion",
    "push","survival_bowie","stiletto",
    "gypsy_jackknife","ursus","css",
    "skeleton","cord","canis","outdoor"];

    for(local i = 0; i < array.len(); i++)
    {
        if(array[i] == arguments1)
        { 
            knifename = arguments1;
            break;
        }
    }
    if(knifename == null)
        return;
    
    player_class.knife = knifename;

    local oldKnife = null;
    while((oldKnife = Entities.FindByClassname(oldKnife, "weapon_knife*")) != null)
    {
        if(oldKnife.GetOwner() == handle)
        {
            if(oldKnife.GetClassname() == "weapon_knifegg")
                return;
            
            oldKnife.Destroy();
            local Equip = Entities.CreateByClassname("game_player_equip");    
            Equip.__KeyValueFromInt("weapon_knife_"+knifename, 1);

            EntFireByHandle(Equip, "Use", "",0.00,handle,handle);

            EntFireByHandle(Equip, "Kill", "",0.05,handle,handle);
            EntFireByHandle(self, "RunScriptCode", "MoveKnife()",0.05,null,null);
            return;
        }
    }
}

function MoveKnife()
{
    local handle = null;
    while((handle = Entities.FindByClassname(handle, "weapon_knife")) != null)
    {
        if(handle.GetOwner() == null)
        {
            handle.__KeyValueFromString("classname", "weapon_knifegg");
        }
    }
}


function Transfer(userid, arguments1 = "", arguments2 = "")
{
    local player_class = map_brush.GetScriptScope().GetPlayerClassByUserID(userid);
    local target_class = map_brush.GetScriptScope().GetPlayerClassByUserID(arguments1.tointeger());

    if(player_class == null || target_class == null)
        return;
    if(player_class == target_class)
        return;
    local remove_money = arguments2.tointeger();
    local add_money = player_class.GetNewPriceV2(remove_money)
    if(remove_money <= 1)
        return;
    if(player_class.money < remove_money)
        return;
    player_class.Minus_money(remove_money);
    target_class.Add_money(add_money);
    
    ScriptPrintMessageChatAll(Chat_pref + "\x04" + player_class.name + "\x01 {\x07" + player_class.steamid + "\x01} has\x09 transferred \x04" + remove_money + "\x01{\x07" + (add_money - remove_money) + "\x01}\x04 money\x01 for \x04" + target_class.name + "\x01 {\x07" + target_class.steamid + "\x01}");
}

function Money(userid, arguments1 = "", arguments2 = "", arguments3 = "")
{
    local target;
    local newmoney;

    local player_class = map_brush.GetScriptScope().GetPlayerClassByUserID(userid);

    if(arguments1 != "")
    {
        if(arguments1 != "@me")
        {
            if(arguments1 == "@all")
                target = "@all"
            else if(arguments1 == "@t")
                target = "@t"
            else if(arguments1 == "@ct")
                target = "@ct"
            else target = map_brush.GetScriptScope().GetPlayerClassByUserID(arguments1.tointeger());
            
            if(target == null)
                return
        }
        else
        {
            target = map_brush.GetScriptScope().GetPlayerClassByUserID(userid);
        }

        if(arguments2 != "")
        {
            if(arguments3 != "")
            {
                if(arguments3 == "+")
                {
                    if(typeof target == "string")
                    {
                        local handle = null;
                        local handle_data;
                        while((handle = Entities.FindByClassname(handle, "player")) != null)
                        {
                            if(handle == null)
                                continue;
                            if(!handle.IsValid())
                                continue;

                            if(target == "@all")
                            {
                                handle_data = map_brush.GetScriptScope().GetPlayerClassByHandle(handle)
                                newmoney = handle_data.money + arguments2.tointeger();
                                handle_data.money = newmoney
                            }
                            else if(target == "@t")
                            {
                                if(handle.GetTeam() == 2)
                                {
                                    handle_data = map_brush.GetScriptScope().GetPlayerClassByHandle(handle)
                                    newmoney = handle_data.money + arguments2.tointeger();
                                    handle_data.money = newmoney
                                }
                            }
                            else if(target == "@ct")
                            {
                                if(handle.GetTeam() == 3)
                                {
                                    handle_data = map_brush.GetScriptScope().GetPlayerClassByHandle(handle)
                                    newmoney = handle_data.money + arguments2.tointeger();
                                    handle_data.money = newmoney
                                }
                            }
                        }

                        ScriptPrintMessageChatAll(Chat_pref + "\x04" + player_class.name + "\x01 {\x07" + player_class.steamid + "\x01} + \x07" + arguments2.tointeger() + "\x04 money\x01 for \x04" + target);
                        return;
                    }

                    newmoney = target.money + arguments2.tointeger();
                    ScriptPrintMessageChatAll(Chat_pref + "\x04" + player_class.name + "\x01 {\x07" + player_class.steamid + "\x01} + \x07" + newmoney + "\x04 money\x01 for \x04" + target.name);
                    target.money = newmoney
                }
                else if(arguments3 == "-")
                {
                    if(typeof target == "string")
                    {
                        local handle = null;
                        local handle_data;
                        while((handle = Entities.FindByClassname(handle, "player")) != null)
                        {
                            if(handle == null)
                                continue;
                            if(!handle.IsValid())
                                continue;

                            if(target == "@all")
                            {
                                handle_data = map_brush.GetScriptScope().GetPlayerClassByHandle(handle)
                                newmoney = handle_data.money - arguments2.tointeger();
                                handle_data.money = newmoney
                            }
                            else if(target == "@t")
                            {
                                if(handle.GetTeam() == 2)
                                {
                                    handle_data = map_brush.GetScriptScope().GetPlayerClassByHandle(handle)
                                    newmoney = handle_data.money - arguments2.tointeger();
                                    handle_data.money = newmoney
                                }
                            }
                            else if(target == "@ct")
                            {
                                if(handle.GetTeam() == 3)
                                {
                                    handle_data = map_brush.GetScriptScope().GetPlayerClassByHandle(handle)
                                    newmoney = handle_data.money - arguments2.tointeger();
                                    handle_data.money = newmoney
                                }
                            }
                        }

                        ScriptPrintMessageChatAll(Chat_pref + "\x04" + player_class.name + "\x01 {\x07" + player_class.steamid + "\x01} - \x07" + arguments2.tointeger() + "\x04 money\x01 for \x04" + target);
                        return;
                    }

                    newmoney = target.money - arguments2.tointeger();
                    ScriptPrintMessageChatAll(Chat_pref + "\x04" + player_class.name + "\x01 {\x07" + player_class.steamid + "\x01} - \x07" + newmoney + "\x04 money\x01 for \x04" + target.name);
                    target.money = newmoney
                }
                else if(arguments3 == "*")
                {
                    if(typeof target == "string")
                    {
                        local handle = null;
                        local handle_data;
                        while((handle = Entities.FindByClassname(handle, "player")) != null)
                        {
                            if(handle == null)
                                continue;
                            if(!handle.IsValid())
                                continue;

                            if(target == "@all")
                            {
                                handle_data = map_brush.GetScriptScope().GetPlayerClassByHandle(handle)
                                newmoney = handle_data.money * arguments2.tointeger();
                                handle_data.money = newmoney
                            }
                            else if(target == "@t")
                            {
                                if(handle.GetTeam() == 2)
                                {
                                    handle_data = map_brush.GetScriptScope().GetPlayerClassByHandle(handle)
                                    newmoney = handle_data.money * arguments2.tointeger();
                                    handle_data.money = newmoney
                                }
                            }
                            else if(target == "@ct")
                            {
                                if(handle.GetTeam() == 3)
                                {
                                    handle_data = map_brush.GetScriptScope().GetPlayerClassByHandle(handle)
                                    newmoney = handle_data.money * arguments2.tointeger();
                                    handle_data.money = newmoney
                                }
                            }
                        }
                    
                        ScriptPrintMessageChatAll(Chat_pref + "\x04" + player_class.name + "\x01 {\x07" + player_class.steamid + "\x01} * \x07" + arguments2.tointeger() + "\x04 money\x01 for \x04" + target);
                        return;
                    }
                    newmoney = target.money * arguments2.tointeger();
                    ScriptPrintMessageChatAll(Chat_pref + "\x04" + player_class.name + "\x01 {\x07" + player_class.steamid + "\x01} * \x07" + newmoney + "\x04 money\x01 for \x04" + target.name);
                    target.money = newmoney
                }
                else
                    return;
            }  
            else
            {
                if(typeof target == "string")
                {
                    local handle = null;
                    while((handle = Entities.FindByClassname(handle, "player")) != null)
                    {
                        if(handle == null)
                            continue;
                        if(!handle.IsValid())
                            continue;
                        
                        if(target == "@all")
                            map_brush.GetScriptScope().GetPlayerClassByHandle(handle).money = arguments2.tointeger();
                        else if(target == "@t")
                        {
                            if(handle.GetTeam() == 2)
                                map_brush.GetScriptScope().GetPlayerClassByHandle(handle).money = arguments2.tointeger();
                        }
                        else if(target == "@ct")
                        {
                            if(handle.GetTeam() == 3)
                                map_brush.GetScriptScope().GetPlayerClassByHandle(handle).money = arguments2.tointeger();
                        }
                    }

                    ScriptPrintMessageChatAll(Chat_pref + "\x04" + player_class.name + "\x01 {\x07" + player_class.steamid + "\x01} set \x07" + arguments2.tointeger() + "\x04 money\x01 for \x04" + target);
                    return;
                }
                ScriptPrintMessageChatAll(Chat_pref + "\x04" + player_class.name + "\x01 {\x07" + player_class.steamid + "\x01} set \x07" + arguments2.tointeger() + "\x04 money\x01 for \x04" + target.name);
                target.money = arguments2.tointeger();
            }     
        }
        else
            return;
    }
    else 
        return;
}
function GetStatus(userid, arguments1 = "", arguments2 = "")
{
    local target;
    local info;
    if(arguments1 != "")
    {
        if(arguments1 != "@me")
        {
            target = map_brush.GetScriptScope().GetPlayerClassByUserID(arguments1.tointeger());
            if(target == null)
                return
        }
        else
        {
            target = map_brush.GetScriptScope().GetPlayerClassByUserID(userid);
        }

        if(arguments2 != "")
        {
            if(arguments2 == "info" || arguments2 == "i" || arguments2 == "1")
                info = PrintText_Info(target);
            else if(arguments2 == "item" || arguments2 == "m" || arguments2 == "materia"|| arguments2 == "2")
                info = PrintText_Item(target);
            else if(arguments2 == "perk" || arguments2 == "p" || arguments2 == "3")
                info = PrintText_Perk(target);
            else if(arguments2 == "hm" || arguments2 == "h" || arguments2 == "human" || arguments2 == "4")
                info = PrintText_Perk_hm(target);
            else if(arguments2 == "zm" || arguments2 == "z" || arguments2 == "zombie" || arguments2 == "5")
                info = PrintText_Perk_zm(target);
            else 
                return;
        }
        else
        {
            info = PrintText_Info(target);
        }
    }
    else 
    {
        target = map_brush.GetScriptScope().GetPlayerClassByUserID(userid);
        info = PrintText_Info(target);
    }
    
    local handleshow = map_brush.GetScriptScope().GetPlayerByUserID(userid);
    map_brush.GetScriptScope().ShowPlayerText(handleshow, info);
}

function Stage(userid, arguments1 = "")
{
    local player_class = map_brush.GetScriptScope().GetPlayerClassByUserID(userid);
    if(arguments1 != "")
    {
        if(!player_class.mapper)
            return;
        arguments1 = arguments1.tostring();

        if(arguments1 == "0" || arguments1 == "warmup")
        {
            map_brush.GetScriptScope().AdminSetStage(0);
            ScriptPrintMessageChatAll(Chat_pref + "\x04" + player_class.name + "\x01 {\x07" + player_class.steamid + "\x01} set " + GetStageByNumber(0) + " \x04stage");
        }
            
        else if(arguments1 == "1" || arguments1 == "normal")
        {
            map_brush.GetScriptScope().AdminSetStage(1);
            ScriptPrintMessageChatAll(Chat_pref + "\x04" + player_class.name + "\x01 {\x07" + player_class.steamid + "\x01} set " + GetStageByNumber(1) + " \x04stage");
        }
            
        else if(arguments1 == "2" || arguments1 == "hard")
        {
            map_brush.GetScriptScope().AdminSetStage(2);
            ScriptPrintMessageChatAll(Chat_pref + "\x04" + player_class.name + "\x01 {\x07" + player_class.steamid + "\x01} set " + GetStageByNumber(2) + " \x04stage");
        }

        else if(arguments1 == "3" || arguments1 == "zm")
        {
            map_brush.GetScriptScope().AdminSetStage(3);
            ScriptPrintMessageChatAll(Chat_pref + "\x04" + player_class.name + "\x01 {\x07" + player_class.steamid + "\x01} set " + GetStageByNumber(3) + " \x04stage");
        }

        else if(arguments1 == "4" || arguments1 == "extreme")
        {
            map_brush.GetScriptScope().AdminSetStage(4);
            ScriptPrintMessageChatAll(Chat_pref + "\x04" + player_class.name + "\x01 {\x07" + player_class.steamid + "\x01} set " + GetStageByNumber(4) + " \x04stage");
        }

        else if(arguments1 == "5" || arguments1 == "inferno")
        {
            map_brush.GetScriptScope().AdminSetStage(5);
            ScriptPrintMessageChatAll(Chat_pref + "\x04" + player_class.name + "\x01 {\x07" + player_class.steamid + "\x01} set " + GetStageByNumber(5) + " \x04stage");
        }
    }
    else 
    {
        local Stage = map_brush.GetScriptScope().Stage;
        ScriptPrintMessageChatAll(Chat_pref + "Current \x04stage\x01 is " + GetStageByNumber(Stage))
    }
}
//Support
{
    function GetStageByNumber(num)
    {
        local Stage_name = "None";

        switch (num)
        {
            case 0:
            Stage_name = "\x08" + "Warmup"
            break;

            case 1:
            Stage_name = "\x04" + "Normal"
            break;

            case 2:
            Stage_name = "\x09" + "Hard"
            break;

            case 3:
            Stage_name = "\x03" + "ZM"
            break;

            case 4:
            Stage_name = "\x07" + "Extreme"
            break;

            case 5:
            Stage_name = "\x02" + "Inferno"
            break;

        }

        return Stage_name;
    }
}


function PrintText_Item(pl)
{
    local text = "";
    if(pl.bio_lvl > 0)text += "Bio <- ["+pl.bio_lvl+"/"+MaxLevel+"]\n";
    if(pl.ice_lvl > 0)text += "Ice <- ["+pl.ice_lvl+"/"+MaxLevel+"]\n";
    if(pl.poison_lvl > 0)text += "Poison <- ["+pl.poison_lvl+"/"+MaxLevel+"]\n";
    if(pl.wind_lvl > 0)text += "Wind <- ["+pl.wind_lvl+"/"+MaxLevel+"]\n";
    if(pl.summon_lvl > 0)text += "Summon <- ["+pl.summon_lvl+"/"+MaxLevel+"]\n";
    if(pl.fire_lvl > 0)text += "Fire <- ["+pl.fire_lvl+"/"+MaxLevel+"]\n";
    if(pl.electro_lvl > 0)text += "Electro <- ["+pl.electro_lvl+"/"+MaxLevel+"]\n";
    if(pl.earth_lvl > 0)text += "Earth <- ["+pl.earth_lvl+"/"+MaxLevel+"]\n";
    if(pl.gravity_lvl > 0)text += "Gravity <- ["+pl.gravity_lvl+"/"+MaxLevel+"]\n";
    if(pl.ultimate_lvl > 0)text += "Ultima <- ["+pl.ultimate_lvl+"/"+MaxLevel+"]\n";
    if(pl.heal_lvl > 0)text += "Heal <- ["+pl.heal_lvl+"/"+MaxLevel+"]\n";
    if(text == "")text += "No Materia level";
    return text;
}

function PrintText_Info(pl)
{
    local text = "";
    text += "NAME <- "+pl.name+"\n";
    text += "STEAMID <- "+pl.steamid+"\n";
    text += "MONEY <- "+pl.money+"\n";
    text += "Status <- " + ((pl.mapper) ? "Mapper" : (pl.vip) ? "VIP" : "Player");
    text += "\nLVLup <- ";
    if(pl.maxlvluping == 0){text +="No";}else{text += pl.maxlvluping;}

    return text;
}

function PrintText_Perk(pl)
{
    local text = "";
    if(pl.perkhuckster_lvl > 0)
        text += "Huckster <- ["+pl.perkhuckster_lvl+"/"+perkhuckster_maxlvl+"]\n";
    if(pl.perksteal_lvl > 0)
        text += "Thief("+pl.otm+") <- ["+pl.perksteal_lvl+"/"+perksteal_maxlvl+"]\n";
    if(pl.perkluck_lvl > 0)
        text += "Lucky Warrior <- ["+pl.perkluck_lvl+"/"+perkluck_maxlvl+"]\n";
    if(text == "")
        text += "No perks";
    return text;
}

function PrintText_Perk_zm(pl)
{
    local text = "";
    if(pl.perkhp_zm_lvl > 0)
        text += "Zombie HP <- ["+pl.perkhp_zm_lvl+"/"+perkhp_zm_maxlvl+"]\n";
    if(pl.perkspeed_lvl > 0)
        text += "Zombie Speed <- ["+pl.perkspeed_lvl+"/"+perkspeed_maxlvl+"]\n";
    if(pl.perkchameleon_lvl > 0)
        text += "Zombie Chameleon <- ["+pl.perkchameleon_lvl+"/"+perkchameleon_maxlvl+"]\n";
    if(pl.perkresist_zm_lvl > 0)
        text += "Human Materia Resist <- ["+pl.perkresist_zm_lvl+"/"+perkresist_zm_maxlvl+"]\n";
    if(text == "")
        text += "No Zombie perks";
    return text;
}

function PrintText_Perk_hm(pl)
{
    local text = "";
    if(pl.perkhp_hm_lvl > 0)
        text += "Human HP <- ["+pl.perkhp_hm_lvl+"/"+perkhp_hm_maxlvl+"]\n";
    if(pl.perkresist_hm_lvl > 0)
        text += "Attack Resist <- ["+pl.perkresist_hm_lvl+"/"+perkresist_hm_maxlvl+"]\n";
    if(pl.item_buff_radius || pl.item_buff_last || pl.item_buff_recovery || pl.item_buff_turbo || pl.item_buff_doble)
        text += "Support Materia <- "+((pl.item_buff_radius) ? "All" : (pl.item_buff_last) ? "Final Attack" : (pl.item_buff_recovery) ? "Recovery" : (pl.item_buff_last) ? "MP turbo" : "W-magic")+"\n";
    if(text == "")
        text += "No Human perks";
    return text;
}

/*
if(msg.find("!map_knife") != 0)
if(msg.find("!map_stats") != 0){msg = msg.tolower();}
if(msg.find("!map_model") != 0){msg = msg.tolower();}
if(msg.find("!map_money") != 0){msg = msg.tolower();}

if(msg.find("!map_money") == 0)
{
    local sp_text = split(msg," ");
    local len = sp_text.len();
    if(len == 2)
    {
        local target = GetPlayerClassByUserID(userid);
        local money = sp_text[1].tointeger();
        target.Add_money(money);
    }
    return;
}
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
}
*/