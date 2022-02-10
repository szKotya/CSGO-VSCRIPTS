//Main
{
    class class_randomspawn
    {
        position = null;

        command = null;
        info1 = null;
        info2 = null;

        constructor(_command, _info1 = null, _info2 = null)
        {
            this.position = [];

            this.command = _command;
            this.info1 = _info1;
            this.info2 = _info2;
        }

        function AddPos(_position)
        {
            this.position.push(_position);
        }

        function GetRandomSpawn(bdelete = true)
        {
            local random = RandomInt(0, this.position.len() - 1);
            local pos = this.position[random];
            
            if(bdelete)
                this.position.remove(random);
            
            return pos;
        }

        function Spawn(count)
        {
            if(count < position.len())
            {
                for(local i = 0; i < count; i++) 
                {
                    local pos = this.GetRandomSpawn()
                    this.Command(pos);
                }
            }
        }

        function Command(pos)
        {
            if(info2 != null)
                this.command(pos, this.info1, this.info2);
            else if(info1 != null)
                this.command(pos, this.info1);
            else
                this.command(pos);
        }

        function ClearPosition()
        {
            this.position.clear();
        }
    }

    g_crsBarnacle <- class_randomspawn(CreateBarnacle);
    g_crsSniper <- class_randomspawn(CreateSniper);
    g_crsLaserTrap <- class_randomspawn(CreateTrap, false, 40);
    g_crsLaserTrapDeath <- class_randomspawn(CreateTrap, false, 9999);
    g_crsExplodeTrap <- class_randomspawn(CreateTrap, true);
}