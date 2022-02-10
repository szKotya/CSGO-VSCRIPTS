
SelectID <- 0;
ParticleArray <- [];

function OnPostSpawn()
{
    for(local i = 0; i < 10; i++)
    {
        ParticleArray.push("custom_particle_00" + i);
    }

    for(local i = 10; i < 100; i++)
    {
        ParticleArray.push("custom_particle_0" + i);
    }

    for(local i = 100; i < 200; i++)
    {
        ParticleArray.push("custom_particle_" + i);
    }
}

function PrintArray()
{
    for(local i = 0; i < ParticleArray.len(); i++)
    {
        printl(ParticleArray[i]);
    }
}

function CreateParticle(id = null)
{
    if(id == null)
        SelectID++
    else
        SelectID = id;
    ScriptPrintMessageChatAll(ParticleArray[SelectID]);
    EntFire("particle", "Kill", "", 0.00, null);
    EntFireByHandle(self, "ForceSpawn", "", 0.00, null, null);
}

function PreSpawnInstance( entityClass, entityName )
{
	local keyvalues = {};

    if(entityClass == "info_particle_system")
    {
        keyvalues["effect_name"]  <- ParticleArray[SelectID];
    }

	return keyvalues
}