filterName <- "player";
function filter(team = 2)//ct
{
    if(activator.IsValid() && activator.GetHealth() > 0 && activator.GetTeam() == team && activator.GetName() == filterName)
    {
        EntFireByHandle(self, "FireUser1", "", 0, activator, activator);
    }
}