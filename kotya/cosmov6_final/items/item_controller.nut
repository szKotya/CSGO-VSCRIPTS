const TICKRATE_ITEMCHECK = 0.1;

const TICKRATE_ENTWATCH = 1.0;

const TICKRATE_ITEMWORK = 0.05;
g_bTicking_ItemCheck <- false;
g_bTicking_EntWatch <- false;
g_bTicking_ItemTrigger <- false;

g_hEntWatch <- null;

::ITEMS_TRIGGERS <- [];

::ITEMS_PICK <- [];
::class_item_trigger <- class
{
	name = null;

	gun = null;

	trigger = null;
}

::ITEMS <- [];

::TRANSFER_DOUBLE_BAN_TIME <- 80.0;

::STARS_DISTANCE <- 9;
::STARS_DISTANCE_F <- -22;
::STARS_ANG <- 22;

::class_item <- class
{
	name = null;

	gun = null;
	button = null;

	parent_measure = null;
	parent_entity = null;
	stars = null;

	particle_main = null;
	particle_light = null;
	particle_sprite = null;
	effects = true;
	model = null;

	owner = null;
	lastowner = null;

	status_allow_transfer_ban = false;
	status_allow_silence = true;
	status_allow_last_use = false;
	status_allow_last_regen = false;

	status_double_ban_time = 0.0;
	status_silence_time = 0.0;
	status_CD_time = 0.0;

	use_type = null;
	use_count = [];
	use_lvl = 0;

	function TurnOff()
	{
		if (TargerValid(this.particle_main))
		{
			EF(this.particle_main, "Stop");
		}
		if (TargerValid(this.particle_light))
		{
			EF(this.particle_light, "TurnOff");
		}
		if (TargerValid(this.particle_sprite))
		{
			EF(this.particle_sprite, "HideSprite");
		}
		this.effects = false;
	}

	function TurnOn()
	{
		if (TargerValid(this.particle_main))
		{
			EF(this.particle_main, "Start");
		}
		if (TargerValid(this.particle_light))
		{
			EF(this.particle_light, "TurnOn");
		}
		if (TargerValid(this.particle_sprite))
		{
			EF(this.particle_sprite, "ShowSprite");
		}
		this.effects = true;
	}
	function Press()
	{
		EntFireByHandle(this.button, "Press", "", 0.00, this.owner, this.owner);
	}

	function PickUpItem(player_class)
	{
		printl("SetNewOwner" + player_class);
		this.owner = player_class;

		// if (this.owner != this.lastowner)
		// {
		//     if (this.use_count < this.use_maxcount)
		//     {

		//     }
		// }

		local iteminfo = GetItemInfoByName(this.name)

		local bdouble = false;
		local ilvl = 3;

		if (iteminfo.type == 1 || iteminfo.type == 3)
		{
			this.use_type = 1;
		}
		else if (iteminfo.type == 2)
		{
			this.use_type = 2;
		}

		this.use_lvl = ilvl;
		// if (this.use_count.len() > 0 && this.GetFreeCount())
		// {

		// }
		this.use_count.clear();

		if (iteminfo.type == 3)
		{
			for (local i = 0; i < this.use_lvl; i++)
			{
				this.use_count.push(0.0);
			}
		}
		else// if (this.use_type == 2)
		{
			this.use_count.push(0.0);
		}

		if (bdouble)
		{
			for (local i = 0; i < iteminfo.cast_count_double; i++)
			{
				this.use_count.push(0.0);
			}
		}

		this.CreateStars();
	}

	function Use()
	{
		if ((this.status_double_ban_time <= 0.0) &&
		(this.status_silence_time <= 0.0) &&
		((this.use_type == 1 && this.GetFreeCount() > 0) ||
		(this.use_type == 2 && this.use_count.len() > 0 && this.GetFreeCount() == this.use_count.len())))
		{
			return true;
		}
		return false;
	}

	function CreateStars()
	{
		if (this.name == "Potion" ||
		this.name ==  "Ammo" ||
		this.name == "Hook" ||
		this.name == "Phoenix")
		{
			return;
		}

		this.stars = [];
		local kv = {};
		local temp;
		local color = GetItemInfoByName(this.name).gun_particle_light_color;

		kv["model"] <- "models/friend/cosmov6/star_01.mdl";
		kv["glowdist"] <- 512;
		kv["parentname"] <- this.button.GetName();
		kv["glowstyle"] <- 1;
		kv["renderamt"] <- 1;
		kv["rendermode"] <- 2;
		// for (local i = 0; i < 3; i++)
		// {
		//     kv["pos"] <- class_pos(temp, Vector(90, 0, 0));
		//     this.stars.push(Prop_dynamic_Glow_Maker.CreateEntity(kv));
		//     temp = this.gun.GetOrigin() + (this.gun.GetLeftVector() * (-STARS_DISTANCE + i * STARS_DISTANCE)) + (this.gun.GetForwardVector() * 35) + (this.gun.GetUpVector() * 45);
		// }

		for (local i = 0; i < this.use_lvl; i++)
		{
			temp = this.button.GetOrigin();
			temp += this.button.GetLeftVector() * (-STARS_DISTANCE + i * STARS_DISTANCE);
			temp += this.button.GetForwardVector() * (STARS_DISTANCE_F + ((i != 1) ? -1.5 : 0));

			kv["pos"] <- class_pos(temp);
			// kv["rendercolor"] <- color;
			kv["glowcolor"] <- color;

			temp = Prop_dynamic_Glow_Maker.CreateEntity(kv)

			temp.SetForwardVector(this.button.GetForwardVector());
			temp.SetAngles(90, ((i == 0) ? STARS_ANG : ((i == 2) ? -STARS_ANG : 0)), 0);
			this.stars.push(temp);
		}
		color = null;

		switch (this.owner.GetHealth())
		{
			case 96:
			color = GetItemInfoByName("Support_Last").gun_particle_light_color;
				break;
			case 97:
			color = GetItemInfoByName("Support_Double").gun_particle_light_color;
				break;
			case 98:
			color = GetItemInfoByName("Support_Recovery").gun_particle_light_color;
				break;
			case 99:
			color = GetItemInfoByName("Support_Turbo").gun_particle_light_color;
				break;
			case 100:
			color = GetItemInfoByName("Support_Radius").gun_particle_light_color;
				break;
		}

		if (color != null)
		{
			temp = this.button.GetOrigin();
			temp += this.button.GetUpVector() * -STARS_DISTANCE;
			temp += this.button.GetForwardVector() * STARS_DISTANCE_F;

			kv["pos"] <- class_pos(temp);
			kv["glowcolor"] <- color;
			temp = Prop_dynamic_Glow_Maker.CreateEntity(kv)

			temp.SetForwardVector(this.button.GetForwardVector());
			temp.SetAngles(90, 0, 0);
			this.stars.push(temp);
		}
	}

	function DropItem()
	{
		this.lastowner = this.owner;
		this.owner = null;
		if (this.stars != null)
		{
			for (local i = 0; i < this.stars.len(); i++)
			{
				this.stars[i].Destroy();
			}
		}
		printl("DROPITEM");
	}

	function GetFreeCount()
	{
		local i = 0;
		foreach (count in this.use_count)
		{
			if (count < 0.1)
			{
				i++;
			}
		}
		return i;

		// for (local i = 0; i < this.use_count.len(); i++)
		// {
		//     if (this.use_count[i] != -1 && this.use_count < 0.1)
		//     {
		//         return i;
		//     }
		// }
		// return -1;
	}
	function GetFirstCD()
	{
		for (local i = 0; i < this.use_count.len(); i++)
		{
			if (this.use_count[i] > 0.0)
			{
				return i;
			}
		}
		return null;
	}

	function GetSmallCD()
	{
		if (this.use_count.len() < 1)
		{
			return null;
		}

		local ID = 0;

		for (local i = 0; i < this.use_count.len(); i++)
		{
			if (this.use_count[i] > 0.0 && this.use_count[ID] > this.use_count[i])
			{
				ID = i;
			}
		}

		if (this.use_count[ID] == 0.0)
		{
			return null;
		}
		return ID;
	}

	function ReturnFreeCount()
	{
		for (local i = 0; i < this.use_count.len(); i++)
		{
			if (this.use_count[i] < 0.1)
			{
				return i;
			}
		}
		return null;
	}
}

