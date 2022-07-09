const TICKRATE = 0.05;
const TICKRATE_HP = 1.00;
const TICKRATE_ABILITY_CD = 1.00;
const TICKRATE_ABILITY_WORK = 0.1;
const TICKRATE_KNIFE1 = 0.2;
const TICKRATE_ANIM = 0.1;

const PHYSBOX_HP = 9999999;

const BERSERK_DAMAGE_REDUCE = 0.75;
const BERSERK_KNIFE_DELAY = 0.35;

const TANK_FLYTIME_MAX = 0.3;

g_bTicking_ZombieCheck <- false;

g_bTickRate_HP <- 0.0;
g_bTickRate_KNIFE1 <- 0.0;
g_bTickRate_ABILITY_CD <- 0.0;
g_bTickRate_ABILITY_WORK <- 0.0;
g_bTickRate_ANIM <- 0.0;
::Zombie_Script <- self.GetScriptScope();
::Zombie_Handle <- self;

::ZOMBIE_OWNERS <- [];

::ZOMBIE_CLASS_DATA <- [];
::class_zombie_info <- class
{
	speed = 0.0;
	damage = 0.0;
	hp = 700;
	regen_hp_hit = 20;

	name = "default";

	modelname = "";

	anim_stand_idle = null;

	anim_run_start = null;
	anim_run_loop = null;
	anim_run_end = null;

	anim_crouch_run = null;
	anim_crouch_idle = null;

	knife_delay1 = 0.3;
	ability_cd = 10;
	ability_duration = 10;
	constructor()
	{
		this.anim_stand_idle = [];
		this.anim_run_start = [];
		this.anim_run_loop = [];
		this.anim_run_end = [];

		this.anim_crouch_run = [];
		this.anim_crouch_idle = [];
	}

	function GetAnim_Stand_Idle()
	{
		return this.GetRandomFromArray(this.anim_stand_idle);
	}
	function GetAnim_Run_Start()
	{
		return this.GetRandomFromArray(this.anim_run_start);
	}
	function GetAnim_Run_Loop()
	{
		return this.GetRandomFromArray(this.anim_run_loop);
	}
	function GetAnim_Run_End()
	{
		return this.GetRandomFromArray(this.anim_run_end);
	}

	function GetAnim_Crouch_Run()
	{
		return this.GetRandomFromArray(this.anim_crouch_run);
	}
	function GetAnim_Crouch_Idle()
	{
		return this.GetRandomFromArray(this.anim_crouch_idle);
	}

	function GetRandomFromArray(array)
	{
		if (array.len() == 0)
		{
			return null;
		}
		if (array.len() == 1)
		{
			return array[0];
		}
		return array[RandomInt(0, array.len() - 1)]
	}
}

