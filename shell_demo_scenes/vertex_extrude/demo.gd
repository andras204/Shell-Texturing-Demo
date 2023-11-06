@tool
extends Node3D

@export_category("shell Positioning")
@export var shell_count: int = 32
@export_range(0.0001, 1.0, 0.0001) var shell_spacing: float = 0.01
@export var shell_spacing_attenuation: float = 1.0

@export_category("Shell Texture")
@export_range(1, 4096) var density: int = 64
@export var noise_min: float = 0.0
@export var noise_max: float = 1.0

@export_category("Physics")
@export var stiffness: float = 2.0
@export var stiffness_attenuation: float = 2.0
@export var gravity_dir: Vector3 = Vector3(0.0, -1.0, 0.0)
@export var displace_dir: Vector3 = Vector3(0.0, 0.0, 0.0)

@export_category("Demo")
@export_range(0.0, 100.0, 0.1) var wind_strength: float = 1.0

var shell_scene = preload("res://shell_demo_scenes/vertex_extrude/shell.tscn")

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
	time += delta
	#displace_dir.x = ((cos(time) + 1) / 2) * wind_strength
	displace_dir.x = wind_strength
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
	
	instance.stiffness = stiffness
	instance.stiffness_attenuation = stiffness_attenuation
	instance.gravity_dir = gravity_dir
	instance.displace_dir = displace_dir
