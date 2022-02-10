::Lightd_temp <- self;
::g_hLightdMaker <- Entities.CreateByClassname("env_entity_maker")
g_hLightdMaker.__KeyValueFromString("EntityTemplate", self.GetName());

::g_szLightdPreset <- {};

::type_default_light <- "lightd"
::type_crystal_light <- "crystal"
::type_crystal_laser <- "laser"

::type_sunstrike1_light <- "sunstrike1"
::type_sunstrike3_light <- "sunstrike3"

::type_finalflash_light <- "finalflash"
::type_beam_light <- "beam";
::type_fireball_light <- "fireball";
::type_snipershot_light <- "snipershoot";

::CreateLightd <- function(origin, Preset = null, id = -1) 
{
    if(Preset == null)
        return;

    local lightd;

    if(Preset == type_crystal_light)
    {
        g_szLightdPreset = {
            _core = 0,                  //not work
            _inner_core = 0,            //not work
            _light = "255 128 0 750",
            brightness = 10,
            distance = 600,
            pitch = 90,
        };

        g_hLightdMaker.SpawnEntityAtLocation(origin, Vector(0,0,0));

        lightd = Entities.FindByName(null, "lightd_temp");
        lightd.__KeyValueFromString("targetname", "Nihilanth_Lightd_CrystalHeal");

        EntFireByHandle(lightd, "TurnOff", "", 0.00, null, null);
    }

    else if(Preset == type_beam_light)
    {
        g_szLightdPreset = {
            _core = 0,                  //not work
            _inner_core = 0,            //not work
            _light = "255 128 0 600",
            brightness = 7,
            distance = 450,
            pitch = 90,
        };

        g_hLightdMaker.SpawnEntityAtLocation(origin, Vector(0,0,0));

        lightd = Entities.FindByName(null, "lightd_temp");
        lightd.__KeyValueFromString("targetname", "Nihilanth_Lightd_Beam");

        EntFireByHandle(lightd, "TurnOff", "", 0.00, null, null);
    }
    
    else if(Preset == type_default_light)
    {
        g_szLightdPreset = {
            _core = 0,                  //not work
            _inner_core = 0,            //not work
            _light = "255 255 255 5000",
            brightness = 50,
            distance = 1000,
            pitch = -90,
        };

        g_hLightdMaker.SpawnEntityAtLocation(origin, Vector(0,0,0));

        lightd = Entities.FindByName(null, "lightd_temp");
        lightd.__KeyValueFromString("targetname", "lightd_temp" + Time());

        EntFireByHandle(lightd, "TurnOn", "", 0.00, null, null);
    }

    else if(Preset == type_sunstrike1_light)
    {
        g_szLightdPreset = {
            _core = 0,                  //not work
            _inner_core = 0,            //not work
            _light = "255 167 14 320",
            brightness = 10,
            distance = 320,
            pitch = 90,
        };

        g_hLightdMaker.SpawnEntityAtLocation(origin, Vector(0,0,0));

        lightd = Entities.FindByName(null, "lightd_temp");
        lightd.__KeyValueFromString("targetname", "SunStike1_Lightd");

        EntFireByHandle(lightd, "TurnOn", "", 0.00, null, null);
    }

    else if(Preset == type_snipershot_light)
    {
        g_szLightdPreset = {
            _core = 0,                  //not work
            _inner_core = 0,            //not work
            _light = "255 255 0 420",
            brightness = 8,
            distance = 330,
            pitch = 90,
        };

        g_hLightdMaker.SpawnEntityAtLocation(origin, Vector(0,0,0));

        lightd = Entities.FindByName(null, "lightd_temp");
        lightd.__KeyValueFromString("targetname", "lightd_temp" + Time());

        EntFireByHandle(lightd, "TurnOn", "", 0.00, null, null);
    }

    else if(Preset == type_fireball_light)
    {
        g_szLightdPreset = {
            _core = 0,                  //not work
            _inner_core = 0,            //not work
            _light = "255 167 100 160",
            brightness = 8,
            distance = 160,
            pitch = 90,
        };

        g_hLightdMaker.SpawnEntityAtLocation(origin, Vector(0,0,0));

        lightd = Entities.FindByName(null, "lightd_temp");
        lightd.__KeyValueFromString("targetname", "SunStike1_Lightd");

        EntFireByHandle(lightd, "TurnOn", "", 0.00, null, null);
    }

    else if(Preset == type_finalflash_light)
    {
        g_szLightdPreset = {
            _core = 0,                  //not work
            _inner_core = 0,            //not work
            _light = "0 128 255 1000",
            brightness = 8,
            distance = 1000,
            pitch = -90,
        };

        g_hLightdMaker.SpawnEntityAtLocation(origin, Vector(0,0,0));

        lightd = Entities.FindByName(null, "lightd_temp");
        lightd.__KeyValueFromString("targetname", "FinalFlash_Lightd");

        EntFireByHandle(lightd, "TurnOn", "", 0.00, null, null);
    }

    else if(Preset == type_sunstrike3_light)
    {
        g_szLightdPreset = {
            _core = 0,                  //not work
            _inner_core = 0,            //not work
            _light = "255 167 14 400",
            brightness = 8,
            distance = 400,
            pitch = 90,
        };

        g_hLightdMaker.SpawnEntityAtLocation(origin, Vector(0,0,0));

        lightd = Entities.FindByName(null, "lightd_temp");
        lightd.__KeyValueFromString("targetname", "SunStike3_Lightd");

        EntFireByHandle(lightd, "TurnOn", "", 0.00, null, null);
    }

    else if(Preset == type_crystal_laser)
    {
        g_szLightdPreset = {
            _core = 0,                  //not work
            _inner_core = 0,            //not work
            _light = "255 0 0 320",
            brightness = 10,
            distance = 320,
            pitch = 90,
        };

        g_hLightdMaker.SpawnEntityAtLocation(origin, Vector(0,0,0));

        lightd = Entities.FindByName(null, "lightd_temp");
        lightd.__KeyValueFromString("targetname", "Laser_Lightd");

        EntFireByHandle(lightd, "TurnOn", "", 0.00, null, null);
    }
 
    return lightd;
}
function PreSpawnInstance(entityClass, entityName)
{
    local keyvalues = {};
    
    if(entityClass == "light_dynamic")
    {
        if(g_szLightdPreset != {})
        {
            foreach(k,v in g_szLightdPreset)//thanks OrelStealth for this code
            {
                keyvalues[k] <- v;
            }
        }

        g_szLightdPreset = {};
    }

	return keyvalues
}