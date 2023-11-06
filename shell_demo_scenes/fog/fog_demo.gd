extends Node3D


@export var shells: int = 32
@export var shell_spacing: float = 0.005

var shell_scene = preload("res://fog/shell_instance/fog_shell_instance.tscn")

func _ready():
	for x in range(shells):
		var instance: FogShellInstance = shell_scene.instantiate()
		instance.transform.origin = Vector3(0, x * shell_spacing, 0)
		instance.name = "shell" + str(x)
		instance.height = x as float / shells
		add_child(instance)