::class_zombie_owner <- class
{
	handle = null;
	knife = null;
	model = null;

	hp = 100;
	last_hp = PHYSBOX_HP;
	last_dps_player = null;

	trigger_hand = null;
	controller = null;
	physbox = null;
	eye = null;
	measure = null;

	fknife_time = 0;
	bknife = false;

	class_id = 0;

	ability_cd = 0;
	berserk_ticks = 0.0;

	tank_jumping = false;
	tank_jumping_time = 0.00;

	grounded = false;
	crouched = false;

	anim = "";
	press_w = false;
	press_s = false;
	press_a = false;
	press_d = false;

	constructor(_handle, _knife, _class_id = 0)
	{
		printl("constructor" + _handle);
		this.handle = _handle;
		this.knife = _knife;

		this.class_id = _class_id;

		local temp = CreateEyeParent(_handle);

		this.measure = temp[0];
		this.eye = temp[1];

		this.controller = CreateController(_handle, Zombie_Handle, g_iItem_GameUIFlags);
		this.controller.press_attack = Zombie_Script.PressedAttack1;
		this.controller.unpress_attack = Zombie_Script.UnPressedAttack1;

		this.controller.press_attack2 = Zombie_Script.PressedAttack2;

		this.controller.press_w = Zombie_Script.PressedW;
		this.controller.press_s = Zombie_Script.PressedS;
		this.controller.press_a = Zombie_Script.PressedA;
		this.controller.press_d = Zombie_Script.PressedD;

		this.controller.unpress_w = Zombie_Script.UnPressedW;
		this.controller.unpress_s = Zombie_Script.UnPressedS;
		this.controller.unpress_a = Zombie_Script.UnPressedA;
		this.controller.unpress_d = Zombie_Script.UnPressedD;

		this.trigger_hand = CreateTrigger(this.eye.GetOrigin() + this.eye.GetForwardVector() * 20, Vector(48, 80, 48), null, {filtername = "filter_team_only_ct", parentname = this.eye.GetName()});
		this.trigger_hand.SetForwardVector(this.eye.GetForwardVector());

		AOP(this.trigger_hand, "OnStartTouch", "map_script_zombie_controller:RunScriptCode:TouchZombieAttackTrigger():0:-1", 0.01);

		this.physbox = CreatePhysBoxMulti(_handle.GetOrigin() + Vector(0, 0, 38), {model = "*1", CollisionGroup = 16, damagefilter = "filter_team_not_t", parentname = _handle.GetName(), spawnflags = 62464, health = PHYSBOX_HP, disableflashlight = 1, material = 10, disableshadowdepth = 1, disableshadows = 1});
		AOP(this.physbox, "OnHealthChanged", "map_script_zombie_controller:RunScriptCode:DamageZombieByPhysBox():0:-1", 0.01);

		this.model = Prop_dynamic_Glow_Maker.CreateEntity({model = ZOMBIE_CLASS_DATA[_class_id].modelname, DefaultAnim = ZOMBIE_CLASS_DATA[_class_id].GetAnim_Stand_Idle(), glowenabled = 0, solid = 0, parentname = _handle.GetName(), pos = class_pos(_handle.GetOrigin())})
		temp = this.knife.GetForwardVector();
		this.model.SetForwardVector(Vector(temp.x, temp.y, 0));
		this.model.SetAngles(0, -90, 0);
		AOP(this.handle, "rendermode", 10);

		EF(_handle, "SetDamageFilter", "filter_team_only_t");
		this.handle.SetMaxHealth(ZOMBIE_CLASS_DATA[_class_id].hp);

		this.hp = ZOMBIE_CLASS_DATA[_class_id].hp;
		this.last_hp = PHYSBOX_HP;
		this.UpDateHP();

		this.SetAnimIdle();

		if (ZOMBIE_CLASS_DATA[_class_id].speed != 0.00)
		{
			SetSpeed(_handle, ZOMBIE_CLASS_DATA[_class_id].speed);
		}
	}

	function KnifeCheck()
	{
		if (!this.bknife ||
		this.fknife_time > Time())
		{
			return;
		}

		EF(this.trigger_hand, "Enable");
		EF(this.trigger_hand, "Disable", "", 0.01);
	}

	function AbilityCheckCD()
	{
		if (this.ability_cd > 0)
		{
			this.ability_cd--;
		}
	}
	function AbillityCheckWork()
	{
		if (this.berserk_ticks > 0)
		{
			this.berserk_ticks -= TICKRATE_ABILITY_WORK;
			printl("Berserk---");
		}
		else if (this.tank_jumping)
		{
			this.tank_jumping_time += TICKRATE_ABILITY_WORK;
			if (this.tank_jumping_time >= TANK_FLYTIME_MAX)
			{
				this.tank_jumping = false;
				this.tank_jumping_time = 0.0;
				local vecVelocity = this.handle.GetVelocity();
				vecVelocity = Vector(vecVelocity.x * 0.5, vecVelocity.y * 0.5, vecVelocity.z * 0.5);
				this.handle.SetVelocity(vecVelocity);
			}
		}
	}
	function AnimCheck()
	{
		if (this.press_w ||
		this.press_s ||
		this.press_a ||
		this.press_d)
		{
			if (this.crouched)
			{
				this.SetAnimRunCrouch();
			}
			else
			{
				this.SetAnimRun();
			}
		}
		else
		{
			if (this.crouched)
			{
				this.SetAnimCrouchIdle();
			}
			else
			{
				this.SetAnimIdle();
			}
		}
	}
	function SetAnimIdle()
	{
		if (this.anim != "idle")
		{
			local animstart = null;
			if (this.anim == "run")
			{
				animstart = ZOMBIE_CLASS_DATA[this.class_id].GetAnim_Run_End()
			}
			if (animstart == null)
			{
				animstart = ZOMBIE_CLASS_DATA[this.class_id].GetAnim_Stand_Idle();
			}

			local animloop = ZOMBIE_CLASS_DATA[this.class_id].GetAnim_Stand_Idle();

			if (animstart != null)
			{
				this.SetAnim(animstart);
			}
			if (animloop != null)
			{
				this.SetAnimDefault(animloop);
			}
		}
		this.anim = "idle";
	}
	function SetAnimCrouchIdle()
	{
		if (this.anim != "idlecrouch")
		{
			local animstart = ZOMBIE_CLASS_DATA[this.class_id].GetAnim_Crouch_Idle();
			local animloop = ZOMBIE_CLASS_DATA[this.class_id].GetAnim_Crouch_Idle();

			if (animstart != null)
			{
				this.SetAnim(animstart);
			}
			if (animloop != null)
			{
				this.SetAnimDefault(animloop);
			}
		}
		this.anim = "idlecrouch";
	}
	function SetAnimRun()
	{
		if (this.anim != "run")
		{
			local animstart = ZOMBIE_CLASS_DATA[this.class_id].GetAnim_Run_Start();
			local animloop = ZOMBIE_CLASS_DATA[this.class_id].GetAnim_Run_Loop();

			if (animstart != null)
			{
				this.SetAnim(animstart);
			}
			if (animloop != null)
			{
				this.SetAnimDefault(animloop);
			}
		}
		this.anim = "run";
	}
	function SetAnimRunCrouch()
	{
		if (this.anim != "runcrouch")
		{
			local animstart = ZOMBIE_CLASS_DATA[this.class_id].GetAnim_Crouch_Run();
			local animloop = ZOMBIE_CLASS_DATA[this.class_id].GetAnim_Crouch_Run();

			if (animstart != null)
			{
				this.SetAnim(animstart);
			}
			if (animloop != null)
			{
				this.SetAnimDefault(animloop);
			}
		}
		this.anim = "runcrouch";
	}
	function SetAnim(szAnim)
	{
		EF(this.model, "SetAnimation", szAnim);
	}
	function SetAnimDefault(szAnim)
	{
		EF(this.model, "SetDefaultAnimation", szAnim);
	}

	function AbilityCheck()
	{
		if (this.ability_cd > 0)
		{
			return;
		}

		if (this.class_id == 0)
		{
			this.Use_Berserk();
		}
		else if (this.class_id == 1)
		{
			this.Use_Tank();
		}
		else if (this.class_id == 2)
		{
			this.Use_Smoke();
		}
		else
		{
			return;
		}

		this.ability_cd = ZOMBIE_CLASS_DATA[this.class_id].ability_cd;
	}

	function Use_Berserk()
	{
		this.berserk_ticks = ZOMBIE_CLASS_DATA[this.class_id].ability_duration;
		printl("Use_Berserk");
	}

	function Use_Tank()
	{
		printl("Use_Tank");
		if (this.handle.GetVelocity().z == 0 &&
		InSight(this.handle.EyePosition(), this.handle.EyePosition() + Vector(0, 0, 16), this.physbox))
		{
			local dir = this.eye.GetForwardVector();
			dir = Vector(dir.x* 880, dir.y * 880, 160);
			this.tank_jumping = true;

			this.handle.SetOrigin(this.handle.GetOrigin() + Vector(0, 0, 8));
			this.handle.SetVelocity(dir);
		}
	}

	function Use_Smoke()
	{
		printl("Use_Smoke");
	}

	function JumpCheck()
	{
		if (this.handle.IsNoclipping())
		{
			return;
		}
		if (InSight(this.handle.GetOrigin(), this.handle.GetOrigin() - Vector(0, 0, 8), this.physbox))
		{
			this.grounded = false;
		}
		else
		{
			this.grounded = true;

			if (this.tank_jumping)
			{
				this.tank_jumping = false;
				this.tank_jumping_time = 0.0;
			}
		}

		if (this.handle.GetBoundingMaxs().z > 54)
		{
			this.crouched = false;
		}
		else
		{
			this.crouched = true;
		}

		if (!this.grounded &&
		!this.tank_jumping)
		{
			local vecVelocity = this.handle.GetVelocity();
			if (vecVelocity.z > 0)
			{
				this.handle.SetVelocity(Vector(vecVelocity.x, vecVelocity.y, 0));
			}
		}
	}

	function RegenHP_Knife()
	{
		if (this.fknife_time > Time())
		{
			return;
		}
		this.hp += ZOMBIE_CLASS_DATA[this.class_id].regen_hp_hit;
		if (this.hp > ZOMBIE_CLASS_DATA[this.class_id].hp)
		{
			this.hp = ZOMBIE_CLASS_DATA[this.class_id].hp;
		}

		UpDateHP();
	}

	function DamageHuman_Knife(activator)
	{
		local delay = ZOMBIE_CLASS_DATA[this.class_id].knife_delay1;
		if (this.berserk_ticks > 0)
		{
			delay = BERSERK_KNIFE_DELAY;
		}
		this.fknife_time = Time() + delay;

		DispatchParticleEffect("blood_impact_goop_heavy", activator.GetOrigin() + Vector(0, 0, 48), this.handle.GetForwardVector());
		DamagePlayer(activator, ZOMBIE_CLASS_DATA[this.class_id].damage);

		if (activator.GetHealth() - ZOMBIE_CLASS_DATA[this.class_id].damage < 1)
		{
			DispatchParticleEffect("blood_pool", activator.GetOrigin() + Vector(0, 0, 32), Vector(0, 0, 0));
		}
	}

	function DamageZombie(dps = null)
	{
		local idamage = this.last_hp - this.physbox.GetHealth();
		this.last_hp = this.physbox.GetHealth();

		local activator_class = GetHumanOwnerClassByOwner(dps);
		if (activator_class != null)
		{
			idamage *= HUMAN_CLASS_DATA[activator_class.class_id].damage_multi;
		}

		if (this.berserk_ticks > 0)
		{
			idamage *= BERSERK_DAMAGE_REDUCE;
		}

		this.hp -= idamage;

		this.last_dps_player = dps;

		this.UpDateHP();
	}

	function UpDateHP()
	{
		if (this.hp < 1)
		{
			this.hp = -69;
			local vecDir = Vector(0, 0, 0);
			if (TargetValid(this.last_dps_player))
			{
				vecDir = this.last_dps_player.GetOrigin() - this.handle.GetOrigin();
				vecDir.Norm();
			}
			DispatchParticleEffect("blood_impact_headshot", this.handle.EyePosition(), vecDir);
		}

		if (this.hp != this.handle.GetHealth())
		{
			EF(this.handle, "SetHealth", "" + this.hp);
		}
	}

	function SelfDestroy()
	{
		printl("destroy");

		if (TargetValid(this.knife))
		{
			this.knife.Destroy();
		}
		if (TargetValid(this.trigger_hand))
		{
			this.trigger_hand.Destroy();
		}
		if (TargetValid(this.eye))
		{
			this.eye.Destroy();
		}
		if (TargetValid(this.measure))
		{
			this.measure.Destroy();
		}
		if (TargetValid(this.physbox))
		{
			this.physbox.Destroy();
		}
		if (TargetValid(this.model))
		{
			this.model.Destroy();
		}
		if (TargetValid(this.controller.game_ui))
		{
			EF(this.controller.game_ui, "Kill");
		}
		if (TargetValid(this.handle))
		{
			AOP(this.handle, "targetname", "");
			AOP(this.handle, "rendermode", 0);
		}
		RemovePlayerMovementClassByHandle(this.handle);
	}
}

