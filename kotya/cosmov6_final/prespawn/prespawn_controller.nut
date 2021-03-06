::Spawn_Script <- self.GetScriptScope();

::Sprite_Maker <- null;
::Light_Maker <- null;
::Prop_dynamic_Glow_Maker <- null;
::Particle_Maker <- null;
::Physbox_Maker <- null;
::Button_Maker <- null;
::Elite_Maker <- null;
::Knife_Maker <- null;
::Trigger_Maker <- null;
::Measure_Maker <- null;
::Movelinear_Maker <- null;
::GameUI_Maker <- null;
::Beam_Maker <- null;
::Shake_Maker <- null;
::Ambient_Generic_Maker <- null;
::ID_MAKER <- 0;

function Start()
{
	local point_template;
	local szName;
	while ((point_template = Entities.FindByClassname(point_template,"point_template")) != null)
	{
		szName = point_template.GetName();
		if (szName == "prespawn_sprite")
		{
			Sprite_Maker = point_template.GetScriptScope();
		}
		else if (szName == "prespawn_light_dynamic")
		{
			Light_Maker = point_template.GetScriptScope();
		}
		else if (szName == "prespawn_info_particle_system")
		{
			Particle_Maker = point_template.GetScriptScope();
		}
		else if (szName == "prespawn_prop_dynamic_glow")
		{
			Prop_dynamic_Glow_Maker = point_template.GetScriptScope();
		}
		else if (szName == "prespawn_func_physbox")
		{
			Physbox_Maker = point_template.GetScriptScope();
		}
		else if (szName == "prespawn_func_button")
		{
			Button_Maker = point_template.GetScriptScope();
		}
		else if (szName == "prespawn_weapon_elite")
		{
			Elite_Maker = point_template.GetScriptScope();
		}
		else if (szName == "prespawn_trigger_multiple")
		{
			Trigger_Maker = point_template.GetScriptScope();
		}
		else if (szName == "prespawn_weapon_knife")
		{
			Knife_Maker = point_template.GetScriptScope();
		}
		else if (szName == "prespawn_logic_measure_movement")
		{
			Measure_Maker = point_template.GetScriptScope();
		}
		else if (szName == "prespawn_func_movelinear")
		{
			Movelinear_Maker = point_template.GetScriptScope();
		}
		else if (szName == "prespawn_game_ui")
		{
			GameUI_Maker = point_template.GetScriptScope();
		}
		else if (szName == "prespawn_env_beam")
		{
			Beam_Maker = point_template.GetScriptScope();
		}
		else if (szName == "prespawn_env_shake")
		{
			Shake_Maker = point_template.GetScriptScope();
		}
		else if (szName == "prespawn_ambient_generic")
		{
			Ambient_Generic_Maker = point_template.GetScriptScope();
		}
		printl(point_template);
	}
}

ANIM_ID <- 0;
function test(ID = -1)
{
	if (ID != -1)
	{
		ANIM_ID = ID;
	}
	else
	{
		ANIM_ID++;
	}

	local Anim_list = [
		"idle",
		"attack1",
		"attack2",
		"attack3",
		"attack4",
		"attack5",
		"attack6",
		"attack7",
		"attack8",
		"combo1",
		"combo2",
		"cure",
		"death",
		"death_idle",
		"idle_v2",
		"idle_v2_1",
		"item",
		"limit",
		"s_run",
		"s_run_i",
		"s_run_s",
		"s_runv2",
		"s_runv2_i",
		"s_runv2_s",
		"s_walk",
		"s_walk_v2",
		"s_walk_v2_e",
		"t_jump",
		"t_jump_e",
		"t_jump_i",
		"to_idle",
		"to_idle_e",
		"to_idle_s",
		"win",
	]
	if (ANIM_ID > Anim_list.len() - 1)
	{
		ANIM_ID = 0;
	}
	ScriptPrintMessageChatAll(Anim_list[ANIM_ID]);
	EF("312", "setanimation", Anim_list[ANIM_ID]);
	// local kv = {};
	// local temp = Vector(-55, 138, 39);
	// temp = class_pos(temp, Vector(0, 0, 0));
	// kv["pos"] <- temp;

	// if (ID == 0)
	// {
	//     ID = "exp1_1"
	// }
	// else if(ID == 1)
	// {
	//     ID = "exp2_1"
	// }
	// else
	// {
	//     ID = "custom_particle_" + ID.tostring();
	// }

	// kv["effect_name"] <- ID;
	// local particle_main = Particle_Maker.CreateEntity(kv);
	// EF(particle_main, "Start");
}

