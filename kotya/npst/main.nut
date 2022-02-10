::Main <- self;
::MainScript <- self.GetScriptScope();
//MODELS
{
    ::Gargantua_Model <- "models/garg2.mdl";
    ::Nihilanth_Model <- "models/npstfix/nihilanth/nihilanth.mdl";
    ::Nihilanth_HeadCrystal_Model  <- "models/npstfix/props_xen/c4a4/nihilanth_headcrystal_explode.mdl";

    ::MedicBag_Model <- "models/npstfix/props/medicbag.mdl";

    ::LaserTrap_Model <- "models/npstfix/props_marines/triplaser.mdl";

    ::Manta_Model <- "models/npstfix/xenians/manta_jet.mdl";

    ::CrystalHeal_Model <- "models/npstfix/props_xen/nil_pylon.mdl";
    ::Stick_Model <- "models/npstfix/props_xen/nihil_pile_pylon.mdl";

    ::WoodPallet_Model <- "models/props_junk/wood_pallet001a.mdl";
    ::Oildrum_Model <- "models/props_c17/oildrum001.mdl";
    ::WoodCrate_Model <- "models/props_junk/wood_crate001a.mdl";
    ::Trailer_Model <- "models/props_vehicles/trailer002a.mdl";
    ::Car_Model <- "models/props_vehicles/car004b.mdl";

    ::Rock01_Model <- "models/npstfix/props_xen/instances/bm_c4a4a/bm_c4a4a_barricade011.mdl";
    ::Rock02_Model <- "models/npstfix/props_xen/instances/bm_c4a4a/bm_c4a4a_barricade012.mdl";
    ::Rock03_Model <- "models/npstfix/props_xen/instances/bm_c4a4a/bm_c4a4a_barricade010.mdl";
    ::Rock04_Model <- "models/npstfix/props_xen/instances/bm_c4a4a/bm_c4a4a_barricade004.mdl";
    ::Rock05_Model <- "models/npstfix/props_xen/instances/bm_c4a4a/bm_c4a4a_barricade001.mdl";
    ::Rock06_Model <- "models/npstfix/props_xen/instances/bm_c4a4a/bm_c4a4a_barricade013.mdl";
    ::Rock07_Model <- "models/npstfix/props_xen/instances/bm_c4a4a/bm_c4a4a_barricade014.mdl";
    ::Rock08_Model <- "models/npstfix/props_xen/instances/bm_c4a4a/bm_c4a4a_barricade015.mdl";
    ::Rock09_Model <- "models/npstfix/props_xen/instances/bm_c4a4a/bm_c4a4a_barricade005.mdl";
    ::Rock10_Model <- "models/npstfix/props_xen/instances/bm_c4a4a/bm_c4a4a_barricade016.mdl";
    ::Rock11_Model <- "models/npstfix/props_xen/instances/bm_c4a4a/bm_c4a4a_barricade017.mdl";
    ::Rock12_Model <- "models/npstfix/props_xen/instances/bm_c4a4a/bm_c4a4a_barricade006.mdl";
    ::Rock13_Model <- "models/npstfix/props_xen/instances/bm_c4a4a/bm_c4a4a_barricade007.mdl";
    ::Rock14_Model <- "models/npstfix/props_xen/instances/bm_c4a4a/bm_c4a4a_barricade018.mdl";
    ::Rock15_Model <- "models/npstfix/props_xen/instances/bm_c4a4a/bm_c4a4a_barricade019.mdl";
    ::Rock16_Model <- "models/npstfix/props_xen/instances/bm_c4a4a/bm_c4a4a_barricade003.mdl";
    ::Rock17_Model <- "models/npstfix/props_xen/instances/bm_c4a4a/bm_c4a4a_barricade008.mdl";
    ::Rock18_Model <- "models/npstfix/props_xen/instances/bm_c4a4a/bm_c4a4a_barricade020.mdl";
    ::Rock19_Model <- "models/npstfix/props_xen/rocks/xen_rock_nihil_cone_001a.mdl";
    ::Rock20_Model <- "models/npstfix/props_xen/instances/bm_c4a4a/bm_c4a4a_barricade009.mdl";
    ::Rock21_Model <- "models/npstfix/props_xen/instances/bm_c4a4a/bm_c4a4a_barricade002.mdl";

    ::FlyingRock01_Model <- "models/npstfix/props_xen/c4a4/nihilanth_chamber_rocks_part1.mdl";
    ::FlyingRock02_Model <- "models/npstfix/props_xen/c4a4/nihilanth_chamber_rocks_part2.mdl";
    ::FlyingRock03_Model <- "models/npstfix/props_xen/c4a4/nihilanth_chamber_rocks_part3.mdl";
    ::FlyingRock04_Model <- "models/npstfix/props_xen/c4a4/nihilanth_chamber_rocks_part4.mdl";
    ::FlyingRock05_Model <- "models/npstfix/props_xen/c4a4/nihilanth_chamber_rocks_part5.mdl";
    ::FlyingRock06_Model <- "models/npstfix/props_xen/c4a4/nihilanth_chamber_rocks_part6.mdl";

    ::ShockWave_Model <- "models/npstfix/props_xen/c4a4/nihilanth_shockwave_horizontal.mdl";

    ::Cloud01_Model <- "models/npstfix/props_xen/c4a4/nihilanth_cyclone1.mdl";
    ::Cloud02_Model <- "models/npstfix/props_xen/c4a4/nihilanth_cyclone2.mdl";
    ::Cloud03_Model <- "models/npstfix/props_xen/c4a4/nihilanth_cyclone3.mdl";
    ::Cloud04_Model <- "models/npstfix/props_xen/c4a4/nihilanth_cyclone4.mdl";

    ::Laser_Model <- "models/npstfix/c4a4/nihilanth_shockwave_disc2.mdl";
    ::Parent_Model <- "models/editor/playerstart.mdl";
    ::Shield_Model <- "models/npstfix/c4a4/nihilanth_vortex_shield.mdl";
    ::AttackRock_Model  <- "models/npstfix/props_xen/c4a4/nihilanth_groundrocks_line.mdl";

    ::Barnacle_Model  <- "models/npstfix/barnacle/barnacle.mdl";

    ::Sniper_Model <- "models/weapons/w_snip_awp.mdl";
    ::SniperBullet_Model <- "models/tools/bullet_hit_marker.mdl";

    ::Human_Turret_Model <- "models/weapons/w_mach_m249.mdl";

    g_haPrecacheModels <- 
    [
        Gargantua_Model,
        Nihilanth_Model,
        WoodPallet_Model,
        Oildrum_Model,
        WoodCrate_Model,
        Trailer_Model,
        Car_Model,
        CrystalHeal_Model,
        Stick_Model,

        Manta_Model,

        MedicBag_Model,

        LaserTrap_Model,

        Rock01_Model,
        Rock02_Model,
        Rock03_Model,
        Rock04_Model,
        Rock05_Model,
        Rock06_Model,
        Rock07_Model,
        Rock08_Model,
        Rock09_Model,
        Rock10_Model,
        Rock11_Model,
        Rock12_Model,
        Rock13_Model,
        Rock14_Model,
        Rock15_Model,
        Rock16_Model,
        Rock17_Model,
        Rock18_Model,
        Rock19_Model,
        Rock20_Model,
        Rock21_Model,

        FlyingRock01_Model,
        FlyingRock02_Model,
        FlyingRock03_Model,
        FlyingRock04_Model,
        FlyingRock05_Model,
        FlyingRock06_Model,

        ShockWave_Model,

        Cloud01_Model,
        Cloud02_Model,
        Cloud03_Model,
        Cloud04_Model,

        Laser_Model,

        Parent_Model,

        Shield_Model,

        AttackRock_Model,

        Barnacle_Model,

        Sniper_Model,
        SniperBullet_Model,

        Human_Turret_Model,
    ]

    for(local i = 0; i < g_haPrecacheModels.len(); i++)
        self.PrecacheModel(g_haPrecacheModels[i]);
}
//SNIPER SOUNDS
{
    ::SniperDeath01_Sound <- "anarchist.t_death01"
    ::SniperDeath02_Sound <- "anarchist.t_death02"
    ::SniperDeath03_Sound <- "anarchist.t_death03"
    ::SniperDeath04_Sound <- "anarchist.t_death04"
    ::SniperDeath05_Sound <- "anarchist.t_death05"

    ::SniperDeathArray_Sound <- [
        SniperDeath01_Sound,
        SniperDeath02_Sound,
        SniperDeath03_Sound,
        SniperDeath04_Sound,
        SniperDeath05_Sound,
    ]

    for(local i = 0; i < SniperDeathArray_Sound.len(); i++)
        self.PrecacheSoundScript(SniperDeathArray_Sound[i]);

    ::SniperShoot01_Sound <- "Weapon_AWP.Single"
    ::SniperShoot02_Sound <- "Weapon_AWP.SingleDistant"

    ::SniperShootArray_Sound <- [
        SniperShoot01_Sound,
        SniperShoot02_Sound,
    ]

    for(local i = 0; i < SniperShootArray_Sound.len(); i++)
        self.PrecacheSoundScript(SniperShootArray_Sound[i]);

    ::SniperReload01_Sound <- "Weapon_AWP.Cliphit"
    ::SniperReload02_Sound <- "Weapon_AWP.Clipin"
    ::SniperReload03_Sound <- "Weapon_AWP.Clipout"
    ::SniperReload04_Sound <- "Weapon_AWP.BoltBack"
    ::SniperReload05_Sound <- "Weapon_AWP.BoltForward"

    ::SniperReloadArray_Sound <- [
        SniperReload01_Sound,
        SniperReload02_Sound,
        SniperReload03_Sound,
        SniperReload04_Sound,
        SniperReload05_Sound,
    ]
    for(local i = 0; i < SniperReloadArray_Sound.len(); i++)
        self.PrecacheSoundScript(SniperReloadArray_Sound[i]);
}
//NIHILANTH SOUNDS
{
    //BEAM
    {
        ::Nihilanth_Beam_Start01_Sound <- "npst/Nihilanthbattle/beam/beam_attack_start1.mp3";
        ::Nihilanth_Beam_Start02_Sound <- "npst/Nihilanthbattle/beam/beam_attack_start2.mp3";
        ::Nihilanth_BeamArray_Sound <- [Nihilanth_Beam_Start01_Sound, Nihilanth_Beam_Start02_Sound];

        ::Nihilanth_Beam_End_Sound <- "npst/Nihilanthbattle/beam/beam_attack_end.mp3";
    }
    //CRYSTAL
    // {
    //     ::Nihilanth_Crystal_Start_Sound <- "npst/Nihilanthbattle/crystal/crystal_deploy_start.mp3";
    //     ::Nihilanth_Crystal_End_Sound <- "npst/Nihilanthbattle/crystal/crystal_deploy_end.mp3";
    // }
    //SUNSTRIKE
    {
        ::Nihilanth_SunStrike_Start01_Sound <- "npst/Nihilanthbattle/sunstrike/mortar_charge.mp3";
        ::Nihilanth_SunStrike_Start02_Sound <- "npst/Nihilanthbattle/sunstrike/mortar_charge2.mp3";
        ::Nihilanth_SunStrike_Start03_Sound <- "npst/Nihilanthbattle/sunstrike/mortar_charge3.mp3";
        ::Nihilanth_SunStrike_Sound <- [Nihilanth_SunStrike_Start01_Sound, Nihilanth_SunStrike_Start02_Sound, Nihilanth_SunStrike_Start03_Sound];

        ::Nihilanth_SunStrike_Explode_Sound <- "npst/Nihilanthbattle/sunstrike/mortar_explode.mp3";
    }
    //FINALFLASH
    {
        ::Nihilanth_FinalFlash_Sound <- "npst/Nihilanthbattle/finalflash/finalflash.mp3";
    }
    //ROCK
    {
        ::Nihilanth_Rock_Start_Sound <- "npst/Nihilanthbattle/rock/rock_attack1.mp3";
        ::Nihilanth_Rock_End_Sound <- "npst/Nihilanthbattle/rock/rocks_down1.mp3";
    }
    //PHASE
    {
        ::Nihilanth_Phase1_Sound <- "npst/Nihilanthbattle/phase/mach_roar1.mp3";

        ::Nihilanth_Phase3_Sound <- "npst/Nihilanthbattle/phase/nih_stage3_st.mp3";
        ::Nihilanth_Phase31_Sound <- "npst/Nihilanthbattle/phase/shockwave_attack.mp3";

        ::Nihilanth_Phase4_Sound <- "npst/Nihilanthbattle/phase/head_open.mp3";
        ::Nihilanth_Phase4_End_Sound <- "npst/Nihilanthbattle/phase/nihilanth_critical.mp3";
    }

    //LASER
    {
        ::Nihilanth_Laser01_Sound <- "npst/Nihilanthbattle/laser/shockwave_start.mp3";
        ::Nihilanth_Laser02_Sound <- "npst/Nihilanthbattle/laser/shockwave_start2.mp3";

        ::Nihilanth_LaserArray_Sound <- [Nihilanth_Laser01_Sound, Nihilanth_Laser02_Sound];
    }

    //TELE
    {
        ::Nihilanth_Tele_Sound <- "npst/Nihilanthbattle/tele/mind_throw.mp3";
    }
}
//TRAP_SOUNDS
{
    ::Explode_Sound <- "BaseGrenade.Explode";
}
g_haPrecacheSounds <- [
    Explode_Sound,
    Nihilanth_Beam_Start01_Sound,
    Nihilanth_Beam_Start02_Sound,
    Nihilanth_Beam_End_Sound,

    // Nihilanth_Crystal_Start_Sound,
    // Nihilanth_Crystal_End_Sound,

    Nihilanth_SunStrike_Start01_Sound,
    Nihilanth_SunStrike_Start02_Sound,
    Nihilanth_SunStrike_Start03_Sound,

    Nihilanth_SunStrike_Explode_Sound,

    Nihilanth_FinalFlash_Sound,

    Nihilanth_Rock_Start_Sound,
    Nihilanth_Rock_End_Sound,

    Nihilanth_Phase1_Sound

    Nihilanth_Phase3_Sound,
    Nihilanth_Phase31_Sound,

    Nihilanth_Phase4_Sound,
    Nihilanth_Phase4_End_Sound,

    Nihilanth_Laser01_Sound,
    Nihilanth_Laser02_Sound,

    Nihilanth_Tele_Sound,
]