function PressItem()
{
	ScriptPrintMessageChatAll("PressItem");
	local item_class = GetItemByButton(caller);
	printl(item_class.name + " : " + caller);
	if (item_class == null || item_class.owner != activator)
	{
		printl("NOT OWNER " +  item_class + " : " + item_class.owner);
		return;
	}

	local item_info = GetItemInfoByName(item_class.name);
	if (item_info == null)
	{
		return;
	}
	if (item_class.Use())
	{
		ScriptPrintMessageChatAll("DO ITEM: " + item_class.name);
		//SetCDItem(item_class);

		if (item_class.name == "Bio")
		{
			return UseBio(item_class, item_info);
		}

		if (item_class.name == "Wind")
		{
			return UseWind(item_class, item_info);
		}

		if (item_class.name == "Gravity")
		{
			return UseGravity(item_class, item_info);
		}

		if (item_class.name == "Fire")
		{
			return UseFire(item_class, item_info);
		}

		if (item_class.name == "Summon")
		{
			return UseSummon(item_class, item_info);
		}

		if (item_class.name == "Electro")
		{
			return UseElectro(item_class, item_info);
		}

		if (item_class.name == "Ice")
		{
			return UseIce(item_class, item_info);
		}

		if (item_class.name == "Earth")
		{
			return UseEarth(item_class, item_info);
		}

		if (item_class.name == "Poison")
		{
			return UsePoison(item_class, item_info);
		}

		if (item_class.name == "Ultima")
		{
			return UseUltima(item_class, item_info);
		}

		if (item_class.name == "Heal")
		{
			return UseHeal(item_class, item_info);
		}

		if (item_class.name == "Potion")
		{
			return UsePotion(item_class, item_info);
		}

		if (item_class.name == "Ammo")
		{
			return UseAmmo(item_class, item_info);
		}

		if (item_class.name == "Phoenix")
		{
			return UsePhoenix(item_class, item_info);
		}

		if (item_class.name == "Hook")
		{
			return UseHook(item_class, item_info);
		}
	}
}


