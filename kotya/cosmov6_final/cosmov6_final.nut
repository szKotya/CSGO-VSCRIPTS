::Main_Script <- self.GetScriptScope();

function RoundStart()
{
	local h;
	h = Entities.CreateByClassname("logic_script");
	EF(h, "RunScriptFile", "kotya/cosmov6_final/prespawn/prespawn_controller.nut");
	AOP(h, "targetname", "map_script_prespawn_controller");

	h = Entities.CreateByClassname("logic_script");
	EF(h, "RunScriptFile", "kotya/cosmov6_final/items/item_controller.nut");
	AOP(h, "targetname", "map_script_item_controller");

	h = Entities.CreateByClassname("logic_script");
	EF(h, "RunScriptFile", "kotya/cosmov6_final/map_manager.nut");
	AOP(h, "targetname", "map_script_map_manager");

	h = Entities.CreateByClassname("logic_script");
	EF(h, "RunScriptFile", "kotya/cosmov6_final/menu/controller.nut");
	AOP(h, "targetname", "map_script_controller");

	h = Entities.CreateByClassname("logic_script");
	EF(h, "RunScriptFile", "kotya/cosmov6_final/menu/menu_builder.nut");
	AOP(h, "targetname", "map_script_menu_builder");

	h = Entities.CreateByClassname("logic_script");
	EF(h, "RunScriptFile", "kotya/cosmov6_final/menu/test_menu.nut");
	AOP(h, "targetname", "map_script_menu_test");

	h = Entities.CreateByClassname("logic_script");
	EF(h, "RunScriptFile", "kotya/cosmov6_final/triggers.nut");
	AOP(h, "targetname", "map_script_trigger");
	// EF("map_script_trigger", "RunScriptCode", "Spawn_Trigger()");

	//DEBUG
	SendToConsole("sv_cheats 1");
	SendToConsole("bot_stop 1");
	SendToConsole("bot_kick");
	SendToConsole("mp_freezetime 0");
	SendToConsole("mp_warmuptime 999999999");
	// EF("map_script_prespawn_controller", "RunScriptCode", "ITEMALL()");
}
SendToConsole("mp_restartgame 1");

::class_pos <- class
{
	origin = Vector(0, 0, 0);
	ox = 0;
	oy = 0;
	oz = 0;
	angles = Vector(0, 0, 0);
	ax = 0;
	ay = 0;
	az = 0;

	constructor(_origin, _angles = Vector(0, 0, 0))
	{
		this.origin = _origin;
		this.ox = _origin.x;
		this.oy = _origin.y;
		this.oz = _origin.z;

		this.angles = _angles;
		this.ax = _angles.x;
		this.ay = _angles.y;
		this.az = _angles.z;
	}
}

::ITEM_INFO <- [];
class class_iteminfo
{
	name = null;
	info = null;

	use_particle_name = null;
	use_model_name = null;
	use_particle_support_name = null;

	gun_particle_name = null;
	gun_particle_light_color = null;
	gun_particle_sprite_color = null;

	gun_model = null;

	vscripts = null;

	type = null;

	can_silence = true;
	transfer_ban_double = true;
	
	use_last = false;
	use_regen = false;

	cast_count_double = 0;

	cast_cd = null;
	cast_duration = null;
	cast_radius = null;
	cast_damage = null;
	cast_time = null;

	cast_forward = null;
	cast_up = null;
	cast_left = null;

	function Cast_SetCD(szvalue) 
	{
		this.cast_cd = ConvertStringToArrayFloat(szvalue);
	}
	function Cast_SetDuration(szvalue) 
	{
		this.cast_duration = ConvertStringToArrayFloat(szvalue);
	}
	function Cast_SetRadius(szvalue) 
	{
		this.cast_radius = ConvertStringToArrayFloat(szvalue);
	}
	function Cast_SetDamage(szvalue) 
	{
		this.cast_damage = ConvertStringToArrayFloat(szvalue);
	}
	function Cast_SetTime(szvalue) 
	{
		this.cast_time = ConvertStringToArrayFloat(szvalue);
	}
	function Cast_SetCastRangeForward(szvalue) 
	{
		this.cast_forward = ConvertStringToArrayFloat(szvalue);
	}
	function Cast_SetCastRangeUp(szvalue) 
	{
		this.cast_up = ConvertStringToArrayFloat(szvalue);
	}
	function Cast_SetCastRangeLeft(szvalue) 
	{
		this.cast_left = ConvertStringToArrayFloat(szvalue);
	}
	function ConvertStringToArrayFloat(szvalue)
	{
		local newvalue = split(szvalue, " ");
		for (local i = 0; i < newvalue.len(); i++)
		{
			newvalue[i] = newvalue[i].tofloat();
		}
		return newvalue.slice();
	}