for(local i = 0; i < g_haPrecacheSounds.len(); i++)
        self.PrecacheSoundScript(g_haPrecacheSounds[i]);
class class_teleprop
{
    modelname = null;
    damage = 0;
    radius = 0;
    origin = null;
    fade = false;

    constructor(_origin, _modelname, _damage, _radius, _fade)
    {
        this.origin = _origin;
        this.modelname = _modelname;
        this.damage = _damage;
        this.radius = _radius;
        this.fade = _fade;
    }
}

::g_teleaPreset <-
[
    class_teleprop(Vector(0,0,0), WoodPallet_Model, 10, 84, false),
    class_teleprop(Vector(0,0,0), Oildrum_Model, 15, 64, true),
    class_teleprop(Vector(0,0,0), WoodCrate_Model, 10, 64, false),
    class_teleprop(Vector(0,0,0), Trailer_Model, 45, 148, true),
    class_teleprop(Vector(0,0,0), Car_Model, 30, 144, true),
]

::class_pos <- class
{
    origin = Vector(0, 0, 0);
    ox = 0;
    oy = 0;
    oz = 0;
    angles = Vector(0, 0, 0);
    ax = 0;
    ay = 0;
    az = 0;

    constructor(_origin, _angles = Vector(0, 0, 0))
    {
        this.origin = _origin;
        this.ox = _origin.x;
        this.oy = _origin.y;
        this.oz = _origin.z;

        this.angles = _angles;
        this.ax = _angles.x;
        this.ay = _angles.y;
        this.az = _angles.z;
    }
}

