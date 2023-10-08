::MONOPOL_SCRIPT <- self.GetScriptScope();

const TICKRATE = 0.05;

const MOVE_DELAY = 0.5;
const START_DELAY = 3.0;
const END_DELAY = 3.0;

const GLOWROLLEND_DELAY = 1.0;

const GLOWSELECTED_DELAY = 0.25;
const GLOWUNSELECTED_DELAY = 0.45;

const QUESTIONSHOW_DELAY = 1.0;

RollDelays <- [0.5, 2.0];

enum Enum_QUESTION
{
	REROLL = 0,
	FREE = 1,
	SWAP = 2,
	PARKING = 3,
	JAIL = 4,
	SLAY = 5,
	FORWARD = 6,
	BACKWARD = 7,
}
::Enum_QUESTION <- getconsttable().Enum_QUESTION;

enum Enum_PLACE
{
	NONE = 0,
	QUESTION = 1,
	JAIL = 2,
	FREE = 3,
}
::Enum_PLACE <- getconsttable().Enum_PLACE;

enum Enum_MOVESTATUS
{
	NONE = 0,
	QUESTION = 1,
	JAIL = 2,
	FREE = 3,
	MOVE = 4,
}
::Enum_MOVESTATUS <- getconsttable().Enum_MOVESTATUS;

PLAYERS <- [];

Draw <- true;

GameTicking <- false;
GameStart <- false;

GlowSelected_Time <- 0;
GlowNotSelected_Bool <- false;


::MONOPOL_Question <- false;
QuestionType <- -1;
QuestionSelect <- -1;
Question_Time <- 0;
QuestionRolling <- false;


PriorSelected <- -1;
PlayerMoving <- false;

RollSelected <- -1;
Rolling <- false;
RollHandle <- null;
RollAng <- Vector();
RollEnd_Time <- 0;
RollAng_Time <- 0;

::MONOPOL_JAIL_ORIGIN <- Vector();

::MONOPOL_RollStart <- false;

::MONOPOL_COLORS <- [];
::MONOPOL_PLACES <- [];
::MONOPOL_QUESTIONS <- [];

class class_question
{
	question_type = Enum_QUESTION.REROLL;
	name = "";
	block_name = "";

	constructor(_question_type, _name, _block_name)
	{
		this.question_type = _question_type;
		this.name = _name;
		this.block_name = _block_name;

		this.Hide();
	}

	function Show(delay = 0.00)
	{
		EntFire(this.block_name, "Enable", "", delay, null);
	}

	function Hide(delay = 0.00)
	{
		EntFire(this.block_name, "Disable", "", delay, null);
	}
}

class class_place
{
	origin = Vector();
	place_type = Enum_PLACE.NONE;

	constructor(_place_type, _origin)
	{
		this.place_type = _place_type;
		this.origin = _origin - Vector(0, 0, 5);

		this.Draw(15.00);
	}

	function GetOrigin()
	{
		return this.origin;
	}

	function Draw(fTime = 0.00)
	{
		if (this.place_type == Enum_PLACE.NONE)
		{
			DebugDrawCircle(this.origin, 32, 16, fTime, Vector(255, 255, 255));
		}
		else if (this.place_type == Enum_PLACE.QUESTION)
		{
			DebugDrawCircle(this.origin, 32, 16, fTime, Vector(255, 255, 0));
		}
		else if (this.place_type == Enum_PLACE.JAIL)
		{
			DebugDrawCircle(this.origin, 32, 16, fTime, Vector(255, 0, 0));
		}
		else if (this.place_type == Enum_PLACE.FREE)
		{
			DebugDrawCircle(this.origin, 32, 16, fTime, Vector(0, 255, 0));
		}
	}
}

class class_color
{
	name = "";
	altname = "";
	player_rgb = Vector();

	glow_status = false;
	sprite_name = "";
	createbutton_name = "";
	selectbutton_name = "";

	free = true;
	pass = true;

	constructor(_name, _altname, _player_rgb, _selectbutton_name, _sprite_name, _createbutton_name)
	{
		this.name = _name;
		this.altname = _altname;
		this.player_rgb = _player_rgb;
		this.sprite_name = _sprite_name;
		this.createbutton_name = _createbutton_name;
		this.selectbutton_name = _selectbutton_name;

		this.pass = true;

		if (this.name == "Черный")
		{
			EntFire(this.sprite_name, "Disable", "", 0, null);
		}

		this.Glow_Disable();

		EntFire(this.selectbutton_name, "Lock", "", 0, null);
		EntFire(this.selectbutton_name, "AddOutput", "rendermode 10", 0, null);
	}

	function GetTextName()
	{
		return format("\x04(\x01%s\x04)\x01 ", this.name);
	}

	function IsPass()
	{
		return this.pass;
	}

	function SetPass(bValue)
	{
		this.pass = bValue;
	}

	function Glow_Enable(delay = 0.00)
	{
		if (!this.glow_status)
		{
			if (this.name == "Черный")
			{
				EntFire(this.sprite_name, "Enable", "", delay, null);
			}
			else
			{
				EntFire(this.sprite_name, "ShowSprite", "", delay, null);
			}
		}

		this.glow_status = true;
	}

	function Off(delay = 0.00)
	{
		EntFire(this.selectbutton_name "Lock", "", delay, null);
	}

	function On(delay = 0.00)
	{
		EntFire(this.selectbutton_name, "UnLock", "", delay, null);
	}

	function Glow_Disable(delay = 0.00)
	{
		if (this.glow_status)
		{
			if (this.name == "Черный")
			{
				EntFire(this.sprite_name, "Disable", "", delay, null);
			}
			else
			{
				EntFire(this.sprite_name, "HideSprite", "", delay, null);
			}
		}

		this.glow_status = false;
	}

	function Glow_Toggle(delay = 0.00)
	{
		if (this.glow_status)
		{
			this.Glow_Disable(delay);
		}
		else
		{
			this.Glow_Enable(delay);
		}
	}

	function IsFree()
	{
		return this.free;
	}

