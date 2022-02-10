function SetGlowModelPlayer()
{
    if(caller != null && caller.IsValid() && caller.GetHealth())
    {
        local pl_model = caller.GetModelName();
        local MODEL_GLOW = Entities.CreateByClassname("prop_dynamic_glow");
        MODEL_GLOW.__KeyValueFromString("targetname", "pl_model");
        MODEL_GLOW.__KeyValueFromInt("glowdist",1024);
        MODEL_GLOW.__KeyValueFromInt("effects",1);
        MODEL_GLOW.__KeyValueFromString("glowcolor", "255 0 0");
        MODEL_GLOW.__KeyValueFromInt("glowenabled", 1);
        MODEL_GLOW.__KeyValueFromInt("glowstyle", 0);
        MODEL_GLOW.__KeyValueFromInt("rendermode", 6);
        MODEL_GLOW.__KeyValueFromInt("DisableBoneFollowers", 1);
        MODEL_GLOW.SetModel(pl_model);
        MODEL_GLOW.SetOrigin(caller.GetOrigin());
        EntFireByHandle(MODEL_GLOW, "SetParent", "!activator", 0.00, caller, null);
        EntFireByHandle(MODEL_GLOW, "SetParentAttachment", "primary", 0.00, null, null);
    }
}