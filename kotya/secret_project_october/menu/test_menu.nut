const TICKRATE = 10.0;
const TICKRATE_REDRAW = 1.0;

::Menu_Script_Handle <- self;
::Menu_Script <- self.GetScriptScope();

::class_menu_item <- class
{
	displayname = "";
	input = null;
	clickcable = true;

	constructor(_input = "", _displayname = "", _clickcable = true)
	{
		this.displayname = _displayname;
		this.input = _input;
		this.clickcable = _clickcable;
	}
	function Use_Input()
	{
		if (this.input != null)
		{
			this.input();
		}
	}
}

::class_menu <- class
{
	items = null;
	function AddItem(_input = null, _displayname = "", _clickcable = true)
	{
		if (this.items == null)
		{
			this.items = [];
		}
		this.items.push(class_menu_item(_input, _displayname, _clickcable));
	}
}

::PLAYERS_MENU <- [];
::g_iMax_Menu_Draws <- 5;
::class_menu_draw <- class
{
	activator = null;
	game_text = null;
	controller = null;

	active_menu = null;
	back_menu = null;

	selectID = 0;

	function constructor(_handle, _active_menu)
	{
		this.activator = _handle;
		this.controller = CreateController(this.activator, Menu_Script_Handle, g_iDefault_GameUIFlags);

		this.game_text = Entities.CreateByClassname("game_text");
		AOP(this.game_text, "spawnflags", 0);
		AOP(this.game_text, "channel", 3);
		AOP(this.game_text, "color", Vector(255, 255, 255));
		AOP(this.game_text, "y", -1.0);
		AOP(this.game_text, "x", 0.0);
		AOP(this.game_text, "holdtime", 5.0);

		this.active_menu = _active_menu;
		this.Draw();
	}

	function Draw()
	{
		local szMessage = "";

		// if (this.active_menu.items.len() > g_iMax_Menu_Draws)
		// {
			for (local i = 0; i < this.active_menu.items.len(); i++)
			{
				if (i == this.selectID)
				{
						szMessage += "> "
				}

				szMessage += this.active_menu.items[i].displayname;

				if (i == this.selectID)
				{
						szMessage += " <"
				}
				szMessage += "\n";
			}
		// }

		this.Display(szMessage);
	}

	function Display(szMessage)
	{
		EntFireByHandle(this.game_text, "SetText", szMessage, 0, this.activator, this.activator);
		EntFireByHandle(this.game_text, "Display", "", 0, this.activator, this.activator);
	}

	function GiveItemID(ID)
	{
		if (ID < 0)
		{
			return this.GiveItemID(this.active_menu.items.len() + ID);
		}
		else if (ID > this.active_menu.items.len() - 1)
		{
			return this.GiveItemID(ID % this.active_menu.items.len());
		}
		else
		{
			return ID;
		}
	}

	function MoveUp()
	{
		for (local i = 0; i < 128; i++)
		{
			this.selectID -= 1;
			if (this.selectID < 0)
			{
				this.selectID += 1;
			}

			if (this.active_menu.items[this.selectID].clickcable)
			{
				break;
			}
		}

		this.Draw();
	}

	function MoveDown()
	{
		for (local i = 0; i < 128; i++)
		{
			this.selectID += 1
			if (this.selectID >= this.active_menu.items.len())
			{
				this.selectID -= 1;
			}

			if (this.active_menu.items[this.selectID].clickcable)
			{
				break;
			}
		}

		this.Draw();
	}

	function Forward()
	{
		this.active_menu.items[this.selectID].Use_Input();
	}
	function Backward()
	{
		if (this.back_menu == null)
		{
			this.SelfClose(true);
		}
	}

	function ExitGameUI()
	{
		this.SelfClose(false);
	}
	function SelfClose(byMenu = true)
	{
		foreach (index, menu_draw_class in PLAYERS_MENU)
		{
			if (this == menu_draw_class)
			{
				if (byMenu)
				{
					if (TargetValid(this.activator))
					{
						if (TargetValid(this.controller.game_ui))
						{
							ScriptPrintMessageChatAll("SelfClose");
							this.controller.press_off = null;
							EF(this.controller.game_ui, "Deactivate");
						}
					}
					EntFire("map_script_controller", "RunScriptCode","PlayerOff()", 0, this.activator);
				}

				if (TargetValid(this.activator))
				{
					this.Display("");
					EF(this.game_text, "Kill");
				}

				return PLAYERS_MENU.remove(index);
			}
		}
	}
}

