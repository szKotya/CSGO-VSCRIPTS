g_hMaker <- Entities.FindByName(null, "missile_bfg_maker");

g_szName <- self.GetName().slice(self.GetPreTemplateName().len(), self.GetName().len());
g_hEye <- Entities.CreateByClassname("prop_dynamic");
g_hEye.SetModel("models/editor/playerstart.mdl");
AOP(g_hEye, "solid", 0);
AOP(g_hEye, "rendermode", 10);
AOP(g_hEye, "targetname", "item_bfg_eye" + g_szName);

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
g_hSound_Shoot <- null;
g_hSound_Shoot_Pre <- null;
g_hGun <- null;
g_hOwner <- null;

g_iAmmo_Max <- 7;
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

	g_hEye.SetOrigin(owner.EyePosition());
	AOP(owner, "targetname", "owner" + g_szName);
	EF(g_hEye_Parent, "SetMeasureTarget", owner.GetName());
	EF(g_hEye_Parent, "Enable");
	EntFireByHandle(g_hEye, "SetParent", "!activator", 0.02, owner, owner);
	AOP(owner, "targetname", "", 0.07);

	EF(g_hParent, "ClearParent");
	EntFireByHandle(g_hParent, "SetParent", "!activator", 0.02, owner, owner);
	EntFireByHandle(g_hParent, "SetParentAttachment", "weapon_hand_R", 0.07, owner, owner);
	EntFireByHandle(self, "Activate", "", 0.05, owner, owner);
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

function DeactivateItem(owner)
{
	printl("DeactivateItem");
	if (g_bActive != 0)
	{
		EF(g_hEye, "ClearParent");
		EF(g_hEye_Parent, "Disable");

		EF(g_hParent, "ClearParent");
		EntFireByHandle(g_hParent, "SetParent", "!activator", 0.01, owner, owner);
		EntFireByHandle(g_hParent, "SetParentAttachment", "primary", 0.06, owner, owner);

		if (TargerValid(owner))
		{
			EF(self, "Deactivate", "", 0.02);
		}
		g_bActive = 0;
	}
}

function OnPressAttack2()
{
	if (!IsAttack() && !IsReload())
	{
		if (g_iAmmo > 0)
		{

			g_iAmmo--;

			UpDateAmmo();
			Shoot_Pre();
		}
	}
}

function Shoot_Pre()
{
	g_szAnim = "preattack";
	EF(g_hModel, "Color", "255 36 36");
	EF(g_hModel, "SetAnimation", "fire2");
	EF(g_hSound_Shoot_Pre, "PlaySound");
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
	EF(g_hModel, "SetAnimation", "fire1", 0.01);
	EF(g_hSound_Shoot, "PlaySound");
}

function Reload()
{
	EF(g_hSound_Reload, "PlaySound");

	g_szAnim = "reload";
	EF(g_hModel, "SetAnimation", "reload1", 0.01);
}

function UpDateAmmo()
{
	local iSkin = 7 - g_iAmmo;
	EF(g_hModel, "Skin", "" + ValueLimiter(iSkin, 0, 7));
	EF(g_hGun, "SetAmmoAmount", "" + g_iAmmo);
	EF(g_hGun, "SetReserveAmmoAmount", "0");
}

function OnAnimEnd()
{
	local anim = g_szAnim;
	g_szAnim = "";

	switch (anim)
	{
		case "preattack":
		{
			Shoot();
			break;
		}

		case "attack":
		{
			if (g_iAmmo > 0)
			{
				Reload()
			}
			else
			{
				EF(g_hModel, "SetAnimation", "noammo", 0.01);
				EF(g_hModel, "SetDefaultAnimation", "noammo", 0.01);
			}
			break;
		}

		case "reload":
		{
			EF(g_hModel, "Color", "255 255 255");
			UpDateAmmo();
			break;
		}
	}
}

function IsAttack()
{
	if (g_szAnim == "attack" || g_szAnim == "preattack")
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
EF(self, "RunScriptCode", "UpDateAmmo()", 0.05);