const TICKRATE_PICKUP = 0.2;
const TICKRATE = 0.01;
const TICKRATE_TEXT = 2.00;

g_iHP <- 200;
g_hOwner <- null;

g_bPickup <- false;
g_bTicking <- false;

g_hGameUI <- null;
g_hModel <- null;
g_hKnife <- self.GetMoveParent();
g_hHitBox <- self;

g_hFlame <- [];
g_hEye <- null;
g_hEyeParent <- null;

g_iDamage_Light <- 10;
g_iRadius_Light <- 128;

g_iDamage_Hard <- 30;
g_iRadius_Hard <- 156;

g_bAllow_Sprint <- true;

g_fAllowTime_Flame <- 15.0;
g_fAllowTime_Grab <- 5.0;
g_fAllowTime_Stomp <- 10.0;
g_fAllowTime_Sprint <- 15.0;

g_bSprint <- false;
g_aPlayers_Sprint <- [];
g_fTick_Sprint <- 0.0;
g_fTime_Sprint <- 1.7;
g_iGrab_Sprint <- 100.0;
g_fVelocity_Sprint <- 850.0;
g_vVelocity <- Vector(0, 0, 0);


g_bAllow_Flame <- true;
g_bFlame <- false;
g_fTick_Flame <- 0.0;
g_fTime_Flame <- 3.0;

g_bAllow_Grab <- true;


g_fVelocity_Grab <- 1200.0;
g_iRadius_Grab <- 50;
g_iDistance_Grab <- 48;
g_iHP_Grab <- 50;

g_bAllow_Stomp <- true;

g_fVelocity_Stomp <- 228.0;
g_iRadius_Stomp <- 512;
g_fRadiusFullDamage_Stomp <- 50;
g_fRadiusFullDamage_Stomp = g_iRadius_Stomp * 0.01 * g_fRadiusFullDamage_Stomp;

g_iDamage_Stomp <- 50;
g_fTime_Stomp <- 0.5;

g_key_A1 <- false;
g_key_A2 <- false;

g_key_W <- false;
g_key_S <- false;
g_key_A <- false;
g_key_D <- false;

INFO_TEXT <- "";
INFO_TEXT += "[W + RMB] - CHARGE\n";
INFO_TEXT += "[CTRL + S] - STOMP\n";
INFO_TEXT += "[CTRL + RMB] - THROWS A TARGET (IF HP OF THE TARGET EQUAL OR LESSER THAN 50 INSTA KILL)\n";
INFO_TEXT += "[RMB] - FLAME\n";
INFO_TEXT += "[LMB] - LIGHT ATTACK\n";
INFO_TEXT += "[HOLD LMB] - HARD ATTACK";

g_hText <- Entities.CreateByClassname("game_text");
g_hText.__KeyValueFromInt("spawnflags", 0);
g_hText.__KeyValueFromInt("channel", 3);
g_hText.__KeyValueFromInt("effect", 0);
g_hText.__KeyValueFromVector("color", Vector(255, 0, 0));
g_hText.__KeyValueFromVector("color2", Vector(193, 87, 0));
g_hText.__KeyValueFromFloat("y", 0.8);
g_hText.__KeyValueFromFloat("x", -1.0);
g_hText.__KeyValueFromFloat("fadein", 0.75);
g_hText.__KeyValueFromFloat("fadeout", 0.75);
g_hText.__KeyValueFromFloat("holdtime", 1.0);
g_hText.__KeyValueFromString("message", INFO_TEXT);
g_hText.__KeyValueFromString("targetname", "gargantua_text" + Time());


