shader_type spatial;
render_mode blend_mix,depth_prepass_alpha,cull_disabled,diffuse_lambert_wrap,specular_disabled;


group_uniforms shell_positioning;
uniform int shell_index = 1;
uniform int shell_count = 2;
uniform float shell_spacing = 0.01;
uniform float shell_spacing_attenuation = 1.0;

group_uniforms shell_texture;
uniform float density = 64.0;
uniform float noise_min = 0.0;
uniform float noise_max = 1.0;

group_uniforms physics;
uniform float stiffness = 1.0;
uniform float stiffness_attenuation = 2.0;
uniform vec3 gravity_dir = vec3(0.0, -1.0, 0.0);
uniform vec3 displace_dir = vec3(0.0, -1.0, 0.0);

varying float height;


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


void vertex() {
	// TODO: shell attenuation
	height = float(shell_index) / float(shell_count);
	
	// extrude shell
	VERTEX.xyz += NORMAL.xyz * shell_spacing * float(shell_index);
	
	vec3 target = VERTEX.xyz;
	
	// gravity
	VERTEX.xyz += gravity_dir * pow(height, stiffness_attenuation) / stiffness * (1.0 - ((abs(dot(NORMAL, normalize(gravity_dir))) + 1.0) / 2.0));
	
	// wind
	//VERTEX.xyz += displace_dir * pow(height, stiffness_attenuation) / stiffness * (1.0 - ((abs(dot(NORMAL, normalize(displace_dir))) + 1.0) / 2.0));
	
	
}


void fragment() {
	vec2 scaled_uv = vec2(UV.x * 1.5, UV.y) * density;
	
	float tex = hash(uint(scaled_uv.x) + hash_u(uint(scaled_uv.y)));
	
	float dist = length((floor(scaled_uv) + vec2(0.5)) - scaled_uv);
	
	float thickness = clamp(smoothstep(0.4 * tex, 0.9 * tex, height), 0.4, clamp(tex, 0.4, 1.0));
	
	if((tex < height || dist > 0.5 * (height / tex)) && shell_index != 0) { discard; }
	//if((tex < height || dist > 0.5 * thickness) && shell_index != 0) { discard; }
	
	vec3 color = vec3(0.1, 0.1, 0.3) * tex * smoothstep(-0.2, 1.0, height);
	
	ALBEDO = color;
	ALPHA = 1.0;
	ALPHA_SCISSOR_THRESHOLD = 0.5;
}
