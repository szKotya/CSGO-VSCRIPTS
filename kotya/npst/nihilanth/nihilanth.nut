g_bTicking <- false;
g_bAfter_Attack <- false;
g_bTickingGravity <- false;
g_iPhase <- 0;
::g_hTarget <- null;
g_fTimer_Retarget <- 0.00;
g_hModel <- null;
g_bCan_Tele <- true;
g_bCan_Beam <- true;
g_bCan_FinalFlash <- true;
g_fTimer_Crystal <- 0.00;
g_bCanDamage_Crystal <- false;
g_fTimer_Attack <- 0.00;
g_avPos_Laser <- [];
g_avPos_Shield <- [];
g_avOrigins_Tele <- [];
g_avOrigins_SunStike <- [];
::IgnoreID_Nihilanth <- [];
::g_vOrigin_Nihilanth <- Vector(-11144.5, 10126, -395)
g_avOrigins_Heal <- [
(g_vOrigin_Nihilanth + Vector(400, -5000, -817)),
(g_vOrigin_Nihilanth + Vector(-200, 4329, -823)),
]

g_avPos_Stick <- [
    class_pos((g_vOrigin_Nihilanth - Vector(5, 206, 782)), Vector(0, 0, 40)),
    class_pos((g_vOrigin_Nihilanth - Vector(5, -331, 782)), Vector(0, 185, 36)),
    class_pos((g_vOrigin_Nihilanth - Vector(-253, -63, 782)), Vector(0, 90, 40)),
    class_pos((g_vOrigin_Nihilanth - Vector(283, -61, 782)), Vector(0, 275, 36)),
];
 
g_avPos_AttackRock <- [
    class_pos((g_vOrigin_Nihilanth - Vector(11.5, 0, 896)), Vector(0, 146, 0)),
    class_pos((g_vOrigin_Nihilanth - Vector(11.5, 0, 896)), Vector(0, 236, 0)),
    class_pos((g_vOrigin_Nihilanth - Vector(11.5, 0, 896)), Vector(0, 326, 0)),
    class_pos((g_vOrigin_Nihilanth - Vector(23.7, -62.8 896)), Vector(0, 56, 0)),
];

g_avOrigins_StickGlow <- [
    (g_vOrigin_Nihilanth - Vector(-458, -64, 544)),
    (g_vOrigin_Nihilanth - Vector(5, 410, 544)),
    (g_vOrigin_Nihilanth - Vector(469, -44, 531)),
    (g_vOrigin_Nihilanth - Vector(22, -517, 530)),
];


g_vOrigin_HBoxMain <- (g_vOrigin_Nihilanth - Vector(3, 3, 401));
g_vOrigin_ShockWave <- (g_vOrigin_Nihilanth - Vector(57, -4, -294));
g_vOrigin_LaserPre <- (g_vOrigin_Nihilanth - Vector(0, 0, 1215));

g_vPos_FlyingRocks <- class_pos((g_vOrigin_Nihilanth - Vector(267, -320, 242)), Vector(0, 270, 0));

g_avOrigins_Cloud <- [
    (g_vOrigin_Nihilanth - Vector(-7, -51, 718)),
    (g_vOrigin_Nihilanth - Vector(-7, 77, 718)),
    (g_vOrigin_Nihilanth - Vector(75, -448, 718)),
    (g_vOrigin_Nihilanth - Vector(11, 0, 672)),
]

::g_aszModelName_Cloud <- [
    Cloud01_Model,
    Cloud02_Model,
    Cloud03_Model,
    Cloud04_Model,
]

::g_aszModelName_FlyingRocks <- [
    FlyingRock01_Model,
    FlyingRock02_Model,
    FlyingRock03_Model,
    FlyingRock04_Model,
    FlyingRock05_Model,
    FlyingRock06_Model,
]

g_avPos_StartRocks <- [
    class_pos((g_vOrigin_Nihilanth - Vector(1839, 2435, 835)), Vector(0, 0, 0)),
    class_pos((g_vOrigin_Nihilanth - Vector(715, 3429, 797)), Vector(0, 0, 0)),
    class_pos((g_vOrigin_Nihilanth - Vector(2783, 973, 770)), Vector(0, 0, 0)),
    class_pos((g_vOrigin_Nihilanth - Vector(1406, 1118, 896)), Vector(0, 0, 0)),
    class_pos((g_vOrigin_Nihilanth - Vector(1495, 685, 935)), Vector(0, 216, 0)),
    class_pos((g_vOrigin_Nihilanth - Vector(1526, 51, 687)), Vector(0, 0, 0)),
    class_pos((g_vOrigin_Nihilanth - Vector(-553, 2723, 721)), Vector(0, 0, 0)),
    class_pos((g_vOrigin_Nihilanth - Vector(-1939, 2276, 699)), Vector(0, 0, 0)),
    class_pos((g_vOrigin_Nihilanth - Vector(-2500, 1096, 884)), Vector(0, 0, 0)),
    class_pos((g_vOrigin_Nihilanth - Vector(-1485, 83, 729)), Vector(0, 0, 0)),
    class_pos((g_vOrigin_Nihilanth - Vector(-2558, -686, 709)), Vector(0, 0, 0)),
    class_pos((g_vOrigin_Nihilanth - Vector(-1561, -2195, 847)), Vector(0, 0, 0)),
    class_pos((g_vOrigin_Nihilanth - Vector(-1207, -1113, 810)), Vector(0, 0, 0)),
    class_pos((g_vOrigin_Nihilanth - Vector(-414, -1759, 685)), Vector(0, 0, 0)),
    class_pos((g_vOrigin_Nihilanth - Vector(0, -2712, 818)), Vector(0, 0, 0)),
    class_pos((g_vOrigin_Nihilanth - Vector(256, -1574, 923)), Vector(0, 180, 0)),
    class_pos((g_vOrigin_Nihilanth - Vector(1579, -2313, 812)), Vector(0, 0, 0)),
    class_pos((g_vOrigin_Nihilanth - Vector(277, 1253, 706)), Vector(0, 0, 0)),
    class_pos((g_vOrigin_Nihilanth - Vector(-529, 1342, 956)), Vector(0, 98, 0)),
    class_pos((g_vOrigin_Nihilanth - Vector(-1089, 1334, 900)), Vector(0, 0, 0)),
    class_pos((g_vOrigin_Nihilanth - Vector(876, -1704, 923)), Vector(0, 0, 0)),
    class_pos((g_vOrigin_Nihilanth - Vector(2560, -812, 896)), Vector(0, 0, 0)),
    class_pos((g_vOrigin_Nihilanth - Vector(1627, 3348, 720)), Vector(0, 0, 0)),
    class_pos((g_vOrigin_Nihilanth - Vector(1343, -949, 737)), Vector(0, 0, 0)),
];
::g_aszModelName_StartRocks <- [
    Rock01_Model,
    Rock02_Model,
    Rock03_Model,
    Rock21_Model,
    Rock04_Model,
    Rock05_Model,
    Rock06_Model,
    Rock07_Model,
    Rock08_Model,
    Rock09_Model,
    Rock10_Model,
    Rock11_Model,
    Rock12_Model,
    Rock13_Model,
    Rock14_Model,
    Rock21_Model,
    Rock15_Model,
    Rock16_Model,
    Rock17_Model,
    Rock04_Model,
    Rock17_Model,
    Rock18_Model,
    Rock19_Model,
    Rock20_Model,
];

g_bStatus_Glow <- true;

g_avOrigins_CrystalHeal <- [
    (g_vOrigin_Nihilanth + Vector(1390, 461, -913)),
    (g_vOrigin_Nihilanth + Vector(-1169, -442, -906)),
    (g_vOrigin_Nihilanth + Vector(-578, 1174, -903)),
];

g_bCan_Attacks <- false;

g_btick_Beam <- false;
g_bTakeDamage <- false;
g_iHP <- 0;

g_iHPAdd_Phase2 <- 0;
g_iHPBack_Phase2 <- 0;
g_iHPrestore_Phase2 <- 0;
g_aiHP_CrystalHeal <- [];

g_ahModel_CrystalHeal <- [];
g_hShields <- [];
g_iHealth_Shields <- [];
g_hFade_Heal <- Entities.CreateByClassname("env_fade");

g_bCan_Wall <- false;
g_fTimer_Wall <- 0.0;
g_fTime_Wall <- 0.0;

g_bCan_MasSunStrike <- false;
g_fTimer_MasSunStrike <- 0.0;
g_fTime_MasSunStrike <- 0.0;

g_bCan_Shield <- false;
g_fTimer_Shield <- 0.0;
g_fTime_Shield <- 0.0;

g_bCan_Laser <- false;
g_fTimer_Laser <- 0.0;
g_fTime_Laser <- 0.0;

/*Settings*/
// vector(-9754, 10587, -1308)vector(0, 0, 0)
// vector(-12313, 9684, -1301)vector(0, 0, 0)
// vector(-11722, 11300, -1298)vector(0, 0, 0)
const TICKRATE_HEAL = 1.0;
const TICKRATE_HEAL_HUMAN = 0.5;
const TICKRATE = 0.15;
const TICKRATE_MOVE = 0.01;
const TICKRATE_GRAVITY = 0.1;
const TICKRATE_PHASE3_GRAVITY = 0.1;
const TICKRATE_BEAM = 0.05
const TICKRATE_BEAMMOVE = 0.01;
const TICKRATE_ATTACKS = 1.0;

g_iPerTick_Heal <- 1;
g_iMax_Heal <- 100;
g_iRadius_Heal <- 180;

g_fCD_Attack <- 3.0;

g_aiCD_MasSunStrike <- [10, 30];
g_aiCD_Wall <- [15, 25];
g_aiCD_Shield <- [25, 40];
g_aiCD_Laser <- [15, 30];

g_aiCD_Phase4_MasSunStrike <- [6, 9];
g_aiCD_Phase4_Laser <- [11, 15];

g_fCD_Tele <- 20.0;
g_fCD_Beam <- 15.0;
g_fCD_FinalFlash <- 25.0;

g_iDamage_SunStrike1 <- 15;
g_iRadius_SunStrike1 <- 128;

g_iDamage_SunStrike3 <- 30;
g_iRadius_SunStrike3 <- 184;

g_fRadius_MasSunStrike <- 2.2;
g_fSpawnRadius_MasSunStrike <- 1.15;

g_aiCount2Human_MasSunStrike <- [20, 40];
g_aiCount3Human_MasSunStrike <- [30, 50];

g_aiCount2_MasSunStrike <- [2, 5];
g_aiCount3_MasSunStrike <- [2, 3];
//g_fRadius_MasSunStrike <- 1.2;
//g_iParts_MasSunStrike <- 64;

g_iDistance_Retarget <- 15000;
g_fTime_Retarget <- 7;

g_iRadius_TeleportBoys <- 800;
g_iParts_TeleportBoys <- 16;
g_avOrigins_TeleportBoys <- [];
g_iID_TeleportBoys <- 0;