function ITEMALL()
{
	local start = Vector(380, 0, 0);
	for(local i = 0; i < 14; i++)
	{
		ITEM(i, start);
		start.x -= 65;
	}
}

function CreateHook(origin = Vector(-55, 138, 39))
{
	local item_info = GetItemInfoByName("Hook");

	local kv = {};

	local knife;
	local trigger;
	local temp = origin;
	local isize = Vector(16, 16, 16);

	kv["CanBePickedUp"] <- 0;
	kv["spawnflags"] <- 1;
	kv["pos"] <- class_pos(temp);
	knife = Knife_Maker.CreateEntity(kv);

	kv = {};
	kv["pos"] <- class_pos(temp);
	kv["parentname"] <- knife.GetName();

	kv["vscripts"] <- "triggerShow.nut";
	trigger = Trigger_Maker.CreateEntity(kv);
	trigger.SetSize(Vector(-isize.x, -isize.y, -isize.z), isize);
	AOP(trigger, "solid", 3);

	local item_trigger = class_item_trigger();
	item_trigger.name = item_info.name;
	item_trigger.gun = knife;
	item_trigger.trigger = trigger;

	ITEMS_PICK.push(item_trigger);

	AOP(item_trigger.trigger, "OnStartTouch map_script_item_controller:RunScriptCode:PickUpItemTrigger():0:-1", null);
	// AOP(item_trigger.trigger, "OnStartTouch map_script_item_controller:RunScriptCode:PickUpItemTrigger():0:-1", null);
	AOP(item_trigger.gun, "OnPlayerPickup map_script_item_controller:RunScriptCode:PickUpItemTriggerLast():0:-1", null);


	local item_class = class_item();

	item_class.name = item_info.name;
	item_class.gun = knife;
	ITEMS.push(item_class);
}

