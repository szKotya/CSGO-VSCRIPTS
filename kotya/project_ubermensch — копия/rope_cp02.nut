
g_vecStart <- Vector(2861, -1031, 1732) + Vector(0, -16, 40);
g_vecEnd <- Vector(2861, -1031, 232) + Vector(0, -16, 0);

g_vecForward <- Vector(0, 1, 0);

::path_01 <- self.GetScriptScope();

const TICKRATE = 0.05;
g_fTick <- 0.00;

const RESET_TIME = 2.0;
const DOWN_TIME = 5.0;

g_hOwners <- [];
g_hIgnore <- [];

g_bDestroy <- false;
g_bInit <- false;

function Init()
{
	if (g_bInit)
	{
		return;
	}
	g_bInit = true;
	g_ahGlobal_Tick.push(self);
}

function Tick()
{
	if (g_fTick > Time())
	{
		return;
	}

	g_fTick = Time() + TICKRATE;

	Tick_Move();
}

function Connect()
{
	if (g_bDestroy)
	{
		return;
	}

	if (GetIndexByOwner(activator))
	{
		return;
	}

	local human_owner_class = GetHumanOwnerClassByOwner(activator);
	if (human_owner_class == null)
	{
		return;
	}

	activator.SetVelocity(Vector(0, 0, -20));
	activator.SetOrigin(g_vecStart);
	activator.SetForwardVector(g_vecForward);

	human_owner_class.Freeze();

	g_hOwners.push([activator, human_owner_class, Time() - 0.001, activator.GetOrigin()]);
}

function Tick_Move()
{
	local handle;
	local proccent;
	local human_owner_class;
	local vec1;
	local vec2;

	foreach (index, owner in g_hOwners)
	{
		handle = owner[0];
		if (!handle.IsValid())
		{
			g_hOwners.remove(index);
			continue;
		}

		human_owner_class = owner[1];

		if (handle.GetTeam() != 3 ||
		handle.GetHealth() < 1)
		{
			human_owner_class.UnFreeze();
			g_hOwners.remove(index);
			continue;
		}

		vec1 = g_vecEnd;
		vec2 = LerpTime(owner[3], g_vecEnd, DOWN_TIME, Time() - owner[2]);

		if (vec1.z == vec2.z)
		{
			human_owner_class.UnFreeze();

			handle.SetVelocity(Vector(0, 0, 280));
			handle.SetOrigin(g_vecEnd + Vector(0, 0, -15));

			g_hIgnore.push([handle, Time() + RESET_TIME]);

			g_hOwners.remove(index);
			continue;
		}

		handle.SetOrigin(vec2);
	}
}

function GetIndexByOwner(_owner)
{
	foreach (value in g_hIgnore)
	{
		if (value[0] == _owner)
		{
			// return true;
			if (value[1] > Time())
			{
				return true;
			}
		}
	}

	foreach (index, value in g_hOwners)
	{
		if (value[0] == _owner)
		{
			return true;
		}
	}
	return false;
}

function Destroy()
{
	g_bDestroy = true;

	local handle;
	local human_owner_class;

	foreach (index, owner in g_hOwners)
	{
		local handle = owner[0];
		if (!handle.IsValid())
		{
			continue;
		}
		human_owner_class = owner[1];
		if (handle.GetHealth() < 1)
		{
			continue;
		}
		human_owner_class.UnFreeze();
	}
	EF(self, "Kill");
}