g_iRadius_Tele <- 800;
g_iParts_Tele <- 32;
g_iCount_Tele1 <- [4, 5];
g_iCount_Tele2 <- [5, 6];
g_iCount_Tele3 <- [6, 7];

//g_iCount_Tele <- [30, 32];
g_iOriginZ_Tele <- [-100, 200];
g_fDelay_Tele <- 0.3;

g_fTimeRestore_CrystalHeal <- 25.0;
g_iHPRestore_CrystalHeal <- 30;
g_iHP_CrystalHeal_perhuman <- 70;
g_fDelay_CrystalHeal_takedamage <- 1.0;

g_iParts_Laser <- 96;
g_iDelay_Laser <- 4;
g_iRadius_Laser <- 666;

g_iDamage_FinalFlash <- 500;
g_iRadius_FinalFlash <- 128;

g_iParts_Shield <- 32;
g_iRadius_Shield <- 478;
g_fTime_Shield <- 30.0;
g_iShoots_Shields <- 10;

// g_iHP_Phase1_perhuman <- 40;
// g_iHP_Phase2_perhuman <- 40;
// g_iHP_Phase3_perhuman <- 40;

g_iHP_Phase1_perhuman <- 375;
g_iHP_Phase2_perhuman <- 400;
g_iHP_Phase3_perhuman <- 425;
g_iHP_Phase4_perhuman <- 170;

g_fIter_Angles <- 0.5;


/*Settings end*/

g_hFade_Heal.__KeyValueFromString("duration", "" + TICKRATE_HEAL_HUMAN);
g_hFade_Heal.__KeyValueFromString("holdtime", "" + TICKRATE_HEAL_HUMAN);
g_hFade_Heal.__KeyValueFromInt("renderamt", 200);
g_hFade_Heal.__KeyValueFromInt("spawnflags", 7);
g_hFade_Heal.__KeyValueFromVector("rendercolor", Vector(28, 184, 227));

EntFireByHandle(self, "RunScriptCode", "Init();", 0.01, null, null);

function Init() 
{
    g_fTime_Laser = RandomInt(g_aiCD_Laser[0], g_aiCD_Laser[1])
    g_fTime_Shield = RandomInt(g_aiCD_Shield[0], g_aiCD_Shield[1])
    g_fTime_MasSunStrike = RandomInt(g_aiCD_MasSunStrike[0], g_aiCD_MasSunStrike[1])
    g_fTime_Wall = RandomInt(g_aiCD_Wall[0], g_aiCD_Wall[1])

    g_fTimeRestore_CrystalHeal = 0.00 + g_fTimeRestore_CrystalHeal;

    g_iDistance_Retarget = 0.00 + g_iDistance_Retarget;
    g_fTime_Retarget = 0.00 + g_fTime_Retarget;
    g_fIter_Angles = 0.00 + g_fIter_Angles;
    g_fDelay_CrystalHeal_takedamage = 0.00 + g_fDelay_CrystalHeal_takedamage;

    g_fCD_FinalFlash = 0.00 + g_fCD_FinalFlash;
    g_fCD_Beam = 0.00 + g_fCD_Beam;
    g_fCD_Attack = 0.00 + g_fCD_Attack;
    g_fCD_Tele = 0.00 + g_fCD_Tele;

    g_fRadius_MasSunStrike = 0.00 + g_fRadius_MasSunStrike;
    g_fSpawnRadius_MasSunStrike = 0.00 + g_fSpawnRadius_MasSunStrike;
    g_fTime_Shield = 0.00 + g_fTime_Shield;

    g_hModel = Entities.CreateByClassname("prop_dynamic");
    {
        g_hModel.SetOrigin(g_vOrigin_Nihilanth);
        g_hModel.SetAngles(0, 0, 0);
        g_hModel.SetModel(Nihilanth_Model);
        g_hModel.__KeyValueFromInt("solid", 0);
        g_hModel.__KeyValueFromString("targetname", "Nihilanth_Prop_Model");
        EntFireByHandle(g_hModel, "AddOutPut", "OnAnimationDone " + self.GetName() + ":RunScriptCode:OnAnimationComplite():0:-1", 0.01, null, null);
        
        SetAnimIdle();
        {
            local u = 0.0;
            local parts = g_iParts_Tele
            local a = PI / parts * 2;
            while(parts > 0)
            {
                local vec = Vector(g_hModel.GetOrigin().x+cos(u)*g_iRadius_Tele, g_hModel.GetOrigin().y+sin(u)*g_iRadius_Tele, g_hModel.GetOrigin().z);
                g_avOrigins_Tele.push(vec);
                u += a;
                parts--;
            }

            u = 0.0;
            parts = g_iParts_TeleportBoys
            a = PI / parts * 2;

            while(parts > 0)
            {
                local vec = Vector(g_hModel.GetOrigin().x+cos(u)*g_iRadius_TeleportBoys, g_hModel.GetOrigin().y+sin(u)*g_iRadius_TeleportBoys, g_hModel.GetOrigin().z);
                g_avOrigins_TeleportBoys.push(vec);
                u += a;
                parts--;
            }

            u = 0.0;
            parts = g_iParts_Laser
            a = PI / parts * 2;

            while(parts > 0)
            {
                local origin = Vector(g_hModel.GetOrigin().x+cos(u)*g_iRadius_Laser, g_hModel.GetOrigin().y+sin(u)*g_iRadius_Laser, g_hModel.GetOrigin().z - 1015);
                local movedir = Vector(0, GetPithYawFVect3D(origin, g_hModel.GetOrigin()), 0);
                g_avPos_Laser.push(class_pos(origin, movedir));
                //DebugDrawCircle(origin, Vector(0,255,0), g_iRadius_SunStrike1, 16, true, 3);
                u += a;
                parts--;
            }

            u = 0.0;
            parts = g_iParts_Shield
            a = PI / parts * 2;

            while(parts > 0)
            {
                local origin = Vector(g_hModel.GetOrigin().x+cos(u)*g_iRadius_Shield, g_hModel.GetOrigin().y+sin(u)*g_iRadius_Shield, g_hModel.GetOrigin().z + 50);
                local movedir = Vector(30, GetPithYawFVect3D(origin, g_hModel.GetOrigin()), 0);
                g_avPos_Shield.push(class_pos(origin, movedir));
                //DebugDrawCircle(origin, Vector(0,255,255), g_iRadius_Shield, 16, true, 3);
                u += a;
                parts--;
            }
        }
    }

    {
        local Hbox = Entities.FindByName(null, "Nihilanth_HitBox_Main");
        if(Hbox != null)
        {
            IgnoreID_Nihilanth.push(Hbox)
            Hbox.SetOrigin(g_vOrigin_HBoxMain);
            EntFireByHandle(Hbox, "SetParent", "!activator", 0.00, g_hModel, g_hModel);
        }

        Hbox = Entities.FindByName(null, "Nihilanth_HitBox_Head");

        if(Hbox != null)
        {
            IgnoreID_Nihilanth.push(Hbox)
            EntFireByHandle(Hbox, "SetParent", "!activator", 0.00, g_hModel, g_hModel);
            EntFireByHandle(Hbox, "SetParentAttachment", "0", 0.02, g_hModel, g_hModel);
        }
    }

    local part = CreateParticle((g_vOrigin_Nihilanth + Vector(0, 0, 1800)), Aura, true);
    EntFireByHandle(part, "SetParent", "!activator", 0.00, g_hModel, g_hModel);


    {
        for(local i = 0; i < g_avOrigins_CrystalHeal.len(); i++)
        {
            g_ahModel_CrystalHeal.push(Create_Crystal());
            g_aiHP_CrystalHeal.push(0);
        }
            
        for(local i = 0; i < g_avPos_Stick.len(); i++)
            Create_Stick(i);
        for(local i = 0; i < g_avPos_StartRocks.len(); i++)
            Create_StartRocks(i);
        for(local i = 0; i < g_avPos_AttackRock.len(); i++)
            CreateProp(g_avPos_AttackRock[i], type_rockattack_prop);
    }

    ScriptCoopResetRoundStartTime();
    //Spawn();
    //OnAnimationComplite();
}

function Spawn()
{
    Phase1_Pre();
    TickHealHuman();
    Tick_KillZone();
}

function Start()
{
    g_bTicking = true;
    Tick();
    TickMove();
}



function TickHealHuman() 
{
    local h;
    foreach(loc in g_avOrigins_Heal) 
    {
        while(null != (h = Entities.FindInSphere(h, loc, g_iRadius_Heal)))
        {
            if(h.GetClassname() == "player" && 
                h.IsValid() && 
                h.GetHealth() > 0 &&
                h.GetTeam() == 3)
            {
                EntFireByHandle(g_hFade_Heal, "Fade", "", 0, h, h);
                {
                    local hp = h.GetHealth();
                    hp += g_iPerTick_Heal;
                    if(hp > g_iMax_Heal)
                        continue;
                    h.SetHealth(hp);
                }
            }
        }
        //DebugDrawCircle(loc, Vector(0,255,0), g_iRadius_Heal, 16, true, 1);
    }
    if(g_iPhase < 3)
        EntFireByHandle(self, "RunScriptCode", "TickHealHuman()", TICKRATE_HEAL_HUMAN, null, null)
}

function Tick()
{
    //Debug();
    
    if(!(Anim_now == "StageEnter" || 
    Anim_now == "Heal" || 
    Anim_now == "Heal_End" || 
    Anim_now == "Stage4"))
    {
        TickTarget();
        TickAttack();
        TickAnimation();
    }

    if(g_bTicking)
        EntFireByHandle(self, "RunScriptCode", "Tick()", TICKRATE, null, null)
}

function Debug() 
{
    local text = "";
    text += g_hTarget;
    if(ValidTarget(g_hTarget, 3))
    {
        text += "\n" + g_hModel.GetAngles().y;
        text += "\n" + GetPithYawFVect3D(g_hTarget.GetOrigin(), g_hModel.GetOrigin());
    }
    text += "\n" + g_fCD_Attack;
    text += "\n" + Anim_now;
    text += "\n" + g_iHP;
    
    if(text != "")
        ScriptPrintMessageCenterAll(text);    
}

function TickTarget() 
{
    if(!ValidTarget(g_hTarget, 3))
        return SearchTarget();

    g_fTimer_Retarget += TICKRATE;

    if(g_fTimer_Retarget >= g_fTime_Retarget)
    {
        return SearchTarget();
    }
}

function TickAttack() 
{
    g_fTimer_Attack += TICKRATE;
    if(g_fTimer_Attack >= g_fCD_Attack && 
    !(  Anim_now == "Beam" ||
        Anim_now == "Tele" || 
        Anim_now == "FinalFlash" ||
        Anim_now == "Summon"))
    {
        g_fTimer_Attack = 0.00;
        return PickRandomAttack();
    }
}

