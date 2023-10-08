map_brush <- Entities.FindByName(null, "map_brush");

PLAYERS <- [];

function Touch()
{
    foreach(player in PLAYERS)
	{
		if(player == activator)
        {
            return;
        }
    }

    PLAYERS.push(activator);

    EntFireByHandle(map_brush, "RunScriptCode", "PoisonPlayer(10,30,1)", 0, activator, activator);
}

function OnPostSpawn()
{
    Enable();
}

function Enable()
{
    ticking = true;
    self.ConnectOutput("OnStartTouch", "Touch");
    EntFireByHandle(self, "Enable", "", 0.01, null, null);
}