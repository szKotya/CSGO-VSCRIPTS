const TICKRATE = 10.0;

::Menu_Controller_Script <- self.GetScriptScope();

::PLAYERS_MENU_CONTOLLER <- [];

class class_menu_controller
{
	handle = null;
	menu = null;
	game_ui = null;

	constructor(_handle, menu)
	{
		this.handle = _handle;
		this.game_ui = Entities.CreateByClassname("game_ui");

		AOP(this.game_ui, "spawnflags", 480);
		AOP(this.game_ui, "PressedAttack", "map_script_menu_controller:RunScriptCode:PressedAttack():0:-1", 0.01);
		AOP(this.game_ui, "PressedAttack2", "map_script_menu_controller:RunScriptCode:PressedAttack2():0:-1", 0.01);

		AOP(this.game_ui, "PressedForward", "map_script_menu_controller:RunScriptCode:PressedForward():0:-1", 0.01);
		AOP(this.game_ui, "PressedBack", "map_script_menu_controller:RunScriptCode:PressedBack():0:-1", 0.01);
		AOP(this.game_ui, "PressedMoveLeft", "map_script_menu_controller:RunScriptCode:PressedMoveLeft():0:-1", 0.01);
		AOP(this.game_ui, "PressedMoveRight", "map_script_menu_controller:RunScriptCode:PressedMoveRight():0:-1", 0.01);

		AOP(this.game_ui, "PlayerOff", "map_script_menu_controller:RunScriptCode:PlayerOff():0:-1", 0.01);
		AOP(this.game_ui, "PlayerOn", "map_script_menu_controller:RunScriptCode:PlayerOn():0:-1", 0.01);
		
		EntFireByHandle(this.game_ui, "Activate", "", 0.02, this.handle, this.handle);
	}
	function PressedAttack()
	{
		return this.menu.PressedAttack()
	}
	function PressedAttack2()
	{
		return this.menu.PressedAttack2()
	}
	function PressedForward()
	{
		return this.menu.PressedForward()
	}
	function PressedBack()
	{
		return this.menu.PressedBack()
	}
	function PressedMoveLeft()
	{
		return this.menu.PressedMoveLeft()
	}
	function PressedMoveRight()
	{
		return this.menu.PressedMoveRight()
	}
	function PlayerOff()
	{
		return this.menu.PlayerOff()
	}
	function PlayerOn()
	{
		return this.menu.PlayerOn()
	}
}

{
	function PressedAttack()
	{
		local menu_controller_class = GetPlayerMenuControllerClassByPlayer(activator);
		if (menu_controller_class == null)
		{
			return;
		}
		menu_controller_class.PressedAttack();
	}

	function PressedAttack2()
	{
		local menu_controller_class = GetPlayerMenuControllerClassByPlayer(activator);
		if (menu_controller_class == null)
		{
			return;
		}
		menu_controller_class.PressedAttack2();
	}

	function PressedForward()
	{
		local menu_controller_class = GetPlayerMenuControllerClassByPlayer(activator);
		if (menu_controller_class == null)
		{
			return;
		}
		menu_controller_class.PressedForward();
	}

	function PressedBack()
	{
		local menu_controller_class = GetPlayerMenuControllerClassByPlayer(activator);
		if (menu_controller_class == null)
		{
			return;
		}
		menu_controller_class.PressedBack();
	}

	function PressedMoveLeft()
	{
		local menu_controller_class = GetPlayerMenuControllerClassByPlayer(activator);
		if (menu_controller_class == null)
		{
			return;
		}
		menu_controller_class.PressedMoveLeft();
	}

	function PressedMoveRight()
	{
		local menu_controller_class = GetPlayerMenuControllerClassByPlayer(activator);
		if (menu_controller_class == null)
		{
			return;
		}
		menu_controller_class.PressedMoveRight();
	}

	function PlayerOn()
	{
		local menu_controller_class = GetPlayerMenuControllerClassByPlayer(activator);
		if (menu_controller_class == null)
		{
			return;
		}
		menu_controller_class.PlayerOn();
	}

	function PlayerOff()
	{
		foreach (index, menu_controller in PLAYERS_MENU_CONTOLLER)
		{
			if (menu_controller.handle == activator)
			{
				menu_controller_class.PlayerOff();

				if (TargerValid(PLAYERS_MENU_CONTOLLER.game_ui))
				{
					PLAYERS_MENU_CONTOLLER.game_ui.Destroy();
				}
				PLAYERS_MENU_CONTOLLER.remove(index);
				break;
			}
		}
	}
}

::CreateMenuController <- function(player, menu)
{
	PLAYERS_MENU_CONTOLLER.push(class_menu_controller(player, menu));
	if (PLAYERS_MENU_CONTOLLER.len() == 1)
	{
		Tick();
	}
}

::GetPlayerMenuControllerClassByGameUI <- function(game_ui)
{
	foreach (menu_controller in PLAYERS_MENU_CONTOLLER)
	{
		if (game_ui == menu_controller.game_ui)
		{
			return menu_controller;
		}
	}

	return null;
}

::GetPlayerMenuControllerClassByPlayer <- function(handle)
{
	foreach (menu_controller in PLAYERS_MENU_CONTOLLER)
	{
		if (handle == menu_controller.handle)
		{
			return menu_controller;
		}
	}
	
	return null;
}

function Tick() 
{
	for (local i = 0; i < PLAYERS_MENU_CONTOLLER.len(); i++)
	{
		if (!TargerValid(PLAYERS_MENU_CONTOLLER[i].handle))
		{
			if (TargerValid(PLAYERS_MENU_CONTOLLER.game_ui))
			{
				PLAYERS_MENU_CONTOLLER.game_ui.Destroy();
			}
			
			PLAYERS_MENU_CONTOLLER.remove(i);
			i--;
		}
	}

	if (PLAYERS_MENU_CONTOLLER.len() > 0)
	{
		CallFunction("Tick()", TICKRATE);
	}
}