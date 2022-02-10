
RandomPosArray <- [];

function test()
{
    local origin = activator.GetOrigin();
    local angles = activator.GetAngles();
    local obj = FullPos(origin,angles);

    printl(format("Vector(%f,%f,%f) : (%f, %f, %f)",
    obj.origin.x, obj.origin.y, obj.origin.z,
    obj.angles.x, obj.angles.y, obj.angles.z))
}

function test1()
{
    local temp;
    local maker;

    // temp = Entities.FindByName(null, "chest_4");
    // maker = Entities.CreateByClassname("env_entity_maker");
    // maker.__KeyValueFromString("EntityTemplate", temp.GetName())
    // //temp.Destroy();
    // RandomPosArray.push(RandomSpawn(maker));

    // temp = Entities.FindByName(null, "chest_3");
    // maker = Entities.CreateByClassname("env_entity_maker");
    // maker.__KeyValueFromString("EntityTemplate", temp.GetName())
    // //temp.Destroy();
    // //RandomPosArray.push(RandomSpawn(maker));
    // RandomPosArray[0].AddHandle(maker);

    // temp = Entities.FindByName(null, "chest_0");
    // maker = Entities.CreateByClassname("env_entity_maker");
    // maker.__KeyValueFromString("EntityTemplate", temp.GetName())
    // //temp.Destroy();
    // //RandomPosArray.push(RandomSpawn(maker));
    // RandomPosArray[0].AddHandle(maker);

    temp = Entities.FindByName(null, ::TEMP_BIO);
    maker = Entities.CreateByClassname("env_entity_maker");
    maker.__KeyValueFromString("EntityTemplate", temp.GetName())
    RandomPosArray.push(RandomSpawn(maker));

    temp = Entities.FindByName(null, ::TEMP_EARTH);
    maker = Entities.CreateByClassname("env_entity_maker");
    maker.__KeyValueFromString("EntityTemplate", temp.GetName())
    RandomPosArray[0].AddHandle(maker);

    temp = Entities.FindByName(null, ::TEMP_ICE);
    maker = Entities.CreateByClassname("env_entity_maker");
    maker.__KeyValueFromString("EntityTemplate", temp.GetName())
    RandomPosArray[0].AddHandle(maker);

    temp = Entities.FindByName(null, ::TEMP_FIRE);
    maker = Entities.CreateByClassname("env_entity_maker");
    maker.__KeyValueFromString("EntityTemplate", temp.GetName())
    RandomPosArray[0].AddHandle(maker);

    temp = Entities.FindByName(null, ::TEMP_SUMMON);
    maker = Entities.CreateByClassname("env_entity_maker");
    maker.__KeyValueFromString("EntityTemplate", temp.GetName())
    RandomPosArray[0].AddHandle(maker);

    temp = Entities.FindByName(null, ::TEMP_ELECTRO);
    maker = Entities.CreateByClassname("env_entity_maker");
    maker.__KeyValueFromString("EntityTemplate", temp.GetName())
    RandomPosArray[0].AddHandle(maker);

    temp = Entities.FindByName(null, ::TEMP_GRAVITY);
    maker = Entities.CreateByClassname("env_entity_maker");
    maker.__KeyValueFromString("EntityTemplate", temp.GetName())
    RandomPosArray[0].AddHandle(maker);

    temp = Entities.FindByName(null, ::TEMP_HEAL);
    maker = Entities.CreateByClassname("env_entity_maker");
    maker.__KeyValueFromString("EntityTemplate", temp.GetName())
    RandomPosArray[0].AddHandle(maker);

    temp = Entities.FindByName(null, ::TEMP_WIND);
    maker = Entities.CreateByClassname("env_entity_maker");
    maker.__KeyValueFromString("EntityTemplate", temp.GetName())
    RandomPosArray[0].AddHandle(maker);

    temp = Entities.FindByName(null, ::TEMP_ULTIMATE);
    maker = Entities.CreateByClassname("env_entity_maker");
    maker.__KeyValueFromString("EntityTemplate", temp.GetName())
    RandomPosArray[0].AddHandle(maker);

    temp = Entities.FindByName(null, ::TEMP_POISON);
    maker = Entities.CreateByClassname("env_entity_maker");
    maker.__KeyValueFromString("EntityTemplate", temp.GetName())
    RandomPosArray[0].AddHandle(maker);

    for (local i = 0; i < RandomPosArray.len(); i++)
    {
        local randomValue = RandomInt(20, 25);
        for (local a = 0; a < randomValue; a++)
        {
            local origin = Vector(RandomInt(-900,900), RandomInt(-900,900), RandomInt(100,500));
            local angles = Vector(RandomInt(-100,100), RandomInt(-100,100), RandomInt(-100,100));
            local obj = FullPos(origin,angles);
            RandomPosArray[i].AddPos(obj);
        }
    }

    test3()
}