function SetCDItem(item_class)
{
	local ID = null;
	switch (item_class.use_type)
	{
		case 1:
			ID = item_class.ReturnFreeCount();
			if (ID == null)
			{
				return;
			}

			local ilvlstaff = item_class.use_lvl - 1;
			local item_info = GetItemInfoByName(item_class.name);
			item_class.use_count[ID] = item_info.GetCD(ilvlstaff);
			break;

			break;
		case 2:
			ID = item_class.ReturnFreeCount();
			if (ID == null)
			{
				return;
			}
			item_class.use_count.remove(ID);
			ID = item_class.ReturnFreeCount();
			if (ID == null)
			{
				item_class.TurnOff();
				return;
			}
			local ilvlstaff = item_class.use_lvl - 1;
			local item_info = GetItemInfoByName(item_class.name);
			item_class.use_count[ID] = item_info.GetDuration(ilvlstaff);
			break;

		default:
			return;
	}

	if (!item_class.Use() && item_class.effects)
	{
		item_class.TurnOff();
	}
	CallFunction("TickCDItem(" + ID  + ")", 0.0, item_class.button, item_class.button);
	// EntFireByHandle(self, "RunScriptCode", "TickCDItem(" + ID  + ")", 0.0, item_class.button, item_class.button);
}

function TickCDItem(ID)
{
	local item_class = GetItemByButton(activator);
	if (item_class == null)
	{
		return;
	}

	if (--item_class.use_count[ID] < 0.0)
	{
		item_class.use_count[ID] = 0.0;
		if (item_class.Use() && !item_class.effects)
		{
			item_class.TurnOn();
		}
	}
	else
	{
		CallFunction("TickCDItem(" + ID  + ")", 1.0, activator, activator);
		// EntFireByHandle(self, "RunScriptCode", "TickCDItem(" + ID + ")", 1.0, activator, activator);
	}
}

function SetSilenceItem()
{
	local item_class = GetItemByOwner(activator);
	if (item_class == null)
	{
		return;
	}

	item_class.status_silence_time = 100;

	if (item_class.effects)
	{
		item_class.TurnOff();
	}
	CallFunction("TickSilenceItem()", 0.0, item_class.button, item_class.button);
	// EntFireByHandle(self, "RunScriptCode", "TickSilenceItem()", 0.0, item_class.button, item_class.button);
}

function TickSilenceItem()
{
	local item_class = GetItemByButton(activator);
	if (item_class == null)
	{
		return;
	}

	if (--item_class.status_silence_time < 0.0)
	{
		item_class.status_silence_time = 0.0;
		if (item_class.Use() && !item_class.effects)
		{
			item_class.TurnOn();
		}
	}
	else
	{
		CallFunction("TickSilenceItem()", 1.0, activator, activator);
		EntFireByHandle(self, "RunScriptCode", "TickSilenceItem()", 1.0, activator, activator);
	}
}

