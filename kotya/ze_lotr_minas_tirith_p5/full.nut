////////////////////////////////////////////////////////////////////
//Script by Kotya[STEAM_1:1:124348087]
//Put here scripts\vscripts\stripper\kotya\ze_lotr_minas_tirith_p5\
//update 07.06
////////////////////////////////////////////////////////////////////
shield <- 0;
shieldSave <- 0;
shieldFind <- 0;
Stage <- 0;
ExtraStage <- false;
Extreme <- false;
EndStage <- false;

function StartLevel()
{
	EndStage=false;
	if(Stage!=0 && !ExtraStage)
	{
		shieldFind = 0;
		shield = shieldSave;
		ShowShield();
		if(Stage==1)
		{
			SpawnShieldOne();
			SetStageOne();
		}
		else if(Stage==2)
		{
			SpawnShieldTwo();
			SetStageTwo();
		}
		else if(Stage==3)
		{
			SpawnShieldThree();
			SetStageThree();
		}
		else if(Stage==4)
		{
			SpawnShieldFour();
			SetStageFour();
		}
	}
	else if(ExtraStage)
	{
		StartFullStageOne();
	}
}


function StartFullStageOne()
{
	EntFire("triggers_spawan_z_lv2_b", "disable", "", 0.00, self);
	EntFire("triggers_spawan2_z_lv2_b", "disable", "", 0.00, self);

	EntFire("player", "AddOutput", "targetname 5", 0.00, self);
	EntFire("ph_item_gandalf_15", "addoutput", "health 228", 0.00, self);
	EntFire("ph_object_soldier_5_3", "addoutput", "health 28", 0.00, self);
	EntFireByHandle(self, "RunScriptCode", "HeroSetHp(); ", 20.00, null, null);
	EntFire("consola", "Command", "mp_freezetime 5", 0.00, self);
	EntFire("consola", "Command", "say ** THE ROUND WILL START IN FEW SECONDS ** CHECK YOUR LEVEL AND PROCEED TO BUY AN ITEM **", 0.00, self);
	EntFire("ResetWarmupLevel", "Trigger", "", 1.00, self);
	EntFire("MZMTimer", "Kill", "", 20.00, self);
	EntFire("SpawnPush", "Trigger", "", 14.00, self);
	EntFire("SpawnPush", "Kill", "", 20.00, self);
	EntFire("consola", "Command", "say ** CURRENT STAGE >> PART 1/4 >> OSGILIATH **", 0.00, self);
	EntFire("texture_1", "SetTextureIndex", "0", 0.00, self);

	EntFire("musica_st_1_1","Volume", "10", 24.5, self);
	EntFire("musica_muteAll","Trigger", "", 24.0, self);

	EntFire("stage_1_enough","addoutput", "OnTrigger musica_muteAll:Trigger::0:-1,0,-1", 10.0, self);
	EntFire("stage_1_enough","addoutput", "OnTrigger musica_st_1_2:Volume:10:0.5:-1,0,-1", 10.0, self);

	EntFire("stage_1_barcos_relay", "Trigger", "", 15.00, self);

	EntFire("spawn_brsh5", "Break", "", 13.00, self);

	EntFire("stage_1_limits", "Enable", "", 0.00, self)
	EntFire("stage_2_limits", "Disable", "", 0.00, self)
	EntFire("stage_3_limits", "Disable", "", 0.00, self)
	EntFire("stage_4_limits", "Disable", "", 0.00, self)
	EntFire("spawn_teleport_z2", "AddOutput", "target stage_1_teleport_z2", 0.00, self);
	EntFire("spawn_teleport_z2_2", "AddOutput", "target stage_1_teleport_z", 0.00, self);
	EntFire("spawn_teleport_z2_3", "AddOutput", "target stage_1_teleport_z3", 0.00, self);
	EntFire("spawn_teleport_3", "AddOutput", "target stage_1_teleport_s3", 0.00, self);
	EntFire("spawn_teleport_2", "AddOutput", "target stage_1_teleport_s2", 0.00, self);
	EntFire("spawn_teleport_1", "AddOutput", "target stage_1_teleport_s3", 0.00, self);
	EntFire("spawn_teleport_mass_z", "AddOutput", "target stage_1_teleport_z", 0.00, self);
	EntFire("spawn_teleport_mass_h", "AddOutput", "target stage_1_teleport_s2", 0.00, self);
	EntFire("spawn_teleport_mass", "AddOutput", "target stage_1_teleport", 0.00, self);

	EntFire("ultra_optimize", "FireUser1", "", 0.00, self);
	EntFire("stage_1_SPAWN_ENTS", "ForceSpawn", "", 0.00, self);
	EntFire("global_nuke_spawn","addoutput", "damage 1", 0.00, self);
	EntFire("newH_stage_1_nuke","addoutput", "damage 1", 10.0, self);
	EntFire("newH_stage_1_nuke","addoutput", "OnHurtPlayer fullmod:RunScriptCode:SetPos(0):0:-1,0,-1", 10.0, self);
	EntFire("global_nuke_spawn","enable", "", 49.0, self);
	EntFire("global_nuke_spawn","addoutput", "OnHurtPlayer fullmod:RunScriptCode:Damage():1:-1,0,-1", 5.0, self);

	EntFire("stage_1_fin","addoutput", "OnTrigger newH_stage_1_nuke:Enable::0.02:1,0,1", 0.0, self);
	EntFire("stage_1_fin","addoutput", "OnTrigger consola:Command:say ** STAGE 1/4 COMPLETED **:0:1,0,1", 0.0, self);
	EntFire("stage_1_fin","addoutput", "OnTrigger ph_item_nazgul_7*:Break::0:1,0,1", 0.0, self);
	EntFire("stage_1_fin","addoutput", "OnTrigger fade_whte:fade::0:1,0,1", 0.0, self);
	EntFire("stage_1_fin","addoutput", "OnTrigger fullmod:RunScriptCode:StartFullStageTwo():1:1,0,1", 1.0, self);
}

