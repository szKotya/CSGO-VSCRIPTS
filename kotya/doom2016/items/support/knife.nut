Owner <- null;
Center <- null;
Weapon <- null;

function SetHandle()
{
    if(caller.GetClassname() == "func_door")Center = caller;
    if(caller.GetClassname() == "weapon_knife")Weapon = caller;
}

function SetParent()
{
    Owner = activator;
    Owner.__KeyValueFromString("targetname", "Owner"+(self.GetName().slice(self.GetPreTemplateName().len(),self.GetName().len())).tostring());
    Center.SetOrigin(activator.EyePosition())
    EntFireByHandle(Center, "SetParent", "!activator", 0.01, Weapon, Weapon);
    EntFireByHandle(self, "SetMeasureTarget", Owner.GetName().tostring(), 0.02, Owner, Owner);
    EntFireByHandle(self, "Enable", "", 0.02, Owner, Owner);
    //EntFireByHandle(self, "RunScriptCode", "Center.SetOrigin(Owner.EyePosition())", 0.02, Owner, Owner);
}
