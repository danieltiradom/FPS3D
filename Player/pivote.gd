extends Node3D

@export var look_sensitivity: float = 15.0
@export var min_look_angle: float = -10.0
@export var max_look_angle: float = 75.0

var mouse_delta := Vector2()

@onready var player: Node3D = get_parent()

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse_delta = event.relative

func _process(delta: float) -> void:
	var rot := Vector3(mouse_delta.y, mouse_delta.x, 0) * look_sensitivity * delta

	rotation.x += deg_to_rad(rot.x)
	rotation.x = clamp(rotation.x, deg_to_rad(min_look_angle), deg_to_rad(max_look_angle))

	player.rotation.y -= deg_to_rad(rot.y)

	mouse_delta = Vector2()