	function PlayerDisconnect()
	{
		if (this.free)
		{
			return;
		}

		this.free = true;

		this.Glow_Disable(2.00);

		EntFire(this.selectbutton_name, "Lock", "", 0, null);
		EntFire(this.selectbutton_name, "AddOutput", "rendermode 10", 0, null);
	}

	function PlayerConnect()
	{
		this.free = false;
		this.pass = true;

		EntFire(this.createbutton_name, "Lock", "", 0, null);
		EntFire(this.createbutton_name, "AddOutput", "rendermode 10", 0, null);

		EntFire(this.selectbutton_name, "UnLock", "", 0, null);
		EntFire(this.selectbutton_name, "AddOutput", "rendermode 0", 0, null);
	}

	function Reset()
	{
		this.free = true;
		this.Glow_Disable(2.00);

		EntFire(this.selectbutton_name, "Lock", "", 0, null);
		EntFire(this.selectbutton_name, "AddOutput", "rendermode 10", 0, null);

		EntFire(this.createbutton_name, "UnLock", "", 0, null);
		EntFire(this.createbutton_name, "AddOutput", "rendermode 0", 0, null);
	}

	function NoPlayer()
	{
		this.Glow_Disable();

		EntFire(this.createbutton_name, "Lock", "", 0, null);
		EntFire(this.createbutton_name, "AddOutput", "rendermode 10", 0, null);
		EntFire(this.selectbutton_name, "Lock", "", 0, null);
		EntFire(this.selectbutton_name, "AddOutput", "rendermode 10", 0, null);
	}
}

class class_player
{
	color = 0;
	placeID = 0;
	moves = 0;
	move_time = 0;
	handle = null;

	free = false;

	constructor(_handle, _color)
	{
		this.placeID = 0;

		this.handle = _handle;
		this.color = _color;

		this.handle.__KeyValueFromInt("rendermode", 1);
		this.handle.__KeyValueFromVector("rendercolor", MONOPOL_COLORS[this.color].player_rgb);

		this.handle.SetOrigin(MONOPOL_PLACES[this.placeID].GetOrigin());
	}

	function Valid()
	{
		return (this.handle != null && this.handle.IsValid() && this.handle.GetHealth() > 0)
	}

	function SetMoves(i)
	{
		this.moves = i;
	}

	function Move()
	{
		if (this.moves == 0)
		{
			return Enum_MOVESTATUS.NONE;
		}

		if (this.move_time > Time())
		{
			return Enum_MOVESTATUS.MOVE;
		}

		local lastplaceID = this.placeID;

		if (this.moves > 0)
		{
			this.moves--;
			if (++this.placeID >= MONOPOL_PLACES.len())
			{
				this.moves = 0;
				this.placeID = MONOPOL_PLACES.len() - 1;
			}
		}
		else
		{
			this.moves++;
			if (--this.placeID < 0)
			{
				this.moves = 0;
				this.placeID = 0;
			}
		}

		if (lastplaceID != this.placeID)
		{
			this.CompareOrigin();
			this.move_time = Time() + MOVE_DELAY;
		}

		if (this.moves != 0)
		{
			return Enum_MOVESTATUS.MOVE;
		}

		switch (MONOPOL_PLACES[this.placeID].place_type)
		{
			case Enum_PLACE.QUESTION:
				return Enum_MOVESTATUS.QUESTION;
				break;

			case Enum_PLACE.JAIL:
				return Enum_MOVESTATUS.JAIL;
				break;

			case Enum_PLACE.FREE:
				return Enum_MOVESTATUS.FREE;
				break;
		}

		return Enum_MOVESTATUS.NONE;
	}

	function CompareOrigin()
	{
		local vec = MONOPOL_PLACES[this.placeID].GetOrigin();
		this.handle.SetOrigin(vec);
	}

	function Free()
	{
		this.free = true;
	}

	function Jail()
	{
		this.handle.SetOrigin(MONOPOL_JAIL_ORIGIN);
	}
}

