g_aColors_Data <- [
	["Красный", Vector(255, 0, 0), null], 
	["Желтый", Vector(255, 255, 0), null],
	["Синий", Vector(0, 0, 255), null],

	["Фиолетовый", Vector(128, 0, 128), [0, 2]],    //Красный + Синий
	["Оранжевый", Vector(255, 128, 0), [0, 1]],     //Красный + Желтый
	["Зеленый", Vector(0, 255, 0), [1, 2]],         //Желтый + Синий

	["Пурпурный", Vector(164, 0, 255), [0, 1, 2]],  //Красный + Желтый + Синий
	["Белый", Vector(255, 255, 255), [0, 2, 5]],    //Красный + Синий + Зеленый
	["Голубой", Vector(0, 192, 255), [2, 7]],       //Синий + Белый

	["Розовый", Vector(255, 193, 203), [7, 0]],     //Красный + Белый 
	["Молочный", Vector(251, 240, 178), [7, 1]],    //Желтый + Белый
	["Коричневый", Vector(150, 75, 0), [0, 5]],     //Красный + Зеленый

	["Черный", Vector(0, 0, 0), [3, 4]],//Фиолетовый + Оранжевый
	["Серый", Vector(128, 128, 128), [7, 12]],//Белый + Черный
	["Болотный", Vector(129, 145, 85), [1, 2, 12]],//Желтый + Синий + Черный   

	["Бордовый", Vector(121, 6, 4), [0, 7, 12]],//Красный + Белый + Черный
];

g_accColors <- [];

g_hGun_0 <- null;
g_hGun_1 <- null;

g_ccColor_bucket_0 <- null;
g_ccColor_bucket_1 <- null;

g_hGun_Parent_0 <- null;
g_hGun_Parent_1 <- null;

g_aCobmo_0 <- [];
g_aCobmo_1 <- [];

g_ccColor_slot_0 <- null;
g_ccColor_slot_1 <- null;

g_hBucket_slot_0 <- null;
g_hBucket_slot_1 <- null;

g_aCobmo_slot_0 <- [];
g_aCobmo_slot_1 <- [];

class class_color
{
	szName = "";
	vecColor = Vector(0, 0, 0);
	combinate = null;

	function GetColorByString()
	{
		return this.vecColor.x + " " + this.vecColor.y + " " + this.vecColor.z;
	}

	function Print()
	{
		printl("-- DATA --");
		printl(this.szName + " - " + this.GetColorByString());
		printl("-- END --");
	}

	function Combinate(array)
	{
		if (this.combinate != null)
		{
			if (array.len() == this.combinate.len())
			{
				local bValid = true;
				foreach(elem_array in array)
				{
					bValid = false;
					foreach(elem_combinate in this.combinate)
					{
						if (elem_array == elem_combinate)
						{
							bValid = true;
							break;
						}
					}
					if (!bValid)
					{
						return false;
					}
				}
				return true;
			}
		}
		return false
	}
}

function Init()
{
	local obj;
	foreach (elem in g_aColors_Data)
	{
		obj = class_color();
		obj.szName = elem[0];
		obj.vecColor = elem[1];
		if (elem[2] != null)
		{
			obj.combinate = [];
			foreach (elem1 in elem[2])
			{
			   obj.combinate.push(g_aColors_Data[elem1]);
			}
		}
		g_accColors.push(obj);
	}

	g_hGun_0 = Entities.FindByName(null, "color_combo_gun_0");
	g_hGun_1 = Entities.FindByName(null, "color_combo_gun_1");

	g_hGun_Parent_0 = Entities.FindByName(null, "color_combo_bucket_0");
	g_hGun_Parent_1 = Entities.FindByName(null, "color_combo_bucket_1");
}

