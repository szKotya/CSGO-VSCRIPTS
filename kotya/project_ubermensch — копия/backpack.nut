::BACKPACKS <-[];
::TEMP_OWNER_BACKPACK <- null;

::CreateBackPack <- function(_owner = null)
{
	if (_owner == null)
	{
		_owner = activator
	}
	TEMP_OWNER_BACKPACK = _owner;
	AOP(Entity_Maker, "EntityTemplate", "backpack");
	Entity_Maker.SpawnEntity();
}

function PreSpawnInstance(szClass, szName)
{
	return {};
}

// VECDIR <- Vector(270, 75, -40);
function PostSpawn(entities)
{
	foreach(backpack in entities)
	{
		// local vecOrigin = TEMP_OWNER_BACKPACK.GetAttachmentOrigin(TEMP_OWNER_BACKPACK.LookupAttachment("primary"));
		// local vecOrigin = TEMP_OWNER_BACKPACK.GetCenter() +
		// TEMP_OWNER_BACKPACK.GetForwardVector() * -3.6 +
		// TEMP_OWNER_BACKPACK.GetLeftVector() * -2.5 +
		// Vector(0, 0, 14);
		// local vecDir = TEMP_OWNER_BACKPACK.GetAttachmentAngles(TEMP_OWNER_BACKPACK.LookupAttachment("primary"));
		// vecDir = Vector(vecDir.x.tointeger(), vecDir.y.tointeger(), vecDir.z.tointeger());
		// // print(""+( vecOrigin - TEMP_OWNER_BACKPACK.GetCenter()));

		// // 2.515503, 3.609009, 14.426270
		// backpack.SetOrigin(vecOrigin);
		// backpack.SetAngles(vecDir.x + VECDIR.x, vecDir.y + VECDIR.y, vecDir.z + VECDIR.z);
		// backpack.SetForwardVector(VECDIR);
		// backpack.SetAngles(0, -90, 0);

		EntFireByHandle(backpack, "SetParent", "!activator", 0, TEMP_OWNER_BACKPACK, TEMP_OWNER_BACKPACK);
		EF(backpack, "SetParentAttachment", "primary_bagaje", 0.02);

		BACKPACKS.push([TEMP_OWNER_BACKPACK, backpack]);
		return;
	}
}

::RemoveBackPackByOwner <- function(_owner = null)
{
	if (_owner == null)
	{
		_owner = activator
	}
	foreach (index, backpack in BACKPACKS)
	{
		if (backpack[0] == _owner)
		{
			BACKPACKS.remove(index);
			if (TargetValid(backpack[1]))
			{
				EF(backpack[1], "Kill");
			}
			return;
		}
	}
}