::GetFloor <- function(origin, back = 1000, ignorehandle = null) 
{
    local count = 0;
    origin = origin;
    local start = origin;
    
    while(count < back)
    {
        if(!InSight(origin, origin - Vector(0, 0, 1), ignorehandle))
        {
            return origin;
        }
        origin = origin - Vector(0, 0, 1);
        count++;
    }
    return start;
}

::CountPlayers <- function(origin, radius, TEAM = 3)
{
    local count = 0;
    local handle = null;

    while( null != ( handle = Entities.FindInSphere(handle, origin, radius)))
    {
        if(handle.GetClassname() == "player" && handle.GetTeam() == TEAM && handle.GetHealth() > 0)
        {
            count++;
        }
    }
    return count;
}

::ValidTarget <- function(target = null, team = 0) 
{
    
    if(target == null || !target.IsValid() || target.GetHealth() <= 0)
    {    
        return false;
    }

    if(team != 0)
    {   
        if(team > 0)
            if(target.GetTeam() == abs(team))
                return true;
        else 
            if(target.GetTeam() != team)
                return false;
    }

    return true;
}

::RandomBool <- function()
{
    return RandomInt(0,1);
}

::InSight <- function(start, end, ignorehandle = null)
{
    if(ignorehandle == null || typeof ignorehandle == "instance")
    {
        if(TraceLine(start, end, ignorehandle) < 1.00)
            return false;
        return true;
    }

    if(typeof ignorehandle == "array")
    {
        for(local i = 0; i < ignorehandle.len(); i++)
        {
            if(ignorehandle[i] == null || !ignorehandle[i].IsValid())
                continue;

            if(InSight(start, end, ignorehandle[i]))
                return true;
        }
    }

    return InSight(start, end, null);
}

