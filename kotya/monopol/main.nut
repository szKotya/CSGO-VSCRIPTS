const TICKRATE = 0.05;

const MOVE_DELAY = 0.5;
const START_DELAY = 3.0;

const GLOWSELECTED_DELAY = 0.25;
const GLOWUNSELECTED_DELAY = 0.6;

const GLOWROLLEND_DELAY = 1.0;

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

PLAYERS <- [];

Draw <- true;

GameTicking <- false;
GameStart <- false;

GlowSelected_Time <- 0;
GlowNotSelected_Bool <- false;

Question <- false;
QuestionValue <- -1;
MONOPOL_QUESTIONSelect <- -1;

RollStart <- false;
RollSelected <- -1;
Rolling <- false;
RollHandle <- null;
RollAng <- Vector();
RollEnd_Time <- 0;
RollAng_Time <- 0;

::MONOPOL_COLORS <- [];
::MONOPOL_PLACES <- [];
::MONOPOL_QUESTIONS <- [];

class class_place
{
	name = "";
	block_name = "";

	constructor(_name, _block_name)
	{
		this.name = _name;
		this.block_name = _block_name;
	}

	function Enable(delay = 0.00)
	{
		EntFire(this.block_name, "Enable", "", delay, null);
	}

	function Disable(delay = 0.00)
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
	player_rgb = Vector();

	glow_status = false;
	sprite_name = "";
	createbutton_name = "";
	selectbutton_name = "";

	free = true;
	pass = true;

	constructor(_name, _player_rgb, _selectbutton_name, _sprite_name, _createbutton_name)
	{
		this.name = _name;
		this.player_rgb = _player_rgb;
		this.sprite_name = _sprite_name;
		this.createbutton_name = _createbutton_name;
		this.selectbutton_name = _selectbutton_name;

		this.pass = true;

		if (this.name == "Черный")
		{
			EntFire(this.sprite_name, "Disable", "", 0, null);
		}
		this.glow_status = false;
	}

	function Reset()
	{
		this.free = true;
		this.pass = true;
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
		EntFire(this.selectbutton_name, "Lock", "", delay, null);
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

	function NoPlayer()
	{
		if (this.name == "Черный")
		{
			EntFire(this.sprite_name, "Disable", "", 0, null);
		}
		else
		{
			EntFire(this.sprite_name, "HideSprite", "", 0, null);
		}

		EntFire(this.createbutton_name, "Lock", "", 0, null);
		EntFire(this.selectbutton_name, "Lock", "", 0, null);
		EntFire(this.createbutton_name, "AddOutput", "Rendermode 10", 0, null);
		EntFire(this.selectbutton_name, "AddOutput", "Rendermode 10", 0, null);
	}
}

class class_player
{
	color = 0;
	placeID = 0;
	moves = 0;
	move_time = 0;
	handle = null;

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
			return;
		}

		if (this.move_time > Time())
		{
			return;
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
			local vec = MONOPOL_PLACES[this.placeID].GetOrigin();

			this.handle.SetOrigin(vec);
			this.move_time = Time() + MOVE_DELAY;
		}

		if (this.moves != 0)
		{
			return;
		}

		if (MONOPOL_PLACES[this.placeID] == Enum_PLACE.QUESTION)
		{
			Question = true;
			return;
		}

		if (MONOPOL_PLACES[this.placeID] == Enum_PLACE.JAIL)
		{

			return;
		}

		if (MONOPOL_PLACES[this.placeID] == Enum_PLACE.FREE)
		{

			return;
		}
	}
}