function Toggle(ID)
{
	local owner = activator;
	local gun = GetPistol(owner);
	if (gun == null)
	{
		return;
	}

	if (ID == 0)
	{
		if (g_hBucket_slot_0 == null)
		{
			if (gun == g_hGun_0 && g_hGun_Parent_0 != null)
			{
				g_aCobmo_slot_0 = g_aCobmo_0.slice();
				g_ccColor_slot_0 = g_ccColor_bucket_0;
				g_hBucket_slot_0 = g_hGun_Parent_0;

				g_hGun_Parent_0.ValidateScriptScope();
				EntFireByHandle(g_hGun_Parent_0, "ClearParent", "", 0, null, null);
				EntFireByHandle(g_hGun_Parent_0, "RunScriptCode", "self.SetOrigin(activator.GetOrigin() + Vector(0, 0, 12))", 0.01, caller, caller);

				g_hGun_Parent_0 = null;
			}
			else if (gun == g_hGun_1 && g_hGun_Parent_1 != null)
			{
				g_aCobmo_slot_0 = g_aCobmo_1.slice();
				g_ccColor_slot_0 = g_ccColor_bucket_1;
				g_hBucket_slot_0 = g_hGun_Parent_1;

				g_hGun_Parent_1.ValidateScriptScope();
				EntFireByHandle(g_hGun_Parent_1, "ClearParent", "", 0, null, null);
				EntFireByHandle(g_hGun_Parent_1, "RunScriptCode", "self.SetOrigin(activator.GetOrigin() + Vector(0, 0, 12))", 0.01, caller, caller);
				
				g_hGun_Parent_1 = null;
			}
			else
			{
				return;
			}
			g_ccColor_slot_0 = g_ccColor_bucket_0;
		}
		else
		{
			g_hBucket_slot_0.SetOrigin(owner.GetOrigin() + owner.GetForwardVector() * 31 + owner.GetUpVector() * 32);
			EntFireByHandle(g_hBucket_slot_0, "SetParent", "!activator", 0, gun, gun);
			if (gun == g_hGun_0)
			{
				g_hGun_Parent_0 = g_hBucket_slot_0;
				g_aCobmo_0 = g_aCobmo_slot_0.slice();
				g_ccColor_bucket_0 = g_ccColor_slot_0;
			}
			else
			{
				g_hGun_Parent_1 = g_hBucket_slot_0;
				g_aCobmo_1 = g_aCobmo_slot_0.slice();
				g_ccColor_bucket_1 = g_ccColor_slot_0;
			}
			g_hBucket_slot_0 = null;
			g_aCobmo_slot_0.clear();
			g_ccColor_slot_0 = null;
		}
	}
	else
	{
		if (g_hBucket_slot_1 == null)
		{
			if (gun == g_hGun_0 && g_hGun_Parent_0 != null)
			{
				g_aCobmo_slot_1 = g_aCobmo_0.slice();
				g_ccColor_slot_1 = g_ccColor_bucket_0;
				g_hBucket_slot_1 = g_hGun_Parent_0;

				g_hGun_Parent_0.ValidateScriptScope();
				EntFireByHandle(g_hGun_Parent_0, "ClearParent", "", 0, null, null);
				EntFireByHandle(g_hGun_Parent_0, "RunScriptCode", "self.SetOrigin(activator.GetOrigin() + Vector(0, 0, 12))", 0.01, caller, caller);

				g_hGun_Parent_0 = null;
			}
			else if (gun == g_hGun_1 && g_hGun_Parent_1 != null)
			{
				g_aCobmo_slot_1 = g_aCobmo_1.slice();
				g_ccColor_slot_1 = g_ccColor_bucket_1;
				g_hBucket_slot_1 = g_hGun_Parent_1;

				g_hGun_Parent_1.ValidateScriptScope();
				EntFireByHandle(g_hGun_Parent_1, "ClearParent", "", 0, null, null);
				EntFireByHandle(g_hGun_Parent_1, "RunScriptCode", "self.SetOrigin(activator.GetOrigin() + Vector(0, 0, 12))", 0.01, caller, caller);
				
				g_hGun_Parent_1 = null;
			}
			else
			{
				return;
			}
			g_ccColor_slot_1 = g_ccColor_bucket_0;
		}
		else
		{
			g_hBucket_slot_1.SetOrigin(owner.GetOrigin() + owner.GetForwardVector() * 31 + owner.GetUpVector() * 32);
			EntFireByHandle(g_hBucket_slot_1, "SetParent", "!activator", 0, gun, gun);
			if (gun == g_hGun_0)
			{
				g_hGun_Parent_0 = g_hBucket_slot_1;
				g_aCobmo_0 = g_aCobmo_slot_1.slice();
				g_ccColor_bucket_0 = g_ccColor_slot_1;
			}
			else
			{
				g_hGun_Parent_1 = g_hBucket_slot_1;
				g_aCobmo_1 = g_aCobmo_slot_1.slice();
				g_ccColor_bucket_1 = g_ccColor_slot_1;
			}
			g_hBucket_slot_1 = null;
			g_aCobmo_slot_1.clear();
			g_ccColor_slot_1 = null;
		}
	}
}

