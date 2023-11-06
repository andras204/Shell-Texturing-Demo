@tool
extends Node3D

@export_category("shell Positioning")
@export var shell_count: int = 32
@export_range(0.0001, 1.0, 0.0001) var shell_spacing: float = 0.01
@export var shell_spacing_attenuation: float = 1.0

@export_category("Shell Texture")
@export_range(1, 4096) var density: int = 32
@export var noise_min: float = 0.0
@export var noise_max: float = 1.0


var shell_scene = preload("res://shell_demo_scenes/pine_forest/shell.tscn")

var shell_array: Array


var time: float = 0.0

func _ready():
	for x in range(shell_count):
		var instance = shell_scene.instantiate()
		instance.name = "shell" + str(x)
		update_shader_params(instance, x)
		add_child(instance)
		shell_array.append(instance)

func _process(delta):
	var i: int = 0
	for s in shell_array:
		update_shader_params(s, i)
		i += 1

func update_shader_params(instance, index: int):
	instance.shell_index = index
	instance.shell_count = shell_count
	instance.shell_spacing = shell_spacing
	instance.shell_spacing_attenuation = shell_spacing_attenuation
	
	instance.density = density
	instance.noise_min = noise_min
	instance.noise_max = noise_max