{
    function TickPickUp()
    {
        SearchOwner();

        if(g_bPickup)
        {
            return FindOwner();
        }

        EntFireByHandle(self, "RunScriptCode", "TickPickUp();", TICKRATE_PICKUP, null, null);
    }

    function SetHP(i)
    {
        local handle = null;
        while(null != (handle = Entities.FindByClassname(handle, "player")))
        {
            if(handle.IsValid())
            {
                if(handle.GetTeam() == 3 && handle.GetHealth() > 0)
                {
                    g_iHP += i;
                }
            }
        }
    }

    function Damage(i)
    {
        g_iHP -= i;
        if(g_iHP <= 0)
        {
            return Death();
        }
    }

    function Death()
    {
        g_bTicking = false;
        // EntFireByHandle(g_GargantuaLogic, "RunScriptCode", "End()", 0, g_hOwner, self);

        EntFireByHandle(g_hModel, "ClearParent", "", 0, null, null);
        SetAnimation(A_Death);
        ResetOwner();

        EntFireByHandle(g_hGameUI, "Deactivate", "", 0, g_hOwner, g_hOwner);
        EntFireByHandle(g_hGameUI, "Kill", "", 0.01, null, null);
        EntFireByHandle(g_hHitBox, "Kill", "", 0, null, null);
        EntFireByHandle(g_hFlame[0], "Kill", "", 0, null, null);
        EntFireByHandle(g_hFlame[1], "Kill", "", 0, null, null);
        EntFireByHandle(g_hEye, "Kill", "", 0, null, null);
        EntFireByHandle(g_hEyeParent, "Kill", "", 0, null, null);
        EntFireByHandle(g_hText, "Kill", "", 0, null, null);
        EntFireByHandle(g_hModel, "FadeAndKill", "", 5, null, null);

        if(g_aPlayers_Sprint.len() > 0)
        {
            for(local i = 0; i < g_aPlayers_Sprint.len(); i++)
            {
                EntFireByHandle(g_aPlayers_Sprint[i], "AddOutPut", "movetype 1", 0, null, null);
                EntFireByHandle(g_aPlayers_Sprint[i], "ClearParent", "", 0, null, null);
                EntFireByHandle(self, "RunScriptCode", "activator.SetOrigin(activator.GetOrigin() + Vector(0,0,15))", 0.05, g_aPlayers_Sprint[i], g_aPlayers_Sprint[i]);
                EntFireByHandle(self, "RunScriptCode", "activator.SetVelocity(Vector(g_vVelocity.x * g_fVelocity_Sprint, g_vVelocity.y * g_fVelocity_Sprint, 150))", 0.05, g_aPlayers_Sprint[i], g_aPlayers_Sprint[i]);
            }

            g_aPlayers_Sprint.clear();
        }
    }

    function SearchOwner()
    {
        local h = null;
        while(null != (h = Entities.FindInSphere(h, g_hKnife.GetOrigin(), 32)))
        {
            if(h.GetClassname() == "player" &&
            h.IsValid() &&
            h.GetHealth() > 0 &&
            h.GetTeam() == 2)
            {
                g_bPickup = true;
                g_hOwner = h;
                return;
            }
        }
        return;
    }

    function FindOwner()
    {
        DestroyOwnerKnife();
        SetOwner();
        ConnectGameUI();
        SetEyeParent();
        SetAnimSpawn();
        SetHP(200);

        // EntFireByHandle(g_GargantuaLogic, "RunScriptCode", "PickUp()", 0.8, g_hOwner, self);
    }

    function DestroyOwnerKnife()
    {
        local oldKnife = null;
        while((oldKnife = Entities.FindByClassname(oldKnife, "weapon_knife*")) != null)
        {
            if(oldKnife.GetOwner() == g_hOwner)
            {
                oldKnife.Destroy();
                break;
            }
        }
    }

    function SetEyeParent()
    {
        g_hEye.SetOrigin(g_hOwner.EyePosition())
        EntFireByHandle(g_hEye, "SetParent", "!activator", 0.01, g_hKnife, g_hKnife);
        EntFireByHandle(g_hEyeParent, "SetMeasureTarget", g_hOwner.GetName(), 0.01, null, null);
        EntFireByHandle(g_hEyeParent, "Enable", "", 0.02, g_hOwner, g_hOwner);
    }

    function SetOwner()
    {
        g_hOwner.__KeyValueFromString("targetname", "gargantua_owner" + Time());
        g_hOwner.__KeyValueFromInt("rendermode", 10);
        g_hOwner.__KeyValueFromFloat("gravity", 2.5);

        g_hOwner.SetHealth(80000);

        EntFireByHandle(g_hOwner, "SetDamageFilter", "No_Damage", 0, null, null);
    }

    function ResetOwner()
    {
        g_hOwner.__KeyValueFromString("targetname", "");
        g_hOwner.__KeyValueFromInt("rendermode", 0);
        g_hOwner.__KeyValueFromFloat("gravity", 1.0);

        EntFireByHandle(g_hOwner, "SetDamageFilter", "", 0, null, null);
        EntFireByHandle(g_hOwner, "SetHealth", "-1", 0, null, null);
    }

    function ConnectGameUI()
    {
        EntFireByHandle(g_hGameUI, "Activate", "", 0.05, g_hOwner, g_hOwner);
    }

    function Start()
    {
        local origin = g_hKnife.GetOrigin();
        local angles = g_hKnife.GetAngles();

        CreateModel(origin, angles);
        CreateEye();
        CreateGameUI();
        SetAnimIdle();
        SetParentParticle();

        EntFireByHandle(self, "RunScriptCode", "TickPickUp();", TICKRATE_PICKUP, null, null);
    }

    {
        function SetParentParticle()
        {
            local h = null;
            while(null != (h = Entities.FindInSphere(h, g_hHitBox.GetOrigin(), 64)))
            {
                if(h.GetClassname() == "info_particle_system" && h.GetMoveParent() == null)
                {
                    EntFireByHandle(h, "FireUser1", "", 0, g_hModel, g_hModel);
                    g_hFlame.push(h);
                }
            }
        }

        function CreateEye()
        {
            g_hEye = Entities.CreateByClassname("prop_dynamic")
            g_hEye.__KeyValueFromString("targetname", "gargantua_eye" + Time());
            g_hEye.__KeyValueFromInt("solid", 0);
            g_hEye.__KeyValueFromInt("rendermode", 10);
            self.PrecacheModel("models/editor/playerstart.mdl");
            g_hEye.SetModel("models/editor/playerstart.mdl");

            g_hEyeParent = Entities.CreateByClassname("logic_measure_movement");

            g_hEyeParent.__KeyValueFromInt("TargetScale", 100);
            g_hEyeParent.__KeyValueFromInt("MeasureType", 1);

            EntFireByHandle(g_hEyeParent, "SetTargetReference", g_hEye.GetName(), 0.02, null, null);
            EntFireByHandle(g_hEyeParent, "SetMeasureReference", g_hEye.GetName(), 0.02, null, null);
            EntFireByHandle(g_hEyeParent, "SetTarget", g_hEye.GetName(), 0.02, null, null);
        }


        function CreateGameUI()
        {
            g_hGameUI = Entities.CreateByClassname("game_ui");

            g_hGameUI.__KeyValueFromInt("spawnflags", 0);
            g_hGameUI.__KeyValueFromFloat("FieldOfView", -1.0);

            EntFireByHandle(g_hGameUI, "AddOutPut", "PressedAttack " + self.GetName() + ":RunScriptCode:Press_AT1():0:-1", 0.01, null, null);
            EntFireByHandle(g_hGameUI, "AddOutPut", "PressedAttack2 " + self.GetName() + ":RunScriptCode:Press_AT2():0:-1", 0.01, null, null);

            EntFireByHandle(g_hGameUI, "AddOutPut", "UnPressedAttack " + self.GetName() + ":RunScriptCode:UnPress_AT1():0:-1", 0.01, null, null);
            EntFireByHandle(g_hGameUI, "AddOutPut", "UnPressedAttack2 " + self.GetName() + ":RunScriptCode:UnPress_AT2():0:-1", 0.01, null, null);

            EntFireByHandle(g_hGameUI, "AddOutPut", "PressedForward " + self.GetName() + ":RunScriptCode:Press_W():0:-1", 0.01, null, null);
            EntFireByHandle(g_hGameUI, "AddOutPut", "PressedBack " + self.GetName() + ":RunScriptCode:Press_S():0:-1", 0.01, null, null);
            EntFireByHandle(g_hGameUI, "AddOutPut", "PressedMoveLeft " + self.GetName() + ":RunScriptCode:Press_A():0:-1", 0.01, null, null);
            EntFireByHandle(g_hGameUI, "AddOutPut", "PressedMoveRight " + self.GetName() + ":RunScriptCode:Press_D():0:-1", 0.01, null, null);

            EntFireByHandle(g_hGameUI, "AddOutPut", "UnPressedForward " + self.GetName() + ":RunScriptCode:UnPress_W():0:-1", 0.01, null, null);
            EntFireByHandle(g_hGameUI, "AddOutPut", "UnPressedBack " + self.GetName() + ":RunScriptCode:UnPress_S():0:-1", 0.01, null, null);
            EntFireByHandle(g_hGameUI, "AddOutPut", "UnPressedMoveLeft " + self.GetName() + ":RunScriptCode:UnPress_A():0:-1", 0.01, null, null);
            EntFireByHandle(g_hGameUI, "AddOutPut", "UnPressedMoveRight " + self.GetName() + ":RunScriptCode:UnPress_D():0:-1", 0.01, null, null);
        }

        function CreateModel(origin, angles)
        {
            g_hModel = Entities.CreateByClassname("prop_dynamic")
            g_hModel.__KeyValueFromInt("solid", 0);
            g_hModel.__KeyValueFromInt("rendermode", 1);
            //g_hModel.__KeyValueFromInt("renderamt", 50);
            self.PrecacheModel("models/editor/playerstart.mdl");
            g_hModel.SetModel("models/editor/playerstart.mdl");

            g_hModel.SetAngles(0, angles.y - 90, 0);
            local fix_Origin = g_hModel.GetBoundingMins();
            g_hModel.SetOrigin(origin + Vector(0, 0, fix_Origin));

            EntFireByHandle(g_hModel, "AddOutPut", "OnAnimationDone " + self.GetName() + ":RunScriptCode:OnAnimationComplite():0:-1", 0.01, null, null);

            EntFireByHandle(g_hModel, "SetParent", "!activator", 0.01, g_hKnife, g_hKnife);
            EntFireByHandle(g_hModel, "RunScriptFile", "kotya/npst/gargantua/gargantua.nut", 0.01, null, null);
        }
    }
}

