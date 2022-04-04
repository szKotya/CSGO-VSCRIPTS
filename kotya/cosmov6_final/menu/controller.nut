const TICKRATE = 10.0;

enum GameUI_Flags
{
	NONE = 0,
	FREEZE_PLAYER = 32,
	HIDE_WEAPON = 64,
	USE_DEACTIVATE = 128,
	JUMP_DEACTIVATE = 256,
}

::g_iDefault_GameUIFlags <- GameUI_Flags.FREEZE_PLAYER + GameUI_Flags.HIDE_WEAPON + GameUI_Flags.USE_DEACTIVATE + GameUI_Flags.JUMP_DEACTIVATE;
::g_iItem_GameUIFlags <- GameUI_Flags.NONE;

::Controller_Script <- self.GetScriptScope();

::PLAYERS_CONTROLLERS <- [];

::class_controller <- class
{
	controller_caller = null;
	activator = null;
	game_ui = null;
	
	press_attack = null;
	press_attack2= null;

	press_w = null;
	press_s = null;
	press_a = null;
	press_d = null;

	unpress_attack = null;
	unpress_attack2= null;

	unpress_w = null;
	unpress_s = null;
	unpress_a = null;
	unpress_d = null;

	press_on = null;
	press_off = null;

	constructor(_handle, _controller_caller, _iFlags)
	{
		this.controller_caller = _controller_caller;
		this.activator = _handle;
		
		local kv = {};
		kv["spawnflags"] <- _iFlags;
		this.game_ui = GameUI_Maker.CreateEntity(kv);

		AOP(this.game_ui, "PressedAttack", "map_script_controller:RunScriptCode:PressedAttack():0:-1", 0.01);
		AOP(this.game_ui, "PressedAttack2", "map_script_controller:RunScriptCode:PressedAttack2():0:-1", 0.01);

		AOP(this.game_ui, "PressedForward", "map_script_controller:RunScriptCode:PressedForward():0:-1", 0.01);
		AOP(this.game_ui, "PressedBack", "map_script_controller:RunScriptCode:PressedBack():0:-1", 0.01);
		AOP(this.game_ui, "PressedMoveLeft", "map_script_controller:RunScriptCode:PressedMoveLeft():0:-1", 0.01);
		AOP(this.game_ui, "PressedMoveRight", "map_script_controller:RunScriptCode:PressedMoveRight():0:-1", 0.01);

		AOP(this.game_ui, "UnPressedAttack", "map_script_controller:RunScriptCode:UnPressedAttack():0:-1", 0.01);
		AOP(this.game_ui, "UnPressedAttack2", "map_script_controller:RunScriptCode:UnPressedAttack2():0:-1", 0.01);

		AOP(this.game_ui, "UnPressedForward", "map_script_controller:RunScriptCode:UnPressedForward():0:-1", 0.01);
		AOP(this.game_ui, "UnPressedBack", "map_script_controller:RunScriptCode:UnPressedBack():0:-1", 0.01);
		AOP(this.game_ui, "UnPressedMoveLeft", "map_script_controller:RunScriptCode:UnPressedMoveLeft():0:-1", 0.01);
		AOP(this.game_ui, "UnPressedMoveRight", "map_script_controller:RunScriptCode:UnPressedMoveRight():0:-1", 0.01);

		AOP(this.game_ui, "PlayerOff", "map_script_controller:RunScriptCode:PlayerOff():0:-1", 0.01);
		AOP(this.game_ui, "PlayerOn", "map_script_controller:RunScriptCode:PlayerOn():0:-1", 0.01);
		
		EntFireByHandle(this.game_ui, "Activate", "", 0.02, this.activator, this.activator);
	}

	function Use_Attack()
	{
		if (this.press_attack != null)
		{
			this.press_attack();
		}
	}
	function Use_Attack2()
	{
		if (this.press_attack2 != null)
		{
			this.press_attack2();
		}
	}
	function Use_W()
	{
		if (this.press_w != null)
		{
			this.press_w();
		}
	}
	function Use_S()
	{
		if (this.press_s != null)
		{
			this.press_s();
		}
	}
	function Use_A()
	{
		if (this.press_a != null)
		{
			this.press_a();
		}
	}
	function Use_D()
	{
		if (this.press_d != null)
		{
			this.press_d();
		}
	}
	function Use_UnAttack()
	{
		if (this.unpress_attack != null)
		{
			this.unpress_attack();
		}
	}
	function Use_UnAttack2()
	{
		if (this.unpress_attack2 != null)
		{
			this.unpress_attack2();
		}
	}
	function Use_UnW()
	{
		if (this.unpress_w != null)
		{
			this.unpress_w();
		}
	}
	function Use_UnS()
	{
		if (this.unpress_s != null)
		{
			this.unpress_s();
		}
	}
	function Use_UnA()
	{
		if (this.unpress_a != null)
		{
			this.unpress_a();
		}
	}
	function Use_UnD()
	{
		if (this.unpress_d != null)
		{
			this.unpress_d();
		}
	}
	function Use_On()
	{
		if (this.press_on != null)
		{
			this.press_on();
		}
	}
	function Use_Off()
	{
		if (this.press_off != null)
		{
			this.press_off();
		}
	}
}

