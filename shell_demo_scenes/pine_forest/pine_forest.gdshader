shader_type spatial;
render_mode blend_mix,depth_prepass_alpha,cull_disabled,diffuse_lambert_wrap,specular_disabled;

uniform vec4 albedo : source_color;
uniform float height : hint_range(0.0, 1.0, 0.001) = 0.0;
uniform int density = 64;
uniform int shell_index = 0;
uniform uint seed = 0;

// hash function by FabriceNeyret2
// https://www.shadertoy.com/view/WttXWX
uint hash_u(uint x)
{
    x ^= x >> 17U;
    x *= 0xed5ad4bbU;
    x ^= x >> 11U;
    x *= 0xac4c1b51U;
    x ^= x >> 15U;
    x *= 0x31848babU;
    x ^= x >> 14U;
    return x;
}

float hash(uint x)
{
    x ^= x >> 17U;
    x *= 0xed5ad4bbU;
    x ^= x >> 11U;
    x *= 0xac4c1b51U;
    x ^= x >> 15U;
    x *= 0x31848babU;
    x ^= x >> 14U;
    return float(x) / float(0xffffffffU);
}

void fragment() {
	vec2 sway_uv = UV * float(density);
	
	float sway_tex = hash(uint(sway_uv.x) + hash_u(uint(sway_uv.y)));
	
	float sway_offset = hash(uint(sway_tex * 1000.0)) * (PI / 2.0);
	
	float sway_x = sin((TIME / PI + sway_offset) + length(UV)) * pow(height, 2.0) * (1.0 / (float(density) * 10.0));
	float sway_y = cos((TIME / E + sway_offset) + length(UV)) * pow(height, 2.0) * (1.0 / (float(density) * 10.0));
	
	vec2 scaled_uv = (UV + vec2(sway_x, sway_y)) * float(density);
	
	float tex = hash(uint(scaled_uv.x) + hash_u(uint(scaled_uv.y)));
	
	float dist = length((floor(scaled_uv) + vec2(0.5)) - scaled_uv);
	
	float thickness = ((1.0 - fract((height / tex) * 4.0)) * 0.5 + 0.5) * smoothstep(-1.0, 1.0, tex) * (1.0 - (height / tex));
	
	if(height < tex / 4.0) { thickness = 0.15; }
	
	if((tex < height || dist > 0.5 * thickness) && shell_index != 0) { discard; }
	
	vec3 trunk_col = vec3(0.5, 0.1, 0.0);
	vec3 foliage_col = vec3(0.03, 0.15, 0.04);
	
	ALBEDO = mix(trunk_col, foliage_col, step(tex / 4.0, height)) * smoothstep(-0.2, 1.0, height) * clamp(tex, 0.5, 1.0);
	if(shell_index == 0) { ALBEDO = foliage_col * smoothstep(-0.2, 1.0, height) * smoothstep(-1.0, 2.0, 1.0 - tex); }
	ALPHA = 1.0;
	ALPHA_SCISSOR_THRESHOLD = 0.5;
}
