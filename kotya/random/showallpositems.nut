EntFireByHandle(self, "runscriptcode", "ShowPos()", 0.01, null, null);

printl("СКРИПТ ПОДКЛЮЧИЛСЯ!");
printl("СКРИПТ ПОДКЛЮЧИЛСЯ!");
printl("СКРИПТ ПОДКЛЮЧИЛСЯ!");
printl("СКРИПТ ПОДКЛЮЧИЛСЯ!");

function ShowPos()
{
    printl("tick");
    for(local i = 0; i < ItemOrigin.len(); i++)
    {
        DebugDrawCircle(ItemOrigin[i], Vector(0, 255, 0), 64, 16, true, 0.6);
    }

    EntFireByHandle(self, "runscriptcode", "ShowPos()", 0.5, null, null);
}

ItemOrigin <-[
Vector(-1973,-986,1177),
Vector(-956,-3311,1322),
Vector(-1407,-3299,1235),
Vector(-410,-4785,1486),
Vector(385,-4568,590),
Vector(3544,-3918,502),
Vector(4733,-3566,606),
Vector(5085,-3267,395),
Vector(6239,-3622,339),
Vector(-1777,-1552,1449),
Vector(-1023,-3662,1307),
Vector(-43,-2068,546),
Vector(192,-2358,281),
Vector(-2188,-1931,1758),
Vector(-3304,-1882,1709),
Vector(-4238,-4274,2038),
Vector(-5930,-1308,2027),
Vector(-5622,-1552,2030),
Vector(-3693,-1276,598),
Vector(-1218,2569,299),
Vector(6712,-4488,688),
Vector(5445,-3034,242),
Vector(4896,-4600,707),
Vector(3978,-3671,142),
Vector(3546,-2966,587),
Vector(3246,-4610,543),
Vector(2448,-2419,762),
Vector(1723,-3632,619),
Vector(1886,-4237,127),
Vector(1870,-4542,883),
Vector(920,-3760,124),
Vector(552,-2656,670),
Vector(939,-1270,1068),
Vector(-510,-2728,932),
Vector(-322,-3913,918),
Vector(-727,-4457,1145),
Vector(118,-4605,883),
Vector(-345,-1269,618),
Vector(-471,-780,1157),
Vector(-1425,-717,1350),
Vector(-1392,-1480,1226),
Vector(-1592,-1248,1626),
Vector(-1477,-2550,1174),
Vector(-1259,-4688,1036),
Vector(-2151,-3861,1209),
Vector(-2024,-3449,1442),
Vector(-2241,-2422,1402),
Vector(-2461,-2581,1106),
Vector(-2416,-3200,1067),
Vector(-2145,-2768,1225),
Vector(-1966,-309,1200),
Vector(-1752,-552,1335),
Vector(-2418,-1471,1417),
Vector(-1597,-946,1067),
Vector(-2510,-1471,1091),
Vector(-2607,-950,1604),
Vector(-3240,-2176,1809),
Vector(-2256,-2624,1707),
Vector(-2523,-3055,1891),
Vector(-2198,-3598,1862),
Vector(-2994,-3567,2034),
Vector(-3759,-3087,1780),
Vector(-4436,-3658,2002),
Vector(-4360,-4247,2145),
Vector(-7255,-3463,2007),
Vector(-6712,-2256,2055),
Vector(-6444,-216,2116),
Vector(-7018,-498,2259),
Vector(-7906,-213,1855),
Vector(-5344,-1560,1931),
Vector(-5630,-649,2218),
Vector(-4750,-877,1862),
Vector(-4824,-1110,512),
Vector(-3725,764,526),
Vector(-2317,1350,348),
Vector(-2373,1723,104),
Vector(-2258,3092,232),
Vector(-405,4617,519),
Vector(-271,5451,280),
Vector(6986,-646,1181),
Vector(4934,-3756,357),
Vector(2678,-3885,410),
Vector(-1990,-2859,1492),
Vector(5078,-825,1055),
Vector(2905,-1133,783),
Vector(-1265,307,301),]


function DebugDrawCircle(Vector_Center, Vector_RGB, radius, parts, zTest, duration) //0 -32 80
{
    local u = 0.0;
    local vec_end = [];
    local parts_l = parts;
    local radius = radius;
    local a = PI / parts * 2;
    while(parts_l > 0)
    {
        local vec = Vector(Vector_Center.x+cos(u)*radius, Vector_Center.y+sin(u)*radius, Vector_Center.z);
        vec_end.push(vec);
        u += a;
        parts_l--;
    }
    for(local i = 0; i < vec_end.len(); i++)
    {
        if(i < vec_end.len()-1){DebugDrawLine(vec_end[i], vec_end[i+1], Vector_RGB.x, Vector_RGB.y, Vector_RGB.z, zTest, duration);}
        else{DebugDrawLine(vec_end[i], vec_end[0], Vector_RGB.x, Vector_RGB.y, Vector_RGB.z, zTest, duration);}
    }
}
