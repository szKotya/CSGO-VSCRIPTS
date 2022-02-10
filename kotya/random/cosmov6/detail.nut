
function PreSpawnInstance(entityClass,entityName)
{
    local keyvalues = {};
    keyvalues["rendercolor"] <- RandomInt(0, 255)+" "+RandomInt(0, 255)+" "+RandomInt(0, 255);
    return keyvalues
}
