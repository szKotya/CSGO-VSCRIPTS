const TICKRATE = 0.01;

g_hTarget <- null;
g_hSprite <- null;

g_hUp <- true;
g_iRadius <- 4096;
g_fSpeed <- 20;
function OnPostSpawn()
{
	local players = [];
	local player;
	while ((player = Entities.FindInSphere(player, self.GetOrigin(), g_iRadius)) != null)
	// while ((player = Entities.FindByClassnameWithin(player, "player", self.GetOrigin(), g_iRadius)) != null)
	{
		if (player.IsValid() &&
		player.GetHealth() > 0 &&
		player.GetTeam() == 3)
		{
			if (InSight(player.GetOrigin() + Vector(0, 0, 45), self.GetOrigin()))
			{
				players.push(player);
			}
		}
	}
	if (players.len() == 0)
	{
		return CallFunction("Explode()", TICKRATE);
	}
	else if (players.len() == 1)
	{
		g_hTarget = players[0];
	}
	else
	{
		g_hTarget = players[RandomInt(0, players.len() - 1)];
	}
	CreateTargetSprite();
	CallFunction("g_hUp = false;", 0.5);
	Tick();
}

function Tick()
{
	if (!self.IsValid())
	{
		return;
	}

	if (!g_hUp)
	{
		if (!TargerValid(g_hTarget) || g_hTarget.GetHealth() < 1)
		{
			return Explode();
		}
		local vecDir = self.GetOrigin() - (g_hTarget.GetOrigin() + Vector(0, 0, 45));
		vecDir.Norm();
		self.SetForwardVector(vecDir);
	}
	if (!InSight((self.GetOrigin() + self.GetForwardVector() * -40), self.GetOrigin() + self.GetForwardVector() * -(g_fSpeed + 40)))
	{
		return Explode();
	}
	self.SetOrigin(self.GetOrigin() + self.GetForwardVector() * -g_fSpeed);
	CallFunction("Tick()", TICKRATE);
}

function CreateTargetSprite()
{
	local kv = {};
	local temp = class_pos(g_hTarget.GetOrigin() + (g_hTarget.GetForwardVector() * 20) + Vector(0, 0, 45));
	kv["pos"] <- temp;
	kv["rendermode"] <- 5;
	kv["model"] <- "sprites/640_pain_up.vmt";
	g_hSprite = Sprite_Maker.CreateEntity(kv);
	AOP(g_hSprite, "renderfx", 2);
	EF(g_hSprite, "ShowSprite");
	EntFireByHandle(g_hSprite, "SetParent", "!activator", 0, g_hTarget, g_hTarget);

	kv = {};
	kv["size"] <- GetSizeByWLH(64);
	kv["pos"] <- class_pos(self.GetOrigin(), self.GetForwardVector());
	kv["parentname"] <- self.GetName();
	local trigger = CreateTrigger(kv);
	
	AOP(trigger, "OnStartTouch", self.GetName() + ":RunScriptCode:Explode():0.05:1", 0.01);
}

function Explode()
{
	CreateExplosion((self.GetOrigin() + self.GetForwardVector() * -40), 128, 30, null);

	if (TargerValid(g_hSprite))
	{
		g_hSprite.Destroy();
	}

	if (TargerValid(self))
	{
		self.Destroy();
	}
}