function UseHook(item_class, item_info)
{
	local ilvlstaff = item_class.use_lvl - 1;

	local kv = {};
	local trigger;

	local fRadius = item_info.GetRadius(ilvlstaff);
	local iSpeed = item_info.GetTime(ilvlstaff);

	local iSize = 16;
	iSize = Vector(iSize, iSize, iSize);

	kv["pos"] <- class_pos(item_class.parent_entity.GetOrigin());
	kv["vscripts"] <- item_info.vscripts;

	trigger = Trigger_Maker.CreateEntity(kv);
	trigger.SetSize(Vector(-iSize.x, -iSize.y, -iSize.z), iSize);
	AOP(trigger, "solid", 3);
	trigger.SetForwardVector(item_class.parent_entity.GetForwardVector());

	item_class.model.ValidateScriptScope();
	EF(item_class.model, "ClearParent");
	EntFireByHandle(item_class.model, "RunScriptCode", "self.SetOrigin(activator.GetOrigin());self.SetForwardVector(activator.GetForwardVector())", 0, trigger, trigger);
	EntFireByHandle(item_class.model, "SetParent", "!activator", 0, trigger, trigger);

	trigger.GetScriptScope().g_fRadius = fRadius;
	trigger.GetScriptScope().g_hOwner = item_class.owner;
	trigger.GetScriptScope().g_iSpeed = iSpeed;
	trigger.GetScriptScope().g_icItem = item_class;
	trigger.GetScriptScope().g_hModel = item_class.model;

	trigger.GetScriptScope().Enable();
}

::UseHookAfter <- function(item_class)
{
	EF(item_class.model, "ClearParent");
	EntFireByHandle(item_class.model, "RunScriptCode", "self.SetOrigin(activator.GetOrigin() + (activator.GetForwardVector() * 35 + activator.GetUpVector() * -10));self.SetForwardVector(activator.GetForwardVector())", 0, item_class.parent_entity, item_class.parent_entity);
	EntFireByHandle(item_class.model, "SetParent", "!activator", 0, item_class.parent_entity, item_class.parent_entity);
}

function UseBio(item_class, item_info)
{
	local ilvlstaff = item_class.use_lvl - 1;

	local kv = {};
	local particle;
	local trigger;

	local fDuration = item_info.GetDuration(ilvlstaff);
	local fRadius = item_info.GetRadius(ilvlstaff);
	fRadius = Vector(fRadius, fRadius, fRadius);

	local iDamage = (item_info.GetDamage(ilvlstaff) * TICKRATE_ITEMWORK).tointeger();

	local temp = item_class.gun.GetOrigin();
	temp += item_class.gun.GetForwardVector() * item_info.GetCastRangeForward(ilvlstaff);
	temp += item_class.gun.GetUpVector() * item_info.GetCastRangeUp(ilvlstaff);
	temp += item_class.gun.GetLeftVector() * item_info.GetCastRangeLeft(ilvlstaff);

	kv["pos"] <- class_pos(temp);
	kv["effect_name"] <- item_info.GetParticle(ilvlstaff);

	particle = Particle_Maker.CreateEntity(kv);
	EF(particle, "Start");

	kv = {};
	kv["pos"] <- class_pos(temp);
	kv["vscripts"] <- item_info.vscripts;

	trigger = Trigger_Maker.CreateEntity(kv);
	trigger.SetSize(Vector(-fRadius.x, -fRadius.y, -fRadius.z), fRadius);
	AOP(trigger, "solid", 3);

	trigger.GetScriptScope().g_iDamage = iDamage;

	StartItemTriggerTick(trigger);

	EF(particle, "Kill", "", fDuration);
	EF(trigger, "Kill", "", fDuration);
}

function UseWind(item_class, item_info)
{
	local ilvlstaff = item_class.use_lvl - 1;

	local kv = {};
	local particle;
	local trigger;

	local fDuration = item_info.GetDuration(ilvlstaff);
	local fRadius = item_info.GetRadius(ilvlstaff);
	local fRadiusf = fRadius + fRadius * item_info.GetTime(ilvlstaff);
	fRadiusf = Vector(fRadiusf, fRadiusf, fRadius);

	local iPower = item_info.GetDamage(ilvlstaff).tointeger();

	local temp = item_class.gun.GetOrigin();
	temp += item_class.gun.GetForwardVector() * item_info.GetCastRangeForward(ilvlstaff);
	temp += item_class.gun.GetUpVector() * item_info.GetCastRangeUp(ilvlstaff);
	temp += item_class.gun.GetLeftVector() * item_info.GetCastRangeLeft(ilvlstaff);

	kv["pos"] <- class_pos(temp);
	kv["effect_name"] <- item_info.GetParticle(ilvlstaff);

	particle = Particle_Maker.CreateEntity(kv);
	EF(particle, "Start");

	kv = {};
	kv["pos"] <- class_pos(temp + Vector(0, 0, fRadiusf.z));
	kv["vscripts"] <- item_info.vscripts;

	trigger = Trigger_Maker.CreateEntity(kv);
	trigger.SetSize(Vector(-fRadiusf.x, -fRadiusf.y, -fRadiusf.z), fRadiusf);
	AOP(trigger, "solid", 3);

	trigger.GetScriptScope().g_iPower = iPower;
	trigger.GetScriptScope().g_fRadius = fRadius;

	EntFireByHandle(particle, "SetParent", "!activator", 0, item_class.gun, item_class.gun);
	EntFireByHandle(trigger, "SetParent", "!activator", 0, item_class.gun, item_class.gun);
	StartItemTriggerTick(trigger);

	EF(particle, "Kill", "", fDuration - 0.75);
	EF(trigger, "Kill", "", fDuration);
}