function TickZombie()
{
	if (!g_bTicking_ZombieCheck)
	{
		return;
	}
	g_bTicking_ZombieCheck = false;

	// UPDATE HP BAR
	local bUpdateHP = false;
	g_bTickRate_HP += TICKRATE;
	if (g_bTickRate_HP >= TICKRATE_HP)
	{
		g_bTickRate_HP = 0.0;
		bUpdateHP = true;
	}

	local bCheckKnife = false;
	g_bTickRate_KNIFE1 += TICKRATE;
	if (g_bTickRate_KNIFE1 >= TICKRATE_KNIFE1)
	{
		g_bTickRate_KNIFE1 = 0.0;
		bCheckKnife = true;
	}

	local bCheckAbility = false;
	g_bTickRate_ABILITY_CD += TICKRATE;
	if (g_bTickRate_ABILITY_CD >= TICKRATE_ABILITY_CD)
	{
		g_bTickRate_ABILITY_CD = 0.0;
		bCheckAbility = true;
	}

	local bCheckAbilityWork = false;
	g_bTickRate_ABILITY_WORK += TICKRATE;
	if (g_bTickRate_ABILITY_WORK >= TICKRATE_ABILITY_WORK)
	{
		g_bTickRate_ABILITY_WORK = 0.0;
		bCheckAbilityWork = true;
	}

	local bCheckAnim = false;
	g_bTickRate_ANIM+= TICKRATE;
	if (g_bTickRate_ANIM >= TICKRATE_ANIM)
	{
		g_bTickRate_ANIM = 0.0;
		bCheckAnim = true;
	}

	foreach (index, zombie in ZOMBIE_OWNERS)
	{
		if (!TargetValid(zombie.handle) ||
		zombie.handle.GetTeam() != CS_TEAM_T ||
		zombie.handle.GetHealth() < 1)
		{
			zombie.SelfDestroy();
			ZOMBIE_OWNERS.remove(index);
			continue;
		}

		zombie.JumpCheck();

		if (bCheckKnife)
		{
			zombie.KnifeCheck();
		}

		if (bCheckAbility)
		{
			zombie.AbilityCheckCD();
		}

		if (bCheckAbilityWork)
		{
			zombie.AbillityCheckWork();
		}

		if (bUpdateHP)
		{
			zombie.UpDateHP();
		}

		if (bCheckAnim)
		{
			zombie.AnimCheck();
		}

		g_bTicking_ZombieCheck = true;
	}

	if (g_bTicking_ZombieCheck)
	{
		CallFunction("TickZombie()", TICKRATE);
	}
}

