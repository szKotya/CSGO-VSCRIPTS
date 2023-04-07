::Maker <- null;
::ID_MAKER <- 1;
::MakerName <- "prespawn_maker";

function Init()
{
	Entities.FindByName(null, MakerName);
}

CreateEntity <- function(kv = {})
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

	kv["targetname"] <- szName;
	foreach(k,v in kv)
	{
		KV[k] <- v;
	}

	// if (!KVhaveK(kv, "pos"))
	// {
	// 	KV["pos"] <- class_pos(self.GetOrigin());
	// }

	// local origin = KV["pos"].origin;
	// local angles = KV["pos"].angles;
	// KV = KVremoveK(KV, "pos");

	Maker.__KeyValueFromString("EntityTemplate", self.GetName());
	Maker.SpawnEntityAtLocation(Vector(0, 0, 0), Vector(0, 0, 0));
	hEntity = Entities.FindByName(null, KV["targetname"]);

	// ID_MAKER++;
	KV = {};
	return hEntity;
}

PreSpawnInstance <- function(szClass, szName)
{
	return KV;
}

EntFireByHandle(self, "RunScriptCode", "Init()", 2, null, null);