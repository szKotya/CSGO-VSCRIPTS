
function Trigger_City_Gate()
{
	local timer = 10.0
	local text;

	text = "City gates open in "+timer+" seconds"
	ServerChat(Chat_pref + text);

	EntFire("City_Gate", "Open", "", timer);
	if(Stage == 4 || Stage == 5)
	{
		EntFire("explosion", "RunScriptCode", "CreateExplosion(Vector(2846,-3937,136),350,500)", timer - 0.1);
		EntFire("City_Gate", "Kill", "", timer - 0.05);
		EntFire("Temp_City_Gate", "ForceSpawn", "", timer);
	}
}

function Trigger_Left_Side_Path()
{
	local timer = 12.0
	local text;

	text = "The path open in "+timer+" seconds"
	ServerChat(Chat_pref + text);

	EntFire("Hold1_0_Clip", "Break", "", timer);

	EntFire("explosion", "RunScriptCode", "CreateExplosion(Vector(1706,-4718,907),180,99)", timer - 0.1);
}

function Trigger_Right_Side_Path()
{
	local timer = 13.0
	local text;

	text = "The path open in "+timer+" seconds"
	ServerChat(Chat_pref + text);

	EntFire("Hold1_2_Clip", "Break", "", timer);

	EntFire("explosion", "RunScriptCode", "CreateExplosion(Vector(1455,-2230,976),180,99)", timer - 0.1);
}

function Trigger_Cave_Bar_Lower_Path()
{
	local timer = 5.0
	local text;

	text = "The path open in "+timer+" seconds"
	ServerChat(Chat_pref + text);

	EntFire("Hold1_1_Clip", "Break", "", timer);

	EntFire("explosion", "RunScriptCode", "CreateExplosion(Vector(-138,-1130,512),80,99)", timer - 0.1);
}

function Trigger_Cave_Bar_Up_Path()
{
	local timer = 4.0
	local text;

	text = "We are almost at Cosmo Canyon"
	ServerChat(Chat_pref + text);

	EntFire("Hold1_Clip", "Break", "", timer);

	EntFire("explosion", "RunScriptCode", "CreateExplosion(Vector(-791,-862,1088),84,80)", timer - 0.1);
}

