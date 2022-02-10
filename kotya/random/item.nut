ArrayPos <- [];
printl("СКРИПТ ПОДКЛЮЧИЛСЯ!");
printl("СКРИПТ ПОДКЛЮЧИЛСЯ!");
printl("СКРИПТ ПОДКЛЮЧИЛСЯ!");
printl("СКРИПТ ПОДКЛЮЧИЛСЯ!");
function ShowPosAll()
{
    printl("---------ПОЗИЦИИ---------")
    for(local i=0; i < ArrayPos.len();i++)
    {
        printl("AddSpot(Vector("+ArrayPos[i].x+","+ArrayPos[i].y+","+ArrayPos[i].z+"),ITEMNAME)")
        DebugDrawCircle(ArrayPos[i], Vector(255,255,255), 32, 16, true, 16)
    }
    printl("--------------------------")
}


function AddPos()
{
    local pos = activator.GetOrigin() + Vector(0,0,45);
    DebugDrawCircle(pos, Vector(0,0,255), 32, 16, true, 1)
    ArrayPos.push(pos);
}

function DeletePos()
{
    local last = ArrayPos.len() - 1;
    DebugDrawCircle(ArrayPos[last], Vector(255,0,0), 32, 16, true, 1);
    ArrayPos.remove(last);
}

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