// EntityGroup[0] //cp03_quest01_prop00
// EntityGroup[1] //cp03_quest01_prop01
// EntityGroup[2] //cp03_quest01_prop02
// EntityGroup[3] //cp03_quest01_prop03

// EntityGroup[4] //BRUSH2
// EntityGroup[5] //BRUSH3
// EntityGroup[6] //BRUSH4
const TICKRATE = 0.25;
g_fTick <- 0.00;

::cp03_quest_01 <- self.GetScriptScope();

PROPANS <- [];
class class_propan_balon
{
	owner = null;
	take = false;

	item_button = null;
	item_model = null;
	model = null;

	init = true;

	complete = false;

	veclastpos = Vector();

	constructor(_model, _item_button)
	{
		this.item_button = _item_button;
		this.item_model = _item_button.GetMoveParent();
		this.model = _model;
	}

	function SetLastPos(_vec)
	{
		this.veclastpos = _vec;
	}

	function SetOwner(_owner)
	{
		this.owner = _owner;
		this.take = true;

		if (this.init)
		{
			this.init = false;
			// AOP(this.item_model, "glowdist", 99999);
			// AOP(this.item_model, "glowstyle", 0);
		}

		EF(this.item_button, "Lock");
		EF(this.item_model, "SetGlowDisabled");
		this.item_model.SetOrigin(g_vecVpizde);

		this.veclastpos = this.owner.GetCenter() + Vector(0, 0, 16);
	}

	function Init(_vec)
	{
		this.item_model.SetOrigin(_vec);

		EF(this.item_model, "SetGlowEnabled");
		EF(this.item_button, "UnLock");
	}

	function RemoveOwner()
	{
		this.owner = null;
		this.take = false;

		EF(this.item_model, "SetGlowEnabled");
		EF(this.item_button, "UnLock");
		this.item_model.SetOrigin(this.veclastpos);
	}

	function IsComplete()
	{
		return this.complete;
	}

	function IsTake()
	{
		return this.take;
	}

	function GetOwner()
	{
		return this.owner;
	}

	function Complete()
	{
		this.complete = true;

		EF(this.item_button, "Kill");
		EF(this.item_model, "Kill");

		AOP(this.model, "rendermode", 0);
		EF(this.model, "SetGlowDisabled");
	}
}

g_bInit <- true;

function Init(array)
{
	local obj;

	obj = class_propan_balon(EntityGroup[0], EntityGroup[4]);
	PROPANS.push(obj);

	obj = class_propan_balon(EntityGroup[1], EntityGroup[5]);
	PROPANS.push(obj);

	obj = class_propan_balon(EntityGroup[2], EntityGroup[6]);
	PROPANS.push(obj);

	obj = class_propan_balon(EntityGroup[3], EntityGroup[7]);
	PROPANS.push(obj);

	foreach(index, propan_balon_class in PROPANS)
	{
		propan_balon_class.Init(array[index]);
		DebugDrawCircle(array[index], 160, 32, 60);
	}
}

function Touch_Trigger()
{
	foreach (index, propan_balon_class in PROPANS)
	{
		if (propan_balon_class.owner == activator)
		{
			propan_balon_class.Complete();
			RemoveBackPackByOwner(propan_balon_class.GetOwner());
			SetSpeed(propan_balon_class.GetOwner(), 0.3);
			PROPANS.remove(index);
			break;
		}
	}

	CompleteAll();
}

function Tick()
{
	if (g_fTick > Time())
	{
		return;
	}
	g_fTick = Time() + TICKRATE;
	foreach (propan_balon in PROPANS)
	{
		if (!propan_balon.IsTake())
		{
			continue;
		}
		if (!TargetValid(propan_balon.GetOwner()) ||
		propan_balon.GetOwner().GetHealth() < 1 ||
		propan_balon.GetOwner().GetTeam() != 3)
		{
			RemoveOwner(propan_balon);
			continue;
		}
		propan_balon.SetLastPos(propan_balon.GetOwner().GetOrigin() + Vector (0, 0, 16));
	}
}

function SetOwner()
{
	if (activator.GetTeam() != 3)
	{
		return;
	}

	local propan_balon_class = GetPropanBalonClassByOwner(activator);
	if (propan_balon_class != null)
	{
		return;
	}

	propan_balon_class = GetPropanBalonClassByButton(caller);
	if (propan_balon_class == null)
	{
		return;
	}
	// printl("SetOwner 3");
	propan_balon_class.SetOwner(activator);

	if (g_bInit)
	{
		// Main_Script.Trigger_Quest_01_CP03_PickUp();

		g_bInit = false;

		g_ahGlobal_Tick.push(self);
	}
	CreateBackPack(activator);
	SetSpeed(activator, -0.3);
}

function RemoveOwner(propan_balon_class)
{
	RemoveBackPackByOwner(propan_balon_class.GetOwner());
	propan_balon_class.RemoveOwner();
}

function GetPropanBalonClassByButton(_button)
{
	foreach (propan_balon in PROPANS)
	{
		if (propan_balon.item_button == _button)
		{
			return propan_balon;
		}
	}
	return null;
}

function CompleteAll()
{
	foreach (propan_balon in PROPANS)
	{
		if (!propan_balon.IsComplete())
		{
			return;
		}
	}

	Main_Script.Trigger_Chapter3_02();

	EF(self, "Kill");
}

function GetPropanBalonClassByOwner(_owner)
{
	foreach (index, propan_balon in PROPANS)
	{
		if (propan_balon.owner == _owner)
		{
			return propan_balon;
		}
	}
	return null;
}