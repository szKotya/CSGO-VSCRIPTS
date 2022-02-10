

::Sprite_temp <- self;
::g_hSpriteMaker <- Entities.CreateByClassname("env_entity_maker")
g_hSpriteMaker.__KeyValueFromString("EntityTemplate", self.GetName());

::g_szSpritePreset <- {};

::type_crystal_sprite <- "crystal";
::type_stick_sprite <- "stick";
::type_beam_sprite <- "beam";
::type_finalflash_sprite <- "finalflash";
::type_sniper_sprite <- "sniper";
::type_snipershot_sprite <- "snipershoot";
::type_lasertrap_sprite <- "lasertrap";
::type_lasertrapexplode_sprite <- "lasertrapexplode";
::CreateSprite <- function(origin, Preset = null, ID = null) 
{
    if(Preset == null)
        return;

    local sprite;

    if(Preset == type_crystal_sprite)
    {   
        g_szSpritePreset = {
            renderamt = 140,
            model = "sprites/glow.vmt",
            rendercolor = "255 128 0",
            HDRColorScale = 1,
            GlowProxySize = 48,
            rendermode = 9,
            scale = 5,
            spawnflags = 1,
        }

        g_hSpriteMaker.SpawnEntityAtLocation(origin, Vector(0,0,0));

        sprite = Entities.FindByName(null, "sprite_temp");
        sprite.__KeyValueFromString("targetname", "Nihilanth_Sprite_CrystalHeal");
        //EntFireByHandle(sprite, "ShowSprite", "", 0.00, null, null);
    }

    else if(Preset == type_sniper_sprite)
    {   
        g_szSpritePreset = {
            renderamt = 200,
            model = "sprites/glow.vmt",
            rendercolor = "0 255 255",
            HDRColorScale = 1,
            GlowProxySize = 5,
            rendermode = 9,
            scale = 0.25,
            spawnflags = 1,
        }

        g_hSpriteMaker.SpawnEntityAtLocation(origin, Vector(0,0,0));

        sprite = Entities.FindByName(null, "sprite_temp");
        sprite.__KeyValueFromString("targetname", "Sniper_Spite" + Time());
        //EntFireByHandle(sprite, "ShowSprite", "", 0.00, null, null);
    }

    else if(Preset == type_lasertrap_sprite)
    {   
        g_szSpritePreset = {
            renderamt = 200,
            model = "sprites/glow.vmt",
            rendercolor = "255 0 0",
            HDRColorScale = 1,
            GlowProxySize = 3,
            rendermode = 9,
            scale = 0.15,
            spawnflags = 1,
        }

        g_hSpriteMaker.SpawnEntityAtLocation(origin, Vector(0,0,0));

        sprite = Entities.FindByName(null, "sprite_temp");
        sprite.__KeyValueFromString("targetname", "LaserTrap_Sprite" + Time());
        //EntFireByHandle(sprite, "ShowSprite", "", 0.00, null, null);
    }

    else if(Preset == type_lasertrapexplode_sprite)
    {   
        g_szSpritePreset = {
            renderamt = 200,
            model = "sprites/glow.vmt",
            rendercolor = "0 255 128",
            HDRColorScale = 1,
            GlowProxySize = 3,
            rendermode = 9,
            scale = 0.15,
            spawnflags = 1,
        }

        g_hSpriteMaker.SpawnEntityAtLocation(origin, Vector(0,0,0));

        sprite = Entities.FindByName(null, "sprite_temp");
        sprite.__KeyValueFromString("targetname", "LaserTrap_Sprite" + Time());
        //EntFireByHandle(sprite, "ShowSprite", "", 0.00, null, null);
    }

    else if(Preset == type_snipershot_sprite)
    {   
        g_szSpritePreset = {
            renderamt = 200,
            model = "sprites/glow.vmt",
            rendercolor = "255 255 0",
            HDRColorScale = 1,
            GlowProxySize = 5,
            rendermode = 9,
            scale = 3.0,
            spawnflags = 1,
        }

        g_hSpriteMaker.SpawnEntityAtLocation(origin, Vector(0,0,0));

        sprite = Entities.FindByName(null, "sprite_temp");
        sprite.__KeyValueFromString("targetname", "Sniper_Spite" + Time());
        EntFireByHandle(sprite, "ShowSprite", "", 0.00, null, null);
    }

    else if(Preset == type_beam_sprite)
    {   
        g_szSpritePreset = {
            renderamt = 140,
            model = "sprites/glow.vmt",
            rendercolor = "255 128 128",
            HDRColorScale = 1,
            GlowProxySize = 48,
            rendermode = 9,
            scale = 4,
            spawnflags = 0,
        }


        g_hSpriteMaker.SpawnEntityAtLocation(origin, Vector(0,0,0));

        sprite = Entities.FindByName(null, "sprite_temp");
        sprite.__KeyValueFromString("targetname", "Nihilanth_Sprite_Stick");
        //EntFireByHandle(sprite, "ShowSprite", "", 0.00, null, null);
    }

    else if(Preset == type_finalflash_sprite)
    {   
        g_szSpritePreset = {
            renderamt = 140,
            model = "sprites/glow.vmt",
            rendercolor = "0 255 255",
            HDRColorScale = 1,
            GlowProxySize = 56,
            rendermode = 9,
            scale = 7,
            spawnflags = 1,
        }


        g_hSpriteMaker.SpawnEntityAtLocation(origin, Vector(0,0,0));

        sprite = Entities.FindByName(null, "sprite_temp");
        sprite.__KeyValueFromString("targetname", "Nihilanth_Sprite_Stick");
        //EntFireByHandle(sprite, "ShowSprite", "", 0.00, null, null);
    }

    else if(Preset == type_stick_sprite)
    {   
        g_szSpritePreset = {
            model = "sprites/glow.vmt",
            rendercolor = "0 255 0",
            rendermode = 5,
            scale = 1,
            spawnflags = 1,
        }

        g_hSpriteMaker.SpawnEntityAtLocation(origin, Vector(0,0,0));

        sprite = Entities.FindByName(null, "sprite_temp");
        sprite.__KeyValueFromString("targetname", "Nihilanth_Sprite_Stick");
        //EntFireByHandle(sprite, "ShowSprite", "", 0.00, null, null);
    }
    
    return sprite;
}

function PreSpawnInstance(entityClass, entityName)
{
    local keyvalues = {};
    
    if(entityClass == "env_sprite")
    {
        foreach(k,v in g_szSpritePreset)//thanks OrelStealth for this code
        {
            keyvalues[k] <- v;
        }
        g_szSpritePreset = {};
    }

	return keyvalues
}