function Init()
{
	MONOPOL_COLORS.push(class_color("Красный", "Red", Vector(255, 0, 0), "monopol_selectplayer_0", "monopol_selectglow_0", "monopol_seleccolor_0"));
	MONOPOL_COLORS.push(class_color("Синий", "Blue", Vector(6, 0, 255), "monopol_selectplayer_1", "monopol_selectglow_1", "monopol_seleccolor_1"));
	MONOPOL_COLORS.push(class_color("Зеленый", "Green", Vector(0, 255, 48), "monopol_selectplayer_2", "monopol_selectglow_2", "monopol_seleccolor_2"));
	MONOPOL_COLORS.push(class_color("Розовый", "Pink", Vector(255, 0, 228), "monopol_selectplayer_3", "monopol_selectglow_3", "monopol_seleccolor_3"));
	MONOPOL_COLORS.push(class_color("Желтый", "Yellow", Vector(255, 240, 0), "monopol_selectplayer_4", "monopol_selectglow_4", "monopol_seleccolor_4"));
	MONOPOL_COLORS.push(class_color("Голубой", "Azure", Vector(0, 255, 246), "monopol_selectplayer_5", "monopol_selectglow_5", "monopol_seleccolor_5"));
	MONOPOL_COLORS.push(class_color("Белый", "White", Vector(255, 255, 255), "monopol_selectplayer_6", "monopol_selectglow_6", "monopol_seleccolor_6"));
	MONOPOL_COLORS.push(class_color("Черный", "Black", Vector(75, 75, 75), "monopol_selectplayer_7", "monopol_selectglow_7", "monopol_seleccolor_7"));
	MONOPOL_COLORS.push(class_color("Фиолетовый", "Purple", Vector(126, 0, 255), "monopol_selectplayer_8", "monopol_selectglow_8", "monopol_seleccolor_8"));
	MONOPOL_COLORS.push(class_color("Оранжевый", "Orange", Vector(254, 114, 0), "monopol_selectplayer_9", "monopol_selectglow_9", "monopol_seleccolor_9"));
	MONOPOL_COLORS.push(class_color("Коричневый", "Brown", Vector(89, 47, 13), "monopol_selectplayer_10", "monopol_selectglow_10", "monopol_seleccolor_10"));
	MONOPOL_COLORS.push(class_color("Серый", "Grey", Vector(128, 128, 128), "monopol_selectplayer_11", "monopol_selectglow_11", "monopol_seleccolor_11"));

	MONOPOL_PLACES.push(class_place(Enum_PLACE.NONE, Vector(24, 6558, -305))); //0
	MONOPOL_PLACES.push(class_place(Enum_PLACE.NONE, Vector(122, 6549, -298))); //1
	MONOPOL_PLACES.push(class_place(Enum_PLACE.NONE, Vector(211, 6549, -298))); //2
	MONOPOL_PLACES.push(class_place(Enum_PLACE.NONE, Vector(292, 6551, -298))); //3
	MONOPOL_PLACES.push(class_place(Enum_PLACE.QUESTION, Vector(378, 6545, -298))); //4
	MONOPOL_PLACES.push(class_place(Enum_PLACE.NONE, Vector(460, 6541, -298))); //5
	MONOPOL_PLACES.push(class_place(Enum_PLACE.QUESTION, Vector(541, 6542, -298))); //6
	MONOPOL_PLACES.push(class_place(Enum_PLACE.NONE, Vector(627, 6542, -298))); //7
	MONOPOL_PLACES.push(class_place(Enum_PLACE.NONE, Vector(714, 6543, -298))); //8
	MONOPOL_PLACES.push(class_place(Enum_PLACE.NONE, Vector(801, 6542, -298))); //9
	MONOPOL_PLACES.push(class_place(Enum_PLACE.JAIL, Vector(889, 6546, -305))); //10
	MONOPOL_PLACES.push(class_place(Enum_PLACE.NONE, Vector(889, 6648, -305))); //11
	MONOPOL_PLACES.push(class_place(Enum_PLACE.NONE, Vector(889, 6732, -305))); //12
	MONOPOL_PLACES.push(class_place(Enum_PLACE.NONE, Vector(889, 6810, -305))); //13
	MONOPOL_PLACES.push(class_place(Enum_PLACE.QUESTION, Vector(889, 6887, -305))); //14
	MONOPOL_PLACES.push(class_place(Enum_PLACE.NONE, Vector(889, 6965, -305))); //15
	MONOPOL_PLACES.push(class_place(Enum_PLACE.NONE, Vector(889, 7065, -305))); //16
	MONOPOL_PLACES.push(class_place(Enum_PLACE.NONE, Vector(799, 7065, -305))); //17
	MONOPOL_PLACES.push(class_place(Enum_PLACE.NONE, Vector(712, 7065, -305))); //18
	MONOPOL_PLACES.push(class_place(Enum_PLACE.NONE, Vector(626, 7065, -305))); //19
	MONOPOL_PLACES.push(class_place(Enum_PLACE.QUESTION, Vector(542, 7065, -305))); //20
	MONOPOL_PLACES.push(class_place(Enum_PLACE.NONE, Vector(463, 7065, -305))); //21
	MONOPOL_PLACES.push(class_place(Enum_PLACE.QUESTION, Vector(377, 7065, -305))); //22
	MONOPOL_PLACES.push(class_place(Enum_PLACE.NONE, Vector(293, 7065, -305))); //23
	MONOPOL_PLACES.push(class_place(Enum_PLACE.NONE, Vector(207, 7065, -305))); //24
	MONOPOL_PLACES.push(class_place(Enum_PLACE.NONE, Vector(121, 7065, -305))); //25
	MONOPOL_PLACES.push(class_place(Enum_PLACE.JAIL, Vector(24, 7065, -305))); //26
	MONOPOL_PLACES.push(class_place(Enum_PLACE.NONE, Vector(24, 6975, -305))); //27
	MONOPOL_PLACES.push(class_place(Enum_PLACE.NONE, Vector(24, 6891, -305))); //28
	MONOPOL_PLACES.push(class_place(Enum_PLACE.NONE, Vector(24, 6807, -305))); //29
	MONOPOL_PLACES.push(class_place(Enum_PLACE.QUESTION, Vector(24, 6725, -305))); //30
	MONOPOL_PLACES.push(class_place(Enum_PLACE.NONE, Vector(24, 6652, -305))); //31
	MONOPOL_PLACES.push(class_place(Enum_PLACE.FREE, Vector(457, 6817, -302))); //32

	// MONOPOL_PLACES.push(class_place(Enum_PLACE.NONE, Vector(-934, -168, -467))); //0
	// MONOPOL_PLACES.push(class_place(Enum_PLACE.NONE, Vector(-836, -177, -467))); //1
	// MONOPOL_PLACES.push(class_place(Enum_PLACE.NONE, Vector(-747, -177, -467))); //2
	// MONOPOL_PLACES.push(class_place(Enum_PLACE.NONE, Vector(-666, -175, -467))); //3
	// MONOPOL_PLACES.push(class_place(Enum_PLACE.QUESTION, Vector(-580, -181, -467))); //4
	// MONOPOL_PLACES.push(class_place(Enum_PLACE.NONE, Vector(-498, -185, -467))); //5
	// MONOPOL_PLACES.push(class_place(Enum_PLACE.QUESTION, Vector(-417, -184, -467))); //6
	// MONOPOL_PLACES.push(class_place(Enum_PLACE.NONE, Vector(-331, -184, -467))); //7
	// MONOPOL_PLACES.push(class_place(Enum_PLACE.NONE, Vector(-244, -183, -467))); //8
	// MONOPOL_PLACES.push(class_place(Enum_PLACE.NONE, Vector(-157, -184, -467))); //9
	// MONOPOL_PLACES.push(class_place(Enum_PLACE.JAIL, Vector(-69, -180, -467))); //10
	// MONOPOL_PLACES.push(class_place(Enum_PLACE.NONE, Vector(-69, -78, -467))); //11
	// MONOPOL_PLACES.push(class_place(Enum_PLACE.NONE, Vector(-69, 6, -467))); //12
	// MONOPOL_PLACES.push(class_place(Enum_PLACE.NONE, Vector(-69, 84, -467))); //13
	// MONOPOL_PLACES.push(class_place(Enum_PLACE.QUESTION, Vector(-69, 161, -467))); //14
	// MONOPOL_PLACES.push(class_place(Enum_PLACE.NONE, Vector(-69, 239, -467))); //15
	// MONOPOL_PLACES.push(class_place(Enum_PLACE.NONE, Vector(-69, 339, -467))); //16
	// MONOPOL_PLACES.push(class_place(Enum_PLACE.NONE, Vector(-159, 339, -467))); //17
	// MONOPOL_PLACES.push(class_place(Enum_PLACE.NONE, Vector(-246, 339, -467))); //18
	// MONOPOL_PLACES.push(class_place(Enum_PLACE.NONE, Vector(-332, 339, -467))); //19
	// MONOPOL_PLACES.push(class_place(Enum_PLACE.QUESTION, Vector(-416, 339, -467))); //20
	// MONOPOL_PLACES.push(class_place(Enum_PLACE.NONE, Vector(-495, 339, -467))); //21
	// MONOPOL_PLACES.push(class_place(Enum_PLACE.QUESTION, Vector(-581, 339, -467))); //22
	// MONOPOL_PLACES.push(class_place(Enum_PLACE.NONE, Vector(-665, 339, -467))); //23
	// MONOPOL_PLACES.push(class_place(Enum_PLACE.NONE, Vector(-751, 339, -467))); //24
	// MONOPOL_PLACES.push(class_place(Enum_PLACE.NONE, Vector(-837, 339, -467))); //25
	// MONOPOL_PLACES.push(class_place(Enum_PLACE.JAIL, Vector(-934, 339, -467))); //26
	// MONOPOL_PLACES.push(class_place(Enum_PLACE.NONE, Vector(-934, 249, -467))); //27
	// MONOPOL_PLACES.push(class_place(Enum_PLACE.NONE, Vector(-934, 165, -467))); //28
	// MONOPOL_PLACES.push(class_place(Enum_PLACE.NONE, Vector(-934, 81, -467))); //29
	// MONOPOL_PLACES.push(class_place(Enum_PLACE.QUESTION, Vector(-934, -1, -467))); //30
	// MONOPOL_PLACES.push(class_place(Enum_PLACE.NONE, Vector(-934, -74, -467))); //31
	// MONOPOL_PLACES.push(class_place(Enum_PLACE.FREE, Vector(-501, 91, -464))); //32

	MONOPOL_QUESTIONS.push(class_question(Enum_QUESTION.REROLL, "Реролл", "monopol_question_0")); //0
	MONOPOL_QUESTIONS.push(class_question(Enum_QUESTION.FORWARD, "3 Клетки вперед", "monopol_question_1")); //1
	MONOPOL_QUESTIONS.push(class_question(Enum_QUESTION.JAIL, "Джайл", "monopol_question_2")); //2
	MONOPOL_QUESTIONS.push(class_question(Enum_QUESTION.PARKING,  "На парковку", "monopol_question_3")); //3
	MONOPOL_QUESTIONS.push(class_question(Enum_QUESTION.SWAP, "Поменяйся местами", "monopol_question_4")); //4
	MONOPOL_QUESTIONS.push(class_question(Enum_QUESTION.BACKWARD, "3 Клетки назад", "monopol_question_5")); //5
	MONOPOL_QUESTIONS.push(class_question(Enum_QUESTION.SLAY, "Зек на килл", "monopol_question_6")); //6
	MONOPOL_QUESTIONS.push(class_question(Enum_QUESTION.FREE, "Фридей", "monopol_question_7")); //7

	MONOPOL_JAIL_ORIGIN = Vector(647, 6916, -272);

	RollHandle = Entities.FindByName(null, "monopol_roller_cube");

	// local ent;
	// for (local i = 0; i <= 32; i++)
	// {
	// 	ent = Entities.FindByName(null, "point" + i);
	// 	if (ent == null || !ent.IsValid())
	// 	{
	// 		printl("ERORR");
	// 		continue;
	// 	}
	// 	printl(format("MONOPOL_PLACES.push(class_place(Enum_PLACE.NONE, Vector(%i, %i, %i))); //%i", ent.GetOrigin().x, ent.GetOrigin().y, ent.GetOrigin().z, i));
	// }
}

