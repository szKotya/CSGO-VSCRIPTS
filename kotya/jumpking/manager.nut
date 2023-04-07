const TICKRATE = 0.05;

::PLAYERS <- [];
::START_ORIGIN <- Vector(-8912, -736, -14896);
::SPRITE_ORIGIN <- Vector(-8912, 0, -14860);
::GAME_ANG <- Vector(0, 90, 0);

::WeaponStrip <-  null;
::SpriteMaker <-  null;
::SpriteTemp <- null;
::SpeedMod <- null;

const DEFAULT_JUMP_TIME_MAX = 0.8;
const DEFAULT_JUMP_BOOST = 765;

::JUMP_TIME_MAX <- 1;
::JUMP_BOOST <- 1;

enum Enum_Side
{
	Left = 0,
	Right = 1,
}

enum Enum_AnimStatus
{
	stayleft, //[13-22-23-24-25]
	stayright, //[0-9-10-11-12]

	runleft, //14-15-16
	runright, //1-2-3

	jump, //4
	jumpright, //5
	jumpleft, //18

	fallright, //6
	fallleft, //19

	fullfallright, //7
	fullfallleft, //20

	bounceright, //8
	bounceleft, //21
}

class class_player
{
	handle = null;
	viewmodel = null;

	sprite = null;
	sprite_toggler = null;

	anim_status = Enum_AnimStatus.jump;
	anim_buffer_back = null;
	anim_buffer = null;
	anim_rate_back = 0.0;
	anim_rate = 0.0;

	side = Enum_Side.Left;
	moving = false;
	jumping = false;
	jump_time = 0.0;
	crounched = false;
	grounded = false;

	constructor (_handle)
	{
		this.anim_buffer_back = [];
		this.anim_buffer = [];

		this.handle = _handle;
		this.handle.SetOrigin(START_ORIGIN);
		this.handle.SetAngles(GAME_ANG.x, GAME_ANG.y, GAME_ANG.z);
		this.handle.SetForwardVector(Vector(0, 1, 0));

		EntFireByHandle(this.handle, "AddOutPut", "MoveType 0", 0, null, null);
		EntFireByHandle(this.handle, "AddOutPut", "MoveType 2", 1.0, null, null);

		EntFireByHandle(this.handle, "AddOutPut", "gravity 1.0", 0, null, null);
		EntFireByHandle(SpeedMod, "ModifySpeed", "1.0", 0, this.handle, this.handle);

		EntFireByHandle(WeaponStrip, "Strip", "", 0, this.handle, this.handle);
		// EntFireByHandle(this.handle, "SetHUDVisibility", "0", 0, null, null);

		SpriteTemp.GetScriptScope().CreateSprite(this);

		local viewmodel;
		while ((viewmodel = Entities.FindByClassname(viewmodel, "predicted_viewmodel*")) != null)
		{
			if (viewmodel.GetRootMoveParent() == this.handle)
			{
				this.viewmodel = viewmodel;
				EntFireByHandle(this.viewmodel, "DisableDraw", "", 0, null, null);
				break;
			}
		}
	}

	function IsValid()
	{
		return (this.handle != null &&
		this.handle.IsValid() &&
		this.handle.GetHealth() > 0);
	}

	function SetSprite(_sprite, _sprite_toggler)
	{
		this.sprite = _sprite;
		this.sprite_toggler = _sprite_toggler;

		this.sprite.SetOrigin(SPRITE_ORIGIN);
		EntFireByHandle(this.sprite, "SetParent", "!activator", 1.00, this.handle, this.handle);
	}

	function Tick_Status()
	{
		this.grounded = (TraceLine(this.handle.GetCenter(), this.handle.GetOrigin() - Vector(0, 0, 24), null) != 1.00 ||
		TraceLine(this.handle.GetCenter() - Vector(15, 0, 0), this.handle.GetOrigin() - Vector(15, 0, 24), null) != 1.00 ||
		TraceLine(this.handle.GetCenter() - Vector(-15, 0, 0), this.handle.GetOrigin() - Vector(-15, 0, 24), null) != 1.00);
		this.crounched = (this.handle.GetBoundingMaxs().z < 72);

		this.moving = false;
		if (this.grounded)
		{
			if (this.jumping)
			{
				if (this.crounched)
				{
					this.jump_time += TICKRATE;
					if (this.jump_time >= JUMP_TIME_MAX)
					{
						this.jump_time = JUMP_TIME_MAX;
						this.jumping = false;
					}
				}
				else
				{
					this.jumping = false;
				}

				if (!this.jumping)
				{
					EntFireByHandle(SpeedMod, "ModifySpeed", "1.0", 0, this.handle, this.handle);

					local vel = this.handle.GetVelocity();
					if (vel.x > 0.01)
					{
						vel = 250;
					}
					else if (vel.x < -0.01)
					{
						vel = -250;
					}
					else
					{
						vel = 0;
					}

					vel = Vector(vel, 0, this.jump_time * JUMP_BOOST);
					printl("JUMO " + vel);

					this.handle.SetVelocity(vel);
					this.jump_time = 0.0;
					this.crounched = false;
				}
			}
			else
			{
				if (this.crounched)
				{
					EntFireByHandle(SpeedMod, "ModifySpeed", "0.1", 0, this.handle, this.handle);
					this.jumping = true;
				}
				else
				{
					local vel = this.handle.GetVelocity();
					if (vel.x < -10)
					{
						this.moving = true;
						this.side = Enum_Side.Left;
					}
					else if (vel.x > 10)
					{
						this.moving = true;
						this.side = Enum_Side.Right;
					}
				}
			}
		}


		local message = "";
		message += "Side: " + this.side;
		message += "\nMoving: " + this.moving;
		message += "\nCrounched: " + this.crounched;
		message += "\nJumping: " + this.jumping;
		message += "\nGrounded: " + this.grounded;
		message += "\nVel: " + this.handle.GetVelocity();
		message += "\nOr: " + this.handle.GetCenter();
		message += "\nD: " + this.handle.GetBoundingMaxs().z;
		ScriptPrintMessageCenterAll(message)
	}

