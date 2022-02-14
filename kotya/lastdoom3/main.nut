const TICKRATE_DROP = 0.1
const TICKRATE_PROJECTILE = 0.1

class class_item
{
	postfix = null;
	gun = null;
	center = null;
	owner = null;

	active = false;

	script = null;
	gun_modelname = null;

	constructor(_postfix)
	{
		this.postfix = _postfix;
	}

	function SetNewOwner(owner)
	{
		printl("PICK");
		this.owner = owner;
		this.script.GetScriptScope().g_hOwner = owner;
	}

	function RemoveOwner()
	{
		printl("DROP");
		if (this.owner == null)
		{
			return;
		}
		this.gun.SetModel(NULLPROP);
		local oldowner = this.owner;
		this.owner = null;
		
		EF(this.center, "ClearParent");
		
		EntFireByHandle(g_hItems, "RunScriptCode", "caller.SetForwardVector(activator.GetForwardVector());caller.SetOrigin(activator.GetOrigin())", 0.01, this.gun, this.center);
		EntFireByHandle(this.center, "SetParent", "!activator", 0.01, this.gun, this.gun);

		if (TargerValid(oldowner))
		{
			EF(this.script, "Deactivate", "", 0.02);
		}

		if (this.script != null)
		{
			this.script.GetScriptScope().RemoveOwner();
		}
	}
	function ToggleItem(toggle)
	{
		printl("ToggleItem");
		if (this.script != null)
		{
			if (toggle)
			{
				this.active = true;
				this.script.GetScriptScope().ActivateItem(this.owner);
			}
			else
			{
				this.active = false;
				if (this.gun.GetRootMoveParent() != this.owner)
				{
					this.RemoveOwner();
				}
				else
				{
					this.script.GetScriptScope().DeactivateItem(this.owner);
				}
			}
		}
	}

	function Init()
	{
		printl("INIT");
		this.gun_modelname = this.gun.GetModelName();
		this.gun_modelname = this.gun_modelname.slice(17, this.gun_modelname.len() - 13);
		this.gun.SetModel(NULLPROP);

		local weaponworldmodel;
		while ((weaponworldmodel = Entities.FindByClassname(weaponworldmodel, "weaponworldmodel*")) != null)
		{
			if (weaponworldmodel.GetMoveParent() == this.gun)
			{
				weaponworldmodel.SetModel(NULLPROP);
				
				break;
			}
		}
	}
}

::g_hItems <- self;
::g_iID <- 0;
g_aiItems <- [];
g_bTicking_Drop <- false;
function LastInit()
{
	local postfix = caller.GetName().slice(caller.GetPreTemplateName().len(), caller.GetName().len());
	local item_class = GetItemByPostFix(postfix);

	if (item_class == null)
	{
		return;
	}

	item_class.Init();
	}

function RegItem(ID = -1)
{
	local classname = caller.GetClassname();

	local postfix = caller.GetName().slice(caller.GetPreTemplateName().len(), caller.GetName().len());
	local item_class = GetItemByPostFix(postfix);

	if (item_class == null)
	{
		item_class = class_item(postfix);
		g_aiItems.push(item_class);
	}

	if (classname.find("weapon_") != null)
	{
		item_class.gun = caller;
	}
	else if (classname == "func_door")
	{
		item_class.center = caller;
	}

	if (ID == 1)
	{
		item_class.script = caller;
	}
}

function PickUpGun()
{
	local item_class = GetItemByGun(caller);
	local player_class = activator;

	if (item_class == null || player_class == null)
	{
		return;
	}

	item_class.SetNewOwner(player_class);
	ActivateItem(activator);

	if (!g_bTicking_Drop)
	{
		g_bTicking_Drop = true;
		TickDrop();
	}
}
function TickDrop()
{
	if (g_bTicking_Drop)
	{
		g_bTicking_Drop = false;
		foreach(item in g_aiItems)
		{
			if (item.owner != null)
			{
				if (item.gun.GetMoveParent() != item.owner)
				{
					printl("TickDropRemove")
					item.RemoveOwner();
				}
				else
				{
					g_bTicking_Drop = true;
				}
			}
		}
		if (g_bTicking_Drop)
		{
			EF(self, "RunScriptCode", "TickDrop()", TICKRATE_DROP);
		}
	}
}

function GetItemByGun(gun)
{
	foreach (item in g_aiItems) 
	{
		if (item.gun == gun)
		{
		return item;
		}
	}
	return null;
}

function GetItemByPostFix(postfix)
{
	foreach (item in g_aiItems) 
	{
		if (item.postfix == postfix)
		{
		return item;
		}
	}
	return null;
}

function TickProjectile(iValue)
{
	if (!TargerValid(caller))
	{
		return;
	}
	local co = caller.GetOrigin();
	if (!InSight(co, co + (caller.GetForwardVector() * iValue)))
	{
		EF(caller, "FireUser1", "");
		return;
	}
	EntFireByHandle(self, "RunScriptCode", "TickProjectile(" + iValue + ")", TICKRATE_PROJECTILE, null, caller);
}

EVENT_EQUIP <- null;
function ItemEquip()
{
	if (EVENT_EQUIP == null || EVENT_EQUIP != null && !EVENT_EQUIP.IsValid()){EVENT_EQUIP = Entities.FindByName(null, "map_eventlistener_item_equip");}
	local userid = EVENT_EQUIP.GetScriptScope().event_data.userid;
	local player_class = GetPlayerClassByUserID(userid);

	if (player_class == null)
	{
		return;
	}

	ActivateItem(player_class.handle);
}