{
    function Tick()
    {
        //Debug();
        // if(!ValidTarget(g_hOwner, 2))
        //     return Death();

        CheckForAttack();

        if(g_bSprint)
        {
            TickSprint();
        }
        else if(g_bFlame)
        {
            TickFlame();
        }

        SetAnimMovement();

        if(g_bTicking)
            EntFireByHandle(self, "RunScriptCode", "Tick();", TICKRATE, null, null);
    }

    function TickGameText()
    {
        EntFireByHandle(g_hText, "Display", "", 0, g_hOwner, g_hOwner);

        if(g_bTicking)
            EntFireByHandle(self, "RunScriptCode", "TickGameText();", TICKRATE_TEXT, null, null);
    }

    {
        function Debug()
        {
            local text = "Vecocity : ";
            text += g_hOwner.GetVelocity();

            ScriptPrintMessageCenterAll(text)
        }

        function TickFlame()
        {
            g_fTick_Flame += TICKRATE;

            if(g_fTick_Flame >= g_fTime_Flame)
            {
                g_bFlame = false;
                g_fTick_Flame = 0;

                UnFreeze();
                Anim_now = "";

                for(local i = 0; i < g_hFlame.len(); i++)
                    EntFireByHandle(g_hFlame[i], "Stop", "", 0, null, null);

                return;
            }

            DebugDrawCircle(g_hHitBox.GetOrigin() + g_hHitBox.GetForwardVector() * 250, Vector(255,255,255), 256, 36, true, 0.2)

            local h = null;
            while(null != (h = Entities.FindInSphere(h, g_hOwner.GetOrigin() + g_hHitBox.GetForwardVector() * 250, 256)))
            {
                if(h.GetClassname() == "player" &&
                h.IsValid() &&
                h.GetHealth() > 0 &&
                h.GetTeam() == 3)
                {
                    //h.SetOrigin(g_hOwner.GetOrigin() + g_vVelocity * 75);
                    EntFireByHandle(h, "IgniteLifeTime", "1.0", 0, null, null);
                }
            }
        }

        function TickSprint()
        {
            if(CheckWall())
            {
                g_bSprint = false;
                g_hOwner.SetVelocity(Vector(0, 0, 0));
                g_fTick_Sprint = 0;

                Freeze();


                SetAnimation(A_Charge_Wall_Attack);
                for(local i = 0; i < g_aPlayers_Sprint.len(); i++)
                    EntFireByHandle(g_aPlayers_Sprint[i], "SetHealth", "-1", 0.1, null, null);
                g_aPlayers_Sprint.clear();
                return;
            }

            g_fTick_Sprint += TICKRATE;

            if(g_fTick_Sprint >= g_fTime_Sprint)
            {
                g_bSprint = false;
                g_hOwner.SetVelocity(Vector(0, 0, 0));

                g_fTick_Sprint = 0;

                for(local i = 0; i < g_aPlayers_Sprint.len(); i++)
                {
                    EntFireByHandle(g_aPlayers_Sprint[i], "AddOutPut", "movetype 1", 0, null, null);
                    EntFireByHandle(g_aPlayers_Sprint[i], "ClearParent", "", 0, null, null);
                    EntFireByHandle(self, "RunScriptCode", "activator.SetOrigin(activator.GetOrigin() + Vector(0,0,15))", 0.05, g_aPlayers_Sprint[i], g_aPlayers_Sprint[i]);
                    EntFireByHandle(self, "RunScriptCode", "activator.SetVelocity(Vector(g_vVelocity.x * g_fVelocity_Sprint, g_vVelocity.y * g_fVelocity_Sprint, 150))", 0.05, g_aPlayers_Sprint[i], g_aPlayers_Sprint[i]);
                }
                g_aPlayers_Sprint.clear();

                OnAnimationComplite();
            }
            else
            {
                local h = null;
                while(null != (h = Entities.FindInSphere(h, g_hOwner.GetOrigin() + g_vVelocity * 20, g_iGrab_Sprint)))
                {
                    if(h.GetClassname() == "player" &&
                    h.IsValid() &&
                    h.GetHealth() > 0 &&
                    h.GetTeam() == 3)
                    {
                        if(!CheckSprintArray(h))
                        {
                            //h.SetOrigin(g_hOwner.GetOrigin() + g_vVelocity * 75);
                            h.__KeyValueFromInt("movetype", 7);
                            EntFireByHandle(h, "SetParent", "!activator", 0, g_hModel, g_hModel);
                            g_aPlayers_Sprint.push(h);
                        }
                    }
                }

                local z = self.GetVelocity().z;
                z = (!CheckFloor()) ? -500 : (z == 0) ? 400 : 0;

                g_hOwner.SetVelocity(Vector(
                    g_vVelocity.x * g_fVelocity_Sprint,
                    g_vVelocity.y * g_fVelocity_Sprint,
                    z));
            }


        }

        function CheckSprintArray(HANDLE)
        {
            for(local i = 0; i < g_aPlayers_Sprint.len(); i++)
                if(g_aPlayers_Sprint[i] == HANDLE)
                    return true;
            return false;

        }

        {
            function CheckWall()
            {
                if(TraceLine(g_hOwner.GetOrigin() + Vector(0,0,45), g_hOwner.GetOrigin() + Vector(0,0,45) + g_vVelocity * 200, g_hHitBox) != 1.00)
                    return true;
                return false;
            }

            function CheckFloor()
            {
                if(TraceLine(g_hOwner.GetOrigin(), g_hOwner.GetOrigin() + Vector(0,0,-20), g_hHitBox) != 1.00)
                    return true;
                return false;
            }
        }


        function CheckForAttack()
        {
            if(Anim_now != "Casting")
            {
                if(CheckCTRL())
                {
                    if(g_key_S)
                        Cast_Stomp();
                    else if(g_key_A2)
                        Cast_Grab();
                }
                else
                {
                    if(CheckSprint())
                        Cast_Sprint();
                    else if(g_key_A2)
                    {
                        Cast_Flame();
                    }
                    else if(g_key_A1)
                    {
                        EntFireByHandle(self, "RunScriptCode", "CheckLightOrHard();", 0.08, null, null);
                    }
                }
            }
        }

        {
            function CheckLightOrHard()
            {
                if(Anim_now == "Casting")
                    return;

                if(g_key_A1)
                    Cast_Hard();
                else
                    Cast_Light();
            }

            function CheckCTRL()
            {
                if(g_hOwner.GetBoundingMaxs().z <= 54)
                    return true;
                return false;
            }

            function CheckSprint()
            {
                if(g_key_A2 && g_key_W)
                    return true;
                return false;
            }
        }


        function SetAnimMovement()
        {
            if(Anim_now != "Casting")
            {
                if(g_key_W || g_key_S || g_key_D || g_key_A)
                    SetAnimWalk();
                else
                    SetAnimIdle();
            }
        }
    }

    function Press_AT1()
    {
        g_key_A1 = true;
    }

    function UnPress_AT1()
    {
        g_key_A1 = false;
    }

    function Press_AT2()
    {
        g_key_A2 = true;
    }
    function UnPress_AT2()
    {
        g_key_A2 = false;
    }


    function Press_W()
    {
        g_key_W = true;
    }
    function UnPress_W()
    {
        g_key_W = false;
    }

    function Press_S()
    {
        g_key_S = true;
    }
    function UnPress_S()
    {
        g_key_S = false;
    }

    function Press_A()
    {
       g_key_A = true;
    }
    function UnPress_A()
    {
        g_key_A = false;
    }

    function Press_D()
    {
        g_key_D = true;
    }
    function UnPress_D()
    {
        g_key_D = false;
    }
}

