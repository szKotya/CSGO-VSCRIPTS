act <- null;
cd <- true;
pounce <- 3;

function OnPostSpawn()
{
    if(self.GetRootMoveParent()!=null)
    {
        local target = self.GetRootMoveParent();
        local hp = self.GetRootMoveParent().GetHealth()-15;
	    if(hp<=0)
        {
            EntFireByHandle(target,"SetHealth","0",0.01,null,null);
            EntFireByHandle(self,"ClearParent","",0,null,null);
            act = null;
        }
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
            if(pounce == -1){EntFireByHandle(self,"Kill","",0,null,null);return}
            act = activator;
            cd = false;
            pounce--;
            EntFireByHandle(act,"AddContext","mako_test:1",0,null,null);
            EntFireByHandle(self,"RunScriptCode","cd=true",3,null,null);
            EntFireByHandle(self,"FireUser1", "",0,activator,activator);
        }
    }
}