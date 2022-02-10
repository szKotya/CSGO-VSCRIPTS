IncludeScript("kotya/doom2016/items/support/items.nut");
IncludeScript("kotya/doom2016/support/math.nut");
IncludeScript("kotya/doom2016/support/models.nut");
//////////////////////
//   Handle block   //
//////////////////////
Model  <- null;
Effect <- null;

Hade_CD <- 50;
Hade_CAN <- true;

function SetHandle()
{
    local name = caller.GetName();
    if(caller.GetClassname() == "prop_dynamic_glow")Model = caller;
}

//////////////////////
//    Main Block    //
//////////////////////
function filter()
{
    if(self.GetMoveParent().GetMoveParent() == activator && Hade_CAN)
    {
        local Script = Entities.FindByName(null, "map_brush");
        if(!(Script.IsValid()) || Script == null) return;
        EntFireByHandle(Script, "RunScriptCode", "GetGravityNade();", 0.01, activator, activator);
        Hade_CAN = false;
        EntFireByHandle(self, "RunScriptCode", "Hade_CAN = true;", Hade_CD, null, null);
    }
}
