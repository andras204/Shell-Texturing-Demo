@tool
extends MeshInstance3D

@export_range(0, 1) var height: float = 0.5
@export var shell_index: int = 1
@export var density: int = 32

func _ready():
	mesh.material.set_shader_parameter("height", height)
	mesh.material.set_shader_parameter("shell_index", shell_index)
	mesh.material.set_shader_parameter("density", density)
