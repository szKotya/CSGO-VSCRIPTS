g_szName <- self.GetName().slice(self.GetPreTemplateName().len(), self.GetName().len());
g_hEye <- Entities.CreateByClassname("prop_dynamic");
g_hEye.SetModel("models/editor/playerstart.mdl");

AOP(g_hEye, "solid", 0);
AOP(g_hEye, "rendermode", 10);
AOP(g_hEye, "targetname", "item_push_eye" + g_szName);

g_hEye_Parent <- Entities.CreateByClassname("logic_measure_movement");
AOP(g_hEye_Parent, "MeasureType", 1);
AOP(g_hEye_Parent, "TargetScale", 100);

EF(g_hEye_Parent, "SetTargetReference", g_hEye.GetName(), 0.02);
EF(g_hEye_Parent, "SetMeasureReference", g_hEye.GetName(), 0.02);
EF(g_hEye_Parent, "SetTarget", g_hEye.GetName(), 0.02);
EF(g_hEye_Parent, "Disable");

g_hParent <- null;
g_hModel <- null;
g_hSound_Shot <- null;
g_hGun <- null;
g_hOwner <- null;

g_hLight <- null;
g_hParticle <- null;
g_hTrigger <- null;

g_bCD <- false;
g_fCD <- 5.0;

g_szAnim <- "";
g_bActive <- -1;

function ActivateItem(owner)
{
	printl("ActivateItem");
	if (g_bActive == 1)
	{
		return;
	}
	UpDateAmmo();

	g_hOwner = owner;
	SetEyeParent();

	EF(g_hParent, "ClearParent");
	EntFireByHandle(g_hParent, "SetParent", "!activator", 0.02, g_hOwner, g_hOwner);
	EntFireByHandle(g_hParent, "SetParentAttachment", "weapon_hand_R", 0.07, g_hOwner, g_hOwner);
	EntFireByHandle(self, "Activate", "", 0.05, g_hOwner, g_hOwner);
	g_bActive = 1;
}

function RemoveOwner()
{
	printl("REMOVEOWNERGUN")
	g_bActive = -1;
	g_hOwner = null;

	SetModelParent();
}

function SetModelParent()
{
	EF(g_hEye, "ClearParent");
	EF(g_hEye_Parent, "Disable");

	local vecOrigin = g_hModel.GetOrigin() + g_hModel.GetLeftVector() * -34; 
	local vecDir =  g_hModel.GetLeftVector() * -1;
	CallFunction("caller.SetOrigin(Vector(" +vecOrigin.x + "," + vecOrigin.y + "," + vecOrigin.z + "));caller.SetForwardVector(Vector(" +vecDir.x + "," + vecDir.y + "," + vecDir.z + "))", 0.02, g_hEye, g_hEye);
	EntFireByHandle(g_hEye, "SetParent", "!activator", 0.02, g_hParent, g_hParent);
}

function SetEyeParent()
{
	EF(g_hEye, "ClearParent");

	local vecOrigin = g_hOwner.EyePosition();
	AOP(g_hOwner, "targetname", "owner" + g_szName);
	EF(g_hEye_Parent, "SetMeasureTarget", g_hOwner.GetName());
	EF(g_hEye_Parent, "Enable");

	CallFunction("caller.SetOrigin(Vector(" +vecOrigin.x + "," + vecOrigin.y + "," + vecOrigin.z + "));", 0.02, g_hEye, g_hEye);
	EntFireByHandle(g_hEye, "SetParent", "!activator", 0.02, g_hOwner, g_hOwner);
	AOP(g_hOwner, "targetname", "", 0.07);
}

function DeactivateItem()
{
	printl("DeactivateItem");
	if (g_bActive != 0)
	{
		SetModelParent();

		EF(g_hParent, "ClearParent");
		EntFireByHandle(g_hParent, "SetParent", "!activator", 0.01, g_hOwner, g_hOwner);
		EntFireByHandle(g_hParent, "SetParentAttachment", "primary", 0.06, g_hOwner, g_hOwner);

		if (TargerValid(g_hOwner))
		{
			EF(self, "Deactivate", "", 0.02);
		}
		
		g_hOwner = null;
		g_bActive = 0;
	}
}

function OnPressAttack2()
{
	if (!IsAttack() && !IsReload() && !IsCD())
	{
		Shoot();
	}
}

function TogglePush(time, time1)
{
	EF(g_hSound_Shot, "PlaySound", "", time - 0.15);
	EF(g_hLight, "TurnOn", "", time);
	EF(g_hParticle, "Start", "", time);
	EF(g_hTrigger, "Enable", "", time);

	EF(g_hLight, "TurnOff", "", time1);
	EF(g_hParticle, "Stop", "", time1);
	EF(g_hTrigger, "Disable", "", time1);
}

function Shoot()
{
	TogglePush(2.2, 3.1);
	SetCD();

	g_szAnim = "attack";
	EF(g_hModel, "SetAnimation", "animgraber4");
}

function Reload()
{
	g_szAnim = "reload";
	EF(g_hModel, "SetAnimation", "animgraber1", 0.01);
}

function UpDateAmmo()
{
	EF(g_hGun, "SetAmmoAmount", "" + ((g_bCD) ? "0" : "1"));
	EF(g_hGun, "SetReserveAmmoAmount", "0");
}

function SetCD()
{
	g_bCD = true;
	UpDateAmmo();
	CallFunction("SetUnCD()", g_fCD);
}

function SetUnCD()
{
	g_bCD = false;
	UpDateAmmo();
}

function OnAnimEnd()
{
	local anim = g_szAnim;
	g_szAnim = "";

	switch (anim)
	{
		case "attack":
		{
			Reload();
			break;
		}

		case "reload":
		{
			break;
		}
	}
}

function IsAttack()
{
	if (g_szAnim == "attack")
	{
		return true;
	}
	return false;
}

function IsReload()
{
	if (g_szAnim == "reload")
	{
		return true;
	}
	return false;
}

function IsCD()
{
	return g_bCD;
}

function Init()
{
	g_hParticle.SetOrigin(g_hEye.GetOrigin());
	EntFireByHandle(g_hParticle, "SetParent", "!activator", 0.02, g_hEye, g_hEye);
}
CallFunction("Init()", 0.05);
CallFunction("UpDateAmmo()", 0.05);