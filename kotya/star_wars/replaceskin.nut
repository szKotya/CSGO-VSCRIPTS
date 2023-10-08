model_v <- "models/weapons/redsaber/v_red.mdl"; self.PrecacheModel(model_v);
model_w <- "models/weapons/redsaber/w_red.mdl"; self.PrecacheModel(model_w);

array_v <- [
"models/weapons/v_knife_default_ct.mdl",
"models/weapons/v_knife_default_t.mdl",
"models/weapons/v_knife_bayonet.mdl",
"models/weapons/v_knife_butterfly.mdl",
"models/weapons/v_knife_canis.mdl",
"models/weapons/v_knife_cord.mdl",
"models/weapons/v_knife_css.mdl",
"models/weapons/v_knife_falchion_advanced.mdl",

"models/weapons/v_knife_flip.mdl",
"models/weapons/v_knife_gg.mdl",
"models/weapons/v_knife_gut.mdl",
"models/weapons/v_knife_gypsy_jackknife.mdl",
"models/weapons/v_knife_karam.mdl",
"models/weapons/v_knife_m9_bay.mdl",

"models/weapons/v_knife_outdoor.mdl",
"models/weapons/v_knife_push.mdl",
"models/weapons/v_knife_skeleton.mdl",
"models/weapons/v_knife_stiletto.mdl",
"models/weapons/v_knife_survival_bowie.mdl",
"models/weapons/v_knife_tactica.mdl",

"models/weapons/v_knife_ursus.mdl",
"models/weapons/v_knife_widowmaker.mdl",];
array_w <- [
"models/weapons/w_knife_default_ct.mdl",
"models/weapons/w_knife_default_t.mdl",
"models/weapons/w_knife_bayonet.mdl",
"models/weapons/w_knife_butterfly.mdl",
"models/weapons/w_knife_canis.mdl",
"models/weapons/w_knife_cord.mdl",
"models/weapons/w_knife_css.mdl",
"models/weapons/w_knife_falchion_advanced.mdl",

"models/weapons/w_knife_flip.mdl",
"models/weapons/w_knife_gg.mdl",
"models/weapons/w_knife_gut.mdl",
"models/weapons/w_knife_gypsy_jackknife.mdl",
"models/weapons/w_knife_karam.mdl",
"models/weapons/w_knife_m9_bay.mdl",

"models/weapons/w_knife_outdoor.mdl",
"models/weapons/w_knife_push.mdl",
"models/weapons/w_knife_skeleton.mdl",
"models/weapons/w_knife_stiletto.mdl",
"models/weapons/w_knife_survival_bowie.mdl",
"models/weapons/w_knife_tactica.mdl",

"models/weapons/w_knife_ursus.mdl",
"models/weapons/w_knife_widowmaker.mdl",]

function Tick()
{
	local w = null;

	while (null != (w = Entities.FindByClassname(w, "predicted_viewmodel")))
	{
		if(InArray(w.GetModelName(), array_v))
		{
			w.SetModel(model_v);
		}
	}

	while (null != (w = Entities.FindByClassname(w, "weaponworldmodel")))
	{
		if(InArray(w.GetModelName(), array_w))
		{
			w.SetModel(model_w);
		}
	}
}

function InArray(fvalue, narray)
{
	foreach (value in narray)
	{
		if (value == fvalue)
		{
			return true;
		}
	}

	return false;
}