function UseGravity(item_class, item_info)
{
	local ilvlstaff = item_class.use_lvl - 1;

	local kv = {};
	local particle;
	local trigger;

	local fDuration = item_info.GetDuration(ilvlstaff);
	local fRadius = item_info.GetRadius(ilvlstaff);
	local fRadiusf = fRadius + fRadius * item_info.GetTime(ilvlstaff);
	fRadiusf = Vector(fRadiusf, fRadiusf, fRadius);

	local iPower = item_info.GetDamage(ilvlstaff).tointeger();

	local temp = item_class.gun.GetOrigin();
	temp += item_class.gun.GetForwardVector() * item_info.GetCastRangeForward(ilvlstaff);
	temp += item_class.gun.GetUpVector() * item_info.GetCastRangeUp(ilvlstaff);
	temp += item_class.gun.GetLeftVector() * item_info.GetCastRangeLeft(ilvlstaff);

	kv["pos"] <- class_pos(temp);
	kv["effect_name"] <- item_info.GetParticle(ilvlstaff);

	particle = Particle_Maker.CreateEntity(kv);
	EF(particle, "Start");

	kv = {};
	kv["pos"] <- class_pos(temp);
	kv["vscripts"] <- item_info.vscripts;

	trigger = Trigger_Maker.CreateEntity(kv);
	trigger.SetSize(Vector(-fRadiusf.x, -fRadiusf.y, -fRadiusf.z), fRadiusf);
	AOP(trigger, "solid", 3);

	trigger.GetScriptScope().g_iPower = iPower;
	trigger.GetScriptScope().g_fRadius = fRadius;
	trigger.GetScriptScope().Init();

	StartItemTriggerTick(trigger);

	EF(particle, "Kill", "", fDuration);
	EF(trigger, "RunScriptCode", "Disable()", fDuration);
	EF(trigger, "Kill", "", fDuration);
}

function UseFire(item_class, item_info)
{
	local ilvlstaff = item_class.use_lvl - 1;

	local kv = {};
	local particle;
	local trigger;

	local fDuration = item_info.GetDuration(ilvlstaff);
	local fRadius = item_info.GetRadius(ilvlstaff);
	fRadius = Vector(fRadius, fRadius, fRadius);

	local iDamage = (item_info.GetDamage(ilvlstaff) * TICKRATE_ITEMWORK).tointeger();
	local fFireRate = (item_info.GetTime(ilvlstaff) * TICKRATE_ITEMWORK);
	ScriptPrintMessageChatAll("FIREDAMAGE " + fFireRate);
	local temp = item_class.gun.GetOrigin();
	temp += item_class.gun.GetForwardVector() * item_info.GetCastRangeForward(ilvlstaff);
	temp += item_class.gun.GetUpVector() * item_info.GetCastRangeUp(ilvlstaff);
	temp += item_class.gun.GetLeftVector() * item_info.GetCastRangeLeft(ilvlstaff);

	kv["pos"] <- class_pos(temp);
	kv["effect_name"] <- item_info.GetParticle(ilvlstaff);

	particle = Particle_Maker.CreateEntity(kv);
	EF(particle, "Start");

	kv = {};
	kv["pos"] <- class_pos(temp);
	kv["vscripts"] <- item_info.vscripts;

	trigger = Trigger_Maker.CreateEntity(kv);
	trigger.SetSize(Vector(-fRadius.x, -fRadius.y, -fRadius.z), fRadius);
	AOP(trigger, "solid", 3);

	trigger.GetScriptScope().g_iDamage = iDamage;
	trigger.GetScriptScope().g_fFireRate = fFireRate;

	EntFireByHandle(particle, "SetParent", "!activator", 0, item_class.gun, item_class.gun);
	EntFireByHandle(trigger, "SetParent", "!activator", 0, item_class.gun, item_class.gun);
	StartItemTriggerTick(trigger);

	EF(particle, "Kill", "", fDuration);
	EF(trigger, "Kill", "", fDuration);
}

