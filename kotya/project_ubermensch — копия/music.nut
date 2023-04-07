::Music_Script <- self.GetScriptScope();
::Music01 <- self;
::Music02 <- Entities.FindByName(null, "map_music02");

const TICKRATE = 0.5;
g_fTick <- 0.00;

::g_iDuration01 <- 0;
::g_iDuration02 <- 0;

::g_szNow01 <- null;
::g_szNow02 <- null;

::g_iTicks01 <- 0;
::g_iTicks02 <- 0;

::g_iVolume01 <- 0;
::g_iVolume02 <- 0;

::g_iDirection01 <- 0;
::g_iDirection02 <- 0;

::MUSIC <- [];

::class_music <- class
{
	szpath = "";
	duration = 0;
	repit = false;
	id = 0;

	function SetPath(_szpath)
	{
		this.id = MUSIC.len();
		this.szpath = _szpath;
		Music01.PrecacheScriptSound(this.szpath);
	}

	function SetDuration(_duration)
	{
		this.duration = 0.00 + _duration;
	}

	function GetID()
	{
		return this.id;
	}

	function SetRepit(_repit)
	{
		this.repit = _repit;
	}

	function GetRepit()
	{
		return this.repit;
	}

	function GetDuration()
	{
		return this.duration;
	}

	function GetPath()
	{
		return this.szpath;
	}
}

function Tick()
{
	if (g_fTick > Time())
	{
		return;
	}

	g_fTick = Time() + TICKRATE;

	if (g_szNow01 != null)
	{
		// printl("01 : " +g_iTicks01 + " : Volume " + g_iVolume01);

		g_iTicks01 -= TICKRATE;
		if (g_iDirection01 != 0)
		{
			if (g_iDirection01 == -1)
			{
				g_iVolume01--;
				if (g_iVolume01 <= 0)
				{
					g_iDirection01 = 0;
					ResetTrack01();
				}
				else
				{
					// printl("T1_Volume01 " + g_iVolume02);
					EF(Music01, "Volume", "" + g_iVolume01);
				}
			}
			else
			{
				g_iVolume01++;
				if (g_iVolume01 <= 10)
				{
					// printl("T2_Volume01 " + g_iVolume02);
					EF(Music01, "Volume", "" + g_iVolume01);
				}
				else
				{
					g_iVolume01 = 11;
					g_iDirection01 = 0;
				}
			}
		}
		else if (g_iTicks01 <= 0)
		{
			// printl("END01");
			local id = (g_szNow01.GetRepit() ? g_szNow01.GetID() : -1);
			ResetTrack01();
			if (id != -1)
			{
				CallFunction("PlayMusic(" + id+")", 0.05);
			}
		}
	}

	if (g_szNow02 != null)
	{
		// printl("02 : " +g_iTicks02 + " : Volume " + g_iVolume02);

		g_iTicks02 -= TICKRATE;
		if (g_iDirection02 != 0)
		{
			if (g_iDirection02 == -1)
			{
				g_iVolume02--;
				if (g_iVolume02 <= 0)
				{
					g_iDirection02 = 0;
					ResetTrack02();
				}
				else
				{
					// printl("T1_Volume02 " + g_iVolume02);
					EF(Music02, "Volume", "" + g_iVolume02);
				}
			}
			else
			{
				g_iVolume02++;
				if (g_iVolume02 <= 10)
				{
					// printl("T2_Volume02 " + g_iVolume02);
					EF(Music02, "Volume", "" + g_iVolume02);
				}
				else
				{
					g_iVolume02 = 11;
					g_iDirection02 = 0;
				}
			}
		}
		else if (g_iTicks02 <= 0)
		{
			// printl("END02");
			local id = (g_szNow02.GetRepit() ? g_szNow02.GetID() : -1);
			ResetTrack02();
			if (id != -1)
			{
				CallFunction("PlayMusic(" + id+")", 0.05);
			}
		}
	}
}

::ResetTrack01 <- function()
{
	// printl("R_Volume01 " + 0);
	g_iVolume01 = 0
	EF(Music01, "Volume", "" + g_iVolume01);
	EF(Music01, "StopSound");

	g_iTicks01 = 0;
	g_szNow01 = null;
}
::ResetTrack02 <- function()
{
	// printl("R_Volume02 " + 0);
	g_iVolume02 = 0;
	EF(Music02, "Volume", "" + g_iVolume02);
	EF(Music02, "StopSound");

	g_iTicks02 = 0;
	g_szNow02 = null;
}