function Trigger_CosmoBar()
{
	if(Stage == 1)
	{
		local text;
		text = "it's been a while since you were kidnapped, Red";
		ServerChat(OldMan_pref + text, 10);

		text = "I am glad to see that you made it in one piece, even if there wasn't much hope";
		ServerChat(OldMan_pref + text, 13);

		text = "It would not have been possible without the help of these guys, and now we travel together";
		ServerChat(RedX_pref + text, 16);

		text = "Is there anything we could do before we leave?";
		ServerChat(RedX_pref + text, 19);

		text = "I'm worried about Gi's cave. Your father sacrificed himself a long time ago to protect the village.";
		ServerChat(OldMan_pref + text, 22);

		text = "It appears like the ancient evil has been awakened";
		ServerChat(OldMan_pref + text, 25);

		text = "Ok, let us scope out the severity of this evil";
		ServerChat(RedX_pref + text, 28);

		text = "I will be waiting for you guys at the observatories, good luck!";
		ServerChat(RedX_pref + text, 31);

		text = "Ghosts don't exist... right?";
		ServerChat(Tifa_pref + text, 35);

		text = "You don't know my village well.";
		ServerChat(RedX_pref + text, 38);

		text = "To be honest, I don't know you either";
		ServerChat(Tifa_pref + text, 41);

		text = "This place used to be my home three years ago before Shinra soldiers took me away";
		ServerChat(RedX_pref + text, 44);

		text = "I have been a lab rat since then";
		ServerChat(RedX_pref + text, 47);

		text = "Sorry, but I can't get used to you talking, not to mention about how I am terrified of ghosts.";
		ServerChat(Tifa_pref + text, 50);

		text = "Don't worry; we have plenty of time to get to know each other";
		ServerChat(RedX_pref + text, 53);

		text = "Agreed";
		ServerChat(Tifa_pref + text, 56);
	}
	if(Stage == 1 || Stage == 2)
	{
		local text;

		text = "The barman will open the door in 10 seconds"
		ServerChat(Chat_pref + text);

		text = "Zombies are coming. Defend Cosmo Bar for 32 seconds before we open the back door"
		ServerChat(Chat_pref + text, 7);

		text = "5 SECONDS LEFT"
		ServerChat(Chat_pref + text, 27);

		text = "FALL BACK"
		ServerChat(Chat_pref + text, 32);

		EntFire("Hold2_Door", "Open", "", 10.00);
		EntFire("Cosmo_Bar_Glasses", "Break", "", 12.00);

		EntFire("Hold3_Door", "Open", "", 32.00);
		EntFire("Hold3_Vent", "Break", "", 34.00);

		EntFire("UpVillage_Border", "Kill", "", 35.00);
		EntFire("UpVillage_Border_fence", "Kill", "", 42.00);
	}
	else if(Stage == 4 || Stage == 5)
	{
		local text;

		text = "The barman will open the door in 5 esconds"
		ServerChat(Chat_pref + text);

		text = "Zombies are coming. Defend Cosmo Bar for 42 seconds before we open the back door";
		ServerChat(Chat_pref + text, 7);

		text = "5 SECONDS LEFT"
		ServerChat(Chat_pref + text, 37);

		text = "FALL BACK"
		ServerChat(Chat_pref + text, 42);

		EntFire("Hold2_Door", "Open", "", 4.50);
		EntFire("Hold2_Door", "Kill", "", 5.00);
		EntFire("Cosmo_Bar_Glasses", "Break", "", 5.00);

		EntFire("explosion", "RunScriptCode", "CreateExplosion(Vector(-1549,-1103,1193),228,100,true)", 5.00);
		EntFire("explosion", "RunScriptCode", "CreateExplosion(Vector(-1550,-1295,1193),228,100,true)", 5.01);
		EntFire("lvl3_Break", "Break", "", 5.03);
		if(Stage == 5)
		{
			EntFire("explosion", "RunScriptCode", "CreateExplosion(Vector(-1828,-1224,1669),228,100,true)", 10.01);
			EntFire("lvl4_Break", "Break", "", 10.00);
		}

		EntFire("Cosmo_Bar_Door", "Kill", "", 5.00);
		EntFire("Hold3_Door", "Open", "", 42.00);
		EntFire("Hold3_Vent", "Break", "", 44.00);

		EntFire("UpVillage_Border", "Kill", "", 45.00);
		EntFire("UpVillage_Border_fence", "Kill", "", 51.00);
	}

	EntFire("Map_TP_1", "Enable", "", 40.00);

	{
		EntFire("info_perk_hp_hm", "Kill", "", 40.00);
		EntFire("shop_perk_hp_hm", "Kill", "", 40.00);

		EntFire("info_perk_resist_hm", "Kill", "", 40.00);
		EntFire("shop_perk_resist_hm", "Kill", "", 40.00);

		EntFire("info_perk_luck", "Kill", "", 40.00);
		EntFire("shop_perk_luck", "Kill", "", 40.00);

		EntFire("info_perk_huckster", "Kill", "", 40.00);
		EntFire("shop_perk_huckster", "Kill", "", 40.00);

		EntFire("info_perk_steal", "Kill", "", 40.00);
		EntFire("shop_perk_steal", "Kill", "", 40.00);

		EntFire("info_perk_hp_zm", "Kill", "", 40.00);
		EntFire("shop_perk_hp_zm", "Kill", "", 40.00);

		EntFire("info_perk_speed", "Kill", "", 40.00);
		EntFire("shop_perk_speed", "Kill", "", 40.00);

		EntFire("info_perk_chameleon", "Kill", "", 40.00);
		EntFire("shop_perk_chameleon", "Kill", "", 40.00);

		EntFire("info_perk_resist_zm", "Kill", "", 40.00);
		EntFire("shop_perk_resist_zm", "Kill", "", 40.00);

		EntFire("perk_reset", "Kill", "", 40.00);

		EntFire("info_item_buff_radius", "Kill", "", 40.00);
		EntFire("shop_item_buff_radius", "Kill", "", 40.00);

		EntFire("info_item_buff_last", "Kill", "", 40.00);
		EntFire("shop_item_buff_last", "Kill", "", 40.00);

		EntFire("info_item_buff_double", "Kill", "", 40.00);
		EntFire("shop_item_buff_double", "Kill", "", 40.00);

		EntFire("info_item_buff_turbo", "Kill", "", 40.00);
		EntFire("shop_item_buff_turbo", "Kill", "", 40.00);

		EntFire("info_item_buff_reset", "Kill", "", 40.00);
		EntFire("shop_item_buff_reset", "Kill", "", 40.00);

		EntFire("info_item_buff_recovery", "Kill", "", 40.00);
		EntFire("shop_item_buff_recovery", "Kill", "", 40.00);


		EntFire("info_item_gravity", "Kill", "", 40.00);
		EntFire("shop_item_gravity", "Kill", "", 40.00);

		EntFire("info_item_summon", "Kill", "", 40.00);
		EntFire("shop_item_summon", "Kill", "", 40.00);

		EntFire("info_item_earth", "Kill", "", 40.00);
		EntFire("shop_item_earth", "Kill", "", 40.00);

		EntFire("info_item_wind", "Kill", "", 40.00);
		EntFire("shop_item_wind", "Kill", "", 40.00);

		EntFire("info_item_heal", "Kill", "", 40.00);
		EntFire("shop_item_heal", "Kill", "", 40.00);

		EntFire("info_item_ultimate", "Kill", "", 40.00);
		EntFire("shop_item_ultimate", "Kill", "", 40.00);

		EntFire("info_item_poison", "Kill", "", 40.00);
		EntFire("shop_item_poison", "Kill", "", 40.00);

		EntFire("info_item_fire", "Kill", "", 40.00);
		EntFire("shop_item_fire", "Kill", "", 40.00);

		EntFire("info_item_bio", "Kill", "", 40.00);
		EntFire("shop_item_bio", "Kill", "", 40.00);

		EntFire("info_item_ice", "Kill", "", 40.00);
		EntFire("shop_item_ice", "Kill", "", 40.00);

		EntFire("info_item_electro", "Kill", "", 40.00);
		EntFire("shop_item_electro", "Kill", "", 40.00);
	}

	EntFire("shop_travel_trigger", "Kill", "", 40.00);
	EntFire("shop_stock", "Kill", "", 40.00);
	EntFire("shop_reroll", "Kill", "", 40.00);

	EntFire("kojima_main_trigger", "Kill", "", 40.00)

	EntFire("City_Spawn_Doorv2", "Kill", "", 40.00);
	EntFire("City_Spawn_Door", "Kill", "", 40.00);
}