function StartItemTriggerTick(trigger)
{
	ITEMS_TRIGGERS.push(trigger);
	if (!g_bTicking_ItemTrigger)
	{
		g_bTicking_ItemTrigger = true;
		TickItemTrigger();
	}
}
// 99 543 -33 (65) (95) (33)
// 32 448 0
264
// -29 417 -31 
function UseEarth(item_class, item_info)
{
	
	local ilvlstaff = item_class.use_lvl - 1;
	ScriptPrintMessageChatAll("Earth : " + ilvlstaff);
	local fDuration = item_info.GetDuration(ilvlstaff);
	
	local temp = item_class.gun.GetOrigin();
	temp += item_class.gun.GetForwardVector() * item_info.GetCastRangeForward(ilvlstaff);
	temp += item_class.gun.GetUpVector() * item_info.GetCastRangeUp(ilvlstaff);
	temp += item_class.gun.GetLeftVector() * item_info.GetCastRangeLeft(ilvlstaff);

	local time = 0.00;
	local origin = temp;
	local ang = Vector(item_class.gun.GetAngles().x, item_class.gun.GetAngles().y + 90, 35);

	temp += Vector(0, 0, -70);

	for (local i = -1; i < ilvlstaff; i++)
	{
		origin = class_pos(temp, ang);
		EF(CreateEarth(origin, item_info.use_model_name[0], time += 0.01), "Kill", "", fDuration);
		origin = class_pos(temp + Vector(65 + RandomInt(-5, 5), 65 + RandomInt(-5, 5), -33), ang + Vector(0, RandomInt(-15, 15), RandomInt(-15, 15)));
		EF(CreateEarth(origin, item_info.use_model_name[1], time += 0.01), "Kill", "", fDuration);
		origin = class_pos(temp + Vector(65 + RandomInt(-5, 5), 0 + RandomInt(-5, 5), -33), ang + Vector(0, RandomInt(-15, 15), RandomInt(-15, 15)));
		EF(CreateEarth(origin, item_info.use_model_name[1], time += 0.01), "Kill", "", fDuration);
		origin = class_pos(temp + Vector(0 + RandomInt(-5, 5), 65 + RandomInt(-5, 5), -33), ang + Vector(0, RandomInt(-15, 15), RandomInt(-15, 15)));
		EF(CreateEarth(origin, item_info.use_model_name[1], time += 0.01), "Kill", "", fDuration);
		origin = class_pos(temp + Vector(-65 + RandomInt(-5, 5), -65 + RandomInt(-5, 5), -33), ang + Vector(0, RandomInt(-15, 15), RandomInt(-15, 15)));
		EF(CreateEarth(origin, item_info.use_model_name[1], time += 0.01), "Kill", "", fDuration);
		origin = class_pos(temp + Vector(-65 + RandomInt(-5, 5), 0 + RandomInt(-5, 5), -33), ang + Vector(0, RandomInt(-15, 15), RandomInt(-15, 15)));
		EF(CreateEarth(origin, item_info.use_model_name[1], time += 0.01), "Kill", "", fDuration);
		origin = class_pos(temp + Vector(0 + RandomInt(-5, 5), -65 + RandomInt(-5, 5), -33), ang + Vector(0, RandomInt(-15, 15), RandomInt(-15, 15)));
		EF(CreateEarth(origin, item_info.use_model_name[1], time += 0.01), "Kill", "", fDuration);
		origin = class_pos(temp + Vector(65 + RandomInt(-5, 5), -65 + RandomInt(-5, 5), -33), ang + Vector(0, RandomInt(-15, 15), RandomInt(-15, 15)));
		EF(CreateEarth(origin, item_info.use_model_name[1], time += 0.01), "Kill", "", fDuration);
		origin = class_pos(temp + Vector(-65 + RandomInt(-5, 5), 65 + RandomInt(-5, 5), -33), ang + Vector(0, RandomInt(-15, 15), RandomInt(-15, 15)));
		EF(CreateEarth(origin, item_info.use_model_name[1], time += 0.01), "Kill", "", fDuration);
		
		time += 0.20;
		temp += item_class.gun.GetForwardVector() * 214;
	}
}