function PickRandomAttack() 
{
    if(g_iPhase == 1)
    {
        local aArray = [];
        local result = null;

        if(g_bCan_Tele)
        {
            aArray.push({
                iChance = 0.1,
                func = "Cast_Tele_Pre",
            });
        }

        if(g_bCan_Beam)
        {
            aArray.push({
                iChance = 0.1,
                func = "Cast_Beam_Pre",
            });
        }

        aArray.push({
            iChance = 0.05,
            func = "Cast_FireBall",
        });

        result = GetChance(aArray);

        EntFireByHandle(self, "RunScriptCode", result.func + "();", 0.00, null, null);
    }
    
    else if(g_iPhase == 2)
    {
        local aArray = [];
        local result = null;

        if(g_bCan_Tele)
        {
            aArray.push({
                iChance = 0.1,
                func = "Cast_Tele_Pre",
            });
        }

        if(g_bCan_Beam)
        {
            aArray.push({
                iChance = 0.1,
                func = "Cast_Beam_Pre",
            });
        }

        aArray.push({
            iChance = 0.05,
            func = "Cast_FireBall",
        });

        result = GetChance(aArray);

        EntFireByHandle(self, "RunScriptCode", result.func + "();", 0.00, null, null);
    }
    else if(g_iPhase == 3)
    {
        local aArray = [];
        local result = null;

        if(g_bCan_Tele)
        {
            aArray.push({
                iChance = 0.1,
                func = "Cast_Tele_Pre",
            });
        }

        if(g_bCan_Beam)
        {
            aArray.push({
                iChance = 0.1,
                func = "Cast_Beam_Pre",
            });
        }

        if(g_bCan_FinalFlash)
        {
            aArray.push({
                iChance = 0.2,
                func = "Cast_FinalFlash",
            });
        }

        aArray.push({
            iChance = 0.1,
            func = "Cast_FireBall",
        });

        result = GetChance(aArray);

        EntFireByHandle(self, "RunScriptCode", result.func + "();", 0.00, null, null);
    }
    else if(g_iPhase == 4)
    {
        // local aArray = [];
        // local result = null;

        // aArray.push({
        //     iChance = 0.5,
        //     func = "Cast_Laser",
        // });

        // aArray.push({
        //     iChance = 0.5,
        //     func = "Cast_MasSunStrike",
        // });

        // result = GetChance(aArray);

        // EntFireByHandle(self, "RunScriptCode", result.func + "();", 0.00, null, null);
    }   
}

function TickAttack_Second()
{
    if(!g_bCan_Attacks)
        return;
    
    if(g_bCan_Wall)
    {
        g_fTimer_Wall += TICKRATE_ATTACKS;
        if(g_fTimer_Wall >= g_fTime_Wall)
        {
            g_fTimer_Wall = 0.0;
            g_fTime_Wall = RandomInt(g_aiCD_Wall[0], g_aiCD_Wall[1])
            Cast_Wall();
        }
    }
    
    if(g_bCan_MasSunStrike)
    {
        g_fTimer_MasSunStrike += TICKRATE_ATTACKS;
        if(g_fTimer_MasSunStrike >= g_fTime_MasSunStrike)
        {
            g_fTimer_MasSunStrike = 0.0;
            if(g_iPhase < 4)
                g_fTime_MasSunStrike = RandomInt(g_aiCD_MasSunStrike[0], g_aiCD_MasSunStrike[1])
            else
                g_fTime_MasSunStrike = RandomInt(g_aiCD_Phase4_MasSunStrike[0], g_aiCD_Phase4_MasSunStrike[1])
            Cast_MasSunStrike();
        }
    }

    if(g_bCan_Shield)
    {
        g_fTimer_Shield += TICKRATE_ATTACKS;
        if(g_fTimer_Shield >= g_fTime_Shield)
        {
            g_fTimer_Shield = 0.0;
            g_fTime_Shield = RandomInt(g_aiCD_Shield[0], g_aiCD_Shield[1])
            Cast_Shield();
        }
    }

    if(g_bCan_Laser)
    {
        g_fTimer_Laser += TICKRATE_ATTACKS;
        if(g_fTimer_Laser >= g_fTime_Laser)
        {
            g_fTimer_Laser = 0.0;
            if(g_iPhase < 4)
                g_fTime_Laser = RandomInt(g_aiCD_Laser[0], g_aiCD_Laser[1])
            else
                g_fTime_Laser = RandomInt(g_aiCD_Phase4_Laser[0], g_aiCD_Phase4_Laser[1])
            Cast_Laser();
        }
    }

    EntFireByHandle(self, "RunScriptCode", "TickAttack_Second();", TICKRATE_ATTACKS, null, null);
}

function TickAnimation() 
{
    if( !(Anim_now == "FireBall" || 
        Anim_now == "Beam" || 
        Anim_now == "Tele" || 
        Anim_now == "FinalFlash" ||
        Anim_now == "Summon" || 
        Anim_now == "Stage4Loop")
        )
    {
        SetAnimIdle();
    }
}

function OnAnimationComplite() 
{
    if(Anim_now == "StageEnter")
    {
        // g_hTarget = null;
        // g_fTime_Retarget = 0.0;
        Anim_now = "";
        g_bTakeDamage = true;
        EntFire("Nihilanth_HitBox_Main", "SetDamageFilter", "Only_CT", 0.00, null);

        if(g_iPhase == 1)
        {
            Start();
            g_bCan_MasSunStrike = true;

            g_bCan_Attacks = true;
            TickAttack_Second();

        }
        else if(g_iPhase == 2)
        {
            g_bCan_MasSunStrike = true;
            g_bCan_Wall = true;

            g_bCan_Attacks = true;
            TickAttack_Second();
        }
        else if(g_iPhase == 3)
        {
            g_bCan_MasSunStrike = true;
            g_bCan_Wall = true;
            g_bCan_Shield = true;
            g_bCan_Laser = true;

            g_bCan_Attacks = true;
            TickAttack_Second();
        }
    }
    else if(Anim_now == "Stage4")
    {
        // g_hTarget = null;
        // g_fTime_Retarget = 0.0;
        Anim_now = "Stage4Loop"

        EntFire("Nihilanth_HitBox_Main", "Break", "", 0.00, null);

        EntFire("Nihilanth_HitBox_Head", "SetDamageFilter", "Only_CT", 0.00, null);

        g_bTakeDamage = true;

        g_bCan_MasSunStrike = true;
        g_bCan_Laser = true;

        g_bCan_Attacks = true;
        TickAttack_Second();

    } 
    else if(Anim_now == "Heal_End")
    {
        g_hTarget = null;
        g_fTimer_Retarget = 0.0;
        Anim_now = "";
        g_iHPBack_Phase2 = g_iHP;
        g_iHPrestore_Phase2 = g_iHP - g_iHP * 0.01 * g_iHPRestore_CrystalHeal * (4 - g_ahModel_CrystalHeal.len());

        g_bTakeDamage = true;
        EntFire("Nihilanth_HitBox_Main", "SetDamageFilter", "Only_CT", 0.00, null);
    }
    else if(Anim_now == "Summon")
    {
        return
    }
    else if(Anim_now == "Heal")
    {
        g_hTarget = null;
        g_fTimer_Retarget = 0.0;
        return
    }
    else if(Anim_now == "Beam" || 
    Anim_now == "Tele" || 
    Anim_now == "FinalFlash" || 
    Anim_now == "FireBall")
    {
        if(g_bAfter_Attack)
            EntFireByHandle(self, "RunScriptCode", "NextStage()", 0.05, null, null);
        else
            Anim_now = "";  
    }
}
A_Summon_Start <- "Attack_Summon_Enter";
A_Summon_Loop <- "Attack_Summon";
A_Summon_End <- "Attack_Summon_End";

A_TeleRight <- "Attack_telekenesis_right";
A_TeleLeft <- "Attack_telekenesis_left";
function Cast_Tele_Pre(block_cast = true)
{
    SetAnimSummon();

    EntFireByHandle(self, "RunScriptCode", "Cast_Tele()", 0.5, null, null)

    if(block_cast)
    {
        g_bCan_Tele = false;
        EntFireByHandle(self, "RunScriptCode", "g_bCan_Tele = true;", g_fCD_Tele, null, null)
    }
}

function Create_StartRocks(ID) 
{
    local model = CreateProp(g_avPos_StartRocks[ID].origin, type_startrock_prop, ID);
    model.SetAngles(g_avPos_StartRocks[ID].ax, g_avPos_StartRocks[ID].ay, g_avPos_StartRocks[ID].az);
}

A_Phase1_Start <- "Intro";
A_Phase2_Start <- "Phase2_Enter";
A_Phase3_Start <- "Phase3_Enter";

A_FinalFlash <- "Attack_Final_Flash";
function Cast_FinalFlash(block_cast = true) 
{
    SetAnimation(A_FinalFlash);
    Anim_now = "FinalFlash";

    g_fTimer_Retarget = 0.00;
    local target = g_hTarget;
    
    if(target == null)
        target = GetRandomTarget(g_hModel.GetOrigin(), 99999);

    local origin = g_hModel.GetAttachmentOrigin(g_hModel.LookupAttachment("4"));
    local part1 = CreateParticle(origin, FinalFlash, true);
    local lightd = CreateLightd(origin, type_finalflash_light); 

    EntFireByHandle(part1, "SetParent", "!activator", 0.00, g_hModel, g_hModel);
    EntFireByHandle(lightd, "SetParent", "!activator", 0.00, g_hModel, g_hModel);
    EntFireByHandle(part1, "SetParentAttachment", "4", 0.05, g_hModel, g_hModel);
    EntFireByHandle(lightd, "SetParentAttachment", "4", 0.05, g_hModel, g_hModel);

    local part2 = CreateParticle(Vector(0, 0, 0), FinalFlash_Beam);
    local part2parent = CreateProp(Vector(0, 0, 0), type_parent_prop);

    local parent1 = CreateProp(target.GetOrigin(), type_parent_prop);
    local parent2 = CreateProp(origin, type_parent_prop);

    EntFireByHandle(parent2, "SetParent", "!activator", 0.00, g_hModel, g_hModel);
    EntFireByHandle(parent2, "SetParentAttachment", "4", 0.05, g_hModel, g_hModel);

    parent1.__KeyValueFromString("targetname", "Parent_FinalFlash1" + Time())
    parent2.__KeyValueFromString("targetname", "Parent_FinalFlash2" + Time())

    EntFireByHandle(parent1, "SetParent", "!activator", 0.00, target, target);
    EntFireByHandle(part2, "SetParent", "!activator", 0.00, part2parent, part2parent);
    local timer = 4.15;
    
    part2parent.ValidateScriptScope();
    EntFireByHandle(part2parent, "RunScriptCode", "self.SetOrigin(activator.GetOrigin());", timer - 0.15, part1, part1);
    EntFireByHandle(part2parent, "RunScriptCode", "local ang = GetPithXawFVect3D(self.GetOrigin(), activator.GetOrigin());self.SetAngles(ang.x - 90, ang.y, ang.z)", timer - 0.1, parent1, parent1);
    EntFireByHandle(part2, "Start", "", timer, null, null);
    EntFireByHandle(part2parent, "Kill", "", timer + 0.5, null, null);
    
    local array = [];
    array.push(parent1.GetName());
    array.push(parent2.GetName());

    EntFireByHandle(CreateSound(g_vOrigin_Nihilanth, type_nihilanthfinalflash_sound), "Kill", "", 8.0, null, null);

    EntFireByHandle(CreateBeam(origin, type_finalflash_beam, array), "Kill", "", timer - 0.5, null, null);
    EntFireByHandle(parent1, "ClearParent", "", timer - 0.65, null, null);
    EntFireByHandle(parent1, "Kill", "", timer, null, null);
    EntFireByHandle(parent2, "Kill", "", timer, null, null);
    EntFireByHandle(lightd, "Kill", "", timer + 0.5, null, null);
    EntFireByHandle(part1, "Kill", "", timer, null, null);

    EntFireByHandle(self, "RunScriptCode", "Cast_FinalFlash_Next();", timer, parent1, parent1);

    if(block_cast)
    {
        g_bCan_FinalFlash = false;
        EntFireByHandle(self, "RunScriptCode", "g_bCan_FinalFlash = true;", g_fCD_FinalFlash, null, null)
    }
}