function StartFullStageTwo()
{
	local timer = 0.50;
	CheckPlayerDoneStage()
	ClearStage()
	ClearStageOne()
	EntFire("stage_1_triggerx", "Disable", "", 0.00, self)
	EntFire("stage_1_limits", "Disable", "", 0.00, self)
	EntFire("stage_2_limits", "Enable", "", 0.00, self)
	EntFireByHandle(self, "RunScriptCode", "HeroSetHp(); ", 5.00, null, null);
	EntFire("ultra_optimize", "FireUser2", "", timer+0.00, self);
	EntFire("stage_2_SPAWN_ENTS", "ForceSpawn", "", timer+0.00, self);
	EntFire("stage_grond_tmp", "ForceSpawn", "", timer+0.00, self);
	EntFire("stage_2_torre_entraad", "Toggle", "", timer+0.00, self);

	EntFire("escalerasGrond","Toggle", "",timer, self);
	EntFire("musica_st_2_1","PlaySound","", timer+239.00, self);
	EntFire("musica_st_2_1","PlaySound","", timer+44.00, self);
	EntFire("sonidos_denethor","PlaySound","", timer+32.00, self);
	EntFire("sonidos_gandalf_preparaospara","PlaySound","", timer+42.00, self);
	EntFire("army_","Toggle", "", timer+0.00, self);

	EntFire("orcos_s_stage2","SetParent","esconder_", timer+0.00, self);
	EntFire("orcos_s_stage2","Start","",timer+5.00, self);
	EntFire("orcos_s","Start",	"", timer+5.00, self);
	EntFire("stage_2_y_1_soldiers_1","ForceSpawn","",timer, self);
	EntFire("musica_muteAll","Trigger","", timer+29.80, self);
	EntFire("stage_2_puerta_vida_timer","Enable",	"", timer+30.00, self);
	EntFire("consola", "Command", "say ** CURRENT STAGE >> PART 2/4 >> MAIN GATES **", timer, self);
	EntFire("texture_1", "SetTextureIndex", "1", 0.00, self);
	EntFire("spawn_teleport_z2_3", "AddOutput", "target stage_2_teleport_z", 0.00, self);
	EntFire("spawn_teleport_z2_2", "AddOutput", "target stage_2_teleport_z", 0.00, self);
	EntFire("spawn_teleport_z2", "AddOutput", "target stage_2_teleport_z", 0.00, self);
	EntFire("spawn_teleport_1", "AddOutput", "target stage_2_teleport_s3", 0.00, self);
	EntFire("spawn_teleport_2", "AddOutput", "target stage_2_teleport_s2", 0.00, self);
	EntFire("spawn_teleport_3", "AddOutput", "target stage_2_teleport_s1", 0.00, self);
	EntFire("spawn_teleport_mass_h", "AddOutput", "target stage_2_teleport_s2", 0.00, self);
	EntFire("spawn_teleport_mass_z", "AddOutput", "target stage_2_teleport_z", 0.00, self);
	EntFire("spawn_teleport_mass", "AddOutput", "target stage_2_teleport", 0.00, self);
	EntFire("stage_2_nuke","addoutput", "damage 1", 10.00, self);
	EntFire("stage_2_nuke","addoutput", "OnHurtPlayer fullmod:RunScriptCode:SetPos(1):0:-1,0,1", 10.00, self);
	EntFire("stage_2_fin","addoutput", "OnTrigger stage_2_nuke:Enable::0.0:1,0,1", 0.0, self);
	EntFire("stage_2_fin","addoutput", "OnTrigger consola:Command:say ** STAGE 2/4 COMPLETED **:0:1,0,1", 0.0, self);
	EntFire("stage_2_fin","addoutput", "OnTrigger fullmod:RunScriptCode:StartFullStageThree():1:1,0,1", 0.0, self);
}