{
    function OnAnimationComplite()
    {
        if(Anim_now == A_Take)
        {
            UnFreeze();

            g_bTicking = true;
            EntFireByHandle(g_hHitBox, "SetDamageFilter", "", 0, null, null);
            Tick();

            EntFireByHandle(self, "RunScriptCode", "TickGameText();", 12.00, null, null);

            Anim_now = "";
        }

        else if(g_bSprint || g_bFlame)
        {

        }

        else if(Anim_now == "Casting")
        {
            UnFreeze();
            Anim_now = "";
        }

    }

    function Cast_Light()
    {
        Anim_now = "Casting";

        Freeze();

        SetAnimation(A_Lite_Attack);
        g_key_A1 = false;
        EntFireByHandle(self, "RunScriptCode", "Cast_LightNext();", 0.5, null, null);
    }

    function Cast_Hard()
    {
        Anim_now = "Casting";

        Freeze();

        SetAnimation(A_Hard_Attack);
        g_key_A1 = false;
        EntFireByHandle(self, "RunScriptCode", "Cast_HardNext();", 0.5, null, null);
    }

    function Cast_LightNext()
    {
        local h = null;
        DebugDrawCircle(g_hOwner.GetOrigin() + g_hHitBox.GetForwardVector() * 75, Vector(255,255,255), 256, g_iRadius_Light, true, 0.2)
        while(null != (h = Entities.FindInSphere(h, g_hOwner.GetOrigin() + g_hHitBox.GetForwardVector() * 75, g_iRadius_Light)))
        {
            if(h.GetClassname() == "player" &&
            h.IsValid() &&
            h.GetHealth() > 0 &&
            h.GetTeam() == 3)
            {
                local hp = h.GetHealth();
                hp -= g_iDamage_Light;
                if(hp <= 0)
                {
                    EntFireByHandle(h, "SetHealth", "-1", 0, null, null);
                }
                else
                    h.SetHealth(hp);
            }
        }
    }

    function Cast_HardNext()
    {
        local h = null;
        DebugDrawCircle(g_hOwner.GetOrigin() + g_hHitBox.GetForwardVector() * 75, Vector(255,255,255), 256, g_iRadius_Hard, true, 0.2)
        while(null != (h = Entities.FindInSphere(h, g_hOwner.GetOrigin() + g_hHitBox.GetForwardVector() * 75, g_iRadius_Hard)))
        {
            if(h.GetClassname() == "player" &&
            h.IsValid() &&
            h.GetHealth() > 0 &&
            h.GetTeam() == 3)
            {
                local hp = h.GetHealth();
                hp -= g_iDamage_Hard;
                if(hp <= 0)
                {
                    EntFireByHandle(h, "SetHealth", "-1", 0, null, null);
                }
                else
                    h.SetHealth(hp);
            }
        }
    }

    function Cast_Grab()
    {
        //Anim_now = "Casting";

        local h = null;
        while(null != (h = Entities.FindInSphere(h, GetEyeDist(g_iDistance_Grab), g_iRadius_Grab)))
        {
            if(h.GetClassname() == "player" &&
            h.IsValid() &&
            h.GetHealth() > 0 &&
            h.GetTeam() == 3)
            {
                return Cast_GrabNext(h);
            }
        }
        return;
    }

    function GetEyeDist(distance)
    {
        return TraceDir(g_hEye.GetOrigin(), g_hEye.GetForwardVector(), distance, g_hHitBox);
    }

    function Cast_GrabNext(handle)
    {
        if(!g_bAllow_Grab)
            return;
        else
        {
            EntFireByHandle(self, "RunScriptCode", "g_bAllow_Grab = true;", g_fAllowTime_Grab, null, null);
            g_bAllow_Grab = false;
        }

        Anim_now = "Casting";
        Freeze();

        if(handle.GetHealth() > g_iHP_Grab)
        {
            SetAnimation(A_Drop_Attack);

            EntFireByHandle(handle, "SetParent", "!activator", 0.2, g_hModel, g_hModel);
            EntFireByHandle(handle, "SetParentAttachment", "2", 0.21, g_hModel, g_hModel);

            EntFireByHandle(handle, "ClearParent", "", 0.95, null, null);
            EntFireByHandle(handle, "AddOutPut", "movetype 1", 0.95, null, null);

            EntFireByHandle(self, "RunScriptCode", "Cast_GrabAfter();", 1.00, handle, handle);
        }
        else
        {
            SetAnimation(A_OneShoot_Attack);

            EntFireByHandle(handle, "AddOutPut", "movetype 7", 0, null, null);

            EntFireByHandle(handle, "SetParent", "!activator", 0.2, g_hModel, g_hModel);
            EntFireByHandle(handle, "SetParentAttachment", "2", 0.21, g_hModel, g_hModel);

            EntFireByHandle(handle, "SetHealth", "-1", 2.2, g_hModel, g_hModel);
        }
    }

    function Cast_GrabAfter()
    {
        if(activator == null || !activator.IsValid())
            return;
        local First_Pos = activator.GetOrigin();
        local Second_Pos = GetEyeDist(1200);

        DrawAxis(First_Pos);
        DrawAxis(Second_Pos);

        local nevVec = (Second_Pos - First_Pos)
        nevVec.Norm();

        activator.SetVelocity(Vector(
            nevVec.x * g_fVelocity_Grab,
            nevVec.y * g_fVelocity_Grab,
            nevVec.z * g_fVelocity_Grab));
    }

    function Cast_Sprint()
    {
        if(!g_bAllow_Sprint)
            return;
        else
        {
            EntFireByHandle(self, "RunScriptCode", "g_bAllow_Sprint = true;", g_fAllowTime_Sprint, null, null);
            g_bAllow_Sprint = false;
        }

        Anim_now = "Casting";
        g_bSprint = true;

        local First_Pos = g_hOwner.GetOrigin();
        local Second_Pos = g_hOwner.GetOrigin() + g_hHitBox.GetForwardVector() * 700;
        g_vVelocity = (Second_Pos - First_Pos)
        g_vVelocity.Norm();

        SetAnimation(A_Charge_Attack);
        SetDefaultAnimation(A_Charge_Attack);
    }

    function Camera()
    {
        g_bSprint = true;

        EntFireByHandle(self, "RunScriptCode", "g_fVelocity_Sprint = " + g_fVelocity_Sprint + "; g_fTime_Sprint = " + g_fTime_Sprint, 3.0, null, null);
        g_fTime_Sprint = 3.0;
        g_fVelocity_Sprint = 350.0;

        local First_Pos = g_hOwner.GetOrigin();
        local Second_Pos = g_hOwner.GetOrigin() + g_hHitBox.GetForwardVector() * 700;
        g_vVelocity = (Second_Pos - First_Pos)
        g_vVelocity.Norm();

        SetAnimWalk();
        Anim_now = "Casting";

        EntFireByHandle(self, "RunScriptCode", ";SetAnimIdle(true);", 3.1, null, null);
    }

    function Cast_Flame()
    {
        if(!g_bAllow_Flame)
            return;
        else
        {
            EntFireByHandle(self, "RunScriptCode", "g_bAllow_Flame = true;", g_fAllowTime_Flame, null, null);
            g_bAllow_Flame = false;
        }

        Anim_now = "Casting";
        g_bFlame = true;

        for(local i = 0; i < g_hFlame.len(); i++)
            EntFireByHandle(g_hFlame[i], "Start", "", 0.05, null, null);

        Freeze();
        SetAnimation(A_Flame_Attack);
        SetDefaultAnimation(A_Flame_Attack_LOOP);
        g_key_A2 = false;
    }

    function Cast_Stomp()
    {
        if(!g_bAllow_Stomp)
            return;
        else
        {
            EntFireByHandle(self, "RunScriptCode", "g_bAllow_Stomp = true;", g_fAllowTime_Stomp, null, null);
            g_bAllow_Stomp = false;
        }

        Anim_now = "Casting";
        Freeze();
        SetAnimation(A_Stomp_Attack);

        EntFireByHandle(self, "RunScriptCode", "Cast_StompNext();", 1.20, null, null);
    }

    function Cast_StompNext()
    {
        local h = null;
        while(null != (h = Entities.FindInSphere(h, g_hOwner.GetOrigin(), g_iRadius_Stomp)))
        {
            if(h.GetClassname() == "player" &&
            h.IsValid() &&
            h.GetHealth() > 0 &&
            h.GetTeam() == 3)
            {
                Cast_StompDamage(h);
            }
        }
    }

    function Cast_StompDamage(activator)
    {
        local First_Pos = activator.GetOrigin();
        local Second_Pos = g_hOwner.GetOrigin();

        local nevVec = (First_Pos - Second_Pos)
        nevVec.Norm();

        local hp = activator.GetHealth();
        local distance = GetDistance3D(First_Pos, Second_Pos)

        hp -= ((distance <= g_fRadiusFullDamage_Stomp) ?
        (g_iDamage_Stomp) :
        (g_iDamage_Stomp - (g_iDamage_Stomp * (g_fRadiusFullDamage_Stomp / distance)))
        );

        if(hp <= 0)
        {
            EntFireByHandle(activator, "SetHealth", "-1", 0, g_hModel, g_hModel);
            return;
        }
        else
            activator.SetHealth(hp);

        EntFireByHandle(activator, "AddOutPut", "movetype 7", 1, null, null);
        EntFireByHandle(activator, "AddOutPut", "movetype 1", 1 + g_fTime_Stomp, null, null);

        activator.SetVelocity(Vector(
            nevVec.x * g_fVelocity_Stomp,
            nevVec.y * g_fVelocity_Stomp,
            320));
    }

    function SetAnimIdle(id = false)
    {
        if(Anim_now != "idle")
        {
            if(id)
            {
                SetAnimation(A_Idle2);
                SetDefaultAnimation(A_Idle2);
            }
            else
            {
                local random1 = RandomInt(0, 3);
                local random2 = RandomInt(0, 3);
                SetAnimation(A_Idle_Array[random1]);
                SetDefaultAnimation(A_Idle_Array[random2]);
            }
        }
        Anim_now = "idle";
    }
    function SetAnimWalk()
    {
        if(Anim_now != A_Walk)
        {
            SetAnimation(A_Walk);
            SetDefaultAnimation(A_Walk);
        }
        Anim_now = A_Walk;
    }
    function SetAnimSpawn()
    {
        //Freeze();
        SetAnimation(A_Take);
        Anim_now = A_Take;
    }
}

