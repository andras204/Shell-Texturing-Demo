extends Node3D

var pine = preload("res://shell_demo_scenes/pine_forest/demo.tscn")
var blue = preload("res://shell_demo_scenes/blue_plants/demo.tscn")
var vert = preload("res://shell_demo_scenes/vertex_extrude/demo.tscn")

var demo

func _ready():
	%master_ui.connect("blue_plants", blue_plants)
	%master_ui.connect("pine_forest", pine_forest)
	%master_ui.connect("vert_ext", vert_ext)
	demo = blue.instantiate()
	%demo_container.add_child(demo)


func _process(delta):
	pass


func switch_scene(scene):
	for x in %demo_container.get_children():
		x.queue_free()
	demo = scene.instantiate()
	%demo_container.add_child(demo)


func blue_plants():
	switch_scene(blue)


func pine_forest():
	switch_scene(pine)


func vert_ext():
	switch_scene(vert)