function Trigger_Rock()
{
	local text;

	EntFire("Hold4_Bomb_Sprite", "FireUser1", "", 0);
	if(Stage == 4 || Stage == 5)
		EntFire("lvl3_Wood_Door", "Break", "", 0);

	if(Stage == 1)
		EntFire("Hold5_Rock", "Kill", "", 0);

	if(Stage == 2)
	{
		text = "I wonder why locals are so cautious. Kaktuars are a peaceful kind";
		ServerChat(Tifa_pref + text, 30.00);

		text = "it's no ordinary Kaktuar. There are myths that there is a legendary kaktuar that can walk";
		ServerChat(RedX_pref + text, 33.00);

		text = "That legendary kaktuar attacks everyone indiscriminately.";
		ServerChat(RedX_pref + text, 36.00);
	}

	local timer = 0;
	if(Stage == 2)
		timer = 1;
	if(Stage == 4)
		timer = 4;
	if(Stage == 5)
		timer = 5;

	text = "The explosives will blow the rocks up in " + (20 + timer) + " seconds"
	ServerChat(Chat_pref + text);

	text = "5 SECONDS LEFT"
	ServerChat(Chat_pref + text, 15 + timer);

	text = "FALL BACK"
	ServerChat(Chat_pref + text, 20 + timer);

	EntFire("Hold4_Bomb_Sprite", "AddOutput", "OnUser1 Hold4_Bomb_Sprite:ToggleSprite::0.3:-1", 15 + timer);
	EntFire("Hold4_Bomb_Sprite", "AddOutput", "OnUser1 Hold4_Bomb_Sprite:ToggleSprite::0.5:-1", 15 + timer);
	EntFire("Hold4_Bomb_Sprite", "AddOutput", "OnUser1 Hold4_Bomb_Sprite:ToggleSprite::0.6:-1", 20 + timer);
	EntFire("Hold4_Bomb_Sprite", "AddOutput", "OnUser1 Hold4_Bomb_Sprite:ToggleSprite::0.8:-1", 20 + timer);
	EntFire("Hold4_Rock", "Break", "", 20.05 + timer);

	EntFire("Hold4_Clip", "Kill", "", 20.05 + timer);
	EntFire("Hold4_Bomb_Sprite", "Kill", "", 20.05 + timer);
	EntFire("Hold4_Bomb", "Kill", "", 20.05 + timer);

	EntFire("explosion", "RunScriptCode", "CreateExplosion(Vector(-4698,-3752,1870),256,100)", 20 + timer);
	EntFire("explosion", "RunScriptCode", "CreateExplosion(Vector(-4620,-4268,1758),228,100)", 20.01 + timer);
	EntFire("explosion", "RunScriptCode", "CreateExplosion(Vector(-4718,-4333,2159),228,100)", 20.02 + timer);

	EntFire("music", "RunScriptCode", "GetMusicExplosion();", 20.05 + timer);

	EntFire("City_Gate", "Kill", "", 0.00);
	EntFire("perk_particle", "Kill", "", 0.00);
	EntFire("Text", "Kill", "", 0.00);
	EntFire("Spawn_props", "Kill", "", 0.00);
	EntFire("City_Gate_Open", "Kill", "", 0.00);
	EntFire("Ship_break", "Kill", "", 0.00);
	EntFire("Hold1*", "Kill", "", 0);

	EntFire("Map_TD", "AddOutput", "origin -2680 -1296 1228", 0.00);
	EntFire("Map_TP_2", "Enable", "", 1.00);
}

