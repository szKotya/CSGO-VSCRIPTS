//Main
{
    ::Music <- self;
    
    class class_music
    {
        path = "";
        duration = 0;
        repit = false;
        display = ""

        constructor(_path, _duration, _repit, _display = "")
        {
            this.path = _path;
            this.duration = _duration;
            this.repit = _repit;
            this.display = _display;
        }
    }

    Music_Text <- Entities.CreateByClassname("game_text");
    Music_Text.__KeyValueFromInt("spawnflags", 1);
    Music_Text.__KeyValueFromInt("channel", 3);
    Music_Text.__KeyValueFromInt("effect", 0);
    Music_Text.__KeyValueFromVector("color", Vector(255, 0, 0));
    Music_Text.__KeyValueFromVector("color2", Vector(193, 87, 0));
    Music_Text.__KeyValueFromFloat("y", 0.2);
    Music_Text.__KeyValueFromFloat("x", -1.0);
    Music_Text.__KeyValueFromFloat("fadein", 1.5);
    Music_Text.__KeyValueFromFloat("fadeout", 0.5);
    Music_Text.__KeyValueFromFloat("holdtime", 4.0);

    //чтобы запустить трек пиши это ent_fire music runscriptcode "SetMusic(M_Argent)"

    //Пример путь к файлу, реальная длительность трека

    ::Music_StartGate01 <- class_music("music/NPST/ze_npst_music_0.mp3", 170, false, "Turboslash - Streetfire"); self.PrecacheScriptSound( Music_StartGate01.path );
    ::Music_StartGate02 <- class_music("music/NPST/ze_npst_music_0bis.mp3", 130, false, "Turboslash - Data Collapse"); self.PrecacheScriptSound( Music_StartGate02.path );

    ::Music_Saw01 <- class_music("music/NPST/ze_npst_music_1bis2.mp3", 150, false, "Turboslash - GodMod Domination"); self.PrecacheScriptSound( Music_Saw01.path );
    ::Music_Saw02 <- class_music("music/NPST/ze_npst_music_1bis.mp3", 150, false, "Perturbator - Diabolus Ex Machina"); self.PrecacheScriptSound( Music_Saw02.path );

    ::Music_StartOffice01 <- class_music("music/NPST/ze_npst_music_8.mp3", 97, false, "Noisecream - Neon Murder"); self.PrecacheScriptSound( Music_StartOffice01.path );
    ::Music_StartOffice02 <- class_music("music/NPST/ze_npst_music_8bis.mp3", 97, false, "Noisecream - Brilliant"); self.PrecacheScriptSound( Music_StartOffice02.path );

    ::Music_Sewerage01 <- class_music("music/NPST/ze_npst_music_3.mp3", 209, false, "Carpenter Brut - Run sally Run"); self.PrecacheScriptSound( Music_Sewerage01.path );
    ::Music_Sewerage02 <- class_music("music/NPST/ze_npst_music_3bis.mp3", 208, false, "Turboslash - Rush!"); self.PrecacheScriptSound( Music_Sewerage02.path );

    ::Music_Eatery01 <- class_music("music/NPST/ze_npst_music_2.mp3", 185, false, "Carpenter Brut - Sexkiller on the Loose"); self.PrecacheScriptSound( Music_Eatery01.path );
    ::Music_Eatery02 <- class_music("music/NPST/ze_npst_music_2bis.mp3", 176, false, "Perturbator - Neo Tokyo"); self.PrecacheScriptSound( Music_Eatery02.path );

    ::Music_Lift01 <- class_music("music/NPST/ze_npst_music_4.mp3", 158, false, "Carpenter Brut - Turbo Killer"); self.PrecacheScriptSound( Music_Lift01.path );
    ::Music_Lift02 <- class_music("music/NPST/ze_npst_music_1.mp3", 158, false, "Turboslash - Memory Reset"); self.PrecacheScriptSound( Music_Lift02.path );

    ::Music_Dike01 <- class_music("music/NPST/ze_npst_music_6.mp3", 158, false, "Carpenter Brut - Roller Mobster"); self.PrecacheScriptSound( Music_Dike01.path );
    ::Music_Dike02 <- class_music("music/NPST/ze_npst_music_6bis.mp3", 175, false, "Perturbator - The Cult Of 2112"); self.PrecacheScriptSound( Music_Dike02.path );

    ::Music_NormalEnd <- class_music("music/NPST/ze_npst_music_7.mp3", 451, false, ""); self.PrecacheScriptSound( Music_NormalEnd.path );

    ::Music_SecretEnd <- class_music("music/NPST/ze_npst_music_7bis.mp3", 462, false, ""); self.PrecacheScriptSound( Music_SecretEnd.path );

    ::Music_Nihilanth_Phase1 <- class_music("music/npst/NihiBattle/ze_npst_music_nihilanth_1.mp3", 91, true, ""); self.PrecacheScriptSound( Music_Nihilanth_Phase1.path );
    ::Music_Nihilanth_Phase2 <- class_music("music/npst/NihiBattle/ze_npst_music_nihilanth_2.mp3", 44, true, ""); self.PrecacheScriptSound( Music_Nihilanth_Phase2.path );
    ::Music_Nihilanth_Phase3 <- class_music("music/npst/NihiBattle/ze_npst_music_nihilanth_3.mp3", 112, true, ""); self.PrecacheScriptSound( Music_Nihilanth_Phase3.path );
    ::Music_Nihilanth_Phase4 <- class_music("music/npst/NihiBattle/ze_npst_music_nihilanth_4.mp3", 35, true, ""); self.PrecacheScriptSound( Music_Nihilanth_Phase4.path );
    ::Music_Nihilanth_Phase5 <- class_music("music/npst/NihiBattle/ze_npst_music_nihilanth_5.mp3", 25, false, ""); self.PrecacheScriptSound( Music_Nihilanth_Phase5.path );

    Current_Sound <- null;
    
    tick <- 0;
    RepitSound <- false;

    function TickMusic()
    {
        tick--;  
        if(tick > 0)
            EntFireByHandle(self,"RunScriptCode", "TickMusic()", 1.0, null, null);
        else if(Current_Sound.repit && RepitSound)
        {
            tick = Current_Sound.duration;
            EntFireByHandle(self, "PlaySound", "", 0.00, null, null);
            EntFireByHandle(self, "RunScriptCode", "TickMusic()", 1.0, null, null);
        }
            
    }

    function SetMusic(Name)
    {
        RepitSound = false;
        Current_Sound = Name;

        if(Name.display != "")
        {
            EntFireByHandle(Music_Text, "SetText", "[Music] " + Name.display, 1.00, null, null);
            EntFireByHandle(Music_Text, "Display", "", 1.00, null, null);
        }
            
        if(Name.repit)
            EntFireByHandle(self, "RunScriptCode", "RepitSound = true", 8.00, null, null);
        if(tick > 2)
        {
            local time = 0;
            
            for(local i = 1; i <= 10; i++)
            {
                time += 0.2;
                EntFireByHandle(self,"Volume", "" + (10 - i),time,null,null);
            }

            EntFireByHandle(self, "StopSound", "", 2.00, null, null);
            EntFireByHandle(self, "AddOutPut", "message "+Name.path, 2.02, null, null);
            EntFireByHandle(self, "PlaySound", "", 2.05, null, null);

            if(Name.duration > 4)
            {
                time = 2.05;
                for(local i = 1; i <= 10; i++)
                {
                    time += 0.2;
                    EntFireByHandle(self,"Volume","" + i, time,null,null);
                }
            }
            //EntFireByHandle(Music,"Volume", "10",2.02,null,null);

            EntFireByHandle(self,"RunScriptCode", "tick = " + (Name.duration + 2), 0, null, null);
        }
        else
        {
            EntFireByHandle(self, "StopSound", "", 0.00, null, null);

            EntFireByHandle(self, "AddOutPut", "message " + Name.path, 0.01, null, null);

            if(Name.duration > 4)
            {
                local time = 0.02;
                for(local i = 1; i <= 10; i++)
                {
                    EntFireByHandle(self, "Volume", "" + i, time, null, null);
                    time += 0.2;
                }
            }
           
            EntFireByHandle(self, "PlaySound", "", 0.05,null,null);

            EntFireByHandle(self,"RunScriptCode", "tick = " + Name.duration, 0, null, null);

            EntFireByHandle(self,"RunScriptCode", "TickMusic()", 1.0, null, null);
        }
    }
}

