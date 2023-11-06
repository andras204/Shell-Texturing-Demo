@tool
extends MeshInstance3D

@export_category("shell Positioning")
@export var shell_index: int = 1
@export var shell_count: int = 2
@export_range(0.0001, 1.0, 0.0001) var shell_spacing: float = 0.01
@export var shell_spacing_attenuation: float = 1.0

@export_category("Shell Texture")
@export var density: int = 64
@export var noise_min: float = 0.0
@export var noise_max: float = 1.0

@export_category("Physics")
@export var stiffness: float = 2.0
@export var stiffness_attenuation: float = 2.0
@export var gravity_dir: Vector3 = Vector3(0.0, -1.0, 0.0)
@export var displace_dir: Vector3 = Vector3(0.0, -1.0, 0.0)

func _ready():
	update_shader_params()


func _process(delta):
	update_shader_params()


func update_shader_params():
	mesh.material.set_shader_parameter("shell_index", shell_index)
	mesh.material.set_shader_parameter("shell_count", shell_count)
	mesh.material.set_shader_parameter("shell_spacing", shell_spacing)
	
	mesh.material.set_shader_parameter("density", density)
	mesh.material.set_shader_parameter("noise_min", noise_min)
	mesh.material.set_shader_parameter("noise_max", noise_max)
	
	mesh.material.set_shader_parameter("stiffness", stiffness)
	mesh.material.set_shader_parameter("stiffness_attenuation", stiffness_attenuation)
	mesh.material.set_shader_parameter("gravity_dir", gravity_dir)
	mesh.material.set_shader_parameter("displace_dir", displace_dir)