function Cast_FinalFlash_Next() 
{
    DamageInSphere(activator.GetOrigin(), g_iRadius_FinalFlash, g_iDamage_FinalFlash);
}

function TickHeal()
{
    if(Anim_now != "Heal")
        return

    g_iHP += g_iHPAdd_Phase2;
    if(g_iHP >= g_iHPBack_Phase2)
    {
        g_iHP = g_iHPBack_Phase2;
        return UnCast_Crystal();
    }

    EntFireByHandle(self, "RunScriptCode", "TickHeal()", TICKRATE_HEAL, null, null)
}

A_Heal_Start <- "Heal_Begin";
A_Heal_Loop <- "Heal_Loop";
A_Heal_End <- "Heal_End";
A_Heal_BadEnd <- "Heal_Interrupted";

function Cast_Crystal()
{
    Anim_now = "Heal";
    SetAnimation(A_Heal_Start);
    SetDefaultAnimation(A_Heal_Loop);

    local hp = CountPlayers(g_hModel.GetOrigin(), g_iDistance_Retarget) * g_iHP_CrystalHeal_perhuman;
    for(local i = 0; i < g_ahModel_CrystalHeal.len(); i++)
    {   
        g_aiHP_CrystalHeal[i] = hp;
    }

    EntFireByHandle(self, "RunScriptCode", "g_bCanDamage_Crystal = true;", g_fDelay_CrystalHeal_takedamage, null, null)

    EntFire("Nihilanth_Prop_CrystalHeal*", "SetAnimation", "deploy", 0);
    EntFire("Nihilanth_Prop_CrystalHeal*", "SetDefaultAnimation", "idle_deploy", 0.01);
    
    EntFire("Nihilanth_Beam_CrystalHeal*", "TurnOn", "", 3.0);

    EntFire("Nihilanth_Particle_CrystalHeal_Start*", "Start", "", 0.3);
    EntFire("Nihilanth_Particle_CrystalHeal_Start*", "Stop", "", 2.8);
    EntFire("Nihilanth_Particle_CrystalHeal_Idle*", "Start", "", 2.5);

    EntFire("Nihilanth_Lightd_CrystalHeal*", "TurnOn", "", 0.4);

    // EntFire("Nihilanth_Sound_CrystalHeal*", "Volume", "10", 0);
    // EntFire("Nihilanth_Sound_CrystalHeal*", "PlaySound", "", 0);

    local Chest_part = CreateParticle(Vector(0, 0, 0), Heal_Start, false);
    Chest_part.__KeyValueFromString("targetname", "Nihilanth_Particle_CrystalHeal_Chest");

    EntFireByHandle(Chest_part, "SetParent", "!activator", 0.00, g_hModel, g_hModel);
    EntFireByHandle(Chest_part, "SetParentAttachment", "2", 0.10, g_hModel, g_hModel);
    EntFireByHandle(Chest_part, "Start", "", 3.0, null, null);

    g_iHPAdd_Phase2 = (g_iHPBack_Phase2 - g_iHP) / g_fTimeRestore_CrystalHeal;
    TickHeal()
}

function Damage_Crystal(damage = 1) 
{
    if(!g_bCanDamage_Crystal)
        return;
    for(local i = 0; i < g_ahModel_CrystalHeal.len(); i++)
    {
        if(caller == g_ahModel_CrystalHeal[i])
        {
            g_aiHP_CrystalHeal[i] -= damage;
            if(g_aiHP_CrystalHeal[i] <= 0)
            {
                local ID = caller.GetName();
                Destroy_Crystal(i, ID = (ID.slice(ID.len() - 1, ID.len())).tointeger());
            }

            return;
        }
    }
}

function Destroy_Crystal(ID, NUM) 
{
    g_bCanDamage_Crystal = false;

    //EntFire("Nihilanth_Sound_CrystalHeal*", "Volume", "0", 0);
    
    for(local i = 0; i < g_avOrigins_CrystalHeal.len(); i++)
    {   
        if(NUM != i)
        {
            EntFire("Nihilanth_Prop_CrystalHeal" + i, "SetAnimation", "retract", 0);
            EntFire("Nihilanth_Prop_CrystalHeal" + i, "SetDefaultAnimation", "idle_retract", 0);
            
            EntFire("Nihilanth_Beam_CrystalHeal" + i, "TurnOff", "", 0.1);
            EntFire("Nihilanth_Particle_CrystalHeal_Start" + i, "Stop", "", 0);
            EntFire("Nihilanth_Particle_CrystalHeal_Idle" + i, "Stop", "", 0.5);
            EntFire("Nihilanth_Lightd_CrystalHeal" + i, "TurnOff", "", 0.5);
        }
        else 
        {
            //EntFireByHandle(CreateSound(g_avOrigins_CrystalHeal[i], type_nihilanthcrystalend_sound), "Kill", "", 1.0, null, null);

            EntFire("Nihilanth_Prop_CrystalHeal" + i, "SetAnimation", "explode", 0);
            EntFire("Nihilanth_Prop_CrystalHeal" + i, "FadeAndKill", "", 3.50);

            EntFire("Nihilanth_Sprite_CrystalHeal" + i, "Kill", "", 0);
            EntFire("Nihilanth_Particle_CrystalHeal_Idle" + i, "Kill", "", 0);

            EntFire("Nihilanth_Particle_CrystalHeal" + i, "Kill", "", 0.9);
            EntFire("Nihilanth_Beam_CrystalHeal" + i, "Kill", "", 0.9);
            EntFire("Nihilanth_Lightd_CrystalHeal" + i, "Kill", "", 0.9);
            //EntFire("Nihilanth_Sound_CrystalHeal" + i, "Kill", "", 0.9);
        }
    }

    EntFire("Nihilanth_Particle_CrystalHeal_Chest", "Kill", "", 0.9);

    local Chest_part = CreateParticle(Vector(0, 0, 0), Heal_Break, true);
    EntFireByHandle(Chest_part, "SetParent", "!activator", 0.00, g_hModel, g_hModel);
    EntFireByHandle(Chest_part, "SetParentAttachment", "2", 0.10, g_hModel, g_hModel);
    EntFireByHandle(Chest_part, "Kill", "", 10.0, null, null);
    
    g_aiHP_CrystalHeal.remove(ID);
    g_ahModel_CrystalHeal.remove(ID);

    if(g_ahModel_CrystalHeal.len() <= 0)
        return Phase3_Pre();

    SetAnimation(A_Heal_BadEnd);
    Anim_now = "Heal_End";
}

function UnCast_Crystal() 
{
    g_bCanDamage_Crystal = false;

    EntFire("Nihilanth_Prop_CrystalHeal*", "SetAnimation", "retract", 0);
    EntFire("Nihilanth_Prop_CrystalHeal*", "SetDefaultAnimation", "idle_retract", 0);
    
    EntFire("Nihilanth_Beam_CrystalHeal*", "TurnOff", "", 0.1);
    EntFire("Nihilanth_Particle_CrystalHeal_Idle*", "Stop", "", 0.5);
    EntFire("Nihilanth_Lightd_CrystalHeal*", "TurnOff", "", 0.5);

    EntFire("Nihilanth_Particle_CrystalHeal_Chest", "Kill", "", 0.9);

    

    SetAnimation(A_Heal_End);
    Anim_now = "Heal_End";
}


function Damage_Nihilanth(i = 1)
{   
    if(!g_bTakeDamage)
        return;

    g_iHP -= i;

    if(g_iPhase == 2 && g_ahModel_CrystalHeal.len() > 0)
    {
        if(g_iHP > g_iHPrestore_Phase2)
            return;
    }
    else if(g_iHP > 0)
        return;
    
    g_bTakeDamage = false;
    EntFire("Nihilanth_HitBox_Main", "SetDamageFilter", "No_Damage", 0.00, null);

    if( Anim_now == "Beam" ||
        Anim_now == "Tele" || 
        Anim_now == "FinalFlash" ||
        Anim_now == "FireBall" ||
        Anim_now == "Summon")
        return g_bAfter_Attack = true;

    NextStage();
}

