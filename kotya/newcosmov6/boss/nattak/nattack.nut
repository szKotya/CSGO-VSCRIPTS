/*
▞▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▚
    Gi Nattack script by Kotya[STEAM_1:1:124348087]
    test branch update 09.06.2021 
▚▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▞
*/

// ▞▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▚
//      Main settings    
// ▚▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▞
{
    CenterArea <- Vector(-1888, 5120, 276);
    InArena_Radius <- 704;
    NearBoss_Radius <- 350;

    //smart_system        <- false;

    ticking <- false;
    tickrate <- 0.1;

    tickrate_use <- 0;
    cd_use_CAN <- true;

    tickrate_minion <- 0;

    cd_use <- 15.0;
    cd_use_d <- cd_use / 17;

    function SetCDUse(i)
    {
        cd_use = 0.00 + i;
        cd_use_d = i / 17;
    }
}
// ▞▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▚
//      Status   
// ▚▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▞
Status              <- "";
// ▞▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▚
//      HP settings    
// ▚▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▞
{
    HP <- 0;
    HP_INIT <- 0;
    HP_BARS <- 16;

    function SetHP(i)
    {
        i = (0.00 + i) / HP_BARS;
        
        local handle = null;
        while(null != (handle = Entities.FindByClassname(handle, "player")))
        {
            if(handle.IsValid())
            {
                if(handle.GetTeam() == 3 && handle.GetHealth() > 0)
                {
                    HP += i;
                    HP_INIT += i;
                }
            }
        }
    }

    function AddHP(i)
    {
        if(i < 0)
        {
            i = -i * HP_INIT;
        }

        while(HP + i >= HP_INIT)
        {
            HP_BARS++;
            i -= HP_INIT;
        }

        if(HP_BARS <= 16)
        {
            local id = 16 - HP_BARS;
            EntFire("Special_HealthTexture", "SetTextureIndex", "" + id, 0.00);
        }
        else EntFire("Special_HealthTexture", "SetTextureIndex", "0", 0.00);

        HP += i;
    }

    Shoot_OneMoney <- 15;
    Shoot_OneMoney = 1.00 / Shoot_OneMoney;
    function ShootDamage()
    {
        SubtractHP(1);
        MainScript.GetScriptScope().GetPlayerClassByHandle(activator).ShootTick(Shoot_OneMoney);
    }

    function ItemDamage(i)
    {
        if(i < 0)
        {
            i = -i * HP_INIT;
        }

        SubtractHP(i);
    }

    function NadeDamage()
    {
        //SubtractHP(80);
        SubtractHP(1);

        if(!Stanned)
        {
            NadeCount++
            NadeTickRate += NadeTime;

            if(NadeCount >= NadeNeed)
                SetStanned();
        }
    }


    function SubtractHP(i)
    {
        if(Stanned)i *= StanDamage;
            HP -= i;
    }

    function ItemEffect_Ice(time)
    {
        if(time <= 0)
            return;
        cd_use_CAN = false;

		local ice_temp = Entities.FindByName(null, "map_ice_temp_01"); 
        ice_temp.SetOrigin(Model.GetOrigin() + Vector(0, 0, 150))
        EntFireByHandle(ice_temp, "ForceSpawn", "", 0.00, null, null);
        
        local name = Time().tointeger();

        EntFire("map_ice_model_01", "SetParent", "!activator", 0, Model);

        EntFire("map_ice_model_01", "RunScriptCode", "Spawn(0.5)", 0, null);

	    EntFire("map_ice_model_01", "AddOutPut", "targetname map_ice_model_01"+name, 0, null);
        EntFire("map_ice_model_01"+name, "RunScriptCode", "Kill(" + (time * 0.9) + ")", time * 0.2, null);
        

        EntFireByHandle(Model, "Color", "0 255 0", 0.00, null, null);

        EntFireByHandle(Model, "Color", "255 255 255", time, null, null);
        EntFireByHandle(self, "RunScriptCode", "cd_use_CAN = true;", time, null, null);
    }


    function BossDead()
    {
        local item_target = Entities.FindByName(null, "map_item_beam_target");
        EntFireByHandle(item_target, "ClearParent", "", 0, null, null);

        EntFire("Gi_Nattak_Timer_Bar", "Kill", "", 0);
        EntFire("Gi_Nattak_Name_Bar", "Kill", "", 0);
        EntFire("Gi_Nattak_HP_Bar", "Kill", "", 0);

        EntFire("Gi_Nattak_Model", "FireUser2", "", 0);

        EntFire("Gi_Nattak_Nova*", "Kill", "", 0);
        EntFire("Gi_Nattak_Dark*", "Kill", "", 0);
        EntFire("Gi_Nattak_Fire*", "Kill", "", 0);
        EntFire("Gi_Nattak_Wind*", "Kill", "", 0);
        EntFire("Gi_Nattak_Heal*", "Kill", "", 0);

        EntFire("Ginattack_Shield_Hbox*", "Break", "", 0);
        EntFire("Ginattack_Shield_M*", "RunScriptCode", "Kill(1.25)", 0);

        EntFire("Gi_Nattak_Background_Fire", "Kill", "", 0);
        EntFire("Gi_Nattak_Ultima*", "Kill", "", 0);
        
        EntFire("Gi_Nattak_Superattack*", "Kill", "", 0);

        EntFire("map_sound_boss_dead", "PlaySound", "", 0);

        if(ShieldArray.len() > 0)
        {
            local time = 0;
            local timeadd = (2.0 / ShieldArray.len());

            for(local i = 0; i < ShieldArray.len(); i++)
            {
                EntFireByHandle(ShieldArray[i].hbox, "Break", "", time, null, null);
                EntFireByHandle(ShieldArray[i].model, "RunScriptCode", "Kill(0.5)", time, null, null);
                time += timeadd;
            }

            ShieldArray.clear();
        }
    }
}
// ▞▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▚
//      Stun settings    
// ▚▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▞
{
    Stanned             <- false;
    StanTime            <- 10.0;
    StanDamage          <- 2.0;

    NadeCount <- 0;
    NadeNeed <- 20;
    NadeShow <- 20.0;

    NadeShow = NadeNeed * (NadeShow / 100);

    NadeTickRate <- 0;
    NadeTime <- 1.50;

    function SetStanned()
    {
        NadeTickRate = StanTime;
        NadeCount = 0;
        Stanned = true;

        cd_use_CAN = false;
        EntFireByHandle(self, "RunScriptCode", "cd_use_CAN = true;", StanTime * 0.5, null, null);
    }

    function SetUnStanned()
    {
        Stanned = false;
    }
}