class FullPos
{
    constructor(_origin, _angles)
    {
        this.angles = _angles;
        this.origin = _origin;
    }
    angles = Vector(0, 0, 0);
    origin = Vector(0, 0, 0);
}

class RandomSpawn
{
    constructor()
    {
        this.handle = [];
        this.position = [];
    }

    handle = null;
    position = null;

    function AddPos(_position)
    {
        this.position.push(_position);
    }

    function AddHandle(_handle)
    {
        printl(_handle);
        this.handle.push(_handle);
    }

    function SpawnOnPositionOne(_postion)
    {
        this.handle[0].SpawnEntityAtLocation(_postion.origin, _postion.angles);
    }


    function GetRandomSpawn()
    {
        local random = RandomInt(0, this.position.len() - 1);
        local handlePos = this.position[random];
        this.position.remove(random);
        return handlePos;
    }

    function GetRandomHandle(removepos)
    {
        local random = RandomInt(0, this.handle.len() - 1);
        local handle = this.handle[random];
        if(removepos)
            this.handle.remove(random);
        return handle;
    }

    function SpawnOnPositionTwo(handle,_postion)
    {
        handle.SpawnEntityAtLocation(_postion.origin, _postion.angles);
    }

    function ClearPosition()
    {
        this.position.clear();
    }

    function ClearHandle()
    {
        this.handle.clear();
    }

    function Print()
    {
        print("---|");
        for (local i = 0; i < this.handle.len(); i++)
        {
            print(this.handle[i]);
        }
        printl("|---")
        for (local i = 0; i < this.position.len(); i++)
        {
            printl(format("%i) Vector(%f,%f,%f) : (%f, %f, %f)", i,
            this.position[i].origin.x, this.position[i].origin.y, this.position[i].origin.z,
            this.position[i].angles.x, this.position[i].angles.y, this.position[i].angles.z))
        }
    }
}


function test2()
{
    for (local i = 0; i < RandomPosArray.len(); i++)
    {
        local randomValue = RandomInt(4, 10);
        for (local a = 0; a < randomValue; a++)
        {
            local origin = Vector(RandomInt(-900,900), RandomInt(-900,900), RandomInt(100,500));
            local angles = Vector(RandomInt(-100,100), RandomInt(-100,100), RandomInt(-100,100));
            local obj = FullPos(origin,angles);
            RandomPosArray[i].AddPos(obj);
        }
    }
    test3();
}

function test3()
{
    for (local i = 0; i < RandomPosArray.len(); i++)
    {
        RandomPosArray[i].Print();
        printl("");
    }
}

function test4(a,count)
{
    for (local i = 0; i < count; i++)
    {
        RandomPosArray[a].SpawnOnPositionOne(RandomPosArray[a].GetRandomSpawn());
    }
}

function test5(count)
{
    for (local i = 0; i < count; i++)
    {
        RandomPosArray[0].SpawnOnPositionTwo(
        RandomPosArray[0].GetRandomHandle(true),
        RandomPosArray[0].GetRandomSpawn());
    }
}

ChestRandomSpawn <- RandomSpawn();

function PushChestPosition()
{
    ChestRandomSpawn.ClearPosition();
    ChestRandomSpawn.ClearHandle();

    local temp;
    local maker;

    // temp = Entities.FindByName(null, "chest_4");
    // maker = Entities.CreateByClassname("env_entity_maker");
    // maker.__KeyValueFromString("EntityTemplate", temp.GetName())
    // ChestRandomSpawn.AddHandle(maker);

    temp = Entities.FindByName(null, "chest_3");
    maker = Entities.CreateByClassname("env_entity_maker");
    maker.__KeyValueFromString("EntityTemplate", temp.GetName())
    ChestRandomSpawn.AddHandle(maker);

    temp = Entities.FindByName(null, "chest_0");
    maker = Entities.CreateByClassname("env_entity_maker");
    maker.__KeyValueFromString("EntityTemplate", temp.GetName())
    ChestRandomSpawn.AddHandle(maker);

    for(local i = 0; i < ChestOrigin.len(); i++)
    {
        ChestRandomSpawn.AddPos(ChestOrigin[i]);
    }
    local pos
    for(local i = 0; i < 12; i++)
    {
        pos = ChestRandomSpawn.GetRandomSpawn();
        DebugDrawCircle(pos.origin, Vector(255,255,255), 64, 16, true, 64);
        ChestRandomSpawn.SpawnOnPositionTwo(
        ChestRandomSpawn.GetRandomHandle(false),
        pos);
    }
}

