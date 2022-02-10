const TICKRATE = 0.25;
const TICKRATE_BEAM = 0.05;

g_fDelay_Shoot <- 5;

g_fTimer_Shoot <- 0.00;
g_iRadius <- 128;
g_bTicking <- false;
g_bTickingBeam <- false;
g_bAllowShoots <- false;
g_hModel <- null;

g_hBeam_Parent <- null;
g_hBeam <- null;
g_hBeam_Explosion <- null;
ang <- null;
function Init()
{
    g_fDelay_Shoot = 0.00 + g_fDelay_Shoot;

    //Start()
}

function Start(ang1 = Vector(0, 0, 0))
{
    ang = ang1
    g_hModel = CreateProp(class_pos(self.GetOrigin(), ang), type_manta_prop, self.GetName());
    local parent1 = CreateProp(Vector(0, 0, -9999), type_parent_prop);
    local part = CreateParticle(Vector(0, 0, -9999), Portal, true);
    EntFireByHandle(part, "SetParent", "!activator", 0.00, parent1, parent1);

    parent1.ValidateScriptScope();
    EntFireByHandle(parent1, "RunScriptCode", "self.SetOrigin(activator.GetOrigin()+activator.GetForwardVector()*250);self.SetAngles(0, " + (ang.y + 90) + ", 0)", 0.05, self, self);

    EntFireByHandle(parent1, "Kill", "", 5.0, null, null);
    EntFireByHandle(g_hModel, "RunScriptCode", "Spawn(1.0)", 0.20, null, null);

    EntFireByHandle(self, "StartForWard", "", 0.20, null, null);
    
    g_bTicking = true;
    Tick()
    //StartTickBeam()
}
 
function Tick()
{   
    if(!g_bTicking)
        return;

    TickShoot();

    EntFireByHandle(self, "RunScriptCode", "Tick()", TICKRATE, null, null);
}

function StartTickBeam()
{
    g_hBeam_Parent = CreateProp(self.GetOrigin() + Vector(0, 0, -20), type_parent_prop);
    g_hBeam_Parent.__KeyValueFromString("targetname", "Manta_Beam_Parent");
    //EntFireByHandle(g_hBeam_Parent, "SetParent", "!activator", 0.00, self, self);

    g_hBeam_Explosion = CreateParticle(self.GetOrigin() + Vector(0, 0, -20), Manta_Explosion, true);
    g_hBeam_Explosion.__KeyValueFromString("targetname", "Manta_Explosion_Particle");

    local array = [];
    array.push(g_hBeam_Parent.GetName());
    array.push(g_hBeam_Explosion.GetName());

    g_hBeam = CreateBeam(self.GetOrigin() + Vector(0, 0, -20), type_manta_beam, array)

    g_bTickingBeam = true;
    TickBeam();
}

function TickBeam()
{
    if(!g_bTickingBeam)
    {
        EntFireByHandle(g_hBeam, "Kill", "", 0.1, null, null);
        EntFireByHandle(g_hBeam_Explosion, "Kill", "", 0.1, null, null);
        EntFireByHandle(g_hBeam_Parent, "Kill", "", 0.1, null, null);
        return;
    }

    g_hBeam_Parent.SetOrigin(self.GetOrigin() + Vector(0, 0, -50))
    g_hBeam_Explosion.SetOrigin(GetFloor(g_hBeam_Parent.GetOrigin(), 2500));
    DamageScat(g_hBeam_Explosion.GetOrigin(), g_iRadius, 256);
    //EntFire("Manta_Explosion_Particle*", "Stop", "", 0.01);
    //EntFire("Manta_Explosion_Particle*", "Start", "", TICKRATE_BEAM);

    EntFire("Manta_Beam*", "TurnOff", "", 0.01);
    EntFire("Manta_Beam*", "TurnOn", "", TICKRATE_BEAM);
    
    EntFireByHandle(self, "RunScriptCode", "TickBeam()", TICKRATE_BEAM, null, null);
}

function DamageScat(origin, radius, damage)
{
   local h = null;
    
    while(null != (h = Entities.FindInSphere(h, origin, radius)))
    {
        if(h.GetClassname() == "player" && 
            h.IsValid() &&
            h.GetTeam() == 3 && 
            h.GetHealth() > 0)
        Damage(h, damage);
    }
}

function TickShoot()
{
    if(!g_bAllowShoots)
        return;

    g_fTimer_Shoot += TICKRATE;
    if(g_fTimer_Shoot >= g_fDelay_Shoot)
    {
        g_fTimer_Shoot = 0.00;
        Shoot();
    }
}

function Shoot()
{
    local part = CreateParticle(self.GetOrigin(), GeenBall_Main, true);
    EntFireByHandle(part, "RunScriptFile", "kotya/npst/scat/greenball.nut", 0.00, null, null);
}

function Death(origin = null)
{
    if(!g_bTicking)
        return;
    if(origin == null)
        origin = self.GetOrigin() + self.GetForwardVector() * 500;
    g_bTicking = false;

    local parent1 = CreateProp(Vector(0, 0, -9999), type_parent_prop);
    local part = CreateParticle(Vector(0, 0, -9999), Portal, true);
    EntFireByHandle(part, "SetParent", "!activator", 0.00, parent1, parent1);

    parent1.ValidateScriptScope();
    EntFireByHandle(parent1, "RunScriptCode", "self.SetOrigin(Vector(" + origin.x + ","+ origin.y + ","+ origin.z+ "));self.SetAngles(0, " + (ang.y + 90) + ", 0)", 0.05, self, self);

    EntFireByHandle(parent1, "Kill", "", 5.0, null, null);

    EntFireByHandle(g_hModel, "RunScriptCode", "Kill(1.0)", 0.20, null, null);
    EntFireByHandle(self, "Kill", "", 5.0, null, null);
}

Init();