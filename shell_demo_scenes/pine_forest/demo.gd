@tool
extends Node3D

@export var shells: int = 256
@export_range(0.0001, 1.0, 0.0001) var shell_spacing: float = 0.001

@export var density: int = 32

@export var shell_scene = preload("res://shell_demo_scenes/pine_forest/shell.tscn")

var shell_array: Array

func _ready():
	for x in range(shells):
		var instance = shell_scene.instantiate()
		instance.transform.origin = Vector3(0, x * shell_spacing, 0)
		instance.name = "shell" + str(x)
		instance.height = x as float / (shells - 1)
		instance.shell_index = x
		instance.density = density
		add_child(instance)
		shell_array.append(instance)

func _process(delta):
	var i: int = 0
	for s in shell_array:
		s.transform.origin = Vector3(0, i * shell_spacing, 0)
		i += 1