function Trigger_Cave_First()
{
	local text;

	text = "The gates will open in 25 seconds"
	ServerChat(Chat_pref + text);

	text = "5 SECONDS LEFT"
	ServerChat(Chat_pref + text, 20);

	text = "FALL BACK"
	ServerChat(Chat_pref + text, 25);

	if(Stage == 1)
	{
		text = "It's amazing how much equipment you managed to fit into a single cave"
		ServerChat(Tifa_pref + text, 5);

		text = "Well, we only equipped the upper level. The lower levels are the forbidden territory."
		ServerChat(RedX_pref + text, 10);

		text = "Is there an evil ghost dwelling there?"
		ServerChat(Tifa_pref + text, 15);

		text = "I hope it's just part of the old man's imagination."
		ServerChat(RedX_pref + text, 20);
	}
	else if(Stage == 4)
	{
		text = "We can't beat him in his current form; His real body is located somehwere else."
		ServerChat(RedX_pref + text, 5);

		text = "We need to deal with his illusion before revealing his real body."
		ServerChat(RedX_pref + text, 10);

		text = "Why am I being told this now?"
		ServerChat(Tifa_pref + text, 15);

		text = "The last time we ran out of the cave, I heard him laugh at the Cape of Rebirth."
		ServerChat(RedX_pref + text, 20);

		text = "I thought it was only me that thought of that, but his main body has been there all this time."
		ServerChat(RedX_pref + text, 25);

		text = "What is this Cape of Rebirth that you speak of?"
		ServerChat(Tifa_pref + text, 30);

		text = "You will find out very soon"
		ServerChat(RedX_pref + text, 35);
	}

	EntFire("Map_TD", "AddOutput", "angles 0 180 0", 10);
	EntFire("Map_TD", "AddOutput", "origin -5774 -3668 1889", 10);

	EntFire("Hold5_Door", "Open", "", 25);
}

function Trigger_Cave_Second()
{
	local text;

	text = "The gates of gi cave will open in 15 seconds"
	ServerChat(Chat_pref + text);

	text = "5 SECONDS LEFT"
	ServerChat(Chat_pref + text, 10);

	text = "FALL BACK"
	ServerChat(Chat_pref + text, 15);

	EntFire("Hold5_Door1", "Open", "", 15);

	EntFire("explosion", "RunScriptCode", "CreateExplosion(Vector(-5111,-1827,1922),228,100)", 29.99);
	EntFire("cave_skip", "Break", "", 30);
	EntFire("explosion", "RunScriptCode", "CreateExplosion(Vector(-4450,-1515,566),228,100)", 29.99);
	EntFire("Skip_Wall", "Toggle", "", 30);

	EntFire("Map_TD", "AddOutput", "origin -6414 -2240 2036", 0);
	EntFire("Map_TP_3", "Enable", "", 0.5);

	//EntFireByHandle(self, "RunScriptCode", "Bhop_Toggle(true, true);", 17, null, null);
}

function Trigger_Cave_Third()
{
	local text;

	text = "Wait until something happens"
	ServerChat(Chat_pref + text);

	EntFire("Hold6_Move", "Open", "", 15);

	if(Stage == 2 || Stage == 4 || Stage == 5)
	{
		EntFire("explosion", "RunScriptCode", "CreateExplosion(Vector(-2646,-704,432),228,100)", 17);
		EntFire("Hold6_Rock1", "Disable", "", 17.01);
		EntFire("Hold6_Rock1_wall", "Toggle", "", 17.01);

		EntFire("explosion", "RunScriptCode", "CreateExplosion(Vector(-3157,753,553),228,100)", 22);
		EntFire("Hold6_Rock", "Disable", "", 22.01);
		EntFire("Hold6_Rock_wall", "Toggle", "", 22.01);
	}
	else
	{
		EntFire("Hold7_Rock", "Kill", "", 0);
	}
	if(Stage == 4)
	{
		EntFire("Temp_Extreme", "ForceSpawn", "", 15);
	}

	if(Stage == 4 || Stage == 5)
	{
		EntFire("explosion", "RunScriptCode", "CreateExplosion(Vector(-1169,300,373),228,100)", 20);
		EntFire("lvl3_Wall", "Kill", "", 20.01);
	}

	EntFire("Gi_Cave_TP", "Kill", "", 0);

	EntFire("Map_TD", "AddOutput", "angles 0 90 0", 25);
	EntFire("Map_TD", "AddOutput", "origin -3810 -144 356", 25);
	EntFire("Map_TP_4", "Enable", "", 26);
}

function Trigger_Cave_Last()
{
	local text;
	local timer = 0;
	if(Stage != 1)
	{
		timer = 10;
	}

	text = "The gi gate will open in " + (25 + timer) + " seconds"
	ServerChat(Chat_pref + text);

	text = "5 SECONDS LEFT"
	ServerChat(Chat_pref + text, 20 + timer);

	text = "FALL BACK"
	ServerChat(Chat_pref + text, 25 + timer);

	EntFire("Boss_Dicks_Move", "Open", "", 0);
	EntFire("Hold7_Break_Anim", "FireUser1", "", 20 + timer);

	EntFire("Hold5_Door1", "Close", "", 25 + timer);
	EntFire("Hold5_Door", "Close", "", 25 + timer);

	EntFire("Hold7_Break", "Break", "", 25 + timer);

	EntFire("Map_TD", "AddOutput", "angles 5 -84 0", 5);
	EntFire("Map_TD", "AddOutput", "origin -2934 696 575", 5);
}

