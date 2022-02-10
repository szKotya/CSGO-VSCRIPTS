act <- null;
cd <- true;
pounce <- 3;

function OnPostSpawn()
{
    if(self.GetRootMoveParent()!=null)
    {
        local target = self.GetRootMoveParent();
        local hp = self.GetRootMoveParent().GetHealth()-5;
	    if(hp<=0){EntFireByHandle(target,"SetHealth","0",0,null,null);}
	    else {EntFireByHandle(target,"SetHealth",hp.tostring(),0,null,null);}
    }
    EntFireByHandle(self,"RunScriptCode","OnPostSpawn()",0.5,null,null);
}

function SetBoyNextDoor()
{
    if(cd)
    {
        if(act!=activator)
        {
            if(pounce==0){EntFireByHandle(self,"Kill","",0,null,null);return}
            act = activator;
            cd = false;
            pounce--;
            //self.SetOrigin(activator.GetOrigin());
            EntFireByHandle(self,"FireUser1", "",0,activator,activator);
            EntFireByHandle(self,"RunScriptCode","cd=true",1,null,null);
        }
    }
}