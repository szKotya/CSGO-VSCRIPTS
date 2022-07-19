const TICKRATE = 0.05;
const TICKRATE_HP = 1.00;
const TICKRATE_ABILITY_CD = 1.00;
const TICKRATE_ABILITY_WORK = 0.1;
const TICKRATE_KNIFE1 = 0.2;
const TICKRATE_ANIM = 0.1;

const PHYSBOX_HP = 9999999;

const BERSERK_DAMAGE_REDUCE = 0.75;
const BERSERK_KNIFE_DELAY = 0.1;

const TANK_DAMAGE_REDUCE = 0.5;
const TANK_SPEED_BOOST = 0.3;
const TANK_PUSH_POWER = 700;

const SMOKE_FLYTIME_MAX = 1.2;
const SMOKE_BUST_JUMP_FLOOR = 4.0;
const SMOKE_BUST_JUMP_FLOOR_Z = 380;
const SMOKE_MAX_WALL_DIR_Z = 0.8;
const SMOKE_MAX_JUMP_DISTANCE = 128;

g_bTicking_ZombieCheck <- false;

g_bTickRate_HP <- 0.0;
g_bTickRate_KNIFE1 <- 0.0;
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

	regen_time = 0.0;

	tank_ticks = 0.0;

	berserk_ticks = 0.0;

	smoke_prepare = false;
	smoke_jumping = false;
	smoke_jumping_time = 0.00;
	smoke_jump_dir = Vector(0, 0, 0);
	smoke_jump_power = 220;

	smoke_wall = false;

	grounded = false;
	crouched = false;
	attacking = false;

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

		if (_class_id != 2)
		{
			this.trigger_hand = CreateTrigger(this.eye.GetOrigin() + this.eye.GetForwardVector() * 20, Vector(48, 80, 48), null, {filtername = "filter_team_only_ct", parentname = this.eye.GetName()});
			this.trigger_hand.SetForwardVector(this.eye.GetForwardVector());

			AOP(this.trigger_hand, "OnStartTouch", "map_script_zombie_controller:RunScriptCode:TouchZombieAttackTrigger():0:-1", 0.01);
		}

		this.physbox = CreatePhysBoxMulti(_handle.GetOrigin() + Vector(0, 0, 38), {model = MODEL_ZOMBIE_HITBOX, CollisionGroup = 16, damagefilter = "filter_team_not_t", parentname = _handle.GetName(), spawnflags = 62464, health = PHYSBOX_HP, disableflashlight = 1, material = 10, disableshadowdepth = 1, disableshadows = 1});
		AOP(this.physbox, "OnHealthChanged", "map_script_zombie_controller:RunScriptCode:DamageZombieByPhysBox():0:-1", 0.01);

		this.model = Prop_dynamic_Glow_Maker.CreateEntity({model = ZOMBIE_CLASS_DATA[_class_id].modelname, DefaultAnim = ZOMBIE_CLASS_DATA[_class_id].GetAnim_Stand_Idle(), glowenabled = 0, solid = 0, parentname = _handle.GetName(), pos = class_pos(_handle.GetOrigin())})
		temp = this.knife.GetForwardVector();
		this.model.SetForwardVector(Vector(temp.x, temp.y, 0));
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
		// this.ability_cd = Time() + 5.0;
	}

	function KnifeCheck()
	{
		if (!this.bknife ||
		this.fknife_time > Time() ||
		this.attacking)
		{
			return;
		}

		this.attacking = true;
		this.anim = "";

		if (this.class_id == 0)
		{
			this.KnifeCheck_Berserk();
		}
		else if (this.class_id == 1)
		{
			this.KnifeCheck_Tank();
		}
		else if (this.class_id == 2)
		{
			this.KnifeCheck_Smoke();
		}
		else
		{
			return;
		}
	}

	function KnifeCheck_Berserk()
	{
		if (this.berserk_ticks > 0)
		{
			this.SetAnim("attack_sweep");
			EF(this.trigger_hand, "Enable", "", 0.4);
			EF(this.trigger_hand, "Disable", "", 0.45);

			EF(this.trigger_hand, "Enable", "", 0.8);
			EF(this.trigger_hand, "Disable", "", 0.85);

			SetSpeed(this.handle, -0.8, 1.05);
			this.SetAnimRate(1.75);
			EntFireByHandle(Zombie_Handle "RunScriptCode", "KnifeCheck_Berserk(true)", 1.05, this.model, this.model);
		}
		else
		{
			SetSpeed(this.handle, -1.0, 0.7);

			EF(this.trigger_hand, "Enable", "", 0.15);
			EF(this.trigger_hand, "Disable", "", 0.2);

			this.SetAnim("attack_burst");
			this.SetAnimRate(2.0);
			EntFireByHandle(Zombie_Handle "RunScriptCode", "KnifeCheck_Berserk(false)", 0.75, this.model, this.model);
		}
	}

	function Attack_Berserk(berserk)
	{
		this.attacking = false;
		local delay = ZOMBIE_CLASS_DATA[this.class_id].knife_delay1;
		if (berserk)
		{
			delay = BERSERK_KNIFE_DELAY;
		}
		this.fknife_time = Time() + delay;
	}

	function KnifeCheck_Tank()
	{
			SetSpeed(this.handle, -0.5, 0.5);

			EF(this.trigger_hand, "Enable", "", 0.2);
			EF(this.trigger_hand, "Disable", "", 0.2 + 0.05);

			this.SetAnim((RandomInt(0, 1) ? "attack_melee_l" : "attack_melee_r"));
			this.SetAnimRate(1.8);
			EntFireByHandle(Zombie_Handle "RunScriptCode", "KnifeCheck_Tank()", 0.5, this.model, this.model);
	}

	function Attack_Tank()
	{
		this.attacking = false;
		this.fknife_time = Time() + ZOMBIE_CLASS_DATA[this.class_id].knife_delay1;;
	}

	function KnifeCheck_Smoke()
	{
		if (!this.smoke_jumping &&
		!this.smoke_prepare)
		{
			if (this.smoke_wall)
			{
				this.SetAnim("attack_wallprojectile");
			}
			else
			{
				GetPlayerMovementClassByHandle(this.handle, true).SetMoveTypeFreeze();
				this.SetAnim("attack_projectile");
			}
			EntFireByHandle(Zombie_Handle "RunScriptCode", "Attack_Smoke()", 0.6, this.model, this.model);
		}
	}

	function Attack_Smoke()
	{
		if (!this.smoke_wall)
		{
			GetPlayerMovementClassByHandle(this.handle, true).SetMoveTypeWalk();
		}
		this.attacking = false;

		this.fknife_time = Time() + ZOMBIE_CLASS_DATA[this.class_id].knife_delay1;

		local vecOrigin = this.eye.GetOrigin();
		local vecOrigin_Last = Trace(this.eye.GetOrigin(), this.eye.GetForwardVector(), 4000, null);
		local vecDir = vecOrigin_Last - vecOrigin;
		vecDir.Norm();

		local vecAngles = GetPithXawFVect3D(vecOrigin, vecOrigin - vecDir * 64);
		vecAngles = Vector(vecAngles.x - 20, vecAngles.y, vecAngles.z);
		vecOrigin += vecDir * 64;

		local physbox = Physbox_multiplayer_Maker.CreateEntity({pos = class_pos(vecOrigin, vecDir), model = MODEL_ZOMBIE_CUM, material = 10, spawnflags = 16902, health = 1, rendermode = 0})
		local truster = Thruster_Maker.CreateEntity({spawnflags = 27, angles = vecAngles, force = 3500, attach1 = physbox.GetName()});
		local triggerhurt = CreateTrigger(vecOrigin, 16, null, {filtername = "filter_team_only_ct", StartDisabled = 0, parentname = physbox.GetName()});
		triggerhurt.SetForwardVector(vecDir);

		triggerhurt.SetOwner(this.handle);
		AOP(triggerhurt, "OnStartTouch", truster.GetName() + ":Kill::0.15:1", 0.01);
		AOP(triggerhurt, "OnStartTouch", physbox.GetName() + ":Kill::0.15:1", 0.01);
		AOP(triggerhurt, "OnStartTouch", "map_script_zombie_controller:RunScriptCode:TouchSmokeShit():0:-1", 0.01);

		AOP(physbox, "OnDamaged", truster.GetName() + ":Kill::0:1", 0.01);
		AOP(physbox, "OnDamaged", physbox.GetName() + ":Kill::0:1", 0.01);

		EF(physbox, "Kill", "", 1.5);
		EF(truster, "Kill", "", 0.5);
	}

	function AbillityCheckWork()
	{
		if (this.berserk_ticks > 0)
		{
			this.berserk_ticks -= TICKRATE_ABILITY_WORK;
			printl("Berserk---");
		}
		else if (this.smoke_jumping)
		{
			this.smoke_jumping_time += TICKRATE_ABILITY_WORK;
			if (this.smoke_jumping_time >= SMOKE_FLYTIME_MAX)
			{
				this.smoke_prepare = false;
				this.smoke_jumping = false;
				this.smoke_jumping_time = 0.0;

				local vecVelocity = this.handle.GetVelocity();
				vecVelocity = Vector(vecVelocity.x * 0.5, vecVelocity.y * 0.5, vecVelocity.z * 0.5);
				this.handle.SetVelocity(vecVelocity);
			}
		}
		else if (this.tank_ticks > 0)
		{
			this.tank_ticks -= TICKRATE_ABILITY_WORK;
			if (this.tank_ticks <= 0)
			{
				this.anim = "";
			}
			printl("Tank---");
		}
	}
	function AnimCheck()
	{
		if (this.smoke_wall ||
		this.smoke_jumping ||
		this.smoke_prepare ||
		this.attacking)
		{
			return;
		}

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
			if (this.tank_ticks > 0)
			{
				animstart = "attack_run_charge";
				animloop = animstart
			}

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
		printl(Time() + " : " + szAnim);
		EF(this.model, "SetAnimation", szAnim);
	}
	function SetAnimRate(fRate, fDelay = 0.0)
	{
		EF(this.model, "SetPlaybackRate", "" + fRate, fDelay);
	}
	function SetAnimDefault(szAnim)
	{
		EF(this.model, "SetDefaultAnimation", szAnim);
	}

	function AbilityCheck()
	{
		if (this.ability_cd > Time())
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

		this.ability_cd = Time() + ZOMBIE_CLASS_DATA[this.class_id].ability_cd;
	}

	function Use_Berserk()
	{
		this.berserk_ticks = ZOMBIE_CLASS_DATA[this.class_id].ability_duration;
		printl("Use_Berserk");
	}

	function Use_Tank()
	{
		this.tank_ticks = ZOMBIE_CLASS_DATA[this.class_id].ability_duration;
		SetSpeed(this.handle, TANK_SPEED_BOOST, ZOMBIE_CLASS_DATA[this.class_id].ability_duration);
		this.anim = "";

		local vecOrigin = this.handle.GetOrigin();
		local triggerhurt = CreateTrigger(this.handle.GetOrigin() + Vector(0, 0, 40) + this.handle.GetForwardVector() * 20, Vector(80, 80, 80), null, {filtername = "filter_team_only_ct", StartDisabled = 1, parentname = this.physbox.GetName()});
		AOP(triggerhurt, "OnStartTouch", "map_script_zombie_controller:RunScriptCode:TouchTankSkin():0:-1", 0.01);
		EF(triggerhurt, "Enable", "", 0.01);
		EF(triggerhurt, "Kill", "", ZOMBIE_CLASS_DATA[this.class_id].ability_duration);
		local dir = this.handle.GetForwardVector();
		dir = Vector(dir.x, dir.y, 0);
		triggerhurt.SetForwardVector(dir);
	}

	function Use_Smoke()
	{
		printl("Use_Smoke");
		if (this.smoke_wall)
		{
			this.smoke_wall = false;
			this.handle.SetVelocity(Vector(0, 0, 0))
			GetPlayerMovementClassByHandle(this.handle, true).SetMoveTypeWalk();

			this.model.SetOrigin(this.handle.GetOrigin());
			EntFireByHandle(this.model, "SetParent", "!activator", 0, this.handle, this.handle);
			EntFireByHandle(Zombie_Handle "RunScriptCode", "activator.SetForwardVector(Vector(caller.GetForwardVector().x, caller.GetForwardVector().y, 0))", 0.05, this.model, this.knife);
			EntFireByHandle(Zombie_Handle "RunScriptCode", "activator.SetAngles(0, 0, 0)", 0.05, this.model, this.model);

			this.SetAnimIdle();
			return;
		}

		local vecStart = this.eye.GetOrigin();
		local vecDir = this.eye.GetForwardVector();
		local vecTraceDir = vecDir * SMOKE_MAX_JUMP_DISTANCE;

		local fTraceDir = TraceLine(vecStart, vecStart + vecTraceDir, this.physbox);

		local vecEnd = vecStart + vecTraceDir * fTraceDir;
		// WAll
		printl("trace: " + fTraceDir);

		DebugDrawAxis(vecEnd, 16, 5);

		if (fTraceDir < 0.9)
		{
			local vecWallPlance = GetApproxPlaneNormal(vecStart, vecTraceDir, 0.01, this.physbox);
			if (!veq(vecWallPlance, Vector(0,0,0)) &&
			vecWallPlance.z > -SMOKE_MAX_WALL_DIR_Z &&
			vecWallPlance.z < SMOKE_MAX_WALL_DIR_Z)
			{
				printl("FIND PLACE: " + vecWallPlance);
				local vecPlayer = vecEnd + vecWallPlance * 28;
				local vecModel = vecEnd + vecWallPlance * 18;

				this.smoke_wall = true;
				this.smoke_prepare = false;
				this.smoke_jumping = false;
				this.smoke_jumping_time = 0.0;

				this.handle.SetOrigin(vecPlayer);
				GetPlayerMovementClassByHandle(this.handle, true).SetMoveTypeFreeze();
				// AOP(this.handle, "movetype", 0);
				// this.handle.SetForwardVector(vecWallPlance);


				EF(this.model, "ClearParent");

				EntFireByHandle(Zombie_Handle "RunScriptCode", "activator.SetOrigin(Vector(" + vecModel.x + "," + vecModel.y + "," + vecModel.z + "))", 0.05, this.model, this.model);
				EntFireByHandle(Zombie_Handle "RunScriptCode", "activator.SetForwardVector(Vector(" + vecWallPlance.x + "," + vecWallPlance.y + "," + vecWallPlance.z + "))", 0.05, this.model, this.model);


				this.SetAnim("cats_climbupstart");
				this.SetAnimDefault("idle_wall");
				return;
			}
		}

		if (this.handle.GetVelocity().z == 0 &&
		InSight(this.handle.EyePosition(), this.handle.EyePosition() + Vector(0, 0, 16), this.physbox))
		{
			this.smoke_jump_dir = vecEnd - vecStart;
			this.smoke_jump_dir.Norm();
			this.smoke_jump_power = GetDistance3D(vecStart, vecEnd);

			this.smoke_prepare = true;
			this.SetAnim("Leap_5m");
			GetPlayerMovementClassByHandle(this.handle, true).SetMoveTypeFreeze();
			EntFireByHandle(Zombie_Handle "RunScriptCode", "Smoke_Jump_Floor()", 0.58, this.model, this.model);
			printl("FLOOR");
			return;
		}

		printl("DEBIL");
	}

	function Smoke_Jump_Floor()
	{
		this.smoke_prepare = false;
		GetPlayerMovementClassByHandle(this.handle, true).SetMoveTypeWalk();
		local dir = Vector(this.smoke_jump_dir.x * this.smoke_jump_power * SMOKE_BUST_JUMP_FLOOR,
		this.smoke_jump_dir.y * this.smoke_jump_power * SMOKE_BUST_JUMP_FLOOR,
		this.smoke_jump_dir.z * this.smoke_jump_power + SMOKE_BUST_JUMP_FLOOR_Z);

		this.smoke_jumping = true;

		printl("" + dir);
		this.handle.SetOrigin(this.handle.GetOrigin() + Vector(0, 0, 8));
		this.handle.SetVelocity(dir);
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

			if (this.smoke_jumping)
			{
				this.smoke_prepare = false;
				this.smoke_jumping = false;
				this.smoke_jumping_time = 0.0;
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
		!this.smoke_jumping)
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
		if (this.regen_time > Time())
		{
			return;
		}
		this.hp += ZOMBIE_CLASS_DATA[this.class_id].regen_hp_hit;
		if (this.hp > ZOMBIE_CLASS_DATA[this.class_id].hp)
		{
			this.hp = ZOMBIE_CLASS_DATA[this.class_id].hp;
		}

		this.regen_time = Time() + 0.05;

		UpDateHP();
	}

	function DamageHuman_Knife(activator)
	{
		DamagePlayer(activator, ZOMBIE_CLASS_DATA[this.class_id].damage);
		DispatchParticleEffect("blood_impact_goop_heavy", activator.GetOrigin() + Vector(0, 0, 48), this.handle.GetForwardVector());

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
		else if (this.tank_ticks > 0)
		{
			idamage *= TANK_DAMAGE_REDUCE;
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
	local trigger = CreateTrigger(origin, 16, null, {parentname = knife.GetName(), filtername = "filter_team_only_t"});

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
function TouchSmokeShit()
{
	DamagePlayer(activator, ZOMBIE_CLASS_DATA[2].damage);
	DispatchParticleEffect("blood_impact_goop_heavy", activator.GetOrigin() + Vector(0, 0, 48), caller.GetForwardVector());

	if (activator.GetHealth() - ZOMBIE_CLASS_DATA[2].damage < 1)
	{
		DispatchParticleEffect("blood_pool", activator.GetOrigin() + Vector(0, 0, 32), Vector(0, 0, 0));
	}
}

function TouchTankSkin()
{
	local dir = activator.GetOrigin() - caller.GetOrigin();
	dir.Norm();

	local activator_class = GetHumanOwnerClassByOwner(activator);
	if (activator_class != null)
	{
		activator_class.pushed = true;
	}

	activator.SetVelocity(Vector(dir.x * TANK_PUSH_POWER,
	dir.y * TANK_PUSH_POWER,
	260));

	DamagePlayer(activator, 5);
	DispatchParticleEffect("blood_impact_goop_heavy", activator.GetOrigin() + Vector(0, 0, 48), caller.GetForwardVector());

	if (activator.GetHealth() - 5 < 1)
	{
		DispatchParticleEffect("blood_pool", activator.GetOrigin() + Vector(0, 0, 32), Vector(0, 0, 0));
	}
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

function Smoke_Jump_Floor()
{
	printl("Smoke_Jump_Floor : " + caller);
	local zombie_owner_class = GetZombieOwnerClassByModel(activator);
	if (zombie_owner_class == null)
	{
		return;
	}

	zombie_owner_class.Smoke_Jump_Floor();
}

function Attack_Smoke()
{
	printl("Smoke_Jump_Floor : " + caller);
	local zombie_owner_class = GetZombieOwnerClassByModel(activator);
	if (zombie_owner_class == null)
	{
		return;
	}

	zombie_owner_class.Attack_Smoke();
}

function KnifeCheck_Berserk(berserk)
{
	printl("KnifeCheck_Berserk : " + caller);
	local zombie_owner_class = GetZombieOwnerClassByModel(activator);
	if (zombie_owner_class == null)
	{
		return;
	}

	zombie_owner_class.Attack_Berserk(berserk);
}

function KnifeCheck_Tank()
{
	printl("KnifeCheck_Tank : " + caller);
	local zombie_owner_class = GetZombieOwnerClassByModel(activator);
	if (zombie_owner_class == null)
	{
		return;
	}

	zombie_owner_class.Attack_Tank();
}

function Smoke_Jump_Wall()
{
	printl("Smoke_Jump_Wall : " + caller);
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


::GetZombieOwnerClassByModel <- function(model)
{
	foreach (zombie_owner_class in ZOMBIE_OWNERS)
	{
		if (model == zombie_owner_class.model)
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

function t1()
{
	printl("t1 : " + activator);
	local zombie_owner_class = GetZombieOwnerClassByOwner(activator);
	if (zombie_owner_class == null)
	{
		return;
	}

	printl("asd");

	__DumpScope(0, getroottable());

	printl("Pre");
	local new_class = class_zombie_owner_bio();
	printl("Post");
	local new_sp = Vector(0, 0, 0);
	printl(new_sp+" : " + typeof(new_sp))
	new_class.Do();
	new_class.asd();
	if(new_class instanceof ::class_zombie_owner_test)
	{
		printl("class_zombie_owner_test");
	}
	else if(new_class instanceof ::class_zombie_owner_bio)
	{
		printl("class_zombie_owner_bio");
	}
	else
	{
		printl("NO");
	}
	printl("new_class: " + typeof(new_class));
	DeepPrintTable( getroottable().class_zombie_owner )
}

::DeepPrintTable <- function( debugTable, prefix = "" )
{
	if (prefix == "")
	{
		printl(prefix + debugTable)
		printl("{")
		prefix = "   "
	}
	foreach (idx, val in debugTable)
	{
		if (typeof(val) == "table")
		{
			printl( prefix + idx + " = \n" + prefix + "{")
			DeepPrint( val, prefix + "   " )
			printl(prefix + "}")
		}
		else if (typeof(val) == "string")
			printl(prefix + idx + "\t= \"" + val + "\"")
		else
			printl(prefix + idx + "\t= " + val)
	}
	if (prefix == "   ")
		printl("}")
}

::class_zombie_owner_test <- class
{
	class_id = 0;
	function _newslot(key,value)
	{
		printl(" _newslot(key,value) "+ key + " : " + value);
	}
	function _typeof()
	{
		return "Pidor";
	}
}

::class_zombie_owner_bio <-class extends class_zombie_owner_test
{
	function asd()
	{
		this.class_id = -2;

		printl("YOUR " + this.class_id);
	}
}

function class_zombie_owner_bio::Do()
{
	this.asd();
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
	obj.speed = 0.25;
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
	obj.anim_run_start.push("attack_run_charge1");
	obj.anim_run_loop.push("attack_run_charge1");

	obj.anim_crouch_idle.push("idle_crouch");
	obj.anim_crouch_run.push("run_crouch");

	obj.hp = 1200;
	obj.speed = -0.2;
	obj.damage = 35;
	obj.regen_hp_hit = 50;

	obj.knife_delay1 = 0.6;
	obj.ability_cd = 30.0;
	// obj.ability_cd = 2.0;
	obj.ability_duration = 10.0;
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

	obj.knife_delay1 = 1.45;
	obj.ability_cd = 0.5;
	ZOMBIE_CLASS_DATA.push(obj);
}
Init();