function Trigger_Cave_Boss_Start()
{
	if(Stage == 1)
	{
		local text;
		text = "Is that a real ghost?"
		ServerChat(Tifa_pref + text, 20);

		text = "Well, we only equipped its top. Below is the forbidden territory."
		ServerChat(RedX_pref + text, 22);

		text = "Then it's time to warm up."
		ServerChat(Tifa_pref + text, 24);
	}
	else if(Stage == 2)
	{
		local text;
		text = "This time, you won't get away."
		ServerChat(RedX_pref + text, 20);
	}
	if(Stage == 1 || Stage == 2 || Stage == 4)
	{
		EntFire("Temp_Gi_Nattak", "ForceSpawn", "", 5);
		EntFire("Temp_Gi_Nattak", "RunScriptCode", "Init();", 5.01);
	}
	if(Stage == 5)
	{

	}
}

function Trigger_Cave_After_Boss()
{
	local text;

	text = "Now you can get out of Cave of Gi"
	ServerChat(Chat_pref + text, 6.5);

	EntFire("Map_Shake", "StartShake", "", 0);
	EntFire("Map_Shake_7_Sec", "StartShake", "", 12);

	EntFire("Boss_Cage", "Kill", "", 6.5);
	EntFire("Boss_ZM_Dicks_Move", "Open", "", 5);

	EntFire("Skip_Wall", "Toggle", "", 5);

	if(Stage == 2 || Stage == 4 || Stage == 5)
	{
		EntFire("Hold_End_Button", "UnLock", "", 0);//?

		EntFire("Hold6_Rock", "Enable", "", 0);
		EntFire("Hold6_Rock_wall", "Toggle", "", 0);

		EntFire("Hold6_Rock1", "Enable", "", 0);
		EntFire("Hold6_Rock1_wall", "Toggle", "", 0);

		EntFire("Hold_End_Ladder_Model", "Enable", "", 0);
		EntFire("Hold_End_Ladder_Wall", "Toggle", "", 0);
	}

	if(Stage == 1)
	{
		text = "We won. Right?"
		ServerChat(Tifa_pref + text, 5);

		text = "I think he vanished. But I'm not sure about how I feel about this."
		ServerChat(RedX_pref + text, 8);

		text = "Then let's hurry to the observatory"
		ServerChat(Tifa_pref + text, 11);

		EntFire("Normal_Crates_End", "Enable", "", 25);
		EntFire("Normal_End_Wall", "Toggle", "", 25);
		EntFire("s1_Ladder_Model", "Kill", "", 25);
		EntFire("s1_Ladder", "Kill", "", 25);

		EntFire("Nigger", "AddOutPut", "origin -4634 -2544 1970", 0);
		EntFire("Nigger", "AddOutPut", "angles -90 346 0", 0)
		EntFire("Nigger", "SetAnimation", "idle", 0);
		EntFire("Nigger", "SetDefaultAnimation", "idle", 0);
	}
	else if(Stage == 2)
	{
		text = "Damn, that wasn't an easy one"
		ServerChat(Tifa_pref + text, 5);

		text = "I am concerned with the fact that he looked different."
		ServerChat(RedX_pref + text, 8);

		text = "What do you mean?"
		ServerChat(Tifa_pref + text, 11);

		text = "Just some random thoughts. Excellent job fellas, how about a quick trip to the bar?"
		ServerChat(RedX_pref + text, 14);

		text = "I will pass on that offer."
		ServerChat(Tifa_pref + text, 17);
	}
	else if(Stage == 4)
	{
		text = "Great, now we need to get out of the cave and reach his main body."
		ServerChat(RedX_pref + text, 5);

		text = "What do you think about the final battle? You think we can manage it?"
		ServerChat(Tifa_pref + text, 8);

		text = "I doubt it. He is using all his power to create an illusion. I think we will need to beat him fast"
		ServerChat(RedX_pref + text, 11);
	}

	EntFire("Trigger_Kill_Boss_Huynya", "Enable", "", 0);
	EntFire("Trigger_Kill_ZM_Cage", "Enable", "", 0);
	EntFire("Normal_End_Trigger", "Enable", "", 0);

	EntFire("Hold6_Move", "Close", "", 0);

	EntFire("Boss_Dicks_Move", "Open", "", 0);

	EntFire("Map_TP_5", "Disable", "", 0);
	EntFire("Map_TP_4", "Disable", "", 0);

	EntFire("music", "RunScriptCode", "GetMusicAfterBoss();", 0.00);
}
function Trigger_After_Boss_Skip_First()
{
	local time;
	switch (Stage)
	{
		case 1:
		time = 10;
		break;
		case 2:
		time = 7;
		break;
		case 4:
		time = 5;
		break;
		case 5:
		time = 2;
		break;
	}
	EntFire("explosion", "RunScriptCode", "CreateExplosion(Vector(643,5346,637),228,100)", time);
	EntFire("cage_skip", "Break", "", time + 0.01);
}