function DrawAxis(pos,s = 16,nocull = true,time = 4)
{
	DebugDrawLine(Vector(pos.x-s,pos.y,pos.z), Vector(pos.x+s,pos.y,pos.z), 255, 0, 0, nocull, time);
	DebugDrawLine(Vector(pos.x,pos.y-s,pos.z), Vector(pos.x,pos.y+s,pos.z), 0, 255, 0, nocull, time);
	DebugDrawLine(Vector(pos.x,pos.y,pos.z-s), Vector(pos.x,pos.y,pos.z+s), 0, 0, 255, nocull, time);
}

function TraceDir(orig, dir, maxd, filter)
{
    local frac = TraceLine(orig,orig+dir*maxd,filter);
    if(frac == 1.0)
    {
        //eye_distance = 0.00;
        return orig + dir * maxd;
    }
    //eye_distance = maxd * frac;
    return orig + (dir * (maxd * frac));
}

function OnPostSpawn()
{
    Start();
}

A_Flame_Attack  <- "shootflames1";
A_Flame_Attack_LOOP <- "shootflames2";

A_Charge_Attack <- "run";
A_Charge_Wall_Attack <- "flinchheavy";

A_Lite_Attack <- "smash";
A_Hard_Attack <- "attack";
A_Stomp_Attack <- "stomp";