function ITEM(ID = 0, origin = Vector(-55, 138, 39))
{
	local kv = {};
	local elite;
	local button;
	local particle_main;
	local particle_light;
	local particle_sprite;
	local model;

	local name = "NONE";
	local color = "255 255 255";
	local particle_name = ""
	ID = ID.tointeger();

	if (ID > 13)
	{
		ID = 13;
	}
	if (ID < 0)
	{
		ID = 0;
	}

	local pos = class_pos(origin, Vector(0, 0, 0));
	local temp;

	kv["pos"] <- pos;
	kv["spawnflags"] <- 1;
	elite = Elite_Maker.CreateEntity(kv);

	kv = {};
	temp = elite.GetOrigin() + (elite.GetForwardVector() * 40) + (elite.GetUpVector() * 45);
	temp = class_pos(temp, Vector(0, 0, 0));
	kv["pos"] <- temp;
	kv["parentname"] <- elite.GetName();
	kv["model"] <- "*" + 6;
	kv["spawnflags"] <- 17409;
	kv["wait"] <- 0.1;
	button = Button_Maker.CreateEntity(kv);

	if (ITEM_INFO[ID].gun_particle_name != null)
	{
		kv = {};
		temp = button.GetOrigin() + (button.GetForwardVector() * 7) + (button.GetUpVector() * -11);
		temp = class_pos(temp, Vector(0, 0, 0));
		kv["pos"] <- temp;
		kv["parentname"] <- elite.GetName();
		kv["effect_name"] <- ITEM_INFO[ID].gun_particle_name;
		particle_main = Particle_Maker.CreateEntity(kv);
		EF(particle_main, "Start");
	}

	if (ITEM_INFO[ID].gun_model != null)
	{
		kv = {};
		if (ITEM_INFO[ID].gun_model == "models/props/de_mirage/metal_ammo_box_1.mdl")
		{
			temp = button.GetOrigin() + (button.GetForwardVector() * -7) + (button.GetUpVector() * -11);
		}
		else if (ITEM_INFO[ID].gun_model == "models/kmodels/cosmo/cosmocanyon/potion/potion.mdl")
		{
			temp = button.GetOrigin() + (button.GetForwardVector() * -7) + (button.GetUpVector() * -11);
		}
		else if (ITEM_INFO[ID].gun_model == "models/kmodels/cosmo/cosmocanyon/potion/potion.mdl")
		{
			temp = button.GetOrigin() + (button.GetForwardVector() * -7) + (button.GetUpVector() * -11);
		}
		else return;

		kv["glowenabled"] <- 0;
		if (ITEM_INFO[ID].gun_particle_light_color != null)
		{
			kv["glowcolor"] <- ITEM_INFO[ID].gun_particle_light_color;
			kv["rendermode"] <- 1;
			kv["glowstyle"] <- 1;
			kv["glowenabled"] <- 1;
		}

		kv["model"] <- ITEM_INFO[ID].gun_model;
		kv["solid"] <- 0;

		temp = class_pos(temp, Vector(0, 0, 0));
		kv["pos"] <- temp;
		kv["parentname"] <- elite.GetName();
		model = Prop_dynamic_Glow_Maker.CreateEntity(kv);
	}

	if (ITEM_INFO[ID].gun_particle_light_color != null)
	{
		kv = {};
		if (ITEM_INFO[ID].gun_model == "models/props/de_mirage/metal_ammo_box_1.mdl")
		{
			temp = button.GetOrigin() + (button.GetForwardVector() * -7) + (button.GetUpVector() * -11);
		}
		else if (ITEM_INFO[ID].gun_model == "models/kmodels/cosmo/cosmocanyon/potion/potion.mdl")
		{
			temp = button.GetOrigin() + (button.GetForwardVector() * -7) + (button.GetUpVector() * -11);
		}
		else if (ITEM_INFO[ID].gun_model == "models/kmodels/cosmo/cosmocanyon/potion/potion.mdl")
		{
			temp = button.GetOrigin() + (button.GetForwardVector() * -7) + (button.GetUpVector() * -11);
		}
		else temp = button.GetOrigin() + (button.GetForwardVector() * 7) + (button.GetUpVector() * -11);

		temp = class_pos(temp, Vector(0, 0, 0));
		kv["pos"] <- temp;
		kv["parentname"] <- elite.GetName();
		kv["_light"] <- ITEM_INFO[ID].gun_particle_light_color + " 100";
		kv["brightness"] <- 5;
		kv["distance"] <- 80;
		kv["pitch"] <- 90;
		particle_light = Light_Maker.CreateEntity(kv);
	}

	if (ITEM_INFO[ID].gun_particle_sprite_color != null)
	{
		kv = {};
		if (ITEM_INFO[ID].gun_model != null)
		{
			temp = button.GetOrigin() + (button.GetForwardVector() * -7) + (button.GetUpVector() * -11);
		}
		else
		{
			temp = button.GetOrigin() + (button.GetForwardVector() * 7) + (button.GetUpVector() * -11);
		}

		temp = class_pos(temp, Vector(0, 0, 0));
		kv["pos"] <- temp;
		kv["parentname"] <- elite.GetName();
		kv["rendercolor"] <- color;
		//kv["model"] <- "sprites/glow04.vmt"
		kv["rendermode"] <- 3;
		kv["spawnflags"] <- 1;
		particle_sprite = Sprite_Maker.CreateEntity(kv);
		AOP(particle_sprite, "renderamt", 50);
		AOP(particle_sprite, "scale", 0.5);
		EF(particle_sprite, "ShowSprite");
	}

	local item_class = class_item();

	item_class.name = ITEM_INFO[ID].name;
	item_class.button = button;
	item_class.gun = elite;
	item_class.particle_main = particle_main;
	item_class.particle_light = particle_light;
	item_class.particle_sprite = particle_sprite;
	item_class.model = model;

	item_class.status_allow_last_use = ITEM_INFO[ID].use_last;
	item_class.status_allow_last_regen = ITEM_INFO[ID].use_regen;
	item_class.status_allow_silence = ITEM_INFO[ID].can_silence;
	item_class.status_allow_transfer_ban = ITEM_INFO[ID].transfer_ban_double;

	AOP(item_class.gun, "OnPlayerPickup", "map_script_item_controller:RunScriptCode:PickUpItem():0:-1", 0.01);
	AOP(item_class.button, "OnPressed", "map_script_item_controller:RunScriptCode:PressItem():0:-1", 0.01);
	ITEMS.push(item_class);
}

