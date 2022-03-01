g_aSide <- [
	["Север", 270],
	["Северо-Восток", 225],
	["Восток", 180],
	["Юго-Восток", 135],
	["Юг", 90],
	["Юго-Запад", 45],
	["Запад", 0],
	["Северо-Запад", 315],
];

g_aLockat <-
[
	[-1, 135, 90, 45],
	[315, -1, 45, 0],
	[270, 225, -1, 315],
	[225, 180, 135, -1],   
]

g_aColor <- [
	["Красная", "255 0 0"],
	["Зеленая", "0 255 0"],
	["Синяя", "0 0 255"],
	["Желтая", "255 255 0"],
];

class class_statue
{
	hRotate = null;
	szColor = "";
	iNumber = 0;
}

g_hLast <- null;
g_hOwner <- null;
g_bDone <- false;

g_hGameUI <- Entities.CreateByClassname("game_ui");
g_hGameUI.__KeyValueFromInt("spawnflags", 480);
g_hGameUI.__KeyValueFromFloat("FieldOfView", -1.0);

EntFireByHandle(g_hGameUI, "AddOutPut", "PressedMoveLeft " + self.GetName() + ":RunScriptCode:Rotate(true):0:-1", 0.01, null, null);
EntFireByHandle(g_hGameUI, "AddOutPut", "PressedMoveRight " + self.GetName() + ":RunScriptCode:Rotate(false):0:-1", 0.01, null, null);

g_aStatue <- [];
g_aStatue_Need <- [];

g_iActive <- null;
g_bRotate <- false;

function Init() 
{
	local index = [1, 2, 3, 4];
	local obj;
	for (local i = 0, k; i < 4; i++)
	{
		obj = class_statue();
		obj.hRotate = Entities.FindByName(null, "statue_rotate_" + i);

		local iRvalue = ((g_aColor.len() > 1) ? (RandomInt(0, g_aColor.len() - 1)) : (0));
		obj.szColor = g_aColor[iRvalue][0];
		Entities.FindByName(null, "statue_model_" + i).__KeyValueFromString("rendercolor", g_aColor[iRvalue][1]);
		g_aColor.remove(iRvalue);
		
		k = RandomInt(0, index.len() - 1);
		obj.iNumber = index[k];
		Entities.FindByName(null, "statue_num_" + i).__KeyValueFromInt("message", index[k]);
		index.remove(k);

		g_aStatue.push(obj);
		EntFireByHandle(Entities.FindByName(null, "statue_button_" + i), "AddOutPut", "OnPressed " + self.GetName() + ":RunScriptCode:Press_Vent(" + i + "):0:-1", 0.01, null, null);
	}
}

