g_hMaker <- Entities.FindByName(null, "missile_rocket_maker");

g_szName <- self.GetName().slice(self.GetPreTemplateName().len(), self.GetName().len());
g_hEye <- Entities.CreateByClassname("prop_dynamic");
g_hEye.SetModel("models/editor/playerstart.mdl");
AOP(g_hEye, "solid", 0);
AOP(g_hEye, "rendermode", 10);
AOP(g_hEye, "targetname", "item_rocket_eye" + g_szName);

g_hEye_Parent <- Entities.CreateByClassname("logic_measure_movement");
AOP(g_hEye_Parent, "MeasureType", 1);
AOP(g_hEye_Parent, "TargetScale", 100);

EF(g_hEye_Parent, "SetTargetReference", g_hEye.GetName(), 0.02);
EF(g_hEye_Parent, "SetMeasureReference", g_hEye.GetName(), 0.02);
EF(g_hEye_Parent, "SetTarget", g_hEye.GetName(), 0.02);
EF(g_hEye_Parent, "Disable");

g_hParent <- null;
g_hModel <- null;
g_hSound_Reload <- null;
g_hGun <- null;
g_hOwner <- null;

g_iAmmo_Max <- 2;
g_iAmmo <- g_iAmmo_Max;

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
	g_hEye.SetOrigin(g_hOwner.EyePosition());
	AOP(g_hOwner, "targetname", "owner" + g_szName);
	EF(g_hEye_Parent, "SetMeasureTarget", g_hOwner.GetName());
	EF(g_hEye_Parent, "Enable");
	EntFireByHandle(g_hEye, "SetParent", "!activator", 0.02, g_hOwner, g_hOwner);
	AOP(g_hOwner, "targetname", "", 0.07);

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
	EF(g_hEye, "ClearParent");
	EF(g_hEye_Parent, "Disable");
}

function DeactivateItem()
{
	printl("DeactivateItem");
	if (g_bActive != 0)
	{
		EF(g_hEye, "ClearParent");
		EF(g_hEye_Parent, "Disable");

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
	if (!IsAttack() && !IsReload())
	{
		g_iAmmo--;
		UpDateAmmo();
		Shoot();
	}
}

function Shoot()
{
	local vecDir;
	if (TargerValid(g_hOwner))
	{
		vecDir = TraceDir(g_hEye.GetOrigin(), g_hEye.GetForwardVector());
	}
	else
	{
		vecDir = TraceDir(g_hModel.GetOrigin(), g_hModel.GetForwardVector());
	}
	local vecStart = g_hModel.GetAttachmentOrigin(g_hModel.LookupAttachment("muzzle"));

	vecDir = GetPithXawFVect3D(vecDir, vecStart);
	g_hMaker.SpawnEntityAtLocation(vecStart, vecDir);

	g_szAnim = "attack";
	EF(g_hModel, "SetAnimation", "rocketfire");
}

function Reload()
{
	EF(g_hSound_Reload, "PlaySound");

	g_szAnim = "reload";
	EF(g_hModel, "SetAnimation", "rocketreload", 0.01);
}

function ReloadEnd()
{
	g_iAmmo = g_iAmmo_Max;
}

function UpDateAmmo()
{
	EF(g_hGun, "SetAmmoAmount", "" + g_iAmmo);
	EF(g_hGun, "SetReserveAmmoAmount", "0");
}

function OnAnimEnd()
{
	local anim = g_szAnim;
	g_szAnim = "";

	switch (anim)
	{
		case "attack":
		{
			if (g_iAmmo <= 0)
			{
				Reload();
			}
			break;
		}

		case "reload":
		{
			ReloadEnd();
			break;
		}
	}
	UpDateAmmo();
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
CallFunction("UpDateAmmo()", 0.05);