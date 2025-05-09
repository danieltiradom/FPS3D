extends Area3D

@export var speed: float = 20.0
var direction: Vector3 = Vector3.FORWARD


func _ready() -> void:
	connect("body_entered", Callable(self, "_on_body_entered"))

func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta

func _on_body_entered(body: Node) -> void:
	if body.has_method("take_damage"):
		body.take_damage(1)  # O la cantidad deseada
		queue_free()  # Destruye la bala