function CreateEarth(pos, model, time)
{
	local earth;
	local kv = {};
	kv["model"] <- model;
	kv["pos"] <- pos;
	kv["solid"] <- 6;
	earth = Prop_dynamic_Glow_Maker.CreateEntity(kv);
	
	local mover;
	local kv = {};
	kv["pos"] <- pos;
	kv["spawnflags"] <- 1;
	kv["movedir"] <- "-90 0 0";
	kv["movedistance"] <- 70;
	kv["speed"] <- 350;
	
	mover = Movelinear_Maker.CreateEntity(kv);

	EntFireByHandle(earth, "SetParent", "!activator", 0, mover, mover);
	EF(mover, "Open", "", time);
	
	return mover;
}

function TickItemTrigger()
{
	if (g_bTicking_ItemTrigger)
	{
		g_bTicking_ItemTrigger = false;
		for (local i = 0; i < ITEMS_TRIGGERS.len(); i++)
		{
			if (TargerValid(ITEMS_TRIGGERS[i]))
			{
				ITEMS_TRIGGERS[i].GetScriptScope().Tick();
				g_bTicking_ItemTrigger = true;
			}
			else
			{
				ITEMS_TRIGGERS.remove(i);
				i--;
			}
		}
		if (g_bTicking_ItemTrigger)
		{
			CallFunction("TickItemTrigger()", TICKRATE_ITEMWORK);
			// EF(self, "RunScriptCode", "TickItemTrigger();", TICKRATE_ITEMWORK);
		}
	}
}

function PickUpItemTrigger()
{
	printl("PickUpItemTrigger");

	local item_trigger = GetItemPickByTrigger(caller);
	local player_class = activator;

	if (item_trigger == null || player_class == null)
	{
		return;
	}

	local knife = null;
	while ((knife = Entities.FindByClassname(knife,"weapon_knife*")) != null)
	{
		if (knife.GetOwner() == activator)
		{
			knife.Destroy();
			break;
		}
	}

	item_trigger.trigger.Destroy();
	EF(item_trigger.gun, "ToggleCanBePickedUp");
	item_trigger.gun.SetOrigin(activator.GetOrigin());
}

function PickUpItemTriggerLast()
{
	local item_trigger = GetItemPickByGun(caller);
	local player_class = activator;

	if (item_trigger == null || player_class == null)
	{
		return;
	}

	if (item_trigger.name == "Hook")
	{
		CreateHook(item_trigger.gun, activator);
	}

	for (local i = 0; i < ITEMS_PICK.len(); i++)
	{
		if (ITEMS_PICK[i].gun == item_trigger.gun)
		{
			ITEMS_PICK.remove(i);
		}
	}
}

function CreateHook(gun, owner)
{
	local item_info = GetItemInfoByName("Hook");
	local item_class = GetItemByGun(gun);

	local nparent = CreateEyeParent(owner);

	local kv = {};

	local button;
	local model;
	local temp;

	item_class.parent_measure = nparent[0];
	item_class.parent_entity = nparent[1];

	kv = {};
	temp = item_class.parent_entity.GetOrigin() + (item_class.parent_entity.GetForwardVector() * 60 + item_class.parent_entity.GetUpVector() * 25);
	temp = class_pos(temp, Vector(0, 0, 0));
	kv["pos"] <- temp;
	kv["parentname"] <- item_class.parent_entity.GetName();
	kv["model"] <- "*" + 9;
	kv["spawnflags"] <- 17409;
	kv["wait"] <- 0.1;
	button = Button_Maker.CreateEntity(kv);
	button.SetForwardVector(item_class.parent_entity.GetForwardVector());

	kv = {};
	temp = item_class.parent_entity.GetOrigin() + (item_class.parent_entity.GetForwardVector() * 35 + item_class.parent_entity.GetUpVector() * -10);
	temp = class_pos(temp, Vector(0, 0, 0));
	kv["pos"] <- temp;
	kv["parentname"] <- item_class.parent_entity.GetName();
	kv["model"] <- item_info.gun_model;
	kv["solid"] <- 0;
	model = Prop_dynamic_Glow_Maker.CreateEntity(kv);
	model.SetForwardVector(item_class.parent_entity.GetForwardVector());

	item_class.model = model;
	item_class.button = button;
	CallFunction("PickUpItem()", 0.00, owner, gun);
	// EntFireByHandle(self, "RunScriptCode", "PickUpItem()", 0.00, owner, gun);

	AOP(item_class.button, "OnPressed map_script_item_controller:RunScriptCode:PressItem():0:-1", null);
}

function PickUpItem()
{
	printl("PickUpItem");
	local item_class = GetItemByGun(caller);
	local player_class = activator;
	if (item_class == null || player_class == null)
	{
		return;
	}

	item_class.PickUpItem(player_class);

	if (!g_bTicking_ItemCheck)
	{
		printl("g_bTicking_ItemCheck");
		g_bTicking_ItemCheck = true;
		CheckItems();
	}

	if (!g_bTicking_EntWatch)
	{
		printl("g_bTicking_EntWatch");
		g_bTicking_EntWatch = true;
		EntWatch();
	}
}

