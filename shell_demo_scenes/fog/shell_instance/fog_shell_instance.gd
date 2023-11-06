@tool
class_name FogShellInstance
extends MeshInstance3D

@export_range(0, 1) var height: float = 0.0


func _process(delta):
	mesh.material.set_shader_parameter("height", height)
