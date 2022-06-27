const TICKRATE = 0.05;

const TICKRATE_BLOOD = 1.00;
const TICKRATE_FADE = 1.3;

const MIN_HP_FOR_BLOOD = 55;
const MIN_HP_FOR_FADE = 90;
const MIN_HP_FOR_SOUNDE = 50;

const MAX_HP = 100;

g_bTicking_HumanCheck <- false;

g_bTickRate_Blood <- 0.0;
g_bTickRate_Fade <- 0.0;


::g_hFade_LowHP <- Entities.CreateByClassname("env_fade");

::Human_Script <- self.GetScriptScope();
::Human_Handle <- self;

::HUMAN_OWNERS <- [];
::class_human_owner <- class
{
	glow = null;
	handle = null;
	knife = null;

	constructor(_handle, _knife)
	{
		printl("constructor" + _handle);
		this.handle = _handle;
		this.knife = _knife;
		this.glow = CreateGlowSkin(_handle);

		EF(_handle, "SetDamageFilter", "filter_team_not_t");
		this.handle.SetMaxHealth(MAX_HP);
		this.handle.SetHealth(MAX_HP);
	}

	function SelfDestroy()
	{
		printl("destroy");

		if (TargetValid(this.knife))
		{
			this.knife.Destroy();
		}
		if (TargetValid(this.glow))
		{
			this.glow.Destroy();
		}

		if (TargetValid(this.handle))
		{
			AOP(this.handle, "targetname", "");
		}
		RemovePlayerMovementClassByHandle(this.handle);
	}

	function CheckBlood()
	{
		if (this.handle.GetHealth() < MIN_HP_FOR_BLOOD)
		{
			DispatchParticleEffect("blood_pool", this.handle.GetOrigin() + Vector(0, 0, 32), Vector(0, 0, 0));
		}
	}

	function CheckFade()
	{
		local hp = this.handle.GetHealth();
		if (hp <= MIN_HP_FOR_FADE)
		{
			local proccent = (1.00 - (0.00 + hp) / MAX_HP);
			local green = 200.0 - 200.0 * proccent;
			local blue = 128.0 - 128.0 * proccent;

			if (hp <= MIN_HP_FOR_SOUNDE)
			{
				EntFireByHandle(POINT_CLIENT_COMMAND, "Command", "play player/heartbeat_noloop.wav", 0.00, this.handle, this.handle);
			}

			EntFireByHandle(g_hFade_LowHP, "Color", "255 " + green + " " + blue, 0, this.handle, this.handle);
			EntFireByHandle(g_hFade_LowHP, "Fade", "", 0, this.handle, this.handle);
		}

	}
}

function TickHuman()
{
	if (!g_bTicking_HumanCheck)
	{
		return;
	}
	g_bTicking_HumanCheck = false;

	local bUpdateBloody = false;
	g_bTickRate_Blood += TICKRATE;
	if (g_bTickRate_Blood >= TICKRATE_BLOOD)
	{
		g_bTickRate_Blood = 0.0;
		bUpdateBloody = true;
	}

	local bUpdateFade = false;
	g_bTickRate_Fade += TICKRATE;
	if (g_bTickRate_Fade >= TICKRATE_FADE)
	{
		g_bTickRate_Fade = 0.0;
		bUpdateFade = true;
	}

	foreach (index, human in HUMAN_OWNERS)
	{
		if (!TargetValid(human.handle) ||
		human.handle.GetTeam() != CS_TEAM_CT ||
		human.handle.GetHealth() < 1)
		{
			human.SelfDestroy();
			HUMAN_OWNERS.remove(index);
			continue;
		}

		if (bUpdateBloody)
		{
			human.CheckBlood();
		}

		if (bUpdateFade)
		{
			human.CheckFade();
		}

		g_bTicking_HumanCheck = true;
	}

	if (g_bTicking_HumanCheck)
	{
		CallFunction("TickHuman()", TICKRATE);
	}
}

function PickHumanKnife()
{
	printl("PickHumanKnife" + activator);
	HUMAN_OWNERS.push(class_human_owner(activator, caller));
	if (!g_bTicking_HumanCheck)
	{
		g_bTicking_HumanCheck = true;
		TickHuman();
	}
}

::CreateHuman <- function(origin)
{
	// local origin = Vector(-500, -188, 16);
	local knife = CreateKnife(origin, true, false);
	local trigger = CreateTrigger(origin, Vector(16, 16, 16), null, {parentname = knife.GetName(), filtername = "filter_team_only_ct"});

	AOP(trigger, "OnStartTouch", "map_script_human_controller:RunScriptCode:TouchHumanTrigger():0:-1", 0.01);
	EF(trigger, "Enable", "", 0.01);
}

function TouchHumanTrigger()
{
	printl("TouchHumanTrigger" + activator);
	if (GetHumanOwnerClassByOwner(activator) != null)
	{
		return;
	}
	local knife = caller.GetMoveParent();
	local ownerknife = GetPlayerKnifeByOwner(activator);

	EF(caller, "Kill");
	if (ownerknife != null && ownerknife.IsValid())
	{
		ownerknife.Destroy();
	}

	AOP(knife, "OnPlayerPickup", "map_script_human_controller:RunScriptCode:PickHumanKnife():0:1", 0.01);
	EF(knife, "ToggleCanBePickedUp", "", 0.01);
	knife.SetOrigin(activator.GetOrigin());
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

function Init()
{
	// CreateHuman();

	g_hFade_LowHP.__KeyValueFromString("duration", "" + TICKRATE_FADE);
	g_hFade_LowHP.__KeyValueFromString("holdtime", "" + TICKRATE_FADE * 0.5);
	g_hFade_LowHP.__KeyValueFromInt("renderamt", 200);
	g_hFade_LowHP.__KeyValueFromInt("spawnflags", 7);
	g_hFade_LowHP.__KeyValueFromVector("rendercolor", Vector(255, 128, 64));
}
Init();