function NextStage()
{
    g_bAfter_Attack = false;

    if(g_iPhase == 2 && g_ahModel_CrystalHeal.len() > 0)
    {
        return Cast_Crystal();
    }
    
    g_fTimer_Wall = 0.0;
    g_fTimer_MasSunStrike = 0.0;
    g_fTimer_Shield = 0.0;
    g_fTimer_Laser = 0.0;

    g_bCan_MasSunStrike = false;
    g_bCan_Wall = false;
    g_bCan_Shield = false;
    g_bCan_Laser = false;

    g_bCan_Attacks = false;

    if(g_iPhase == 1)
    {
        Phase2_Pre();

        OneTickStick();
    }

    else if(g_iPhase == 3)
    {
        g_fTime_MasSunStrike = RandomInt(g_aiCD_Phase4_MasSunStrike[0], g_aiCD_Phase4_MasSunStrike[1])
        g_fTime_Laser = RandomInt(g_aiCD_Phase4_Laser[0], g_aiCD_Phase4_Laser[1])
        Phase4_Enter();
    }

    else if(g_iPhase == 4)
    {
        BossDead();
    }
}
{
    function Cast_Laser() 
    {
        for(local b = 0,start = g_iDelay_Laser; b < g_iDelay_Laser; b++)
        {
            EntFireByHandle(self, "RunScriptCode", "CreateLaserWave()", start, null, null);

            for(local i = start; i < g_iParts_Laser; i+=g_iDelay_Laser)
            {
                local o = g_avPos_Laser[i].origin;
                local a = g_avPos_Laser[i].angles;

                EntFireByHandle(self, "RunScriptCode", "CreateLaser(Vector(" + o.x + "," + o.y + "," + o.z + "), Vector(" + a.x + "," + a.y + "," + a.z + "))", start + 0.6, null, null);
            }

            start -= 1;
        }
    }

    function CreateLaserWave() 
    {
        EntFireByHandle(CreateSound(g_vOrigin_LaserPre, type_nihilanthlaser_sound, RandomInt(0, Nihilanth_LaserArray_Sound.len() - 1)), "Kill", "", 5.0, null, null);
        EntFireByHandle(CreateParticle(g_vOrigin_LaserPre, Laser_Pre, true), "Kill", "", 2.0, null, null);
    }

    function CreateLaser(pos1, pos2) 
    {
        local pos = class_pos(pos1, pos2);
        local model = CreateProp(pos, type_laser_prop);
        
        //local part2 = CreateParticle(Vector(0, 0, 0), Laser, true);
        // local part3 = CreateParticle(Vector(0, 0, 0), Laser, true);
        //local part4 = CreateParticle(Vector(0, 0, 0), Laser, true);
        local lightd = CreateLightd(Vector(0, 0, 0), type_crystal_laser, true);

        // EntFireByHandle(part1, "SetParent", "!activator", 0.00, model, model);
        // EntFireByHandle(part1, "SetParentAttachment", "particle1", 0.05, model, model);

        // EntFireByHandle(part2, "SetParent", "!activator", 0.00, model, model);
        // EntFireByHandle(part2, "SetParentAttachment", "particle3", 0.05, model, model);

        // EntFireByHandle(part3, "SetParent", "!activator", 0.00, model, model);
        // EntFireByHandle(part3, "SetParentAttachment", "particle4", 0.05, model, model);

        // EntFireByHandle(part4, "SetParent", "!activator", 0.00, model, model);
        // EntFireByHandle(part4, "SetParentAttachment", "particle6", 0.05, model, model);

        EntFireByHandle(lightd, "SetParent", "!activator", 0.00, model, model);
        EntFireByHandle(lightd, "SetParentAttachment", "particle3", 0.05, model, model);
    }
}

{
    function Cast_Wall()
    {
        EntFire("Nihilanth_Prop_AttackRock", "SetAnimation", "Cinephys", 0);

        EntFireByHandle(CreateSound(g_vOrigin_Nihilanth, type_nihilanthrockstart_sound), "Kill", "", 15.0, null, null);

        local soundstart = CreateSound(g_vOrigin_Nihilanth, type_nihilanthrockend_sound);
        EntFireByHandle(soundstart, "PlaySound", "", 6.5, null, null);
        EntFireByHandle(soundstart, "Kill", "", 15.0, null, null);
    }
}

{
    function Cast_Shield() 
    {
        local pos = g_avPos_Shield[ShieldCheck()];//LAST!!!
        local part = CreateParticle(Vector(0, 0, 0), Shield, true);
        local model = CreateProp(Vector(0, 0, 0), type_shield_prop);

        IgnoreID_Nihilanth.push(model)
        
        EntFireByHandle(part, "SetParent", "!activator", 0.00, model, model);
        EntFireByHandle(model, "RunScriptCode", "self.SetOrigin(Vector(" + pos.ox + "," + pos.oy + "," + pos.oz + "))", 0.05, null, null);
        EntFireByHandle(model, "RunScriptCode", "self.SetAngles(" + pos.ax + "," + pos.ay + "," + pos.az + ")", 0.05, null, null);
        EntFireByHandle(part, "Kill", "", g_fTime_Shield, null, null);
        EntFireByHandle(model, "Kill", "", g_fTime_Shield, null, null);
        EntFireByHandle(model, "AddOutPut", "OnHealthChanged " + self.GetName() + ":RunScriptCode:Damage_Shield():0:-1", 0.01, null, null);

        EntFireByHandle(self, "RunScritCode", "Remove_Shield()", g_fTime_Shield, model, model);

        g_hShields.push(model);
        g_iHealth_Shields.push(0);

        EntFireByHandle(model, "RunScriptCode", "self.SetAngles(" + pos.ax + "," + pos.ay + "," + pos.az + ")", 0.05, null, null);
    }

    function Damage_Shield()
    {
        if(activator.GetClassname() != "player")
            return;

        for(local i = 0; i < g_hShields.len(); i++)
        {
            if(caller == g_hShields[i])
            {
                g_iHealth_Shields[i] += 1;
                if(g_iHealth_Shields[i] > g_iShoots_Shields)
                {
                    g_iHealth_Shields[i] = 0;
                    CreateFireBall(g_hShields[i].GetOrigin());
                }
            }
        }
    }

    function Remove_Shield()
    {
        for(local i = 0; i < g_hShields.len(); i++)
        {
            if(activator == g_hShields[i])
            {
                g_hShields.remove(i);
                g_iHealth_Shields.remove(i);
                return 
            }
        }
    }

    function ShieldCheck() 
    {
        local origin = Vector(0, 0, 0);
        local count = 0;
        local h = null;
        while(null != (h = Entities.FindInSphere(h, g_hModel.GetOrigin(), 99999)))
        {
            if(h.GetClassname() == "player" && 
                h.IsValid() &&
                h.GetHealth() > 0 &&
                h.GetTeam() == 3)
            {
                origin += h.GetOrigin();
                count++;
            }
        }
        
        local origin = Vector(origin.x / count, origin.y / count, origin.z / count)
        local start = 99999;
        local ID = 0;

        for(local i = 0; i < g_avPos_Shield.len(); i++)
        {
            local distance = GetDistance3D(g_avPos_Shield[i].origin, origin);
            if(distance < start)
            {
                start = distance;
                ID = i;
            }
        }
        return ID;
    }
}

{
    function Cast_SunStrike(target = null) 
    {
        if(target == null)
        {
            if(!ValidTarget(g_hTarget, 3))
                return;
            target = g_hTarget.GetOrigin();
        }

        local pos = GetFloor(target + Vector(0, 0, 100));
        local p = CreateLightd(pos + Vector(0,0, 100), ((g_iPhase > 2) ? type_sunstrike3_light : type_sunstrike1_light));
        local h = CreateParticle(pos, ((g_iPhase > 2) ? SunStrike3_Pre : SunStrike1_Pre), true);
        
        EntFireByHandle(CreateSound(pos, type_nihilanthsunstrikespawn_sound, RandomInt(0, Nihilanth_SunStrike_Sound.len() - 1)), "Kill", "", 3.0, null, null);
        EntFireByHandle(p, "Kill", "", 2.3, null, null);
        EntFireByHandle(self, "RunScriptCode", "Cast_SunStrike_Next()", 2.3, h, h)
    }

    function Cast_SunStrike_Next()
    {
        local part = CreateParticle(activator.GetOrigin(), ((g_iPhase > 2) ? SunStrike3 : SunStrike1), true);
        EntFireByHandle(part, "Kill", "", 0.5, null, null);
        EntFireByHandle(CreateSound(activator.GetOrigin(), type_nihilanthsunstrikeexplode_sound), "Kill", "", 2.8, null, null);

        //DebugDrawCircle(activator.GetOrigin(), Vector(0,255,0), ((g_iPhase > 2) ? g_iRadius_SunStrike3 : g_iRadius_SunStrike1), 16, true, 3);

        DamageInSphere(activator.GetOrigin(), ((g_iPhase > 2) ? g_iRadius_SunStrike3 : g_iRadius_SunStrike1), ((g_iPhase > 2) ? g_iDamage_SunStrike3 : g_iDamage_SunStrike1));
        activator.Destroy();
    }

    function Cast_MasSunStrike() 
    {
        //printl("ew")
        local playerscount = ((g_iPhase > 2) ? g_aiCount3Human_MasSunStrike : g_aiCount2Human_MasSunStrike);
        playerscount = RandomInt(playerscount[0], playerscount[1]);
        local playesvalid = CountPlayers(g_hModel.GetOrigin(), g_iDistance_Retarget);
        if(playesvalid < 1) {return;}
        playerscount = ((playerscount * playesvalid) * 0.01).tointeger();
        if(playerscount < 1) {return;}
        
        if(playerscount > 10) {playerscount = 10;}
            
        local arrayplayes = [];
        

        local handle;
        while( null != ( handle = Entities.FindInSphere(handle, g_hModel.GetOrigin(), g_iDistance_Retarget)))
        {
            //if(handle.GetClassname() == "weapon_bizon")
            if(handle.GetClassname() == "player" && handle.GetTeam() == 3 && handle.GetHealth() > 0)
            {
                arrayplayes.push(handle);
            }
        }

        local arraytakesun = [];

        if(arrayplayes.len() == 1)
        {
            arraytakesun.push(arrayplayes[0]);
        }
        else
        {
            for (local i = 0, randomindex; i < playerscount; i++)
            {
                randomindex = RandomInt(0, arrayplayes.len() - 1);

                arraytakesun.push(arrayplayes[randomindex])
                arrayplayes.remove(randomindex);
            }
        }

        local countforonehuman = ((g_iPhase > 2) ? g_aiCount3_MasSunStrike : g_aiCount2_MasSunStrike);
        for(local b = 0, count, targetorigin, origin; b < arraytakesun.len(); b++)
        {
            count = (RandomInt(countforonehuman[0], countforonehuman[1]));
            targetorigin = arraytakesun[b].GetOrigin();

            for(local i = 0; i <= count; i++)
            {
                origin = SunStikerCheck(targetorigin, g_avOrigins_SunStike, (((g_iPhase > 2) ? g_iRadius_SunStrike3 : g_iRadius_SunStrike1) * g_fRadius_MasSunStrike), count);
                g_avOrigins_SunStike.push(origin);
                Cast_SunStrike(origin);
            }
        }

        g_avOrigins_SunStike.clear();
    }

    function SunStikerCheck(origin, array, radius, spawncount, maxtry = 320, limiter = [740, 3200]) 
    {
        local save = origin;
        if(array.len() > 0)
        {   
            local count = 0;
            local block;
            local idinamic = radius * g_fSpawnRadius_MasSunStrike * (spawncount * 0.25);
            while(maxtry > count++)
            {
                block = false;
                origin = save + Vector(RandomInt(-idinamic, idinamic), RandomInt(-idinamic, idinamic), 0);
                for(local b = 0; b < array.len(); b++)
                {
                    local idistance = GetDistance2D(g_vOrigin_Nihilanth, origin);
                    if(limiter[0] > idistance || idistance > limiter[1])
                    {
                        block = true;
                        break;
                    }

                    local idistance1 = GetDistance2D(array[b], origin);
                    if(idistance1 < radius)
                    {
                        block = true;
                        break;
                    } 
                }

                if(!block)
                    return origin
            }
        }
        return save;
    }
}

