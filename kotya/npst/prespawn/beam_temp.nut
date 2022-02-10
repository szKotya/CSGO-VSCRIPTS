::Beam_temp <- self;
::g_hBeamMaker <- Entities.CreateByClassname("env_entity_maker")
g_hBeamMaker.__KeyValueFromString("EntityTemplate", self.GetName());

::g_szBeamPreset <- {};

::type_crystal_beam <- "crystal";
::type_finalflash_beam <- "finalflash";
::type_beam_beam <- "beam";
::type_sniper_beam <- "sniper";

::type_manta_beam <- "manta";
::type_lasertrap_beam <- "lasertrap";
::type_lasertrapexplode_beam <- "lasertrapexplode";

::type_gargantua_beam <- "gargantua";

::CreateBeam <- function(origin, Preset = null, ID = null) 
{
    if(Preset == null)
        return;

    local beam;

    if(Preset == type_crystal_beam)
    {   
        g_szBeamPreset = {
            rendercolor = "255 255 156",
            LightningEnd = "beam_temp",
            LightningStart = "Nihilanth_Prop_Model",
            life = 0,
            BoltWidth = 2,
            texture = "sprites/laserbeam.vmt",
        }

        g_hBeamMaker.SpawnEntityAtLocation(origin, Vector(0,0,0));

        beam = Entities.FindByName(null, "beam_temp");
        beam.__KeyValueFromString("targetname", "Nihilanth_Beam_CrystalHeal");
        //EntFireByHandle(beam, "ShowBeam", "", 0.00, null, null);
    }

    else if(Preset == type_finalflash_beam)
    {   
        g_szBeamPreset = {
            rendercolor = "255 128 128",
            LightningEnd = ID[1],
            LightningStart = ID[0],
            life = 0,
            renderamt = 128,
            BoltWidth = 3,
            TextureScroll = 15,
            texture = "sprites/laserbeam.vmt",
        }

        g_hBeamMaker.SpawnEntityAtLocation(origin, Vector(0,0,0));

        beam = Entities.FindByName(null, "beam_temp");
        beam.__KeyValueFromString("targetname", "Nihilanth_Beam_FinalFlash");
        //EntFireByHandle(beam, "ShowBeam", "", 0.00, null, null);
    }

    else if(Preset == type_sniper_beam)
    {   
        g_szBeamPreset = {
            rendercolor = "0 255 255",
            LightningEnd = ID[1],
            LightningStart = ID[0],
            life = 0,
            NoiseAmplitude = 0,
            spawnflags = 257,
            TextureScroll = 20,
            renderamt = 255,
            BoltWidth = 2,
            texture = "sprites/purplelaser1.vmt",
        }

        g_hBeamMaker.SpawnEntityAtLocation(origin, Vector(0,0,0));

        beam = Entities.FindByName(null, "beam_temp");
        beam.__KeyValueFromString("targetname", "Sniper_Beam" + Time());

        EntFireByHandle(beam, "TurnOn", "", 0, null, null);
        //EntFireByHandle(beam, "ShowBeam", "", 0.00, null, null);
    }

    else if(Preset == type_lasertrap_beam)
    {   
        g_szBeamPreset = {
            rendercolor = "255 0 0",
            LightningEnd = ID[1],
            LightningStart = ID[0],
            life = 0,
            NoiseAmplitude = 0,
            spawnflags = 1009,
            TextureScroll = 35,
            renderamt = 50,
            BoltWidth = 0.5,
            texture = "sprites/laserbeam.spr",
        }

        g_hBeamMaker.SpawnEntityAtLocation(origin, Vector(0,0,0));

        beam = Entities.FindByName(null, "beam_temp");
        beam.__KeyValueFromString("targetname", "LaserTrap_Beam" + Time());

        //EntFireByHandle(beam, "TurnOn", "", 0, null, null);
        //EntFireByHandle(beam, "ShowBeam", "", 0.00, null, null);
    }

    else if(Preset == type_gargantua_beam)
    {   
        g_szBeamPreset = {
            rendercolor = "255 0 255",
            LightningEnd = ID[0],
            LightningStart = ID[1],
            life = 0,
            NoiseAmplitude = 0,
            spawnflags = 1,
            TextureScroll = 35,
            renderamt = 50,
            BoltWidth = 0.5,
            texture = "sprites/laserbeam.spr",
        }

        g_hBeamMaker.SpawnEntityAtLocation(origin, Vector(0,0,0));

        beam = Entities.FindByName(null, "beam_temp");
        //EntFireByHandle(beam, "TurnOn", "", 0, null, null);

        //EntFireByHandle(beam, "TurnOn", "", 0, null, null);
        //EntFireByHandle(beam, "ShowBeam", "", 0.00, null, null);
    }

    else if(Preset == type_lasertrapexplode_beam)
    {   
        g_szBeamPreset = {
            rendercolor = "0 255 128",
            LightningEnd = ID[1],
            LightningStart = ID[0],
            life = 0,
            NoiseAmplitude = 0,
            spawnflags = 1009,
            TextureScroll = 35,
            renderamt = 50,
            BoltWidth = 0.5,
            texture = "sprites/laserbeam.spr",
        }

        g_hBeamMaker.SpawnEntityAtLocation(origin, Vector(0,0,0));

        beam = Entities.FindByName(null, "beam_temp");
        beam.__KeyValueFromString("targetname", "LaserTrap_Beam" + Time());

        //EntFireByHandle(beam, "TurnOn", "", 0, null, null);
        //EntFireByHandle(beam, "ShowBeam", "", 0.00, null, null);
    }

    else if(Preset == type_manta_beam)
    {   
        g_szBeamPreset = {
            rendercolor = "32 192 32",
            renderamt = 200,
            LightningEnd = ID[1],
            LightningStart = ID[0],
            life = 0.1,
            NoiseAmplitude = 3,
            texture = "sprites/laserbeam.spr",
            BoltWidth = 14,
            targetname = "Manta_Beam",
            TextureScroll = 64,
            damage = 100,
            spawnflags = 0,
            //Radius = 640,
        }

        g_hBeamMaker.SpawnEntityAtLocation(origin, Vector(0,0,0));

        beam = Entities.FindByName(null, "Manta_Beam");

        EntFireByHandle(beam, "TurnOn", "", 0.05, null, null);

        //EntFireByHandle(beam, "ShowBeam", "", 0.00, null, null);
    }

    else if(Preset == type_beam_beam)
    {   
        g_szBeamPreset = {
            rendercolor = "255 255 128",
            LightningEnd = ID[1],
            LightningStart = ID[0],
            life = 0.1,
            //StrikeTime = 1,
            renderamt = 1,
            BoltWidth = 6,
            spawnflags = 992,
            Radius = 640,

            NoiseAmplitude = 1,
            ClipStyle = 1,
            damage = 5,
            dissolvetype = 1,
            TextureScroll = 60,
            //spawnflags = 496,
            //TouchType = 0,
            texture = "sprites/laserbeam.vmt",
        }

        g_hBeamMaker.SpawnEntityAtLocation(origin, Vector(0,0,0));

        beam = Entities.FindByName(null, "beam_temp");
        beam.__KeyValueFromString("targetname", "Nihilanth_Beam_Beam");

        //EntFireByHandle(beam, "TurnOn", "", 0.50, null, null);
        //EntFireByHandle(beam, "ShowBeam", "", 0.00, null, null);
    }
    
    return beam;
}

function PreSpawnInstance(entityClass, entityName)
{
    local keyvalues = {};
    
    if(entityClass == "env_beam")
    {
        foreach(k,v in g_szBeamPreset)//thanks OrelStealth for this code
        {
            keyvalues[k] <- v;
        }
        g_szBeamPreset = {};
    }

	return keyvalues
}