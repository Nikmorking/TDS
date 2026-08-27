shader_type spatial;
render_mode blend_mix, depth_draw_always, cull_back, unshaded;

uniform float r = 1;    

void fragment() {
	float rez = UV.y*UV.y + UV.x*UV.x - r;
	if(rez > 0.0){ALBEDO = vec3(0,1,1);}
}
//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