A_Beam <- "Attack_BeamSwipe"
function Cast_Beam_Pre(block_cast = true)
{
    SetAnimation(A_Beam);
    Anim_now = "Beam";

    Cast_Beam(1);
    Cast_Beam(3);

    g_btick_Beam = true;
    EntFireByHandle(self, "RunScriptCode", "Beam_Toggle()", 1.4, null, null);
    EntFireByHandle(self, "RunScriptCode", "Beam_Move()", 1.2, null, null);

    local soundstart = CreateSound(g_vOrigin_Nihilanth, type_nihilanthbeamstart_sound, RandomInt(0, Nihilanth_BeamArray_Sound.len() - 1));
    EntFireByHandle(soundstart, "PlaySound", "", 1.4, null, null);
    EntFireByHandle(soundstart, "Volume", "0", 7.2, null, null);
    EntFireByHandle(soundstart, "Kill", "", 9.0, null, null);

    local soundend = CreateSound(g_vOrigin_Nihilanth, type_nihilanthbeamend_sound);
    EntFireByHandle(soundend, "PlaySound", "", 7.1, null, null);
    EntFireByHandle(soundend, "Volume", "0", 9.8, null, null);
    EntFireByHandle(soundend, "Kill", "", 10.0, null, null);

    EntFireByHandle(self, "RunScriptCode", "g_btick_Beam = false;", 8.1, null, null);

    if(block_cast)
    {
        g_bCan_Beam = false;
        EntFireByHandle(self, "RunScriptCode", "g_bCan_Beam = true;", g_fCD_Beam, null, null)
    }
}

function Beam_Toggle()
{
    if(!g_btick_Beam)
        return;

    EntFire("Nihilanth_Beam_Beam*", "TurnOff", "", 0.01);
    EntFire("Nihilanth_Beam_Beam*", "TurnOn", "", TICKRATE_BEAM);

    EntFireByHandle(self, "RunScriptCode", "Beam_Toggle()", TICKRATE_BEAM, null, null);
}

function Beam_Move()
{
    if(!g_btick_Beam)
        return;
    local parent1 = Entities.FindByName(null, "Parent_Beams_Main1");
    local parent2 = Entities.FindByName(null, "Parent_Beams_Main3");
    if(parent1 != null && parent2 != null)
    {
        local origin1 = g_hModel.GetAttachmentOrigin(g_hModel.LookupAttachment("1"));
        local origin2 = g_hModel.GetAttachmentOrigin(g_hModel.LookupAttachment("3"));
        local ang = g_hModel.GetAngles();
        parent1.SetOrigin(origin1);
        parent2.SetOrigin(origin2);
        parent1.SetAngles(0, ang.y, 0);
        parent2.SetAngles(0, ang.y, 0);
    }

    EntFireByHandle(self, "RunScriptCode", "Beam_Move()", TICKRATE_BEAMMOVE, null, null);
}

function Cast_Beam(ID)
{
    local mParent = CreateProp(Vector(0, 0, 0), type_parent_prop);
    mParent.__KeyValueFromString("targetname", "Parent_Beams_Main" + ID);
    // EntFireByHandle(mParent, "SetParent", "!activator", 0.00, g_hModel, g_hModel);
    // EntFireByHandle(mParent, "SetParentAttachment", ""+ID, 0.10, g_hModel, g_hModel);
    EntFireByHandle(mParent, "Kill", "", 8.1, null, null);

    local hand_part = CreateParticle(Vector(0, 0, 0), BeamAttack_Hand, false);
    EntFireByHandle(hand_part, "Start", "", 1.30, g_hModel, g_hModel);
    EntFireByHandle(hand_part, "SetParent", "!activator", 0.00, g_hModel, g_hModel);
    EntFireByHandle(hand_part, "SetParentAttachment", ""+ID, 0.10, g_hModel, g_hModel);
    EntFireByHandle(hand_part, "Kill", "", 13.2, null, null);

    local sprite = CreateSprite(Vector(0, 0, 0), type_beam_sprite);
    EntFireByHandle(sprite, "ToggleSprite", "", 1.30, g_hModel, g_hModel);
    EntFireByHandle(sprite, "SetParent", "!activator", 0.00, g_hModel, g_hModel);
    EntFireByHandle(sprite, "SetParentAttachment", ""+ID, 0.10, g_hModel, g_hModel);
    EntFireByHandle(sprite, "Kill", "", 8.0, null, null);

    local lightd = CreateLightd(Vector(0, 0, 0), type_beam_light);
    EntFireByHandle(lightd, "TurnOn", "", 1.30, g_hModel, g_hModel);
    EntFireByHandle(lightd, "SetParent", "!activator", 0.00, g_hModel, g_hModel);
    EntFireByHandle(lightd, "SetParentAttachment", ""+ID, 0.10, g_hModel, g_hModel);
    EntFireByHandle(lightd, "Kill", "", 8.2, null, null);

    // EntFireByHandle(mParent, "SetParent", "!activator", 0.05, g_hModel, g_hModel);
    // EntFireByHandle(mParent, "SetParentAttachment", ""+ID, 0.1, g_hModel, g_hModel);
    
    
    CreateAttackBeam(Vector(1660, 0, -1377), mParent, ID + 1);

    if(g_iPhase < 2)
        return;

    CreateAttackBeam(Vector(3200,  (ID != 3) ? -150 : 150, -2000), mParent, ID + 2);

    if(g_iPhase < 3)
        return;

    //CreateAttackBeam(Vector(3500, (ID != 3) ? -250 : 250, 1000), mParent, ID + 3);
    CreateAttackBeam(Vector(3000, 0, -2750), mParent, ID + 4);
    CreateAttackBeam(Vector(3000, 0, -500), mParent, ID + 5);
    //CreateAttackBeam(Vector(4000, (ID != 3) ? -50 : 50, 2350), mParent, ID + 6);
}

function CreateAttackBeam(origin, mParent, ID)
{
    local nParent = CreateProp(origin, type_parent_prop);
    nParent.__KeyValueFromString("targetname", "Parent_Beams" + ID);
    EntFireByHandle(nParent, "SetParent", "!activator", 0.00, mParent, mParent);

    local array = [];
    array.push(mParent.GetName());
    array.push(nParent.GetName());
    local beam = CreateBeam(Vector(0,0,0), type_beam_beam, array);
    EntFireByHandle(beam, "Kill", "", 8.0, null, null);
    EntFireByHandle(nParent, "Kill", "", 8.1, null, null);
}

A_FireBall <- "Attack_Ballz_p3"
function Cast_FireBall()
{
    SetAnimation(A_FireBall);
    Anim_now = "FireBall";

    local hand_part1 = CreateParticle(Vector(0, 0, 0), FireBall_Hand, true);
    local hand_part2 = CreateParticle(Vector(0, 0, 0), FireBall_Hand, true);

    EntFireByHandle(hand_part1, "SetParent", "!activator", 0.00, g_hModel, g_hModel);
    EntFireByHandle(hand_part2, "SetParent", "!activator", 0.00, g_hModel, g_hModel);

    EntFireByHandle(hand_part1, "SetParentAttachment", "1", 0.10, g_hModel, g_hModel);
    EntFireByHandle(hand_part2, "SetParentAttachment", "3", 0.10, g_hModel, g_hModel);

    EntFireByHandle(self, "RunScriptCode", "Cast_FireBall_Next(1)", 1.3, null, null);
    EntFireByHandle(self, "RunScriptCode", "Cast_FireBall_Next(3)", 1.7, null, null);
    EntFireByHandle(self, "RunScriptCode", "Cast_FireBall_Next(1)", 2.3, null, null);

    EntFireByHandle(hand_part1, "Kill", "", 3.20, null, null);
    EntFireByHandle(hand_part2, "Kill", "", 3.20, null, null);
}

function Cast_FireBall_Next(ID)
{
    local origin = g_hModel.GetAttachmentOrigin(g_hModel.LookupAttachment("" + ID));
    local main = CreateFireBall(origin);
    if(g_iPhase == 2)
    {
        local parent1 = CreateFireBall(origin, main, main.GetLeftVector() * 250);
        local parent2 = CreateFireBall(origin, main, main.GetLeftVector() * -250);
    }
    else if(g_iPhase == 3)
    {
        local parent1 = CreateFireBall(origin, main, main.GetLeftVector() * 250);
        local parent2 = CreateFireBall(origin, main, main.GetLeftVector() * -250);
        local parent3 = CreateFireBall(origin, main, main.GetUpVector() * 250);
        local parent4 = CreateFireBall(origin, main, main.GetUpVector() * -250);
    }
}

function CreateFireBall(origin, nparent = null, Vecocity = null)
{
    local fireball = CreateParticle(origin, FireBall_Main, true);
    EntFireByHandle(fireball, "RunScriptFile", "kotya/npst/nihilanth/fireball.nut", 0.00, null, null);

    local lightd = CreateLightd(origin, type_fireball_light);
    EntFireByHandle(lightd, "SetParent", "!activator", 0.00, fireball, fireball);
    
    if(nparent != null)
    {
        EntFireByHandle(fireball, "RunScriptCode", "local pos = activator.GetScriptScope().g_vBmove; pos = (self.GetOrigin() - (pos + Vector(" + Vecocity.x + ", " + Vecocity.y + ", " + Vecocity.z + "))); pos.Norm(); g_vMove = pos;", 0.02, nparent, nparent);
    }

    return fireball;
}

function Phase1_Pre()
{
    g_iPhase = 1;

    SetAnimation(A_Phase1_Start);
    Anim_now = "StageEnter";

    local Chest_part = CreateParticle(Vector(0, 0, 0), Nihilant_Phase1, true);

    EntFireByHandle(Chest_part, "SetParent", "!activator", 0.00, g_hModel, g_hModel);
    EntFireByHandle(Chest_part, "SetParentAttachment", "2", 0.10, g_hModel, g_hModel);
    EntFireByHandle(Chest_part, "Kill", "", 10.00, null, null);

    EntFireByHandle(Music, "RunScriptCode", "SetMusic(Music_Nihilanth_Phase1)", 0.00, null, null);

    EntFireByHandle(CreateSound(g_vOrigin_Nihilanth, type_nihilanthphase1_sound), "Kill", "", 20.0, null, null);
    
    g_iHP = CountPlayers(g_hModel.GetOrigin(), g_iDistance_Retarget) * g_iHP_Phase1_perhuman;
} 

function Phase2_Pre()
{
    g_iPhase = 2;
    g_fCD_Attack = 2.0;

    EntFireByHandle(Music, "RunScriptCode", "SetMusic(Music_Nihilanth_Phase2)", 0.00, null, null);

    g_iHP = CountPlayers(g_hModel.GetOrigin(), g_iDistance_Retarget) * g_iHP_Phase2_perhuman;
    g_iHPBack_Phase2 = g_iHP;
    g_iHPrestore_Phase2 = g_iHP - g_iHP * 0.01 * g_iHPRestore_CrystalHeal * (4 - g_ahModel_CrystalHeal.len());

    SetAnimation(A_Phase2_Start);
    Anim_now = "StageEnter";
}

