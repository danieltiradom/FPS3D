extends Control

@onready var RIGHT = $Center/RIGHT
@onready var BOTTOM = $Center/BOTTOM
@onready var LEFT = $Center/LEFT
@onready var TOP = $Center/TOP

var growpos = 35
var growspeed = 4

func _physics_process(delta):
	if Input.is_action_pressed("Shoot"):
		RIGHT.position = lerp(RIGHT.position, Vector2(growpos, 0), growspeed * delta)
		BOTTOM.position = lerp(BOTTOM.position, Vector2(0, growpos), growspeed * delta)
		LEFT.position = lerp(LEFT.position, Vector2(-growpos, 0), growspeed * delta)
		TOP.position = lerp(TOP.position, Vector2(0, -growpos), growspeed * delta)
	else:
		RIGHT.position = lerp(RIGHT.position, Vector2(10, 0), growspeed * delta)
		BOTTOM.position = lerp(BOTTOM.position, Vector2(0, 10), growspeed * delta)
		LEFT.position = lerp(LEFT.position, Vector2(-10, 0), growspeed * delta)
		TOP.position = lerp(TOP.position, Vector2(0, -10), growspeed * delta)
