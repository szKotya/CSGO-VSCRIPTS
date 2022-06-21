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

::CreateTrigger <- function(origin, scale, vscripts = null, addkv = null)
{
	local kv = {};
	kv["pos"] <- class_pos(origin);

	if (vscripts != null)
	{
		kv["vscripts"] <- vscripts;
	}

	if (addkv != null)
	{
		KVmerge(kv, addkv);
	}

	local iSize = GetSizeByWLH(scale);

	local trigger = Trigger_Maker.CreateEntity(kv);
	trigger.SetSize(iSize[0], iSize[1]);
	AOP(trigger, "solid", 3);
	return trigger;
}

::CreateKnife <- function(origin, fly = true, canpickup = false)
{
	local kv = {};
	kv["pos"] <- class_pos(origin);
	kv["spawnflags"] <- (fly ? 1 : 0);
	kv["CanBePickedUp"] <- (canpickup ? 1 : 0);
	local knife = Knife_Maker.CreateEntity(kv);
	return knife;
}

// ::CreateExplosion <- function(origin, radius, damage, particle)
// {
// 	local kv = {};

// 	local shake;
// 	local particle;
// 	local light;
// 	local sound;

// 	kv = {};

// 	kv["pos"] <- class_pos(origin);
// 	kv["radius"] <- radius * 2.0;
// 	kv["amplitude"] <- 14;
// 	kv["duration"] <- 1.0;
// 	kv["frequency"] <- 10;
// 	kv["spawnflags"] <- 28;

// 	shake = Shake_Maker.CreateEntity(kv);
// 	EF(shake, "StartShake");

// 	if (damage > 0)
// 	{
// 		local player;
// 		local distance;
// 		while ((player = Entities.FindByClassnameWithin(player, "player", origin, radius)) != null)
// 		{
// 			if (player.IsValid() &&
// 			player.GetHealth() > 0)
// 			{
// 				if (InSight(player.GetOrigin() + Vector(0, 0, 45), origin))
// 				{
// 					distance = GetDistance3D(player.EyePosition(), origin) / radius;
// 					DamagePlayer(player, (damage - ((distance > 0.25) ? distance : 0) * damage), DamageType_Explosion);
// 				}
// 			}
// 		}
// 	}

// 	kv = {};
// 	kv["pos"] <- class_pos(origin);
// 	kv["effect_name"] <- "exp1_1";
// 	particle = Particle_Maker.CreateEntity(kv);
// 	EF(particle, "Start");

// 	kv = {};
// 	kv["pos"] <- class_pos(origin);
// 	kv["_light"] <- "255 255 255 100";
// 	kv["brightness"] <- 5;
// 	kv["distance"] <- radius * 2.0;
// 	kv["pitch"] <- 90;
// 	light = Light_Maker.CreateEntity(kv);

// 	kv = {};
// 	kv["pos"] <- class_pos(origin);
// 	kv["radius"] <- radius * 5.0;
// 	kv["message"] <- "weapons/flashbang/flashbang_explode1.wav";
// 	sound = Ambient_Generic_Maker.CreateEntity(kv);
// 	EF(sound, "PlaySound");

// 	EF(shake, "Kill", "", 0.5);
// 	EF(particle, "Kill", "", 0.5);
// 	EF(light, "Kill", "", 0.5);
// 	EF(sound, "Kill", "", 0.5);
// }

Start();