	function SetParticle(szvalue) 
	{
		this.use_particle_name = split(szvalue, " ");
	}
	function GetParticle(i)
	{
		if (this.use_particle_name != null)
		{
			if (typeof this.use_particle_name == "array")
			{
				return Cast_Calculate(i, this.use_particle_name.slice());
			}
			return this.use_particle_name;
		}
		return -1;
	}

	function Cast_Calculate(i, array)
	{
		if (array.len() - 1 < i)
		{
			i = array.len() - 1;
		}
		else if (i < 0)
		{
			i = 0;
		}
		return array[i];
	}
	function GetCastRangeForward(i)
	{
		if (this.cast_forward != null)
		{
			return Cast_Calculate(i, this.cast_forward.slice());
		}
		return 0;
	}
	function GetCastRangeUp(i)
	{
		if (this.cast_up != null)
		{
			return Cast_Calculate(i, this.cast_up.slice());
		}
		return 0;
	}
	function GetCastRangeLeft(i)
	{
		if (this.cast_left != null)
		{
			return Cast_Calculate(i, this.cast_left.slice());
		}
		return 0;
	}
	function GetRadius(i)
	{
		if (this.cast_radius != null)
		{
			return Cast_Calculate(i, this.cast_radius.slice());
		}
		return 1;
	}
	function GetDuration(i)
	{
		if (this.cast_duration != null)
		{
			return Cast_Calculate(i, this.cast_duration.slice());
		}
		return 0;
	}
	function GetCD(i)
	{
		if (this.cast_cd != null)
		{
			return Cast_Calculate(i, this.cast_cd.slice());
		}
		return 0;
	}
	function GetDamage(i)
	{
		if (this.cast_damage != null)
		{
			return Cast_Calculate(i, this.cast_damage.slice());
		}
		return 0;
	}
	function GetTime(i)
	{
		if (this.cast_time != null)
		{
			return Cast_Calculate(i, this.cast_time.slice());
		}
		return -1;
	}
}

::GetItemInfoByName <- function(name)
{
	foreach (item in ITEM_INFO)
	{
		if (item.name.tolower() == name.tolower())
		{
			return item;
		}
	}
	return null;
}

