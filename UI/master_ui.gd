extends Control

signal blue_plants
signal pine_forest
signal vert_ext

var version = "v0.1.01"

func _ready():
	%topbar_label.text = "Default scene // " + version
	%scenes_button.connect("button_up", toggle_scene_list)
#	%properties_button.connect("button_up", _send_properties_clicked)
	%perf_button.connect("button_up", toggle_perf_readout)
	
	%blue_plants.connect("button_up", _emit_blue_plants)
	%pine_forest.connect("button_up", _emit_pine_forest)
	%vert_ext.connect("button_up", _emit_vert_ext)


func _process(delta):
	if %perf_readout.visible:
		update_perf_readouts(delta)


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		visible = !visible;


func toggle_scene_list():
	%scene_list.visible = !%scene_list.visible;


func toggle_perf_readout():
	%perf_readout.visible = !%perf_readout.visible;


func update_perf_readouts(delta: float):
	%fps_counter.text = "%.2f" % (1 / delta)
	%frametime_readout.text = "%.2f" % (delta * 1000)


func _emit_blue_plants():
	%topbar_label.text = "Blue plants // " + version
	emit_signal("blue_plants")


func _emit_pine_forest():
	%topbar_label.text = "Pine Forest // " + version
	emit_signal("pine_forest")


func _emit_vert_ext():
	%topbar_label.text = "Furball // " + version
	emit_signal("vert_ext")
