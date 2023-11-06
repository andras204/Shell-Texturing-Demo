shader_type spatial;
render_mode blend_mix,depth_prepass_alpha,cull_disabled,diffuse_lambert_wrap,specular_disabled;

uniform vec4 albedo : source_color;
uniform sampler2D texture_albedo : source_color,repeat_enable;
uniform float height: hint_range(0.0, 1.0, 0.001) = 0.0;

void fragment() {
	vec2 base_uv = UV;
	vec4 albedo_tex = texture(texture_albedo, base_uv);
	if(albedo_tex.r < height) { discard; }
	ALBEDO = mix(vec3(0.0, 0.4, 0.10), vec3(0.7, 0.15, 0.0), height);
	if(albedo_tex.r < height + 0.005) { ALBEDO = vec3(0); }
	ALPHA = 1.0;
	ALPHA_SCISSOR_THRESHOLD = 0.5;
}