::GetChance <- function(iChance)
{
    if(typeof iChance == "integer")
        return (RandomInt(1, 100) >= iChance);

    if(typeof iChance == "array")
    {
        local total_chance_sum = 0;
        
		for (local i = 0; i < iChance.len(); i++)
		{
			total_chance_sum += iChance[i].iChance;
		}
        while(true)
        {
            local r = RandomFloat(0, total_chance_sum);
            local current_sum = 0;

            for(local i = 0; i < iChance.len(); i++)
            {
                if (current_sum <= r && r < current_sum + iChance[i].iChance)
                    return iChance[i];
                current_sum += iChance[i].iChance;
            }
        }
    }
}

::GetPithYawFVect3D <- function(a, b)
{
    local deltaX = a.x - b.x;
    local deltaY = a.y - b.y;
    local yaw = (atan2(deltaY,deltaX) * 180 / PI);
    return yaw.tointeger();
}

::VectorDot <- function(v1, v2)
{
    return v1.x * v2.x + v1.y * v2.y + v1.z * v2.z;
}

::VectorDiv <- function(v1, d)
{
    return Vector(v1.x / d, v1.y / d, v1.z / d);
}

::GetPithXawFVect3D <- function(a, b)
{
    local deltaX = a.x - b.x;
    local deltaY = a.y - b.y;
    local deltaZ = a.z - b.z;
    local yaw = atan2(deltaY,deltaX) * 180 / PI
    local pitch = asin(deltaZ / sqrt(deltaX * deltaX + deltaY * deltaY + deltaZ * deltaZ)) * 180 / PI;
    if(pitch > 0){pitch = -pitch;}
    else{pitch = fabs(pitch);}
    return Vector(pitch, yaw, 0);
}

