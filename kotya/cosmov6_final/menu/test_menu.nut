MainMenu <- null;

function Spawn()
{
	local array = [];
	local obj;

	obj = class_menu_input();
	obj.name = "S";
	obj.input = test1();
	array.push(obj);

	obj = class_menu_input();
	obj.name = "F";
	obj.input = test2();
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