function PickZombieKnife(zombie_info_class_id)
{
	printl("PickZombieKnife" + activator);
	ZOMBIE_OWNERS.push(class_zombie_owner(activator, caller, zombie_info_class_id));
	if (!g_bTicking_ZombieCheck)
	{
		g_bTicking_ZombieCheck = true;
		TickZombie();
	}
}

::CreateZombie <- function(origin, zombie_info_class_id)
{
	// local origin = Vector(-480, 0, 16);
	local knife = CreateKnife(origin, true, false);
	local trigger = CreateTrigger(origin, Vector(16, 16, 16), null, {parentname = knife.GetName(), filtername = "filter_team_only_t"});

	// SetParentByActivator(trigger, knife);
	AOP(trigger, "OnStartTouch", "map_script_zombie_controller:RunScriptCode:TouchZombieTrigger(" + zombie_info_class_id + "):0:-1", 0.01);
	EF(trigger, "Enable", "", 0.01);
}

function TouchZombieTrigger(zombie_info_class_id)
{
	printl("TouchZombieTrigger" + activator);
	if (GetZombieOwnerClassByOwner(activator) != null)
	{
		return;
	}
	local knife = caller.GetMoveParent();
	local ownerknife = GetPlayerKnifeByOwner(activator);

	EF(caller, "Disable");
	EF(caller, "Kill");
	if (TargetValid(ownerknife))
	{
		ownerknife.Destroy();
	}

	AOP(knife, "OnPlayerPickup", "map_script_zombie_controller:RunScriptCode:PickZombieKnife(" + zombie_info_class_id + "):0:1", 0.01);
	EF(knife, "ToggleCanBePickedUp", "", 0.01);
	knife.SetOrigin(activator.GetOrigin());
}

