IncludeScript("kotya/doom2016/support/math.nut");
Target  <-  Entities.FindByName(null, "tochka");
Player  <- Entities.FindByName(null, "player");
Arroy <-[
"⬜⬜⬛⬜⬜\n⬜⬛⬜⬛⬜\n⬛⬜⬛⬜⬛\n⬜⬜⬛⬜⬜\n⬜⬜⬛⬜⬜",    //0 c
"⬜⬜⬛⬛⬛\n⬜⬜⬜⬛⬛\n⬜⬜⬛⬜⬛\n⬜⬛⬜⬜⬜\n⬛⬜⬜⬜⬜",    //1 cv
"⬜⬜⬛⬜⬜\n⬜⬜⬜⬛⬜\n⬛⬛⬛⬜⬛\n⬜⬜⬜⬛⬜\n⬜⬜⬛⬜⬜",    //2 v
"⬛⬜⬜⬜⬜\n⬜⬛⬜⬜⬜\n⬜⬜⬛⬜⬛\n⬜⬜⬜⬛⬛\n⬜⬜⬛⬛⬛",    //3 uv
"⬜⬜⬛⬜⬜\n⬜⬜⬛⬜⬜\n⬛⬜⬛⬜⬛\n⬜⬛⬜⬛⬜\n⬜⬜⬛⬜⬜",    //4 u
"⬜⬜⬜⬜⬛\n⬜⬜⬜⬛⬜\n⬛⬜⬛⬜⬜\n⬛⬛⬜⬜⬜\n⬛⬛⬛⬜⬜",    //5 uz
"⬜⬜⬛⬜⬜\n⬜⬛⬜⬜⬜\n⬛⬜⬛⬛⬛\n⬜⬛⬜⬜⬜\n⬜⬜⬛⬜⬜",    //6 z
"⬛⬛⬛⬜⬜\n⬛⬛⬜⬜⬜\n⬛⬜⬛⬜⬜\n⬜⬜⬜⬛⬜\n⬜⬜⬜⬜⬛"];   //7 cz
function Start()
{
    Player = activator;
    Tick()
}
function Tick()
{
    local Strelka = null;
    local sa=Player.GetAngles().y;
    local ta=GetTartgetYaw(Target.GetOrigin(),Player.GetOrigin());
    local angdif=abs((sa-ta+360)%360);
    angdif=abs(angdif);
    DrawAxis(Target.GetOrigin(),32,false,0.1)
    local Dist = abs(GetDistance2D(Target.GetOrigin(),Player.GetOrigin()));
    if(angdif>=0 && angdif<=45)Strelka = Arroy[0].tostring();
    if(angdif>=46 && angdif<=90)Strelka = Arroy[1].tostring();
    if(angdif>=91 && angdif<=135)Strelka = Arroy[2].tostring();
    if(angdif>=136 && angdif<=180)Strelka = Arroy[3].tostring();
    if(angdif>=181 && angdif<=225)Strelka = Arroy[4].tostring();
    if(angdif>=226 && angdif<=270)Strelka = Arroy[5].tostring();
    if(angdif>=271 && angdif<=315)Strelka = Arroy[6].tostring();
    if(angdif>=316 && angdif<=360)Strelka = Arroy[7].tostring();
    self.__KeyValueFromString("message",Strelka.tostring()+"\nDistance : "+Dist.tostring()+"\n"+angdif.tostring());
    EntFireByHandle(self, "Display", "",0.01, Player, Player);
    EntFireByHandle(self, "RunScriptCode", "Tick();", 0.05, null, null);
}