ChestOrigin <-[
FullPos(Vector(-1249,-190,1042),Vector(0,90,0)),
FullPos(Vector(-1470,-3317,1024),Vector(0,227.5,0)),
FullPos(Vector(-2459,-3031,1183),Vector(0,270,0)),
FullPos(Vector(6254,-3564,72.0004),Vector(0,180,0)),
FullPos(Vector(2692,-4550,584),Vector(0,217.5,0)),
FullPos(Vector(542,5054,598),Vector(0,323,0)),
FullPos(Vector(755,5347,586),Vector(0,0,0)),
FullPos(Vector(457,-2420,72),Vector(0,78,0)),
FullPos(Vector(2414,-3009,701),Vector(0,352,0)),
FullPos(Vector(5215,-3489,488),Vector(0,90,0)),
FullPos(Vector(6599,-4375,328),Vector(0,90,0)),
FullPos(Vector(3837,-3724,296),Vector(0,90,0)),
FullPos(Vector(3366,-4636,328),Vector(0,90,0)),
FullPos(Vector(502,-4204,83),Vector(-2.76871,127.914,3.54881)),
FullPos(Vector(197,-3995,840),Vector(0,90,0)),
FullPos(Vector(-601,-4462,1229),Vector(0,0,0)),
FullPos(Vector(-2393.56,-2567,1346),Vector(0,5.00001,0)),
FullPos(Vector(-2399,-2786,1024),Vector(0,90,0)),
FullPos(Vector(-2023,-1715,1024.3),Vector(0,180,0)),
FullPos(Vector(-2070,-1028,920),Vector(0,90,0)),
FullPos(Vector(-1990,-1224,1584),Vector(0,180,0)),
FullPos(Vector(-2582,-1489,1183),Vector(0,180,0)),
FullPos(Vector(-2190,-2133,1664),Vector(0,90,0)),
FullPos(Vector(-2163,-2920,1664),Vector(0,90,0)),
FullPos(Vector(-7167,-419,1824),Vector(0,0,0)),
FullPos(Vector(-7299,-3465,1824),Vector(0,180,0)),
FullPos(Vector(-5210,-1508,1880),Vector(0,90,0)),
FullPos(Vector(-5448,-663,2176),Vector(0,90,0)),
FullPos(Vector(-2775,622,492.605),Vector(0,180,0)),
FullPos(Vector(-1264,1703,419.367),Vector(0,180,0)),
FullPos(Vector(-4360,-945,1602.46),Vector(0,35.5,0)),
FullPos(Vector(-2925.67,-3746.38,1664),Vector(0,90,0))
]

ItemRandomSpawn <- RandomSpawn();

function PushItemPosition()
{
    ItemRandomSpawn.ClearPosition();
    ItemRandomSpawn.ClearHandle();

    local temp;
    local maker;

    temp = Entities.FindByName(null, "chest_4");
    maker = Entities.CreateByClassname("env_entity_maker");
    maker.__KeyValueFromString("EntityTemplate", temp.GetName())
    ItemRandomSpawn.AddHandle(maker);

    for (local i = 0; i < ItemOrigin.len(); i++)
    {
        local origin = ItemOrigin[i];
        local angles = Vector(0, 0, 0);
        local obj = FullPos(origin,angles);
        ItemRandomSpawn.AddPos(obj);
    }

    local pos
    for(local i = 0; i < 8; i++)
    {
        pos = ItemRandomSpawn.GetRandomSpawn();
        DebugDrawCircle(pos.origin, Vector(255,255,255), 64, 16, true, 64);
        ItemRandomSpawn.SpawnOnPositionTwo(
        ItemRandomSpawn.GetRandomHandle(false),
        pos);
    }
}

ItemOrigin <-[
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
Vector(-271,5451,280)]


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