function StartFullStageThree()
{
	local timer = 0.5;
	CheckPlayerDoneStage()
	ClearStage()
	ClearStageTwo()
	EntFireByHandle(self, "RunScriptCode", "HeroSetHp(); ", 5.00, null, null);
	EntFire("consola", "Command", "say ** CURRENT STAGE >> PART 3/4 >> CATAPULTS **", timer, self);
	EntFire("stage_2_limits", "Disable", "", 0.00, self)
	EntFire("stage_3_limits", "Enable", "", 0.50, self)

	EntFire("consola", "Command", "say ** EXTRA ZOMBIE ITEMS HAVE OPENED **", 5.00, self);
	EntFire("balrog_disabled", "Break", "", 5.00, self);
	EntFire("triggers_spawan_z_lv2_b", "enable", "", 5.00, self);
	EntFire("triggers_spawan2_z_lv2_b", "enable", "", 5.00, self);

	EntFire("stage_3_soldiers","ForceSpawn","",timer+1.00, self)
	EntFire("stage_3_barricadas","ForceSpawn","",timer+3.00, self)
	EntFire("ph_stage_3_door1","FireUser1","",timer, self)
	EntFire("orcos_s","Kill","",timer+1.00, self)
	EntFire("stage_2_nuke", "kill", "", timer, self)
	EntFire("ph_stage_3_door1","FireUser1","",timer, self)
	EntFire("ph_stage_3_door2","Break","",timer+15.00, self)
	EntFire("ph_stage_3_door1","Break","",timer+15.00, self)
	EntFire("ph_stage_3_door2","FireUser1","",timer, self)

	EntFire("ultra_optimize", "FireUser3", "", timer+0.00, self);
	EntFire("stage_3_SPAWN_ENTS", "ForceSpawn", "", timer+0.00, self);

	EntFire("texture_1", "SetTextureIndex", "2", 0.00, self);
	EntFire("spawn_teleport_z2_3", "AddOutput", "target stage_3_teleport_z", 0.00, self);
	EntFire("spawn_teleport_z2_2", "AddOutput", "target stage_3_teleport_z", 0.00, self);
	EntFire("spawn_teleport_z2", "AddOutput", "target stage_3_teleport_z", 0.00, self);
	EntFire("spawn_teleport_1", "AddOutput", "target stage_3_teleport_s3", 0.00, self);
	EntFire("spawn_teleport_2", "AddOutput", "target stage_3_teleport_s2", 0.00, self);
	EntFire("spawn_teleport_3", "AddOutput", "target stage_3_teleport_s1", 0.00, self);
	EntFire("spawn_teleport_mass_h", "AddOutput", "target stage_3_teleport_s2", 0.00, self);
	EntFire("spawn_teleport_mass_z", "AddOutput", "target stage_3_teleport_z", 0.00, self);
	EntFire("spawn_teleport_mass", "AddOutput", "target stage_3_teleport", 0.00, self);

	EntFire("stage_3_nuke","addoutput", "damage 1", 10.00, self);
	EntFire("stage_3_nuke","addoutput", "OnHurtPlayer fullmod:RunScriptCode:SetPos(2):0:1,0,1", 10.00, self);

	EntFire("stage_3_fin","addoutput", "OnTrigger stage_3_tracktrain_1_3:Close::7:1,0,1", 0.0, self);
	EntFire("stage_3_fin","addoutput", "OnTrigger stage_3_tracktrain_2:Close::7:1,0,1", 0.0, self);
	EntFire("stage_3_fin","addoutput", "OnTrigger stage_3_tracktrain_1:Close::7:1,0,1", 0.0, self);
	EntFire("stage_3_fin","addoutput", "OnTrigger stage_3_trigger_aumentonivel:Enable::15:1,0,1", 0.0, self);
	EntFire("stage_3_fin","addoutput", "OnTrigger stage_3_nuke:Enable::15.5:1,0,1", 0.0, self);
	EntFire("stage_3_fin","addoutput", "OnTrigger stage_3_nuke:Disable::17.5:1,0,1", 0.0, self);
	EntFire("stage_3_fin","addoutput", "OnTrigger stage_3_trigger:FireUser1::15.5:1,0,1", 0.0, self);
	EntFire("stage_3_fin","addoutput", "OnTrigger fullmod:RunScriptCode:StartFullStageFour();:16:1,0,1", 0.0, self);
}

function StartFullStageFour()
{
	local timer = 1.5;
	CheckPlayerDoneStage()
	ClearStage()
	ClearStageThree()
	EntFireByHandle(self, "RunScriptCode", "HeroSetHp(); ", 5.00, null, null);
	EntFire("ph_stage_3_door*","FireUser1","",timer, self)
	EntFire("stage_4_door_noborrar", "Unlock", "", timer, self)
	EntFire("stage_4_barricadas", "ForceSpawn", "", timer, self)
	EntFire("stage_4_soldiers", "ForceSpawn", "", timer, self)
	EntFire("ultra_optimize", "FireUser4", "", timer, self);
	EntFire("stage_4_SPAWN_ENTS", "ForceSpawn", "", timer, self);
	EntFire("texture_1", "SetTextureIndex", "3", 0.00, self);
	EntFire("stage_3_limits", "Disable", "", 0.00, self)
	EntFire("stage_4_limits", "Enable", "", 0.00, self)
	EntFire("spawn_teleport_z2_3", "AddOutput", "target stage_4_teleport_z", 0.00, self);
	EntFire("spawn_teleport_z2_2", "AddOutput", "target stage_4_teleport_z", 0.00, self);
	EntFire("spawn_teleport_z2", "AddOutput", "target stage_4_teleport_z", 0.00, self);
	EntFire("spawn_teleport_1", "AddOutput", "target stage_4_teleport_s3", 0.00, self);
	EntFire("spawn_teleport_2", "AddOutput", "target stage_4_teleport_s2", 0.00, self);
	EntFire("spawn_teleport_3", "AddOutput", "target stage_4_teleport_s1", 0.00, self);
	EntFire("spawn_teleport_mass_h", "AddOutput", "target stage_4_teleport_s2", 0.00, self);
	EntFire("spawn_teleport_mass_z", "AddOutput", "target stage_4_teleport_z", 0.00, self);
	EntFire("spawn_teleport_mass", "AddOutput", "target stage_4_teleport", 0.00, self);
	EntFire("stage_4_comprobarfinal","addoutput", "OnTrigger stage_4_trigger_aumentonivel:Disable::2:1,0,1", 0.0, self);
	EntFire("stage_4_comprobarfinal","addoutput", "OnTrigger stage_4_extreme_2:Trigger::1:1,0,1", 0.0, self);
	EntFire("stage_4_comprobarfinal","addoutput", "OnTrigger stage_4_trigger_aumentonivel:Enable::1:1,0,1", 0.0, self);
	EntFire("stage_4_comprobarfinal","addoutput", "OnTrigger fullmod:RunScriptCode:CheckPlayerDoneStage();:0:1,0,1", 1.0, self);
	EntFire("stage_4_comprobarfinal","addoutput", "OnTrigger fullmod:RunScriptCode:DoneExtraStage();:0:1,0,1", 1.0, self);
	EntFire("stage_4_comprobarfinal","addoutput", "OnTrigger fullmod:RunScriptCode:Reset();:0:1,0,1", 0.0, self);

	EntFire("consola", "Command", "say ** CURRENT STAGE >> PART 4/4 >> THE LAST STAND **", timer, self);
}