::VectorEqul <- function(v1, v2)
{
    if(v1.x == v2.x && v1.y == v2.y && v1.z == v2.z)
        return true;
    return false;
}

::DamageInSphere <- function(origin, radius, damage) 
{
    local h = null;
    
    while(null != (h = Entities.FindInSphere(h, origin, radius)))
    {
        if(h.GetClassname() == "player" && 
            h.IsValid() && 
            h.GetHealth() > 0)
        Damage(h, damage);
    }

    //DebugDrawCircle(origin, Vector(255,0,0), radius, 16, true, 3);
}

::Damage <- function(handle, damage) 
{
    if(!handle.IsValid())
        return;

    local hp = handle.GetHealth();
    hp -= damage;

    if(hp < 1)
    {
        EntFireByHandle(handle, "SetHealth", "-1", 0, null, null);
        EntFireByHandle(handle, "SetDamageFilter", "", 0, null, null);
    }
    else
        handle.SetHealth(hp);
}

::GetPredictionOrigin <- function(oShoot, oTarget, velTarget, iBullet, tickrate = 0.01, speedmodif = 50)
{
    local totarget = oTarget - oShoot;

    local a = VectorDot(velTarget, velTarget) - (iBullet * iBullet / tickrate * speedmodif);
    
    local b = 2 * VectorDot(velTarget, totarget);
    local c = VectorDot(totarget, totarget);

    local p = -b / (2 * a);
    local q = (0.00 + sqrt( ( b * b ) -4 * a * c ) / ( 2 * a) );

    local t1 = p - q;
    local t2 = p + q;

    local t;
    if( t1 > t2 &&
        t2 > 0)
        t = t2;
    else 
        t = t1;

    return oTarget + velTarget * t;
}

::GetDistance3D <- function(v1,v2)
{
    return 0.00 + sqrt((v1.x-v2.x)*(v1.x-v2.x)+(v1.y-v2.y)*(v1.y-v2.y)+(v1.z-v2.z)*(v1.z-v2.z));
}

::GetDistance2D <- function(v1,v2)
{
    return 0.00 + sqrt((v1.x-v2.x)*(v1.x-v2.x)+(v1.y-v2.y)*(v1.y-v2.y));
}
/*
ent_fire map_brush RunScriptFile kotya/npst/main; mp_restartgame 1; 

ent_fire map_brush RunScriptCode "DebugDrawCircle(Vector(0,0,0))"
*/
::DebugDrawCircle <- function(Vector_Center, Vector_RGB = Vector(255, 255, 255), radius = 64, parts = 16, zTest = true, duration = 4.00) //0 -32 80
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

::TraceDir <- function(orig, dir, maxd = 99999, filter = null)
{
    local frac = TraceLine(orig, orig+dir*maxd, filter);
    if(frac == 1.0)
    {
        return orig + dir * maxd;
    }
    
    return orig + (dir * (maxd * frac));
}

