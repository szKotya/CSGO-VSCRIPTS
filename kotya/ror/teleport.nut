players <- [];
OutTeleport <- null;
function Teleport()
{
    local h = null;
    local Count = 0;
    while(null!=(h=Entities.FindInSphere(h,caller.GetOrigin(),80000)))
    {
        if(h.GetClassname() == "player")
        {
            if(!OnArray(h))
            {
                if(h.GetTeam()!=1 && h.GetHealth()>0)
                {
                    h.SetOrigin(Vector(224,160,-12))
                    InPlayer(h)
                }
                else OutPlayer(h)
            }
        }
    }
    if(OutTeleport!=null && OutTeleport.IsValid())
    {
        EntFireByHandle(OutTeleport, "AddOutPut", "OnStartTouch !activator:AddOutPut:origin 224 160 -12:0:-1", 0, null, null)
        //OutTeleport = null;
    }
}

function InPlayer(handle)
{
    printl(handle.tostring())
    if(OnArray(handle))
    {
        printl("dont push")
        return;
    }
    printl("push")
    players.push(handle);
}

function OutPlayer(handle)
{
    if(OutTeleport==null || !OutTeleport.IsValid())OutTeleport = caller;
    if(players.len() == 0)
    {
        printl("Outreturn")
        return;
    }

    for (local i = 0; i<players.len(); i++)
    {
        if(players[i] == handle)
        {
            printl("remove")
            players.remove(i);
            return;
        }
    }
}
function OnArray(handle)
{
    if(players.len() != 0)
    {
        for (local i = 0; i<players.len(); i++)
        {
            if(players[i] == handle)
            {
                return true;
            }
        }
    }
    return false;
}

function PrintInfo()
{
    for (local i = 0; i<players.len(); i++)
    {
        printl(players[i]);
    }
}