function PressedAttack1()
{
	this.controller_caller.GetScriptScope().Hook_PressedAttack1();
}
function UnPressedAttack1()
{
	this.controller_caller.GetScriptScope().Hook_UnPressedAttack1();
}
function PressedAttack2()
{
	this.controller_caller.GetScriptScope().Hook_PressedAttack2();
}

function Hook_PressedAttack1()
{
	printl("Hook_PressedAttack1 : " + activator);
	local zombie_owner_class = GetZombieOwnerClassByOwner(activator);
	if (zombie_owner_class == null)
	{
		return;
	}

	zombie_owner_class.bknife = true;
	zombie_owner_class.KnifeCheck();
}

function Hook_UnPressedAttack1()
{
	printl("Hook_UnPressedAttack1 : " + activator);
	local zombie_owner_class = GetZombieOwnerClassByOwner(activator);
	if (zombie_owner_class == null)
	{
		return;
	}

	zombie_owner_class.bknife = false;
}

function Hook_PressedAttack2()
{
	printl("Hook_PressedAttack2 : " + activator);
	local zombie_owner_class = GetZombieOwnerClassByOwner(activator);
	if (zombie_owner_class == null)
	{
		return;
	}

	zombie_owner_class.AbilityCheck();
}

{
	function PressedW()
	{
		this.controller_caller.GetScriptScope().Hook_PressedW();
	}
	function Hook_PressedW()
	{
		printl("Hook_PressedW : " + activator);
		local zombie_owner_class = GetZombieOwnerClassByOwner(activator);
		if (zombie_owner_class == null)
		{
			return;
		}
		zombie_owner_class.press_w = true;
	}
	function PressedS()
	{
		this.controller_caller.GetScriptScope().Hook_PressedS();
	}
	function Hook_PressedS()
	{
		printl("Hook_PressedS : " + activator);
		local zombie_owner_class = GetZombieOwnerClassByOwner(activator);
		if (zombie_owner_class == null)
		{
			return;
		}
		zombie_owner_class.press_s = true;
	}
	function PressedA()
	{
		this.controller_caller.GetScriptScope().Hook_PressedA();
	}
	function Hook_PressedA()
	{
		printl("Hook_PressedA : " + activator);
		local zombie_owner_class = GetZombieOwnerClassByOwner(activator);
		if (zombie_owner_class == null)
		{
			return;
		}
		zombie_owner_class.press_a = true;
	}
	function PressedD()
	{
		this.controller_caller.GetScriptScope().Hook_PressedA();
	}
	function Hook_PressedD()
	{
		printl("Hook_PressedD : " + activator);
		local zombie_owner_class = GetZombieOwnerClassByOwner(activator);
		if (zombie_owner_class == null)
		{
			return;
		}
		zombie_owner_class.press_d = true;
	}

	function UnPressedW()
	{
		this.controller_caller.GetScriptScope().Hook_UnPressedW();
	}
	function Hook_UnPressedW()
	{
		printl("Hook_UnPressedW : " + activator);
		local zombie_owner_class = GetZombieOwnerClassByOwner(activator);
		if (zombie_owner_class == null)
		{
			return;
		}
		zombie_owner_class.press_w = false;
	}
	function UnPressedS()
	{
		this.controller_caller.GetScriptScope().Hook_UnPressedS();
	}
	function Hook_UnPressedS()
	{
		printl("Hook_UnPressedS : " + activator);
		local zombie_owner_class = GetZombieOwnerClassByOwner(activator);
		if (zombie_owner_class == null)
		{
			return;
		}
		zombie_owner_class.press_s = false;
	}
	function UnPressedA()
	{
		this.controller_caller.GetScriptScope().Hook_UnPressedA();
	}
	function Hook_UnPressedA()
	{
		printl("Hook_UnPressedA : " + activator);
		local zombie_owner_class = GetZombieOwnerClassByOwner(activator);
		if (zombie_owner_class == null)
		{
			return;
		}
		zombie_owner_class.press_a = false;
	}
	function UnPressedD()
	{
		this.controller_caller.GetScriptScope().Hook_UnPressedA();
	}
	function Hook_UnPressedD()
	{
		printl("Hook_UnPressedD : " + activator);
		local zombie_owner_class = GetZombieOwnerClassByOwner(activator);
		if (zombie_owner_class == null)
		{
			return;
		}
		zombie_owner_class.press_d = false;
	}
}