function CheckItems()
{
	// printl("CheckItems");
	if (g_bTicking_ItemCheck)
	{
		g_bTicking_ItemCheck = false;
		for (local i = 0; i < ITEMS.len(); i++)
		{
			if (ITEMS[i].owner != null)
			{
				if (ITEMS[i].gun.GetRootMoveParent() != ITEMS[i].owner)
				{
					ITEMS[i].DropItem();
				}
				else
				{
					g_bTicking_ItemCheck = true;
				}
			}
		}
		if (g_bTicking_ItemCheck)
		{
			CallFunction("CheckItems()", TICKRATE_ITEMCHECK);
			// EF(self, "RunScriptCode", "CheckItems();", TICKRATE_ITEMCHECK);
		}
	}
}

function EntWatch()
{
	// printl("EntWatch");
	if (g_bTicking_EntWatch)
	{
		g_bTicking_EntWatch = false;
		for (local i = 0; i < ITEMS.len(); i++)
		{
			if (ITEMS[i].owner != null)
			{
				local text = ITEMS[i].name + " - " + ITEMS[i].owner;

				g_bTicking_EntWatch = true;
				if (ITEMS[i].status_silence_time > 0.0)
				{
					text += " - " + "[" + "S" + " - " + ITEMS[i].status_silence_time + "]";
				}
				else if (ITEMS[i].status_double_ban_time > 0.0)
				{
					text += " - " + "[" + "T" + " - " + ITEMS[i].status_double_ban_time + "]";
				}
				else if (ITEMS[i].use_type == 1)
				{
					if (ITEMS[i].use_count.len() > 1)
					{
						if (ITEMS[i].GetFreeCount() > 0)
						{
							text += " - " + "[" + ITEMS[i].GetFreeCount() + "/" + ITEMS[i].use_count.len() + "]";
						}
						else
						{
							local ID = ITEMS[i].GetSmallCD();
							if (ID == null)
							{
								text += " - " + "[" + ITEMS[i].GetFreeCount() + "/" + ITEMS[i].use_count.len() + "]";
							}
							else
							{
								text += " - " + "[" + ITEMS[i].use_count[ID] + "]";
							}
						}
					}
					else
					{
						if (ITEMS[i].use_count[0] < 0.1)
						{
							text += " - " + "[" + "R" + "]";
						}
						else
						{
							text += " - " + "[" + ITEMS[i].use_count[0] + "]";
						}
					}
				}
				else if (ITEMS[i].use_type == 2)
				{
					local ID = ITEMS[i].GetFirstCD();
					if (ID == null)
					{
						if (ITEMS[i].use_count.len() > 1)
						{
							text += " - " + "[" + ITEMS[i].GetFreeCount() + "/" + ITEMS[i].use_count.len() + "]";
						}
						else if (ITEMS[i].use_count.len() == 1)
						{
							text += " - " + "[" + "R" + "]";
						}
						else
						{
							text += " - " + "[" + "E" + "]";
						}
					}
					else
					{
						text += " - " + "[" + ITEMS[i].use_count[ID] + "]";
					}
				}
				ScriptPrintMessageChatAll(text);
			}
		}

		if (g_bTicking_EntWatch)
		{
			CallFunction("EntWatch()", TICKRATE_ENTWATCH);
			// EF(self, "RunScriptCode", "EntWatch();", TICKRATE_ENTWATCH);
		}
	}
}


::GetItemByGun <- function(gun)
{
	printl(gun);
	foreach (item in ITEMS)
	{
		if (item.gun == gun)
		{
			return item;
		}
	}
	return null;
}

::GetItemByButton <- function(button)
{
	foreach (item in ITEMS)
	{
		if (item.button == button)
		{
			return item;
		}
	}
	return null;
}

::GetItemByOwner <- function(owner)
{
	foreach (item in ITEMS)
	{
		if (item.owner == owner)
		{
			return item;
		}
	}
	return null;
}

::GetItemPickByTrigger <- function(trigger)
{
	foreach (item in ITEMS_PICK)
	{
		if (item.trigger == trigger)
		{
			return item;
		}
	}
	return null;
}

::GetItemPickByGun <- function(gun)
{
	foreach (item in ITEMS_PICK)
	{
		if (item.gun == gun)
		{
			return item;
		}
	}
	return null;
}