function RegItemInfo()
{
	ITEM_INFO.clear()
	local obj;

	obj = class_iteminfo();
	obj.name = "Bio";
	obj.Cast_SetCD("80 75 70");
	obj.Cast_SetDamage("100 200 300");
	obj.Cast_SetDuration("5 6 7");
	obj.Cast_SetRadius("196 320 440");
	obj.Cast_SetTime("0.3 0.35 0.4");
	obj.Cast_SetCastRangeForward("400");
	obj.cast_up = obj.cast_radius;
	// obj.Cast_SetCastRangeLeft("0");
	obj.vscripts = "kotya/cosmov6_final/items/item_trigger_bio.nut";
	obj.type = 1;
	obj.can_silence = true;
	obj.transfer_ban_double = true;
	obj.use_last = true;
	obj.use_regen = true;
	obj.cast_count_double = 1;
	obj.info = "Slows down and boosts ZMs up";
	obj.SetParticle("custom_particle_113 custom_particle_110 custom_particle_107");
	obj.gun_particle_name = "custom_particle_005";
	obj.gun_particle_light_color = "23 226 255";
	obj.gun_particle_sprite_color = null;//obj.gun_particle_light_color;
	ITEM_INFO.push(obj);

	obj = class_iteminfo();
	obj.name = "Wind";
	obj.Cast_SetCD("80 75 70");
	obj.Cast_SetDamage("64 100 136");
	obj.Cast_SetDuration("5 6 7");
	obj.Cast_SetRadius("180 260 340");
	obj.Cast_SetTime("0.9 1.1 1.3");
	obj.Cast_SetCastRangeUp("-72");
	//obj.cast_up = obj.cast_radius;
	obj.vscripts = "kotya/cosmov6_final/items/item_trigger_wind.nut";
	obj.type = 1;
	obj.can_silence = true;
	obj.transfer_ban_double = true;
	obj.use_last = true;
	obj.use_regen = true;
	obj.cast_count_double = 1;
	obj.info = "Creates tornado that pushes ZMs";
	obj.SetParticle("custom_particle_124 custom_particle_123 custom_particle_122");
	obj.gun_particle_name = "custom_particle_001";
	obj.gun_particle_light_color = "72 249 130";
	obj.gun_particle_sprite_color = null;//obj.gun_particle_light_color;
	ITEM_INFO.push(obj);

	obj = class_iteminfo();
	obj.name = "Gravity";
	obj.Cast_SetCD("80 75 70");
	obj.Cast_SetDamage("256 256 256");
	obj.Cast_SetDuration("5 6 7");
	obj.Cast_SetRadius("512 726 1024");
	obj.Cast_SetTime("1.2 1.5 1.8");
	obj.Cast_SetCastRangeForward("120 150 180");
	obj.Cast_SetCastRangeUp("92");
	obj.vscripts = "kotya/cosmov6_final/items/item_trigger_gravity.nut";
	obj.type = 1;
	obj.can_silence = true;
	obj.transfer_ban_double = true;
	obj.use_last = true;
	obj.use_regen = true;
	obj.cast_count_double = 1;
	obj.info = "Creates a dark materia that pulls ZMs inside";
	obj.SetParticle("custom_particle_150 custom_particle_152 custom_particle_153");
	obj.gun_particle_name = "custom_particle_017";
	obj.gun_particle_light_color = "160 66 255";
	obj.gun_particle_sprite_color = null;//obj.gun_particle_light_color;
	ITEM_INFO.push(obj);

	obj = class_iteminfo();
	obj.name = "Fire";
	obj.Cast_SetCD("75 70 65");
	obj.Cast_SetDamage("350 450 500");
	obj.Cast_SetDuration("7 8 9");
	obj.Cast_SetRadius("360 512 600");
	obj.Cast_SetTime("0.5 0.75 1.0");
	obj.vscripts = "kotya/cosmov6_final/items/item_trigger_fire.nut";
	obj.type = 1;
	obj.can_silence = true;
	obj.transfer_ban_double = true;
	obj.use_last = true;
	obj.use_regen = true;
	obj.cast_count_double = 1;
	obj.info = "Creates a fire zone that burns ZMs";
	obj.SetParticle("custom_particle_139 custom_particle_135 custom_particle_131");
	obj.gun_particle_name = "custom_particle_014";
	obj.gun_particle_light_color = "231 102 24";
	obj.gun_particle_sprite_color = null;//obj.gun_particle_light_color;
	ITEM_INFO.push(obj);

	obj = class_iteminfo();
	obj.name = "Summon";
	obj.Cast_SetCD("80 75 70");
	obj.Cast_SetDamage("512 768 1024");
	obj.Cast_SetDuration("20 25 30");
	obj.Cast_SetRadius("360 430 512");
	obj.Cast_SetTime("4 5 6");
	obj.type = 1;
	obj.can_silence = true;
	obj.transfer_ban_double = true;
	obj.use_last = true;
	obj.use_regen = true;
	obj.cast_count_double = 1;
	obj.info = "Spawns a chocobo guardian";
	obj.use_model_name = "models/microrost/cosmov6/ff7r/chokobo.mdl";
	obj.SetParticle("custom_particle_129 custom_particle_127 custom_particle_125");
	obj.gun_particle_name = "custom_particle_026";
	obj.gun_particle_light_color = "255 255 0";
	obj.gun_particle_sprite_color = null;//obj.gun_particle_light_color;
	ITEM_INFO.push(obj);

	obj = class_iteminfo();
	obj.name = "Electro";
	//obj.Cast_SetCD("80 75 70");
	obj.Cast_SetDamage("300 400 500");
	obj.Cast_SetDuration("5 6 7");
	obj.Cast_SetRadius("360 430 512");
	obj.Cast_SetTime("0.15 0.2 0.25");
	obj.vscripts = "kotya/cosmov6_final/items/item_trigger_electro.nut";
	obj.type = 3;
	obj.can_silence = true;
	obj.transfer_ban_double = true;
	obj.use_last = true;
	obj.use_regen = true;
	obj.cast_count_double = 2;
	obj.info = "Creates an electric zone that slows down and damages ZMs";
	obj.SetParticle("custom_particle_145 custom_particle_144 custom_particle_143");
	obj.gun_particle_name = "custom_particle_011";
	obj.gun_particle_light_color = "7 50 248";
	obj.gun_particle_sprite_color = null;//obj.gun_particle_light_color;
	ITEM_INFO.push(obj);

	obj = class_iteminfo();
	obj.name = "Ice";
	obj.Cast_SetCD("80 75 70");
	obj.Cast_SetDamage("0.85 1.0 1.15");
	obj.Cast_SetDuration("5 6 7");
	obj.Cast_SetRadius("360 512 600");
	obj.Cast_SetTime("0.5 1 1.5");
	obj.type = 1;
	obj.can_silence = true;
	obj.transfer_ban_double = true;
	obj.use_last = true;
	obj.use_regen = true;
	obj.cast_count_double = 1;
	obj.info = "Freezes ZMs";
	obj.SetParticle("custom_particle_120 custom_particle_118 custom_particle_116");
	obj.gun_particle_name = "custom_particle_029";
	obj.gun_particle_light_color = "128 255 255";
	obj.gun_particle_sprite_color = null;//obj.gun_particle_light_color;
	ITEM_INFO.push(obj);

	obj = class_iteminfo();
	obj.name = "Earth";
	obj.Cast_SetCD("80 75 70");
	obj.Cast_SetDamage("500 1000 2000");
	obj.Cast_SetDuration("5 6 7");
	obj.Cast_SetCastRangeForward("180");
	obj.Cast_SetCastRangeUp("92");
	obj.type = 1;
	obj.can_silence = true;
	obj.transfer_ban_double = true;
	obj.use_last = true;
	obj.use_regen = true;
	obj.cast_count_double = 1;
	obj.info = "Creates a breakable rock wall";
	obj.use_model_name = ["models/kmodels/cosmo/props_wasteland/rockcliff01c.mdl", "models/kmodels/cosmo/props_wasteland/rockcliff01j.mdl"];
	obj.gun_particle_name = "custom_particle_020";
	obj.gun_particle_light_color = "157 79 0";
	obj.gun_particle_sprite_color = null;//obj.gun_particle_light_color;
	ITEM_INFO.push(obj);

	obj = class_iteminfo();
	obj.name = "Poison";
	obj.Cast_SetCD("80 75 70");
	obj.Cast_SetDamage("500 750 1000");
	obj.Cast_SetDuration("5 6 7");
	obj.Cast_SetRadius("360 430 512");
	obj.Cast_SetTime("0.1 0.15 0.2");
	obj.type = 3;
	obj.can_silence = true;
	obj.transfer_ban_double = true;
	obj.use_last = true;
	obj.use_regen = true;
	obj.cast_count_double = 2;
	obj.info = "Creates an energy that bounces from the walls\nExplodes and creates a smoke when hits ZMs";
	obj.SetParticle("custom_particle_080 custom_particle_181 custom_particle_182");
	obj.gun_particle_name = "custom_particle_032";
	obj.gun_particle_light_color = "221 251 76";
	obj.gun_particle_sprite_color = null;//obj.gun_particle_light_color;
	ITEM_INFO.push(obj);

	obj = class_iteminfo();
	obj.name = "Ultima";
	obj.Cast_SetDamage("80 90 100");
	obj.Cast_SetDuration("15");
	obj.cast_cd = obj.cast_duration;
	obj.Cast_SetRadius("740 920 1024");
	obj.Cast_SetTime("500 1000 1500");
	obj.type = 2;
	obj.can_silence = true;
	obj.transfer_ban_double = true;
	obj.use_last = true;
	obj.use_regen = true;
	obj.cast_count_double = 1;
	obj.info = "Gains an energy which explodes and deals a lot of damage to ZMs";
	obj.SetParticle("custom_particle_193 custom_particle_188 custom_particle_183");
	obj.gun_particle_name = "custom_particle_023";
	obj.gun_particle_light_color = "32 255 0";
	obj.gun_particle_sprite_color = null;//obj.gun_particle_light_color;
	ITEM_INFO.push(obj);

	obj = class_iteminfo();
	obj.name = "Heal";
	obj.Cast_SetCD("80 75 70");
	obj.Cast_SetDuration("5 6 7");
	obj.Cast_SetRadius("360 512 600");
	obj.type = 1;
	obj.can_silence = true;
	obj.transfer_ban_double = true;
	obj.use_last = true;
	obj.use_regen = true;
	obj.cast_count_double = 1;
	obj.info = "Restores the current HP to the max and gives some buffs";
	obj.SetParticle("custom_particle_154 custom_particle_157 custom_particle_158");
	obj.gun_particle_name = "custom_particle_008";
	obj.gun_particle_light_color = "255 255 255";
	obj.gun_particle_sprite_color = null;//obj.gun_particle_light_color;
	ITEM_INFO.push(obj);

	obj = class_iteminfo();
	obj.name = "Potion";
	obj.Cast_SetDuration("5 6 7");
	obj.cast_cd = obj.cast_duration;
	obj.Cast_SetRadius("360 512 600");
	obj.type = 2;
	obj.can_silence = false;
	obj.transfer_ban_double = false;
	obj.use_last = false;
	obj.use_regen = false;
	obj.info = "Heals wounds at half of max HP";
	obj.use_particle_name = "custom_particle_166";
	obj.gun_particle_light_color = "0 255 64";
	obj.gun_model = "models/kmodels/cosmo/cosmocanyon/potion/potion.mdl";
	ITEM_INFO.push(obj);

	obj = class_iteminfo();
	obj.name = "Hook";
	obj.vscripts = "kotya/cosmov6_final/items/item_trigger_hook.nut";
	obj.Cast_SetCD("30");
	obj.Cast_SetRadius("1200");
	obj.Cast_SetTime("15");
	obj.type = 1;
	obj.gun_model = "models/weapons/w_hammer_dropped.mdl";
	ITEM_INFO.push(obj);

	obj = class_iteminfo();
	obj.name = "Ammo";
	obj.Cast_SetDuration("5 6 7");
	obj.cast_cd = obj.cast_duration;
	obj.Cast_SetRadius("360 512 600");
	obj.type = 2;
	obj.can_silence = false;
	obj.transfer_ban_double = false;
	obj.use_last = false;
	obj.use_regen = false;
	obj.info = "Gives some amount of ammo";
	obj.use_particle_name = "custom_particle_167";
	obj.gun_model = "models/props/de_mirage/metal_ammo_box_1.mdl";
	ITEM_INFO.push(obj);

	obj = class_iteminfo();
	obj.name = "Phoenix";
	obj.Cast_SetDuration("6 7 8");
	obj.cast_cd = obj.cast_duration;
	obj.Cast_SetRadius("360 512 600");
	obj.type = 2;
	obj.can_silence = false;
	obj.transfer_ban_double = false;
	obj.use_last = false;
	obj.use_regen = false;
	obj.info = "Gives all types of Resist to debuffs";
	obj.use_particle_name = "custom_particle_165";
	obj.gun_particle_light_color = "155 0 0";
	obj.gun_model = "models/kmodels/cosmo/cosmocanyon/potion/potion.mdl";
	ITEM_INFO.push(obj);


	obj = class_iteminfo();
	obj.name = "Support_Last";
	obj.gun_particle_light_color = "255 0 0";
	ITEM_INFO.push(obj);

	obj = class_iteminfo();
	obj.name = "Support_Double";
	obj.gun_particle_light_color = "0 0 255";
	ITEM_INFO.push(obj);

	obj = class_iteminfo();
	obj.name = "Support_Recovery";
	obj.gun_particle_light_color = "140 0 255";
	ITEM_INFO.push(obj);

	obj = class_iteminfo();
	obj.name = "Support_Turbo";
	obj.gun_particle_light_color = "255 255 0";
	ITEM_INFO.push(obj);

	obj = class_iteminfo();
	obj.name = "Support_Radius";
	obj.gun_particle_light_color = "0 255 0";
	ITEM_INFO.push(obj);
}

