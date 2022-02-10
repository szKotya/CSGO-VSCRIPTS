

::Sound_temp <- self;
::g_hSoundMaker <- Entities.CreateByClassname("env_entity_maker")
g_hSoundMaker.__KeyValueFromString("EntityTemplate", self.GetName());

::g_szSoundPreset <- {};

::type_sniperdeath_sound <- "sniperdeath";
::type_snipershoot_sound <- "snipershoot";
::type_sniperreload_sound <- "sniperreload";

::type_nihilanthbeamstart_sound <- "nihilanthbeamstart";
::type_nihilanthbeamend_sound <- "nihilanthbeamend";

::type_nihilanthcrystalstart_sound <- "crystalstart";
::type_nihilanthcrystalend_sound <- "crystalend";
::type_nihilanthfinalflash_sound <- "finalflash";
::type_nihilanthheadopen_sound <- "headopen";

::type_nihilanthphase1_sound <- "phase1";
::type_nihilanthphase4_sound <- "phase4";

::type_nihilanthphase3_sound <- "phase3";
::type_nihilanthphase31_sound <- "phase31";

::type_nihilanthtele_sound <- "tele";
::type_nihilanthsunstrikeexplode_sound <- "explode";
::type_nihilanthsunstrikespawn_sound <- "spawn";

::type_nihilanthrockstart_sound <- "rockstart";
::type_nihilanthrockend_sound <- "rockend";

::type_nihilanthlaser_sound <- "laser";

::type_explode_sound <- "explode1";