function Phase3_Pre() 
{
    g_iPhase = 3;
    g_fCD_Attack = 1.0;

    g_fTimer_Wall = 0.0;
    g_fTimer_MasSunStrike = 0.0;
    g_fTimer_Shield = 0.0;
    g_fTimer_Laser = 0.0;

    g_bCan_MasSunStrike = false;
    g_bCan_Wall = false;
    g_bCan_Shield = false;
    g_bCan_Laser = false;

    g_bCan_Attacks = false;

    SetAnimation(A_Phase3_Start);
    Anim_now = "StageEnter";

    EntFireByHandle(Music, "RunScriptCode", "SetMusic(Music_Nihilanth_Phase3)", 0.00, null, null);

    local hand_part1 = CreateParticle(Vector(0, 0, 0), Hand_Phase3, false);
    local hand_part2 = CreateParticle(Vector(0, 0, 0), Hand_Phase3, false);
    local Chest_part = CreateParticle(Vector(0, 0, 0), Nihilant_Phase3, false);

    EntFireByHandle(hand_part1, "SetParent", "!activator", 0.00, g_hModel, g_hModel);
    EntFireByHandle(hand_part2, "SetParent", "!activator", 0.00, g_hModel, g_hModel);
    EntFireByHandle(Chest_part, "SetParent", "!activator", 0.00, g_hModel, g_hModel);

    EntFireByHandle(hand_part1, "SetParentAttachment", "1", 0.10, g_hModel, g_hModel);
    EntFireByHandle(hand_part2, "SetParentAttachment", "3", 0.10, g_hModel, g_hModel);
    EntFireByHandle(Chest_part, "SetParentAttachment", "2", 0.10, g_hModel, g_hModel);

    EntFireByHandle(hand_part1, "Start", "", 4.90, null, null);
    EntFireByHandle(hand_part2, "Start", "", 4.90, null, null);
    EntFireByHandle(Chest_part, "Start", "", 4.90, null, null);

    EntFireByHandle(hand_part1, "Kill", "", 11.00, null, null);
    EntFireByHandle(hand_part2, "Kill", "", 11.00, null, null);
    EntFireByHandle(Chest_part, "Kill", "", 12.00, null, null);

    EntFireByHandle(self, "RunScriptCode", "Phase3_Enter();", 8.70, null, null)

    g_iHP = CountPlayers(g_hModel.GetOrigin(), g_iDistance_Retarget) * g_iHP_Phase3_perhuman;
}

function Tick_KillZone()
{   
    if(g_iPhase == 4 && !g_bTicking)
        return;
    local h = null;
    while(null != (h = Entities.FindByClassname(h, "player")))
    {
        if(h.IsValid() && h.GetHealth() > 0)
        {
            if((g_iPhase == 3 && GetDistance2D(g_vOrigin_Nihilanth, h.GetOrigin()) > 3200) || GetDistance2D(g_vOrigin_Nihilanth, h.GetOrigin()) < 700)
                Damage(h, 9999);
        }
    }
    //DebugDrawCircle(g_vOrigin_Nihilanth, Vector(0,255,0), 700, 16, true, 1);
    //DebugDrawCircle(g_vOrigin_Nihilanth, Vector(0,255,0), 3200, 16, true, 1);
    

    EntFireByHandle(self, "RunScriptCode", "Tick_KillZone();", TICKRATE_PHASE3_GRAVITY, null, null)
}

function Phase3_Enter() 
{
    local timer = 0.10;
    EntFire("Nihilanth_Prop_StartRock*", "Kill", "", timer);

    local shockwave = CreateProp(g_vOrigin_ShockWave, type_shockwave_prop);
    EntFireByHandle(CreateSound(g_vOrigin_Nihilanth, type_nihilanthphase3_sound), "Kill", "", 20.0, null, null);
    EntFireByHandle(CreateSound(g_vOrigin_Nihilanth, type_nihilanthphase31_sound), "Kill", "", 6.0, null, null);
    EntFire("Nihilanth_Prop_StartRock_Solid", "Break", "", 0.00);
    EntFireByHandle(shockwave, "SetAnimation", "idle", 0, null, null);
    EntFireByHandle(shockwave, "FadeAndKill", "", 1.00, null, null);

    //EntFire("Nihilanth_Prop_StartRock*", "FadeAndKill", "", 0);
    for(local i = 0; i < g_aszModelName_FlyingRocks.len(); i++)
        Create_FlyingRocks(i);    

    local cyclone = CreateParticle(g_vOrigin_ShockWave - Vector(0, 0, 1200), CycloneSide, true);
    
    for(local i = 0; i < g_avOrigins_Cloud.len(); i++)
        Create_Cloud(i); 
        
    StartTickStick();
    //EntFireByHandle(self, "RunScriptCode", "Phase3_Post();", 0.10, null, null)
}

A_Phase4_End <- "Death"
A_Phase4_Loop <- "Death_loop"
A_Phase4_Start <- "Death_enter"

function Phase4_Enter()
{
    g_iPhase = 4;
    g_fCD_Attack = 0.5;

    Anim_now = "Stage4";
    SetAnimation(A_Phase4_Start);
    SetDefaultAnimation(A_Phase4_Loop);

    EntFireByHandle(Music, "RunScriptCode", "SetMusic(Music_Nihilanth_Phase4)", 0.00, null, null);

    local soundstart = CreateSound(g_vOrigin_Nihilanth, type_nihilanthheadopen_sound);
    EntFireByHandle(soundstart, "PlaySound", "", 5.7, null, null);
    EntFireByHandle(soundstart, "Kill", "", 15.0, null, null);

    g_iHP = CountPlayers(g_hModel.GetOrigin(), g_iDistance_Retarget) * g_iHP_Phase4_perhuman;
}

function BossDead()
{
    g_bTicking = false;

    SetAnimation(A_Phase4_End);

    EntFireByHandle(Music, "RunScriptCode", "SetMusic(Music_Nihilanth_Phase5)", 0.00, null, null);

    EntFireByHandle(CreateProp(g_hModel.GetAttachmentOrigin(g_hModel.LookupAttachment("0")) - Vector(0, 0, 400), type_nihilanthdeath_prop), "FadeAndKill", "", 15.0, null, null);
    local part1 = CreateParticle(Vector(0, 0, 0), Death, true);
    EntFireByHandle(part1, "SetParent", "!activator", 0.00, g_hModel, g_hModel);
    EntFireByHandle(part1, "SetParentAttachment", "0", 0.05, g_hModel, g_hModel);
    
    EntFireByHandle(CreateSound(g_vOrigin_Nihilanth, type_nihilanthphase4_sound), "Kill", "", 20.0, null, null);


    g_bTickingGravity = true;

    EntFire("fade3", "Fade", "", 12.0, null);
    EntFire("GameText_A", "AddOutput", "message Map made by Trazix", 14.5, null);
    EntFire("GameText_A", "Display", "", 15.0, null);
    EntFire("game_text2", "Display", "", 16.5, null);
    EntFire("game_text2bis", "Display", "", 17.5, null);

    EntFireByHandle(self, "RunScriptCode", "TickGravity()", 9.00, null, null);
    EntFireByHandle(self, "RunScriptCode", "g_bTickingGravity = false; TeleportWin()", 18.00, null, null);
}

function TeleportWin()
{
    local h = null;
    while(null != (h = Entities.FindInSphere(h, g_hModel.GetOrigin(), 99999)))
    {
        if(h.GetClassname() == "player" && 
            h.IsValid() &&
            h.GetHealth() > 0 &&
            h.GetTeam() == 3)
        {
            h.SetOrigin(Vector(3976 11510 1402));
        }
    }
}

function TickGravity()
{
    if(!g_bTickingGravity)
        return;
    local power = 370;
    local h = null;
    local nVeloc 
    while(null != (h = Entities.FindInSphere(h, g_hModel.GetOrigin(), 99999)))
    {
        if(h.GetClassname() == "player" && 
            h.IsValid() &&
            h.GetHealth() > 0 &&
            h.GetTeam() == 3)
        {
            nVeloc = (g_hModel.GetOrigin() + Vector(0, 0, 150) - h.GetOrigin());
            nVeloc.Norm();

            if(TraceLine(h.GetOrigin(),h.GetOrigin() + Vector(0,0,-32), null) != 1.00)
            {
                h.SetVelocity(Vector(nVeloc.x * power, nVeloc.y * power, power));
            }
            else
            {
                h.SetVelocity(Vector(nVeloc.x * power, nVeloc.y * power, nVeloc.z * power));
            }
        }
    }

    EntFireByHandle(self, "RunScriptCode", "TickGravity()", TICKRATE_GRAVITY, null, null);
}

function Create_Cloud(ID) 
{
    local model = CreateProp(g_avOrigins_Cloud[ID], type_cloud_prop, ID);
    EntFireByHandle(model, "SetAnimation", "intro", 0.00, null, null);
    EntFireByHandle(model, "SetDefaultAnimation", "idle", 0.00, null, null);
}

function Create_FlyingRocks(ID) 
{
    local timer = 0.10
    local model = CreateProp(g_vPos_FlyingRocks.origin, type_flyingrock_prop, ID);
    model.SetAngles(g_vPos_FlyingRocks.ax, g_vPos_FlyingRocks.ay, g_vPos_FlyingRocks.az);
    EntFireByHandle(model, "SetAnimation", "cinephys", timer + 0.00, null, null);
    EntFireByHandle(model, "FadeAndKill", "", timer + 4.10, null, null);
}

function Create_Stick(ID) 
{
    local model = CreateProp(g_avPos_Stick[ID].origin, type_stick_prop)
    model.SetAngles(g_avPos_Stick[ID].ax, g_avPos_Stick[ID].ay, g_avPos_Stick[ID].az);
    model.__KeyValueFromString("targetname", "Nihilanth_Prop_Stick" + ID);
    local sprite = CreateSprite(g_avOrigins_StickGlow[ID], type_stick_sprite);
    sprite.__KeyValueFromString("targetname", "Nihilanth_Sprite_Stick" + ID);
}

const TICKRATE_STICK = 1.00;
g_bTicking_Stick <- false;

function StartTickStick()
{
    g_bTicking_Stick = true;
    TickStick();
}

function TickStick()
{
    OneTickStick();
    if(g_bTicking_Stick)
        EntFireByHandle(self, "RunScriptCode", "TickStick()", TICKRATE_STICK, null, null)
}


function OneTickStick() 
{
    if(g_iPhase == 2)
    {
        EntFire("Nihilanth_Sprite_Stick*", "Color", "255 255 0", 0);
        EntFire("Nihilanth_Prop_Stick*", "Skin", "1", 0);
    }
    else if(g_iPhase >= 3)
    {
        if(g_bStatus_Glow)
        {
            g_bStatus_Glow = false;

            for(local i = 0; i < g_avPos_Stick.len(); i++) 
            {
                local delay = RandomFloat(0.0, TICKRATE_STICK);
                EntFire("Nihilanth_Sprite_Stick" + i, "Color", "255 0 0", delay);
                EntFire("Nihilanth_Prop_Stick" + i, "Skin", "2", delay);
            }
            
        }
        else
        {
            g_bStatus_Glow = true;

            for(local i = 0; i < g_avPos_Stick.len(); i++) 
            {
                local delay = RandomFloat(0.0, TICKRATE_STICK);
                EntFire("Nihilanth_Sprite_Stick" + i, "Color", "0 0 0", delay);
                EntFire("Nihilanth_Prop_Stick" + i, "Skin", "3", delay);
            }
        }
    }
}