function ClearStage()
{
	EntFire("object_soldier_*", "kill", "", 0.00, self)
	EntFire("ph_object_soldier_5*", "kill", "", 0.00, self)
	EntFire("stage_1_barricade*", "kill", "", 0.00, self)
}

function test()
{
	local act = caller;
	local pos1 = act.EyePosition();
	local pos2 = Vector(9774,780,10141);
	DebugDrawLine(pos1, pos2, 255, 255, 255, true, 250)
}

function ShowShield()
{
	if(!ExtraStage)
 	{
		EntFire("shield_text", "SetText", "Shield: "+shield.tostring()+"/16", 0.00, self);
		EntFire("shield_text", "Display", "", 0.10, self);
	}
}

function AddShield()
{
	EntFire("fullmod", "runscriptcode", "ShowShield()", 0.10, self);
	if(activator.GetTeam() == 3)
	{
		if(shield<16)
		{
			shield++;
			if (shield-shieldSave==4)EntFire("consola", "Command", "say ** All Shield on this Stage was find **", 1.00, self);
		}
	}
	else if(shield!=0)
	{
		shield--;
		EntFire("consola", "Command", "say ** Zombie take Shield **", 0.00, self);
	}
	shieldFind++;
	EntFire("consola", "Command", "say ** Shield: "+shieldFind.tostring()+"/4 **", 0.00, self);
}

function StageDone()
{
	EndStage=true;
	switch (Stage)
	{
		case 1:
			if (shield-4==shieldSave)EntFire("consola", "Command", "say ** STAGE 1 FULL COMPLETE **", 0.00, self);
			else EntFire("consola", "Command", "say ** STAGE 1 COMPLETE **", 0.00, self);
			break;
		case 2:
			if (shield-4==shieldSave)EntFire("consola", "Command", "say ** STAGE 2 FULL COMPLETE **", 0.00, self);
			else EntFire("consola", "Command", "say ** STAGE 2 COMPLETE **", 0.00, self);
			break;
		case 3:
			if (shield-4==shieldSave)EntFire("consola", "Command", "say ** STAGE 3 FULL COMPLETE **", 0.00, self);
			else EntFire("consola", "Command", "say ** STAGE 3 COMPLETE **", 0.00, self);
			break;
		case 4:
			if (shield-4==shieldSave)
			{
				EntFire("consola", "Command", "say ** STAGE 4 FULL COMPLETE **", 0.00, self);
			}
			else EntFire("consola", "Command", "say ** STAGE 4 COMPLETE **", 0.00, self);
			break;
	}
	shieldSave = shield;
}

function DoneExtraStage()
{
	ExtraStage = false;
	Extreme = true;
	shield = 0;
	shieldSave = 0;
	EntFire("consola", "Command", "say ** STAGE 4/4 COMPLETED **", 0.00, self);
	EntFire("consola", "Command", "say ** Thx for test Kotya Stripper **", 0.10, self);
	EntFire("consola", "Command", "say ** Testers: LeXeR, Jayson, DarkerZ, Switchback **", 0.15, self);
	EntFire("consola", "Command", "say ** Start Extrem **", 1.00, self);
	EntFire("LevelInput", "SetValue", "1", 0.00, self);
	EntFire("LevelExtrem", "Enable", "", 0.00, self);
}
function CheckPizdecChiNet()
{
	if(shield==16)
	{
		shield = 0;
		shieldSave = 0;
		ExtraStage = true;
		EntFire("consola", "Command", "say ** All Shield was find start Extra Stage **", 1.00, self);
		EntFire("LevelInput", "SetValue", "5", 0.00, self);
	}
	else
	{
		Extreme = true;
		EntFire("consola", "Command", "say ** Not enough Shield start Extreme Stage **", 1.00, self);
		EntFire("LevelInput", "SetValue", "1", 0.00, self);
		EntFire("LevelExtrem", "Enable", "", 0.00, self);
	}
}