function SelectPlayerButton(ID)
{
	if (activator == null ||
		!activator.IsValid() ||
		activator.GetTeam() != 3)
	{
		return;
	}

	local iFind = -1;
	foreach (index, player in PLAYERS)
	{
		if (player.color == ID)
		{
			iFind = index;
			break;
		}
	}

	if (iFind == -1)
	{
		printl(format("Цвет не доступен"));
		return;
	}

	if (MONOPOL_Question &&
		QuestionType > 0 &&
		(MONOPOL_QUESTIONS[QuestionType].question_type == Enum_QUESTION.SWAP ||
		MONOPOL_QUESTIONS[QuestionType].question_type == Enum_QUESTION.SLAY))
	{
		if (!CheckQuestion(QuestionSelect, iFind))
		{
			iFind = -1;
		}
	}
	else
	{
		RollSelected = iFind;
	}

	if (iFind == -1)
	{
		return;
	}

	foreach (index, color in MONOPOL_COLORS)
	{
		if (color.IsFree())
		{
			continue;
		}

		color.Glow_Disable();
	}
}

function CreatePlayerButton(ID)
{
	CreatePlayer(activator, MONOPOL_COLORS[ID].name);
}

function CreatePlayer(handle, color_name)
{
	foreach (player in PLAYERS)
	{
		if (player.handle == handle)
		{
			printl(handle.tostring() + format(" Игрок уже в массиве. Цвет %s", MONOPOL_COLORS[player.color].GetTextName()));
			return;
		}
	}

	local bFind = false;
	foreach (i, color in MONOPOL_COLORS)
	{
		if (color.name == color_name)
		{
			if (!color.IsFree())
			{
				printl(format("%s Цвет уже занят", color_name));
				return;
			}

			bFind = true;
			color_name = i;

			color.PlayerConnect();
			break;
		}
	}

	if (!bFind)
	{
		printl(format("%s Цвет не найден", color_name));
		return;
	}

	PLAYERS.push(class_player(handle, color_name));

	PreStart();
}