{
    //Functions below by Enviolinador:
    //============================================================
    /**
    * Attempts to project a triangle onto a surface in front of a point and in a direction
    * to compute the normal of the plane in that surface
    */
    ::GetApproxPlaneNormal <- function(orig, vec, delta=0.01, drawTrianglePlane=true)
    {
        // Compute the direction vector
        local length = vec.Length();
        local dir = vnorm(vec);
        local yaw = atan2(dir.x, dir.z);
        local pitch = atan2(dir.y, sqrt((dir.x * dir.x) + (dir.z * dir.z)));

        // Compute R direction
        local xR = sin(yaw+delta)*cos(pitch+delta);
        local yR = sin(pitch+delta);
        local zR = cos(yaw+delta)*cos(pitch+delta);
        local endR = Vector(xR, yR, zR);
        local vecR = vscale(vnorm(endR), length);

        // Compute L direction
        local xL = sin(yaw-delta)*cos(pitch+delta);
        local yL = sin(pitch+delta);
        local zL = cos(yaw-delta)*cos(pitch+delta);
        local endL = Vector(xL, yL, zL);
        local vecL = vscale(vnorm(endL), length);

        // Find end points distance
        local distA = TraceLine(orig, vadd(orig, vec), null);
        local distB = TraceLine(orig, vadd(orig, vecR), null);
        local distC = TraceLine(orig, vadd(orig, vecL), null);

        // Compute the 3 triangle verts
        local vertA = vadd(orig, vscale(vec, distA));
        local vertB = vadd(orig, vscale(vecR, distB));
        local vertC = vadd(orig, vscale(vecL, distC));

        // Return a null vector if any of the traces hit nothing
        if(distA == 1 && distB == 1 && distC == 1)
            return Vector(0.0, 0.0, 0.0);
        
        
        // Draw the triangle used to compute the normal, if desired
        if(drawTrianglePlane)
        {
            DebugDrawLine(vertA, vertB, 255, 0, 0, false, 5);
            DebugDrawLine(vertB, vertC, 0, 255, 0, false, 5);
            DebugDrawLine(vertC, vertA, 0, 0, 255, false, 5);
        }
        

        // Compute the two planar vectors
        local t1 = vsub(vertB, vertA);
        local t2 = vsub(vertB, vertC);
        local norm = vcross(t1, t2);

        // Return if the normal is the null vector (either t1, t2 or both are null)
        if(VectorEqul(norm, Vector(0, 0, 0)))
            return norm;

        // Correct the normal if we're going in the same direction as the original vector
        norm = vnorm(norm);
        if(veqd(norm, dir))
            norm = vinv(norm);
        return norm;
    }

    /**
    * Compute the negated/inverse direction vector
    */
    ::vinv <- function(v)
    {
        return Vector(-v.x, -v.y, -v.z);
    }

    /**
    * Add two vectors
    */
    ::vadd <- function(v1, v2)
    {
        return Vector(v1.x + v2.x, v1.y + v2.y, v1.z + v2.z);
    }

    /**
    * Subtract two vectors
    */
    ::vsub <- function(v1, v2)
    {
        return Vector(v1.x - v2.x, v1.y - v2.y, v1.z - v2.z);
    }

    /**
    * Multiply all vector components by a scalar
    */
    ::vscale <- function(v, s)
    {
        return Vector(v.x * s, v.y * s, v.z * s);
    }

    /**
    * Cross product of two vectors, wrapping v1.Cross(v2)
    */
    ::vcross <- function(v1, v2)
    {
        return v1.Cross(v2);
    }

    /**
    * Divide all components of a vector by a scalar
    */
    ::vdiv <- function(v, d)
    {
        return Vector(v.x / d, v.y / d, v.z / d);
    }

    /**
    * Normalization of a vector, equivalent for v.norm()
    */
    ::vnorm <- function(v)
    {
        return vdiv(v, v.Length())
    }


    /**
    * Vector equality with a delta
    */
    ::veqd <- function(v1, v2, d=0.001){
        return abs(v1.x - v2.x) < d && 
            abs(v1.y - v2.y) < d &&
            abs(v1.z - v2.z) < d; 
    }
    
    /**
    * Compute the reflection of a vector v with respect to the normal n
    */
    ::vrefl <- function(v, n)
    {
        local nn = vnorm(n);
        local dot = VectorDot(v, nn);
        local term = vscale(n, 2*dot)
        return vsub(v, term); 
    }
}

::DrawBoundingBox <- function(ent, color = Vector(0, 255, 255), tickrate = 10)
{
    local origin = ent.GetOrigin();

    local max = ent.GetBoundingMaxs();
    local min = ent.GetBoundingMins();

    local rV = ent.GetLeftVector();
    local fV = ent.GetForwardVector();
    local uV = ent.GetUpVector();

    local TFR = origin + uV * max.z + rV * max.y + fV * max.x;
    local TFL = origin + uV * max.z + rV * min.y + fV * max.x;

    local TBR = origin + uV * max.z + rV * max.y + fV * min.x;
    local TBL = origin + uV * max.z + rV * min.y + fV * min.x;

    local BFR = origin + uV * min.z + rV * max.y + fV * max.x;
    local BFL = origin + uV * min.z + rV * min.y + fV * max.x;

    local BBR = origin + uV * min.z + rV * max.y + fV * min.x;
    local BBL = origin + uV * min.z + rV * min.y + fV * min.x;


    DebugDrawLine(TFR, TFL, color.x, color.y, color.z, true, tickrate + 0.01);
    DebugDrawLine(TBR, TBL, color.x, color.y, color.z, true, tickrate + 0.01);

    DebugDrawLine(TFR, TBR, color.x, color.y, color.z, true, tickrate + 0.01);
    DebugDrawLine(TFL, TBL, color.x, color.y, color.z, true, tickrate + 0.01);

    DebugDrawLine(TFR, BFR, color.x, color.y, color.z, true, tickrate + 0.01);
    DebugDrawLine(TFL, BFL, color.x, color.y, color.z, true, tickrate + 0.01);

    DebugDrawLine(TBR, BBR, color.x, color.y, color.z, true, tickrate + 0.01);
    DebugDrawLine(TBL, BBL, color.x, color.y, color.z, true, tickrate + 0.01);

    DebugDrawLine(BFR, BBR, color.x, color.y, color.z, true, tickrate + 0.01);
    DebugDrawLine(BFL, BBL, color.x, color.y, color.z, true, tickrate + 0.01);

    DebugDrawLine(BFR, BFL, color.x, color.y, color.z, true, tickrate + 0.01);
    DebugDrawLine(BBR, BBL, color.x, color.y, color.z, true, tickrate + 0.01);
}