function Reset()
{
	Extreme = false;
	ExtraStage = false;
	shield = 0;
	shieldSave = 0;
	EntFire("LevelInput", "SetValue", "1", 0.00, self);
}

function SpawnShieldOne()
{
	switch (RandomInt(0, 2))
	{
		case 0:
		EntFire("Shield_pt", "AddOutPut", "origin -9629 258 5760", 1.10, self);
		break;
		case 1:
		EntFire("Shield_pt", "AddOutPut", "origin -12679 1268 5760", 1.10, self);
		break;
		case 2:
		EntFire("Shield_pt", "AddOutPut", "origin -12672 1378 6125", 1.10, self);
		break;
	}
	EntFire("Shield_pt", "forcespawn", "", 1.20, self);

	if(RandomInt(0, 1))EntFire("Shield_pt", "AddOutPut", "origin -12195 3281 5760", 1.30, self);
	else EntFire("Shield_pt", "AddOutPut", "origin -11182 445 5760", 1.30, self);
	EntFire("Shield_pt", "forcespawn", "", 1.40, self);

	if(RandomInt(0, 1))EntFire("Shield_pt", "AddOutPut", "origin -9671 343 6060", 1.50 self);
	else EntFire("Shield_pt", "AddOutPut", "origin -9435 1640 6644", 1.50, self);
	EntFire("Shield_pt", "forcespawn", "", 1.60, self);

	if(RandomInt(0, 1))EntFire("Shield_pt", "AddOutPut", "origin -12168 3517 6224", 1.70, self);
	else EntFire("Shield_pt", "AddOutPut", "origin -8657 3258 5760", 1.70, self);
	EntFire("Shield_pt", "forcespawn", "", 1.80, self);
}

function SpawnShieldTwo()
{
	EntFire("Shield_pt", "AddOutPut", "origin -2438 -2301 -13611", 1.10, self);
	EntFire("Shield_pt", "forcespawn", "", 1.20 self);

	if(RandomInt(0, 1))EntFire("Shield_pt", "AddOutPut", "origin 5 4129 -12927", 1.30, self);
	else EntFire("Shield_pt", "AddOutPut", "origin 260 2958 -13507", 1.30, self);
	EntFire("Shield_pt", "forcespawn", "", 1.40, self);

	if(RandomInt(0, 1))EntFire("Shield_pt", "AddOutPut", "origin 1240 6146 -13103", 1.50, self);
	else EntFire("Shield_pt", "AddOutPut", "origin -4644 3469 -13095", 1.50, self);
	EntFire("Shield_pt", "forcespawn", "", 1.60, self);

	if(RandomInt(0, 1))EntFire("Shield_pt", "AddOutPut", "origin -4007 -1290 -13792", 1.70, self);
 	else EntFire("Shield_pt", "AddOutPut", "origin -4894 512 -13547", 1.70, self);
	EntFire("Shield_pt", "forcespawn", "", 1.80, self);
}

function SpawnShieldThree()
{
	switch (RandomInt(0, 2))
	{
		case 0:
		EntFire("Shield_pt", "AddOutPut", "origin 415 -1409 -10485", 1.10, self);
		break;
		case 1:
		EntFire("Shield_pt", "AddOutPut", "origin 1955 -3460 -10517", 1.10, self);
		break;
		case 2:
		EntFire("Shield_pt", "AddOutPut", "origin 3017 -4894 -10508", 1.10, self);
		break;
	}
	EntFire("Shield_pt", "forcespawn", "", 1.20, self);

	if(RandomInt(0, 1))EntFire("Shield_pt", "AddOutPut", "origin 2832 3366 -12607", 1.30, self);
	else EntFire("Shield_pt", "AddOutPut", "origin 2175 2522 -11263", 1.30, self);
	EntFire("Shield_pt", "forcespawn", "", 1.40, self);

	if(RandomInt(0, 1))EntFire("Shield_pt", "AddOutPut", "origin 1532 1382 -11263", 1.50, self);
	else EntFire("Shield_pt", "AddOutPut", "origin 1701 -1851 -11071", 1.50, self);
	EntFire("Shield_pt", "forcespawn", "", 1.60, self);

	if(RandomInt(0, 1))EntFire("Shield_pt", "AddOutPut", "origin 3771 -442 -8407", 1.70, self);
 	else EntFire("Shield_pt", "AddOutPut", "origin 3771 -332 -8407", 1.70, self);
	EntFire("Shield_pt", "forcespawn", "", 1.8, self);
}

