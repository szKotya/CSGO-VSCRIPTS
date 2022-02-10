/*
Script by Kotya[STEAM_1:1:124348087]
update 07.12.2020

　　__..,,__　　　,.｡='`1
　　　　 .,,..;~`''''　　　　`''''＜``彡　}
　 _...:=,`'　　 　︵　 т　︵　　X彡-J
＜`　彡 /　　ミ　　,_人_.　＊彡　`~
　 `~=::　　　 　　　　　　 　　　Y
　　 　i.　　　　　　　　　　　　 .:
　　　.\　　　　　　　,｡---.,,　　./
　　　　ヽ　／ﾞ''```\;.{　　　 ＼／
　　　　　Y　　　`J..r_.彳　 　|
　　　　　{　　　``　　`　　　i
　　　　　\　　　　　　　　　＼　　　..︵︵.
　　　　　`＼　　　　　　　　　``ゞ.,/` oQ o`)
　　　　　　`i,　　　　　　　　　　Y　 ω　/
　　　　 　　`i,　　　 　　.　　　　"　　　/
　　　　　　`iミ　　　　　　　　　　　,,ノ
　　　　 　 ︵Y..︵.,,　　　　　,,+..__ノ``
　　　　　(,`, З о　　　　,.ノ川彡ゞ彡　　＊
　　　　　 ゞ_,,,....彡彡~　　　`+Х彡彡彡彡*

*/
Roter <-null;
Move <-null;
Red <-0;
Green <-0;
Blue <-0;


function SetRoter() {
    Roter = caller;
    switch (RandomInt(0,3)){
    case 0:{SettingsBlue();break;}
    case 1:{SettingsRed();;break;}
    case 2:{SettingsSwapBlue();break;}
    case 3:{SettingsSwapRed();break;}
    }
}
function TeslaColor() {
    EntFireByHandle(caller, "AddOutPut", "m_Color "+Red.tostring()+" "+Green.tostring()+" "+Blue.tostring()+" 200", 0, null, null);
}
function SettingsBlue() {
    Red = 0;
    Green = 0;
    Blue = 255;
    EntFireByHandle(Roter, "Color", "0 0 255", 0, null, null);
    EntFireByHandle(self, "RunScriptCode", "RandomColor(2)", 1.2, null, null);
    EntFireByHandle(Roter, "StartBackward", "", 0.5, null, null);
}

function SettingsRed() {
    Red = 255;
    Green = 0;
    Blue = 0;
    EntFireByHandle(Roter, "Color", "255 0 0", 0, null, null);
    EntFireByHandle(self, "RunScriptCode", "RandomColor(0)", 1.2, null, null);
    EntFireByHandle(Roter, "StartForward", "", 0.5, null, null);
}

function SettingsSwapBlue() {
    local randomTimeTwo = RandomFloat(1, 2);
    Red = 0;
    Green = 255;
    Blue = 255;
    EntFireByHandle(Roter, "Color", "0 255 255", 0, null, null);
    EntFireByHandle(Roter, "StartForward", "", randomTimeTwo, null, null);
    EntFireByHandle(Roter, "StartBackward", "", 0.5, null, null);
    EntFireByHandle(self, "RunScriptCode", "RandomColor(3)", 1.2, null, null);
}

function SettingsSwapRed() {
    local randomTimeTwo = RandomFloat(1, 2);
    Red = 255;
    Green = 255;
    Blue = 0;
    EntFireByHandle(Roter, "Color", "255 255 0", 0, null, null);
    EntFireByHandle(Roter, "StartBackward", "", randomTimeTwo, null, null);
    EntFireByHandle(Roter, "StartForward", "", 0.5, null, null);
    EntFireByHandle(self, "RunScriptCode", "RandomColor(1)", 1.2, null, null);
}

function SetMove() {
    Move = caller;
    if (RandomInt(0, 1)) return;
    else {
        EntFireByHandle(Move, "SetSpeed", RandomInt(1200, 2000).tostring(), 0, null, null);
    }
}

function RandomColor(rorb) {
    if (Roter != null) {
        if (rorb == 0) {
            if (Red >= 15) {
                Red -= 10;
            }
            EntFireByHandle(self, "RunScriptCode", "RandomColor(0)", 0.1, null, null);
        } else if (rorb == 1) {
            if (Red >= 15) {
                Red -= 10;
                Green -= 10;
            }
            EntFireByHandle(self, "RunScriptCode", "RandomColor(1)", 0.1, null, null);
        } else if (rorb == 2) {
            if (Blue >= 15) {
                Blue -= 10;
            }
            EntFireByHandle(self, "RunScriptCode", "RandomColor(2)", 0.1, null, null);
        } else if (rorb == 3) {
            if (Blue >= 15) {
                Blue -= 10;
                Green -= 10;
                EntFireByHandle(self, "RunScriptCode", "RandomColor(3)", 0.1, null, null);
            }
        }
        SetColor();
    }
}

function SetColor() EntFireByHandle(Roter, "Color", Red.tostring() + " " + Green.tostring() + " " + Blue.tostring(), 0, null, null);