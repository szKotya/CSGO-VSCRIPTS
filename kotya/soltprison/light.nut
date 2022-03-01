g_hButtons <- [];
g_bTicking <- false;

g_bDone <- false;

g_hOwner <- null;
g_iCombo_Delay <- [5, 7];
g_iCombo_Len <- 0;
g_hButtons_Combo <- [];
g_hPress_Combo <- [];

function Press() 
{
	if (g_bTicking)
	{
		return;
	}
	g_bDone = false;

	g_hOwner = activator;
	g_bTicking = true;
	g_hButtons_Combo.clear();
	g_hPress_Combo.clear();
	g_iCombo_Len = RandomInt(g_iCombo_Delay[0], g_iCombo_Delay[1]);
	EntFireByHandle(self, "RunScriptCode", "Show();", 1.5, null, null);
}

function Show() 
{
	local hHandle = GetRandomButton();
	g_hButtons_Combo.push(hHandle);
	g_iCombo_Len--;

	EntFireByHandle(hHandle, "Color", "255 255 128", 0, null, null);
	EntFireByHandle(hHandle, "Color", "100 100 100", 0.5, null, null);

	if (g_iCombo_Len > 0)
	{
		EntFireByHandle(self, "RunScriptCode", "Show();", 0.8, null, null);
	}
	else
	{
		g_bTicking = false;
	}
}

function Display() 
{
	for (local i = 0; i < g_hButtons_Combo.len(); i++)
	{
		printl(g_hButtons_Combo[i]);
	}
}

function Press_Light() 
{
	if (g_bTicking || g_hOwner != activator || g_bDone)
	{
		return;
	}

	g_hPress_Combo.push(caller);

	if (g_hButtons_Combo.len() == g_hPress_Combo.len())
	{
		local bRight = true;
		for (local i = 0; i < g_hPress_Combo.len(); i++)
		{
			if (g_hButtons_Combo[i] != g_hPress_Combo[i])
			{
				bRight = false;
				break;
			}
		}

		g_bDone = true;

		if (bRight)
		{
			ScriptPrintMessageChatAll("GOOD");
		}
		else
		{
			ScriptPrintMessageChatAll("BAD");
		}
	}
}

function Init() 
{
	local hHandle = null;
	while ((hHandle = Entities.FindByName(hHandle, "light_button_*")) != null)
	{
		EntFireByHandle(hHandle, "AddOutPut", "OnPressed " + self.GetName() + ":RunScriptCode:Press_Light():0:-1", 0.01, null, null);
		g_hButtons.push(hHandle);
	}
}

function GetRandomButton() 
{
	return g_hButtons[RandomInt(0, g_hButtons.len() - 1)];
}
Init();