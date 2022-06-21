const TICKRATE = 0.05;

g_bTicking_ZombieCheck <- false;

::Zombie_Script <- self.GetScriptScope();
::Zombie_Handle <- self;

::ZOMBIE_OWNERS <- [];
::class_zombie_owner <- class
{
	handle = null;
	knife = null;

	trigger_hand = null;

	controller = null;
	eye = null;
	measure = null;

	constructor(_handle, _knife)
	{
		this.handle = _handle;
		this.knife = _knife;

		local temp = CreateEyeParent(_handle);

		this.measure = temp[0];
		this.eye = temp[1];

		this.controller = CreateController(_handle, Zombie_Handle, g_iItem_GameUIFlags);
		this.controller.press_attack = Zombie_Script.PressedAttack1;
		this.controller.unpress_attack = Zombie_Script.UnPressedAttack1;

		this.trigger_hand = CreateTrigger(this.eye.GetOrigin(), Vector(32, 32, 16), null, null);
		this.trigger_hand.SetForwardVector(this.eye.GetForwardVector());

		EntFireByHandle(this.trigger_hand, "SetParent", "!activator", 0.01, this.eye, this.eye);
		AOP(this.trigger_hand, "OnStartTouch", "map_script_map_manager:RunScriptCode:DamagePlayerByHandle(20):0:-1", 0.01);
	}
	function SelfDestroy()
	{
		printl("destroy");

		if (TargerValid(this.knife))
		{
			this.knife.Destroy();
		}
		if (TargerValid(this.trigger_hand))
		{
			this.trigger_hand.Destroy();
		}
		if (TargerValid(this.eye))
		{
			this.eye.Destroy();
		}
		if (TargerValid(this.measure))
		{
			this.measure.Destroy();
		}
		// LAST???
		if (TargerValid(this.controller))
		{
			EF(this.controller, "Kill");
		}
	}
}

function TickZombie()
{
	if (!g_bTicking_ZombieCheck)
	{
		return;
	}
	g_bTicking_ZombieCheck = false;

	foreach (index, zombie in ZOMBIE_OWNERS)
	{
		if (TargerValid(zombie.handle) && zombie.handle.GetHealth() > 0)
		{
			g_bTicking_ZombieCheck = true;
		}
		else
		{
			zombie.SelfDestroy();
		}
	}

	if (g_bTicking_ZombieCheck)
	{
		CallFunction("TickZombie()", TICKRATE);
	}
}

function PickZombieKnife()
{
	ZOMBIE_OWNERS.push(class_zombie_owner(activator, caller));
	if (!g_bTicking_ZombieCheck)
	{
		g_bTicking_ZombieCheck = true;
		TickZombie();
	}
}

function CreateZombie()
{
	local origin = Vector(-480, 0, 16);
	local knife = CreateKnife(origin, true, false);
	local trigger = CreateTrigger(origin, Vector(16, 16, 16), null, null);

	SetParentByActivator(trigger, knife);
	AOP(trigger, "OnStartTouch", "map_script_zombie_controller:RunScriptCode:TouchZombieTrigger():0:-1", 0.01);
	EF(trigger, "Enable", "", 0.01);
}

function TouchZombieTrigger()
{
	local knife = caller.GetMoveParent();
	local ownerknife = GetPlayerKnifeByOwner(activator);

	EF(caller, "Kill");
	if (ownerknife != null && ownerknife.IsValid())
	{
		ownerknife.Destroy();
	}

	AOP(knife, "OnPlayerPickup", "map_script_zombie_controller:RunScriptCode:PickZombieKnife():0:1", 0.01);
	EF(knife, "ToggleCanBePickedUp", "", 0.01);
	knife.SetOrigin(activator.GetOrigin());
}

CreateZombie();

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

	EF(zombie_owner_class.trigger_hand, "Enable");
}
function Hook_UnPressedAttack1()
{
	printl("Hook_UnPressedAttack1 : " + activator);
	local zombie_owner_class = GetZombieOwnerClassByOwner(activator);
	if (zombie_owner_class == null)
	{
		return;
	}

	EF(zombie_owner_class.trigger_hand, "Disable");
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