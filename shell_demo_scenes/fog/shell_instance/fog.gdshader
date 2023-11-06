shader_type spatial;
render_mode blend_mix,depth_draw_opaque,cull_disabled,diffuse_lambert_wrap,specular_disabled;

uniform vec4 albedo : source_color;
uniform sampler2D texture_albedo : source_color,filter_linear_mipmap,repeat_enable;
uniform sampler2D texture_noise : source_color,filter_linear_mipmap,repeat_enable;
uniform float height = 0.0;


void fragment() {
	vec2 base_uv = UV;
	vec4 albedo_tex = texture(texture_albedo, vec2(base_uv.x + (TIME / 113.0), base_uv.y + cos(TIME / 7.0) / 10.0));
	vec4 noise_tex = texture(texture_noise, vec2(base_uv.x + sin(TIME / 13.0) / 10.0, base_uv.y + (TIME / 127.0)));
	vec4 tex = (albedo_tex + noise_tex) / 2.0;
	if(tex.r < height) { discard; }
	ALBEDO = albedo.rgb * clamp(height, 0.5, 1.0);
	ALPHA = 1.0 / 32.0;
}
