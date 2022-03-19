MainMenu <- null;

function Spawn()
{
	local array = [];
	local obj;

	obj = class_menu_input("Q", test1, true);
	array.push(obj);

	obj = class_menu_input("W", test1, true);
	array.push(obj);

	obj = class_menu_input("E", test2, true);
	array.push(obj);
	
}

function test1()
{
	printl("test1 : " + activator);
}

function test2()
{
	printl("test2 : " + caller);
}