function Create_Crystal() 
{
    local model = CreateProp(g_avOrigins_CrystalHeal[g_ahModel_CrystalHeal.len()], type_crystal_prop)
    local sprite = CreateSprite(Vector(0, 0, 0), type_crystal_sprite);
    local lightd = CreateLightd(Vector(0, 0, 0), type_crystal_light);
    local startparticle = CreateParticle(Vector(0, 0, 0), Pylon_Rise);
    local idleparticle = CreateParticle(Vector(0, 0, 0), Pylon_Deploy);
    local beam = CreateBeam(g_avOrigins_CrystalHeal[g_ahModel_CrystalHeal.len()] + Vector(0, 0, 400), type_crystal_beam);
    //local sound = CreateSound(g_avOrigins_CrystalHeal[g_ahModel_CrystalHeal.len()] + Vector(0, 0, 400), type_nihilanthcrystalstart_sound);

    model.__KeyValueFromString("targetname", "Nihilanth_Prop_CrystalHeal" + g_ahModel_CrystalHeal.len());
    sprite.__KeyValueFromString("targetname", "Nihilanth_Sprite_CrystalHeal" + g_ahModel_CrystalHeal.len());
    lightd.__KeyValueFromString("targetname", "Nihilanth_Lightd_CrystalHeal" + g_ahModel_CrystalHeal.len());
    startparticle.__KeyValueFromString("targetname", "Nihilanth_Particle_CrystalHeal_Start" + g_ahModel_CrystalHeal.len());
    idleparticle.__KeyValueFromString("targetname", "Nihilanth_Particle_CrystalHeal_Idle" + g_ahModel_CrystalHeal.len());
    beam.__KeyValueFromString("targetname", "Nihilanth_Beam_CrystalHeal" + g_ahModel_CrystalHeal.len());
    //sound.__KeyValueFromString("targetname", "Nihilanth_Sound_CrystalHeal" + g_ahModel_CrystalHeal.len());

    EntFireByHandle(lightd, "SetParent", "!activator", 0.00, model, model);
    EntFireByHandle(lightd, "SetParentAttachment", "crystal", 0.05, model, model);
    EntFireByHandle(sprite, "SetParent", "!activator", 0.00, model, model);
    EntFireByHandle(sprite, "SetParentAttachment", "crystal", 0.05, model, model);

    EntFireByHandle(startparticle, "SetParent", "!activator", 0.00, model, model);
    EntFireByHandle(startparticle, "SetParentAttachment", "crystal", 0.05, model, model);

    EntFireByHandle(idleparticle, "SetParent", "!activator", 0.00, model, model);
    EntFireByHandle(idleparticle, "SetParentAttachment", "crystal", 0.05, model, model);

    // EntFireByHandle(beam, "SetParent", "!activator", 0.00, model, model);
    // EntFireByHandle(beam, "SetParentAttachment", "crystal", 0.05, model, model);

    EntFireByHandle(model, "AddOutPut", "OnHealthChanged " + self.GetName() + ":RunScriptCode:Damage_Crystal():0:-1", 0.01, null, null);

    return model;
}

function TeleportToArea(bNkill = true)
{
    local vOrigin = g_avOrigins_TeleportBoys[((g_iID_TeleportBoys++ >= g_avOrigins_TeleportBoys.len() - 1) ? (g_iID_TeleportBoys = 0) : g_iID_TeleportBoys)];

    if(activator.GetTeam() == 3)
    {
        if(bNkill)
            return Damage(activator, 99999);

        activator.SetOrigin(Vector(-7174, 1510, -446));
        EntFireByHandle(activator, "SetDamageFilter", "No_T", 0, null, null);
    }
    else if(activator.GetTeam() == 2)
    {
        activator.SetOrigin(Vector(-9164, -483, 46));
        EntFireByHandle(activator, "SetDamageFilter", "No_CT", 0, null, null);
    }

    local camera = Entities.CreateByClassname("point_viewcontrol");
    camera.SetOrigin(Vector(-7835, 973, -60));
    camera.SetAngles(0, 140, 0);
    camera.__KeyValueFromInt("spawnflags", 128);
    camera.__KeyValueFromInt("fov_rate", 1);
    camera.__KeyValueFromInt("wait", 5);

    camera.__KeyValueFromInt("fov", 160);

    EntFireByHandle(camera, "Enable", "", 0, activator, activator);
    EntFireByHandle(camera, "Disable", "", 3.99, activator, activator);
    EntFireByHandle(camera, "Kill", "", 4.0, activator, activator);
    
    EntFireByHandle(activator, "RunScriptCode", "self.SetOrigin(Vector(" + vOrigin.x + "," + vOrigin.y + "," + vOrigin.z + "))", 4.0, null, null);
}

function Cast_Tele() 
{
    local origins = g_avOrigins_Tele.slice(0,g_avOrigins_Tele.len());
    local origin = [];
    local count = 2;
    if(g_iPhase < 2)
        count = RandomInt(g_iCount_Tele1[0], g_iCount_Tele1[1]);
    else if(g_iPhase < 3)
        count = RandomInt(g_iCount_Tele2[0], g_iCount_Tele2[1]);
    else if(g_iPhase < 4)
        count = RandomInt(g_iCount_Tele3[0], g_iCount_Tele3[1]);

    if(count > 1)
    {
        for(local i = 0; i < count; i++)
        {
            local random = RandomInt(0, origins.len() - 1);
            origin.push(origins[random]);
            origins.remove(random);
        }
    }
    else
        origin.push(origins[RandomInt(0, origins.len() - 1)])

    local delay = 1.0;

    for(local i = 0; i < count; i++)
    {
        EntFireByHandle(Prop_temp, "RunScriptCode", "CreatePropTele(Vector(" + origin[i].x + "," + origin[i].y + "," +( origin[i].z + RandomInt(g_iOriginZ_Tele[0], g_iOriginZ_Tele[1]))+ "));", delay, null, null);
        delay += g_fDelay_Tele;
    }

    SetAnimation(A_Summon_End, delay + 1.0);
    SetDefaultAnimation(A_Idle, delay);

    EntFireByHandle(self, "RunScriptCode", "Cast_Tele_Post();", delay + 2.2, null, null);
}

function Cast_Tele_Post() 
{
    Anim_now = "Tele";
    if(RandomBool())
        SetAnimation(A_TeleRight);
    else
        SetAnimation(A_TeleLeft);

    local soundstart = CreateSound(g_vOrigin_Nihilanth, type_nihilanthtele_sound);
    EntFireByHandle(soundstart, "PlaySound", "", 3.15, null, null);
    //EntFireByHandle(soundstart, "Volume", "0", 7.2, null, null);
    EntFireByHandle(soundstart, "Kill", "", 5.0, null, null);
}

function GetRandomTarget(origin, radius) 
{
    local h = null;
    while(null != (h = Entities.FindInSphere(h, origin, radius)))
    {
        if(h.GetClassname() == "player" && 
            h.IsValid() && 
            h.GetHealth() > 0 &&
            h.GetTeam() == 3)
        return h;
    }    
    return null;
}

function TickMove() 
{
    if(Anim_now == "Stage4")
        return;

    if(Anim_now != "StageEnter" && Anim_now != "Heal" && Anim_now != "Heal_End")
        MoveToTarget();
    
    if(g_bTicking)
        EntFireByHandle(self, "RunScriptCode", "TickMove()", TICKRATE_MOVE, null, null)
}

function MoveToTarget() 
{
    if(!ValidTarget(g_hTarget, 3))
        return;
    local first = g_hModel.GetAngles().y;
    local second = GetPithYawFVect3D(g_hModel.GetOrigin(), g_hTarget.GetOrigin());
    local newDir = MoveDir(first, second, g_fIter_Angles);
    g_hModel.SetAngles(0, newDir, 0)
}

{
    function MoveDir(c1, c2, mod)
    {
        local c3 = 0.00 + c1;

        local c4 = abs((c3 - c2 + 360) % 360);
        if(c3 >= 355)
            c3 = 0;
        if(c3 <= -355)
            c3 = 0;
        local c5 = (c2 + 180) - (c1 + 360) % 360;
        local c6 = mod * 1.5; 
        if(c5 > c6 ||
        c5 < -c6)
        {
            if(c4 <= 180)
                return c3 + mod;
            return c3 - mod;
        }
        return c3;
    }
}

function SearchTarget()
{
    local array = [];
    local h = null;
    g_hTarget = null;
    g_fTimer_Retarget = 0.00;
    while( null != ( h = Entities.FindInSphere( h, g_hModel.GetOrigin(), g_iDistance_Retarget)))
    {
        if(h.GetClassname() == "player" && h.GetTeam() == 3 && h.GetHealth() > 0)
        {
            array.push(h);
        }
    }
    if(array.len() <= 0)
        return g_hTarget = null;
    return g_hTarget = array[RandomInt(0, array.len() - 1)]
}


A_Idle <- "idle_calm";

Anim_now <- "";
Anim_default <- "";

function SetAnimIdle() 
{
    if(Anim_now != "idle")
    {
        SetAnimation(A_Idle);
        SetDefaultAnimation(A_Idle);
    }
    Anim_now = "idle";
}

function SetAnimSummon() 
{
    if(Anim_now != "Summon")
    {
        SetAnimation(A_Summon_Start);
        SetDefaultAnimation(A_Summon_Loop);
    }
    Anim_now = "Summon";
}

function SetAnimation(animationName,time = 0)
{
    EntFireByHandle(g_hModel, "SetAnimation", animationName, time, null, null);
}

function SetDefaultAnimation(animationName,time = 0)
{
    EntFireByHandle(g_hModel, "SetDefaultAnimation", animationName, time, null, null);
}

/*anims block
Intro //spawn

Idle_Calm

+ Attack1//sunstrike
mass sunstike > 1 phases

Attack_telekenesis_left
Attack_telekenesis_right

Phase2_Enter    //go to phase 2
//after phase 1 if destroy all crystal

Heal_Begin //cast
Heal_Loop  //
Heal_End   //end cast

Heal_Interrupted//bad heal

Attack_Zap//spawn small balls

Attack_TeleProp_Enter
Attack_TeleProp //loop
Attack_TeleProp_End

Attack_BeamSwipe//it's lasers kek

Attack_Ballz_p3//spawn another ball's like ror

Phase3_Enter    //go to phase 3
//after phase 2 if destroy all crystal

Attack2//beam
Attack3//power attack

Attack_Zap_buffed//spawn big ball

Attack_Summon_Enter
Attack_Summon//loop
Attack_Summon_End

Attack_Ballz_out//laser all side's

Death_enter//start anim
Death_loop
*/