function ActivateItem(owner)
{
	printl("3");
	if (!TargerValid(owner))
	{
		return;
	}
	printl("2");
	local item_class = GetItemByOwner(owner);
	if (item_class == null)
	{
		return;
	}
	printl("1");
	local viewmodel = GetViewModelByOwner(owner); 
	if (viewmodel == null)
	{
		return;
	}
	printl("0.5");
	// Подбор 2 итема если есть 1 getmodel дает нулл проп
	local viewmodel_name = viewmodel.GetModelName();
	if (viewmodel_name != NULLPROP)
	{
		viewmodel_name = viewmodel_name.slice(17, viewmodel_name.len() - 5);
	}
	foreach(item in item_class)
	{
		if (item.gun_modelname == null)
		{
			printl(viewmodel_name + " : " + item.gun_modelname);
			printl("0.35");
		}
		else if (viewmodel_name != item.gun_modelname)
		{
			printl(viewmodel_name + " : " + item.gun_modelname);
			printl("0.25");
			if (viewmodel_name != NULLPROP)
			{
				item.ToggleItem(false);
			}
			else if (!item.active)
			{
				item.ToggleItem(false);
			}
		}
		else
		{
			printl("0");
			viewmodel.SetModel(NULLPROP);
			item.gun.SetModel(NULLPROP);
			item.ToggleItem(true);
		}
	}
}

function GetViewModelByOwner(owner)
{
	local viewmodel;
	while ((viewmodel = Entities.FindByClassname(viewmodel, "predicted_viewmodel*")) != null)
	{
		if (viewmodel.GetRootMoveParent() == owner)
		{
			return viewmodel;
		}
	}
	return null;
}

::NULLPROP <- "models/props_doors/null.mdl";
self.PrecacheModel(NULLPROP);

::AOP <- function(item, key, value = "", d = 0.00)
{
	if (typeof item == "string")
	{
		EntFire(item, "addoutput", key + " " + value, d);
	}
	else if (typeof item == "instance")
	{
		if (d > 0.00)
		{
			EntFireByHandle(item, "AddOutPut", key + " " + value, d, item, item);
		}
		else
		{
			if (typeof value == "string")
			{
				item.__KeyValueFromString(key, value);
			}
			else if (typeof value == "integer")
			{
				item.__KeyValueFromInt(key, value);
			}
			else
			{
				EntFireByHandle(item, "AddOutPut", key + " " + value, d, item, item);
			}
		}
	}
}

::EF <- function(item, key, value = "", d = 0)
{
	if (typeof item == "string")
	{
		EntFire(item, key, value, d);
	}
	else if (typeof item == "instance")
	{
		EntFireByHandle(item, key, value, d, item, item);
	}
}

::InSight <- function(start, end, ignorehandle = null)
{
	if (ignorehandle == null || typeof ignorehandle == "instance")
	{
		// DebugDrawLine(start, end, 255, 255, 255, true, 3.0);
		if (TraceLine(start, end, ignorehandle) < 1.00)
		{
			return false;
		}
		return true;
	}

	if (typeof ignorehandle == "array")
	{
		foreach(item in ignorehandle)
		{
			if (!TargerValid(item))
			{
				continue;
			}
			if (InSight(start, end, item))
			{
				return true;
			}	
		}
	}

	return InSight(start, end, null);
}

::TargerValid <- function(target)
{
	if (target == null || !target.IsValid())
	{
		return false;
	}
	return true;
} 

::TraceDir <- function(orig, dir, maxd = 99999, filter = null)
{
	local frac = TraceLine(orig, orig+dir*maxd, filter);
	if(frac == 1.0)
	{
		return orig + dir * maxd;
	}

	return orig + (dir * (maxd * frac));
}

::GetPithXawFVect3D <- function(a, b)
{
	local deltaX = a.x - b.x;
	local deltaY = a.y - b.y;
	local deltaZ = a.z - b.z;
	local yaw = atan2(deltaY,deltaX) * 180 / PI
	local pitch = asin(deltaZ / sqrt(deltaX * deltaX + deltaY * deltaY + deltaZ * deltaZ)) * 180 / PI;
	if(pitch > 0){pitch = -pitch;}
	else{pitch = fabs(pitch);}
	return Vector(pitch, yaw, 0);
}

::ValueLimiter <- function(Value, Min, Max)
{
	if (Value > Max)
	{
		return Max;
	}
	else if (Value < Min)
	{
		return Min;
	}
	return Value;
}

function GetItemByOwner(owner)
{
	local array = [];
	foreach(item in g_aiItems)
	{
		if (owner == item.owner)
		{
		array.push(item);
		}
	}

	if (array.len() > 0)
	{
		return array;
	}

	return null;
}

::DrawAxis <- function(pos,s = 16,time = 10)
{
	DebugDrawLine(Vector(pos.x-s,pos.y,pos.z), Vector(pos.x+s,pos.y,pos.z), 255, 0, 0, true, time);
	DebugDrawLine(Vector(pos.x,pos.y-s,pos.z), Vector(pos.x,pos.y+s,pos.z), 0, 255, 0, true, time);
	DebugDrawLine(Vector(pos.x,pos.y,pos.z-s), Vector(pos.x,pos.y,pos.z+s), 0, 0, 255, true, time);
}

function GetDistance3D(v1, v2){return sqrt((v1.x-v2.x)*(v1.x-v2.x)+(v1.y-v2.y)*(v1.y-v2.y)+(v1.z-v2.z)*(v1.z-v2.z));}
function GetDistance2D(v1, v2){return sqrt((v1.x-v2.x)*(v1.x-v2.x)+(v1.y-v2.y)*(v1.y-v2.y));}
function GetDistanceZ(v1, v2){return v1.z-v2.z;}