A_OneShoot_Attack <- "bitehead";
A_Drop_Attack <- "throwbody";

A_Stun <- "flicnhheavy";
A_Death <- "die";
A_Walk <- "walk";
A_Take <- "bust";

A_Idle1 <- "idle1";
A_Idle2 <- "idle2";
A_Idle3 <- "idle3";
A_Idle4 <- "idle4";
A_Idle_Array <- [A_Idle1, A_Idle2, A_Idle3, A_Idle4];

Anim_now <- "";
Anim_default <- "";

function GetDistance3D(v1,v2)return sqrt((v1.x-v2.x)*(v1.x-v2.x)+(v1.y-v2.y)*(v1.y-v2.y)+(v1.z-v2.z)*(v1.z-v2.z));

function SetAnimation(animationName,time = 0)
{
    EntFireByHandle(g_hModel, "SetAnimation", animationName, time, null, null);
}

function SetDefaultAnimation(animationName,time = 0)
{
    EntFireByHandle(g_hModel, "SetDefaultAnimation", animationName, time, null, null);
}

function Freeze()
{
   g_hOwner.__KeyValueFromInt("movetype", 7);
}

function UnFreeze()
{
   g_hOwner.__KeyValueFromInt("movetype", 1);
}

function DebugDrawCircle(Vector_Center, Vector_RGB, radius, parts, zTest, duration) //0 -32 80
{
    local u = 0.0;
    local vec_end = [];
    local parts_l = parts;
    local radius = radius;
    local a = PI / parts * 2;
    while(parts_l > 0)
    {
        local vec = Vector(Vector_Center.x+cos(u)*radius, Vector_Center.y+sin(u)*radius, Vector_Center.z);
        vec_end.push(vec);
        u += a;
        parts_l--;
    }
    for(local i = 0; i < vec_end.len(); i++)
    {
        if(i < vec_end.len()-1){DebugDrawLine(vec_end[i], vec_end[i+1], Vector_RGB.x, Vector_RGB.y, Vector_RGB.z, zTest, duration);}
        else{DebugDrawLine(vec_end[i], vec_end[0], Vector_RGB.x, Vector_RGB.y, Vector_RGB.z, zTest, duration);}
    }
}
/*shootflames1 - начинает огнемет
shootflames2 - продолжение (зацикленная)

run - спринт + пуш + дамаг

stomp - стан + маленький дамаг

attack - зажалите лкм и большой дамаг
smash - быстрое нажатие лкм и маленький дамаг

bitehead - ваншот атака

flicnhheavy - стан от самолетов
die - умер от выстрела в жопу

+walk - ходьба
+bust - подбор

+лкм - attack
+лкм зажат - smash

+вперед + пкм - спринт
+ctrl + назад - stomp
+ctrl + пкм - ваншот атака
+ctrl + лкм - flame
*/