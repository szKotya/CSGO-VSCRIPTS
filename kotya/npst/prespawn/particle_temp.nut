
::g_hParticleMaker <- Entities.CreateByClassname("env_entity_maker")
g_hParticleMaker.__KeyValueFromString("EntityTemplate", self.GetName());

//::MasSunStrike <- "nihilanth_attack_shockwave_pre";
::SunStrike1_Pre <- "nihilanth_attack_bullethell_zap_pre";
::SunStrike1 <- "nihilanth_attack_bullethell_zap_explode";

::Death <- "nihilanth_death";

::SunStrike3_Pre <- "nihilanth_attack_bullethell_zap_pre_phase3";
::SunStrike3 <- "nihilanth_attack_bullethell_zap_explode_p3";

::Laser <- "nihilanth_attack_shockwave";
::Laser_Pre <- "nihilanth_attack_shockwave_pre_pp";

// ::Laser2 <- "nihilanth_attack_finalflash_beam";
// ::Laser_Pre4 <- "nihilanth_attack_final_flash";

::Teleprop_start <- "nihilanth_teleprop_enter";
::Teleprop_end <- "diorama_shockwave";

::Pylon_Deploy <- "pylon_deploy";
::Pylon_Rise <- "pylon_deploy_rise";
::Pylon_Destroy <- "pylon_heal_damage";

::CycloneSide <- "nihilanth_cyclone_sides"

::Nihilant_Phase1 <- "nihilanth_intro_aura";
::Nihilant_Phase3 <- "nihilanth_phase3"
::Hand_Phase3 <- "nihilanth_phase3_hands"

::FinalFlash_Beam <- "nihilanth_attack_finalflash_beam";
::FinalFlash <- "nihilanth_attack_final_flash";

::Portal <- "d_tele";
::Manta_Explosion <- "custom_particle_003";

::Shield <- "nihilanth_shield_vortex";
::Aura <- "nihilanth_aura";
::Heal_Start <- "nihilanth_heal_base_all";
::Heal_Break <- "nihilanth_headcrystal_hurt";

::BeamAttack_Hand <- "nihilanth_zap_p1_charge_all";

::FireBall_Explode <- "nihilanth_intro_ballz_e";
::FireBall_Main <- "nihilanth_vortex_ballz_fire_grow";
::FireBall_Hand <- "nihilanth_zap_p1_charge_all";

::GeenBall_Main <- "nihilanth_chair_hover_rings";
::GeenBall_Floor <- "diorama_fire";

::Sniper_Explosion <- "explosion_molotov_air";

::Basic_Explosion <- "explosion_hegrenade_brief";
// effectname <-[
//     ,//256
//     "explosion_basic",]

::g_szParticle_Effect <- "";

::CreateParticle <- function(origin, szName_Effect, Activate = false) 
{
    g_szParticle_Effect = szName_Effect;
    
    g_hParticleMaker.SpawnEntityAtLocation(origin, Vector(0,0,0));
    
    local particle = Entities.FindByName(null, "particle_temp");
    if(Activate)
        EntFireByHandle(particle, "Start", "", 0, null, null);
    if(szName_Effect == Basic_Explosion)
        EntFireByHandle(particle, "Kill", "", 1.00, null, null);
    particle.__KeyValueFromString("targetname", "particle_temp" + Time());
    
    return particle;
}

function PreSpawnInstance(entityClass, entityName)
{
    local keyvalues = {};
    if(entityClass == "info_particle_system")
    {
        keyvalues["effect_name"] <- g_szParticle_Effect;
    }
	return keyvalues
}