function PreStart()
{
	if (!GameStart)
	{
		GameStart = true;

		EntFire("monopol_roller_cube", "EnableMotion", "", 0, null);
		EntFireByHandle(self, "RunScriptCode", "Start()", START_DELAY, null, null);
	}
}

function Start()
{
	printl(format("Игра началась"));

	MONOPOL_RollStart = false;
	GameTicking = true;

	Tick();
}

function Tick()
{
	if (!GameTicking)
	{
		return;
	}

	// Tick_PlaceDraw();

	Tick_ValidPlayers();

	if (PLAYERS.len() < 1)
	{
		GameEnd();
		return;
	}

	Tick_Roll();

	Tick_Glow();

	Tick_Move();

	Tick_Question();

	EntFireByHandle(self, "RunScriptCode", "Tick()", TICKRATE, null, null);
}

function Tick_Move()
{
	if (MONOPOL_Question)
	{
		return;
	}

	PlayerMoving = false;

	if (PriorSelected != -1)
	{
		_result = PLAYERS[PriorSelected].Move();
		switch (_result)
		{
			case Enum_MOVESTATUS.QUESTION:
				PlayerQuestion(PriorSelected);
				break;

			case Enum_MOVESTATUS.JAIL:
				PlayerJail(PriorSelected);
				break;

			case Enum_MOVESTATUS.FREE:
				PlayerFree(PriorSelected);
				break;

			case Enum_MOVESTATUS.MOVE:
				PlayerMoving = true;
				return;
				break;
		}

		PriorSelected = -1;
		return;
	}


	local _result;
	foreach (index, player in PLAYERS)
	{
		_result = player.Move();
		switch (_result)
		{
			case Enum_MOVESTATUS.QUESTION:
				PlayerQuestion(index);
				return;
				break;

			case Enum_MOVESTATUS.JAIL:
				PlayerJail(index);
				break;

			case Enum_MOVESTATUS.FREE:
				PlayerFree(index);
				break;

			case Enum_MOVESTATUS.MOVE:
				PlayerMoving = true;
				return;
				break;
		}
	}
}

function Tick_PlaceDraw()
{
	if (!Draw)
	{
		return;
	}

	foreach (place in MONOPOL_PLACES)
	{
		place.Draw(TICKRATE + TICKRATE);
	}
}

function Tick_ValidPlayers()
{
	if (RollSelected != -1)
	{
		if (PLAYERS.len() > RollSelected &&
		PLAYERS[RollSelected].Valid())
		{
			RollSelected = PLAYERS[RollSelected].handle;
		}
		else
		{
			RollSelected = -1;
		}
	}

	if (PriorSelected != -1)
	{
		if (PLAYERS.len() > PriorSelected &&
		PLAYERS[PriorSelected].Valid())
		{
			PriorSelected = PLAYERS[PriorSelected].handle;
		}
		else
		{
			PriorSelected = -1;
		}
	}

	if (QuestionSelect != -1)
	{
		if (PLAYERS.len() > QuestionSelect &&
		PLAYERS[QuestionSelect].Valid())
		{
			QuestionSelect = PLAYERS[QuestionSelect].handle;
		}
		else
		{
			QuestionRolling = false;
			MONOPOL_Question = false;
			QuestionSelect = -1;
		}
	}

	local SaveArray = [];
	foreach (index, player in PLAYERS)
	{
		if (!player.Valid())
		{
			MONOPOL_COLORS[player.color].PlayerDisconnect();
			continue;
		}
		SaveArray.push(player);
	}

	PLAYERS.clear();

	foreach (index, player in SaveArray)
	{
		PLAYERS.push(player);
	}

	if (RollSelected != -1)
	{
		foreach (index, player in PLAYERS)
		{
			if (player.handle == RollSelected)
			{
				RollSelected = index;
				break;
			}
		}
	}
	else
	{
		if (PLAYERS.len() == 1)
		{
			RollSelected = 0;
		}
	}

	if (PriorSelected != -1)
	{
		foreach (index, player in PLAYERS)
		{
			if (player.handle == PriorSelected)
			{
				PriorSelected = index;
				break;
			}
		}
	}

	if (QuestionSelect != -1)
	{
		foreach (index, player in PLAYERS)
		{
			if (player.handle == QuestionSelect)
			{
				QuestionSelect = index;
				break;
			}
		}
	}
}

function Tick_Roll()
{
	if (Rolling &&
		RollAng_Time < Time())
	{
		local vecAng = RollHandle.GetAngles();

		if (vecAng.x == RollAng.x &&
			vecAng.y == RollAng.y &&
			vecAng.z == RollAng.z)
		{
			printl(format("Ролл закончился"));
			local iValue = GetRollValue(vecAng);
			if (iValue == -1)
			{
				return StartRoll(RollSelected);
			}

			Monopol_ScriptPrintMessageChatAll(format("%s - %i клетки вперед", MONOPOL_COLORS[PLAYERS[RollSelected].color].GetTextName(), iValue));
			PlayerMove(RollSelected, iValue);

			MONOPOL_COLORS[PLAYERS[RollSelected].color].Glow_Disable();
			RollSelected = -1;

			if (PLAYERS.len() == 1)
			{
				RollSelected = 0;
			}

			Rolling = false;
			RollEnd_Time = Time() + GLOWROLLEND_DELAY;

			local bReset = true;
			foreach (color in MONOPOL_COLORS)
			{
				if (color.IsFree())
				{
					continue;
				}

				color.On();

				if (color.IsPass())
				{
					bReset = false;
				}
			}

			if (bReset)
			{
				foreach (color in MONOPOL_COLORS)
				{
					if (color.IsFree())
					{
						continue;
					}
					color.SetPass(true);
				}
			}
		}

		RollAng = vecAng;
	}
}