function Init()
{
	MONOPOL_COLORS.push(class_color("Красный", Vector(255, 0, 0), "monopol_selectplayer_0", "monopol_selectglow_0", "monopol_seleccolor_0"));
	MONOPOL_COLORS.push(class_color("Синий", Vector(6, 0, 255), "monopol_selectplayer_1", "monopol_selectglow_1", "monopol_seleccolor_1"));
	MONOPOL_COLORS.push(class_color("Зеленый", Vector(0, 255, 48), "monopol_selectplayer_2", "monopol_selectglow_2", "monopol_seleccolor_2"));
	MONOPOL_COLORS.push(class_color("Розовый", Vector(255, 0, 228), "monopol_selectplayer_3", "monopol_selectglow_3", "monopol_seleccolor_3"));
	MONOPOL_COLORS.push(class_color("Желтый", Vector(255, 240, 0), "monopol_selectplayer_4", "monopol_selectglow_4", "monopol_seleccolor_4"));
	MONOPOL_COLORS.push(class_color("Голубой", Vector(0, 255, 246), "monopol_selectplayer_5", "monopol_selectglow_5", "monopol_seleccolor_5"));
	MONOPOL_COLORS.push(class_color("Белый", Vector(255, 255, 255), "monopol_selectplayer_6", "monopol_selectglow_6", "monopol_seleccolor_6"));
	MONOPOL_COLORS.push(class_color("Черный", Vector(75, 75, 75), "monopol_selectplayer_7", "monopol_selectglow_7", "monopol_seleccolor_7"));
	MONOPOL_COLORS.push(class_color("Фиолетовый", Vector(126, 0, 255), "monopol_selectplayer_8", "monopol_selectglow_8", "monopol_seleccolor_8"));
	MONOPOL_COLORS.push(class_color("Оранжевый", Vector(254, 114, 0), "monopol_selectplayer_9", "monopol_selectglow_9", "monopol_seleccolor_9"));
	MONOPOL_COLORS.push(class_color("Коричневый", Vector(89, 47, 13), "monopol_selectplayer_10", "monopol_selectglow_10", "monopol_seleccolor_10"));
	MONOPOL_COLORS.push(class_color("Серый", Vector(128, 128, 128), "monopol_selectplayer_11", "monopol_selectglow_11", "monopol_seleccolor_11"));

	MONOPOL_PLACES.push(class_place(Enum_PLACE.NONE, Vector(-934, -168, -467))); //0
	MONOPOL_PLACES.push(class_place(Enum_PLACE.NONE, Vector(-836, -177, -467))); //1
	MONOPOL_PLACES.push(class_place(Enum_PLACE.NONE, Vector(-747, -177, -467))); //2
	MONOPOL_PLACES.push(class_place(Enum_PLACE.NONE, Vector(-666, -175, -467))); //3
	MONOPOL_PLACES.push(class_place(Enum_PLACE.QUESTION, Vector(-580, -181, -467))); //4
	MONOPOL_PLACES.push(class_place(Enum_PLACE.NONE, Vector(-498, -185, -467))); //5
	MONOPOL_PLACES.push(class_place(Enum_PLACE.QUESTION, Vector(-417, -184, -467))); //6
	MONOPOL_PLACES.push(class_place(Enum_PLACE.NONE, Vector(-331, -184, -467))); //7
	MONOPOL_PLACES.push(class_place(Enum_PLACE.NONE, Vector(-244, -183, -467))); //8
	MONOPOL_PLACES.push(class_place(Enum_PLACE.NONE, Vector(-157, -184, -467))); //9
	MONOPOL_PLACES.push(class_place(Enum_PLACE.JAIL, Vector(-69, -180, -467))); //10
	MONOPOL_PLACES.push(class_place(Enum_PLACE.NONE, Vector(-69, -78, -467))); //11
	MONOPOL_PLACES.push(class_place(Enum_PLACE.NONE, Vector(-69, 6, -467))); //12
	MONOPOL_PLACES.push(class_place(Enum_PLACE.NONE, Vector(-69, 84, -467))); //13
	MONOPOL_PLACES.push(class_place(Enum_PLACE.QUESTION, Vector(-69, 161, -467))); //14
	MONOPOL_PLACES.push(class_place(Enum_PLACE.NONE, Vector(-69, 239, -467))); //15
	MONOPOL_PLACES.push(class_place(Enum_PLACE.NONE, Vector(-69, 339, -467))); //16
	MONOPOL_PLACES.push(class_place(Enum_PLACE.NONE, Vector(-159, 339, -467))); //17
	MONOPOL_PLACES.push(class_place(Enum_PLACE.NONE, Vector(-246, 339, -467))); //18
	MONOPOL_PLACES.push(class_place(Enum_PLACE.NONE, Vector(-332, 339, -467))); //19
	MONOPOL_PLACES.push(class_place(Enum_PLACE.QUESTION, Vector(-416, 339, -467))); //20
	MONOPOL_PLACES.push(class_place(Enum_PLACE.NONE, Vector(-495, 339, -467))); //21
	MONOPOL_PLACES.push(class_place(Enum_PLACE.QUESTION, Vector(-581, 339, -467))); //22
	MONOPOL_PLACES.push(class_place(Enum_PLACE.NONE, Vector(-665, 339, -467))); //23
	MONOPOL_PLACES.push(class_place(Enum_PLACE.NONE, Vector(-751, 339, -467))); //24
	MONOPOL_PLACES.push(class_place(Enum_PLACE.NONE, Vector(-837, 339, -467))); //25
	MONOPOL_PLACES.push(class_place(Enum_PLACE.JAIL, Vector(-934, 339, -467))); //26
	MONOPOL_PLACES.push(class_place(Enum_PLACE.NONE, Vector(-934, 249, -467))); //27
	MONOPOL_PLACES.push(class_place(Enum_PLACE.NONE, Vector(-934, 165, -467))); //28
	MONOPOL_PLACES.push(class_place(Enum_PLACE.NONE, Vector(-934, 81, -467))); //29
	MONOPOL_PLACES.push(class_place(Enum_PLACE.QUESTION, Vector(-934, -1, -467))); //30
	MONOPOL_PLACES.push(class_place(Enum_PLACE.NONE, Vector(-934, -74, -467))); //31
	MONOPOL_PLACES.push(class_place(Enum_PLACE.FREE, Vector(-501, 91, -464))); //32

	MONOPOL_QUESTIONS.push(class_place("Реролл", "monopol_question_0")); //0
	MONOPOL_QUESTIONS.push(class_place("3 Клетки вперед", "monopol_question_1")); //1
	MONOPOL_QUESTIONS.push(class_place("Джайл", "monopol_question_2")); //2
	MONOPOL_QUESTIONS.push(class_place("На парковку", "monopol_question_3")); //3
	MONOPOL_QUESTIONS.push(class_place("Поменяйся местами", "monopol_question_4")); //4
	MONOPOL_QUESTIONS.push(class_place("3 Клетки назад", "monopol_question_5")); //5
	MONOPOL_QUESTIONS.push(class_place("Зек на килл", "monopol_question_6")); //6
	MONOPOL_QUESTIONS.push(class_place("Фридей", "monopol_question_7")); //7

	RollHandle = Entities.FindByName(null, "monopol_roller_cube");

	// local ent;
	// for (local i = 0; i <= 32; i++)
	// {
	// 	ent = Entities.FindByName(null, "point" + i);
	// 	if (ent == null //// !ent.IsValid())
	// 	{
	// 		printl("ERORR");
	// 		continue;
	// 	}
	// 	printl(format("MONOPOL_PLACES.push(class_place(Enum_PLACE.NONE, Vector(%i, %i, %i))); //%i", ent.GetOrigin().x, ent.GetOrigin().y, ent.GetOrigin().z, i));
	// }
}

