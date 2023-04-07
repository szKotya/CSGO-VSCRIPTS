::g_iPlayerID <- 0;

::Class_Handle <- self;
::Class_Scope <- self.GetScriptScope();

const CT_SKIN = "models/player/custom_player/microrost/spec/spec1.mdl";
self.PrecacheModel(CT_SKIN);

const INIT_TIME = 0.25;

enum Enum_PSM_FLAGS
{
	B_WEAPON = 1,
	B_HUD = 2,
	B_JUMP = 4,
	B_DUCK = 8,
	B_USE = 16,
}
::Enum_PSM_FLAGS <- getconsttable().Enum_PSM_FLAGS;

enum Enum_MOTYPE_FLAGS
{
	WALK = 2,
	FREEZE = 0,
	NOCLIP = 8,
}
::Enum_MOTYPE_FLAGS <- getconsttable().Enum_MOTYPE_FLAGS;
////////////////////////////////////////////////////////////////
//
// 					PLAYER BLOCK
//
////////////////////////////////////////////////////////////////
{
	::class_player <- class
	{
		handle = null;

		speed = 1.00;
		gravity = 1.00;

		movetype = Enum_MOTYPE_FLAGS.WALK;

		cant_switchweapon = false;
		hide_hud = false;
		cant_jump = true;
		cant_duck = false;
		cant_use = false;

		constructor(_handle)
		{
			this.handle = _handle;
		}

		function HideHud()
		{
			this.hide_hud = false;
			this.UpDateFlags();
		}

		function UnHideHud()
		{
			this.hide_hud = true;
			this.UpDateFlags();
		}

		function GetOrigin()
		{
			return this.handle.GetOrigin();
		}

		function GetCenter()
		{
			return this.handle.GetCenter();
		}

		function Freeze()
		{
			AOP(this.handle, "movetype", this.movetype = Enum_MOTYPE_FLAGS.FREEZE);
		}

		function UnFreeze()
		{
			AOP(this.handle, "movetype", this.movetype = Enum_MOTYPE_FLAGS.WALK);
		}

		function GetSpeedNow()
		{
			return this.handle.GetVelocity().Length();
		}

		function SetSpeed(speed, delay = 0.00)
		{
			this.speed += (0.00 + speed);

			if (delay > 0.00)
			{
				EntFireByHandle(Class_Handle "RunScriptCode", "SetSpeedByActivator(" + -speed + ")", delay, this.handle, this.handle);
			}
			this.UpDateSpeed();
		}

		function UpDateSpeed()
		{
			if (this.speed == 1.00)
			{
				EntFire("player_speedmod", "ModifySpeed", "0.99", 0, this.handle);
			}
			else
			{
				EntFire("player_speedmod", "ModifySpeed", "" + this.speed, 0, this.handle);
			}
		}

		function GetHandle()
		{
			return this.handle;
		}

		function UpDateFlags()
		{
			local iFlags = 0;

			if (this.cant_switchweapon)
			{
				iFlags += Enum_PSM_FLAGS.B_WEAPON;
			}
			if (this.hide_hud)
			{
				iFlags += Enum_PSM_FLAGS.B_HUD;
			}
			if (this.cant_jump)
			{
				iFlags += Enum_PSM_FLAGS.B_JUMP;
			}
			if (this.cant_duck)
			{
				iFlags += Enum_PSM_FLAGS.B_DUCK;
			}
			if (this.cant_use)
			{
				iFlags += Enum_PSM_FLAGS.B_USE;
			}

			EntFire("player_speedmod", "ModifySpeed", "1.0", 0, this.handle);
			EntFire("player_speedmod", "AddOutPut", "spawnflags " + iFlags, 0, this.handle);

			this.UpDateSpeed();
		}
	}
	::SetSpeed <- function(activator, speed, delay = 0.00)
	{
		if (!TargetValid(activator))
		{
			return;
		}
		local owner_class = null;
		if (activator.GetTeam() == 3)
		{
			owner_class = GetHumanOwnerClassByOwner(activator);
		}
		else if (activator.GetTeam() == 2)
		{
			owner_class = GetZombieOwnerClassByOwner(activator);
		}

		if (owner_class == null)
		{
			return;
		}

		owner_class.SetSpeed(speed, delay);
	}
	::SetSpeedByActivator <- function(speed, delay = 0.00)
	{
		SetSpeed(activator, speed, delay);
	}
}

////////////////////////////////////////////////////////////////
//
// 					ZOMBIE BLOCK
//
////////////////////////////////////////////////////////////////
::DISABLE_ABILITY <- true;


enum Enum_DAMAGE_TYPE
{
	NULL,
	ZOMBIE_BITE,
	ZOMBIE_PROJECTILE,
	ZOMBIE_PUSH,

	HUMAN_BULLET,
	HUMAN_TURRET,
	BTR_EXPLOSION,
}

::Enum_DAMAGE_TYPE <- getconsttable().Enum_DAMAGE_TYPE;

enum Enum_ZOMBIE_CLASS
{
	BERSERK = 0,
	VULTURE = 1,
	TANK = 2,
}

::Enum_ZOMBIE_CLASS <- getconsttable().Enum_ZOMBIE_CLASS;

const ATTACK_SLOW_TIME = 0.6;
const ATTACK_SLOW_VALUE = -0.5;

const AIM_BOT_DISTANCE = 200;

const BERSERK_DAMAGE_REDUCE = 0.90;
const BERSERK_KNIFE_DELAY = 0.1;

const TANK_DAMAGE_REDUCE = 0.6;
const TANK_PUSH_DAMAGE = 10;
const TANK_PUSH_POWER = 400;
const TANK_PUSH_POWER_Z = 260;
const TANK_SPEED_BOOST = 0.3;

const TANK_EXPLOSION_RADIUS = 256;
const TANK_EXPLOSION_DAMAGE = 75;
const TANK_EXPLOSION_PUSH_POWER = 500;
const TANK_EXPLOSION_PUSH_POWER_Z = 320;

const VULTURE_TURRET_DAMAGE = 10;
const VULTURE_WALL_COLLISION_Z = 50;
const VULTURE_WALL_COLLISION = 42;
const VULTURE_FLYTIME_MAX = 1.2;
const VULTURE_BUST_JUMP_FLOOR = 4.0;
const VULTURE_BUST_JUMP_FLOOR_Z = 380;
const VULTURE_MAX_WALL_DIR_Z = 0.8;
const VULTURE_MAX_JUMP_DISTANCE = 128;

const ZO_TICKRATE_ABILITY = 0.2;
g_t_ZO_TickRate_ABILITY <- 0;

const ZO_TICKRATE_REGEN = 0.2;
g_t_ZO_TickRate_REGEN <- 0;

const ZO_TICKRATE_KNIFE1 = 0.2;
g_t_ZO_TickRate_KNIFE1 <- 0;

const ZO_TICKRATE_AIMBOT = 0.05;
g_t_ZO_TickRate_AIMBOT <- 0;

const ZO_TICKRATE_HP = 1.00;
g_t_ZO_TickRate_HP <- 0;

const ZO_TICKRATE_RENDERMODE = 5.0;
g_t_ZO_TickRate_RENDERMODE <- 0;

const ZO_TICKRATE_HUD = 1.00;
g_t_ZO_TickRate_HUD <- 0;

const ZO_TICKRATE_ANIM = 0.1;
g_t_ZO_TickRate_ANIM <- 0;

::ZOMBIE_OWNERS <- [];