function Trigger_After_Boss_Skip_Second()
{
	local time;
	local time1;
	switch (Stage)
	{
		case 1:
		time = 7;
		time1 = 0;
		break;
		case 2:
		time = 5;
		time1 = 4;
		break;
		case 4:
		time = 3;
		time1 = 8;
		break;
		case 5:
		time = 0;
		time1 = 12;
		break;
	}

	EntFire("Map_TD", "AddOutput", "angles 7 -145 0", 15);
	EntFire("Map_TD", "AddOutput", "origin -950 3297 469", 15);

	EntFire("explosion", "RunScriptCode", "CreateExplosion(Vector(-3456,3737,453),228,100)", time);
	EntFire("Boss_Side_Model", "Kill", "", time + 0.01);
	EntFire("Boss_Side_Wall", "Kill", "", time + 0.01);

	if(Stage == 1)
	{
		EntFire("explosion", "RunScriptCode", "CreateExplosion(Vector(-4450,-1515,566),228,100)", (30 - 0.01) + time1);
		EntFire("Skip_Wall", "Kill", "", 30 + time1);
	}

	EntFire("Hold6_Move", "Open", "", 25 + time1);

	EntFire("explosion", "RunScriptCode", "CreateExplosion(Vector(-3157,753,553),228,100)", 30 + time1);
	EntFire("Hold6_Rock1", "Disable", "", 30.01 + time1);
	EntFire("Hold6_Rock1_wall", "Toggle", "", 30.01 + time1);

	EntFire("explosion", "RunScriptCode", "CreateExplosion(Vector(-3120,958,525),228,100)", 35.5 + time1);
	EntFire("Hold6_Rock", "Disable", "", 35.51 + time1);
	EntFire("Hold6_Rock_wall", "Toggle", "", 35.51 + time1);
}



//Normal
{
	function Trigger_Normal_End_Pre()
	{
		local text;

		text = "The gates of observatory will open in 20 seconds"
		ServerChat(Chat_pref + text);

		text = "5 SECONDS LEFT"
		ServerChat(Chat_pref + text, 15);

		text = "FALL BACK"
		ServerChat(Chat_pref + text, 20);

		EntFire("Lab_Wall_door", "Open", "", 20);
		EntFire("Normal_end_door", "Open", "", 30);

		EntFire("Map_TD", "AddOutput", "angles 0 180 0", 0);
		EntFire("Map_TD", "AddOutput", "origin -3200 256 340", 0);
		EntFire("Map_TP_6", "Enable", "", 1);

		EntFire("Normal_End", "Enable", "", 0);
	}

	function Trigger_Normal_End()
	{
		local text;
		text = "This is your last hold point"
		ServerChat(Chat_pref + text);

		text = "Congrats! You made it.. But seems like Gi Nattak ran away somehow.. We will defeat him next time..."
		ServerChat(Chat_pref + text, 4);

		text = "It seems he appeared again... I thought your father took care of him before!"
		ServerChat(OldMan_pref + text, 7);

		text = "We were all wrong!"
		ServerChat(OldMan_pref + text, 10);

		text = "This time I will finish the job once and for all"
		ServerChat(RedX_pref + text, 13);

		EntFire("Normal_end_door", "Close", "", 15);
		EntFire("Normal_End", "RunScriptCode", "Start(21,7);", 0.01);
	}
	function Trigger_Normal_Win()
	{
		local text;

		text = "NORMAL mode was beaten. Unlocking HARD mode"
		ServerChat(Chat_pref + text);

		Winner_array = caller.GetScriptScope().GetWinner();
		SetStage(2);
	}

	function Trigger_Normal_Lose()
	{
		local text;

		text = "Nice try cringe"
		ServerChat(Chat_pref + text);
	}
}


