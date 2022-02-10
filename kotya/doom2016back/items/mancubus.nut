IncludeScript("kotya/doom2016/support/models.nut");
IncludeScript("kotya/doom2016/support/items.nut");
IncludeScript("kotya/doom2016/support/math.nut");

Forward <- false;
Back    <- false;
Right   <- false;
Left    <- false;
Attack1 <- false;
Attack2 <- false;

TICKRATE <- 0.05
Dist <- 0;
Hit <- 0;
Owner   <- null;
//////////////////////
//  Settings block  //
//////////////////////
PUSH_SHIELD_SCALE <- 10;
PUSH_SCALE <- PUSH_SHIELD_SCALE;
PUSH_NOSHIELD_SCALE <- 40;


TAKE_DAMAGETICK<-0;
TAKE_DAMAGE <- false;

SHIELD_DIST <- 2048;
SHIELD <- 1000;
SHIELD_BASE <- 100;
SHIELD_PERHUMAN<- 32;

FLAME_TOFUEL_MIN<-2;
FLAME_FUEL_MINUS<-2;

FUEL <- 10;
FUELTICK_UP <- 0;
FUEL_MAX <- FUEL;
//////////////////////
//   Handle block   //
//////////////////////



Model   <- null;
Freeze  <- Entities.FindByName(null, "speedMod");
ArmHurt <- null;
TriggerFlame <- [];
EffectFlame <- [];

MeasureEye<- null;
Eye     <- null;
Cannon_l<- null;
Cannon_r<- null;
Button  <- null;
Hbox             <- null;
function SetHandle()
{
    local name = caller.GetName();
    if(caller.GetClassname() == "func_physbox_multiplayer"){Hbox = caller;caller.SetOwner(self);}
    if(caller.GetClassname() == "prop_dynamic_glow")Model = caller;
    if(name.find("item_mancubus_cannon_l") == 0)Cannon_l = caller;
    if(name.find("item_mancubus_cannon_r") == 0)Cannon_r = caller;
    if(name.find("item_mancubus_eye") == 0)Eye = caller;

    if(name.find("item_mancubus_armhurt") == 0)ArmHurt = caller;
    if(name.find("item_mancubus_hurt_") == 0)TriggerFlame.push(caller);
    if(name.find("item_mancubus_effect_") == 0)EffectFlame.push(caller);

    if(caller.GetClassname() == "func_button")Button = caller;
    if(caller.GetClassname() == "logic_measure_movement")MeasureEye = caller;
}

function Start()
{
    Owner = activator;
    Owner.__KeyValueFromString("targetname", "mancubus_owner"+(self.GetName().slice(self.GetPreTemplateName().len(),self.GetName().len())).tostring());
    Spawning = true
    EntFireByHandle(Freeze, "ModifySpeed", "0", 0, Owner, Owner);
    SetAnimation(a_Spawn1);
    Casting = true;
    EntFireByHandle(MeasureEye, "SetMeasureTarget", Owner.GetName().tostring(), 0.02, Owner, Owner);
    SetRestoreShield();
    Tick();
}
function Tick()
{
    if(Owner == null)return;
    if(!Casting)
    {
        if(Forward || Back || Right || Left)
        {
            SetRun();
        }
        else
        {
            SetIdel();
        }
        if(FUELTICK_UP >= 5)
        {
            FUELTICK_UP = 0;
            if(FUEL+1<=FUEL_MAX)FUEL++;
        }
        else if(FUEL_MAX != FUEL) FUELTICK_UP += TICKRATE;
        if(TAKE_DAMAGE)
        {
            if(TAKE_DAMAGETICK >= 10)
            {
                TAKE_DAMAGETICK = 0;
                TAKE_DAMAGE = false;
                if(SHIELD==0)SetShieldEnable()
                else SetRestoreShield();
            }
            else TAKE_DAMAGETICK += TICKRATE;
        }
        TraceDir(Owner.EyePosition(),Eye.GetForwardVector(),4096.00,Hbox);
        DebugDrawBox(Hit, Vector(-16,-16,-16), Vector(16,16,16), 0, 255, 255, 5, 0.50);
        local b_ar = Model.LookupAttachment("arm_end_rt");
        local b_al = Model.LookupAttachment("arm_end_if");
        local pos_b_ar = Model.GetAttachmentOrigin(b_ar);
        local pos_b_al = Model.GetAttachmentOrigin(b_al);
        local ang_b_ar = Model.GetAttachmentAngles(b_ar);
        local ang_b_al = Model.GetAttachmentAngles(b_al);
        Cannon_l.SetOrigin(pos_b_al);
        Cannon_r.SetOrigin(pos_b_ar);
        Cannon_l.SetAngles(Eye.GetAngles().x,Eye.GetAngles().y,ang_b_al.z);
        Cannon_r.SetAngles(Eye.GetAngles().x,Eye.GetAngles().y,ang_b_ar.z);
        if(Attack1 || Attack2)EntFireByHandle(self, "RunScriptCode", "Attack();", TICKRATE, null, null);
    }
    //ScriptPrintMessageCenterAll("FUEL "+FUEL+"|"+FUEL_MAX+"\nup "+abs(FUELTICK_UP)+"\nSHIELD "+SHIELD);
    EntFireByHandle(self, "RunScriptCode", "Tick();", TICKRATE, null, null);
}
function Attack()
{
    if(Casting)return;
    if(Attack2 && FUEL>=FLAME_TOFUEL_MIN)
    {
        if(FUEL-FLAME_FUEL_MINUS>0)FUEL-=FLAME_FUEL_MINUS;
        else FUEL=0;
        Idling = false;
        Running = false;
        Casting = true;
        {
            SetAnimation(a_Flame);
        }
        FlameToggle(0.6,1.9)
        return;
    }
    if(Attack1)
    {
        Idling = false;
        Running = false;
        Casting = true;
        EntFireByHandle(ArmHurt, "Enable", "", 2.5, null, null)
        EntFireByHandle(ArmHurt, "Disable", "", 2.5+0.1, null, null)
        EntFireByHandle(ArmHurt, "Enable", "", 3.3, null, null)
        EntFireByHandle(ArmHurt, "Disable", "", 3.3+0.1, null, null)
        {
            SetAnimation(a_Attack);
        }
        return;
    }
}
function SetDeath()
{
    local Clean = [Model,ArmHurt,MeasureEye,Eye,Cannon_l,Cannon_r];
    Owner.__KeyValueFromString("targetname", "");
    EntFireByHandle(Owner, "SetDamageFilter", "", 0.00, null, null);
    EntFireByHandle(Owner, "AddOutput", "rendermode 0", 0.00, null, null);
    EntFireByHandle(Freeze, "ModifySpeed", "1", 0, Owner, Owner);
    EntFireByHandle(Owner, "SetHealth", "-1", 0.02, null, null);
    Casting = true;
    Owner = null;
    for (local i=0; i<Clean.len(); i++)
    {
        Clean[i].Destroy()
    }
}
function SetRun()
{
    Idling = false;
    if(!Running)
    {
        SetDefAnimation(a_Run);
        SetAnimation(a_Run);
    }
    Running = true;
}