::DisplayMenuForPlayer <- function(player, menu)
{
	local menu_draw_class = class_menu_draw(player, menu);
	PLAYERS_MENU.push(menu_draw_class);

	menu_draw_class.controller.press_w = Menu_Script.Use_MoveUp;
	menu_draw_class.controller.press_s = Menu_Script.Use_MoveDown;

	menu_draw_class.controller.press_off = Menu_Script.Use_ExitGameUI;

	menu_draw_class.controller.press_attack = Menu_Script.Use_Forward;
	menu_draw_class.controller.press_attack2 = Menu_Script.Use_Backward;

	if (PLAYERS_MENU.len() == 1)
	{
		Menu_Script.Tick();
		Menu_Script.TickDraw()
	}
}

function Tick()
{
	for (local i = 0; i < PLAYERS_MENU.len(); i++)
	{
		if (!TargetValid(PLAYERS_MENU[i].activator))
		{
			if (TargetValid(PLAYERS_MENU[i].game_text))
			{
				PLAYERS_MENU[i].game_text.Destroy();
			}
			if (TargetValid(PLAYERS_MENU[i].controller))
			{
				PLAYERS_MENU[i].game_text.Destroy();
			}

			PLAYERS_MENU.remove(i--);
		}
	}

	if (PLAYERS_MENU.len() > 0)
	{
		CallFunction("Tick()", TICKRATE);
	}
}

function TickDraw()
{
	if (PLAYERS_MENU.len() > 0)
	{
		foreach (menu_draw_class in PLAYERS_MENU)
		{
			if (TargetValid(menu_draw_class.activator))
			{
				menu_draw_class.Draw();
			}
		}

		CallFunction("TickDraw()", TICKRATE_REDRAW);
	}
}

function Use_MoveUp()
{
	local menu_draw_class = GetPlayerMenuClassByPlayer(activator);
	if (menu_draw_class == null)
	{
		return;
	}
	menu_draw_class.MoveUp();
}

function Use_MoveDown()
{
	local menu_draw_class = GetPlayerMenuClassByPlayer(activator);
	if (menu_draw_class == null)
	{
		return;
	}
	menu_draw_class.MoveDown();
}

function Use_ExitGameUI()
{
	local menu_draw_class = GetPlayerMenuClassByPlayer(activator);
	if (menu_draw_class == null)
	{
		return;
	}
	menu_draw_class.ExitGameUI();
}

function Use_Forward()
{
	local menu_draw_class = GetPlayerMenuClassByPlayer(activator);
	if (menu_draw_class == null)
	{
		return;
	}
	menu_draw_class.Forward();
}

function Use_Backward()
{
	local menu_draw_class = GetPlayerMenuClassByPlayer(activator);
	if (menu_draw_class == null)
	{
		return;
	}
	menu_draw_class.Backward();
}

::GetPlayerMenuDrawClassByController <- function(controller)
{
	foreach (menu_draw in PLAYERS_MENU)
	{
		if (controller == menu_draw.controller)
		{
			return menu_draw;
		}
	}

	return null;
}

::GetPlayerMenuDrawClassByGameUI <- function(game_ui)
{
	foreach (menu_draw in PLAYERS_MENU)
	{
		if (game_ui == menu_draw.controller.game_ui)
		{
			return menu_draw;
		}
	}

	return null;
}

::GetPlayerMenuDrawClassByGameText <- function(game_text)
{
	foreach (menu_draw in PLAYERS_MENU)
	{
		if (game_text == menu_draw.game_text)
		{
			return menu_draw;
		}
	}

	return null;
}

::GetPlayerMenuClassByPlayer <- function(handle)
{
	foreach (menu_draw in PLAYERS_MENU)
	{
		if (handle == menu_draw.activator)
		{
			return menu_draw;
		}
	}

	return null;
}