// ▞▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▚
//      Other settings
// ▚▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▞
{
    BossMover <- null;
    Model <- null;

    allow_fire            <- true;
    allow_heal            <- true;
    allow_wind            <- true;
    allow_silence         <- true;
    allow_poison          <- true;
    allow_ultima          <- true;

    allow_gravity         <- false;
    allow_shield          <- false;

    allow_fireNova        <- false;
    allow_superattack     <- false;

    cancast_fire          <- false;
    cancast_heal          <- false;
    cancast_wind          <- false;
    cancast_silence       <- false;
    cancast_poison        <- false;
    cancast_ultima        <- false;

    cancast_gravity       <- false;
    cancast_shield        <- false;

    cancast_fireNova      <- false;
    cancast_superattack   <- false;
}
// ▞▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▚
//      Attack settings    
// ▚▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▞
{
    //FIRE
    {    
        function Cast_Fire()
        {
            cancast_fire = false;

            ScriptPrintMessageChatAll(Scan_pref + "\x07Gi Nattak\x01 is using\x06 fire");
            
            EntFire("Gi_Nattak_Fire_Sound", "PlaySound", "", 0);

            EntFire("Gi_Nattak_Fire_Hurt", "Enable", "", 1.0);
            EntFire("Gi_Nattak_Fire_Effect", "Start", "", 1.0);

            EntFire("Gi_Nattak_Fire_Effect", "Stop", "", 4.5);
            EntFire("Gi_Nattak_Fire_Hurt", "Disable", "",  4.5);
            //EntFire(cmd Command say **Gi Nattak is using fire** 0)
        }
    }
    //HEAL
    {
        function Cast_Heal()
        {
            cancast_heal = false;

            ScriptPrintMessageChatAll(Scan_pref + "\x07Gi Nattak\x01 is using heal");

            //ScriptPrintMessageChatAll("UseHeal");
            EntFire("Gi_Nattak_Heal_Sound", "PlaySound", "", 0);

            EntFire("Gi_Nattak_Heal_Effect", "Start", "", 0);
            EntFire("Gi_Nattak_Heal_Effect", "Stop", "", 3);

            local hp = ((50 * CountAlive()) / 7).tostring();

            EntFireByHandle(self, "RunScriptCode", "AddHP(" + hp + ")", 0.5, null, null);
            EntFireByHandle(self, "RunScriptCode", "AddHP(" + hp + ")", 1, null, null);

            EntFireByHandle(self, "RunScriptCode", "AddHP(" + hp + ")", 1.5, null, null);
            EntFireByHandle(self, "RunScriptCode", "AddHP(" + hp + ")", 2, null, null);

            EntFireByHandle(self, "RunScriptCode", "AddHP(" + hp + ")", 2.5, null, null);
            EntFireByHandle(self, "RunScriptCode", "AddHP(" + hp + ")", 3, null, null);
            //test
            //EntFire("Special_Health", "Add", 600 0);

            //EntFire(cmd Command say **Gi Nattak has healed** 0);
        }
    }
    //WIND
    {
        function Cast_Wind()
        {
            cancast_wind = false;

            //ScriptPrintMessageChatAll("UseWind");
            ScriptPrintMessageChatAll(Scan_pref + "\x07Gi Nattak\x01 is using\x05 wind");

            EntFire("Gi_Nattak_Wind_Sound", "PlaySound", "", 0);

            EntFire("Gi_Nattak_Wind_Push", "Enable", "", 1.25);
            EntFire("Gi_Nattak_Wind_Push", "Disable", "", 4.75);

            EntFire("Gi_Nattak_Wind_Flow", "Start", "", 0);
            EntFire("Gi_Nattak_Wind_Flow", "Stop", "", 4.5);

            EntFire("Gi_Nattak_Wind_Effect", "Start", "", 0);
            EntFire("Gi_Nattak_Wind_Effect", "Stop", "", 4.75);

            //EntFire("cmd Command say **Gi Nattak is using wind** 0);
        }
    }
    //SILENCE
    {
        function Cast_Silence()
        {
            cancast_silence = false;

            ScriptPrintMessageChatAll(Scan_pref + "\x07Gi Nattak\x01 is using\x0C silence");

            EntFire("Gi_Nattak_Silence_Effect", "Stop", "", 20);
            EntFire("Gi_Nattak_Silence_Effect", "Start", "", 0);
            EntFire("map_brush", "RunScriptCode", "UseSilence()", 0);
            //Звук сайленса
            //EntFire("cmd Command say **Gi Nattak is using silence** 0);
        }
    }
    //POISON
    {
        function Cast_Poison()
        {
            cancast_poison = false;

            ScriptPrintMessageChatAll(Scan_pref + "\x07Gi Nattak\x01 is using\x04 poison");

            local origin = Model.GetOrigin() + Vector(0, 0, 420) + (Model.GetForwardVector() * -250);
            EntFire("poison_temp", "AddOutPut", "origin "+origin.x+" "+origin.y+" "+origin.z, 0);
            EntFire("poison_temp", "ForceSpawn", "", 0.02);
        }
    }
    //MINION
    {
        function Cast_Minion()
        {
            if(!RightMinion && !LeftMinion)
                return;

            local origin;
            if(RightMinion && LeftMinion)
            {
                if(RandomInt(0,1))
                {
                    RightMinion = false;
                    EntFireByHandle(self, "RunScriptCode", "RightMinion = true;", 1, null, null);

                    origin = Model.GetOrigin() + Vector(0, 0, 500) + (Model.GetLeftVector() * -235);
                }
                else
                {
                    LeftMinion = false;
                    EntFireByHandle(self, "RunScriptCode", "LeftMinion = true;", 1, null, null);

                    origin = Model.GetOrigin() + Vector(0, 0, 500) + (Model.GetLeftVector() * 235);
                }
            }
            else if(RightMinion)
            {
                RightMinion = false;
                EntFireByHandle(self, "RunScriptCode", "RightMinion = true;", 1, null, null);

                origin = Model.GetOrigin() + Vector(0, 0, 500) + (Model.GetLeftVector() * -235);
            }
            else
            {
                LeftMinion = false;
                EntFireByHandle(self, "RunScriptCode", "LeftMinion = true;", 1, null, null);

                origin = Model.GetOrigin() + Vector(0, 0, 500) + (Model.GetLeftVector() * 235);
            }

            EntFire("Minion_Temp", "AddOutPut", "origin "+origin.x+" "+origin.y+" "+origin.z, 0);
            EntFire("Minion_Temp", "ForceSpawn", "", 0.02);

            //ScriptPrintMessageChatAll("Cast_Minion");
        }
    }
    //GRAVITY
    {
        function Cast_Gravity()
        {
            cancast_gravity = false;

            ScriptPrintMessageChatAll(Scan_pref + "\x07Gi Nattak\x01 is using\x0E gravity");

            EntFire("Gi_Nattak_Dark_Push", "Enable", "", 1.25);
            EntFire("Gi_Nattak_Dark_Push", "Disable", "", 4.75);

            EntFire("Gi_Nattak_Dark_Effect", "Start", "", 0);
            EntFire("Gi_Nattak_Dark_Effect", "Stop", "", 4.5);

            //ScriptPrintMessageChatAll("UseGravity");
        }
    }
    //SHIELD
    {
        ShieldArray <- [];
        class shield
        {
            model = null;
            hbox = null;
            health = 0;
            constructor(_model, _hbox, _health)
            {
                this.model = _model;
                this.hbox = _hbox;
                this.health = _health;
            }
        }

        Shield_Random <- 1;
        Shield_FullRotate <- 4.0;
        Shield_Count <- [4, 6, 8, 16];
        //Shield_Count <- [16];
        Shield_Health <- null;

        Shield_Rot  <- null;
        Shield_Maker  <- null;

        function RegShield()
        {
            local model = caller;
            local hbox = Entities.FindByName(null, "Ginattack_Shield_Hbox" + caller.GetName().slice(caller.GetPreTemplateName().len(),caller.GetName().len()));
            local health = (CountAlive() * Shield_Health) / Shield_Count[Shield_Random];
            ShieldArray.push(shield(model, hbox, health));
        }

        function DamageShield(damage = 1)
        {
            local Shield = null;
            local i = 0;
            for(i = 0; i < ShieldArray.len(); i++)
            {
                if(ShieldArray[i].hbox == caller)
                {
                    Shield = ShieldArray[i];
                    break;
                }
            }

            if(Shield == null)
                return;

            if(Shield.health - damage <= 0)
            {
                EntFireByHandle(Shield.hbox, "Break", "", 0.00, null, null);
                EntFireByHandle(Shield.model, "RunScriptCode", "Kill(1.25)", 0.00, null, null);
                ShieldArray.remove(i);
            }
            else Shield.health--;
        }

        function GetShield(Handle)
        {
            foreach(s in ShieldArray)
            {
                if(s.hbox == Handle)
                    return s;
            }
            return null;
        }

        function Cast_Shield()
        {
            cancast_shield = false;

            ScriptPrintMessageChatAll(Scan_pref + "\x07Gi Nattak\x01 is using\x0C shield");

            //ScriptPrintMessageChatAll("UseShield");

            if(ShieldArray.len() > 0)
            {
                local time = 0;
                local timeadd = (2.0 / ShieldArray.len());

                for(local i = 0; i < ShieldArray.len(); i++)
                {
                    EntFireByHandle(ShieldArray[i].hbox, "Break", "", time, null, null);
                    EntFireByHandle(ShieldArray[i].model, "RunScriptCode", "Kill(0.5)", time, null, null);
                    time += timeadd;
                }

                ShieldArray.clear();
            }
            EntFireByHandle(self, "RunScriptCode", "Cast_Shield_Next();", 1, null, null);
        }

        function Cast_Shield_Next()
        {
            Shield_Random = RandomInt(0, Shield_Count.len() -1);
            local time = 0;
            local speed = 360.0 / Shield_FullRotate;
            local ang = 360.0 / Shield_Count[Shield_Random];
            local timeadd = ang / speed;
            for(local i = Shield_Count[Shield_Random]; 0 < i; i--)
            {
                EntFireByHandle(self, "RunScriptCode", "Spawn_Shield();", time, null, null);
                time += timeadd;
            }
        }

        function Spawn_Shield()
        {
            Shield_Maker.SpawnEntity();
        }
    }
    //FIRENOVA
    {
        FireNova_Maker <- null;
        function Cast_FireNova()
        {
            cancast_fireNova = false;
            ScriptPrintMessageChatAll(Scan_pref + "\x07Gi Nattak\x01 is using\x02 fire nova");

            local h = null;
            local list = [];
            while(null != (h = Entities.FindByClassname(h, "player")))
            {
                if(h == null)
                    continue;
                if(!h.IsValid())
                    continue;
                if(h.GetHealth() <= 0)
                    continue;
                if(h.GetTeam() != 3)
                    continue;

                list.push(h);
            }
            if(list.len() <= 0)
                return true;
            h = list[RandomInt(0, list.len() - 1)].GetOrigin();
            FireNova_Maker.SpawnEntityAtLocation(Vector(h.x, h.y , 276), Vector(0,0,0));
            return false;
        }
    }
    //FIRENOVA SPAM
    {
        FireNova_Spam_Interval_Timer <- 8; 
        FireNova_Spam_Interval_Limit <- [0.6,4];
        FireNova_Spam_Interval <- FireNova_Spam_Interval_Limit[1];
        FireNova_Spam_Interval_Timer = (FireNova_Spam_Interval_Limit[1] - FireNova_Spam_Interval_Limit[0]) / FireNova_Spam_Interval_Timer;
        function Cast_FireNova_Spam()
        {
            if(!ticking)
                return;
            
            if(Cast_FireNova())
                return;
            //printl("In : " + FireNova_Spam_Interval);
            EntFireByHandle(self, "RunScriptCode", "Cast_FireNova_Spam()", FireNova_Spam_Interval, null, null);

            if(FireNova_Spam_Interval - FireNova_Spam_Interval_Timer > FireNova_Spam_Interval_Limit[0])
                FireNova_Spam_Interval -= FireNova_Spam_Interval_Timer;
        }
    }
    //SUPERATTACK
    {
        Rock_array <- ["1","2","3","4","5"];
        function Cast_SuperAttack()
        {
            SetCDUse(15.0);

            ScriptPrintMessageChatAll(Scan_pref + "\x07Gi Nattak\x01 is using\x02 super attack");

            SetCastTimeByOneAttack = true;
            
            allow_superattack = false;
            cancast_superattack = false;

            EntFireByHandle(self, "RunScriptCode", "GetRockForSuperattack()", 0, null, null);
            EntFireByHandle(self, "RunScriptCode", "GetRockForSuperattack()", 0.1, null, null);

            EntFire("Gi_Nattak_Background_Fire", "Start", "", 0);
            EntFire("Gi_Nattak_Background_Fire", "Stop", "", 15);

            EntFire("Gi_Nattak_Superattack_Effect", "Start", "", 0);
            EntFire("Gi_Nattak_Superattack_Move", "Open", "", 0);
            EntFire("Gi_Nattak_Superattack_Hurt", "Enable", "", 0);

            EntFire("Gi_Nattak_Superattack_Hurt", "Kill", "", 14);
            EntFire("Gi_Nattak_Superattack_Effect", "Kill", "", 14);
            EntFire("Gi_Nattak_Superattack_Move_*", "Break", "", 15);
            EntFire("Gi_Nattak_Superattack_*", "Kill", "", 15.01);


            //EntFire(cmd Command say **GI NATTAK USES LAVA SUPERATTACK** 0);
            //EntFire(cmd Command say **Get on the rocks to get saved!!!** 1);
        }

        function GetRockForSuperattack()
        {
            local rock_random_index = RandomInt(0, Rock_array.len() - 1);

            EntFire("Gi_Nattak_Superattack_Move_"+Rock_array[rock_random_index], "Open", "", 0);

            Rock_array.remove(rock_random_index);
        }
    }
    //ULTIMA
    {
        SetCastTimeByOneAttack <- false;
        function Cast_Ultima()
        {
            if(!ticking)
                return;

            ScriptPrintMessageChatAll(Scan_pref + "\x07Gi Nattak\x01 is using\x02 ultima");

            SetCDUse(16.0);
            SetCastTimeByOneAttack = true;
            
            allow_ultima = false;
            cancast_ultima = false;

            EntFire("Gi_Nattak_Ultima_Fade", "Fade", "", 15);
            EntFire("Gi_Nattak_Ultima_Sound", "PlaySound", "", 15);
            EntFire("Map_Shake", "StartShake", "", 13);
            EntFire("Map_Shake", "StartShake", "", 8);
            EntFire("Map_Shake", "StartShake", "", 0);
            EntFire("Gi_Nattak_Ultima_Effect", "Start", "", 0);
            EntFireByHandle(self, "RunScriptCode", "Cast_Ultima_Next()", 15, null, null);
        }
        function Cast_Ultima_Next()
        {
            if(!ticking)
                return;
            local h = null;
            while(null != (h = Entities.FindByClassname(h, "player")))
            {
                if(h == null)
                    continue;
                if(!h.IsValid())
                    continue;
                if(h.GetHealth() <= 0)
                    continue;
                if(h.GetTeam() != 3)
                    continue;

                h.SetHealth(1);
            }
        }
    }
}
// ▞▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▚
//      Main
// ▚▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▞
{
    function Init()
    {
        EntFire("Camera_old", "RunScriptCode", "SetOverLay(Overlay)", 9.05);
        
        if(RandomInt(0,1))
            EntFire("Camera_old", "RunScriptCode", "SpawnCameras(Vector(-3575,4055,217),Vector(38.5,69,0),0,Vector(-3575,4055,217),Vector(38.5,69,0),3,1)", 9.05);
        else
            EntFire("Camera_old", "RunScriptCode", "SpawnCameras(Vector(-3014,6625,-1502),Vector(-18,263,3),0,Vector(-3014,6625,-1502),Vector(-18,263,3),3,1)", 9.05);
        
        EntFire("Camera_old", "RunScriptCode", "SpawnCameras(Vector(-2742,5132,580),Vector(0,180,0),0,Vector(-2742,5132,580),Vector(0,180,0),5,0)", 9.05 + 4.00);

        EntFire("Gi_Nattak_Smex", "PlaySound", "", 9.05 + 4.00);

        EntFire("Camera_old", "RunScriptCode", "SetOverLay()", 9.05 + 4.00 + 5);

        EntFire("Gi_Nattak_Move", "Open", "", 10.05);
        EntFire("Gi_Nattak_Effect", "FireUser1", "", 0);
        EntFire("Gi_Nattak_Dark_Push", "SetParent", "Gi_Nattak_Model", 0);
        EntFire("Gi_Nattak_Hurt", "SetParent", "Gi_Nattak_Model", 0);
        EntFire("Gi_Nattak_Nade", "SetParent", "Gi_Nattak_Model", 0);
        EntFire("Gi_Nattak_Phys", "SetParent", "Gi_Nattak_Nade", 0);
        EntFire("Gi_Nattak_HP_Bar", "SetParent", "Gi_Nattak_Model", 0);
        EntFire("Gi_Nattak_Silence_Effect", "SetParent", "Gi_Nattak_Model", 0);
        EntFire("Gi_Nattak_Heal_Effect", "SetParent", "Gi_Nattak_Model", 0);
        EntFire("Gi_Nattak_Wind_Effect", "SetParent", "Gi_Nattak_Model", 0);
        EntFire("Gi_Nattak_Appear", "SetParent", "Gi_Nattak_Model", 0);
        EntFire("Gi_Nattak_Shield_Effect", "SetParent", "Gi_Nattak_Model", 0);
        EntFire("Gi_Nattak_Dark_Effect", "SetParent", "Gi_Nattak_Model", 0);
        EntFire("Gi_Nattak_Rot1", "Open", "", 19);
        EntFire("GI_Nattak_Rot_Move", "Open", "", 19);
        EntFire("Credits_Game_Text", "AddOutput", "message Gi Nattak", 0);
       
        EntFire("Boss_Dicks_Move", "Close", "", 10);
        EntFire("Boss_Push", "Kill", "", 10);
        EntFire("Credits_Game_Text", "Display", "", 10);
       
        EntFire("Gi_Nattak_Appear", "Start", "", 10);
        EntFire("Gi_Nattak_Model", "FireUser1", "", 13);
        EntFire("Gi_Nattak_Nade_Explode", "SetParent", "Gi_Nattak_Model", 0);

        EntFire("Name_Texture", "AddOutPut", "target Gi_Nattak_Name_Bar", 0);
        EntFire("Name_Texture", "IncrementTextureIndex", "", 0);
        EntFire("Timer_Texture", "AddOutPut", "target Gi_Nattak_Timer_Bar", 0);
        EntFire("Special_HealthTexture", "AddOutPut", "target Gi_Nattak_HP_Bar", 0);

        Model = Entities.FindByName(null,"Gi_Nattak_Model");
        FireNova_Maker = Entities.FindByName(null, "Gi_Nattak_Nova_Maker");
        Shield_Maker = Entities.FindByName(null, "Gi_Nattak_Shield_Spawner");
        Shield_Rot = Entities.FindByName(null, "Gi_Nattak_Shield_Rotate");
        EntFireByHandle(Shield_Rot, "AddOutPut", "maxspeed " + (360.0 / Shield_FullRotate), 0.00, null, null);
        EntFireByHandle(Shield_Rot, "Start", "", 0.05, null, null);

        local item_target = Entities.FindByName(null, "map_item_beam_target");
        item_target.SetOrigin(Model.GetOrigin());
        EntFireByHandle(item_target, "SetParent", "!activator", 0, Model, Model);
    }

    function InitEnd()
    {
        EntFire("Gi_Nattak_HP_Bar", "ShowSprite", "", 0.01);
        EntFire("Gi_Nattak_Name_Bar", "ShowSprite", "", 0.01);
        EntFire("Gi_Nattak_Timer_Bar", "ShowSprite", "", 0.01);

        EntFire("Gi_Nattak_Background_Fire", "Start", "", 0);
        EntFire("Gi_Nattak_Model", "SetParent", "GI_Nattak_Rot1", 0.01);
        EntFire("Gi_Nattak_Model", "ClearParent", "", 0);

        SetPreset();
        EntFire("Gi_Nattak_Nade", "Enable", "", 0);
        EntFire("Gi_Nattak_Phys", "SetDamageFilter", "filter_humans", 0);

        Start();
    }

    function Start()
    {
        ticking = true;

        EntFireByHandle(self, "RunScriptCode", "Cast_FireNova_Spam()", 120, null, null);
        MainScript.GetScriptScope().Active_Boss = "NattakCave";

        Tick();
    }

    map_brush <- Entities.FindByName(null, "map_brush");

    function SetPreset()
    {
        local stage = map_brush.GetScriptScope().Stage;
        if(stage == 1)
        {
            minion_useDef = [18,21];
            minion_use = RandomInt(minion_useDef[0], minion_useDef[1]);

            Shield_Health = 25.0;
            SetHP(700);

            SetCDUse(15.0);
        }
        else if(stage == 2)
        {
            minion_useDef = [15,18];
            minion_use = RandomInt(minion_useDef[0], minion_useDef[1]);

            allow_gravity = true;
            allow_shield = true;

            Shield_Health = 50.0;
            SetHP(850);

            SetCDUse(13.0);
        }
        else if(stage == 4)
        {   
            minion_useDef = [12,15];
            minion_use = RandomInt(minion_useDef[0], minion_useDef[1]);

            allow_gravity = true;
            allow_shield = true;

            allow_fireNova = true;
            allow_superattack = true;

            Shield_Health = 75.0;
            SetHP(1100);

            SetCDUse(11.0);
        }
    }

    function Tick()
    {
        if(!ticking)
            return;

        TickUse();
        TickMinion();
        StanTick();

        UpDateCasttime();
        UpDateHP();
        UpDateStatus()

        ShowBossStatus();
        
        //DrawTriggers();

        EntFireByHandle(self, "RunScriptCode", "Tick()", tickrate, null, null);
    }

    function TickUse()
    {
        if(!cd_use_CAN)
            return;
        if(tickrate_use + tickrate >= cd_use)
        {
            tickrate_use = 0;
            //if(!smart_system)
                Use();
            //else
                //UseSmart();
            GetRandomAnimation();
        }
        else tickrate_use += tickrate;
    }

    use_array <- [];

    function Use()
    {
        if(use_array.len() <= 0)
        {
            if(allow_fire)
                cancast_fire = true;

            if(allow_heal)
                cancast_heal = true;

            if(allow_wind)
                cancast_wind = true;

            if(allow_silence)
                cancast_silence = true;

            if(allow_gravity)
                cancast_gravity = true;

            if(allow_shield)
                cancast_shield = true;

            if(allow_fireNova)
                cancast_fireNova = true;

            if(allow_superattack)
                cancast_superattack = true;

            if(allow_poison)
                cancast_poison = true;

            if(allow_ultima)
                cancast_ultima = true;
        }

        if(cancast_fire)
            use_array.push("Fire");
        if(cancast_heal)
            use_array.push("Heal");
        if(cancast_wind)
            use_array.push("Wind");
        if(cancast_silence)
            use_array.push("Silence");

        if(cancast_poison)
            use_array.push("Poison");

        if(cancast_ultima)
            use_array.push("Ultima");

        if(cancast_gravity)
            use_array.push("Gravity");

        if(cancast_shield)
            use_array.push("Shield");

        if(cancast_fireNova)
            use_array.push("FireNova");

        if(cancast_superattack)
            use_array.push("SuperAttack");

        local use_random_index = RandomInt(0, use_array.len() - 1);

        //ScriptPrintMessageChatAll("Use"+use_array[use_random_index]+"();");
        if(SetCastTimeByOneAttack)
        {
            SetCastTimeByOneAttack = false;
            local stage = map_brush.GetScriptScope().Stage;
            if(stage == 1)
                SetCDUse(15.0);
            else if(stage == 2)
                SetCDUse(13.0);
            else if(stage == 4)
                SetCDUse(11.0);

        }
        EntFireByHandle(self, "RunScriptCode", "Cast_"+use_array[use_random_index]+"();", 0, null, null);
        use_array.remove(use_random_index);
    }

    function UseSmart()
    {

    }

    function UpDateHP()
    {
        if(HP <= 0)
        {
            HP += HP_INIT;
            HP_BARS--;

            if(HP_BARS <= 16)
            {
                local id = 16 - HP_BARS;
                EntFire("Special_HealthTexture", "SetTextureIndex", "" + id, 0.00);
            }
        }
        if(HP_BARS <= 0)
        {
            ticking = false;
            ShowBossDeadStatus(); 

            BossDead();

            MainScript.GetScriptScope().Active_Boss = null;
            EntFire("map_brush", "RunScriptCode", "Trigger_Cave_After_Boss()", 0);
        }
    }

    function StanTick()
    {
        if(NadeTickRate > 0)
        {
            NadeTickRate -= tickrate;
            if(NadeTickRate <= 0)
            {
                if(Stanned)
                {
                    SetUnStanned();
                }
                    
                NadeCount = 0;
                NadeTickRate = 0;
            }
        }
    }

    function UpDateStatus()
    {
        if(!Stanned)
        {
            Status = "Casting";
        }
        else Status = "Stunned[dmg x" + StanDamage + "]";
    }

    function UpDateCasttime()
    {
        if(!ticking)
            return;

        local id;
        for(local a = 0; a <= 16; a++)
        {
            id = (a + 1) * cd_use_d;

            if(id >= tickrate_use)
            {
                EntFire("timer_texture", "SetTextureIndex", "" + (a-1), 0.00);
                break;
            }
        }
    }

    function ShowBossStatus()
    {
        if(!ticking)
            return;

        local message;

        message = "[Gi Nattak] : Status : " + Status + "\n";
        for(local i = 1; i <= HP_BARS; i++)
        {
            if(i <= 16)
                message += "◆";
            else
                message += "◈";
        }
        for(local i = HP_BARS; i < 16; i++)
        {
            message += "◇";
        }

        if(!Stanned)
        {
            if(NadeCount >= NadeShow)
            {
                local proccent = 0.0 + NadeCount;
                message += "\nStunStatus : " + ((proccent / NadeNeed) * 100) + "%";
            }
        }
        else
        {
            message += "\nStunTime : " + (NadeTickRate).tointeger(); 
        }
        
        ScriptPrintMessageCenterAll(message);
    }

    function ShowBossDeadStatus()
    {
        local message;
        message = "[Gi Nattak] : Status : Dead\n";

        for(local i = HP_BARS; i < 16; i++)
        {
            message += "◇";
        }

        ScriptPrintMessageCenterAll(message);
    }
    minion_useDef <- [2,4];
    minion_use <- RandomInt(minion_useDef[0], minion_useDef[1]);
    function TickMinion()
    {
        if(Stanned)
            return;
        if(tickrate_minion + tickrate >= minion_use)
        {
            minion_use = RandomInt(minion_useDef[0], minion_useDef[1]);
            tickrate_minion = 0;
            Cast_Minion();
        }
        else tickrate_minion += tickrate;
    }

    RightMinion <- true;
    LeftMinion <- true;
}
// ▞▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▚
//      Support Function 
// ▚▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▞
{
    Idle_Anim <- "idle";
    Attack1_Anim <- "attack1";
    Attack2_Anim <- "attack2";
    Attack3_Anim <- "attack3";

    function GetRandomAnimation()
    {
        switch (RandomInt(0,2))
        {
            case 0:
            {
                SetBossAnimation(Attack1_Anim);
                SetBossAnimation(Idle_Anim,3.3);
            }
            break;

            case 1:
            {
                SetBossAnimation(Attack2_Anim);
                SetBossAnimation(Idle_Anim,4.55);
            }
            break;

            case 2:
            {
                SetBossAnimation(Attack3_Anim);
                SetBossAnimation(Idle_Anim,5.25);
            }
            break;
        }
    }

    function SetBossAnimation(animationName,time = 0)EntFireByHandle(Model,"SetAnimation",animationName,time,null,null);

    function CountAlive(TEAM = 3)
    {
        local handle = null;
        local counter = 0;
        while(null != (handle = Entities.FindByClassname(handle,"player")))
        {
            if(handle.GetTeam() == TEAM && handle.GetHealth() > 0)
                counter++;
        }
        return counter;
    }

    function MidleHp(TEAM = 3)
    {
        local handle = null;
        local counter = 0;
        local hp = 0;
        while(null != (handle = Entities.FindByClassname(handle,"player")))
        {
            if(handle.GetTeam() == TEAM && handle.GetHealth() > 0)
            {
                hp += handle.GetHealth();
                counter++;
            }
        }
        return hp / counter;
    }

    function InArena(TEAM = 3)
    {
        local handle = null;
        local counter = 0;
        while (null != (handle = Entities.FindInSphere(handle , CenterArea, InArena_Radius)))
        {
            if(handle.GetTeam() == TEAM && handle.GetHealth() > 0)counter++;
        }
        return counter;
    }

    function OutArena(TEAM = 3)return CountAlive(TEAM) - InArena(TEAM);

    function NearBoss(TEAM = 3)
    {
        local handle = null;
        local counter = 0;
        while (null != (handle = Entities.FindInSphere(handle , Model.GetOrigin(), NearBoss_Radius)))
        {
            if(handle.GetTeam() == TEAM && handle.GetHealth() > 0)counter++;
        }
        return counter;
    }

    function DrawTriggers()
    {
        local ent = null;
        ent = Entities.FindByName(null, "Gi_Nattak_Phys");
        DrawBoundingBox(ent);
        // ent = Entities.FindByName(null, "Gi_Nattak_Nade");
        // DrawBoundingBox(ent);
        // ent = Entities.FindByName(null, "Gi_Nattak_Dark_Push");
        // DrawBoundingBox(ent);
    }

    function DrawBoundingBox(ent)
    {
        local origin = ent.GetOrigin();

        local max = ent.GetBoundingMaxs();
        local min = ent.GetBoundingMins();

        local rV = ent.GetLeftVector();
        local fV = ent.GetForwardVector();
        local uV = ent.GetUpVector();

        local TFR = origin + uV * max.z + rV * max.y + fV * max.x;
        local TFL = origin + uV * max.z + rV * min.y + fV * max.x;

        local TBR = origin + uV * max.z + rV * max.y + fV * min.x;
        local TBL = origin + uV * max.z + rV * min.y + fV * min.x;

        local BFR = origin + uV * min.z + rV * max.y + fV * max.x;
        local BFL = origin + uV * min.z + rV * min.y + fV * max.x;

        local BBR = origin + uV * min.z + rV * max.y + fV * min.x;
        local BBL = origin + uV * min.z + rV * min.y + fV * min.x;


        DebugDrawLine(TFR, TFL, 0, 0, 255, true, tickrate + 0.01);
        DebugDrawLine(TBR, TBL, 0, 0, 255, true, tickrate + 0.01);

        DebugDrawLine(TFR, TBR, 0, 0, 255, true, tickrate + 0.01);
        DebugDrawLine(TFL, TBL, 0, 0, 255, true, tickrate + 0.01);

        DebugDrawLine(TFR, BFR, 0, 0, 255, true, tickrate + 0.01);
        DebugDrawLine(TFL, BFL, 0, 0, 255, true, tickrate + 0.01);

        DebugDrawLine(TBR, BBR, 0, 0, 255, true, tickrate + 0.01);
        DebugDrawLine(TBL, BBL, 0, 0, 255, true, tickrate + 0.01);

        DebugDrawLine(BFR, BBR, 0, 0, 255, true, tickrate + 0.01);
        DebugDrawLine(BFL, BBL, 0, 0, 255, true, tickrate + 0.01);

        DebugDrawLine(BFR, BFL, 0, 0, 255, true, tickrate + 0.01);
        DebugDrawLine(BBR, BBL, 0, 0, 255, true, tickrate + 0.01);
    }
}