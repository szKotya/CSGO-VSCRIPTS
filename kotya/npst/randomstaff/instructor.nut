debug <- true;
instructor_target <- null;
instructor_hint <- null;

instructor_ico <- [
"icon_alert", //black
"icon_alert_red", //white
"icon_tip",     //revers !
"icon_interact",//hand
"icon_door",    //door
"icon_mouseRight",//right
"icon_mouseLeft",//left
"icon_mouseWheel_up",
"icon_mouseWheel_down",
"icon_mouseThree",//key mouse
"icon_key_generic",//key base
"icon_key_wide",//key space
"icon_key_right",//key right
"icon_key_left",//key left
"icon_key_down",//key donw
"icon_key_up"   //key up
"icon_dpad",    //joystick
"icon_fire",    //fire
"icon_blank_wide"]//joystick

Color <- "255 255 255"//RGB
::PressButton <- "Press button, pls";
::BreakThis <- "Break this";

function Pre_Button(Text = ::PressButton, time = 0, throughWall = true, Range = 512)
{
    IH_Start(Text, time, true, throughWall, true, true, Range, 3, 1);
}

function Pre_Break(Text = ::BreakThis, time = 0, throughWall = true, Range = 512)
{
    IH_Start(Text, time, true, throughWall, true, true, Range, 0, 1);
}

function IH_Start(Text = "Default text", time = 0, HaveTarget = false, throughWall = false, Alpha = false,Pulse = false, Range = 512, on = 1, off = 1,)
{
    if(instructor_hint  !=  null && instructor_hint.IsValid())
    {
        printl("ERRROR")
        return;
    }
    try
    {
        instructor_hint = Entities.CreateByClassname("env_instructor_hint");
        instructor_hint.__KeyValueFromString("targetname", "instructor_hint");
        instructor_hint.__KeyValueFromString("hint_caption", Text);
        instructor_hint.__KeyValueFromString("hint_color", Color);
        instructor_hint.__KeyValueFromString("hint_forcecaption", throughWall.tointeger().tostring());

        if(typeof on == "string")
        {
            instructor_hint.__KeyValueFromString("hint_binding", on);
            instructor_hint.__KeyValueFromString("hint_icon_onscreen", "use_binding");
        }
        else
        {
            instructor_hint.__KeyValueFromString("hint_icon_onscreen", instructor_ico[on]);
        }
        instructor_hint.__KeyValueFromString("hint_icon_offscreen", instructor_ico[off]);

        //instructor_hint.__KeyValueFromString("hint_nooffscreen", "1"); When the hint is offscreen show arrow
        if(Pulse)
        {
            instructor_hint.__KeyValueFromString("hint_pulseoption", "1");
        }

        if(Alpha)
        {
            instructor_hint.__KeyValueFromString("hint_alphaoption", "1");
        }

        instructor_hint.__KeyValueFromString("hint_range", Range.tostring());

        if(HaveTarget)
        {
            if(instructor_target   !=  null && instructor_target.IsValid())
            {
                local instructor_target_name = instructor_target.GetName();
                if(instructor_target_name == "")
                {
                    instructor_target.__KeyValueFromString("targetname", "instructor_target");
                }
                instructor_hint.__KeyValueFromString("hint_target", instructor_target_name);
                if(instructor_target.GetClassname() == "prop_dynamic_glow")
                {
                    EntFireByHandle(instructor_target, "SetGlowEnabled", "", 0, instructor_hint, instructor_hint);
                }
            }
        }
        if(instructor_hint  !=  null && instructor_hint.IsValid())
        {
            EntFireByHandle(instructor_hint, "ShowHint", "", 0.01, instructor_hint, instructor_hint);
            if(time !=  0)
            {
                EntFireByHandle(self, "RunScriptCode", "IH_Stop()", time, instructor_hint, instructor_hint);
            }
        }
    }
    catch(error)
    {
        EntFireByHandle(instructor_hint, "Kill", "", 0 + 0.01, instructor_hint, instructor_hint);
        instructor_hint = null;
    }
}

function IH_SetColor(Red = 255,Blue = 255,Green = 255)
{
    try
    {
        Color = IH_SetColorSupport(Red).tostring();
        Color+=" "+IH_SetColorSupport(Blue).tostring();
        Color+=" "+IH_SetColorSupport(Green).tostring();
    }
    catch(error)
    {
        printl("ERRROR")
        if(Color != "255 255 255")
        {
            Color = "255 255 255";
        }
    }
    if(debug)printl(Color);
}

function IH_SetColorSupport(int)
{
    if(int >= 0 && int <= 255)
    {
        return int;
    }
    else if(int > 255)
    {
        return 255;
    }
    else return 0;

}

function IH_Stop()
{
    if(instructor_hint  !=  null && instructor_hint.IsValid())
    {
        EntFireByHandle(instructor_hint, "EndHint", "", 0, instructor_hint, instructor_hint);
        EntFireByHandle(instructor_hint, "Kill", "", 0 + 0.01, instructor_hint, instructor_hint);
        instructor_hint = null;
    }
    if(instructor_target   !=  null && instructor_target.IsValid())
    {
        if(instructor_target.GetClassname() == "prop_dynamic_glow")
        {
            EntFireByHandle(instructor_target, "SetGlowDisabled", "", 0, instructor_hint, instructor_hint);
        }
        instructor_target = null;
    }
}

function IH_SetTarget()
{
    instructor_target = caller;
    if(debug)
    {
        local Name = caller.GetName();
        if(Name == "")Name = "Null"
        ScriptPrintMessageCenterAll("Name : "+Name+"\nTarget : "+instructor_target);
    }
}