function GetMusicFirstGate()
{
    if (Music_0)
    {
        EntFireByHandle(self, "RunScriptCode", "SetMusic(Music_StartGate01)", 0, null, null);
    }
    else
    {
        EntFireByHandle(self, "RunScriptCode", "SetMusic(Music_StartGate02)", 18.0, null, null);
    }

    Music_0 = !Music_0;
}

function GetMusicOffice()
{
    if (Music_1)
    {
        EntFireByHandle(self, "RunScriptCode", "SetMusic(Music_StartOffice01)", 0, null, null);
    }
    else
    {
        EntFireByHandle(self, "RunScriptCode", "SetMusic(Music_StartOffice02)", 0, null, null);
    }
    
    Music_1 = !Music_1;
}

function GetMusicSaw()
{
    if (Music_2)
    {
        EntFireByHandle(self, "RunScriptCode", "SetMusic(Music_Saw01)", 0, null, null);
    }
    else
    {
        EntFireByHandle(self, "RunScriptCode", "SetMusic(Music_Saw02)", 0, null, null);
    }
    
    Music_2 = !Music_2;
}


function GetMusicEatery()
{
    if (Music_3)
    {
        EntFireByHandle(self, "RunScriptCode", "SetMusic(Music_Eatery01)", 0, null, null);
    }
    else
    {
        EntFireByHandle(self, "RunScriptCode", "SetMusic(Music_Eatery02)", 0, null, null);
    }
    
    Music_3 = !Music_3;
}