::CreateSound <- function(origin, Preset = null, ID = null) 
{
    if(Preset == null)
        return;

    local sound;

    if(Preset == type_nihilanthbeamstart_sound)
    {   
        g_szSoundPreset = {
            message = Nihilanth_BeamArray_Sound[ID],
            radius = 2500,
        }

        g_hSoundMaker.SpawnEntityAtLocation(origin, Vector(0,0,0));

        sound = Entities.FindByName(null, "sound_temp");
        sound.__KeyValueFromString("targetname", "sound_temp" + Time());
    }

    else if(Preset == type_nihilanthcrystalstart_sound)
    {   
        g_szSoundPreset = {
            message = Nihilanth_Crystal_Start_Sound,
            radius = 2500,
            //spawnflags = 0,
            //startvolume = 0
        }

        g_hSoundMaker.SpawnEntityAtLocation(origin, Vector(0,0,0));

        sound = Entities.FindByName(null, "sound_temp");
        sound.__KeyValueFromString("targetname", "sound_temp" + Time());
    }

    else if(Preset == type_nihilanthsunstrikespawn_sound)
    {   
        g_szSoundPreset = {
            message = Nihilanth_SunStrike_Sound[ID],
            radius = 512,
            health = 5,
            spawnflags = 0,
            //startvolume = 0
        }

        g_hSoundMaker.SpawnEntityAtLocation(origin, Vector(0,0,0));

        sound = Entities.FindByName(null, "sound_temp");
        sound.__KeyValueFromString("targetname", "sound_temp" + Time());
    }

    else if(Preset == type_nihilanthsunstrikeexplode_sound)
    {   
        g_szSoundPreset = {
            message = Nihilanth_SunStrike_Explode_Sound,
            radius = 512,
            health = 5,
            spawnflags = 0,
            //startvolume = 0
        }

        g_hSoundMaker.SpawnEntityAtLocation(origin, Vector(0,0,0));

        sound = Entities.FindByName(null, "sound_temp");
        sound.__KeyValueFromString("targetname", "sound_temp" + Time());
    }

    else if(Preset == type_nihilanthfinalflash_sound)
    {   
        g_szSoundPreset = {
            message = Nihilanth_FinalFlash_Sound,
            radius = 2500,
            spawnflags = 0,
            //startvolume = 0
        }

        g_hSoundMaker.SpawnEntityAtLocation(origin, Vector(0,0,0));

        sound = Entities.FindByName(null, "sound_temp");
        sound.__KeyValueFromString("targetname", "sound_temp" + Time());
    }

    else if(Preset == type_nihilanthlaser_sound)
    {   
        g_szSoundPreset = {
            message = Nihilanth_LaserArray_Sound[ID],
            radius = 2500,
            spawnflags = 1,
            //startvolume = 0
        }

        g_hSoundMaker.SpawnEntityAtLocation(origin, Vector(0,0,0));

        sound = Entities.FindByName(null, "sound_temp");
        sound.__KeyValueFromString("targetname", "sound_temp" + Time());
        EntFireByHandle(sound, "PlaySound", "", 4.00, null, null);
    }

    else if(Preset == type_nihilanthheadopen_sound)
    {   
        g_szSoundPreset = {
            message = Nihilanth_Phase4_Sound,
            radius = 2500,
            //spawnflags = 0,
            //startvolume = 0
        }

        g_hSoundMaker.SpawnEntityAtLocation(origin, Vector(0,0,0));

        sound = Entities.FindByName(null, "sound_temp");
        sound.__KeyValueFromString("targetname", "sound_temp" + Time());
    }

    else if(Preset == type_nihilanthrockstart_sound)
    {   
        g_szSoundPreset = {
            message = Nihilanth_Rock_Start_Sound,
            radius = 2500,
            health = 5,
            spawnflags = 1,
            //startvolume = 0
        }

        g_hSoundMaker.SpawnEntityAtLocation(origin, Vector(0,0,0));

        sound = Entities.FindByName(null, "sound_temp");
        sound.__KeyValueFromString("targetname", "sound_temp" + Time());
    }

    else if(Preset == type_nihilanthrockend_sound)
    {   
        g_szSoundPreset = {
            message = Nihilanth_Rock_End_Sound,
            radius = 2500,
            health = 5,
            spawnflags = 17,
            //startvolume = 0
        }

        g_hSoundMaker.SpawnEntityAtLocation(origin, Vector(0,0,0));

        sound = Entities.FindByName(null, "sound_temp");
        sound.__KeyValueFromString("targetname", "sound_temp" + Time());
    }

    else if(Preset == type_nihilanthphase1_sound)
    {   
        g_szSoundPreset = {
            message = Nihilanth_Phase1_Sound,
            radius = 2500,
            spawnflags = 17,
            //startvolume = 0
        }

        g_hSoundMaker.SpawnEntityAtLocation(origin, Vector(0,0,0));

        sound = Entities.FindByName(null, "sound_temp");
        sound.__KeyValueFromString("targetname", "sound_temp" + Time());
        EntFireByHandle(sound, "PlaySound", "", 10.00, null, null);
    }

    else if(Preset == type_nihilanthphase4_sound)
    {   
        g_szSoundPreset = {
            message = Nihilanth_Phase4_End_Sound,
            radius = 2500,
            spawnflags = 1,
            //startvolume = 0
        }

        g_hSoundMaker.SpawnEntityAtLocation(origin, Vector(0,0,0));

        sound = Entities.FindByName(null, "sound_temp");
        sound.__KeyValueFromString("targetname", "sound_temp" + Time());
    }

    else if(Preset == type_nihilanthphase3_sound)
    {   
        g_szSoundPreset = {
            message = Nihilanth_Phase3_Sound,
            radius = 2500,
            spawnflags = 1,
            //startvolume = 0
        }

        g_hSoundMaker.SpawnEntityAtLocation(origin, Vector(0,0,0));

        sound = Entities.FindByName(null, "sound_temp");
        sound.__KeyValueFromString("targetname", "sound_temp" + Time());
    }

    else if(Preset == type_nihilanthphase31_sound)
    {   
        g_szSoundPreset = {
            message = Nihilanth_Phase31_Sound,
            radius = 2500,
            spawnflags = 1,
            //startvolume = 0
        }

        g_hSoundMaker.SpawnEntityAtLocation(origin, Vector(0,0,0));

        sound = Entities.FindByName(null, "sound_temp");
        sound.__KeyValueFromString("targetname", "sound_temp" + Time());
    }

    else if(Preset == type_nihilanthtele_sound)
    {   
        g_szSoundPreset = {
            message = Nihilanth_Tele_Sound,
            radius = 2500,
            //spawnflags = 0,
            //startvolume = 0
        }

        g_hSoundMaker.SpawnEntityAtLocation(origin, Vector(0,0,0));

        sound = Entities.FindByName(null, "sound_temp");
        sound.__KeyValueFromString("targetname", "sound_temp" + Time());
    }

    else if(Preset == type_nihilanthcrystalend_sound)
    {   
        g_szSoundPreset = {
            message = Nihilanth_Crystal_End_Sound,
            radius = 2500,
            spawnflags = 0,
        }

        g_hSoundMaker.SpawnEntityAtLocation(origin, Vector(0,0,0));

        sound = Entities.FindByName(null, "sound_temp");
        sound.__KeyValueFromString("targetname", "sound_temp" + Time());
    }

    else if(Preset == type_nihilanthbeamend_sound)
    {   
        g_szSoundPreset = {
            message = Nihilanth_Beam_End_Sound,
            radius = 2500,
        }

        g_hSoundMaker.SpawnEntityAtLocation(origin, Vector(0,0,0));

        sound = Entities.FindByName(null, "sound_temp");
        sound.__KeyValueFromString("targetname", "sound_temp" + Time());
    }

    else if(Preset == type_sniperdeath_sound)
    {   
        g_szSoundPreset = {
            message = SniperDeathArray_Sound[ID],
            radius = 2500,
        }

        g_hSoundMaker.SpawnEntityAtLocation(origin, Vector(0,0,0));

        sound = Entities.FindByName(null, "sound_temp");
        sound.__KeyValueFromString("targetname", "sound_temp" + Time());
        EntFireByHandle(sound, "PlaySound", "", 0.80, null, null);
    }

    else if(Preset == type_sniperreload_sound)
    {   
        g_szSoundPreset = {
            message = SniperReloadArray_Sound[ID],
            radius = 2500,
        }

        g_hSoundMaker.SpawnEntityAtLocation(origin, Vector(0,0,0));

        sound = Entities.FindByName(null, "sound_temp");
        sound.__KeyValueFromString("targetname", "sound_temp" + Time());
    }

    else if(Preset == type_snipershoot_sound)
    {   
        g_szSoundPreset = {
            message = SniperShootArray_Sound[ID],
            radius = 4000,
            spawnflags = 0,
        }

        g_hSoundMaker.SpawnEntityAtLocation(origin, Vector(0,0,0));

        sound = Entities.FindByName(null, "sound_temp");
        sound.__KeyValueFromString("targetname", "sound_temp" + Time());
    }

    else if(Preset == type_explode_sound)
    {   
        g_szSoundPreset = {
            message = Explode_Sound,
            radius = 2500,
            spawnflags = 0,
        }

        g_hSoundMaker.SpawnEntityAtLocation(origin, Vector(0,0,0));

        sound = Entities.FindByName(null, "sound_temp");
        sound.__KeyValueFromString("targetname", "sound_temp" + Time());
        EntFireByHandle(sound, "Kill", "", 2.80, null, null);
    }
    
    return sound;
}

function PreSpawnInstance(entityClass, entityName)
{
    local keyvalues = {};
    
    if(entityClass == "ambient_generic")
    {
        foreach(k,v in g_szSoundPreset)//thanks OrelStealth for this code
        {
            keyvalues[k] <- v;
        }
        g_szSoundPreset = {};
    }

	return keyvalues
}