function Tick_Glow()
{
	if (!Rolling &&
	!MONOPOL_Question &&
	!PlayerMoving)
	{
		if (RollSelected != -1)
		{
			if (Time() > GlowSelected_Time)
			{
				GlowSelected_Time = Time() + GLOWSELECTED_DELAY;
				MONOPOL_COLORS[PLAYERS[RollSelected].color].Glow_Toggle();
			}
		}
		else
		{
			if (Time() > GlowSelected_Time &&
				Time() > RollEnd_Time)
			{
				GlowSelected_Time = Time() + GLOWUNSELECTED_DELAY;

				local i = -1;

				foreach (color in MONOPOL_COLORS)
				{
					if (color.IsFree())
					{
						continue;
					}

					if (!color.IsPass())
					{
						continue;
					}

					i++;

					if (i % 2 == 0)
					{
						if (GlowNotSelected_Bool)
						{
							color.Glow_Enable();
						}
						else
						{
							color.Glow_Disable();
						}
					}
					else
					{
						if (GlowNotSelected_Bool)
						{
							color.Glow_Disable();
						}
						else
						{
							color.Glow_Enable();
						}
					}
				}

				GlowNotSelected_Bool = !GlowNotSelected_Bool;
			}
		}
	}

	if (MONOPOL_Question &&
	QuestionType > 0)
	{
		switch (MONOPOL_QUESTIONS[QuestionType].question_type)
		{
			case Enum_QUESTION.SWAP:
				if (Time() > GlowSelected_Time &&
				Time() > RollEnd_Time)
				{
					GlowSelected_Time = Time() + GLOWUNSELECTED_DELAY;

					local i = -1;

					foreach (index, color in MONOPOL_COLORS)
					{
						if (color.IsFree())
						{
							continue;
						}

						if (PLAYERS[QuestionSelect].color == index)
						{
							continue;
						}

						i++;

						if (i % 2 == 0)
						{
							if (GlowNotSelected_Bool)
							{
								color.Glow_Enable();
							}
							else
							{
								color.Glow_Disable();
							}
						}
						else
						{
							if (GlowNotSelected_Bool)
							{
								color.Glow_Disable();
							}
							else
							{
								color.Glow_Enable();
							}
						}
					}

					GlowNotSelected_Bool = !GlowNotSelected_Bool;
				}
				break;

			case Enum_QUESTION.SLAY:
				if (Time() > GlowSelected_Time &&
				Time() > RollEnd_Time)
				{
					GlowSelected_Time = Time() + GLOWUNSELECTED_DELAY;

					local i = -1;

					foreach (index, color in MONOPOL_COLORS)
					{
						if (color.IsFree())
						{
							continue;
						}

						i++;

						if (i % 2 == 0)
						{
							if (GlowNotSelected_Bool)
							{
								color.Glow_Enable();
							}
							else
							{
								color.Glow_Disable();
							}
						}
						else
						{
							if (GlowNotSelected_Bool)
							{
								color.Glow_Disable();
							}
							else
							{
								color.Glow_Enable();
							}
						}
					}

					GlowNotSelected_Bool = !GlowNotSelected_Bool;
				}
				break;
		}
	}
}

function Tick_Question()
{
	if (!MONOPOL_Question)
	{
		return;
	}

	if (!QuestionRolling)
	{
		return;
	}

	if (Question_Time > Time())
	{
		return;
	}

	QuestionType = RandomInt(0, MONOPOL_QUESTIONS.len() - 1);
	QuestionRolling = false;

	MONOPOL_QUESTIONS[QuestionType].Show();

	switch (MONOPOL_QUESTIONS[QuestionType].question_type)
	{
		case Enum_QUESTION.REROLL:
			StartQuestionReroll();
			break;

		case Enum_QUESTION.FREE:
			StartQuestionFree();
			break;

		case Enum_QUESTION.PARKING:
			StartQuestionParking();
			break;

		case Enum_QUESTION.SWAP:
			StartQuestionSwap();
			break;

		case Enum_QUESTION.JAIL:
			StartQuestionJail();
			break;

		case Enum_QUESTION.SLAY:
			StartQuestionSlay();
			break;

		case Enum_QUESTION.FORWARD:
			StartQuestionForward();
			break;

		case Enum_QUESTION.BACKWARD:
			StartQuestionBackWard();
			break;
	}
}

function StartQuestionReroll()
{
	Monopol_ScriptPrintMessageChatAll(format("%s - [\x0EКарта\x01] - перекидывает кубики", MONOPOL_COLORS[PLAYERS[QuestionSelect].color].GetTextName()));
	printl(format("Рерол"));

	MONOPOL_Question = false;

	StartRoll(QuestionSelect);
	QuestionSelect = -1;
}

function StartQuestionFree()
{
	Monopol_ScriptPrintMessageChatAll(format("%s - [\x0EКарта\x01] - получил фридей", MONOPOL_COLORS[PLAYERS[QuestionSelect].color].GetTextName()));
	printl(format("Фридей"));

	MONOPOL_Question = false;
	MONOPOL_COLORS[PLAYERS[QuestionSelect].color].PlayerDisconnect();
	PlayerMove(QuestionSelect, MONOPOL_PLACES.len());

	QuestionSelect = -1;
}

function StartQuestionParking()
{
	Monopol_ScriptPrintMessageChatAll(format("%s - [\x0EКарта\x01] - отправляется на парковку", MONOPOL_COLORS[PLAYERS[QuestionSelect].color].GetTextName()));
	printl(format("На парковку"));

	MONOPOL_Question = false;

	PlayerMove(QuestionSelect, 16 - PLAYERS[QuestionSelect].placeID);

	QuestionSelect = -1;
}

function StartQuestionJail()
{
	Monopol_ScriptPrintMessageChatAll(format("%s - [\x0EКарта\x01] - отправляется в джайл", MONOPOL_COLORS[PLAYERS[QuestionSelect].color].GetTextName()));
	printl(format("За решетку"));

	MONOPOL_Question = false;
	PlayerJail(QuestionSelect);
	QuestionSelect = -1;
}

