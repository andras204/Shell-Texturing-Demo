shader_type spatial;
render_mode blend_mix,depth_prepass_alpha,cull_disabled,diffuse_lambert_wrap,specular_disabled;

uniform vec4 albedo : source_color;
uniform sampler2D texture_albedo : source_color,repeat_enable;
uniform float height = 0.0;

void fragment() {
	vec2 base_uv = UV;
	float sway = ((cos(TIME + length(base_uv)) + 1.0) / 2.0) * pow(height + 0.3, 2.0) * (1.0 / 32.0);
	vec4 albedo_tex = texture(texture_albedo, base_uv + sway);
	float tex = clamp(albedo_tex.r * 2.0 - 1.0, 0.0, 1.0);
	if(tex < height) { discard; }
	ALBEDO = albedo.rgb * height;
	ALPHA = 1.0;
	ALPHA_SCISSOR_THRESHOLD = 0.5;
}
