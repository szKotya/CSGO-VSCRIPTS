Maker <- Entities.CreateByClassname("env_entity_maker")
Maker.__KeyValueFromString("EntityTemplate", self.GetName());
KV <- {};

CreateEntity <- function(kv) 
{
	local hEntity = null;
	local szName = split(self.GetName().toupper(),"_");
	if (szName.len() > 1)
	{
		local temp = szName[1];
		for (local i = 2; i < szName.len(); i++)
		{
			temp += "_" + szName[i];
		}
		szName = temp;
	}
	else
	{
		szName = self.GetName();
	}

	kv["targetname"] <- szName + ID_MAKER;
	foreach(k,v in kv)
	{
		KV[k] <- v;
	}
	if (!KVhaveK(kv, "pos"))
	{
		KV["pos"] <- class_pos(self.GetOrigin());
	}

	local origin = KV["pos"].origin;
	local angles = KV["pos"].angles;
	KVremoveK(KV, "pos");

	Maker.SpawnEntityAtLocation(origin, angles);
	hEntity = Entities.FindByName(null, KV["targetname"]);

	ID_MAKER++;
	KV = {};
	return hEntity;
}

function PreSpawnInstance(entityClass, entityName)
{
	return KV
}