::class_zombie_owner <- class extends class_player
{
	handle = null;
	hitbox = null;
	eye = null;
	model = null;
	hud = null;

	name = null;
	id = null;

	hp = 100;
	last_hp = 100;

	last_damage_player = null;
	last_damage_time = 0;

	press_a1 = false;

	press_w = false;
	press_s = false;
	press_a = false;
	press_d = false;

	controller_status = false;

	szcontroller = "";

	szmeasure = "";
	szhurt = "";
	szhurtslow = "";

	anim = "";

	glowstatus = false;

	death = false;
	grounded = false;
	crouched = false;
	attacking = false;

	aimbot_target = null;
	// aimbot_proccent = 0.0;

	knife_time = 0;

	knife_regen_time = 0;

	regen_time = 0;

	ability_time = 0;

	bloodhit_time = 0;

	showhud = false;

	init = false;
	init_time = 0;

	constructor(_owner, _name, _id)
	{
		this.init_time = Time() + INIT_TIME;
		this.handle = _owner;

		this.name = _name;
		this.id = _id;

		this.szcontroller = "zo" + this.id + "_controller" + this.name;

		this.szmeasure = "zo" + this.id + "_measure" + this.name;

		if (this.id != Enum_ZOMBIE_CLASS.VULTURE)
		{
			this.szhurt = "zo" + this.id + "_hurt" + this.name;
			this.szhurtslow = "zo" + this.id + "_hurt_slow" + this.name;
		}

		EntFire(this.szcontroller, "Activate", "", 0, this.handle);

		this.SetOwner();

		EF(this.szmeasure, "Disable");
		EF(this.szmeasure, "SetMeasureTarget", "" + this.handle.GetName());
		EF(this.szmeasure, "Enable", "", 0.05);

		this.Tick_HP();
		this.PostConstructor();
	}

	function PostConstructor()
	{
		return;
	}

	function SetOwner()
	{
		GetFreeTargetName(this.handle);

		AOP(this.handle, "rendermode", 10);

		EF(this.handle, "SetDamageFilter", "filter_team_only_t");

		this.hp = ZOMBIE_CLASS_DATA[this.id].hp;
		this.handle.SetMaxHealth(ZOMBIE_CLASS_DATA[this.id].hp);

		this.speed = ZOMBIE_CLASS_DATA[this.id].speed;
		this.UpDateFlags();
	}

	function SetGlowDisabled()
	{
		if (!this.glowstatus)
		{
			return;
		}

		this.glowstatus = false;
		EF(this.model, "SetGlowDisabled");
	}

	function SetGlowEnabled()
	{
		if (this.glowstatus)
		{
			return;
		}

		this.glowstatus = true;
		EF(this.model, "SetGlowEnabled");
	}

	function ResetOwner()
	{
		AOP(this.handle, "rendermode", 0);
		EF(this.handle, "SetDamageFilter", "");
	}

	function GetID()
	{
		return this.id;
	}

	function SetControllerStatus(status)
	{
		this.controller_status = status;
	}

	function DeactivateController()
	{
		if (this.controller_status)
		{
			EF(this.szcontroller, "Deactivate");
		}
	}

	function GetName()
	{
		return this.name;
	}

	function SetHitBox(hitbox)
	{
		this.hitbox = hitbox;
		this.last_hp = hitbox.GetHealth();

		EntFireByHandle(this.hitbox, "SetParent", "!activator", 0, this.handle, this.handle);

		g_IGNORE_COLLISON.push(this.hitbox);
	}

	function SetEye(eye)
	{
		this.eye = eye;
		EntFireByHandle(this.eye, "SetParent", "!activator", 0.05, this.handle, this.handle);
	}

	function SetModel(model)
	{
		this.model = model;
		EntFireByHandle(this.model, "SetParent", "!activator", 0, this.handle, this.handle);
	}

	function ResetAimBot()
	{
		this.aimbot_target = null;
		// this.aimbot_proccent = 0.00;
	}

	function Tick_AimBot()
	{
		if (!this.press_a1)
		{
			return;
		}

		if (!TargetValid(this.aimbot_target) ||
		this.aimbot_target.GetHealth() < 1)
		{
			this.ResetAimBot();
			return;
		}

		// local v1 = this.eye.GetForwardVector();
		local v2 = aimbot_target.EyePosition() - this.handle.EyePosition();
		v2.Norm();

		// local newdir;
		// this.aimbot_proccent += 0.25;
		// if (this.aimbot_proccent >= 1.0)
		// {
		// 	newdir = v2;
		// }
		// else
		// {
		// 	newdir = Slerp(v1, v2, this.aimbot_proccent);
		// }

		this.handle.SetForwardVector(v2);
	}

	function Search_AimBotTarget()
	{
		this.ResetAimBot()

		local array = [];
		local vecStart = this.handle.EyePosition() + this.eye.GetForwardVector() * 16;
		local distance;
		foreach (index, value in PLAYERS)
		{
			if (!value.IsValid() ||
			value.GetTeam() != 3 ||
			value.GetHealth() < 1 ||
			(distance = GetDistance3D(vecStart, value.GetCenter())) > AIM_BOT_DISTANCE)
			{
				continue;
			}
			array.push([value, distance]);
		}

		if (array.len() < 1)
		{
			return;
		}
		else if (array.len() == 1)
		{
			this.aimbot_target = array[0][0];
		}
		else
		{
			local distance = 9999;
			foreach (value in array)
			{
				if (value[1] < distance)
				{
					distance = value[1];
					this.aimbot_target = value[0]
				}
			}
		}
	}

	function DamageZombie_Owner(activator = null, idamage = 1, damagetype = Enum_DAMAGE_TYPE.NULL)
	{
		idamage = this.CalculateResist(idamage, activator);

		this.hp -= idamage.tointeger();

		this.last_damage_player = activator;
		this.last_damage_time = Time();

		local vecDir = Vector();
		if (TargetValid(this.last_damage_player))
		{
			vecDir = this.last_damage_player.GetOrigin() - this.GetOrigin();
			vecDir.Norm();
		}

		if (Time() > this.bloodhit_time)
		{
			EF(this.model, "AddOutPut", "rendercolor 200 150 150");
			EF(this.model, "AddOutPut", "rendercolor 255 255 255", 0.15);

			this.bloodhit_time = Time() + 0.35;
			local vecStart = this.handle.GetCenter() + Vector(RandomInt(-8, 8), RandomInt(-8, 8), RandomInt(-32, 32));
			DispatchParticleEffect("blood_impact_medium", vecStart, vecDir);
		}

		if (this.hp < 1)
		{
			this.Death();
			EF(this.handle, "SetHealth", "0");
			EF("cs_ragdoll", "Kill");
			return;
		}

		this.Tick_HP();
	}

	function DamageZombie_HitBox(activator = null)
	{
		local idamage = this.last_hp - this.hitbox.GetHealth();
		this.last_hp = this.hitbox.GetHealth();

		idamage = this.CalculateResist(idamage, activator);

		this.hp -= idamage.tointeger();

		this.last_damage_player = activator;
		this.last_damage_time = Time();

		local vecDir = Vector();
		if (TargetValid(this.last_damage_player))
		{
			vecDir = this.last_damage_player.GetOrigin() - this.GetOrigin();
			vecDir.Norm();
		}

		if (Time() > this.bloodhit_time)
		{
			EF(this.model, "AddOutPut", "rendercolor 200 150 150");
			EF(this.model, "AddOutPut", "rendercolor 255 255 255", 0.15);

			this.bloodhit_time = Time() + 0.25;
			local vecStart = this.handle.GetCenter() + Vector(RandomInt(-8, 8), RandomInt(-8, 8), RandomInt(-32, 32));
			DispatchParticleEffect("blood_impact_medium", vecStart, vecDir);
		}

		if (this.hp < 1)
		{
			this.Death();
			EF(this.handle, "SetHealth", "0");
			EF("cs_ragdoll", "Kill");
			return;
		}

		this.Tick_HP();
	}

	function Death()
	{
		return;
	}

	function CalculateResist(idamage, activator)
	{
		if (activator != null)
		{
			local owner_class = GetHumanOwnerClassByOwner(activator);
			if (owner_class != null)
			{
				idamage *= HUMAN_CLASS_DATA[owner_class.id].damage_multi;
			}
		}
		return idamage;
	}

	function RegenHP_Knife()
	{
		if (this.knife_regen_time > Time())
		{
			return;
		}

		this.AddHP(ZOMBIE_CLASS_DATA[this.id].regen_hp_hit);

		this.knife_regen_time = Time() + 0.05;
	}

	function Tick_Init()
	{
		if (this.init)
		{
			return;
		}
		if (Time() < this.init_time)
		{
			return;
		}

		this.init = true;
		if (iChapter == -1)
		{
			this.handle.SetOrigin(Vector(2264, -536, 1784))
		}
		else
		{
			CreatePortalPickerClass(this.handle);
		}
		// TeleportToMap(this.handle);
	}

	function Tick_Hud()
	{
		if (!this.showhud)
		{
			return;
		}
		if (Time() < this.ability_time)
		{
			return;
		}
		this.showhud = false;

		if (CUT_SCENE)
		{
			return;
		}
		EntFire("map_entity_fade_ability", "Fade", "", 0, this.handle);
		EntFire("map_entity_text_ability", "Display", "", 0, this.handle);
	}

	function AddHP(i)
	{
		this.hp += i
		if (this.hp > ZOMBIE_CLASS_DATA[this.id].hp)
		{
			this.hp = ZOMBIE_CLASS_DATA[this.id].hp;
		}
		this.Tick_HP();
	}

	// function DamageHuman_Knife(activator)
	// {
	// 	DamagePlayer(activator, ZOMBIE_CLASS_DATA[this.id].damage);
	// 	DispatchParticleEffect("blood_impact_goop_heavy", activator.GetOrigin() + Vector(0, 0, 48), this.handle.GetForwardVector());

	// 	if (activator.GetHealth() - ZOMBIE_CLASS_DATA[this.id].damage < 1)
	// 	{
	// 		DispatchParticleEffect("blood_pool", activator.GetOrigin() + Vector(0, 0, 32), Vector());
	// 	}
	// }

	function Tick_Attack()
	{
		if (!this.press_a1 ||
		this.knife_time > Time() ||
		this.attacking)
		{
			return;
		}

		this.attacking = true;
		this.anim = "";

		this.Tick_Attack_Post();
	}

	function Tick_Attack_Post()
	{
		return;
	}

	function Tick_Attack_PostAnim()
	{
		this.ResetAimBot()

		this.attacking = false;
		this.knife_time = Time() + ZOMBIE_CLASS_DATA[this.id].knife_delay1;
	}

	function Tick_Regen()
	{
		if (Time() < this.last_damage_time + ZOMBIE_CLASS_DATA[this.id].regen_after_hits)
		{
			return;
		}
		if (Time() < this.regen_time)
		{
			return;
		}
		this.regen_time = Time() + ZOMBIE_CLASS_DATA[this.id].regen_delay_tick;

		this.AddHP(ZOMBIE_CLASS_DATA[this.id].regen_for_tick);
	}

	function Tick_HP()
	{
		if (this.hp != this.handle.GetHealth())
		{
			this.handle.SetHealth(this.hp);
		}
	}

	function Tick_RenderMode()
	{
		AOP(this.handle, "rendermode", 10);
	}

	function Tick_Jump()
	{
		if (this.handle.IsNoclipping())
		{
			return;
		}

		this.grounded = !(InSight(this.GetOrigin(), this.GetOrigin() - Vector(0, 0, 8), this.hitbox));
		this.crouched = this.handle.GetBoundingMaxs().z <= 54;

		// if (!this.grounded)
		// {
		// 	local vecVelocity = this.handle.GetVelocity();
		// 	if (vecVelocity.z > 0)
		// 	{
		// 		this.handle.SetVelocity(Vector(vecVelocity.x, vecVelocity.y, 0));
		// 	}
		// }
	}

	function Use_Ability_Pre()
	{
		if (DISABLE_ABILITY ||
		this.ability_time > Time())
		{
			return;
		}
		this.ability_time = Time() + ZOMBIE_CLASS_DATA[this.id].ability_cd;
		this.showhud = true;

		this.Use_Ability();
	}

	function Use_Ability()
	{
		return;
	}

	function Tick_Ability()
	{
		return;
	}

	function Tick_PreAnim()
	{
		if (this.attacking)
		{
			return;
		}
		this.Tick_Anim();
	}
	function Tick_Anim()
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
				animstart = ZOMBIE_CLASS_DATA[this.id].GetAnim_Run_End()
			}
			if (animstart == null)
			{
				animstart = ZOMBIE_CLASS_DATA[this.id].GetAnim_Stand_Idle();
			}

			local animloop = ZOMBIE_CLASS_DATA[this.id].GetAnim_Stand_Idle();

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
			local animstart = ZOMBIE_CLASS_DATA[this.id].GetAnim_Crouch_Idle();
			local animloop = ZOMBIE_CLASS_DATA[this.id].GetAnim_Crouch_Idle();

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
	function SetAnimRunCrouch()
	{
		if (this.anim != "runcrouch")
		{
			local animstart = ZOMBIE_CLASS_DATA[this.id].GetAnim_Crouch_Run();
			local animloop = ZOMBIE_CLASS_DATA[this.id].GetAnim_Crouch_Run();

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
	function SetAnimRun()
	{
		if (this.anim != "run")
		{
			local animstart = ZOMBIE_CLASS_DATA[this.id].GetAnim_Run_Start();
			local animloop = ZOMBIE_CLASS_DATA[this.id].GetAnim_Run_Loop();

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
	function SetAnim(szAnim)
	{
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

	function Destroy()
	{
		if (TargetValid(this.handle))
		{
			this.ResetOwner();
			this.DeactivateController();
		}

		RemoveFreeTargetName(this.handle);
		RemoveIgnoreCollision(this.hitbox);

		EF(this.eye, "Kill");
		EF(this.szmeasure, "Kill");

		// EF(this.szhurt, "Kill");
		// EF(this.szhurtslow, "Kill");

		EF(this.hitbox, "Kill");

		if (!this.death)
		{
			EF(this.model, "Kill");
		}
		else
		{
			EF(this.model, "Kill", "", 2);
		}

		EF(this.szcontroller, "Kill");
	}
}

::class_zombie_owner_berserk <- class extends class_zombie_owner
{
	berserk_time = 0;
	static id = 0;
	function CalculateResist(idamage, activator)
	{
		idamage = class_zombie_owner.CalculateResist(idamage, activator)
		if (this.berserk_time > Time())
		{
			idamage *= BERSERK_DAMAGE_REDUCE;
		}
		return idamage;
	}

	function Tick_Attack_Post()
	{
		class_zombie_owner.Search_AimBotTarget();

		EF(this.szhurtslow, "Enable", "", 0);
		EF(this.szhurtslow, "Disable", "", 0.05);

		if (this.berserk_time > Time())
		{
			this.SetAnim("attack_sweep");
			EF(this.szhurt, "Enable", "", 0.4);
			EF(this.szhurt, "Disable", "", 0.45);

			EF(this.szhurt, "Enable", "", 0.8);
			EF(this.szhurt, "Disable", "", 0.85);

			this.SetSpeed(-0.4, 1.05);
			this.SetAnimRate(1.75);
			EntFireByHandle(Class_Handle "RunScriptCode", "Hook_ZO_Tick_Attack_PostAnim_Berserk(true)", 1.05, this.handle, this.handle);
		}
		else
		{
			this.SetAnim("attack_burst");

			EF(this.szhurt, "Enable", "", 0.15);
			EF(this.szhurt, "Disable", "", 0.2);

			this.SetSpeed(-0.4, 0.7);
			this.SetAnimRate(2.0);
			EntFireByHandle(Class_Handle "RunScriptCode", "Hook_ZO_Tick_Attack_PostAnim_Berserk(false)", 0.75, this.handle, this.handle);
		}
	}
	function Tick_Attack_PostAnim(berserk)
	{
		this.ResetAimBot()

		this.attacking = false;
		local delay = ZOMBIE_CLASS_DATA[this.id].knife_delay1;
		if (berserk)
		{
			delay = BERSERK_KNIFE_DELAY;
		}
		this.knife_time = Time() + delay;
	}
	function Use_Ability()
	{
		this.berserk_time = Time() + ZOMBIE_CLASS_DATA[this.id].ability_duration;
	}

	function Death()
	{
		if (this.death)
		{
			return;
		}
		this.death = true;

		this.SetAnim("death");

		EF(this.model, "ClearParent");
		EF(this.model, "FadeAndKill", "", 1.5);

		local vecStart = this.handle.GetCenter();
		local vecRandom;

		for (local i = 0; i < 4; i++)
		{
			vecRandom = vecStart + Vector(RandomInt(-8, 8), RandomInt(-8, 8), RandomInt(-32, 32));
			DispatchParticleEffect("blood_impact_heavy", vecRandom, Vector());
		}
	}
}
::class_zombie_owner_tank <- class extends class_zombie_owner
{
	tank_time = 0;
	static id = 2;

	szpush = "";

	function CalculateResist(idamage, activator)
	{
		idamage = class_zombie_owner.CalculateResist(idamage, activator)
		if (this.tank_time > Time())
		{
			idamage *= TANK_DAMAGE_REDUCE;
		}
		return idamage;
	}

	function Tick_Attack()
	{
		if (this.tank_time > Time())
		{
			return;
		}

		class_zombie_owner.Tick_Attack();
	}

	function PostConstructor()
	{
		this.szpush = "zo" + this.id + "_push" + this.name;
		EntFire(this.szpush, "SetParent", "!activator", 0, this.handle);
	}

	function Tick_Attack_Post()
	{
		class_zombie_owner.Search_AimBotTarget();

		EF(this.szhurtslow, "Enable", "", 0);
		EF(this.szhurtslow, "Disable", "", 0.05);

		this.SetSpeed(-0.4, 0.5);

		EF(this.szhurt, "Enable", "", 0.2);
		EF(this.szhurt, "Disable", "", 0.2 + 0.05);

		this.SetAnim((RandomInt(0, 1) ? "attack_melee_l" : "attack_melee_r"));
		this.SetAnimRate(1.8);
		EntFireByHandle(Class_Handle "RunScriptCode", "Hook_ZO_Tick_Attack_PostAnim()", 0.5, this.handle, this.handle);
	}

	function Use_Ability()
	{
		this.anim = "";
		this.tank_time = Time() + ZOMBIE_CLASS_DATA[this.id].ability_duration;

		this.SetSpeed(TANK_SPEED_BOOST, ZOMBIE_CLASS_DATA[this.id].ability_duration);

		EF(this.szpush, "Enable");
		EF(this.szpush, "Disable", "", ZOMBIE_CLASS_DATA[this.id].ability_duration);

		EntFireByHandle(Class_Handle "RunScriptCode", "Hook_ZO_Use_Ability_Post()", ZOMBIE_CLASS_DATA[this.id].ability_duration, this.handle, this.handle);
	}

	function Use_Ability_Post()
	{
		this.anim = "";
	}

	function SetAnimRun()
	{
		if (this.anim != "run")
		{
			local animstart = ZOMBIE_CLASS_DATA[this.id].GetAnim_Run_Start();
			local animloop = ZOMBIE_CLASS_DATA[this.id].GetAnim_Run_Loop();
			if (this.tank_time > Time())
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

	function Destroy()
	{
		class_zombie_owner.Destroy();
		EF(this.szpush, "Kill");
	}

	function Death()
	{
		if (this.death)
		{
			return;
		}
		this.death = true;

		// this.SetAnimDefault("attack_vomit_loop");
		// this.SetAnim("attack_vomit_start");

		this.SetAnim("");

		EF(this.model, "ClearParent");
		EF(this.model, "FadeAndKill");

		local vecStart = this.handle.GetCenter();
		local vecRandom;

		DispatchParticleEffect("custom_particle_026", vecStart, Vector());

		local distance;
		local idamage;
		local dir;
		local coef;

		local handle;
		foreach (index, human_owner_class in HUMAN_OWNERS)
		{
			handle = human_owner_class.GetHandle();
			if (!handle.IsValid() ||
			handle.GetTeam() != 3 ||
			handle.GetHealth() < 1 ||
			!InSight(vecStart, handle.GetCenter(), g_IGNORE_COLLISON) ||
			(distance = GetDistance3D(vecStart, handle.GetCenter())) > TANK_EXPLOSION_RADIUS)
			{
				continue;
			}

			coef = 1.00 - distance / TANK_EXPLOSION_RADIUS;
			idamage = TANK_EXPLOSION_DAMAGE * coef;

			DamagePlayer(handle, idamage);

			if (idamage > 15)
			{
				dir = handle.GetCenter() - this.handle.GetOrigin();
				dir.Norm();

				dir = Vector(dir.x * coef * TANK_EXPLOSION_PUSH_POWER,
				dir.y * coef * TANK_EXPLOSION_PUSH_POWER,
				(coef + 0.35) * TANK_EXPLOSION_PUSH_POWER_Z);

				handle.SetVelocity(dir);
			}
		}

		for (local i = 0; i < 6; i++)
		{
			vecRandom = vecStart + Vector(RandomInt(-32, 32), RandomInt(-32, 32), RandomInt(-32, 32));
			DispatchParticleEffect("blood_impact_heavy", vecRandom, Vector());
		}
	}
}
::class_zombie_owner_vulture <- class extends class_zombie_owner
{
	static id = 1;

	walling = false;
	walling_time = 0.0;
	allow_walling = true;

	vecWallOrigin = Vector();
	vecWallDir = Vector();

	jump_dir = Vector();
	jump_power = 0.0;
	jump_time = 0.0;
	jump_prepare = false;
	jumping = false;

	function Tick_Attack()
	{
		if (this.jumping || this.jump_prepare)
		{
			return;
		}
		class_zombie_owner.Tick_Attack();
	}

	function Tick_AimBot()
	{
		return;
	}

	function Tick_Attack_Post()
	{
		if (this.walling)
		{
			this.SetAnim("attack_wallprojectile");
		}
		else
		{
			this.Freeze();
			this.SetAnim("attack_projectile");
		}
		EntFireByHandle(Class_Handle "RunScriptCode", "Hook_ZO_Tick_Attack_PostAnim()", 0.6, this.handle, this.handle);
	}
	function Tick_Attack_PostAnim()
	{
		if (!this.walling)
		{
			this.UnFreeze();
		}
		class_zombie_owner.Tick_Attack_PostAnim();
		AOP(Entity_Maker, "EntityTemplate", "zo1_projectile");

		local vecStart = this.eye.GetOrigin();
		local vecDir = this.eye.GetForwardVector();
		local vecEnd = vecStart + vecDir * TraceLine(vecStart, vecStart + vecDir * 10000, this.hitbox) * 10000;
		vecStart = this.model.GetAttachmentOrigin(this.model.LookupAttachment("Head"));
		vecDir = vecEnd - vecStart;
		vecDir.Norm();

		Entity_Maker.SetForwardVector(vecDir);
		Entity_Maker.SetOrigin(vecStart);

		Entity_Maker.SpawnEntity();
	}

	function Use_AfterWall()
	{
		local dir = this.handle.GetForwardVector();
		this.model.SetForwardVector(Vector(-dir.x, -dir.y, 0));
		this.model.SetAngles(0, 0, 0);
	}

	function Use_ToWall()
	{
		this.model.SetOrigin(vecWallOrigin);
		this.model.SetForwardVector(vecWallDir);
	}

	function Use_UnWall()
	{
		this.UnFreeze();

		this.allow_walling = false;
		this.walling = false;

		EntFireByHandle(this.model, "SetParent", "!activator", 0, this.handle, this.handle);

		this.model.SetOrigin(this.GetOrigin());

		this.anim = "";
		this.SetAnimIdle();

		EntFireByHandle(Class_Handle "RunScriptCode", "Hook_ZO_Use_AfterWall()", 0.05, this.handle, this.handle);
	}

	function Use_Ability_Pre()
	{
		if (DISABLE_ABILITY ||
		this.attacking ||
		this.jump_prepare ||
		Time() < this.walling_time)
		{
			return;
		}

		if (this.walling)
		{
			this.Use_UnWall();
			return;
		}

		local vecStart = this.eye.GetOrigin();
		local vecDir = this.eye.GetForwardVector();
		local vecTraceDir = vecDir * VULTURE_MAX_JUMP_DISTANCE;

		local fTraceDir = TraceLine(vecStart, vecStart + vecTraceDir, this.hitbox);

		local vecEnd = vecStart + vecTraceDir * fTraceDir;

		if (fTraceDir < 0.9)
		{
			if (!this.allow_walling)
			{
				return;
			}

			local vecWallPlance = GetApproxPlaneNormal(vecStart, vecTraceDir, 0.01, this.hitbox);
			if (!veq(vecWallPlance, Vector(0,0,0)) &&
			vecWallPlance.z > -VULTURE_MAX_WALL_DIR_Z &&
			vecWallPlance.z < VULTURE_MAX_WALL_DIR_Z)
			{
				this.walling_time = Time() + 0.2;

				local vecDirLeft = vecWallPlance.Cross(Vector(0, 0, 1));
				local vecDirUp =  vecWallPlance.Cross(vecDirLeft);

				local l1 = vecEnd + vecDirLeft * VULTURE_WALL_COLLISION + vecDirUp * VULTURE_WALL_COLLISION_Z + vecWallPlance * VULTURE_WALL_COLLISION*2;
				local l2 = vecEnd + vecDirLeft * -VULTURE_WALL_COLLISION + vecDirUp * VULTURE_WALL_COLLISION_Z + vecWallPlance * VULTURE_WALL_COLLISION*2;
				local l3 = vecEnd + vecDirLeft * -VULTURE_WALL_COLLISION + vecDirUp * -VULTURE_WALL_COLLISION_Z + vecWallPlance * VULTURE_WALL_COLLISION*2;
				local l4 = vecEnd + vecDirLeft * VULTURE_WALL_COLLISION + vecDirUp * -VULTURE_WALL_COLLISION_Z + vecWallPlance * VULTURE_WALL_COLLISION*2;


				local w1 = vecEnd + vecDirLeft * VULTURE_WALL_COLLISION + vecDirUp * VULTURE_WALL_COLLISION_Z;
				local w2 = vecEnd + vecDirLeft * -VULTURE_WALL_COLLISION + vecDirUp * VULTURE_WALL_COLLISION_Z;
				local w3 = vecEnd + vecDirLeft * -VULTURE_WALL_COLLISION + vecDirUp * -VULTURE_WALL_COLLISION_Z;
				local w4 = vecEnd + vecDirLeft * VULTURE_WALL_COLLISION + vecDirUp * -VULTURE_WALL_COLLISION_Z;

				local i1 = w1 - vecWallPlance * 5;
				local i2 = w2 - vecWallPlance * 5;
				local i3 = w3 - vecWallPlance * 5;
				local i4 = w4 - vecWallPlance * 5;

				// DebugDrawLine(w1, w2, 255, 0, 0, true, 5.0);
				// DebugDrawLine(w2, w3, 255, 0, 0, true, 5.0);
				// DebugDrawLine(w3, w4, 255, 0, 0, true, 5.0);
				// DebugDrawLine(w4, w1, 255, 0, 0, true, 5.0);

				// DebugDrawLine(l1, l2, 255, 0, 0, true, 5.0);
				// DebugDrawLine(l2, l3, 255, 0, 0, true, 5.0);
				// DebugDrawLine(l3, l4, 255, 0, 0, true, 5.0);
				// DebugDrawLine(l4, l1, 255, 0, 0, true, 5.0);

				// DebugDrawLine(l1, w1, 255, 0, 0, true, 5.0);
				// DebugDrawLine(l2, w2, 255, 0, 0, true, 5.0);
				// DebugDrawLine(l3, w3, 255, 0, 0, true, 5.0);
				// DebugDrawLine(l4, w4, 255, 0, 0, true, 5.0);

				// DebugDrawLine(i1, w1, 0, 255, 0, true, 5.0);
				// DebugDrawLine(i2, w2, 0, 255, 0, true, 5.0);
				// DebugDrawLine(i3, w3, 0, 255, 0, true, 5.0);
				// DebugDrawLine(i4, w4, 0, 255, 0, true, 5.0);

				if (!InSight(w1, w2, this.hitbox) ||
				!InSight(w2, w3, this.hitbox) ||
				!InSight(w3, w4, this.hitbox) ||
				!InSight(w4, w1, this.hitbox) ||

				!InSight(l1, l2, this.hitbox) ||
				!InSight(l2, l3, this.hitbox) ||
				!InSight(l3, l4, this.hitbox) ||
				!InSight(l4, l1, this.hitbox) ||

				!InSight(l1, w1, this.hitbox) ||
				!InSight(l2, w2, this.hitbox) ||
				!InSight(l3, w3, this.hitbox) ||
				!InSight(l4, w4, this.hitbox) ||

				InSight(w1, i1, this.hitbox) ||
				InSight(w2, i2, this.hitbox) ||
				InSight(w3, i3, this.hitbox) ||
				InSight(w4, i4, this.hitbox))
				{
					return;
				}
				local vecPlayer;
				local vecModel;
				// if (vecWallPlance.z > 0.8)
				// {
				// 	vecEnd += vecDirUp * 42;
				// 	vecPlayer = vecEnd + vecWallPlance * 30;
				// 	vecModel = vecEnd + vecWallPlance * 18;
				// }
				// else
				// {
					vecEnd -= Vector(0, 0, 42);
					vecPlayer = vecEnd + vecWallPlance * 30;
					vecModel = vecEnd + vecWallPlance * 18;
				// }


				this.vecWallDir = vecWallPlance;
				this.vecWallOrigin = vecModel;

				this.walling = true;

				this.handle.SetOrigin(vecPlayer);
				this.handle.SetVelocity(Vector());

				EF(this.model, "ClearParent");

				this.Freeze();

				EntFireByHandle(Class_Handle "RunScriptCode", "Hook_ZO_Use_ToWall()", 0.05, this.handle, this.handle);

				this.SetAnim("cats_climbupstart");
				this.SetAnimDefault("idle_wall");
				return;
			}
		}

		if (this.ability_time > Time())
		{
			return;
		}

		if (this.handle.GetVelocity().z == 0 &&
		InSight(this.handle.EyePosition(), this.handle.EyePosition() + Vector(0, 0, 16), this.hitbox))
		{
			this.Freeze();
			this.jump_prepare = true;

			this.ability_time = Time() + ZOMBIE_CLASS_DATA[this.id].ability_cd;
			this.showhud = true;

			this.jump_dir = vecEnd - vecStart;
			this.jump_dir.Norm();
			this.jump_power = GetDistance3D(vecStart, vecEnd);
			this.jump_time = Time() + VULTURE_FLYTIME_MAX;

			this.SetAnim("Leap_5m");
			EntFireByHandle(Class_Handle "RunScriptCode", "Hook_ZO_Use_Ability_Post()", 0.58, this.handle, this.handle);

			return;
		}
	}

	function Tick_Ability()
	{
		if (this.jumping)
		{
			if (Time() < this.jump_time)
			{
				return;
			}

			this.jumping = false;

			local vecVelocity = this.handle.GetVelocity();
			vecVelocity = Vector(vecVelocity.x * 0.5, vecVelocity.y * 0.5, vecVelocity.z * 0.5);
			this.handle.SetVelocity(vecVelocity);
		}
		else if (this.walling)
		{
			if (GetDistance3D(this.GetOrigin(), this.model.GetOrigin()) > 32)
			{
				this.Use_UnWall();
			}
		}
	}

	function Tick_PreAnim()
	{
		if (this.attacking ||
		this.jumping ||
		this.jump_prepare ||
		this.walling)
		{
			return;
		}
		this.Tick_Anim();
	}

	function Use_Ability()
	{
		return;
	}

	function Use_Ability_Post()
	{
		this.UnFreeze();
		this.jump_prepare = false;

		local dir = Vector(this.jump_dir.x * this.jump_power * VULTURE_BUST_JUMP_FLOOR,
		this.jump_dir.y * this.jump_power * VULTURE_BUST_JUMP_FLOOR,
		this.jump_dir.z * this.jump_power + VULTURE_BUST_JUMP_FLOOR_Z);

		this.jumping = true;

		this.handle.SetOrigin(this.GetOrigin() + Vector(0, 0, 8));
		this.handle.SetVelocity(dir);
	}

	function Tick_Jump()
	{
		if (this.handle.IsNoclipping())
		{
			return;
		}

		if (InSight(this.GetOrigin(), this.GetOrigin() - Vector(0, 0, 8), this.hitbox))
		{
			this.grounded = false;
		}
		else
		{
			this.grounded = true;

			this.allow_walling = true;

			if (this.jumping)
			{
				this.jumping = false;
			}
		}
		if (this.handle.GetBoundingMaxs().z <= 54)
		{
			this.crouched = true;

			if (this.walling)
			{
				this.Use_UnWall()
			}
		}
		else
		{
			this.crouched = false;
		}
	}

	function Destroy()
	{
		if (TargetValid(this.handle))
		{
			this.ResetOwner();
			this.DeactivateController();
		}

		RemoveFreeTargetName(this.handle);
		RemoveIgnoreCollision(this.hitbox);

		EF(this.eye, "Kill");
		EF(this.szmeasure, "Kill");

		EF(this.hitbox, "Kill");
		if (!this.death)
		{
			EF(this.model, "Kill");
		}
		else
		{
			EF(this.model, "Kill", "", 2);
		}

		EF(this.szcontroller, "Kill");
	}

	function Death()
	{
		if (this.death)
		{
			return;
		}
		this.death = true;

		this.SetAnim("death");
		EF(this.model, "ClearParent");
		EF(this.model, "FadeAndKill", "", 0.7);

		local vecStart = this.handle.GetCenter();
		local vecRandom;

		for (local i = 0; i < 4; i++)
		{
			vecRandom = vecStart + Vector(RandomInt(-8, 8), RandomInt(-8, 8), RandomInt(-32, 32));
			DispatchParticleEffect("blood_impact_heavy", vecRandom, Vector());
		}
	}
}
//ZO REG
{
	::RegZO <- function()
	{
		if (activator.GetTeam() != 2 ||
		GetZombieOwnerClassByOwner(activator) != null)
		{
			return;
		}
		local trigger = caller;
		local name = trigger.GetName().slice(trigger.GetPreTemplateName().len(),trigger.GetName().len());

		if (name == "")
		{
			// ScriptPrintMessageChatAll("RegZO ERROR");
			return;
		}
		local id = trigger.GetName().slice(2, 3).tointeger();

		activator.SetAngles(0, 0, 0);
		activator.SetOrigin(trigger.GetOrigin() + Vector(0, 0, trigger.GetBoundingMins().z));

		local hitbox = trigger.GetMoveParent();

		local eye = hitbox.GetMoveParent();

		local model = eye.GetMoveParent();

		trigger.Destroy();

		local zombie_owner_class;
		if (id == Enum_ZOMBIE_CLASS.BERSERK)
		{
			zombie_owner_class = class_zombie_owner_berserk(activator, name, id);
		}
		else if (id == Enum_ZOMBIE_CLASS.VULTURE)
		{
			zombie_owner_class = class_zombie_owner_vulture(activator, name, id);
		}
		else if (id == Enum_ZOMBIE_CLASS.TANK)
		{
			zombie_owner_class = class_zombie_owner_tank(activator, name, id);
		}
		else
		{
			zombie_owner_class = class_zombie_owner(activator, name, id);
		}
		zombie_owner_class.SetHitBox(hitbox);
		zombie_owner_class.SetEye(eye);
		zombie_owner_class.SetModel(model);

		ZOMBIE_OWNERS.push(zombie_owner_class);
	}

	::CreateZombie <- function(activator, id)
	{
		if (activator.GetTeam() != 2 ||
		GetZombieOwnerClassByOwner(activator) != null)
		{
			return;
		}

		local vecOrigin = activator.GetOrigin();

		AOP(Entity_Maker, "EntityTemplate", "zo" + id);

		Entity_Maker.SpawnEntityAtLocation(vecOrigin, Vector());
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

	::GetZombieOwnerClassByHandTrigger <- function(szname)
	{
		foreach (zombie_owner_class in ZOMBIE_OWNERS)
		{
			if (szname == zombie_owner_class.szhurt)
			{
				return zombie_owner_class;
			}
		}

		return null;
	}

	::GetZombieOwnerClassByHandTriggerSlow <- function(szname)
	{
		foreach (zombie_owner_class in ZOMBIE_OWNERS)
		{
			if (szname == zombie_owner_class.szhurtslow)
			{
				return zombie_owner_class;
			}
		}

		return null;
	}


	::GetZombieOwnerClassByPushTrigger <- function(szname)
	{
		foreach (zombie_owner_class in ZOMBIE_OWNERS)
		{
			if (zombie_owner_class.id == 2)
			{
				if (szname == zombie_owner_class.szpush)
				{
					return zombie_owner_class;
				}
			}
		}

		return null;
	}

	::GetZombieOwnerClassByHitBox <- function(hitbox)
	{
		foreach (zombie_owner_class in ZOMBIE_OWNERS)
		{
			if (hitbox == zombie_owner_class.hitbox)
			{
				return zombie_owner_class;
			}
		}

		return null;
	}
}
//ZO HOOKS
{
	::Hook_ZO_On <- function()
	{
		local zombie_owner_class = GetZombieOwnerClassByOwner(activator);
		if (zombie_owner_class == null)
		{
			return;
		}

		zombie_owner_class.SetControllerStatus(true);
	}
	::Hook_ZO_Off <- function()
	{
		local zombie_owner_class = GetZombieOwnerClassByOwner(activator);
		if (zombie_owner_class == null)
		{
			return;
		}

		zombie_owner_class.SetControllerStatus(false);
	}
	::Hook_ZO_Use_AfterWall <- function()
	{
		local zombie_owner_class = GetZombieOwnerClassByOwner(activator);
		if (zombie_owner_class == null)
		{
			return;
		}

		zombie_owner_class.Use_AfterWall();
	}
	::Hook_ZO_Use_ToWall <- function()
	{
		local zombie_owner_class = GetZombieOwnerClassByOwner(activator);
		if (zombie_owner_class == null)
		{
			return;
		}

		zombie_owner_class.Use_ToWall();
	}

	::Hook_ZO_Use_Ability_Post <- function()
	{
		local zombie_owner_class = GetZombieOwnerClassByOwner(activator);
		if (zombie_owner_class == null)
		{
			return;
		}

		zombie_owner_class.Use_Ability_Post();
	}
	::Hook_ZO_Tick_Attack_PostAnim <- function()
	{
		local zombie_owner_class = GetZombieOwnerClassByOwner(activator);
		if (zombie_owner_class == null)
		{
			return;
		}

		zombie_owner_class.Tick_Attack_PostAnim();
	}
	::Hook_ZO_TouchZombieTankPush <- function()
	{
		local szname = caller.GetName();
		if (szname == "")
		{
			return;
		}
		local zombie_owner_class = GetZombieOwnerClassByPushTrigger(szname);
		if (zombie_owner_class == null)
		{
			return;
		}
		if (!(zombie_owner_class.GetSpeedNow() > 0))
		{
			return;
		}

		local human_owner_class = GetHumanOwnerClassByOwner(activator);
		if (human_owner_class == null)
		{
			return;
		}

		local dir = caller.GetForwardVector();
		activator.SetVelocity(Vector(dir.x * TANK_PUSH_POWER, dir.y * TANK_PUSH_POWER, TANK_PUSH_POWER_Z));

		human_owner_class.DamageHuman(zombie_owner_class, TANK_PUSH_DAMAGE, Enum_DAMAGE_TYPE.ZOMBIE_PUSH);
	}

	::Hook_ZO_Tick_Attack_PostAnim_Berserk <- function(berserk)
	{
		local zombie_owner_class = GetZombieOwnerClassByOwner(activator);
		if (zombie_owner_class == null)
		{
			return;
		}

		zombie_owner_class.Tick_Attack_PostAnim(berserk);
	}

	::Hook_ZO_TouchZombieAttackTrigger_Shooter <- function()
	{
		local human_owner_class = GetHumanOwnerClassByOwner(activator);
		if (human_owner_class == null)
		{
			return;
		}
		human_owner_class.DamageHuman(null, ZOMBIE_CLASS_DATA[Enum_ZOMBIE_CLASS.VULTURE].damage, Enum_DAMAGE_TYPE.ZOMBIE_PROJECTILE);
	}
	::Hook_ZO_TouchZombieSlowTrigger <- function()
	{
		local szname = caller.GetName();
		if (szname == "")
		{
			return;
		}
		local zombie_owner_class = GetZombieOwnerClassByHandTriggerSlow(szname);
		if (zombie_owner_class == null)
		{
			return;
		}
		local human_owner_class = GetHumanOwnerClassByOwner(activator);
		if (human_owner_class == null)
		{
			return;
		}
		human_owner_class.SlowByZombie();
	}
	::Hook_ZO_TouchZombieAttackTrigger <- function()
	{
		local szname = caller.GetName();
		if (szname == "")
		{
			return;
		}
		local zombie_owner_class = GetZombieOwnerClassByHandTrigger(szname);
		if (zombie_owner_class == null)
		{
			return;
		}
		local human_owner_class = GetHumanOwnerClassByOwner(activator);
		if (human_owner_class == null)
		{
			return;
		}

		human_owner_class.DamageHuman(zombie_owner_class, ZOMBIE_CLASS_DATA[zombie_owner_class.id].damage, Enum_DAMAGE_TYPE.ZOMBIE_BITE);
		zombie_owner_class.RegenHP_Knife();
	}

	::Hook_ZO_Pressed_W <- function()
	{
		local zombie_owner_class = GetZombieOwnerClassByOwner(activator);
		if (zombie_owner_class == null)
		{
			return;
		}
		zombie_owner_class.press_w = true;
	}
	::Hook_ZO_UnPressed_W <- function()
	{
		local zombie_owner_class = GetZombieOwnerClassByOwner(activator);
		if (zombie_owner_class == null)
		{
			return;
		}
		zombie_owner_class.press_w = false;
	}

	::Hook_ZO_Pressed_S <- function()
	{
		local zombie_owner_class = GetZombieOwnerClassByOwner(activator);
		if (zombie_owner_class == null)
		{
			return;
		}
		zombie_owner_class.press_s = true;
	}
	::Hook_ZO_UnPressed_S <- function()
	{
		local zombie_owner_class = GetZombieOwnerClassByOwner(activator);
		if (zombie_owner_class == null)
		{
			return;
		}
		zombie_owner_class.press_s = false;
	}

	::Hook_ZO_Pressed_A <- function()
	{
		local zombie_owner_class = GetZombieOwnerClassByOwner(activator);
		if (zombie_owner_class == null)
		{
			return;
		}
		zombie_owner_class.press_a = true;
	}
	::Hook_ZO_UnPressed_A <- function()
	{
		local zombie_owner_class = GetZombieOwnerClassByOwner(activator);
		if (zombie_owner_class == null)
		{
			return;
		}
		zombie_owner_class.press_a = false;
	}

	::Hook_ZO_Pressed_D <- function()
	{
		local zombie_owner_class = GetZombieOwnerClassByOwner(activator);
		if (zombie_owner_class == null)
		{
			return;
		}
		zombie_owner_class.press_d = true;
	}
	::Hook_ZO_UnPressed_D <- function()
	{
		local zombie_owner_class = GetZombieOwnerClassByOwner(activator);
		if (zombie_owner_class == null)
		{
			return;
		}
		zombie_owner_class.press_d = false;
	}

	::Hook_ZO_Pressed_A1 <- function()
	{
		local zombie_owner_class = GetZombieOwnerClassByOwner(activator);
		if (zombie_owner_class == null)
		{
			return;
		}
		zombie_owner_class.press_a1 = true;
		zombie_owner_class.Tick_Attack();
	}
	::Hook_ZO_UnPressed_A1 <- function()
	{
		local zombie_owner_class = GetZombieOwnerClassByOwner(activator);
		if (zombie_owner_class == null)
		{
			return;
		}
		zombie_owner_class.press_a1 = false;
	}

	::Hook_ZO_Pressed_A2 <- function()
	{
		local zombie_owner_class = GetZombieOwnerClassByOwner(activator);
		if (zombie_owner_class == null)
		{
			return;
		}
		zombie_owner_class.Use_Ability_Pre();
	}

	::Hook_ZO_TakeDamage <- function()
	{
		local zombie_owner_class = GetZombieOwnerClassByHitBox(caller);
		if (zombie_owner_class == null)
		{
			return;
		}
		zombie_owner_class.DamageZombie_HitBox(activator);
	}
}
//ZO DATA
{
	::ZOMBIE_CLASS_DATA <- [];
	::class_zombie_data <- class
	{
		speed = 0.0;
		damage = 0.0;
		hp = 700;
		regen_hp_hit = 20;

		regen_after_hits = 10;
		regen_for_tick = 25;
		regen_delay_tick = 0.5;

		knife_delay1 = 0.3;
		ability_cd = 10;
		ability_duration = 10;

		cam_pos = Vector();

		name = "";

		anim_stand_idle = null;

		anim_run_start = null;
		anim_run_loop = null;
		anim_run_end = null;

		anim_crouch_run = null;
		anim_crouch_idle = null;

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
}
//ZO FUNCTIONS
{
	::Tick_Zombie <- function()
	{
		// UPDATE HUD
		local bUpdateHUD = false;

		if (!CUT_SCENE &&
		Time() > g_t_ZO_TickRate_HUD)
		{
			g_t_ZO_TickRate_HUD = Time() + ZO_TICKRATE_HUD;
			bUpdateHUD = true;
		}

		// UPDATE RENDERMODE
		local bUpdateRenderMode = false;

		if (Time() > g_t_ZO_TickRate_RENDERMODE)
		{
			g_t_ZO_TickRate_RENDERMODE = Time() + ZO_TICKRATE_RENDERMODE;
			bUpdateRenderMode = true;
		}

		// UPDATE HP BAR
		local bUpdateHP = false;

		if (Time() > g_t_ZO_TickRate_HP)
		{
			g_t_ZO_TickRate_HP = Time() + ZO_TICKRATE_HP;
			bUpdateHP = true;
		}

		// UPDATE AIMBOT
		local bUpdateAIM = false;

		if (!CUT_SCENE &&
			Time() > g_t_ZO_TickRate_AIMBOT)
		{
			g_t_ZO_TickRate_AIMBOT = Time() + ZO_TICKRATE_AIMBOT;
			bUpdateAIM = true;
		}

		// UPDATE KNIFE
		local bUpdateKnife = false;

		if (Time() > g_t_ZO_TickRate_KNIFE1)
		{
			g_t_ZO_TickRate_KNIFE1 = Time() + ZO_TICKRATE_KNIFE1;
			bUpdateKnife = true;
		}

		// UPDATE ANIM
		local bUpdateAnim = false;

		if (Time() > g_t_ZO_TickRate_ANIM)
		{
			g_t_ZO_TickRate_ANIM = Time() + ZO_TICKRATE_ANIM;
			bUpdateAnim = true;
		}

		// UPDATE REGEN
		local bUpdateRegen = false;

		if (Time() > g_t_ZO_TickRate_REGEN)
		{
			g_t_ZO_TickRate_REGEN = Time() + ZO_TICKRATE_REGEN;
			bUpdateRegen = true;
		}

		// UPDATE ABILITY
		local bUpdateAbility = false;

		if (Time() > g_t_ZO_TickRate_ABILITY)
		{
			g_t_ZO_TickRate_ABILITY = Time() + ZO_TICKRATE_ABILITY;
			bUpdateAbility = true;
		}

		local removearray = [];

		local handle;
		foreach (index, zombie_owner_class in ZOMBIE_OWNERS)
		{
			handle = zombie_owner_class.GetHandle();
			if (!TargetValid(handle) ||
			handle.GetTeam() != 2 ||
			handle.GetHealth() < 1)
			{
				// ScriptPrintMessageChatAll("zombie_owner_class Destroy");
				zombie_owner_class.Destroy();
				removearray.push(index);
				UpDataClass_Limits(zombie_owner_class.id, false);
				continue;
			}

			zombie_owner_class.Tick_Jump();
			zombie_owner_class.Tick_Init();

			if (bUpdateRegen)
			{
				zombie_owner_class.Tick_Regen();
			}

			if (bUpdateKnife)
			{
				zombie_owner_class.Tick_Attack();
			}

			if (bUpdateAIM)
			{
				zombie_owner_class.Tick_AimBot();
			}

			if (bUpdateAbility)
			{
				zombie_owner_class.Tick_Ability();
			}

			if (bUpdateAnim)
			{
				zombie_owner_class.Tick_PreAnim();
			}

			if (bUpdateHUD)
			{
				zombie_owner_class.Tick_Hud();
			}

			if (bUpdateHP)
			{
				zombie_owner_class.Tick_HP();
			}

			if (bUpdateRenderMode)
			{
				zombie_owner_class.Tick_RenderMode();
			}

		}
		removearray.reverse();
		foreach (value in removearray)
		{
			ZOMBIE_OWNERS.remove(value);
		}
	}
}

////////////////////////////////////////////////////////////////
//
// 					HUMAN BLOCK
//
////////////////////////////////////////////////////////////////
enum Enum_HUMAN_CLASS
{
	SOLDIER = 0,
	SCOUT = 1,
	ENGINEER = 2,
}

::Enum_HUMAN_CLASS <- getconsttable().Enum_HUMAN_CLASS;

::HO_HEART_COLOR <- [
	Vector(255, 0, 0),
	Vector(255, 64, 0),
	Vector(255, 192, 0),
	Vector(0, 255, 0),
];


const MIN_HP_FOR_BLOOD = 55;
const MIN_HP_FOR_FADE = 65;
// const MIN_HP_FOR_SOUNDE = 50;

const UNSTEALTH = 3.0;

const SPORE_DAMAGE_TICK = 5;

const HO_TICKRATE_SPORE = 1.0;
g_t_HO_TickRate_SPORE <- 0.00;

const HO_TICKRATE_BLOOD = 1.0;
g_t_HO_TickRate_BLOOD <- 0.00;

const HO_TICKRATE_SLOWZOMBIE = 0.2;
g_t_HO_TickRate_SLOWZOMBIE <- 0.00;

const HO_TICKRATE_HEARTCOLOR = 0.2;
g_t_HO_TickRate_HEARTCOLOR <- 0.00;

const HO_TICKRATE_MEDKIT = 0.2;
g_t_HO_TickRate_MEDKIT <- 0.00;

const HO_TICKRATE_UNSTEALTH = 0.5;
g_t_HO_TickRate_UNSTEALTH <- 0.00;

const HO_TICKRATE_FADE = 1.3;
g_t_HO_TickRate_FADE <- 0.00;

::HUMAN_OWNERS <- [];
::class_human_owner <- class extends class_player
{
	handle = null;
	glow = null;

	name = null;
	id = null;

	szcontroller = "";

	stealth = false;
	unstealth = false;
	unstealth_time = 0;
	stealth_area = "";

	grounded = false;
	crouched = false;

	controller_status = false;

	init = false;
	init_time = 0;

	ability_cast = false;

	redrender_time = 0;
	colorid = 3;

	heal_time = null;
	heal_ticks = null;

	slowbyzombie_time = 0;
	slowbyzombie = false;

	constructor(_owner, _name, _id)
	{
		this.init_time = Time() + INIT_TIME;
		this.handle = _owner;

		this.name = _name;
		this.id = _id;

		if (this.id != Enum_HUMAN_CLASS.SOLDIER)
		{
			this.szcontroller = "ho" + this.id + "_controller" + this.name;
			EntFire(this.szcontroller, "Activate", "", 0, this.handle);
		}

		this.heal_time = [];
		this.heal_ticks = [];

		this.SetOwner();
	}

	function Pick_MedKit()
	{
		local ticks = (HUMAN_CLASS_DATA[this.id].hp * 0.01 * MEDKIT_HEAL) / MEDKIT_HEAL_TICK;
		this.heal_ticks.push(ticks);
		this.heal_time.push(0);
	}

	function Tick_MedKit()
	{
		local bfade = false;

		foreach(index, value in this.heal_ticks)
		{
			if (this.heal_time[index] > Time())
			{
				continue;
			}

			this.heal_ticks[index]--;
			if (this.heal_ticks[index] < 0)
			{
				this.heal_ticks.remove(index);
				this.heal_time.remove(index);
				continue;
			}

			this.heal_time[index] = Time() + 1.00;

			if (this.handle.GetHealth() >= HUMAN_CLASS_DATA[this.id].hp)
			{
				continue;
			}
			bfade = true;
			this.AddHP(MEDKIT_HEAL_TICK);
		}

		if (bfade)
		{
			EntFire("map_entity_fade_heal", "Fade", "", 0, this.handle);
		}
	}

	function AddHP(i)
	{
		local hp = this.handle.GetHealth() + i;
		if (hp > HUMAN_CLASS_DATA[this.id].hp)
		{
			hp = HUMAN_CLASS_DATA[this.id].hp;
		}
		this.handle.SetHealth(hp);
	}

	function Use_Ability_Pre()
	{
		if (DISABLE_ABILITY ||
		this.ability_cast)
		{
			return;
		}
		this.ability_cast = true;

		this.Use_Ability();
	}

	function Reset_Ability()
	{
		this.ability_cast = false;
	}

	function Use_Ability()
	{
		return;
	}

	function SetControllerStatus(status)
	{
		this.controller_status = status;
	}

	function DeactivateController()
	{
		if (this.controller_status)
		{
			EF(this.szcontroller, "Deactivate");
		}
	}

	function SetStealthDisable()
	{
		this.stealth_area = -1;
		this.unstealth = true;
		this.stealth = false;

		AOP(this.glow, "glowdist", 4000);
	}

	function Tick_Stealth()
	{
		if (!this.unstealth)
		{
			return;
		}

		if (this.unstealth_time > Time())
		{
			return;
		}
		this.SetStealthDisable();
	}

	function GetStealthZone()
	{
		return this.stealth_area;
	}

	function UnStealth()
	{
		this.unstealth = true;
		this.unstealth_time = Time() + UNSTEALTH;
	}

	function SetGlowDisabled()
	{
		EF(this.glow, "SetGlowDisabled");
	}

	function SetGlowEnabled()
	{
		EF(this.glow, "SetGlowEnabled");
	}

	function SetStealthEnable(_area)
	{
		this.stealth = true;
		this.unstealth = false;
		this.stealth_area =_area;

		AOP(this.glow, "glowdist", 256);
	}

	function SetGlow(_glow)
	{
		this.glow = _glow;

		EntFireByHandle(this.glow, "SetParent", "!activator", 0, this.handle, this.handle);
		EF(this.glow, "SetParentAttachment", "primary_heart", 0.05);

		if (!g_bHumanGlow_Enable)
		{
			EF(this.glow, "SetGlowDisabled");
		}
	}

	function Tick_Init()
	{
		if (this.init)
		{
			return;
		}

		if (Time() < this.init_time)
		{
			return;
		}

		this.init = true;
		this.handle.SetOrigin(g_vecCTRoom);
	}

	function DamageHuman(zombie_owner_class, idamage, damagetype)
	{
		DamagePlayer(this.handle, idamage);

		local dir = Vector();
		if (zombie_owner_class != null)
		{
			dir = zombie_owner_class.GetOrigin() - this.GetOrigin();
			dir.Norm();
		}
		DispatchParticleEffect("blood_impact_goop_heavy", this.GetOrigin() + Vector(0, 0, 48), dir);

		if (Time() > this.redrender_time)
		{
			EF(this.handle, "AddOutPut", "rendercolor 255 100 100");
			EF(this.handle, "AddOutPut", "rendercolor 255 255 255", 0.15);

			this.redrender_time = Time() + 0.25;
		}

		if (this.handle.GetHealth() - idamage < 1)
		{
			DispatchParticleEffect("blood_pool", this.GetOrigin() + Vector(0, 0, 32), Vector());
		}
	}

	function SlowByZombie()
	{
		if (!this.slowbyzombie)
		{
			this.slowbyzombie = true;
			this.SetSpeed(ATTACK_SLOW_VALUE);
		}
		this.slowbyzombie_time = Time() + ATTACK_SLOW_TIME;
	}

	function Tick_SlowByZombie()
	{
		if (!this.slowbyzombie)
		{
			return;
		}

		if (this.slowbyzombie_time > Time())
		{
			return;
		}
		this.slowbyzombie = false;
		this.SetSpeed(-ATTACK_SLOW_VALUE);
	}

	function SetOwner()
	{
		this.handle.SetModel(CT_SKIN);
		EF(this.handle, "Skin", HUMAN_CLASS_DATA[this.id].skin);

		AOP(this.handle, "rendermode", 1);

		EF(this.handle, "SetDamageFilter", "filter_damage_ct");
		this.handle.SetMaxHealth(HUMAN_CLASS_DATA[this.id].hp);
		this.handle.SetHealth(HUMAN_CLASS_DATA[this.id].hp);

		this.speed = HUMAN_CLASS_DATA[this.id].speed;
		this.UpDateFlags();
	}

	function ResetOwner()
	{
		AOP(this.handle, "rendermode", 0);
		EF(this.handle, "SetDamageFilter", "");
	}

	function GetID()
	{
		return this.id;
	}

	function GetName()
	{
		return this.name;
	}

	function Tick_Jump()
	{
		if (this.handle.IsNoclipping())
		{
			return;
		}

		this.grounded = !(InSight(this.GetOrigin(), this.GetOrigin() - Vector(0, 0, 8), null));
		this.crouched = this.handle.GetBoundingMaxs().z <= 54;
	}

	function Tick_Spore()
	{
		DamagePlayer(this.handle, SPORE_DAMAGE_TICK);
	}

	function Tick_HurtColor()
	{
		local ID = HUMAN_CLASS_DATA[this.id].GetColorID(this.handle.GetHealth());
		if (ID == this.colorid)
		{
			return;
		}

		this.colorid = ID;
		AOP(this.glow, "glowcolor", HO_HEART_COLOR[this.colorid]);
	}

	function Tick_Blood()
	{
		if (this.handle.GetHealth() < ((this.handle.GetMaxHealth() * MIN_HP_FOR_BLOOD) / 100).tointeger())
		{
			DispatchParticleEffect("blood_pool", this.GetOrigin() + Vector(0, 0, 32), Vector());
		}
	}

	function Tick_Fade()
	{
		if (this.heal_ticks.len() > 0)
		{
			return;
		}

		local hp = this.handle.GetHealth();
		local maxhp = this.handle.GetMaxHealth();
		if (hp <= ((maxhp * MIN_HP_FOR_FADE) / 100).tointeger())
		{
			local color = "255 200 164";
			if (hp < 20)
			{
				color = "255 100 64";
			}
			else if (hp < 35)
			{
				color = "255 128 84";
			}
			else if (hp < 50)
			{
				color = "255 164 128";
			}

			EntFire("map_entity_fade_blood", "Color", color, 0, this.handle);
			EntFire("map_entity_fade_blood", "Fade", "", 0, this.handle);
		}

		// no music
		// if (hp <=  ((maxhp * MIN_HP_FOR_SOUNDE) / 100).tointeger())
		// {
		// 	EntFire("point_clientcommand", "Command", "play player/heartbeat_noloop.wav", 0.00, this.handle);
		// }
	}

	function Destroy()
	{
		if (TargetValid(this.handle))
		{
			this.ResetOwner();
			this.DeactivateController();
		}
		EF(this.glow, "Kill");

		EF(this.szcontroller, "Kill");
	}
}
::class_human_owner_soldier <- class extends class_human_owner
{
	static id = 0;

	function DeactivateController()
	{
		return;
	}

	function Destroy()
	{
		if (TargetValid(this.handle))
		{
			this.ResetOwner();
		}
		EF(this.glow, "Kill");
	}
}
::class_human_owner_scout <- class extends class_human_owner
{
	static id = 1;
	function SetStealthDisable()
	{
		this.stealth_area = -1;
		this.unstealth = true;
		this.stealth = false;

		AOP(this.glow, "glowdist", 2200);
	}

	function Use_Ability()
	{
		local vec = GetFloor(this.handle.GetOrigin()) + Vector(0, 0, 4);
		AOP(Entity_Maker, "EntityTemplate", "ability_ho1");
		Entity_Maker.SpawnEntityAtLocation(vec, Vector());
	}
}
::class_human_owner_engineer <- class extends class_human_owner
{
	static id = 2;


	function Use_Ability()
	{
		local vec = GetFloor(this.handle.GetOrigin()) + Vector(0, 0, 8);
		AOP(Entity_Maker, "EntityTemplate", "ability_ho2");
		Entity_Maker.SpawnEntityAtLocation(vec, Vector());
	}
}
//HO REG
{
	::RegHO <- function()
	{
		if (activator.GetTeam() != 3 ||
		GetHumanOwnerClassByOwner(activator) != null)
		{
			return;
		}

		local trigger = caller;
		local name = trigger.GetName().slice(trigger.GetPreTemplateName().len(),trigger.GetName().len());
		if (name == "")
		{
			// ScriptPrintMessageChatAll("RegHO ERROR");
			return;
		}
		local id = trigger.GetName().slice(2, 3).tointeger();

		activator.SetAngles(0, 0, 0);
		activator.SetOrigin(trigger.GetOrigin() + Vector(0, 0, trigger.GetBoundingMins().z))

		local glow = trigger.GetMoveParent();

		trigger.Destroy();

		local human_owner_class;
		if (id == Enum_HUMAN_CLASS.SOLDIER)
		{
			human_owner_class = class_human_owner_soldier(activator, name, id);
		}
		else if (id == Enum_HUMAN_CLASS.SCOUT)
		{
			human_owner_class = class_human_owner_scout(activator, name, id);
		}
		else if (id == Enum_HUMAN_CLASS.ENGINEER)
		{
			human_owner_class = class_human_owner_engineer(activator, name, id);
		}
		else
		{
			human_owner_class = class_human_owner(activator, name, id);
		}
		human_owner_class.SetGlow(glow);

		HUMAN_OWNERS.push(human_owner_class);
	}
	::CreateHuman <- function(activator, id)
	{
		if (activator.GetTeam() != 3 ||
		GetHumanOwnerClassByOwner(activator) != null)
		{
			return;
		}

		local vecOrigin = activator.GetOrigin();

		AOP(Entity_Maker, "EntityTemplate", "ho" + id);

		Entity_Maker.SpawnEntityAtLocation(vecOrigin, Vector());
	}

	::GetHumanOwnerClassByOwner <- function(owner)
	{
		foreach (human_owner_class in HUMAN_OWNERS)
		{
			if (owner == human_owner_class.handle)
			{
				return human_owner_class;
			}
		}

		return null;
	}
}
//HO HOOKS
{
	::Hook_HO_On <- function()
	{
		local human_owner_class = GetHumanOwnerClassByOwner(activator);
		if (human_owner_class == null)
		{
			return;
		}

		human_owner_class.SetControllerStatus(true);
	}
	::Hook_HO_Off <- function()
	{
		local human_owner_class = GetHumanOwnerClassByOwner(activator);
		if (human_owner_class == null)
		{
			return;
		}

		human_owner_class.SetControllerStatus(false);
	}
	::Hook_HO_Pressed_A2 <- function()
	{
		local human_owner_class = GetHumanOwnerClassByOwner(activator);
		if (human_owner_class == null)
		{
			return;
		}
		human_owner_class.Use_Ability_Pre();
	}

	::Hook_HO_TouchTurretAttackTrigger <- function()
	{
		local zombie_owner_class = GetZombieOwnerClassByOwner(activator);
		if (zombie_owner_class == null)
		{
			return;
		}

		zombie_owner_class.DamageZombie_Owner(null, TURRET_SHOOT_DAMAGE, Enum_DAMAGE_TYPE.HUMAN_TURRET);
	}

	::Hook_HO_TouchBTRAttackTrigger <- function()
	{
		local zombie_owner_class = GetZombieOwnerClassByOwner(activator);
		if (zombie_owner_class == null)
		{
			return;
		}

		zombie_owner_class.DamageZombie_Owner(null, 2000, Enum_DAMAGE_TYPE.BTR_EXPLOSION);
	}

	::Hook_HO_TakeDamageTurret <- function()
	{
		local turret_class = GetTurretClassByHitBox(caller);
		if (turret_class == null)
		{
			return;
		}
		turret_class.DamageTurret_HitBox();
	}
}
//HO DATA
{
	::HUMAN_CLASS_DATA <- [];
	::class_human_data <- class
	{
		speed = 0.00;
		damage_multi = 1.00;
		hp = 100;
		skin = 0;

		hp_color = null;

		cam_pos = Vector();

		name = "default";

		function CalculateColorBalance()
		{
			this.hp_color = [this.hp * 0.2, this.hp * 0.45, this.hp * 0.75];
		}

		function GetColorID(iHP)
		{
			foreach (i, iHPValue in this.hp_color)
			{
				if (iHP < iHPValue)
				{
					return i;
				}
			}
			return 3;
		}
	}
}
//HO FUNCTIONS
{
	::Tick_Human <- function()
	{
		// UPDATE SPORE
		local bUpdateSPORE = false;

		if (SPORE_END &&
		!CUT_SCENE &&
		Time() > g_t_HO_TickRate_SPORE)
		{
			g_t_HO_TickRate_SPORE = Time() + HO_TICKRATE_SPORE;
			bUpdateSPORE = true;
		}

		// UPDATE SLOWZOMBIE
		local bUpdateSLOWZOMBIE = false;

		if (Time() > g_t_HO_TickRate_SLOWZOMBIE)
		{
			g_t_HO_TickRate_SLOWZOMBIE = Time() + HO_TICKRATE_SLOWZOMBIE;
			bUpdateSLOWZOMBIE = true;
		}

		// UPDATE HEARTCOLOR
		local bUpdateHEARTCOLOR = false;

		if (Time() > g_t_HO_TickRate_HEARTCOLOR)
		{
			g_t_HO_TickRate_HEARTCOLOR = Time() + HO_TICKRATE_HEARTCOLOR;
			bUpdateHEARTCOLOR = true;
		}

		// UPDATE BLOOD
		local bUpdateBlood = false;

		if (Time() > g_t_HO_TickRate_BLOOD)
		{
			g_t_HO_TickRate_BLOOD = Time() + HO_TICKRATE_BLOOD;
			bUpdateBlood = true;
		}

		// UPDATE MEDKIT
		local bUpdateMedkit = false;

		if (Time() > g_t_HO_TickRate_MEDKIT)
		{
			g_t_HO_TickRate_MEDKIT = Time() + HO_TICKRATE_MEDKIT;
			bUpdateMedkit = true;
		}

		// UPDATE FADE
		local bUpdateFade = false;

		if (!CUT_SCENE &&
		!OVERLAY_TICKING &&
		!bFade &&
		Time() > g_t_HO_TickRate_FADE)
		{
			g_t_HO_TickRate_FADE = Time() + HO_TICKRATE_FADE;
			bUpdateFade = true;
		}

		// UPDATE UnStealth
		local bUpdateUnStealth = false;

		if (Time() > g_t_HO_TickRate_UNSTEALTH)
		{
			g_t_HO_TickRate_UNSTEALTH = Time() + HO_TICKRATE_UNSTEALTH;
			bUpdateUnStealth = true;
		}

		local removearray = [];

		local handle;
		foreach (index, human_owner_class in HUMAN_OWNERS)
		{
			handle = human_owner_class.GetHandle();
			if (!TargetValid(handle) ||
			handle.GetTeam() != 3 ||
			handle.GetHealth() < 1)
			{
				// ScriptPrintMessageChatAll("human_owner_class Destroy");
				human_owner_class.Destroy();
				removearray.push(index);
				UpDataClass_Limits(human_owner_class.id, true);
				continue;
			}

			human_owner_class.Tick_Jump();
			human_owner_class.Tick_Init();

			if (bUpdateMedkit)
			{
				human_owner_class.Tick_MedKit();
			}

			if (bUpdateSPORE)
			{
				human_owner_class.Tick_Spore();
			}

			if (bUpdateHEARTCOLOR)
			{
				human_owner_class.Tick_HurtColor();
			}

			if (bUpdateUnStealth)
			{
				human_owner_class.Tick_Stealth();
			}

			if (bUpdateBlood)
			{
				human_owner_class.Tick_Blood();
			}

			if (bUpdateFade)
			{
				human_owner_class.Tick_Fade();
			}

			if (bUpdateSLOWZOMBIE)
			{
				human_owner_class.Tick_SlowByZombie();
			}
		}

		removearray.reverse();
		foreach (value in removearray)
		{
			HUMAN_OWNERS.remove(value);
		}
	}
	::Human_Glow_Disabled <- function()
	{
		g_bHumanGlow_Enable = false;
		foreach (human_owner_class in HUMAN_OWNERS)
		{
			human_owner_class.SetGlowDisabled();
		}
	}
	::Human_Glow_Enabled <- function()
	{
		g_bHumanGlow_Enable = true;
		foreach (human_owner_class in HUMAN_OWNERS)
		{
			human_owner_class.SetGlowEnabled();
		}
	}

	::Human_Reset_Ability <- function()
	{
		foreach (human_owner_class in HUMAN_OWNERS)
		{
			human_owner_class.Reset_Ability();
		}
	}

	::Human_SetHalfHP <- function()
	{
		local handle;
		foreach (human_owner_class in HUMAN_OWNERS)
		{
			handle = human_owner_class.GetHandle();
			if (!TargetValid(handle) ||
			handle.GetTeam() != 3 ||
			handle.GetHealth() < 1)
			{
				continue;
			}
			handle.SetHealth(handle.GetMaxHealth() * 0.5);
		}
	}
}
////////////////////////////////////////////////////////////////
//
// 					PICK CLASS BLOCK
//
////////////////////////////////////////////////////////////////
{
	::LIMIT_CLASS_SCOUT <- 0;
	::LIMIT_CLASS_ENGINEER <- 0;

	::LIMIT_CLASS_VULTURE <- 0;
	::LIMIT_CLASS_TANK <- 0;
	::LIMIT_CLASS_TANK_DELAY <- 25.0;

	::COUNT_CLASS_SOLDIER <- 0;
	::COUNT_CLASS_SCOUT <- 0;
	::COUNT_CLASS_ENGINEER <- 0;

	::COUNT_CLASS_BERSERK <- 0;
	::COUNT_CLASS_VULTURE <- 0;
	::COUNT_CLASS_TANK <- 0;

	::g_bHumanGlow_Enable <- true;

	const PICKER_PICK_TIME = 7.5;
	// const PICKER_PICK_TIME = 2.05;
	const PICK_TICKRATE_INFO = 0.9;
	g_t_PICK_TickRate_INFO <- 0;

	const PICK_TICKRATE_STATS = 0.5;
	g_t_PICK_TickRate_STATS <- 0;

	::CLASS_PICKERS <- [];

	::class_picker <- class
	{
		handle = null;
		camera = null;

		szcontroller = "";
		controller_status = false;

		name = null;

		pick_time = 0;

		switch_time = 0;
		id = 0;

		side = false;

		destroy = false;

		constructor(_handle, _name)
		{
			this.handle = _handle;

			this.name = _name;

			this.pick_time = Time() + PICKER_PICK_TIME;
			this.side = (this.handle.GetTeam() == 3);

			this.szcontroller = "select_controller" + this.name;

			EntFire(this.szcontroller, "Activate", "", 0.25, this.handle);

			this.camera = GetFreeCamera(activator);

			this.UpDate_Cam();
			this.Tick_Display_Info();
			this.Tick_Display_Stats();
		}

		function GetHandle()
		{
			return this.handle;
		}

		function Tick_Display_Info()
		{
			if (CUT_SCENE)
			{
				return;
			}
			EntFire("map_entity_text_classpicker", "Display", "", 0, this.handle);
		}

		function Tick_Display_Stats()
		{
			if (CUT_SCENE)
			{
				return;
			}
			EntFire("map_entity_text_class_info_" + ((this.side) ? "h" : "z") + "_" + this.id, "Display", "", 0, this.handle);
		}

		function SetControllerStatus(status)
		{
			this.controller_status = status;
		}

		function IsValid()
		{
			return (this.destroy ||
			!TargetValid(this.handle) ||
			this.handle.GetHealth() < 1 ||
			(this.handle.GetTeam() != 3 && this.side) ||
			(this.handle.GetTeam() != 2 && !this.side))
		}

		function Tick_AutoPick()
		{
			if (Time() < this.pick_time)
			{
				return;
			}

			this.CreateClass(0);

			this.destroy = true;
			this.DeactivateController();
		}

		function UpDate_Cam()
		{
			local pos = ZOMBIE_CLASS_DATA[this.id].cam_pos;
			if (this.side)
			{
				pos = HUMAN_CLASS_DATA[this.id].cam_pos;
			}

			this.camera.SetCameraPos(pos);
		}

		function Press_A()
		{
			if (this.switch_time > Time())
			{
				return;
			}

			this.id--;
			if (this.id < 0)
			{
				this.id = ZOMBIE_CLASS_DATA.len() - 1;
				if (this.side)
				{
					this.id = HUMAN_CLASS_DATA.len() - 1;
				}
			}

			this.Move();
		}

		function Press_D()
		{
			if (this.switch_time > Time())
			{
				return;
			}

			this.id++;

			local len = ZOMBIE_CLASS_DATA.len() - 1;
			if (this.side)
			{
				len = HUMAN_CLASS_DATA.len() - 1;
			}

			if (this.id > len)
			{
				this.id = 0;
			}

			this.Move();
		}

		function Move()
		{
			this.switch_time = Time() + 0.25;

			this.UpDate_Cam();
			this.Tick_Display_Stats();
		}

		function Press_A1()
		{
			if (!AllowPickClass(this.id, this.side))
			{
				if (CUT_SCENE)
				{
					return;
				}
				EntFire("map_entity_fade_limit_class", "Fade", "", 0, this.handle);
				EntFire("map_entity_text_limit_class", "Display", "", 0, this.handle);
				return;
			}

			this.CreateClass(this.id);

			this.destroy = true;
			this.DeactivateController();
		}

		function DeactivateController()
		{
			if (this.controller_status)
			{
				EF(this.szcontroller, "Deactivate");
			}
		}

		function CreateClass(id)
		{
			if (this.side)
			{
				CreateHuman(this.handle, id);
				UpDataClass_Limits(id, true, false);
			}
			else
			{
				CreateZombie(this.handle, id);
				UpDataClass_Limits(id, false, false);
			}
		}

		function Destroy()
		{
			if (!this.destroy &&
			TargetValid(this.handle))
			{
				this.DeactivateController();
			}

			this.camera.Disable();
			EF(this.szcontroller, "Kill");
		}
	}

	::Tick_ClassPick <- function()
	{
		// UPDATE INFO
		local bUpdateInfo = false;

		if (Time() > g_t_PICK_TickRate_INFO)
		{
			g_t_PICK_TickRate_INFO = Time() + PICK_TICKRATE_INFO;
			bUpdateInfo = true;
		}

		// UPDATE STATS
		local bUpdateStats = false;

		if (Time() > g_t_PICK_TickRate_STATS)
		{
			g_t_PICK_TickRate_STATS = Time() + PICK_TICKRATE_STATS;
			bUpdateStats = true;
		}

		local removearray = [];
		foreach (index, picker in CLASS_PICKERS)
		{
			if (picker.IsValid())
			{
				// ScriptPrintMessageChatAll("picker Destroy");
				picker.Destroy();
				removearray.push(index);
				continue;
			}

			if (CUT_SCENE)
			{
				continue;
			}

			picker.Tick_AutoPick();

			if (bUpdateInfo)
			{
				picker.Tick_Display_Info();
			}

			if (bUpdateStats)
			{
				picker.Tick_Display_Stats();
			}
		}

		removearray.reverse();
		foreach (value in removearray)
		{
			CLASS_PICKERS.remove(value);
		}
	}

	::CreateClassPicker <- function(acitvator)
	{
		if (CUT_SCENE)
		{
			EntFire("viewcontrol" "AddPlayer", "", 0, activator);

			CUT_SCENE_PLAYERS.push(activator);
			local vecOrigin = GetOriginBAZA();
			activator.SetOrigin(vecOrigin);
			return;
		}
		PRESELECTS.push([activator, Enum_PickerType.ClassPicker]);
		CreateSelect(acitvator);
	}

	::UpDataClass_Limits <- function(id, team, remove = true)
	{
		local add = 1;
		if (remove)
		{
			add = -1;
		}

		if (team)
		{
			switch (id)
			{
				case Enum_HUMAN_CLASS.SOLDIER:
				COUNT_CLASS_SOLDIER += add;
				break;

				case Enum_HUMAN_CLASS.SCOUT:
				COUNT_CLASS_SCOUT += add;
				break;

				case Enum_HUMAN_CLASS.ENGINEER:
				COUNT_CLASS_ENGINEER += add;
				break;

				default:
				break;
			}
			return;
		}
		switch (id)
		{
			case Enum_ZOMBIE_CLASS.BERSERK:
			COUNT_CLASS_BERSERK += add;
			break;

			case Enum_ZOMBIE_CLASS.VULTURE:
			COUNT_CLASS_VULTURE += add;
			break;

			case Enum_ZOMBIE_CLASS.TANK:
			if (remove)
			{
				CallFunction("COUNT_CLASS_TANK--;", LIMIT_CLASS_TANK_DELAY);
				return;
			}
			COUNT_CLASS_TANK += add;
			break;

			default:
			break;
		}
	}

	::AllowPickClass <- function(id, team)
	{
		if (id == 0)
		{
			return true;
		}

		if (team)
		{
			if (id == Enum_HUMAN_CLASS.SCOUT)
			{
				if (COUNT_CLASS_SCOUT < LIMIT_CLASS_SCOUT)
				{
					return true;
				}
			}
			else if (id == Enum_HUMAN_CLASS.ENGINEER)
			{
				if (COUNT_CLASS_ENGINEER < LIMIT_CLASS_ENGINEER)
				{
					return true;
				}
			}
		}
		else
		{
			if (id == Enum_ZOMBIE_CLASS.VULTURE)
			{
				if (COUNT_CLASS_VULTURE < LIMIT_CLASS_VULTURE)
				{
					return true;
				}
			}
			else if (id == Enum_ZOMBIE_CLASS.TANK)
			{
				if (COUNT_CLASS_TANK < LIMIT_CLASS_TANK)
				{
					return true;
				}
			}
		}
		return false;
	}

	::GetPickerClassByOwner <- function(owner)
	{
		foreach (picker_class in CLASS_PICKERS)
		{
			if (owner == picker_class.handle)
			{
				return picker_class;
			}
		}

		return null;
	}
}
////////////////////////////////////////////////////////////////
//
// 					TURRET BLOCK
//
////////////////////////////////////////////////////////////////
{
	const TURRET_LIFETIME = 300.0;

	const TURRET_TARGET_RADIUS = 512;
	const TURRET_TARGET_DISTANCE_Z = 128;
	const TURRET_SHOOT_DELAY = 1.0;
	const TURRET_SHOOT_DAMAGE = 100;
	const TURRET_TICKRATE = 0.2;

	::g_t_TURRET_TickRate <- 0;

	::TURRETS <- [];

	::class_turret <- class
	{
		handle = null;
		hitbox = null;

		origin = Vector();
		destroy_time = 0;

		target = null;
		target_handle = null;

		hp = 50;
		last_hp = 50;

		destroy = false;
		death = false;

		shoot_time = 0;

		constructor(_handle)
		{
			this.handle = _handle;
			this.origin = this.handle.GetCenter() + Vector(0, 0, 8);
			this.destroy_time = Time() + TURRET_LIFETIME;

			this.hitbox = _handle.GetRootMoveParent();
			this.last_hp = this.hitbox.GetHealth();

			g_IGNORE_COLLISON.push(this.hitbox);
		}

		function SetDestroy(_destroy)
		{
			this.destroy = _destroy;
		}

		function DamageTurret_HitBox(activator = null)
		{
			local idamage = this.last_hp - this.hitbox.GetHealth();
			this.last_hp = this.hitbox.GetHealth();
			this.Damage(idamage);
		}

		function DamageTurret_Owner(activator = null, idamage = 1, damagetype = Enum_DAMAGE_TYPE.NULL)
		{
			this.Damage(idamage);
		}

		function Damage(idamage)
		{
			this.hp -= idamage;

			if (this.hp < 1)
			{
				this.Death();
				return;
			}
		}

		function Search_Target()
		{
			this.target_handle = null;
			this.target = null;

			local distance = TURRET_TARGET_RADIUS;
			local temp;
			local z;
			local _target = null;

			foreach (zombie_owner_class in ZOMBIE_OWNERS)
			{
				z = this.origin.z - zombie_owner_class.GetCenter().z;
				if (TURRET_TARGET_DISTANCE_Z < z ||
				-TURRET_TARGET_DISTANCE_Z > z)
				{
					continue;
				}

				temp = GetDistance3D(this.origin, zombie_owner_class.GetCenter());
				if (temp >= distance)
				{
					continue;
				}

				if (!InSight(this.origin, zombie_owner_class.GetCenter(), g_IGNORE_COLLISON))
				{
					continue;
				}

				distance = temp;
				_target = zombie_owner_class;
				zombie_owner_class.GetCenter();
			}

			if (_target == null)
			{
				return false;
			}

			this.target = _target;
			this.target_handle = _target.GetHandle();
			return true;
		}

		function Tick_Move()
		{
			local v1 = this.target_handle.GetCenter() - this.origin;
			v1.Norm();
			this.handle.SetForwardVector(Vector(v1.x, v1.y, 0));
		}

		function Tick_Shoot()
		{
			if (Time() <= this.shoot_time)
			{
				return;
			}
			this.shoot_time = Time() + TURRET_SHOOT_DELAY;


			AOP(Entity_Maker, "EntityTemplate", "ability_ho2_projectile");
			local vecStart = this.handle.GetAttachmentOrigin(this.handle.LookupAttachment("muzzle"));
			local vecDir = this.target_handle.GetCenter() - vecStart;
			vecDir.Norm();

			Entity_Maker.SetForwardVector(vecDir);
			Entity_Maker.SetOrigin(vecStart);

			Entity_Maker.SpawnEntity();

			DispatchParticleEffect("weapon_muzzle_flash_awp_tracer", vecStart, vecDir);
		}

		function ValidTarget()
		{
			return (!TargetValid(this.target_handle) ||
			this.target_handle.GetTeam() != 2 ||
			this.target_handle.GetHealth() < 1 ||
			TURRET_TARGET_DISTANCE_Z < this.origin.z - this.target_handle.GetCenter().z ||
			-TURRET_TARGET_DISTANCE_Z > this.origin.z - this.target_handle.GetCenter().z ||
			!InSight(this.origin, this.target_handle.GetCenter(), g_IGNORE_COLLISON))
		}

		function GetOrigin()
		{
			return this.origin;
		}

		function IsValid()
		{
			return (this.destroy ||
			Time() > this.destroy_time)
		}

		function Death()
		{
			if (this.death)
			{
				return;
			}

			this.death = true;
			this.destroy = true;

			local model2 = this.handle.GetMoveParent();
			EF(model2, "ClearParent");
			EF(this.handle, "ClearParent");
			EF(this.hitbox, "Kill", "", 0.05);


			EF(this.handle, "FadeAndKill", "", 1.6);
			EF(model2 "FadeAndKill", "", 1.6);

			DispatchParticleEffect("c4_train_ground_effect", this.origin, Vector());
		}

		function Destroy()
		{
			RemoveIgnoreCollision(this.hitbox);
			if (this.death)
			{
				return;
			}

			EF(this.hitbox, "Kill");
		}
	}

	::RegTurret <- function()
	{
		TURRETS.push(class_turret(caller));
	}

	::Tick_Turret <- function()
	{
		if (g_t_TURRET_TickRate > Time())
		{
			return;
		}

		g_t_TURRET_TickRate = Time() + TURRET_TICKRATE;

		if (TURRETS.len() < 1)
		{
			return;
		}

		local removearray = [];

		foreach (index, turret in TURRETS)
		{
			if (turret.IsValid())
			{
				turret.Destroy();
				removearray.push(index);
				continue;
			}
		}

		if (TURRETS.len() < 1)
		{
			return;
		}

		removearray.reverse();
		foreach (value in removearray)
		{
			TURRETS.remove(value);
		}

		foreach (turret in TURRETS)
		{
			if (turret.ValidTarget())
			{
				if (!turret.Search_Target())
				{
					continue;
				}
			}
			turret.Tick_Move();
			turret.Tick_Shoot();
		}
	}


	::GetTurretClassByHitBox <- function(hitbox)
	{
		foreach (turret in TURRETS)
		{
			if (hitbox == turret.hitbox)
			{
				return turret;
			}
		}

		return null;
	}
}
////////////////////////////////////////////////////////////////
//
// 					SKANNADE BLOCK
//
////////////////////////////////////////////////////////////////
{
	const SCANNADE_RADIUS = 1200;
	const SCANNADE_LIFETIME = 40.0;
	const SCANNADE_RADIUS_DESTROY = 32;

	const SCANNADE_TICKRATE = 0.2;

	::g_t_SCANNADE_TickRate <- 0;

	::SCANNADES <- [];

	::class_scannade <- class
	{
		handle = null;
		origin = Vector();
		destroy_time = 0;

		destroy = false;

		constructor(_handle)
		{
			this.handle = _handle;
			this.origin = this.handle.GetOrigin();
			this.destroy_time = Time() + SCANNADE_LIFETIME;
		}

		function SetDestroy(_destroy)
		{
			this.destroy = _destroy;
		}

		function GetOrigin()
		{
			return this.origin;
		}

		function IsValid()
		{
			return (this.destroy ||
			Time() > this.destroy_time)
		}

		function Destroy()
		{
			EF(handle, "Kill");
		}
	}

	::RegScanNade <- function()
	{
		SCANNADES.push(class_scannade(caller));
	}

	::Tick_ScanNade <- function()
	{
		if (g_t_SCANNADE_TickRate > Time())
		{
			return;
		}

		g_t_SCANNADE_TickRate = Time() + SCANNADE_TICKRATE;

		if (SCANNADES.len() < 1)
		{
			return;
		}

		local removearray = [];

		foreach (index, nade in SCANNADES)
		{
			if (nade.IsValid())
			{
				nade.Destroy();
				removearray.push(index);
				continue;
			}

			foreach (zombie_owner_class in ZOMBIE_OWNERS)
			{
				if (GetDistance3D(nade.GetOrigin(), zombie_owner_class.GetOrigin()) <= SCANNADE_RADIUS_DESTROY)
				{
					nade.Destroy();
					removearray.push(index);
					break;
				}
			}
		}

		if (SCANNADES.len() < 1)
		{
			return;
		}

		removearray.reverse();
		foreach (value in removearray)
		{
			SCANNADES.remove(value);
		}

		local vec;
		local glowstatus;
		foreach (zombie_owner_class in ZOMBIE_OWNERS)
		{
			vec = zombie_owner_class.GetOrigin();
			glowstatus = false;

			foreach (nade in SCANNADES)
			{
				if (GetDistance3D(nade.GetOrigin(), vec) <= SCANNADE_RADIUS)
				{
					glowstatus = true;
					break;
				}
			}

			if (glowstatus)
			{
				zombie_owner_class.SetGlowEnabled();
			}
			else
			{
				zombie_owner_class.SetGlowDisabled();
			}
		}
	}
}
////////////////////////////////////////////////////////////////
//
// 					MEDKIT BLOCK
//
////////////////////////////////////////////////////////////////
{
	const MEDKIT_COUNT = 80;
	const MEDKIT_USE_DELAY = 30.0;
	const MEDKIT_HEAL = 50;
	const MEDKIT_HEAL_TICK = 10;

	::MEDKITS <- [];

	::class_medkit <- class
	{
		handle = null;
		model = null;

		counts = MEDKIT_COUNT;

		destroy = false;

		users = null;
		users_time = null;

		constructor(_handle)
		{
			this.handle = _handle;
			this.model = this.handle.GetMoveParent();

			this.users = [];
			this.users_time = [];
		}

		function Use(activator)
		{
			if (this.counts < 1)
			{
				return false;
			}
			local index0 = -1;
			foreach (index, user in this.users)
			{
				if (activator != user)
				{
					continue;
				}
				if (this.users_time[index] > Time())
				{
					return false;
				}

				index0 = index;
				break;
			}

			if (index0 != -1)
			{
				this.users_time[index0] = Time() + MEDKIT_USE_DELAY;
			}
			else
			{
				this.users.push(activator);
				this.users_time.push(Time() + MEDKIT_USE_DELAY);
			}

			this.counts--;
			if (this.counts <= 0)
			{
				this.Destroy();
			}
			return true;
		}

		function GetOrigin()
		{
			return this.model.GetOrigin();
		}

		function Destroy(fade = true)
		{
			if (this.destroy)
			{
				return;
			}

			this.destroy = true;

			if (fade)
			{
				EF(this.model, "FadeAndKill");
			}
			else
			{
				EF(this.model, "Kill");
			}
		}
	}

	::Hook_HO_Touch_Stealth_Trigger <- function(ID)
	{
		local human_owner_class = GetHumanOwnerClassByOwner(activator);
		if (human_owner_class == null)
		{
			return;
		}
		human_owner_class.SetStealthEnable(ID);
	}

	::Hook_HO_UnTouch_Stealth_Trigger <- function()
	{
		local human_owner_class = GetHumanOwnerClassByOwner(activator);
		if (human_owner_class == null)
		{
			return;
		}
		human_owner_class.UnStealth();
	}

	::HO_Disable_Stealth_Zone <- function(ID)
	{
		foreach (human_owner_class in HUMAN_OWNERS)
		{
			if (human_owner_class.GetStealthZone() == ID)
			{
				human_owner_class.UnStealth();
			}
		}
	}

	::Hook_HO_Pick_MedKit <- function()
	{
		if (activator.GetTeam() != 3)
		{
			return;
		}

		local human_owner_class = GetHumanOwnerClassByOwner(activator);
		if (human_owner_class == null)
		{
			return;
		}

		if (human_owner_class.GetHandle().GetHealth() >=HUMAN_CLASS_DATA[human_owner_class.id].hp)
		{
			return;
		}

		local medkit_class = GetMedKitClassByButton(caller);
		if (medkit_class == null)
		{
			return;
		}
		if (!medkit_class.Use(human_owner_class.handle))
		{
			return;
		}
		human_owner_class.Pick_MedKit();
	}

	::RegMedKit <- function()
	{
		MEDKITS.push(class_medkit(caller));
	}

	::GetMedKitClassByButton <- function(button)
	{
		foreach (medkit_class in MEDKITS)
		{
			if (button == medkit_class.handle)
			{
				return medkit_class;
			}
		}
		return null;
	}

	::RemoveMedKitAtBoundBox <- function(vecOrigin, vecBoundBox)
	{
		local removearray = [];

		foreach (index, medkit_class in MEDKITS)
		{
			if (IsVectorInBoundingBox(medkit_class.GetOrigin(), vecOrigin, vecBoundBox))
			{
				medkit_class.Destroy(false);
				removearray.push(index);
				continue;
			}
		}

		removearray.reverse();
		foreach (value in removearray)
		{
			MEDKITS.remove(value);
		}
	}
}
////////////////////////////////////////////////////////////////
//
// 					PROJECTILES BLOCK
//
////////////////////////////////////////////////////////////////
{
	::g_IGNORE_COLLISON <- [];

	::PROJECTILES <- [];
	::class_projectile <- class
	{
		handle = null;
		distance = 0;
		id = 0;

		constructor(_handle, _distance, _id)
		{
			this.handle = _handle;
			this.distance = _distance;
			this.id = _id;
		}

		function GetHandle()
		{
			return this.handle;
		}

		function GetCenter()
		{
			return this.handle.GetCenter();
		}

		function GetNextCenter()
		{
			return this.handle.GetOrigin() + this.handle.GetForwardVector() * 128;
		}

		function GetDistance()
		{
			return this.distance * 2;
		}

		function GetID()
		{
			return this.id;
		}

		function Destroy()
		{
			EF(this.handle, "FireUser4");
		}
	}

	::RegProjectile <- function()
	{
		local name = caller.GetPreTemplateName();
		local obj;
		if (name == "zo1_projectile_move")
		{
			obj = class_projectile(caller, 32, 0);
		}
		else if (name == "ability_ho2_projectile_move")
		{
			obj = class_projectile(caller, 32, 1);
		}
		else if (name == "btr_projectile_move")
		{
			obj = class_projectile(caller, 32, 2);
		}
		PROJECTILES.push(obj);
	}

	::Tick_Projectile <- function()
	{
		if (PROJECTILES.len() < 1)
		{
			return;
		}

		local removearray = [];
		local vec;
		foreach (index, projectile_class in PROJECTILES)
		{
			if (!TargetValid(projectile_class.GetHandle()))
			{
				removearray.push(index);
				continue;
			}

			if (projectile_class.GetID() == 0)
			{
				vec = projectile_class.GetCenter();
				foreach (nade in SCANNADES)
				{
					if (GetDistance3D(nade.GetOrigin(), vec) <= projectile_class.GetDistance())
					{
						vec = null;
						nade.SetDestroy(true);
						projectile_class.Destroy();
						removearray.push(index);
						break;
					}
				}

				if (vec == null)
				{
					continue;
				}

				vec = projectile_class.GetCenter();
				foreach (turret in TURRETS)
				{
					if (GetDistance3D(turret.GetOrigin(), vec) <= projectile_class.GetDistance() * 2)
					{
						vec = null;
						turret.DamageTurret_Owner(null, VULTURE_TURRET_DAMAGE, Enum_DAMAGE_TYPE.ZOMBIE_PROJECTILE);
						projectile_class.Destroy();

						removearray.push(index);
						break;
					}
				}

				if (vec == null)
				{
					continue;
				}


				vec = projectile_class.GetCenter();
				foreach (minigame in MINIGAMES)
				{
					if (GetDistance3D(minigame.GetOrigin(), vec) <= projectile_class.GetDistance() * 2)
					{
						vec = null;
						minigame.ForceEnd();
						projectile_class.Destroy();

						removearray.push(index);
						break;
					}
				}

				if (vec == null)
				{
					continue;
				}
			}

			if (!InSight(projectile_class.GetCenter(), projectile_class.GetNextCenter(), g_IGNORE_COLLISON))
			{
				DebugDrawLine(projectile_class.GetCenter(), projectile_class.GetNextCenter(), 255, 0, 0, true, 5.06)
				projectile_class.Destroy();
				removearray.push(index);
				continue;
			}
			DebugDrawLine(projectile_class.GetCenter(), projectile_class.GetNextCenter(), 255, 255, 255, true, 5.06)
		}

		removearray.reverse();
		foreach (value in removearray)
		{
			PROJECTILES.remove(value);
		}
	}

	::RemoveIgnoreCollision <- function(collision)
	{
		foreach (index, coll in g_IGNORE_COLLISON)
		{
			if (collision == coll)
			{
				g_IGNORE_COLLISON.remove(index);
				return;
			}
		}
	}

	::Create_ExplosionBTR <- function()
	{
		AOP(Entity_Maker, "EntityTemplate", "btr_explosion");
		local vecOrigin = caller.GetOrigin();
		Entity_Maker.SpawnEntityAtLocation(vecOrigin, caller.GetForwardVector());

		if (IsVectorInBoundingBox(vecOrigin, Vector(11482, 285, -118), Vector(100, 280, 74)))
		{
			Trigger_Chapter4_04();
		}
	}
}
////////////////////////////////////////////////////////////////
//
// 					MAIN BLOCK
//
////////////////////////////////////////////////////////////////

::Tick_Class <- function()
{
	Class_Scope.Tick_Zombie();
	Class_Scope.Tick_Human();
	Class_Scope.Tick_ScanNade();
	Class_Scope.Tick_Turret();
	Class_Scope.Tick_Projectile();

	Class_Scope.Tick_ClassPick();

	Portal_Scope.Tick_PortalPick();
	Portal_Scope.Tick_Portals();
	Portal_Scope.Tick_PortalMaker();
}

function Init()
{
	EF("map_entity_text_ability", "SetText", Translate["gt_abilityready"]);
	EF("map_entity_text_classpicker", "SetText", Translate["gt_howselect"]);
	EF("map_entity_text_limit_class", "SetText", Translate["gt_classlimit"]);

	local obj;

	//ZO
	{
		obj = class_zombie_data();
		obj.name = "berserk";
		obj.anim_stand_idle.push("idle_stand");
		obj.anim_run_start.push("move_loop");
		obj.anim_run_loop.push("move_loop");
		obj.anim_run_end.push("move_stop");

		obj.anim_crouch_run.push("run_crouch");

		obj.cam_pos = class_pos(Vector(-15997, 16279, 15980), Vector(15, 0, 0));


		obj.hp = 1250;
		// obj.hp = 5;
		obj.speed = 1.18;
		obj.damage = 25;

		obj.regen_hp_hit = 50;
		obj.regen_after_hits = 5;
		obj.regen_for_tick = 20;
		obj.regen_delay_tick = 0.2;

		obj.knife_delay1 = 0.5;
		obj.ability_cd = 20;
		obj.ability_duration = 8;

		EF("map_entity_text_class_info_z_" + ZOMBIE_CLASS_DATA.len(), "SetText", format("HP : %i\n" + Translate["gt_speed"] + " : %.2f\n" + Translate["gt_damage"] + " : %i\n" + Translate["gt_ability"] + " : " + Translate["gt_abilityberserk"] + "\n" + Translate["gt_abilityduration"] + " : %i\n" + Translate["gt_abilitycd"] + " : %i",
		obj.hp, obj.speed, obj.damage, obj.ability_duration, obj.ability_cd));

		ZOMBIE_CLASS_DATA.push(obj);


		obj = class_zombie_data();
		obj.name = "vulture";
		obj.anim_stand_idle.push("idle_stand");
		obj.anim_stand_idle.push("idle_stand1");
		obj.anim_run_start.push("run_fast");
		obj.anim_run_loop.push("run_fast");

		obj.anim_crouch_idle.push("idle_crouch");
		obj.anim_crouch_run.push("crouch_run");

		obj.cam_pos = class_pos(Vector(-15997, 16205, 15980), Vector(15, 0, 0));

		obj.hp = 600;
		// obj.hp = 5;
		obj.speed = 1.25;
		obj.damage = 20;

		obj.regen_after_hits = 5;
		obj.regen_for_tick = 10;
		obj.regen_delay_tick = 0.2;

		obj.knife_delay1 = 3.5;
		obj.ability_cd = 3.5;

		EF("map_entity_text_class_info_z_" + ZOMBIE_CLASS_DATA.len(), "SetText", format("HP : %i\n" + Translate["gt_speed"] + " : %.2f\n" + Translate["gt_damage"] + " : %i\n" + Translate["gt_ability"] + " : " + Translate["gt_abilityvulture"] + "\n" + Translate["gt_abilitycd"] + " : %i",
		obj.hp, obj.speed, obj.damage, obj.ability_duration, obj.ability_cd));

		ZOMBIE_CLASS_DATA.push(obj);


		obj = class_zombie_data();
		obj.name = "tank";
		obj.anim_stand_idle.push("idle_stand");
		obj.anim_run_start.push("attack_run_charge1");
		obj.anim_run_loop.push("attack_run_charge1");

		obj.anim_crouch_idle.push("idle_crouch");
		obj.anim_crouch_run.push("run_crouch");

		obj.cam_pos = class_pos(Vector(-16011, 16115, 15980), Vector(15, 0, 0));

		obj.hp = 6000;
		// obj.hp = 5;
		obj.speed = 1.05;
		obj.damage = 30;

		obj.regen_hp_hit = 100;
		obj.regen_after_hits = 15;
		obj.regen_for_tick = 150;
		obj.regen_delay_tick = 1.0;

		obj.knife_delay1 = 0.6;
		obj.ability_cd = 30.0;
		obj.ability_duration = 5.0;

		EF("map_entity_text_class_info_z_" + ZOMBIE_CLASS_DATA.len(), "SetText", format("HP : %i\n" + Translate["gt_speed"] + " : %.2f\n" + Translate["gt_damage"] + " : %i\n" + Translate["gt_ability"] + " : " + Translate["gt_abilitytank"] + "\n" + Translate["gt_abilityduration"] + " : %i\n" + Translate["gt_abilitycd"] + " : %i",
		obj.hp, obj.speed, obj.damage, obj.ability_duration, obj.ability_cd));

		ZOMBIE_CLASS_DATA.push(obj);
	}
	//HO
	{
		obj = class_human_data();
		obj.name = "soldier";
		obj.skin = "0";

		obj.cam_pos = class_pos(Vector(-15997, 16012, 15980), Vector(15, 0, 0));

		obj.hp = 150;
		obj.speed = 1.0;
		obj.damage_multi = 1.00;
		obj.CalculateColorBalance();

		EF("map_entity_text_class_info_h_" + HUMAN_CLASS_DATA.len(), "SetText", format("HP : %i\n" + Translate["gt_speed"] + " : %.2f\n" + Translate["gt_damage"] + " : %.2f",
		obj.hp, obj.speed, obj.damage_multi));

		HUMAN_CLASS_DATA.push(obj);

		obj = class_human_data();
		obj.name = "scout";
		obj.skin = "2";

		obj.cam_pos = class_pos(Vector(-15997, 15924, 15980), Vector(15, 0, 0));

		obj.hp = 120;
		obj.speed = 1.05;
		obj.damage_multi = 0.75;
		obj.CalculateColorBalance();

		EF("map_entity_text_class_info_h_" + HUMAN_CLASS_DATA.len(), "SetText", format("HP : %i\n" + Translate["gt_speed"] + " : %.2f\n" + Translate["gt_damage"] + " : %.2f\n" + Translate["gt_ability"] + " : " + Translate["gt_abilityscout"] + "\n" + Translate["gt_abilityduration"] + " : %i",
		obj.hp, obj.speed, obj.damage_multi, SCANNADE_LIFETIME));

		HUMAN_CLASS_DATA.push(obj);

		obj = class_human_data();
		obj.name = "engineer";
		obj.skin = "1";

		obj.cam_pos = class_pos(Vector(-15997, 15837, 15980), Vector(15, 0, 0));

		obj.hp = 130;
		obj.speed = 1.0;
		obj.damage_multi = 0.9;
		obj.CalculateColorBalance();

		EF("map_entity_text_class_info_h_" + HUMAN_CLASS_DATA.len(), "SetText", format("HP : %i\n" + Translate["gt_speed"] + " : %.2f\n" + Translate["gt_damage"] + " : %.2f\n" + Translate["gt_ability"] + " : " + Translate["gt_abilityengineer"] + "\n" + Translate["gt_abilityduration"] + " : %i",
		obj.hp, obj.speed, obj.damage_multi, TURRET_LIFETIME));

		HUMAN_CLASS_DATA.push(obj);
	}
}
Init();