{
	function PressedAttack()
	{
		printl("PressedAttack");

		local controller_class = GetControllerClassByPlayer(activator);
		if (controller_class == null)
		{
			return;
		}
		controller_class.Use_Attack();
	}

	function PressedAttack2()
	{
		printl("PressedAttack2");
		
		local controller_class = GetControllerClassByPlayer(activator);
		if (controller_class == null)
		{
			return;
		}
		printl("caller" + controller_class.controller_caller);
		controller_class.Use_Attack2();
	}

	function PressedForward()
	{
		printl("PressedForward");
		
		local controller_class = GetControllerClassByPlayer(activator);
		if (controller_class == null)
		{
			return;
		}
		controller_class.Use_W();
	}

	function PressedBack()
	{
		printl("PressedBack");
		
		local controller_class = GetControllerClassByPlayer(activator);
		if (controller_class == null)
		{
			return;
		}
		controller_class.Use_S();
	}

	function PressedMoveLeft()
	{
		printl("PressedMoveLeft");
		
		local controller_class = GetControllerClassByPlayer(activator);
		if (controller_class == null)
		{
			return;
		}
		controller_class.Use_A();
	}

	function PressedMoveRight()
	{
		printl("PressedMoveRight");
		
		local controller_class = GetControllerClassByPlayer(activator);
		if (controller_class == null)
		{
			return;
		}
		controller_class.Use_D();
	}

	function UnPressedAttack()
	{
		printl("UnPressedAttack");
		
		local controller_class = GetControllerClassByPlayer(activator);
		if (controller_class == null)
		{
			return;
		}
		controller_class.Use_UnAttack();
	}

	function UnPressedAttack2()
	{
		printl("UnPressedAttack2");
		
		local controller_class = GetControllerClassByPlayer(activator);
		if (controller_class == null)
		{
			return;
		}
		controller_class.Use_UnAttack2();
	}

	function UnPressedForward()
	{
		printl("UnPressedForward");
		
		local controller_class = GetControllerClassByPlayer(activator);
		if (controller_class == null)
		{
			return;
		}
		controller_class.Use_UnW();
	}

	function UnPressedBack()
	{
		printl("UnPressedBack");
		
		local controller_class = GetControllerClassByPlayer(activator);
		if (controller_class == null)
		{
			return;
		}
		controller_class.Use_UnS();
	}

	function UnPressedMoveLeft()
	{
		printl("UnPressedMoveLeft");
		
		local controller_class = GetControllerClassByPlayer(activator);
		if (controller_class == null)
		{
			return;
		}
		controller_class.Use_UnA();
	}

	function UnPressedMoveRight()
	{
		printl("UnPressedMoveRight");
		
		local controller_class = GetControllerClassByPlayer(activator);
		if (controller_class == null)
		{
			return;
		}
		controller_class.Use_UnD();
	}

	function PlayerOn()
	{
		printl("PlayerOn");
		
		local controller_class = GetControllerClassByPlayer(activator);
		if (controller_class == null)
		{
			return;
		}
		controller_class.Use_On();
	}

	function PlayerOff()
	{
		printl("PlayerOff");

		foreach (index, controller in PLAYERS_CONTROLLERS)
		{
			if (controller.activator == activator)
			{
				controller.Use_Off();
				
				if (TargerValid(controller.game_ui))
				{
					ScriptPrintMessageChatAll("GAME_UI_KILL");
					EF(controller.game_ui, "Kill");
				}
				return PLAYERS_CONTROLLERS.remove(index);
			}
		}
	}
}

::CreateController <- function(player, controller_caller, iflags)
{
	local controller_class = class_controller(player, controller_caller, iflags);
	PLAYERS_CONTROLLERS.push(controller_class);
	if (PLAYERS_CONTROLLERS.len() == 1)
	{
		Controller_Script.Tick();
	}
	return controller_class;
}

::GetPlayerControllerClassByGameUI <- function(game_ui)
{
	foreach (controller in PLAYERS_CONTROLLERS)
	{
		if (game_ui == controller.game_ui)
		{
			return controller;
		}
	}

	return null;
}

::GetControllerClassByPlayer <- function(handle)
{
	foreach (controller in PLAYERS_CONTROLLERS)
	{
		if (handle == controller.activator)
		{
			return controller;
		}
	}
	
	return null;
}

function Tick() 
{
	for (local i = 0; i < PLAYERS_CONTROLLERS.len(); i++)
	{
		if (!TargerValid(PLAYERS_CONTROLLERS[i].activator))
		{
			if (TargerValid(PLAYERS_CONTROLLERS[i].game_ui))
			{
				ScriptPrintMessageChatAll("GAME_UI_Destroy");
				// PLAYERS_CONTROLLERS[i].game_ui.Destroy();
				EF(PLAYERS_CONTROLLERS[i].game_ui, "Kill");
			}
			
			PLAYERS_CONTROLLERS.remove(i--);
		}
	}

	if (PLAYERS_CONTROLLERS.len() > 0)
	{
		CallFunction("Tick()", TICKRATE);
	}
}