function StartQuestionSlay()
{
	Monopol_ScriptPrintMessageChatAll(format("%s - [\x0EКарта\x01] - должен выбрать зека на килл", MONOPOL_COLORS[PLAYERS[QuestionSelect].color].GetTextName()));
	printl(format("Убийство зека"));
	ColorInfo();
}


function StartQuestionSwap()
{
	Monopol_ScriptPrintMessageChatAll(format("%s - [\x0EКарта\x01] - должен выбрать зека для обмена мест", MONOPOL_COLORS[PLAYERS[QuestionSelect].color].GetTextName()));
	printl(format("Смена мест"));
	ColorInfo();
}

function StartQuestionForward()
{
	Monopol_ScriptPrintMessageChatAll(format("%s - [\x0EКарта\x01] - отправляется вперед на 3 клетки", MONOPOL_COLORS[PLAYERS[QuestionSelect].color].GetTextName()));

	printl(format("Вперед на 3 хода"));
	MONOPOL_Question = false;

	PlayerMove(QuestionSelect, 3);
	QuestionSelect = -1;
}

function StartQuestionBackWard()
{
	Monopol_ScriptPrintMessageChatAll(format("%s - [\x0EКарта\x01] - отправляется назад на 3 клетки", MONOPOL_COLORS[PLAYERS[QuestionSelect].color].GetTextName()));
	printl(format("Назад на 3 хода"));
	QuestionRolling = false;
	MONOPOL_Question = false;

	PlayerMove(QuestionSelect, -3);
	QuestionSelect = -1;
}

function StartQuestionButton()
{
	if (activator == null ||
		!activator.IsValid() ||
		activator.GetTeam() != 3)
	{
		return;
	}

	if (!MONOPOL_Question)
	{
		printl(format("Сейчас нет вопроса"));
		return;
	}

	foreach (question in MONOPOL_QUESTIONS)
	{
		question.Hide();
	}

	QuestionRolling = true;
	Question_Time = Time() + QUESTIONSHOW_DELAY;
}

function StartRollButton()
{
	if (activator == null ||
		!activator.IsValid() ||
		activator.GetTeam() != 3)
	{
		return;
	}

	if (MONOPOL_Question)
	{
		printl(format("Сейчас активен вопрос"));
		return;
	}

	if (PlayerMoving)
	{
		printl(format("Игроки еще двигаются"));
		return;
	}

	if (RollSelected == -1)
	{
		printl(format("Выбранный игрок не доступен"));
		return;
	}

	if (!MONOPOL_RollStart)
	{
		MONOPOL_RollStart = true;

		foreach (color in MONOPOL_COLORS)
		{
			if (color.IsFree())
			{
				color.NoPlayer();
			}
		}
	}

	printl(format("Запускаю ролл"));
	StartRoll(RollSelected);
}

function StartRoll(ID)
{
	Monopol_ScriptPrintMessageChatAll(format("%s - запуск кубиков", MONOPOL_COLORS[PLAYERS[ID].color].GetTextName()));

	RollAng_Time = Time() + 0.2;
	Rolling = true;
	RollAng = Vector();

	RollSelected = ID;

	foreach (color in MONOPOL_COLORS)
	{
		if (color.IsFree())
		{
			continue;
		}
		color.Off();
		color.Glow_Disable();
	}

	MONOPOL_COLORS[PLAYERS[RollSelected].color].Glow_Enable();
	MONOPOL_COLORS[PLAYERS[RollSelected].color].SetPass(false);

	EntFire("monopol_roller_cube_sound", "StopSound", "", 0, null);
	EntFire("monopol_roller_cube_sound", "PlaySound", "", 0.1, null);

	EntFire("monopol_roller_cube_mover", "Activate", "", 0, null);
	EntFire("monopol_roller_cube_mover", "Deactivate", "", RandomFloat(RollDelays[0], RollDelays[1]), null);
}

function GetRollValue(ang)
{
	if (ang.x > -1 && ang.x < 1 &&
		ang.z > -1 && ang.z < 1)
	{
		return 1;
	}
	else if (ang.x > -76 && ang.x < -74 &&
		ang.z > 89 && ang.z < 91)
	{
		return 2;
	}
	else if (ang.x > 13 && ang.x < 15 &&
		ang.z > 89 && ang.z < 91)
	{
		return 3;
	}
	else if (ang.x > 74 && ang.x < 76 &&
		ang.z > -91 && ang.z < -89)
	{
		return 4;
	}
	else if (ang.x > -15 && ang.x < -13 &&
		ang.z > -91 && ang.z < -89)
	{
		return 5;
	}
	else if (ang.x > -1 && ang.x < 1 &&
		((ang.z > 0 && ang.z > 179) || (ang.z < 0 && ang.z < -179)))
	{
		return 6;
	}

	printl(format("Кубик не правльное значение"));
	return -1
}

function PlayerMove(ID, moves)
{
	PLAYERS[ID].SetMoves(moves);
}

function GameEnd()
{
	Monopol_ScriptPrintMessageChatAll("Игра завершена!");
	EntFire("monopol_gameend", "Press", "", 1.5, null);
}

function Reset()
{
	PLAYERS.clear();
	GameTicking = false;
	GameStart = false;

	MONOPOL_Question = false;
	MONOPOL_RollStart = false;
	PLAYERS.clear();

	foreach (color in MONOPOL_COLORS)
	{
		color.Reset();
	}

	foreach (question in MONOPOL_QUESTIONS)
	{
		question.Hide();
	}
}
function PlayerQuestion(ID)
{
	Monopol_ScriptPrintMessageChatAll(format("%s - будет тянуть карту", MONOPOL_COLORS[PLAYERS[ID].color].GetTextName()));

	QuestionRolling = false;
	MONOPOL_Question = true;
	QuestionSelect = ID;
	foreach (color in MONOPOL_COLORS)
	{
		if (color.IsFree())
		{
			continue;
		}

		if (!color.IsPass())
		{
			continue;
		}
		color.Glow_Disable();
	}
}

