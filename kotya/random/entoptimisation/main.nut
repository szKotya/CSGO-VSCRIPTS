g_aszProp <- [
//"prop_dynamic", 
//"prop_dynamic_override", 
"prop_physics_multiplayer", 
"prop_physics"]

function Check()
{
    SendToConsoleServer("Clear");
    printl("Ентити лист");

    local handle = null;
    
    for(local i = 0; i < g_aszProp.len(); i++)
    {
        printl("");
        printl(g_aszProp[i] + " : ");

        while(null != (handle = Entities.FindByClassname(handle, g_aszProp[i])))
        {
            if(handle.IsValid())
            {
                printl(handle.GetName() + 
                " - Vector(" + handle.GetOrigin().x + 
                ", " + handle.GetOrigin().y + 
                ", " + handle.GetOrigin().z + 
                ") - " + handle.GetAngles().x + 
                ", "  + handle.GetAngles().y + 
                ", "  + handle.GetAngles().z + 
                " - "  + handle.GetModelName()
                )
            }
        }

        EntFire(g_aszProp[i], "Kill", "", 0.0, null);
    }
}