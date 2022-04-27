const TICKRATE = 0.2;
g_iHP <- 0;

g_iHP_HEAD <- 0;
g_iHP_CHEST <- 0;
g_iHP_LOW <- 0;
g_iHP_HANDS <- 0;

g_iHP_Init <- 0;
g_iHP_Bars <- 16;


g_hModel <- self;
/*
	HP
*/
{
	function SetHP(i, itype)
	{
		
	}
}
/*
	
*/
{
	function Start()
	{
		local kv = {};
		kv["pos"] <- class_pos(Vector(0, 0, 100));
		kv["model"] <- "models/microrost/cosmov6/ff7r/airbuster.mdl";
		kv["solid"] <- 0;
		kv["angles"] <- "-90 270 0";
		kv["glowenabled"] <- 0;

		g_hModel = Prop_dynamic_Glow_Maker.CreateEntity(kv);
	}

	function A()
	{

	}
}

function RotateModel(iRadian = 360, iTimeStart = 0, iTimeEnd = 1, iSide = RandomInt(0, 1))
{
	if(iSide == 0)
	{
		iSide = -1;
	}

	local iAng = 0.5
	local iTicks = iRadian / iAng;
	local iTime = (iTimeEnd - iTimeStart) / iTicks;

	for(local i = 0; i < iTicks; i++)
	{
		CallFunction("SetRotate(" + (iAng * iSide) + ")", iTimeStart + (i * iTime));
	}
}

function SetDownModel(fDelay)
{
	for(local i = 1; i < 76; i++)
	{
		CallFunction("SetZ(" + (-i * 0.02) + ")", (i * 0.01));
		CallFunction("SetZ(" + (i * 0.02) + ")", fDelay + (i * 0.05));
	}
}

function SetZ(i)
{
	g_hModel.SetOrigin(g_hModel.GetOrigin() + Vector(0, 0, i));
}

function SetRotate(i)
{
	local vecAng = g_hModel.GetAngles();
	g_hModel.SetAngles(vecAng.x, vecAng.y, vecAng.z + i);
}

function SetAnimation(szAnim, fDelay = 0.00)
{
	EF(g_hModel, "SetAnimation", szAnim, fDelay);
}

function SetDefaultAnimation(szAnim, fDelay = 0.01)
{
	EF(g_hModel, "SetDefaultAnimation", szAnim, fDelay);
}

function SetPlaybackRate(fRate = 1.00, fDelay = 0.01)
{
	EF(g_hModel, "SetPlaybackRate", "" + fRate, fDelay);
}

function GetAttachmentOriginByName(szName)
{
	return g_hModel.GetAttachmentOrigin(g_hModel.LookupAttachment(szName));
}
function GetAttachmentAnglesByName(szName)
{
	return g_hModel.GetAttachmentAngles(g_hModel.LookupAttachment(szName));
}



function test1()
{
	local kv = {};
	local temp = class_pos(activator.GetOrigin() + (activator.GetForwardVector() * 20) + Vector(0, 0, 45));
	kv["pos"] <- temp;
	kv["rendermode"] <- 5;
	kv["model"] <- "sprites/640_pain_up.vmt";
	local g_hSprite = Sprite_Maker.CreateEntity(kv);

	EF(g_hSprite, "ShowSprite");
	EntFireByHandle(g_hSprite, "SetParent", "!activator", 0, activator, activator);
}

function Cast_Rocket()
{
	SetAnimation("attack_missle");
	CallFunction("Cast_Rocket_Next()", 1.2);
}

function Cast_Rocket_Next()
{
	local pos_class;
	for (local i = 0; i < g_aszRockets_Attach_L.len(); i++)
	{
		pos_class = class_pos(GetAttachmentOriginByName(g_aszRockets_Attach_L[i]), Vector(-90, 0, 0));
		CallFunction("CreateRocket(Vector(" + pos_class.ox + ","+ pos_class.oy + ", " + pos_class.oz + "),Vector(-" + pos_class.ax + ",-"+ pos_class.ay + ", " + pos_class.az + "))", 0.16 * i);
	}

	for (local i = 0; i < g_aszRockets_Attach_R.len(); i++)
	{
		pos_class = class_pos(GetAttachmentOriginByName(g_aszRockets_Attach_R[i]), Vector(-90, 0, 0));
		CallFunction("CreateRocket(Vector(" + pos_class.ox + ","+ pos_class.oy + ", " + pos_class.oz + "),Vector(-" + pos_class.ax + ",-"+ pos_class.ay + ", " + pos_class.az + "))", 0.16 * i);
	}
}

function CreateRocket(origin, angles)
{
	local temp = class_pos(origin, angles);
	local temp1;

	local kv = {};
	kv["pos"] <- temp;
	kv["notsolid"] <- 1;
	kv["disableshadows"] <- 1;
	kv["spawnflags"] <- 62465;
	kv["vscripts"] <- "kotya/cosmov6_final/boss/airbuster/rocket.nut";
	// kv["rendermode"] <- 10;
	temp1 = Physbox_Maker.CreateEntity(kv);

	kv = {};
	kv["pos"] <- temp;
	kv["model"] <- "models/props/de_inferno/hr_i/missile/missile_02.mdl";
	kv["solid"] <- 0;
	kv["parentname"] <- temp1.GetName();
	kv["glowenabled"] <- 0;
	kv["angles"] <- "0 270 90";
	Prop_dynamic_Glow_Maker.CreateEntity(kv);
}

g_aszRockets_Attach_R <- [
"R_VFXMuzzleD_a",
"R_VFXMuzzleE_a",
"R_VFXMuzzleF_a",
"R_VFXMuzzleG_a",
"R_VFXMuzzleH_a",
"R_VFXMuzzleI_a",
"R_VFXMuzzleJ_a",
"R_VFXMuzzleK_a",
"R_VFXMuzzleL_a",
"R_VFXMuzzleM_a",
"R_VFXMuzzleN_a",
"R_VFXMuzzleO_a"];

g_aszRockets_Attach_L <- [
"L_VFXMuzzleD_a",
"L_VFXMuzzleE_a",
"L_VFXMuzzleF_a",
"L_VFXMuzzleG_a",
"L_VFXMuzzleH_a",
"L_VFXMuzzleI_a",
"L_VFXMuzzleJ_a",
"L_VFXMuzzleK_a",
"L_VFXMuzzleL_a",
"L_VFXMuzzleM_a",
"L_VFXMuzzleN_a",
"L_VFXMuzzleO_a"];