function A()
{
	local kv = {};
	local trigger;
	kv["pos"] <- class_pos(Vector(-55, 138, 39), Vector(0, -41, 0));

	local size = Vector(64, 64, 64);

	kv["vscripts"] <- "triggerShow.nut";
	trigger = Trigger_Maker.CreateEntity(kv);
	trigger.SetSize(Vector(-size.x, -size.y, -size.z), size);
	AOP(trigger, "solid", 3);
	AOP(trigger, "OnStartTouch !self:RunScriptCode:ScriptPrintMessageChatAll(activator.tostring()):0:-1", null);
}

function C()
{
	local kv = {};
	kv["pos"] <- class_pos(Vector(-55, 138, 39), Vector(0, -41, 0));
	kv["model"] <- "models/props/de_dust/hr_dust/dust_crates/dust_crate_style_02_64x64x64.mdl";
	kv["modelscale"] <- 0.5;
	Prop_dynamic_Glow_Maker.CreateEntity(kv);
}

function D(ID = 0)
{
	local kv = {};
	local Button;
	kv["pos"] <- class_pos(Vector(-55, 138, 39), Vector(0, -41, 0));
	local size = Vector(256, 256, 256);
	//kv["model"] <- "*" + ID;
	kv["spawnflags"] <- 17409;
	kv["wait"] <- 0.1;
	kv["vscripts"] <- "triggerShow.nut";

	Button = Button_Maker.CreateEntity(kv);

	Button.SetSize(Vector(-size.x, -size.y, -size.z), size);
	AOP(Button, "solid", 3);
	AOP(Button, "OnPressed map_script_item_controller:RunScriptCode:PressItem():0:-1", null);
}

function S(ID = 0)
{
	local kv = {};
	kv["pos"] <- class_pos(Vector(-55, 138, 39), Vector(0, -41, 0));
	if (ID == 0)
	{
		kv["pos"].origin += Vector(0, 0, 0);
		kv["rendercolor"] <- "255 0 0";
	}
	else if (ID == 1)
	{
		kv["pos"].origin += Vector(-100, 0, 0);
		kv["rendercolor"] <- "0 255 0";
	}
	else if (ID == 2)
	{
		kv["pos"].origin += Vector(100, 0, 0);
		kv["rendercolor"] <- "0 0 255";
	}

	kv["spawnflags"] <- 1;
	kv["rendermode"] <- 3;
	Sprite_Maker.CreateEntity(kv);
	kv = {};

	kv["pos"] <- class_pos(Vector(-55, 138, -39), Vector(0, -41, 0));
	if (ID == 0)
	{
		kv["pos"].origin += Vector(0, 0, 0);
		kv["rendercolor"] <- "255 0 0 200";
	}
	else if (ID == 1)
	{
		kv["pos"].origin += Vector(-100, 0, 0);
		kv["rendercolor"] <- "0 255 0 200";
	}
	else if (ID == 2)
	{
		kv["pos"].origin += Vector(100, 0, 0);
		kv["rendercolor"] <- "0 0 255 200";
	}

	kv["brightness"] <- 10;
	kv["distance"] <- 450;
	kv["pitch"] <- 90;
	Light_Maker.CreateEntity(kv);
}

::CreateTempParent <- function()
{
	local kv = {};
	kv["model"] <- "models/editor/playerstart.mdl";
	kv["solid"] <- 0;
	kv["disableshadows"] <- 1;
	kv["rendermode"] <- 10;

	return Prop_dynamic_Glow_Maker.CreateEntity(kv);
}