function TouchZombieAttackTrigger()
{
	local zombie_owner_class = GetZombieOwnerClassByHandTrigger(caller);
	if (zombie_owner_class == null)
	{
		return;
	}

	zombie_owner_class.RegenHP_Knife();
	zombie_owner_class.DamageHuman_Knife(activator);
}

function DamageZombieByPhysBox()
{
	printl("DamageZombieByPhysBox : " + caller);
	local zombie_owner_class = GetZombieOwnerClassByHitBox(caller);
	if (zombie_owner_class == null)
	{
		return;
	}

	zombie_owner_class.DamageZombie(activator);
}

::GetZombieOwnerClassByHitBox <- function(hitbox)
{
	foreach (zombie_owner_class in ZOMBIE_OWNERS)
	{
		if (hitbox == zombie_owner_class.physbox)
		{
			return zombie_owner_class;
		}
	}

	return null;
}

::GetZombieOwnerClassByHandTrigger <- function(trigger_hand)
{
	foreach (zombie_owner_class in ZOMBIE_OWNERS)
	{
		if (trigger_hand == zombie_owner_class.trigger_hand)
		{
			return zombie_owner_class;
		}
	}

	return null;
}

::GetZombieOwnerClassByOwner <- function(owner)
{
	foreach (zombie_owner_class in ZOMBIE_OWNERS)
	{
		if (owner == zombie_owner_class.handle)
		{
			return zombie_owner_class;
		}
	}

	return null;
}

