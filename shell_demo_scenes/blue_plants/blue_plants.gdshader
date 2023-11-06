shader_type spatial;
render_mode blend_mix,depth_prepass_alpha,cull_disabled,diffuse_lambert_wrap,specular_disabled;

uniform vec4 albedo : source_color;
uniform vec4 fade : source_color;
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
	float sway = cos((TIME / 3.0) + length(UV)) * pow(height + 0.3, 2.0) * (1.0 / (float(density) * 1.25));
	float breathe = ((cos(TIME + length(UV * 2.0)) + 1.0) / 2.0) * pow(height + 0.3, 2.0) * (1.0 / (float(64) / 2.0));
	
	vec2 scaled_uv = (UV + vec2(sway)) * float(density);
	
	float tex = hash(uint(scaled_uv.x) + hash_u(uint(scaled_uv.y)) + hash_u(seed));
	
	if(scaled_uv.x < 1.0) { tex = 0.0; }
	if(scaled_uv.y < 1.0) { tex = 0.0; }
	if(scaled_uv.x > float(density - 1)) { tex = 0.0; }
	if(scaled_uv.y > float(density - 1)) { tex = 0.0; }
	
	float dist = length((floor(scaled_uv) + vec2(0.5)) - scaled_uv);
	
	float thickness = clamp(smoothstep(0.4 * tex, 0.9 * tex, height), 0.4, clamp(tex, 0.4, 1.0));
	float asd = tex - (breathe * 10.0);
	
	if((asd < height || dist > 0.5 * thickness) && shell_index != 0) { discard; }
	
	vec3 color = mix(albedo.rgb, fade.rgb, length(UV.xy / sqrt(2))) * tex * smoothstep(-0.2, 1.0, height);
	
	ALBEDO = color;
	ALPHA = 1.0;
	if(tex == 0.0) { ALPHA = 0.0; }
	ALPHA_SCISSOR_THRESHOLD = 0.5;
}