::CreateTrap <- function(pos, bunExplode = true, damage = 100)
{
    local vstart = TraceDir(pos.origin, pos.angles, 9999);
    local vstart_ang = GetApproxPlaneNormal((vstart - pos.angles * 20), (pos.angles * 9999));
    local vend = TraceDir(vstart, vstart_ang, 9999);    
    local vend_ang = vinv(vstart_ang)
    
    local prop = CreateProp(vstart, type_lasertrap_prop);
    prop.SetForwardVector(vstart_ang);

    local parent2 = CreateProp(vend, type_lasertrap_prop);
    parent2.SetForwardVector(vend_ang);
    parent2.__KeyValueFromString("targetname", "LaserTrap_Prop_End" + Time());

    local array = [];
    array.push(prop.GetName());
    array.push(parent2.GetName());
    
    local beam = CreateBeam(vstart, ((bunExplode != 0) ? type_lasertrapexplode_beam : type_lasertrap_beam), array);
    local srite = CreateSprite(vadd(vstart, vstart_ang * 5), ((bunExplode != 0) ? type_lasertrapexplode_sprite : type_lasertrap_sprite));
    local srite1 = CreateSprite(vadd(vend, vend_ang * 5), ((bunExplode != 0) ? type_lasertrapexplode_sprite : type_lasertrap_sprite));

    local maxs = Vector(GetDistance3D(vstart, vend) * 0.5, 4, 4)
    local mins = vinv(maxs);
    local voriginmidle = vscale(vadd(vstart, vend), 0.5);

    local trigger = CreateTrigger(Vector(0, 0, 0), ((bunExplode != 0) ? type_lasertrapexplode_beam : type_lasertrap_beam), damage);
    //EntFireByHandle(trigger, "FireUser1", "", 0, null, null);

    EntFireByHandle(trigger, "AddOutPut", "OnUser4 " + prop.GetName() + ":FadeAndKill::0.00:1", 0, null, null);
    EntFireByHandle(trigger, "AddOutPut", "OnUser4 " + parent2.GetName() + ":FadeAndKill::0.00:1", 0, null, null);
    EntFireByHandle(trigger, "AddOutPut", "OnUser4 " + srite.GetName() + ":Kill::0.00:1", 0, null, null);
    EntFireByHandle(trigger, "AddOutPut", "OnUser4 " + srite1.GetName() + ":Kill::0.00:1", 0, null, null);
    EntFireByHandle(trigger, "AddOutPut", "OnUser4 " + beam.GetName() + ":Kill::0.00:1", 0, null, null);
    EntFireByHandle(trigger, "AddOutPut", "OnUser4 " + trigger.GetName() + ":Kill::0.00:1", 0, null, null);

    if(bunExplode != 0)
    {
        local scripts1 = prop.ValidateScriptScope();
        local scripts1 = parent2.ValidateScriptScope();

        EntFireByHandle(prop, "RunScriptCode", "bExplode<-false;trigger<-activator;Explode<-function(){if(!bExplode){CreateSound(self.GetOrigin(),type_explode_sound);CreateParticle(self.GetOrigin(),Basic_Explosion,true);DamageInSphere(self.GetOrigin(),128,50);ExplodeTrap(self.GetOrigin(),128);bExplode=true}}", 0, trigger, trigger);
        EntFireByHandle(parent2, "RunScriptCode", "bExplode<-false;trigger<-activator;Explode<-function(){if(!bExplode){CreateSound(self.GetOrigin(),type_explode_sound);CreateParticle(self.GetOrigin(),Basic_Explosion,true);DamageInSphere(self.GetOrigin(),128,50);ExplodeTrap(self.GetOrigin(),128);bExplode=true}}", 0, trigger, trigger);

        EntFireByHandle(trigger, "AddOutPut", "OnStartTouch " + trigger.GetName() + ":FireUser4::0:1", 0, null, null);
        EntFireByHandle(trigger, "AddOutPut", "OnStartTouch " + trigger.GetName() + ":FireUser3::0:1", 0, null, null);
        EntFireByHandle(trigger, "AddOutPut", "OnUser3 " + prop.GetName() + ":RunScriptCode:Explode():0:1", 0, null, null);
        EntFireByHandle(trigger, "AddOutPut", "OnUser3 " + parent2.GetName() + ":RunScriptCode:Explode():0:1", 0, null, null);
    }
        

    //}
    EntFireByHandle(trigger, "Enable", "", 0, null, null);
    trigger.SetOrigin(voriginmidle);
    trigger.SetForwardVector(vstart_ang);
    trigger.SetSize(mins, maxs);
}

