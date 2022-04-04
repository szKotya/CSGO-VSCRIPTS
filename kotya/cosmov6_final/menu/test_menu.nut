MainMenu <- null;

function Reg()
{
	local player = activator;
	local controller_class = CreateController(player, self);

	controller_class.press_w = test1;
	controller_class.press_s = test2;
	controller_class.press_off = test3;
	controller_class.press_on = test4;
}
function test1()
{
	printl("test1 : w : " + activator);
}

function test2()
{
	printl("test2 : s : " + activator);
}

function test3()
{
	printl("test3 : off : " + activator);
}

function test4()
{
	printl("test4 : on : " + activator);
}

function Spawn()
{
	MainMenu = null;
	local player = activator;

	MainMenu = class_menu();
	MainMenu.AddItem(Menuselect1, "SetHealth 150 HP", true);
	MainMenu.AddItem(null, "", false);
	MainMenu.AddItem(Menuselect2, "Kill ME", true);
	MainMenu.AddItem(null, "ПКМ - дать майку в рот", false);
	MainMenu.AddItem(null, "", false);
	MainMenu.AddItem(Menuselect3, "RR", true);
	MainMenu.AddItem(null, "", false);

	DisplayMenuForPlayer(player, MainMenu);
}

function Menuselect1()
{
	activator.SetHealth(150);
}

function Menuselect2()
{
	EF(activator, "SetHealth", "-1");
}

function Menuselect3()
{
	SendToConsole("mp_restartgame 1");
}