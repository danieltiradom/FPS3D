extends CharacterBody3D

var health = 2

var enemy_damage: int = 1
var attack_dist: float = 1.5
var attack_rate: float = 0.1

var move_speed: float = 3.6
var vel: Vector3 = Vector3.ZERO

@onready var timer: Timer = $Timer
@onready var player: Node3D = null

@export var next_enemy_scene: PackedScene

signal enemy_died

func _ready() -> void:
	# Buscar al jugador en el grupo "Player"
	var players = get_tree().get_nodes_in_group("Player")
	if players.size() > 0:
		player = players[0]
	else:
		push_warning("No se encontró ningún nodo en el grupo 'Player'")

	timer.wait_time = attack_rate
	timer.start()

func _physics_process(delta: float) -> void:
	if not player:
		return

	var dist = global_position.distance_to(player.global_position)

	if dist > attack_dist:
		var dir = (player.global_position - global_position).normalized()

		velocity.x = dir.x * move_speed
		velocity.z = dir.z * move_speed
	else:
		velocity.x = 0
		velocity.z = 0

	# Aplicar gravedad para que el enemigo no flote
	if not is_on_floor():
		velocity.y -= 9.8 * delta
	else:
		velocity.y = 0

	move_and_slide()

func _on_Timer_timeout():
	if not player:
		return
	
	if global_position.distance_to(player.global_position) <= attack_dist:
		if player.has_method("take_damage"):
			player.take_damage(enemy_damage)

func Enemy_hit(damage):
	health -= damage
	if health <= 0:
		die()
	
func die():
	if next_enemy_scene:
		var new_enemy = next_enemy_scene.instantiate()
		new_enemy.global_position = global_position
		get_tree().current_scene.add_child(new_enemy)
	emit_signal("enemy_died")
	queue_free()