::CreateBarnacle <- function(pos)
{
    local origin = pos.origin;
    CreateProp(origin, type_barnacle_prop);
}

::CreateHumanTurret <- function(pos)
{
    CreateProp(pos, type_human_turret_prop);
}

::CreateSniper <- function(pos)
{
    CreateProp(pos, type_sniper_prop);
}

//ent_fire pizdec forcespawn;setpos -736.361206 5121.057617 692.098450;setang 15.391593 -118.732628 0.000000;ent_fire door_55 open "" 1;

::ExplodeTrap <- function(origin, radius = 256)
{
    local trap = null;
    while(null != (trap = Entities.FindInSphere(trap, origin, radius)))
    {
        if(trap.IsValid() && trap.GetModelName() == LaserTrap_Model)
        {
            if(trap.ValidateScriptScope())
            {
                try 
                {
                    local scriptscope = trap.GetScriptScope()
                    local trigger = scriptscope.trigger;
                    if(trigger != null && trigger.IsValid())
                    {
                        EntFireByHandle(trigger, "FireUser4", "", 0.15, null, null);
                        EntFireByHandle(trigger, "FireUser3", "", 0.1, null, null);
                        scriptscope.trigger = null;
                    }
                } 
                catch(error)
                {
                    continue;
                }
            }
        }     
    }
}

::DrawAxis <- function(pos,s = 16,time = 10)
{
	DebugDrawLine(Vector(pos.x-s,pos.y,pos.z), Vector(pos.x+s,pos.y,pos.z), 255, 0, 0, true, time);
	DebugDrawLine(Vector(pos.x,pos.y-s,pos.z), Vector(pos.x,pos.y+s,pos.z), 0, 255, 0, true, time);
	DebugDrawLine(Vector(pos.x,pos.y,pos.z-s), Vector(pos.x,pos.y,pos.z+s), 0, 0, 255, true, time);
}



function MapStart()
{
    CreateCamera();
    CreateRandomSpawns();
}
::g_Camera_Script <- null;
function CreateCamera()
{
    g_Camera_Script = Entities.CreateByClassname("logic_script");
    g_Camera_Script.__KeyValueFromString("targetname", "map_script_camera");
    EntFireByHandle(g_Camera_Script, "RunScriptFile", "kotya/npst/randomstaff/camera.nut", 0, null, null);
}

::g_GargantuaLogic <- null;

function CreateGargantuaLogic()
{
    g_GargantuaLogic = Entities.CreateByClassname("logic_script");
    g_GargantuaLogic.__KeyValueFromString("targetname", "map_script_gargantua_logic");
    EntFireByHandle(g_GargantuaLogic, "RunScriptFile", "kotya/npst/gargantua/gargantua_fight.nut", 0, null, null);
}

::g_NihilanthLogic <- null;

function CreateNihilanthLogic()
{
    g_NihilanthLogic = Entities.CreateByClassname("logic_script");
    g_NihilanthLogic.__KeyValueFromString("targetname", "map_script_nihilanth_logic");
    EntFireByHandle(g_NihilanthLogic, "RunScriptFile", "kotya/npst/nihilanth/nihilanth.nut", 0, null, null);
}

::g_RandomSpawns <- null;

function CreateRandomSpawns()
{
    g_RandomSpawns = Entities.CreateByClassname("logic_script");
    g_RandomSpawns.__KeyValueFromString("targetname", "map_script_random_spawns");
    EntFireByHandle(g_RandomSpawns, "RunScriptFile", "kotya/npst/randomstaff/randomspawner.nut", 0, null, null);
}

// ::g_TeleportManager <- null;

// function CreateTeleportManager()
// {
//     g_TeleportManager = Entities.CreateByClassname("logic_script");
//     g_TeleportManager.__KeyValueFromString("targetname", "map_script_teleport_manager");
//     EntFireByHandle(g_TeleportManager, "RunScriptFile", "kotya/npst/randomstaff/teleport_manager.nut", 0, null, null);
// }

function SlaySide(side = 2)
{
    local handle;
    while((handle = Entities.FindByClassname(handle, "player")) != null)
    {
        if(!handle.IsValid() || handle.GetHealth() <= 0)
            continue;

        if(handle.GetTeam() != side)
            continue;

        EntFireByHandle(handle, "SetDamageFilter", "", 0.9, null, null);
        EntFireByHandle(handle, "SetHealth", "-1", 1, null, null);
    }
}

::Music_0 <- RandomBool();
::Music_1 <- RandomBool();
::Music_2 <- RandomBool();
::Music_3 <- RandomBool();
::Music_4 <- RandomBool();
::Music_5 <- RandomBool();
::Music_6 <- RandomBool();