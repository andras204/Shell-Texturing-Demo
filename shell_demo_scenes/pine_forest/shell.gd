@tool
extends MeshInstance3D

@export_category("shell Positioning")
@export var shell_index: int = 1
@export var shell_count: int = 2
@export_range(0.0001, 1.0, 0.0001) var shell_spacing: float = 0.01
@export var shell_spacing_attenuation: float = 1.0

@export_category("Shell Texture")
@export var density: int = 32
@export var noise_min: float = 0.0
@export var noise_max: float = 1.0


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
