
movedistance <- 0;
movedir <- Vector(0, 0, 0);

//                                           (место положение, дальность движения, угол направления)
//ent_fire explosion runscriptcode "CreatePlatform(Vector(200,0,20),256,Vector(0,90,0))"
function CreatePlatform(iorigin,imovedistance,imovedir)
{
    self.SetOrigin(iorigin);
    movedistance = imovedistance;
    movedir = imovedir;
    EntFireByHandle(self, "ForceSpawn", "", 0, null, null);
}

function PreSpawnInstance( entityClass, entityName )
{
	local keyvalues = {};
    if(entityClass == "func_movelinear")
    {
        keyvalues["movedistance"] <- movedistance;
        keyvalues["movedir"] <- movedir;
    }
	return keyvalues
}

function PostSpawn( ents )
{
    local classname;
    foreach(targetname, handle in ents)
    {
        classname = handle.GetClassname();
        if(classname == "func_movelinear")
        {
            EntFireByHandle(handle, "Open", "", 0, null, null);
        }
    }
}