::CreateEyeParent <- function(owner = null)
{
	if (owner == null)
	{
		owner = activator;
	}

	local kv = {};
	local measure;
	local nparent = CreateTempParent();
	nparent.SetOrigin(owner.EyePosition());

	EntFireByHandle(nparent, "SetParent", "!activator", 0.00, owner, owner);
	if (owner.GetName() == "")
	{
		AOP(owner, "targetname", "owner" + ID_MAKER++);
	}

	kv["TargetScale"] <- 300;
	kv["Target"] <- nparent.GetName();
	kv["TargetReference"] <- nparent.GetName();
	kv["MeasureTarget"] <- owner.GetName();
	kv["MeasureReference"] <- nparent.GetName();

	measure = Measure_Maker.CreateEntity(kv);

	return [measure, nparent];
}

::CreateBeamToPoints <- function(kv, origin1, origin2)
{
	local temp1 = CreateTempParent();
	local temp2 = CreateTempParent();
	temp1.SetOrigin(origin1);
	temp2.SetOrigin(origin2);

	return CreateBeamToTargets(kv, temp1, temp2);
}

::CreateBeamToTargets <- function(kv, target1, target2)
{
	if (target1.GetName() == "")
	{
		AOP(target1, "targetname", "parent" + ID_MAKER++);
	}
	if (target2.GetName() == "")
	{
		AOP(target2, "targetname", "parent" + ID_MAKER++);
	}
	kv["LightningEnd"] <- target1.GetName();
	kv["LightningStart"] <- target2.GetName();
	local beam = Beam_Maker.CreateEntity(kv);
	return [beam, target1, target2];
}

::CreateTrigger <- function(kv)
{
	printl(kv["size"][0] + " : " + kv["size"][1]);
	local iSize = kv["size"].slice();
	kv = KVremoveK(kv, "size");

	local trigger = Trigger_Maker.CreateEntity(kv);
	trigger.SetSize(iSize[0], iSize[1]);
	AOP(trigger, "solid", 3);
	return trigger;
}

::CreateExplosion <- function(origin, radius, damage, particle)
{
	local kv = {};

	local shake;
	local particle;
	local light;
	local sound;

	kv = {};

	kv["pos"] <- class_pos(origin);
	kv["radius"] <- radius * 2.0;
	kv["amplitude"] <- 14;
	kv["duration"] <- 1.0;
	kv["frequency"] <- 10;
	kv["spawnflags"] <- 28;

	shake = Shake_Maker.CreateEntity(kv);
	EF(shake, "StartShake");

	if (damage > 0)
	{
		local player;
		local distance;
		while ((player = Entities.FindByClassnameWithin(player, "player", origin, radius)) != null)
		{
			if (player.IsValid() &&
			player.GetHealth() > 0)
			{
				if (InSight(player.GetOrigin() + Vector(0, 0, 45), origin))
				{
					distance = GetDistance3D(player.EyePosition(), origin) / radius;
					DamagePlayer(player, (damage - ((distance > 0.25) ? distance : 0) * damage), DamageType_Explosion);
				}
			}
		}
	}

	kv = {};
	kv["pos"] <- class_pos(origin);
	kv["effect_name"] <- "exp1_1";
	particle = Particle_Maker.CreateEntity(kv);
	EF(particle, "Start");

	kv = {};
	kv["pos"] <- class_pos(origin);
	kv["_light"] <- "255 255 255 100";
	kv["brightness"] <- 5;
	kv["distance"] <- radius * 2.0;
	kv["pitch"] <- 90;
	light = Light_Maker.CreateEntity(kv);

	kv = {};
	kv["pos"] <- class_pos(origin);
	kv["radius"] <- radius * 5.0;
	kv["message"] <- "weapons/flashbang/flashbang_explode1.wav";
	sound = Ambient_Generic_Maker.CreateEntity(kv);
	EF(sound, "PlaySound");

	EF(shake, "Kill", "", 0.5);
	EF(particle, "Kill", "", 0.5);
	EF(light, "Kill", "", 0.5);
	EF(sound, "Kill", "", 0.5);
}

Start();