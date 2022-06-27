const TICKRATE = 0.05;
const TICKRATE_HP = 1.00;
const TICKRATE_KNIFE1 = 0.2;


const KNIFE1_DELAY = 0.5;
const JUMP_DELAY = 2.0;

::REGEN_HP_FOR_HIT <- 20;
::DAMAGE_KNIFE1 <- 25;
::SPEED <- 0.3;

const PHYSBOX_HP = 9999999
const MAX_HP = 700

g_bTicking_ZombieCheck <- false;

g_bTickRate_HP <- 0.0;
g_bTickRate_KNIFE1 <- 0.0;


::Zombie_Script <- self.GetScriptScope();
::Zombie_Handle <- self;

::ZOMBIE_OWNERS <- [];
::class_zombie_owner <- class
{
	handle = null;
	knife = null;

	hp = MAX_HP;
	hp_max = MAX_HP;
	last_hp = PHYSBOX_HP;
	last_dps_player = null;

	trigger_hand = null;
	controller = null;
	physbox = null;
	eye = null;
	measure = null;

	fknife_time = 0;
	bknife = false;

	constructor(_handle, _knife)
	{
		printl("constructor" + _handle);
		this.handle = _handle;
		this.knife = _knife;

		local temp = CreateEyeParent(_handle);

		this.measure = temp[0];
		this.eye = temp[1];

		this.controller = CreateController(_handle, Zombie_Handle, g_iItem_GameUIFlags);
		this.controller.press_attack = Zombie_Script.PressedAttack1;
		this.controller.unpress_attack = Zombie_Script.UnPressedAttack1;

		this.trigger_hand = CreateTrigger(this.eye.GetOrigin() + this.eye.GetForwardVector() * 20, Vector(48, 80, 48), null, {filtername = "filter_team_only_ct", parentname = this.eye.GetName()});
		this.trigger_hand.SetForwardVector(this.eye.GetForwardVector());

		AOP(this.trigger_hand, "OnStartTouch", "map_script_zombie_controller:RunScriptCode:TouchZombieAttackTrigger():0:-1", 0.01);

		this.physbox = CreatePhysBoxMulti(_handle.GetOrigin() + Vector(0, 0, 38), {model = "*2", damagefilter = "filter_team_not_t", parentname = _handle.GetName(), spawnflags = 62464, health = PHYSBOX_HP, disableflashlight = 1, material = 10, disableshadowdepth = 1, disableshadows = 1});
		AOP(this.physbox, "CollisionGroup", 16);
		AOP(this.physbox, "OnHealthChanged", "map_script_zombie_controller:RunScriptCode:DamageZombieByPhysBox():0:-1", 0.01);

		EF(_handle, "SetDamageFilter", "filter_team_only_t");
		this.handle.SetMaxHealth(MAX_HP);

		this.hp = MAX_HP;
		this.hp_max = MAX_HP;
		this.last_hp = PHYSBOX_HP;
		this.UpDateHP();

		SetSpeed(_handle, SPEED);
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

	function JumpCheck()
	{
		local vecVelocity = this.handle.GetVelocity();
		if (vecVelocity.z > 0)
		{
			this.handle.SetVelocity(Vector(vecVelocity.x, vecVelocity.y, 0));
		}
	}

	function RegenHP()
	{
		if (this.fknife_time > Time())
		{
			return;
		}
		this.hp += REGEN_HP_FOR_HIT;
		if (this.hp > MAX_HP)
		{
			this.hp = MAX_HP;
		}

		UpDateHP();
	}

	function DamageZombie(dps = null)
	{
		local idamage = this.last_hp - this.physbox.GetHealth();
		this.last_hp = this.physbox.GetHealth();
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
		if (TargetValid(this.controller.game_ui))
		{
			EF(this.controller.game_ui, "Kill");
		}
		if (TargetValid(this.handle))
		{
			AOP(this.handle, "targetname", "");
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

		// DrawBoundingBox(zombie.trigger_hand, Vector(255, 0, 0), TICKRATE + 0.01);
		// DrawBoundingBox(zombie.physbox, Vector(0, 255, 0), TICKRATE + 0.01);

		zombie.JumpCheck();

		g_bTickRate_KNIFE1 += TICKRATE;
		if (g_bTickRate_KNIFE1 >= TICKRATE_KNIFE1)
		{
			g_bTickRate_KNIFE1 = 0.0;
			zombie.KnifeCheck();
		}

		if (bUpdateHP)
		{
			zombie.UpDateHP();
		}

		g_bTicking_ZombieCheck = true;
	}

	if (g_bTicking_ZombieCheck)
	{
		CallFunction("TickZombie()", TICKRATE);
	}
}

function PickZombieKnife()
{
	printl("PickZombieKnife" + activator);
	ZOMBIE_OWNERS.push(class_zombie_owner(activator, caller));
	if (!g_bTicking_ZombieCheck)
	{
		g_bTicking_ZombieCheck = true;
		TickZombie();
	}
}

::CreateZombie <- function(origin)
{
	// local origin = Vector(-480, 0, 16);
	local knife = CreateKnife(origin, true, false);
	local trigger = CreateTrigger(origin, Vector(16, 16, 16), null, {parentname = knife.GetName(), filtername = "filter_team_only_t"});

	// SetParentByActivator(trigger, knife);
	AOP(trigger, "OnStartTouch", "map_script_zombie_controller:RunScriptCode:TouchZombieTrigger():0:-1", 0.01);
	EF(trigger, "Enable", "", 0.01);
}

function TouchZombieTrigger()
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
	if (ownerknife != null && ownerknife.IsValid())
	{
		ownerknife.Destroy();
	}

	AOP(knife, "OnPlayerPickup", "map_script_zombie_controller:RunScriptCode:PickZombieKnife():0:1", 0.01);
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

function TouchZombieAttackTrigger()
{
	local zombie_owner_class = GetZombieOwnerClassByHandTrigger(caller);
	if (zombie_owner_class == null)
	{
		return;
	}

	zombie_owner_class.RegenHP();
	zombie_owner_class.fknife_time = Time() + KNIFE1_DELAY;

	DispatchParticleEffect("blood_impact_goop_heavy", activator.GetOrigin() + Vector(0, 0, 48), zombie_owner_class.handle.GetForwardVector());
	DamagePlayer(activator, DAMAGE_KNIFE1);

	if (activator.GetHealth() - DAMAGE_KNIFE1 < 1)
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

particlelist <- [
"blood_impact_basic",
"blood_impact_basic_fallback",
"blood_impact_chunks1",
"blood_impact_drops1",
"blood_impact_dust",
"blood_impact_goop_heavy",
"blood_impact_goop_light",
"blood_impact_goop_medium",
"blood_impact_green_01",
"blood_impact_headshot",
"blood_impact_headshot_01b",
"blood_impact_headshot_01c",
"blood_impact_headshot_01d",
"blood_impact_headshot_01e",
"blood_impact_heavy",
"blood_impact_light",
"blood_impact_light_headshot",
"blood_impact_medium",
"blood_impact_mist1",
"blood_impact_mist1_light",
"blood_impact_mist_heavy",
"blood_impact_red_01",
"blood_impact_red_01_backspray",
"blood_impact_red_01_chunk",
"blood_impact_red_01_drops",
"blood_impact_red_01_goop_a",
"blood_impact_red_01_goop_a_backup",
"blood_impact_red_01_goop_b",
"blood_impact_red_01_goop_c",
"blood_impact_red_01_mist",
"blood_impact_yellow_01",
"blood_pool",
]
::t1 <- 0;
function t2(ID = null)
{
	if (ID == null)
	{
		t1++;
	}
	else
	{
		t1 = ID;
	}
	DispatchParticleEffect(particlelist[t1], activator.GetOrigin() + Vector(0, 0, 20) + activator.GetForwardVector() * 50, Vector(0, 0, 0));
	printl("ID " + particlelist[t1] + " : " + t1);
}

fdelay <- 0.5;
function t3()
{
	DispatchParticleEffect("blood_pool", activator.GetOrigin() + Vector(0, 0, 32), Vector(0, 0, 0));
	CallFunction("t3()", fdelay, activator, activator);
}

function Init()
{
	// CreateZombie();
}
Init();