function SpawnShieldFour()
{
	if(RandomInt(0, 1))EntFire("Shield_pt", "AddOutPut", "origin 7358 -2881 -7806", 1.10, self);
	else EntFire("Shield_pt", "AddOutPut", "origin 7390 -3237 -7806", 1.10, self);
	EntFire("Shield_pt", "forcespawn", "", 1.20, self);
	switch (RandomInt(0, 2))
	{
		case 0:
		EntFire("Shield_pt", "AddOutPut", "origin 4796 746 -7438", 1.30, self);
		break;
		case 1:
		EntFire("Shield_pt", "AddOutPut", "origin 8808 440 -7438", 1.30, self);
		break;
		case 2:
		EntFire("Shield_pt", "AddOutPut", "origin 7613 3280 -7438", 1.30, self);
		break;
	}
	EntFire("Shield_pt", "forcespawn", "", 1.40, self);
	switch (RandomInt(0, 3))
	{
		case 0:
		EntFire("Shield_pt", "AddOutPut", "origin 7091 4228 -6163", 1.50, self);
		break;
		case 1:
		EntFire("Shield_pt", "AddOutPut", "origin 4858 2395 -6655", 1.50, self);
		break;
		case 2:
		EntFire("Shield_pt", "AddOutPut", "origin 8285 4395 -4351", 1.50, self);
		break;
		case 3:
		EntFire("Shield_pt", "AddOutPut", "origin 7327 4419 -4351", 1.50, self);
		break;
	}
	EntFire("Shield_pt", "forcespawn", "", 1.60, self);
	switch (RandomInt(0, 3))
	{
		case 0:
		EntFire("Shield_pt", "AddOutPut", "origin 8094 -2629 -1751", 1.70, self);
		break;
		case 1:
		EntFire("Shield_pt", "AddOutPut", "origin 7893 2141 -1751", 1.70, self);
		break;
		case 2:
		EntFire("Shield_pt", "AddOutPut", "origin 9414 1055 -1742", 1.70, self);
		break;
		case 3:
		EntFire("Shield_pt", "AddOutPut", "origin 9743 -1050 -1778", 1.70, self);
		break;
	}
	EntFire("Shield_pt", "forcespawn", "", 1.80, self);
}

function SetStageOne()
{
	ClearStageThree()
	EntFire("stage_1_fin","addoutput", "OnTrigger newH_stage_1_nuke:Enable::0.02:1,0,1", 0.0, self);
	EntFire("stage_1_fin","addoutput", "OnTrigger global_nuke_spawn:Enable::0.02:1,0,1", 0.0, self);
	EntFire("stage_1_fin","addoutput", "OnTrigger ph_item_nazgul_7*:Break::0:1,0,1", 0.0, self);
	EntFire("stage_1_fin","addoutput", "OnTrigger LevelInput:SetValue:2:0:1,0,1", 0.0, self);
	EntFire("stage_1_fin","addoutput", "OnTrigger stage_1_spawnear_2:Enable::0:1,0,1", 0.0, self);
	EntFire("stage_1_fin","addoutput", "OnTrigger fullmod:RunScriptCode:StageDone();:0:1,0,1", 0.0, self);
}

function SetStageTwo()
{
	ClearStageOne()
	EntFire("stage_2_fin","addoutput", "OnTrigger stage_2_nuke:Enable::0:1,0,1", 0.0, self);
	EntFire("stage_2_fin","addoutput", "OnTrigger global_nuke_spawn:Enable::0:1,0,1", 0.0, self);
	EntFire("stage_2_fin","addoutput", "OnTrigger LevelInput:SetValue:3:0:1,0,1", 0.0, self);
	EntFire("stage_2_fin","addoutput", "OnTrigger fullmod:RunScriptCode:StageDone();:0:1,0,1", 0.0, self);
}

function SetStageThree()
{
	ClearStageOne()
	ClearStageTwo()
	EntFire("stage_3_fin","addoutput", "OnTrigger stage_3_tracktrain_1_3:Close::7:1,0,1", 0.0, self);
	EntFire("stage_3_fin","addoutput", "OnTrigger stage_3_tracktrain_2:Close::7:1,0,1", 0.0, self);
	EntFire("stage_3_fin","addoutput", "OnTrigger stage_3_tracktrain_1:Close::7:1,0,1", 0.0, self);
	EntFire("stage_3_fin","addoutput", "OnTrigger stage_3_trigger_aumentonivel:Enable::15:1,0,1", 0.0, self);
	EntFire("stage_3_fin","addoutput", "OnTrigger stage_3_nuke:Enable::15.5:1,0,1", 0.0, self);
	EntFire("stage_3_fin","addoutput", "OnTrigger global_nuke_spawn:Enable::15.5:1,0,1", 0.0, self);
	EntFire("stage_3_fin","addoutput", "OnTrigger stage_3_trigger_aumentonivel:Disable::16:1,0,1", 0.0, self);
	EntFire("stage_3_fin","addoutput", "OnTrigger LevelInput:SetValue:4:14.9:1,0,1", 0.0, self);
	EntFire("stage_3_fin","addoutput", "OnTrigger stage_3_trigger:FireUser1::15.5:1,0,1", 0.0, self);
	EntFire("stage_3_fin","addoutput", "OnTrigger fullmod:RunScriptCode:StageDone();:0:16,0,1", 0.0, self);
}

function SetStageFour()
{
	ClearStageOne()
	ClearStageTwo()
	ClearStageThree()
	EntFire("stage_4_comprobarfinal","addoutput", "OnTrigger stage_4_trigger_aumentonivel:Disable::2:1,0,1", 0.0, self);
	EntFire("stage_4_comprobarfinal","addoutput", "OnTrigger stage_4_extreme_2:Trigger::1:1,0,1", 0.0, self);
	EntFire("stage_4_comprobarfinal","addoutput", "OnTrigger stage_4_trigger_aumentonivel:Enable::1:1,0,1", 0.0, self);
	EntFire("stage_4_comprobarfinal","addoutput", "OnTrigger fullmod:RunScriptCode:StageDone();:0:1,0,1", 1.0, self);
	EntFire("stage_4_comprobarfinal","addoutput", "OnTrigger fullmod:RunScriptCode:CheckPizdecChiNet();:0:1,0,1", 1.0, self);
	EntFire("stage_4_comprobarfinal","addoutput", "OnTrigger fullmod:RunScriptCode:CheckPlayerDoneStage();:0:1,0,1", 0.0, self);
}

