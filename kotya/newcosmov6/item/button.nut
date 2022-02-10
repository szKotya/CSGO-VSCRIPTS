au <- true;
useloc <- true;
loc <- true;
mainscript <- Entities.FindByName(null, "map_brush");

function filter()
{
    if(Act == activator && au && loc && useloc)
    {
        EntFireByHandle(self, "FireUser4", "", 0, activator, activator);
    }
}

Act <- null;
Ticking <- true;
Weapon <- null;

function SetWeapon()
{
    Weapon = caller;
    Act = activator;
    Ticking = true;
    CheckItem();
}

function CheckItem()
{
    if(Ticking)
    {
        if(Act != null)
        {
            if(Weapon.GetRootMoveParent() != Act)
            {
                EntFireByHandle(mainscript, "RunScriptCode", "DropItem();", 0.05, Act, self);
                Ticking = false;
                Act = null;
            }
            else
            {
                EntFireByHandle(self, "RunScriptCode", "CheckItem();", 0.1, null, null);
            }
        }
    }
}

function GetStatus()
{
    if(!au || !loc || !useloc) 
    {
        return false;
    }
    else
    {
        return true;
    }
}

function OnPostSpawn()
{
    EntFireByHandle(MainScript, "RunScriptCode", "ITEM_OWNER.push(ItemOwner(caller))", 0.05, self, self);
}