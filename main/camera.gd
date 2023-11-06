extends Camera3D


var radius: float = 1.0
var middle_click_down = false
var camera_arm: Node3D

@export var max_zoom_in: float = 0.1
@export var max_zoom_out: float = 10

@export var mouse_sensitivity: float = 0.01
@export var zoom_step: float = 0.01

func _ready():
	camera_arm = get_parent()
	zoom_in()
	zoom_out()


func _input(event: InputEvent):
	if event is InputEventMouseButton:
		match event.button_index:
			MOUSE_BUTTON_WHEEL_DOWN:
				zoom_out()
			MOUSE_BUTTON_WHEEL_UP:
				zoom_in()
			MOUSE_BUTTON_MIDDLE:
				if event.pressed:
					middle_click_down = true
				else:
					middle_click_down = false
	if event is InputEventMouseMotion and middle_click_down:
		mouse_rotate(event.relative * -mouse_sensitivity)


func mouse_rotate(mouse_input: Vector2):
	camera_arm.rotate_y(mouse_input.x)
	camera_arm.rotate_object_local(Vector3.RIGHT, mouse_input.y)


func zoom_out():
	radius = min(radius + (zoom_step * (radius / max_zoom_in - 0.5)), max_zoom_out)
	transform.origin = Vector3(0, radius, 0)
	if projection == PROJECTION_ORTHOGONAL:
		size = radius


func zoom_in():
	radius = max(radius - (zoom_step * (radius / max_zoom_in - 0.5)), max_zoom_in)
	transform.origin = Vector3(0, radius, 0)
	if projection == PROJECTION_ORTHOGONAL:
		size = radius
