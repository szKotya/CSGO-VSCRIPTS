g_aszOriginal <- [
            "q","w","e","r","t","y","u","i","o","p",
            "a","s","d","f","g","h","j","k","l",
            "z","x","c","v","b","n","m"];

g_aszConvert <- [
            "90","96","78","91","93","98","94","82","88","89",
            "74","92","77","79","80","81","83","84","85",
            "99","97","76","95","75","87","86"];

g_aszSecretWord <- "";            
g_aszSecretWord_Convert <- "";
g_aiGenerateWord_Len <- [3, 4];

g_aszEnter <- "";

g_hEnter <- null;
g_hSecretWord <- null;
g_bDone <- false;
function ButtonPress(ivalue)
{
    if(g_bDone)
        return;
    if(ivalue <= 9)
    {
        if(g_aszEnter.len() >= g_aszSecretWord_Convert.len()){return;}

        g_aszEnter += ivalue;
        SetText(g_hEnter, g_aszEnter);
    }
    else if(ivalue == 10)
    {
        if(g_aszEnter.len() > 0)
        {
            g_aszEnter = g_aszEnter.slice(0, g_aszEnter.len()-1)
            SetText(g_hEnter, g_aszEnter);
            SetColor(g_hEnter, "255 255 255")
        }
    }
    else if(ivalue == 11)
    {
        if(g_aszEnter == g_aszSecretWord_Convert)
        {
            g_bDone = true;
            SetColor(g_hEnter, "0 255 0")
            EntFireByHandle(self, "FireUser1", "", 0, null, null);
        }
        else
        {
            SetColor(g_hEnter, "255 0 0")
        }
    }
}

function Init()
{
    g_hEnter = Entities.CreateByClassname("point_worldtext");
    g_hSecretWord = Entities.CreateByClassname("point_worldtext");
    SetColor(g_hEnter, "255 255 255")
    SetColor(g_hSecretWord, "255 255 255")
    g_hEnter.__KeyValueFromFloat("textsize", 9.0);
    g_hSecretWord.__KeyValueFromFloat("textsize", 9.0);

    for(local i = 0; i <= 11; i+=1)
    {
        EntFireByHandle(EntityGroup[i], "AddOutPut", "OnPressed "+self.GetName().tostring()+":RunScriptCode:ButtonPress(" + i.tostring() + "):0:-1", 0, null, null);
    }

    Gen_comb();
}

function Gen_comb()
{
    g_bDone = false;
    g_aszEnter = "";
    g_aszSecretWord = "";
    g_aszSecretWord_Convert = "";
    

    SetText(g_hEnter, g_aszEnter);

    for(local i = 0; i < RandomInt(g_aiGenerateWord_Len[0], g_aiGenerateWord_Len[1]); i++)
    {
        local id = RandomInt(0,g_aszOriginal.len() - 1);
        g_aszSecretWord += g_aszOriginal[id];
        g_aszSecretWord_Convert += g_aszConvert[id];
    }

    SetText(g_hSecretWord, g_aszSecretWord);
    g_hEnter.SetOrigin(Vector(188, 9808, -1700));
    g_hSecretWord.SetOrigin(Vector(191.5, 9800, -1720));
}

function SetText(handle, text){handle.__KeyValueFromString("message", text);}
function SetColor(handle, color){handle.__KeyValueFromString("color", color);}

Init();
