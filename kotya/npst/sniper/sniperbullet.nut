tickrate <- 0.01;
speed <- 100.00;
trace_dist <- speed * 1.1;
maxkill <- 10;
check <- false;
ignore <- [];
EntFireByHandle(self, "RunScriptCode",  "check = true", 0.05, null, null);  
EntFireByHandle(self, "Kill",  "", 3.00, null, null);  

function Tick()
{
    if(!self.IsValid())
        return;
    if(check && !TraceLineD(self.GetOrigin(), self.GetOrigin() + self.GetForwardVector() * trace_dist))
        return self.Destroy();

    {
        local h = null;
        while(null != (h = Entities.FindInSphere(h, self.GetOrigin(), speed * 0.5)))
        {
            if(maxkill < 0)
                return self.Destroy();            

            if(h.GetClassname() == "player" && 
                h.IsValid() && 
                h.GetHealth() > 0)
            if(!InArray(h))
            {
                ignore.push(h);
                Damage(h, 100);
                maxkill--;
            }
                
        }
    }

    self.SetOrigin(self.GetOrigin() - self.GetForwardVector() * speed);
    EntFireByHandle(self, "RunScriptCode", "Tick(); ", tickrate, null, null);  
}

function InArray(value)
{
    foreach(nvalue in ignore)
    {
        if(nvalue == value)
            return true;
    }
    return false;
    
}

function TraceLineD(start, end)
{
    if(TraceLine(start, end, self) < 1.00)
    {
        //DebugDrawLine(start, end, 255, 0, 0, true, tickrate + 0.01)
        return false;
    }
    //DebugDrawLine(start, end, 0, 255, 0, true, tickrate + 0.01)
    return true;
}

Tick();