function PlayerFree(ID)
{
	Monopol_ScriptPrintMessageChatAll(format("%s - получил фридей", MONOPOL_COLORS[PLAYERS[ID].color].GetTextName()));
	MONOPOL_COLORS[PLAYERS[ID].color].PlayerDisconnect();
	PLAYERS[ID].Free();
	PLAYERS.remove(ID);
}
function PlayerJail(ID)
{
	Monopol_ScriptPrintMessageChatAll(format("%s - попал в джайл", MONOPOL_COLORS[PLAYERS[ID].color].GetTextName()));
	MONOPOL_COLORS[PLAYERS[ID].color].PlayerDisconnect()
	PLAYERS[ID].Jail();
	PLAYERS.remove(ID);
}

function PlayerSay(data)
{
	local player_index = GetPlayerIDbyHandle(data.handle)
	if (player_index == -1)
	{
		return;
	}

	if (!MONOPOL_Question ||
		player_index != QuestionSelect ||
		QuestionType < 0 ||
		(MONOPOL_QUESTIONS[QuestionType].question_type != Enum_QUESTION.SWAP &&
		MONOPOL_QUESTIONS[QuestionType].question_type != Enum_QUESTION.SLAY))
	{
		return;
	}

	local target = GetTargetByText(data.text);
	if (target == -1)
	{
		return;
	}

	CheckQuestion(player_index, target);
}

function ColorInfo()
{
	Monopol_ScriptPrintMessageChatAll(format("Выбери цвет и напиши его название в чат"));
	foreach (color in MONOPOL_COLORS)
	{
		if (!color.IsFree())
		{
			Monopol_ScriptPrintMessageChatAll(format("%s/%s", color.name, color.altname));
		}
	}
}

function GetTargetByText(szText)
{
	foreach (index, player in PLAYERS)
	{
		if ((MONOPOL_COLORS[PLAYERS[index].color].name).find(szText) != null ||
		(MONOPOL_COLORS[PLAYERS[index].color].altname).tolower().find(szText.tolower()) != null)
		{
			return index;
		}
	}

	return -1;
}

function CheckQuestion(player_index, target)
{
	switch (MONOPOL_QUESTIONS[QuestionType].question_type)
	{
		case Enum_QUESTION.SWAP:
			if (target == player_index)
			{
				printl(format("Себя выбрать нельзя"));
				return false;
			}
			local temp = PLAYERS[target].placeID;

			PLAYERS[target].placeID = PLAYERS[player_index].placeID;
			PLAYERS[player_index].placeID = temp;

			PLAYERS[player_index].CompareOrigin();
			PLAYERS[target].CompareOrigin();

			Monopol_ScriptPrintMessageChatAll(format("%s - [\x0EКарта\x01] - поменялся местами с %s", MONOPOL_COLORS[PLAYERS[QuestionSelect].color].GetTextName(), MONOPOL_COLORS[PLAYERS[target].color].GetTextName()));
			break;

		case Enum_QUESTION.SLAY:
			if (target == player_index)
			{
				Monopol_ScriptPrintMessageChatAll(format("%s - [\x0EКарта\x01] - выбрал для убийства сам себя", MONOPOL_COLORS[PLAYERS[QuestionSelect].color].GetTextName()));
			}
			else
			{
				Monopol_ScriptPrintMessageChatAll(format("%s - [\x0EКарта\x01] - выбрал для убийства %s", MONOPOL_COLORS[PLAYERS[QuestionSelect].color].GetTextName(), MONOPOL_COLORS[PLAYERS[target].color].GetTextName()));
			}

			EntFireByHandle(PLAYERS[target].handle, "SetHealth", "0", 1.5, null, null);
			break;
	}

	EntFireByHandle(self, "RunScriptCode", "MONOPOL_Question = false;QuestionSelect = -1;", 1.5, null, null);
	return true;
}

function GetPlayerIDbyHandle(handle)
{
	foreach (index, player in PLAYERS)
	{
		if (player.handle == handle)
		{
			return index;
		}
	}

	return -1;
}

function Monopol_ScriptPrintMessageChatAll(szText)
{
	ScriptPrintMessageChatAll("[\x04MONOPOL\x01] " + szText);
}

function DebugGame(count = 0)
{
	local players = [];
	local handle = null;

	while ((handle = Entities.FindByClassname(handle, "player")) != null)
	{
		if (handle.IsValid() && handle.GetHealth() > 0)
		{
			players.push(handle);
		}
	}

	while ((handle = Entities.FindByClassname(handle, "cs_bot")) != null)
	{
		if (handle.IsValid() && handle.GetHealth() > 0)
		{
			players.push(handle);
		}
	}

	while (MONOPOL_COLORS.len() < players.len())
	{
		players.remove(0);
	}

	if (count > 0)
	{
		while (count < players.len())
		{
			players.remove(0);
		}
	}

	foreach (i, player in players)
	{
		CreatePlayer(player, MONOPOL_COLORS[i].name);
	}
}

::DebugDrawCircle <- function(Vector_Center, radius, parts = 32, duration = 10, Color = Vector(255, 255, 255))
{
	local u = 0.0;
	local vec_end = [];
	local parts_l = parts;
	local radius = radius;
	local a = PI / parts * 2;

	while (parts_l > 0)
	{
		local vec = Vector(Vector_Center.x+cos(u)*radius, Vector_Center.y+sin(u)*radius, Vector_Center.z);
		vec_end.push(vec);
		u += a;
		parts_l--;
	}

	for (local i = 0; i < vec_end.len(); i++)
	{
		if (i < vec_end.len()-1){DebugDrawLine(vec_end[i], vec_end[i+1], Color.x, Color.y, Color.z, true, duration);}
		else{DebugDrawLine(vec_end[i], vec_end[0], Color.x, Color.y, Color.z, true, duration);}
	}
}

EntFireByHandle(self, "RunScriptCode", "Init()", 0.05, null, null);