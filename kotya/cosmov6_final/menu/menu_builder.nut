const TICKRATE = 10.0;

::Menu_Build_Script <- self.GetScriptScope();

::PLAYERS_MENU <- [];

::class_menu_input <- class
{
	name = "";
	input = null;
	clickcable = true;

	constructor(_name, _input, _clickcable)
	{
		this.name = _name;
		this.input = _input;
		this.clickcable = _clickcable;
	}
}

::class_menu_pointer <- class
{
	menupoints = [];

	function AddMenuPoints(point)
	{
		// if (typeof point == array)
		// {
		// 	foreach ( in point) {
				
		// 	}
		// }
		// else
		// {
		// 	this.
		// }
	}
}


class class_menu
{
	handle = null;
	game_text = null;

	selectID = 0;

	PressedAttack = null;
	PressedAttack2 = null;

	PressedForward = null;
	PressedBack = null;
	PressedMoveLeft = null;
	PressedMoveRight = null;

	PlayerOff = null;
	PlayerOn = null;

	function PressedAttack()
	{
		if (this.PressedAttack != null)
		{
			this.PressedAttack;
		}
	}

	function PressedAttack2()
	{
		if (this.PressedAttack2 != null)
		{
			
		}
	}

	function PressedForward()
	{
		if (this.PressedForward != null)
		{
			
		}
	}

	function PressedBack()
	{
		if (this.PressedBack != null)
		{
			
		}
	}

	function PressedMoveLeft()
	{
		if (this.PressedMoveLeft != null)
		{
			
		}
	}

	function PressedMoveRight()
	{
		if (this.PressedMoveRight != null)
		{
			
		}
	}

	function PlayerOff()
	{
		if (this.PlayerOff != null)
		{
			
		}
	}

	function PlayerOn()
	{
		if (this.PlayerOn != null)
		{
			
		}
	}
}


function Tick() 
{
	for (local i = 0; i < PLAYERS_MENU.len(); i++)
	{
		if (!TargerValid(PLAYERS_MENU[i].handle))
		{
			PLAYERS_MENU.remove(i);
			i--;
		}
	}
	
	if (PLAYERS_MENU.len() > 0)
	{
		CallFunction("Tick()", TICKRATE);
	}
}