function SetIdel()
{
    Running = false;
    if(!Idling)
    {
        SetDefAnimation(a_Idle);
        SetAnimation(a_Idle);
    }
    Idling = true;
}

function FlameToggle(a,b)
{
    for (local i=0; i<EffectFlame.len(); i++)
    {
        if(a > 0)
        {
            EntFireByHandle(EffectFlame[i], "Start", "", a, null, null)
            EntFireByHandle(TriggerFlame[i], "Enable", "", a, null, null)
        }

        if(b > 0)
        {
            EntFireByHandle(EffectFlame[i], "Stop", "", b, null, null)
            EntFireByHandle(TriggerFlame[i], "Disable", "", b, null, null)
        }
    }
}
function DamageShield()
{
    TAKE_DAMAGETICK = 0;
    TAKE_DAMAGE = true;
    if(SHIELD - 1 >0)SHIELD--
    else
    {
        SHIELD = 0;
        SetShieldDisable()
    }
}
function SetShieldEnable()
{
    PUSH_SCALE = PUSH_SHIELD_SCALE;
    SetRestoreShield()
    EntFireByHandle(Model,"SetGlowEnabled","",0.01,null,null);
}
function SetRestoreShield()
{
    local h = null;
    local Count = 0;
    while(null!=(h=Entities.FindInSphere(h,Model.GetOrigin(),SHIELD_DIST)))
    {
        if(h.GetClassname()=="player" && h.GetTeam()==3 && h.GetHealth()>0)Count++;
    }
    SHIELD = SHIELD_BASE+SHIELD_PERHUMAN*Count;
}
function SetShieldDisable()
{
    PUSH_SCALE = PUSH_NOSHIELD_SCALE;
    EntFireByHandle(Model,"SetGlowDisabled","",0.01,null,null);
}
//////////////////////
//    Anims Block   //
//////////////////////
Casting <- false;
Running  <- false;
Idling  <- false;
Spawning<- false;


a_Attack <- "attack";       //Атака лапкой

a_Flame_back <- "cancelshoot"; //огнемет откат
a_Flame        <- "flame"; //огнемет

a_Flame_L        <- "flameleft";
a_Flame_R      <- "flameright";
a_Idle         <- "idle";
a_Run         <- "run";
a_Spawn1       <- "spawn"
//a_Spawn2       <- "spawn1"

function AnimComplete()
{
    if(Owner == null)return;
    if(Spawning)
    {
        Spawning = false;
        EntFireByHandle(Freeze, "ModifySpeed", "1", 0, Owner, Owner);
    }
    if(Casting)
    {
        Casting = false;
    }

}