function Init()
{
	local obj;

	obj = class_zombie_info();
	obj.name = "default";
	obj.modelname = "models/microrost/b4b/ubermensch/tallboy.mdl";
	obj.anim_stand_idle.push("idle_stand");
	obj.anim_run_start.push("move_loop");
	obj.anim_run_loop.push("move_loop");
	obj.anim_run_end.push("move_stop");

	obj.anim_crouch_run.push("run_crouch");

	obj.hp = 700;
	obj.speed = 0.3;
	obj.damage = 25;
	obj.regen_hp_hit = 20;

	obj.knife_delay1 = 0.5;
	obj.ability_cd = 10;
	obj.ability_duration = 10;
	ZOMBIE_CLASS_DATA.push(obj);


	obj = class_zombie_info();
	obj.name = "tank";
	obj.modelname = "models/microrost/b4b/ubermensch/bloater.mdl";
	obj.anim_stand_idle.push("idle_stand");
	obj.anim_run_start.push("run_stand");
	obj.anim_run_loop.push("run_stand");

	obj.anim_crouch_idle.push("idle_crouch");
	obj.anim_crouch_run.push("run_crouch");

	obj.hp = 1200;
	obj.speed = -0.2;
	obj.damage = 35;
	obj.regen_hp_hit = 50;

	obj.knife_delay1 = 0.9;
	obj.ability_cd = 1.0;
	ZOMBIE_CLASS_DATA.push(obj);


	obj = class_zombie_info();
	obj.name = "smoker";
	obj.modelname = "models/microrost/b4b/ubermensch/chaser.mdl";
	obj.anim_stand_idle.push("idle_stand");
	obj.anim_stand_idle.push("idle_stand1");
	obj.anim_run_start.push("run_fast");
	obj.anim_run_loop.push("run_fast");

	obj.anim_crouch_idle.push("idle_crouch");
	obj.anim_crouch_run.push("crouch_run");

	obj.hp = 500;
	obj.speed = 0.2;
	obj.damage = 20;
	obj.regen_hp_hit = 20;

	obj.knife_delay1 = 0.45;
	obj.ability_cd = 10;
	ZOMBIE_CLASS_DATA.push(obj);
}
Init();