function Trigger_Hold_End()
{
	local text;

	text = "Door opens in 10 seconds"
	ServerChat(Chat_pref + text);

	EntFire("explosion", "RunScriptCode", "CreateExplosion(Vector(-4450,-1515,566),228,100)", 10 - 0.01);
	EntFire("Skip_Wall", "Kill", "", 13);

	EntFire("Final_Rope_Temp", "ForceSpawn", "", 10);

	EntFire("Hold5_Door1", "Open", "", 10);

	if(Stage == 2)
	{
		text = "The final door opens in 20 seconds"
		ServerChat(Chat_pref + text, 10);

		EntFire("Hard_End_Wall", "Toggle", "", 10);
		EntFire("Map_TP_3", "Disable", "", 10);

		EntFire("Hold5_Door", "Open", "", 30);
		EntFire("Hard_End", "Enable", "", 0);

		EntFire("Map_Shake_7_Sec", "StartShake", "", 0);
		EntFire("Map_Shake_7_Sec", "StartShake", "", 8);
		EntFire("Map_Shake_7_Sec", "StartShake", "", 15);
	}
	if(Stage == 4)
	{
		text = "The final door opens in 35 seconds"
		ServerChat(Chat_pref + text, 10);

		EntFire("Hold5_Door", "Open", "", 45);

		EntFire("New_ending_wall", "Kill", "", 47);
		EntFire("explosion", "RunScriptCode", "CreateExplosion(Vector(-521,-957,2053),228,100)", 46.99);

		EntFire("Temp_End", "ForceSpawn", "", 5);
		EntFire("End_Fire", "Start", "", 10);

		EntFire("Extreme_Reno_Model", "Enable", "", 45);
		EntFire("Extreme_Reno_Model", "FireUser2", "", 46);
		EntFire("Extreme_Reno_Model", "RunScriptCode", "PlaySound(Sound_First);", 49);

		EntFire("Map_Shake_7_Sec", "StartShake", "", 0);
		EntFire("Map_Shake_7_Sec", "StartShake", "", 16);
		EntFire("Map_Shake_7_Sec", "StartShake", "", 33);

		text = "Damn, that's ain't easy one."
		ServerChat(Tifa_pref + text, 45);

		text = "I am concerned with the fact that he looked different."
		ServerChat(RedX_pref + text, 47);
	}
	if(Stage == 5)
	{
		text = "The final door opens in 35 seconds"
		ServerChat(Chat_pref + text, 10);

		EntFire("Temp_End", "ForceSpawn", "", 5);
		EntFire("End_Fire", "Start", "", 10);

		EntFire("Hold5_Door", "Open", "", 45);
		EntFire("Map_Shake_7_Sec", "StartShake", "", 0);
		EntFire("Map_Shake_7_Sec", "StartShake", "", 20.5);
		EntFire("Map_Shake_7_Sec", "StartShake", "", 38);
	}

	EntFire("Hold6_Move", "Close", "", 10);

	EntFire("Map_TP_6", "Enable", "", 10);
	EntFire("Map_TD", "AddOutput", "origin -3200 256 340", 5);
	EntFire("Map_TD", "AddOutput", "angles 0 180 0", 5);
}
//Hard
{
	function Trigger_Hard_End()
	{
		local text;

		text = "This is your last hold point"
		ServerChat(Chat_pref + text);

		EntFire("Hard_End", "RunScriptCode", "Start(40,7);", 0.01);

		EntFire("Map_TP_7", "Enable", "", 20);
		EntFire("Map_TD", "AddOutput", "origin -7045 -1011 1933", 19);
		EntFire("Map_TD", "AddOutput", "angles -5 -100 0", 19);

		text = "We are lucky ones."
		ServerChat(Tifa_pref + text, 24.5);

		text = "Quick, kill him before he gets to us"
		ServerChat(RedX_pref + text, 26);

		EntFire("temp_cactus", "forcespawn", "", 24);
		EntFire("temp_cactus", "runscriptcode", "Init()", 25);
	}
	function Trigger_Hard_Win()
	{
		local text;

		text = "HARD mode was beaten. Unlocking ZM mode"
		ServerChat(Chat_pref + text);

		Winner_array = caller.GetScriptScope().GetWinner();

		SetStage(3);
	}

	function Trigger_Hard_Lose()
	{
		local text;

		text = "Nice try cringe"
		ServerChat(Chat_pref + text);
	}
}
//ZM
{
	function Trigger_ZM_End()
	{
		local handle = null;
		local alive = false;
		while((handle = Entities.FindByClassname(handle, "player")) != null)
		{
			if(handle == null)
				continue;
			if(!handle.IsValid())
				continue;
			if(handle.GetHealth() <= 0)
				continue;
			if(handle.GetTeam() != 3)
			{
				handle.SetOrigin(Vector(-1827,-332,1106));
				continue;
			}

			alive = true;
			handle.SetOrigin(Vector(4680,-3563,899));
			handle.SetVelocity(Vector(0,0,0));
		}

		local text;
		if(!alive)
		{
			text = "Nice try cringe"
			ServerChat(Chat_pref + text);
			return;
		}
		EntFire("zm_camera_nattack", "fireuser1", "", 0.01);

		text = "this can't be happening...";
		ServerChat(RedX_pref + text, 12.00);

		text = "i thought we had destroyed him";
		ServerChat(Tifa_pref + text, 15.00);

		text = "My instincts were right. All this time, we were fighting an illusion";
		ServerChat(RedX_pref + text, 17.00);

		text = "We need to report this to the headquarters that we found the target";
		ServerChat(ShinraSoldier_pref + text, 24.00);

		text = "They can't get away this time";
		ServerChat(ShinraSoldier_pref + text, 33.00);
	}

	function Trigger_ZM_End_Win()
	{
		local text;

		text = "ZM mode was beaten. Unlocking Extreme mode"
		ServerChat(Chat_pref + text);

		Winner_array.clear();
		local handle = null;
		while((handle = Entities.FindByClassname(handle, "player")) != null)
		{
			if(handle == null)
				continue;
			if(!handle.IsValid())
				continue;
			if(handle.GetHealth() <= 0)
				continue;
			if(handle.GetTeam() == 3)
				Winner_array.push(handle);
			else if(handle.GetTeam() == 2)
			{
				EntFireByHandle(handle, "SetDamageFilter", "", 0.9, null, null);
            	EntFireByHandle(handle, "SetHealth", "-1", 2.0, null, null);
			}
		}
		local g_round = Entities.FindByName(null, "round_end");
		EntFireByHandle(g_round, "EndRound_CounterTerroristsWin", "6", 1.8, null, null);

		Show_Credits_Passed();

		EntFire("music", "RunScriptCode", "SetMusic(Sound_Win);", 0.00);
		EntFire("Nuke_fade", "Fade", "", 0.00);
		EntFire("zamok_ct", "RunScriptCode", "Stop()", 0);

		SetStage(4);
	}
}
//EXTREME
{
	function Trigger_New_End()
	{
		if(Stage == 4)
		{
			EntFire("Map_TD", "AddOutput", "angles 0 180 0", 4);
			EntFire("Map_TD", "AddOutput", "origin -6352 -1104 1876", 4);
			EntFire("Map_TP_7", "Enable", "", 5);

			EntFire("End_Move*", "Open", "", 1.5);

			EntFire("Temp_Extreme", "RunScriptCode", "Init();", 0.01);

			EntFire("Map_Shake", "StartShake", "", 0);
			EntFire("Map_Shake", "StartShake", "", 3);

			EntFire("Map_Shake", "StartShake", "", 40);
			EntFire("End_Platform_Move", "FireUser1", "", 25);

			EntFire("End_End", "AddOutPut", "OnUser3 map_brush:RunScriptCode:Trigger_Extreme_Win();:0:1", 0);
			EntFire("End_End", "AddOutPut", "OnUser4 map_brush:RunScriptCode:Trigger_Extreme_Lose();:0:1", 0);
		}
	}

	function Trigger_Extreme_Win()
	{
		local text;

		text = "EXTREME mode was beaten. Thanks for test Cosmov6"
		ServerChat(Chat_pref + text);

		Winner_array = caller.GetScriptScope().GetWinner();

		SetStage(4);
	}

	function Trigger_Extreme_Lose()
	{
		local text;

		text = "Nice try cringe"
		ServerChat(Chat_pref + text);
	}
}

