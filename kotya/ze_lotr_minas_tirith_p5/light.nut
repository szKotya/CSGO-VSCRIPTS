////////////////////////////////////////////////////////////////////
//Script by Kotya[STEAM_1:1:124348087]
//Put here scripts\vscripts\stripper\kotya\ze_lotr_minas_tirith_p5\
//update 08.06
////////////////////////////////////////////////////////////////////
GlowDist <- 100;

function OnPostSpawn()
{
	if(GlowDist<=1000)
	{
		GlowDist+=30;
		EntFireByHandle(self,"addoutput","distance "+GlowDist,0.00,null,null);
		EntFireByHandle(self,"runscriptcode","OnPostSpawn()",0.2,null,null);
	}
	else EntFireByHandle(self,"addoutput","style 6",0.00,null,null);
}
