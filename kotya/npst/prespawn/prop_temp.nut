::Prop_temp <- self;
::g_hPropMaker <- Entities.CreateByClassname("env_entity_maker")
g_hPropMaker.__KeyValueFromString("EntityTemplate", self.GetName());

::g_szPropPreset_phys <- {};
::g_szPropPreset_dynam <- {};

::g_telePropTele <- [];
::type_tele_prop <- "tele";
::type_crystal_prop <- "crystal";
::type_stick_prop <- "stick";
::type_startrock_prop <- "startrock";
::type_flyingrock_prop <- "flyingrock";
::type_shockwave_prop <- "shockwave";
::type_cloud_prop <- "cloud";
::type_laser_prop <- "laser";
::type_parent_prop <- "parent";
::type_shield_prop <- "shield";
::type_rockattack_prop <- "rockattack";
::type_barnacle_prop <- "barnacle";
::type_nihilanthdeath_prop <- "nihilanthdeath";
::type_manta_prop <- "vishnyapidor";
::type_sniper_prop <- "sniper";
::type_sniperhbox_prop <- "sniperhbox";
::type_sniperbullet_prop <- "sniperhbullet";
::type_lasertrap_prop <- "lasertrap";
::type_heal_prop <- "healprop";
::type_human_turret_prop <- "humanturret";
function CreatePropTele(origin = null) 
{
    if(origin == null)
        origin = Vector(-1092, 375, 53);
    g_telePropTele.push(g_teleaPreset[RandomInt(0, g_teleaPreset.len() - 1)]);

    local part = CreateParticle(origin, Teleprop_start, true);
    local part = CreateParticle(origin, Teleprop_start, true);
    EntFireByHandle(part, "Kill", "", 2.0, null, null);

    EntFireByHandle(self, "RunScriptCode", "CreateProp(Vector(" + origin.x + "," + origin.y + "," + origin.z + "), type_tele_prop," + (g_telePropTele.len() - 1) + ")", 1.0, null, null);
}