function Trigger_New_End_Last()
{
	if(Stage == 4)
	{
		EntFire("music", "RunScriptCode", "SetMusic(Music_Extreme_4);", 6.00);

		for(local i = 9, a = 0; i >= 4; i--, a += 0.2)
		{
			EntFire("music", "Volume", "" + i, 10.0 + a);
		}

		if(ScoreBass > 0 && ScoreBass % 10 == 0)
		{
			EntFire("Extreme_Reno_Model", "RunScriptCode", "self.SetModel(CHICKEN_MODEL);", 8);
			EntFire("Extreme_Reno_Model", "Skin", "4", 8.01);
			EntFire("Extreme_Reno_Model", "SetAnimation", "Run01", 8.01);
			EntFire("Extreme_Reno_Model", "AddOutPut", "ModelScale 3.5", 8);
			EntFire("Extreme_Reno_Model", "AddOutPut", "angles 0 180 0", 8.05 );

			EntFire("Extreme_Reno_Model", "SetAnimation", "Bunnyhop", 3.15 + 8);
			EntFire("Extreme_Reno_Model", "SetAnimation", "Flap_falling", 3.3 + 8);
			EntFire("Extreme_Reno_Model", "SetAnimation", "bounce", 5.9 + 8);
			EntFire("Extreme_Reno_Model", "SetAnimation", "Walk01", 7.4 + 8);
		}

		EntFire("Camera_old", "RunScriptCode", "SetOverLay(Overlay)", 8);
		EntFire("Camera_old", "RunScriptCode", "SpawnCameras(Vector(-8225,-982,1878),Vector(0,45,0),0,Vector(-8695,-982,1878),Vector(0,45,0),1,2.4)", 8);
		EntFire("Camera_old", "RunScriptCode", "SpawnCameras(Vector(-10413,-928,1833),Vector(0,0,0),3,Vector(-10413,-928,1897),Vector(0,0,0),0,1)", 3.4 + 8);
		EntFire("Camera_old", "RunScriptCode", "SpawnCameras(Vector(-10413,-928,1897),Vector(0,0,0),0,Vector(-10839,-928,1897),Vector(0,0,0),1,2.7)", 7.4 + 8);
		EntFire("Camera_old", "RunScriptCode", "SetOverLay()", 11.1 + 8);

		EntFire("End_Platform_Move", "FireUser1", "", 3);
		EntFire("Extreme_Reno_Model", "FireUser3", "", 8);

		EntFire("Map_TP_8", "Enable", "", 8);
	}
}


function Trigger_Add_HP_New_End()
{
	if(Stage == 4)
	{
		EntFire("Temp_Extreme", "RunScriptCode", "AddHPInit(55)", 0);
	}
}


function Trigger_After_Last_Nattak()
{
	if(Stage == 4)
	{
		local text;

		text = "Congrats! You made it... You kill Him..."
		ServerChat(Chat_pref + text);

		text = "Get on the rocks and hold";
		ServerChat(Chat_pref + text, 2);

		text = "This is your last hold point";
		ServerChat(Chat_pref + text, 4);

		EntFire("End_Clip", "Kill", "", 0);

		EntFire("Map_TD", "AddOutput", "angles 0 180 0", 4);
		EntFire("Map_TD", "AddOutput", "origin -8816 -928 2324", 4);
		EntFire("Map_TP_4", "Enable", "", 5);
	}
}