function SelectPlayerButton(ID)
{
	local bFind = false;
	foreach (index, player in PLAYERS)
	{
		if (player.color == ID)
		{
			bFind = true;
			RollSelected = index;
			break;
		}
	}

	if (!bFind)
	{
		printl(format("Цвет не доступен"));
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
			printl(handle.tostring() + format(" Игрок уже в массиве. Цвет %s", MONOPOL_COLORS[player.color].name));
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
			color.free = false;
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

	RollStart = false;
	GameTicking = true;

	Tick();
}

function Tick()
{
	if (!GameTicking)
	{
		return;
	}

	Tick_PlaceDraw();

	Tick_ValidPlayers();

	Tick_Roll();

	Tick_Glow();

	Tick_Move();

	Tick_Question();

	EntFireByHandle(self, "RunScriptCode", "Tick()", TICKRATE, null, null);
}

function Tick_Question()
{
	if (!Question)
	{
		return;
	}


}

function Tick_Move()
{
	foreach (index, player in PLAYERS)
	{
		if (Question)
		{
			break;
		}

		player.Move();

		if (Question)
		{
			MONOPOL_QUESTIONSelect = index;
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
		if (PLAYERS[RollSelected].Valid())
		{
			RollSelected = PLAYERS[RollSelected].handle;
		}
		else
		{
			RollSelected = -1;
		}
	}

	if (MONOPOL_QUESTIONSelect != -1)
	{
		if (PLAYERS[MONOPOL_QUESTIONSelect].Valid())
		{
			MONOPOL_QUESTIONSelect = PLAYERS[MONOPOL_QUESTIONSelect].handle;
		}
		else
		{
			Question = false;
			MONOPOL_QUESTIONSelect = -1;
		}
	}

	local SaveArray = [];
	foreach (index, player in PLAYERS)
	{
		if (!player.Valid())
		{
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

	if (MONOPOL_QUESTIONSelect != -1)
	{
		foreach (index, player in PLAYERS)
		{
			if (player.handle == MONOPOL_QUESTIONSelect)
			{
				MONOPOL_QUESTIONSelect = index;
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


			PlayerMove(RollSelected, iValue);

			MONOPOL_COLORS[PLAYERS[RollSelected].color].Glow_Disable();
			RollSelected = -1;

			Rolling = false;
			RollEnd_Time = Time() + GLOWROLLEND_DELAY;

			local bReset = true;
			foreach (color in MONOPOL_COLORS)
			{
				if (color.IsFree())
				{
					continue;
				}

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

			foreach (color in MONOPOL_COLORS)
			{
				if (color.IsFree())
				{
					continue;
				}

				if (color.IsPass())
				{
					color.Glow_Disable();
					color.Glow_Enable(GLOWROLLEND_DELAY * 0.25);
					color.Glow_Disable(GLOWROLLEND_DELAY * 0.5);
					color.On(GLOWROLLEND_DELAY);
				}
			}
		}

		RollAng = vecAng;
	}
}

function Tick_Glow()
{
	if (!Rolling)
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
}

function StartRollButton()
{
	if (Question)
	{
		return;
	}

	if (RollSelected == -1)
	{
		printl(format("Выбранный игрок не доступен"));
		return;
	}

	if (!RollStart)
	{
		RollStart = true;

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
	return 1
}

function PlayerMove(ID, moves)
{
	PLAYERS[ID].SetMoves(moves);
}

function Reset()
{
	Question = false;
	RollStart = false;
	GameStart = false;
	PLAYERS.clear();

	foreach (color in MONOPOL_COLORS)
	{
		color.Reset();
	}
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

Init();