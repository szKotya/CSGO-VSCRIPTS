::g_hText <- null;

g_bSetSettings <- true;

const TICKRATE = 1.0;

function Init() 
{
    if (g_hText == null || 
    !g_hText.IsValid() || 
    g_hText.GetClassName() != "game_text")
    {
        CreateGameText();
    }

    if (g_bSetSettings) {SetSettings();}

    ResetTimer();
}
//  Game text settings
{
    sColor <- color.RED;
    fcoordX <- -1.0;
    fcoordY <- -1.0;
    iChannel <- 3;

    function CreateGameText() 
    {
        g_hText = Entities.CreateByClassname("game_text");
    }

    function SetSettings() 
    {
        g_hText.__KeyValueFromInt("spawnflags", 1);
        g_hText.__KeyValueFromString("targetname", "map_script_timer");

        g_hText.__KeyValueFromInt("channel", iChannel);

        g_hText.__KeyValueFromInt("effect", 0);
        g_hText.__KeyValueFromFloat("holdtime", TICKRATE);
        g_hText.__KeyValueFromString("message", "");
        g_hText.__KeyValueFromString("color", sColor);
        g_hText.__KeyValueFromFloat("y", fcoordY);
        g_hText.__KeyValueFromFloat("x", fcoordX);
    }

    enum color
    {
        RED = "255 0 0",
        GREEN = "0 255 0",
        BLUE = "0 0 255",
        YELLOW = "255 255 0",
    }
}


//  Main Staff
{
    g_sText <- "";
    g_iSearh <- -1;
    g_iReplace <- -1;

    function SetTimer(ID) 
    {
        switch (ID) 
        {
            case 0:
                g_sText = "11 sec";
                g_iSearh = 11;

                break;
            case 1:
                g_sText = "main door will open in 32 sec";
                g_iSearh = 32;

                break;
            default:
                return;
        }
        


        g_iReplace = g_iSearh;

        Tick();
    }

    function Tick() 
    {
        local text = GetText(g_sText, g_iSearh, g_iReplace);

        if (--g_iReplace < 0)
        {
            return ResetTimer();
        }
        //printl(text)
        EntFireByHandle(g_hText, "SetText", "" + text, 0.00, null, null);
        EntFireByHandle(g_hText, "Display", "", 0.00, null, null);

        EntFireByHandle(self, "RunScriptCode", "Tick()", TICKRATE, null, null);
    }

    function GetText(text, search, replace) 
    {
        local returntext = "";
        local pos;

        pos = text.find(search.tostring());
        if (pos == null) {printl("ERROR"); return;} 
        
        returntext += text.slice(0, pos);
        returntext += replace;
        returntext += text.slice((pos + (search.tostring()).len()), text.len());
        return returntext;
    }

    function ResetTimer() 
    {
        g_sText <- "";
        g_iSearh <- -1;
        g_iReplace <- -1;
    }
}

EntFireByHandle(self, "RunScriptCode", "Init()", 1.00, null, null);