function GetMusicSewerage()
{
    if (Music_4)
    {
        EntFireByHandle(self, "RunScriptCode", "SetMusic(Music_Sewerage01)", 0, null, null);
    }
    else
    {
        EntFireByHandle(self, "RunScriptCode", "SetMusic(Music_Sewerage02)", 0, null, null);
    }
    
    Music_4 = !Music_4;
}

function GetMusicLift()
{
    if (Music_5)
    {
        EntFireByHandle(self, "RunScriptCode", "SetMusic(Music_Lift01)", 0, null, null);
    }
    else
    {
        EntFireByHandle(self, "RunScriptCode", "SetMusic(Music_Lift02)", 0, null, null);
    }
    
    Music_5 = !Music_5;
}

function GetMusicDike()
{
    if (Music_6)
    {
        EntFireByHandle(self, "RunScriptCode", "SetMusic(Music_Dike01)", 0, null, null);
    }
    else
    {
        EntFireByHandle(self, "RunScriptCode", "SetMusic(Music_Dike02)", 0, null, null);
    }
    
    Music_6 = !Music_6;
}

::bSecret <- false;

function GetMusicEnding()
{
    if (bSecret)
        GetMusicSecretEnd();
    else
        GetMusicEnd();
}

function GetMusicEnd()
{
    EntFireByHandle(self, "RunScriptCode", "SetMusic(Music_NormalEnd)", 0, null, null);
    
    EntFireByHandle(Music_Text, "SetText", "[Music] Turboslash - Phantom", 5.00, null, null);
    EntFireByHandle(Music_Text, "Display", "", 5.00, null, null);

    EntFireByHandle(Music_Text, "SetText", "[Music] Carpenter Brut - You're mine", 193.00, null, null);
    EntFireByHandle(Music_Text, "Display", "", 193.00, null, null);

    EntFireByHandle(Music_Text, "SetText", "[Music] Carpenter Brut - Division Ruine", 356.00, null, null);
    EntFireByHandle(Music_Text, "Display", "", 356.00, null, null);
}

    /*
        "Turboslash - Phantom"
        "Carpenter Brut - You're mine"
        "Carpenter Brut - Division Ruine"
    */

function GetMusicSecretEnd()
{
    EntFireByHandle(self, "RunScriptCode", "SetMusic(Music_SecretEnd)", 0, null, null);

    EntFireByHandle(Music_Text, "SetText", "[Music] Turboslash - Echoes", 5.00, null, null);
    EntFireByHandle(Music_Text, "Display", "", 5.00, null, null);

    EntFireByHandle(Music_Text, "SetText", "[Music] Turboslash - Neurohack", 193.00, null, null);
    EntFireByHandle(Music_Text, "Display", "", 193.00, null, null);

    EntFireByHandle(Music_Text, "SetText", "[Music] Turboslash - Legend", 288.00, null, null);
    EntFireByHandle(Music_Text, "Display", "", 288.00, null, null);
}
    /*
        Turboslash - Echoes
        Turboslash - Neurohack
        Turboslash - Legend
    */