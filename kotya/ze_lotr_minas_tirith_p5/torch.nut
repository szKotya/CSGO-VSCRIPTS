////////////////////////////////////////////////////////////////////
//Script by Kotya[STEAM_1:1:124348087]
//Put here scripts\vscripts\stripper\kotya\ze_lotr_minas_tirith_p5\
//update 08.06
////////////////////////////////////////////////////////////////////
GlowDist <- 700;

function GlowTorch()
{
	GlowDist-=15;
	EntFireByHandle(self,"addoutput","distance "+GlowDist,0.00,null,null);
	EntFireByHandle(self,"runscriptcode","GlowTorch()",1.40,null,null);
}