function Press() 
{
	if (g_bRotate)
	{
		return;
	}

	g_bDone = false;
	local irandom = [0, 1, 2, 3];
	local message_a = [];

	local iquest = irandom.slice();
	g_aStatue_Need = irandom.slice();

	for (local j = 0, k; j < g_aStatue.len(); j++)
	{
		k = RandomInt(0, irandom.len() - 1);

		iquest.insert(j, irandom[k]);

		g_aStatue[j].hRotate.SetAngles(0, g_aSide[RandomInt(0, g_aSide.len() - 1)][1], 0);
		local iAng = 0;
		switch (irandom[k])
		{
			case 0:
			{
				local a = RandomInt(0, g_aSide.len() - 1);
				message_a.push( ((RandomInt(0, 2)) ? 
					g_aSide[j * 2][0] : 
					((RandomInt(0, 1)) ?
					g_aStatue[j].szColor :
					g_aStatue[j].iNumber)) + 
					" статуя устремил свой взгляд на " + 
					g_aSide[a][0] +
					".");
				iAng = g_aSide[a][1];
				break;
			}
			case 1:
			{
				local a;
				while ((a = (RandomInt(0, g_aStatue.len() - 1))) == j){};
				message_a.push( ((RandomInt(0, 2)) ? 
					g_aSide[j * 2][0] : 
					((RandomInt(0, 1)) ?
					g_aStatue[j].szColor :
					g_aStatue[j].iNumber)) + 
					" статуя следит за " + 
					((RandomInt(0, 2)) ? 
					g_aSide[a * 2][0] : 
					((RandomInt(0, 1)) ?
					g_aStatue[a].szColor :
					g_aStatue[a].iNumber)) + 
					" статуей.");
				iAng = g_aLockat[j][a];
				break;
			}
			case 2:
			{
				message_a.push(((RandomInt(0, 2)) ? 
					g_aSide[j * 2][0] : 
					((RandomInt(0, 1)) ?
					g_aStatue[j].szColor :
					g_aStatue[j].iNumber)) + 
					" статуя отвернулась от всех.");
				iAng = g_aSide[j * 2][1];
				break;
			}
			case 3:
			{
				message_a.push(((RandomInt(0, 2)) ? 
					g_aSide[j * 2][0] : 
					((RandomInt(0, 1)) ?
					g_aStatue[j].szColor :
					g_aStatue[j].iNumber)) + 
					" статуя всегда недвижима.");
				iAng = g_aStatue[j].hRotate.GetAngles().y;
				break;
			}
		}

		irandom.remove(k);
		g_aStatue_Need.insert(j, iAng);
	}

	for (local i = 0, k; i < message_a.len(); i++)
	{
		if (iquest[i] != 3)
		{
			k = g_aStatue[i].hRotate.GetAngles().y;
			while (k == g_aStatue_Need[i])
			{
				k = g_aSide[RandomInt(0, g_aSide.len() - 1)][1];
			}
			g_aStatue[i].hRotate.SetAngles(0, k, 0);
		}
	}
	
	for (local i = 0, k, j = message_a.len(); i < j; i++)
	{
		k = RandomInt(0, message_a.len() - 1);
		ScriptPrintMessageChatAll(message_a[k]);
		message_a.remove(k);
	}

	/*
		(1)(2) устремил свой взгляд на (1)(2)(3)
		(1)(2) следит за (1)(2)(3) 

		(1)(2) всегда недвижим

		(1)(2) отвернулась от всех
	*/
}

function Press_Vent(ID) 
{
	if (g_bRotate || g_bDone)
	{
		return;
	}

	g_iActive = ID;
	g_hOwner = activator;
	EntFireByHandle(g_hGameUI, "Activate", "", 0.05, g_hOwner, g_hOwner);
}

function Rotate(bSide) 
{
	if (g_bRotate || g_iActive == null || g_bDone)
	{
		return;
	}

	g_bRotate = true;
	EntFireByHandle(g_aStatue[g_iActive].hRotate, ((bSide) ? "StartForWard" : "StartBackWard"), "", 0.00, null, null);
	EntFireByHandle(self, "RunScriptCode", "RotateEnd()", 1.00, null, null);
}

function RotateEnd() 
{
	g_bRotate = false;

	EntFireByHandle(g_aStatue[g_iActive].hRotate, "Stop", "", 0.00, null, null);

	local iAng = g_aStatue[g_iActive].hRotate.GetAngles().y;
	if (iAng < 0)
	{
		iAng = 315;
	}
	else
	{
		iAng += 0.5;
	}
	iAng = iAng.tointeger() % 360;
	g_aStatue[g_iActive].hRotate.SetAngles(0, iAng, 0);
	if (Check())
	{
		g_bDone = true;
		EntFireByHandle(g_hGameUI, "DeActivate", "", 0.05, g_hOwner, g_hOwner);
		ScriptPrintMessageChatAll("GOOD");
	}
}

function Check() 
{
	if (g_aStatue_Need.len() > 0)
	{
		for (local i = 0; i < g_aStatue.len(); i++)
		{
			if (g_aStatue[i].hRotate.GetAngles().y != g_aStatue_Need[i])
			{
				return false;
			}
		}
		return true;
	}
	return false;
}

Init();