function ClearStageOne()
{
	EntFire("stage_1_prop_dynamics*", "kill", "", 0.00, self)
	EntFire("newH_stage_1_nuke*", "kill", "", 0.00, self)
	EntFire("stage_1_trigger_aumentonivel", "kill", "", 0.00, self)
	EntFire("stage_1_trigger", "kill", "", 0.00, self)
	EntFire("stage_1_spawnear*", "kill", "", 0.00, self)
	EntFire("defensa1tr*", "kill", "", 0.00, self)
	EntFire("stage_1_gandalfX*", "kill", "", 0.00, self)
	EntFire("stage_1_gandalf_1*", "kill", "", 0.00, self)
	EntFire("NazgulKiller*", "kill", "", 0.00, self)
	EntFire("stage_1_horses_*", "kill", "", 0.00, self)
	EntFire("stage_1_limits", "Disable", "", 0.00, self)
	EntFire("minas_prop_1", "Kill", "", 0.00, self)
}

function ClearStageTwo()
{
	EntFire("stage_2_nuke","Kill", "", 0.80, self);
	EntFire("stage_2_ret*", "Kill", "", 0.00, self)
	EntFire("stage_2_horse", "Kill", "", 0.00, self)
	EntFire("main_gates_*", "Kill", "", 0.00, self)
	EntFire("stage_3_falling_tower*", "Kill", "", 0.00, self)
	EntFire("stage_2_trigger_aumentonivel", "kill", "", 0.00, self)
	EntFire("stage_2_spawnear*", "Kill", "", 0.00, self)
	EntFire("stage_2_trigger*", "Kill", "", 0.00, self)
	EntFire("stage_2_torre*", "Kill", "", 0.00, self)
	EntFire("stage_2_lock*", "Kill", "", 0.00, self)
	EntFire("stage_2_template*", "kill", "", 0.00, self)
	EntFire("stage_2_door_5", "kill", "", 0.00, self)
	EntFire("stage_2_door_4", "kill", "", 0.00, self)
	EntFire("stage_2_door_6", "kill", "", 0.00, self)
	EntFire("stage_2_door_2", "kill", "", 0.00, self)
	EntFire("stage_5_retx", "kill", "", 0.00, self)
	EntFire("stage_2_door_1", "kill", "", 0.00, self)
	EntFire("stage_2_grond", "Kill", "", 0.00, self)
	EntFire("stage_2_grond_2", "Kill", "", 0.00, self)
	EntFire("stage_1_ariete", "Kill", "", 0.00, self)
	EntFire("stage_2_path_gate_*", "Kill", "", 0.00, self)
	EntFire("stage_1_arietefuego", "Kill", "", 0.00, self)
	EntFire("stage_2_platform", "Kill", "", 0.00, self)
}

function ClearStageThree()
{
	EntFire("stage_3_verja*", "Kill", "", 0.00, self);
	EntFire("stage_3_tracktrain_1*", "Kill", "", 4.00, self);
	EntFire("stage_3_tracktrain_2", "Kill", "", 4.00, self);
	EntFire("stage_2_catapult_rock3*", "Kill", "", 0.00, self);
	EntFire("stage_3_nuke*", "Kill", "", 2.00, self);
	EntFire("stage_3_prop_dynamic*", "Kill", "", 0.00, self);
	EntFire("stage_3_trigger_aumentonivel", "kill", "", 0.00, self)
	EntFire("stage_3_ret*", "Kill", "", 0.00, self);
	EntFire("stage_4_bridge_1*", "Kill", "", 0.00, self);
	EntFire("stage_3_falling_tower*", "Kill", "", 0.00, self);
	EntFire("stage_3_rocas*", "Kill", "", 0.00, self);
	EntFire("stage_3_gate_2*", "Kill", "", 0.00, self);
	EntFire("stage_3_door*", "Kill", "", 0.00, self);
	EntFire("stage_3_trigger*", "Kill", "", 0.00, self);
	EntFire("stage_3_catapult_rock*", "kill", "", 0.00, self)
	EntFire("ph_stage_3_prop_dynamic*", "kill", "", 0.00, self)
}

function CheckPlayerDoneStage()
{
	local p = null;
	local PCtcount = 0;
	local PTcount = 0;
	while(null != (p = Entities.FindByClassname(p,"player")))
	{
		if (AliveCt(p)) PCtcount++;
		else PTcount++;
	}
	EntFire("consola", "Command", "say ** Players done this part "+PCtcount.tostring()+"/"+(PTcount+PCtcount).tostring()+" **", 2.00, self);
}

function CountPlayer(index)
{
	if(index==1)
	{
	 local p = null;
	 local ctCount = 0;
	 while(null != (p = Entities.FindByClassname(p,"player")))
	 {
		 if (AliveCt(p)) ctCount++;
	 }
	 return ctCount;
	}
	else
	{
		local p = null;
	  local tCount = 0;
	  while(null != (p = Entities.FindByClassname(p,"player")))
	  {
		 if (AliveT(p)) tCount++;
	  }
		return tCount;
	}
}