::CreateProp <- function(origin, Preset = null, ID = -1) 
{
    if(Preset == null)
        return;

    local prop;

    if(Preset == type_crystal_prop)
    {
        g_szPropPreset_dynam = {
            model = CrystalHeal_Model,
            lightingorigin = "Nihilanth_Prop_Model",
            disableshadows = 0,
            damagefilter = "Only_CT",
        };
        g_szPropPreset_phys = {};

        g_hPropMaker.SpawnEntityAtLocation(origin, Vector(0,0,0));

        prop = Entities.FindByName(null, "physics_temp");

        if(prop != null && prop.IsValid())
            prop.Destroy();

        prop = Entities.FindByName(null, "dynamic_temp");
        prop.__KeyValueFromString("targetname", "Nihilanth_Prop_CrystalHeal");
    }

    else if(Preset == type_shield_prop)
    {
        g_szPropPreset_dynam = {
            model = Shield_Model,
            //disableshadows = 0,
            damagefilter = "Only_CT",
        };
        g_szPropPreset_phys = {};

        g_hPropMaker.SpawnEntityAtLocation(origin, Vector(0, 0, 0));

        prop = Entities.FindByName(null, "physics_temp");

        if(prop != null && prop.IsValid())
            prop.Destroy();

        prop = Entities.FindByName(null, "dynamic_temp");
        prop.__KeyValueFromString("targetname", "Nihilanth_Prop_Shield");
    }

    else if(Preset == type_lasertrap_prop)
    {
        g_szPropPreset_dynam = {
            model = LaserTrap_Model,
            disableshadows = 0,
            //solid = 0,
        };
        g_szPropPreset_phys = {};

        g_hPropMaker.SpawnEntityAtLocation(origin, Vector(0, 0, 0));

        prop = Entities.FindByName(null, "physics_temp");

        if(prop != null && prop.IsValid())
            prop.Destroy();

        prop = Entities.FindByName(null, "dynamic_temp");
        prop.__KeyValueFromString("targetname", "LaserTrap_Prop_Start" + Time());
    }

    else if(Preset == type_sniperhbox_prop)
    {
        g_szPropPreset_dynam = {
            model = Shield_Model,
            disableshadows = 0,
            rendermode = 10,
            damagefilter = "Only_CT",
        };
        g_szPropPreset_phys = {};

        g_hPropMaker.SpawnEntityAtLocation(origin, Vector(0, 0, 0));

        prop = Entities.FindByName(null, "physics_temp");

        if(prop != null && prop.IsValid())
            prop.Destroy();

        prop = Entities.FindByName(null, "dynamic_temp");
        prop.__KeyValueFromString("targetname", "Sniper_Hbox" + Time());
    }

    else if(Preset == type_sniperbullet_prop)
    {
        g_szPropPreset_dynam = {
            model = SniperBullet_Model,
            disableshadows = 0,
            rendermode = 1,
            rendercolor = "255 255 0",
        };
        g_szPropPreset_phys = {};

        g_hPropMaker.SpawnEntityAtLocation(origin, Vector(0, 0, 0));

        prop = Entities.FindByName(null, "physics_temp");

        if(prop != null && prop.IsValid())
            prop.Destroy();

        prop = Entities.FindByName(null, "dynamic_temp");
        prop.__KeyValueFromString("targetname", "dynamic_temp" + Time());
    }

    else if(Preset == type_heal_prop)
    {
        g_szPropPreset_dynam = {
            model = MedicBag_Model,
            disableshadows = 1,
            rendermode = 1,
            disableflashlight = 1,
            disableshadowdepth = 1,
            solid = 0,
        };
        g_szPropPreset_phys = {};

        g_hPropMaker.SpawnEntityAtLocation(origin, Vector(0, 0, 0));

        prop = Entities.FindByName(null, "physics_temp");

        if(prop != null && prop.IsValid())
            prop.Destroy();

        prop = Entities.FindByName(null, "dynamic_temp");
        prop.__KeyValueFromString("targetname", "dynamic_temp" + Time());
    }

    else if(Preset == type_startrock_prop)
    {
        g_szPropPreset_dynam = {
            model = g_aszModelName_StartRocks[ID],
            //disableshadows = 0,
        };
        g_szPropPreset_phys = {};

        g_hPropMaker.SpawnEntityAtLocation(origin, Vector(0,0,0));

        prop = Entities.FindByName(null, "physics_temp");

        if(prop != null && prop.IsValid())
            prop.Destroy();

        prop = Entities.FindByName(null, "dynamic_temp");
        prop.__KeyValueFromString("targetname", "Nihilanth_Prop_StartRock"+ID);
    }

    else if(Preset == type_rockattack_prop)
    {
        g_szPropPreset_dynam = {
            model = AttackRock_Model,
            //disableshadows = 1,
            lightingorigin = "Nihilanth_Prop_Model",
        };
        g_szPropPreset_phys = {};

        g_hPropMaker.SpawnEntityAtLocation(origin.origin, origin.angles);

        prop = Entities.FindByName(null, "physics_temp");

        if(prop != null && prop.IsValid())
            prop.Destroy();

        prop = Entities.FindByName(null, "dynamic_temp");
        prop.__KeyValueFromString("targetname", "Nihilanth_Prop_AttackRock");
    }
    

    else if(Preset == type_manta_prop)
    {
        g_szPropPreset_dynam = {
            model = Manta_Model,
            solid = 0,
            rendermode = 2,
            disableshadows = 1,
            DefaultAnim = "idle",
            vscripts = "kotya/npst/prespawn/alpha.nut",
            parentname = ID,
            StartDisabled = 1,
        };
        g_szPropPreset_phys = {};

        g_hPropMaker.SpawnEntityAtLocation(origin.origin, origin.angles);

        prop = Entities.FindByName(null, "physics_temp");

        if(prop != null && prop.IsValid())
            prop.Destroy();
        
        prop = Entities.FindByName(null, "dynamic_temp");
        prop.__KeyValueFromString("targetname", "Manta_Prop");
    }

    else if(Preset == type_laser_prop)
    {
        g_szPropPreset_dynam = {
            model = Laser_Model,
            solid = 0,
            vscripts = "kotya/npst/nihilanth/laser.nut",
            disableshadows = 1,
        };
        g_szPropPreset_phys = {};

        g_hPropMaker.SpawnEntityAtLocation(origin.origin, origin.angles);

        prop = Entities.FindByName(null, "physics_temp");

        if(prop != null && prop.IsValid())
            prop.Destroy();

        prop = Entities.FindByName(null, "dynamic_temp");
        prop.__KeyValueFromString("targetname", "Laser_Prop");
    }

    else if(Preset == type_cloud_prop)
    {
        g_szPropPreset_dynam = {
            model = g_aszModelName_Cloud[ID],
            solid = 0,
            disableshadows = 1,
        };
        g_szPropPreset_phys = {};

        g_hPropMaker.SpawnEntityAtLocation(origin, Vector(0,0,0));

        prop = Entities.FindByName(null, "physics_temp");

        if(prop != null && prop.IsValid())
            prop.Destroy();

        prop = Entities.FindByName(null, "dynamic_temp");
        prop.__KeyValueFromString("targetname", "Nihilanth_Prop_Wind");
    }

    else if(Preset == type_nihilanthdeath_prop)
    {
        g_szPropPreset_dynam = {
            model = Nihilanth_HeadCrystal_Model,
            solid = 0,
            disableshadows = 1,
            DefaultAnim = "cinephys",
        };
        g_szPropPreset_phys = {};

        g_hPropMaker.SpawnEntityAtLocation(origin, Vector(0,0,0));

        prop = Entities.FindByName(null, "physics_temp");

        if(prop != null && prop.IsValid())
            prop.Destroy();

        prop = Entities.FindByName(null, "dynamic_temp");
        prop.__KeyValueFromString("targetname", "Nihilanth_Prop_Model");
    }

    else if(Preset == type_human_turret_prop)
    {
        g_szPropPreset_dynam = {
            model = Human_Turret_Model,
            solid = 0,
            disableshadows = 1,
            vscripts = "kotya/npst/human_turret/human_turret.nut",
        };
        g_szPropPreset_phys = {};

        g_hPropMaker.SpawnEntityAtLocation(origin.origin, origin.angles);

        prop = Entities.FindByName(null, "physics_temp");

        if(prop != null && prop.IsValid())
            prop.Destroy();

        prop = Entities.FindByName(null, "dynamic_temp");
        prop.__KeyValueFromString("targetname", "Human_Turret_Model" + Time());
    }

    else if(Preset == type_sniper_prop)
    {
        g_szPropPreset_dynam = {
            model = Sniper_Model,
            solid = 0,
            disableshadows = 1,
            vscripts = "kotya/npst/sniper/sniper.nut",
        };
        g_szPropPreset_phys = {};

        g_hPropMaker.SpawnEntityAtLocation(origin.origin, origin.angles);

        prop = Entities.FindByName(null, "physics_temp");

        if(prop != null && prop.IsValid())
            prop.Destroy();

        prop = Entities.FindByName(null, "dynamic_temp");
        prop.__KeyValueFromString("targetname", "Sniper_Model" + Time());
    }
    
    else if(Preset == type_parent_prop)
    {
        g_szPropPreset_dynam = {
            model = Parent_Model,
            solid = 0,
            disableshadows = 1,
            rendermode = 10,
        };

        g_szPropPreset_phys = {};

        g_hPropMaker.SpawnEntityAtLocation(origin, Vector(0,0,0));

        prop = Entities.FindByName(null, "physics_temp");

        if(prop != null && prop.IsValid())
            prop.Destroy();

        prop = Entities.FindByName(null, "dynamic_temp");
        prop.__KeyValueFromString("targetname", "Parent" + Time());
    }

    else if(Preset == type_shockwave_prop)
    {
        g_szPropPreset_dynam = {
            model = ShockWave_Model,
            solid = 0,
        };
        g_szPropPreset_phys = {};

        g_hPropMaker.SpawnEntityAtLocation(origin, Vector(0,0,0));

        prop = Entities.FindByName(null, "physics_temp");

        if(prop != null && prop.IsValid())
            prop.Destroy();

        prop = Entities.FindByName(null, "dynamic_temp");
        prop.__KeyValueFromString("targetname", "Nihilanth_Prop_ShockWave");
    }

    else if(Preset == type_flyingrock_prop)
    {
        g_szPropPreset_dynam = {
            model = g_aszModelName_FlyingRocks[ID],
            solid = 0,
        };
        g_szPropPreset_phys = {};

        g_hPropMaker.SpawnEntityAtLocation(origin, Vector(0,0,0));

        prop = Entities.FindByName(null, "physics_temp");

        if(prop != null && prop.IsValid())
            prop.Destroy();

        prop = Entities.FindByName(null, "dynamic_temp");
        prop.__KeyValueFromString("targetname", "Nihilanth_Prop_FlyingRock");
    }

    else if(Preset == type_stick_prop)
    {
        g_szPropPreset_dynam = {
            model = Stick_Model,
            disableshadows = 0,
            skin = 0,
        };
        g_szPropPreset_phys = {};

        g_hPropMaker.SpawnEntityAtLocation(origin, Vector(0,0,0));

        prop = Entities.FindByName(null, "physics_temp");

        if(prop != null && prop.IsValid())
            prop.Destroy();

        prop = Entities.FindByName(null, "dynamic_temp");
        prop.__KeyValueFromString("targetname", "Nihilanth_Prop_Stick");
    }

    else if(Preset == type_barnacle_prop)
    {
        g_szPropPreset_dynam = {
            model = Barnacle_Model,
            disableshadows = 0,
            DefaultAnim = "idle01",
            vscripts = "kotya/npst/barnacle/barnacle.nut",
        };
        g_szPropPreset_phys = {};

        g_hPropMaker.SpawnEntityAtLocation(origin, Vector(0,0,0));

        prop = Entities.FindByName(null, "physics_temp");

        if(prop != null && prop.IsValid())
            prop.Destroy();

        prop = Entities.FindByName(null, "dynamic_temp");
        prop.__KeyValueFromString("targetname", "Barnacle_Model");
    }

    else if(Preset == type_tele_prop)
    {
        g_szPropPreset_phys = {
            model = g_telePropTele[ID].modelname,
            spawnflags = 15,
            damagefilter = "No_Damage",
        };
        g_szPropPreset_dynam = {};

        g_hPropMaker.SpawnEntityAtLocation(origin + g_telePropTele[ID].origin, Vector(0,0,0));

        prop = Entities.FindByName(null, "dynamic_temp");
        if(prop != null && prop.IsValid())
            prop.Destroy();

        prop = Entities.FindByName(null, "physics_temp");
        prop.__KeyValueFromString("targetname", "Nihilanth_Phisics_Tele");

        EntFireByHandle(prop, "RunScriptFile", "kotya/npst/nihilanth/teleprop.nut", 0.00, null, null);
        EntFireByHandle(prop, "RunScriptCode", 
        "g_iRadius = " + g_telePropTele[ID].radius + 
        ";g_bFade = " + g_telePropTele[ID].fade + 
        ";g_iDamage = " + g_telePropTele[ID].damage + ";", 0.01, null, null);
    }
    
    return prop;
}

function PreSpawnInstance(entityClass, entityName)
{
    local keyvalues = {};
    
    if(entityClass == "prop_physics")
    {
        if(g_szPropPreset_phys != {})
        {
            foreach(k,v in g_szPropPreset_phys)//thanks OrelStealth for this code
            {
                keyvalues[k] <- v;
            }
        }

        g_szPropPreset_phys = {};
    }
    if(entityClass == "prop_dynamic")
    {
        if(g_szPropPreset_dynam != {})
        {
            foreach(k,v in g_szPropPreset_dynam)//thanks OrelStealth for this code
            {
                keyvalues[k] <- v;
            }
        }

        g_szPropPreset_dynam = {};
    }

	return keyvalues
}