::AOP <- function(item, key, value = "", d = 0.00)
{
	if (typeof item == "string")
	{
		EntFire(item, "AddOutPut", key + " " + value, d);
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
			else if (typeof value == "float")
			{
				item.__KeyValueFromFloat(key, value);
			}
			else if (typeof value == "vector")
			{
				item.__KeyValueFromVector(key, value);
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

::DamagePlayer <- function(player, damage, damagetype = null)
{
	local hp = player.GetHealth() - damage;

	if (hp <= 0)
	{
		hp = -69;
	}

	printl("hp : " +hp + " damage : " + damage);
	EF(player, "SetHealth", "" + hp);
}

::InSight <- function(start, end, ignorehandle = null)
{
	if (ignorehandle == null || typeof ignorehandle == "instance")
	{
		if (TraceLine(start, end, ignorehandle) < 1.00)
		{
			return false;
		}
		return true;
	}

	if (typeof ignorehandle == "array")
	{
		for (local i = 0; i < ignorehandle.len(); i++)
		{
			if (ignorehandle[i] == null || !ignorehandle[i].IsValid())
			{
				continue;
			}
				
			if (InSight(start, end, ignorehandle[i]))
			{
				return true;
			}	
		}
	}

	return InSight(start, end, null);
}

::GetDistance3D <- function(v1, v2){return sqrt((v1.x-v2.x)*(v1.x-v2.x)+(v1.y-v2.y)*(v1.y-v2.y)+(v1.z-v2.z)*(v1.z-v2.z));}
::GetDistance2D <- function(v1, v2){return sqrt((v1.x-v2.x)*(v1.x-v2.x)+(v1.y-v2.y)*(v1.y-v2.y));}
::GetDistanceZ <- function(v1, v2){return v1.z-v2.z;}

::DebugDrawCircle <- function(Vector_Center, radius, parts = 32, duration = 1.0) //0 -32 80
{
	local Vector_RGB = Vector(255, 255, 255);
	local u = 0.0;
	local vec_end = [];
	local parts_l = parts;
	local radius = radius;
	local a = PI / parts * 2;
	while (parts_l > 0)
	{
		local vec = Vector(Vector_Center.x+cos(u)*radius, Vector_Center.y+sin(u)*radius, Vector_Center.z);
		vec_end.push(vec);
		u += a;
		parts_l--;
	}
	for (local i = 0; i < vec_end.len(); i++)
	{
		if (i < vec_end.len()-1){DebugDrawLine(vec_end[i], vec_end[i+1], Vector_RGB.x, Vector_RGB.y, Vector_RGB.z, true, duration);}
		else{DebugDrawLine(vec_end[i], vec_end[0], Vector_RGB.x, Vector_RGB.y, Vector_RGB.z, true, duration);}
	}
}

::DebugDrawAxis <- function(pos, s = 16, time = 10)
{
	DebugDrawLine(Vector(pos.x-s,pos.y,pos.z), Vector(pos.x+s,pos.y,pos.z), 255, 0, 0, true, time);
	DebugDrawLine(Vector(pos.x,pos.y-s,pos.z), Vector(pos.x,pos.y+s,pos.z), 0, 255, 0, true, time);
	DebugDrawLine(Vector(pos.x,pos.y,pos.z-s), Vector(pos.x,pos.y,pos.z+s), 0, 0, 255, true, time);
}

::GetTwoVectorsYaw <- function(start, target)
{
	local yaw = 0.00;
	local v = Vector(start.x - target.x, start.y - target.y, start.z - target.z);
	local vl = sqrt(v.x * v.x + v.y * v.y);
	yaw = 180 * acos(v.x / vl) / PI;
	if(v.y < 0)
	{
		yaw = -yaw;
	}
	return yaw;
}
//(orig, dir, maxd, filter)
::Trace <- function(origin, dir, distance = 4096, filter = null)
{
	return  origin + (dir * (distance * TraceLine(origin, origin + dir * distance, filter)));
}

::TargerValid <- function(target)
{
	if (target == null || !target.IsValid())
	{
		return false;
	}
	return true;
}

::CallFunction <- function(func_name, fdelay = 0.0, activator = null, caller = null)
{
	EntFireByHandle(self, "RunScriptCode", "" + func_name, fdelay, activator, caller);
}

::damagetype_item <- "item";

::ValueLimiter <- function(Value, Min = null, Max = null)
{
	if (Max != null && Value > Max)
	{
		return Max;
	}
	else if (Min != null && Value < Min)
	{
		return Min;
	}
	return Value;
}

::GetSizeByWLH <- function(v1)
{
	ScriptPrintMessageChatAll("type : " + typeof v1);
	if (typeof v1 == "Vector")
	{
		return [Vector(-v1.x * 0.5, -v1.y * 0.5, -v1.z * 0.5), Vector(v1.x * 0.5, v1.y * 0.5, v1.z * 0.5)]
	}
	else
	{
		return [Vector(-v1 * 0.5, -v1 * 0.5, -v1 * 0.5), Vector(v1 * 0.5, v1 * 0.5, v1 * 0.5)]
	}
}

::KVremoveK <- function(kv, key)
{
	local newkv = {};
	foreach (k, v in kv)
	{
		printl(k + " : " + v);
		if (k == key)
		{
			continue;
		}
		newkv[k] <- v;
	}
	return newkv;
}

::KVhaveK <- function(kv, key)
{
	foreach(k,v in kv)
	{
		if (k == key)
		{
			return true;
		}
	}

	return false;
}

RegItemInfo();