function GetPistol(hActivator)
{
	local h;
	while ((h = Entities.FindByClassname(h, "weapon_*")) != null)
	{
		if (h.GetMoveParent() == hActivator && 
		(h == g_hGun_0 || 
		h == g_hGun_1))
		{
			return h;
		}
	}
	return null;
}

function AddColor(i)
{
	if ((g_hBucket_slot_0 == null && g_hBucket_slot_1 == null) || 
	g_hBucket_slot_0 != null && g_hBucket_slot_1 != null)
	{
		return;
	}


	local array;
	local hBucket;

	if (g_hBucket_slot_0 != null)
	{
		array = g_aCobmo_slot_0;
		hBucket = g_hBucket_slot_0;
	}
	else
	{
		array = g_aCobmo_slot_1;
		hBucket = g_hBucket_slot_1;
	}

	array.push(g_aColors_Data[i]);
	if (array.len() == 1)
	{
		hBucket.__KeyValueFromVector("rendercolor", g_aColors_Data[i][1]);
	}
}

function GenerateColor()
{   
	if (g_hBucket_slot_0 == null && g_hBucket_slot_1 == null)
	{
		return;
	}

	local array = [];
	if (g_hBucket_slot_0 != null)
	{
		array.extend(g_aCobmo_slot_0);
	}
	if (g_hBucket_slot_1 != null)
	{
		array.extend(g_aCobmo_slot_1);
	}

	local newColor = Combinate(array);
	if (newColor != -1)
	{
		if (g_hBucket_slot_0 != null && g_hBucket_slot_1 != null)
		{
			g_aCobmo_slot_0.clear();
			g_aCobmo_slot_1.clear();

			g_ccColor_slot_0 = g_accColors[newColor];
			g_ccColor_slot_1 = null;

			g_hBucket_slot_0.__KeyValueFromVector("rendercolor", g_ccColor_slot_0.vecColor);
			g_hBucket_slot_1.__KeyValueFromString("rendercolor", "255 255 255");

			g_aCobmo_slot_0.push(g_aColors_Data[newColor]);
		}
		else if (g_hBucket_slot_0 != null)
		{
			g_aCobmo_slot_0.clear();

			g_ccColor_slot_0 = g_accColors[newColor];

			g_hBucket_slot_0.__KeyValueFromVector("rendercolor", g_ccColor_slot_0.vecColor);

			g_aCobmo_slot_0.push(g_aColors_Data[newColor]);
		}
		else
		{
			g_aCobmo_slot_1.clear();
			g_ccColor_slot_1 = g_accColors[newColor];
			g_hBucket_slot_1.__KeyValueFromVector("rendercolor", g_ccColor_slot_1.vecColor);
			g_aCobmo_slot_1.push(g_aColors_Data[newColor]);
		}
	}
}

function Reset()
{
	g_aCobmo_0.clear();
	g_aCobmo_1.clear();
	g_aCobmo_slot_0.clear();
	g_aCobmo_slot_1.clear();

	g_ccColor_bucket_0 = null;
	g_ccColor_bucket_1 = null;
	g_ccColor_slot_0 = null;
	g_ccColor_slot_1 = null;

	Entities.FindByName(null, "color_combo_bucket_0").__KeyValueFromString("rendercolor", "255 255 255");
	Entities.FindByName(null, "color_combo_bucket_1").__KeyValueFromString("rendercolor", "255 255 255");
}

function Combinate(array)
{
	foreach (index, elem in g_accColors)
	{
		if (elem.Combinate(array))
		{
			local szMessage = "";
			foreach(elem_combinate in array)
			{
				szMessage += elem_combinate[0];
			}
			printl(szMessage + " - " + elem.szName);
			return index;
		}
	}
	printl("NO COMBO");
	return -1;
}

function Print()
{
	foreach (elem in g_accColors)
	{
		elem.Print();
	}
}
Init();