function HeroSetHp()
{
	local Zombie = CountPlayer(0);
	local Humans = CountPlayer(1);
	local White = (768+(Zombie-20)*10).tostring();
	local Balrog = (37500+(Humans-40)*200).tostring();
	local Gandalf = (56+(Zombie*5)).tostring();
	EntFire("ph_item_goliath_2", "SetHealth", White, 0.00, self);
	EntFire("ph_item_gandalf_15", "SetHealth", Gandalf, 0.00, self);
	EntFire("ph_item_balrog_hp", "SetHealth", Balrog, 0.00, self);
	EntFire("item_hp_control", "runscriptcode", "GetHpWhite()", 1.00, self)
	EntFire("item_hp_control", "runscriptcode", "GetHpBalrog()", 1.00, self)
	EntFire("item_hp_control", "runscriptcode", "GetHpGandalf()", 1.00, self)
}

function SetPos(i)
{
	if (AliveCt(activator))EntFireByHandle(activator,"SetHealth","-228",0.00,null,null);
	else
	{
		switch (i)
		{
			case 0:
			EntFireByHandle(activator, "AddOutput", "origin -11028 -268 -13908", 0, null, null);
			break;
			case 1:
			EntFireByHandle(activator, "AddOutput", "origin 1946.85 5037.86 -12929.4", 0, null, null);
			break;
			case 2:
			switch (RandomInt(0, 2))
				{
					case 0:
					EntFireByHandle(activator, "AddOutput", "oirgin 5936 -400 -8233.5", 0, null, null);
					break;
					case 1:
					EntFireByHandle(activator, "AddOutput", "origin 5008 224 -8221.5", 0, null, null);
					break;
					case 2:
					EntFireByHandle(activator, "AddOutput", "origin 5168 -992 -8221.5", 0, null, null);
					break;
				}
			break;
		}
	}
}

function HorseAnim()
{
	for (local i=1; i<=8; i+=1)
	{
		local anim = null;
		local timeranim = RandomInt(1, 10);
		if(RandomInt(0, 1)) anim = "idle";
		else anim = "L01_afraid_1_idle";
		EntFire("stage_1_horses_"+i+"_x","SetAnimation", anim.tostring(), timeranim.tointeger(), self);
	}
}

function AliveCt(act){if(act.GetTeam() == 3 && act.GetHealth() > 0)return true;}
function AliveT(act){if(act.GetTeam() == 2 && act.GetHealth() > 0)return true;}

function Damage()
{
	if (AliveCt(activator))EntFireByHandle(activator,"SetHealth","-228",0.00,null,null);
	else if(EndStage)EntFireByHandle(activator,"SetHealth","-288",0.00,null,null);
}

function EndStageFour()
{
	EntFire("SaveZone_vis", "AddOutPut", "origin 6436 -197 -1871", 0.00, self);
	EntFire("SaveZone_vis", "forcespawn", "", 0.10, self);
	EntFire("SaveZone_vis", "AddOutPut", "origin 6296 -597 -1871", 0.20, self);
	EntFire("SaveZone_vis", "forcespawn", "", 0.30, self);
	EntFire("SaveZone_vis", "AddOutPut", "origin 6198 376 -1871", 1.40, self);
	EntFire("SaveZone_vis", "forcespawn", "", 1.50, self);
	EntFire("SaveZone_vis", "AddOutPut", "origin 5787 -634 -1871", 3.60, self);
	EntFire("SaveZone_vis", "forcespawn", "", 3.70, self);
	EntFire("SaveZone_vis", "AddOutPut", "origin 5243 -578 -1871", 4.60, self);
	EntFire("SaveZone_vis", "forcespawn", "", 4.70, self);
	EntFire("SaveZone_vis", "AddOutPut", "origin 5252 415 -1871", 6.80, self);
	EntFire("SaveZone_vis", "forcespawn", "", 6.90, self);
	EntFire("SaveZone_vis", "AddOutPut", "origin 4812 -188 -1871", 8.00, self);
	EntFire("SaveZone_vis", "forcespawn", "", 8.10, self);
	EntFire("SaveZone_vis", "AddOutPut", "origin 4189 -179 -1871", 12.20, self);
	EntFire("SaveZone_vis", "forcespawn", "", 12.30, self);
	EntFire("SaveZone_vis", "AddOutPut", "origin 3318 -166 -1871", 15.40, self);
	EntFire("SaveZone_vis", "forcespawn", "", 15.50, self);
	EntFire("SaveZone_vis", "AddOutPut", "origin 2582 -188 -1871", 19.60, self);
	EntFire("SaveZone_vis", "forcespawn", "", 19.70, self);
	EntFire("SaveZone_vis", "AddOutPut", "origin 1712 -120 -1871", 22.80, self);
	EntFire("SaveZone_vis", "forcespawn", "", 22.90, self);
	EntFire("SaveZone", "forcespawn", "", 29.90, self);
	EntFire("stage_1_triggerx", "Enable", "", 30.00, self)
}

function SpawnBoss()
{
	EntFire("ph_item_balrog_hp*","Break", "", 0.00, self);
}

function StartBoss()
{
	EntFire("stage_4_boss_model", "SetAnimation", "balrog_groar", 0.00, self);
	EntFire("stage_4_boss_model", "SetAnimation", "crouch_idle_upper_knife", 10.00, self);
}