	function Tick_Animation()
	{
		if (this.grounded)
		{
			if (this.jumping)
			{
				if (this.anim_status != Enum_AnimStatus.jump)
				{
					EntFireByHandle(this.sprite_toggler, "SetMaterialVar", "4", 0, null, null);
				}
				this.anim_status = Enum_AnimStatus.jump;
			}
			else if (this.moving)
			{
				if (this.side == Enum_Side.Left)
				{

				}
				else
				{

				}
			}
			else
			{
				if (this.side == Enum_Side.Left)
				{
					if (this.anim_status != Enum_AnimStatus.stayleft)
					{
						local anim = [13, 22, 23, 24, 25];
						EntFireByHandle(this.sprite_toggler, "SetMaterialVar", "" + anim[RandomInt(0, anim.len()-1)], 0, null, null);
					}
					this.anim_status = Enum_AnimStatus.stayleft;
				}
				else
				{
					if (this.anim_status != Enum_AnimStatus.stayright)
					{
						local anim = [0, 9, 10, 11, 12];
						EntFireByHandle(this.sprite_toggler, "SetMaterialVar", "" + anim[RandomInt(0, anim.len()-1)], 0, null, null);
					}
					this.anim_status = Enum_AnimStatus.stayright;
				}
			}
		}
		else
		{

		}
	}

	function SetAngles(x, y, z)
	{
		this.handle.SetAngles(x, y, z);
	}

	function Draw()
	{
		// DebugDrawLine(this.sprite.GetOrigin(), this.sprite.GetOrigin() + Vector(0, 0, 90), 255, 255, 255, true, 0.1)
	}
}

function CreatePlayer()
{
	local handle = activator;
	local obj = class_player(handle);

	PLAYERS.push(obj);
}

function Start()
{
	WeaponStrip = Entities.CreateByClassname("player_weaponstrip");
	SpeedMod = Entities.CreateByClassname("player_speedmod");
	SpeedMod.__KeyValueFromInt("spawnflags", 4);

	SpriteMaker = Entities.CreateByClassname("env_entity_maker");
	SpriteTemp = Entities.FindByName(null, "player_temp");

	SpriteMaker.__KeyValueFromString("EntityTemplate", "player_temp");
	SpriteTemp.ValidateScriptScope();

	SpriteTemp.GetScriptScope().TEMP_LOGIC <- null;
	SpriteTemp.GetScriptScope().CreateSprite <- function(logic)
	{
		TEMP_LOGIC = logic;
		SpriteMaker.SpawnEntityAtLocation(Vector(), Vector());
	}
	SpriteTemp.GetScriptScope().PreSpawnInstance <- function(entityClass, entityName)
	{
		return {};
	}
	SpriteTemp.GetScriptScope().PostSpawn <- function(entities)
	{
		local sprite;
		local sprite_toggler;
		foreach (entity in entities)
		{
			if (entity.GetClassname() == "func_physbox_multiplayer")
			{
				sprite = entity;
			}
			else if (entity.GetClassname() == "material_modify_control")
			{
				sprite_toggler = entity;
			}
		}
		TEMP_LOGIC.SetSprite(sprite, sprite_toggler);
	}
	JUMP_TIME_MAX = DEFAULT_JUMP_TIME_MAX
	JUMP_BOOST = DEFAULT_JUMP_BOOST

	JUMP_BOOST = JUMP_BOOST / JUMP_TIME_MAX;

	Tick();
}

function Tick()
{
	EntFireByHandle(self, "RunScriptCode", "Tick()", TICKRATE, null, null);

	Tick_Valid();
	if (PLAYERS.len() < 1)
	{
		return;
	}
	Tick_View();
	Tick_Status();
	// Tick_Animation();
}

function Tick_Valid()
{
	local removearray = [];
	foreach (index, player in PLAYERS)
	{
		if (!player.IsValid())
		{
			removearray.push(index);
			continue;
		}
		player.Draw();
	}
	removearray.reverse();
	foreach (value in removearray)
	{
		PLAYERS.remove(value);
	}
}

function Tick_View()
{
	foreach (player in PLAYERS)
	{
		player.SetAngles(GAME_ANG.x, GAME_ANG.y, GAME_ANG.z);
	}
}

function Tick_Status()
{
	foreach (player in PLAYERS)
	{
		player.Tick_Status();
	}
}

function Tick_Animation()
{
	foreach (player in PLAYERS)
	{
		player.Tick_Animation();
	}
}



::GetPlayerClassByPlayer <- function(_handle)
{

	foreach (playerclass in PLAYERS)
	{
		if (playerclass.handle == _handle)
		{
			return playerclass;
		}
	}
	return null;
}