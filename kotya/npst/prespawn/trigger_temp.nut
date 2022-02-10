

::Trigger_temp <- self;
::g_hTriggerMaker <- Entities.CreateByClassname("env_entity_maker")
g_hTriggerMaker.__KeyValueFromString("EntityTemplate", self.GetName());

::g_szTriggerHurtPreset <- {};
::g_szTriggerOncePreset <- {};
::g_szTriggerMultiplePreset <- {};

::type_lasertrap_trigger <- "lasertrap";
::type_lasertrapexplode_trigger <- "lasertrapexplode";
::type_teleport_trigger <- "teleport";

::CreateTrigger <- function(origin, Preset = null, ID = null) 
{
    if(Preset == null)
        return;

    local trigger;

    if(Preset == type_lasertrap_trigger)
    {   
        g_szTriggerHurtPreset = {
            damage = ID,
            damagecap = ID * 2,
        }
        g_szTriggerOncePreset = {};
        g_szTriggerMultiplePreset = {};

        g_hTriggerMaker.SpawnEntityAtLocation(origin, Vector(0, 0, 0));

        trigger = Entities.FindByName(null, "trigger_multiple_temp");

        if(trigger != null && trigger.IsValid())
            trigger.Destroy();

        trigger = Entities.FindByName(null, "trigger_once_temp");

        if(trigger != null && trigger.IsValid())
            trigger.Destroy();

        trigger = Entities.FindByName(null, "trigger_hurt_temp");
        trigger.__KeyValueFromString("targetname", "LaserTrap_Hurt" + Time());
    }
    else if(Preset == type_lasertrapexplode_trigger)
    {   
        g_szTriggerOncePreset = {
            spawnflags = 9,
        };

        g_szTriggerHurtPreset = {};
        g_szTriggerMultiplePreset = {};

        g_hTriggerMaker.SpawnEntityAtLocation(origin, Vector(0, 0, 0));

        trigger = Entities.FindByName(null, "trigger_multiple_temp");

        if(trigger != null && trigger.IsValid())
            trigger.Destroy();

        trigger = Entities.FindByName(null, "trigger_hurt_temp");

        if(trigger != null && trigger.IsValid())
            trigger.Destroy();

        trigger = Entities.FindByName(null, "trigger_once_temp");
        trigger.__KeyValueFromString("targetname", "LaserTrap_Hurt" + Time());
    }
    else if(Preset == type_teleport_trigger)
    {   
        g_szTriggerOncePreset = {};
        g_szTriggerHurtPreset = {};
        g_szTriggerMultiplePreset = {
            spawnflags = 1,
        };

        g_hTriggerMaker.SpawnEntityAtLocation(origin, Vector(0, 0, 0));

        trigger = Entities.FindByName(null, "trigger_once_temp");

        if(trigger != null && trigger.IsValid())
            trigger.Destroy();

        trigger = Entities.FindByName(null, "trigger_hurt_temp");

        if(trigger != null && trigger.IsValid())
            trigger.Destroy();

        trigger = Entities.FindByName(null, "trigger_multiple_temp");
        trigger.__KeyValueFromString("targetname", "trigger_teleport");
    }
    
    return trigger;
}

function PreSpawnInstance(entityClass, entityName)
{
    local keyvalues = {};
    
    if(entityClass == "trigger_hurt")
    {
        foreach(k,v in g_szTriggerHurtPreset)//thanks OrelStealth for this code
        {
            keyvalues[k] <- v;
        }
        g_szTriggerHurtPreset = {};
    }
    else if(entityClass == "trigger_once")
    {
        foreach(k,v in g_szTriggerOncePreset)//thanks OrelStealth for this code
        {
            keyvalues[k] <- v;
        }
        g_szTriggerOncePreset = {};
    }
    else if(entityClass == "trigger_multiple")
    {
        foreach(k,v in g_szTriggerMultiplePreset)//thanks OrelStealth for this code
        {
            keyvalues[k] <- v;
        }
        g_szTriggerMultiplePreset = {};
    }

	return keyvalues
}