/*
if (g_iVolume01 == 10)
		{
			local fTime = 0.00;
			for (local i = 0; i < 10; i++)
			{
				g_iVolume01--;
				EF(Music01, "Volume", "" + g_iVolume01, fTime);
				fTime += 0.15;
			}
		}
*/
::StopMusic <- function()
{
	// ScriptPrintMessageChatAll("Time01 : " + (Time() -  g_iDuration01));
	// ScriptPrintMessageChatAll("Time02 : " + (Time() -  g_iDuration02));
	g_iDuration01 = 0;
	g_iDuration02 = 0;

	g_iDirection01 = -1;
	g_iDirection02 = -1;
}

::PlayMusic <- function(ID)
{
	if (g_szNow01 == null)
	{
		g_iDirection01 = 1;
		g_iDirection02 = -1;
		if (g_szNow02 == null)
		{
			g_iVolume01 = 10;
		}
		// printl("01")

		g_iDuration01 = Time();
		g_szNow01 = MUSIC[ID];
		g_iTicks01 = MUSIC[ID].GetDuration();

		// printl("P_Volume01 " + 0);

		EF(Music01, "AddOutPut", "message " + MUSIC[ID].GetPath());
		EF(Music01, "PlaySound");
		// AOP(Music01, "message", MUSIC[ID].GetPath());

	}
	else if (g_szNow02 == null)
	{
		g_iDirection01 = -1;
		g_iDirection02 = 1;
		g_iVolume02 = 0;
		// printl("02")

		g_iDuration02 = Time();
		g_szNow02 = MUSIC[ID];
		g_iTicks02 = MUSIC[ID].GetDuration();

		// printl("P_Volume02 " + 0);

		EF(Music02, "AddOutPut", "message " + MUSIC[ID].GetPath());
		EF(Music02, "PlaySound");
		// AOP(Music02, "message", MUSIC[ID].GetPath());

		// EF(Music02, "Volume", "" + (g_iVolume02 = 10));
	}
	else
	{
		EF(Music01, "StopSound");

		g_iDirection01 = 1;
		g_iDirection02 = -1;
		g_iVolume01 = 0;
		// printl("01")

		g_iDuration01 = Time();
		g_szNow01 = MUSIC[ID];
		g_iTicks01 = MUSIC[ID].GetDuration();

		// printl("P_Volume01 " + 0);

		EF(Music01, "AddOutPut", "message " + MUSIC[ID].GetPath());
		EF(Music01, "PlaySound");
		// AOP(Music01, "message", MUSIC[ID].GetPath());

		// EF(Music01, "Volume", "" + (g_iVolume02 = 10));
	}
}

function Init()
{
	MUSIC.clear();

	local obj;

	// 0
	obj = class_music();
	obj.SetPath("music/fight01.mp3");
	obj.SetDuration(118);
	MUSIC.push(obj);

	// 1
	obj = class_music();
	obj.SetPath("music/chapter01_start.mp3");
	obj.SetDuration(295);
	obj.SetRepit(true);
	MUSIC.push(obj);

	// 2
	obj = class_music();
	obj.SetPath("music/chapter01_lift.mp3");
	obj.SetDuration(20);
	MUSIC.push(obj);

	// 3
	obj = class_music();
	obj.SetPath("music/chapter01_last.mp3");
	obj.SetDuration(184);
	MUSIC.push(obj);

	// 4
	obj = class_music();
	obj.SetPath("music/chapter02_start.mp3");
	obj.SetDuration(122);
	obj.SetRepit(true);
	MUSIC.push(obj);

	// 5
	obj = class_music();
	obj.SetPath("music/chapter02_metro.mp3");
	obj.SetDuration(119);
	obj.SetRepit(true);
	MUSIC.push(obj);

	// 6
	obj = class_music();
	obj.SetPath("music/chapter02_last.mp3");
	obj.SetDuration(90);
	MUSIC.push(obj);

	// 7
	obj = class_music();
	obj.SetPath("music/chapter03_start.mp3");
	obj.SetDuration(193);
	obj.SetRepit(true);
	MUSIC.push(obj);

	// 8
	obj = class_music();
	obj.SetPath("music/chapter03_worms.mp3");
	obj.SetDuration(133);
	obj.SetRepit(true);
	MUSIC.push(obj);

	ResetTrack02();
	ResetTrack01();

	g_ahGlobal_Tick.push(self);
}

// Init();
CallFunction("Init()", 2.5);