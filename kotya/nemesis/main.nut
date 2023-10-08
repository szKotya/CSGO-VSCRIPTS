g_iIter <- -1;
g_aAnims <- [
"attack_flameth",
"attack_flameth_end",
"attack_flameth_loop",
"attack_flameth_reload",
"attack_left",
"attack_left1",
"attack_molot",
"attack_revers",
"attack_right",
"attack_right1",
"attack_rocket_end",
"attack_rocket_loop",
"attack_rocket_push",
"attack_rocket_start",
"attack_sparta_walk",
"attack_walk_molot",
"damage_down_end",
"damage_down_loop",
"damage_down_start",
"damage_expl_loop",
"damage_expl_end",
"damage_expl_start",
"door_open_L",
"door_open_R",
"idle",
"jump_end",
"jump_loop",
"jump_start",
"run",
"run_loop",
"run_stop",
"talk",
"tentacle_attack",
"walk",
"walk_attack",
"walk_end_L",
"walk_flame",
"walk_flame_loop",
"walk_flame_stop",
"walk_loop",
"walk_rocket",
"walk_rocket_loop",
"walk_rocket_stop",
];

function SetAnim(ID = -1, ID1 = -1)
{
	if (ID == -1)
	{
		g_iIter++;
		if (g_aAnims.len() < g_iIter - 1)
		{
			g_iIter = 0;
		}
	}
	else
	{
		g_iIter = ID;
		if (g_aAnims.len() < g_iIter - 1)
		{
			g_iIter = g_aAnims.len() - 1;
		}
	}

	printl(g_iIter + " - " + g_aAnims[g_iIter] + "");

	EntFireByHandle(self, "SetAnimation", g_aAnims[g_iIter], 0, null, null)

	if (ID1 != -1)
	{
		EntFireByHandle(self, "SetDefaultAnimation", g_aAnims[ID1], 0, null, null)
	}
	else
	{
		EntFireByHandle(self, "SetDefaultAnimation", "", 0, null, null)
	}
}