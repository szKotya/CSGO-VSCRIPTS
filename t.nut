// ::k <- "models/player/custom_player/darraysnias/hunk/hunk.mdl"
// self.PrecacheModel(k);


// ::DebugDrawCircle <- function(Vector_Center, radius, parraysts = 32, duration = 10) //0 -32 80
// {
//    Vector_Center = self.GetOrigin();
//    radius = 72;
//    parraysts = 16;

// 	local Vector_RGB = Vector(255, 255, 255);
// 	local u = 0.0;
// 	local vec_end = [];
// 	local parraysts_l = parraysts;
// 	local radius = radius;
// 	local a = PI / parraysts * 2;

// 	while (parraysts_l > 0)
// 	{
// 		local vec = Vector(Vector_Center.x+cos(u)*radius, Vector_Center.y+sin(u)*radius, Vector_Center.z);
// 		vec_end.push(vec);
// 		u += a;
// 		parraysts_l--;
// 	}

// 	for (local i = 0; i < vec_end.len(); i++)
// 	{
// 		if (i < vec_end.len()-1){DebugDrawLine(vec_end[i], vec_end[i+1], Vector_RGB.x, Vector_RGB.y, Vector_RGB.z, true, duration);}
// 		else{DebugDrawLine(vec_end[i], vec_end[0], Vector_RGB.x, Vector_RGB.y, Vector_RGB.z, true, duration);}

//       printl(format("\"OnCase0%i\" \"!activator,addoutput,origin %i %i %i,0,-1\"", i+1, vec_end[i].x, vec_end[i].y, vec_end[i].z - 100));
// 	}
// }

// DebugDrawCircle(null, null, null);

// EntFire("filter_knife", "testactivator", "", 0, self);

::arrays <- [];
function Load()
{
	local h;
	arrays.clear();

	while ((h = Entities.FindByName(h, "quest00_sprite*")) != null)
	{
		arrays.push(h);
	}

	arrays.sort(sortf);

	local origin;
	foreach (index, value in arrays)
	{
		origin = value.GetOrigin();
		printl(format("\"OnCase%s%i\" \"point_template,AddOutPut,origin %i %i %i,0,1\"", (index+1 > 9 ? "" : "0"), index+1, origin.x, origin.y, origin.z));
	}
}

function sortf(first, second)
{
	local count1 = first.GetName().slice(first.GetName().len()-2).tointeger();
	local count2 = second.GetName().slice(second.GetName().len()-2).tointeger();
	if (count1 > count2) return 1;
	if (count1 < count2) return -1;
	return 0;
}

EntFireByHandle(self, "RunScriptCode", "Load()", 0.05, null, null);