chest <- "models/kmodels/cosmo/cosmocanyon/chest/chest.mdl";
ArrayPos <- [];
ArrayAng <- [];
function Find()
{
    local model = null;
	while((model = Entities.FindByClassname(model,"prop_dynamic")) != null)
    {
        if(model.GetModelName() == chest)
        {
            local pos = model.GetOrigin();
            local ang = model.GetAngles();
            ArrayPos.push(pos);
            ArrayAng.push(ang);
        }
    }
}

function ShowPosAll()
{
    printl("---------ПОЗИЦИИ---------")
    for(local i=0; i < ArrayPos.len();i++)
    {
        printl("Vector("+ArrayPos[i].x+","+ArrayPos[i].y+","+ArrayPos[i].z+"),Vector("+ArrayAng[i].x+","+ArrayAng[i].y+","+ArrayAng[i].z+"),")
        //DebugDrawCircle(ArrayPos[i], Vector(255,255,255), 32, 16, true, 16)
    }
    printl("--------------------------")
}