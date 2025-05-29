extends Node

@export var enemy_scene: PackedScene
@export var spawn_points: Array[Marker3D]  # Añade nodos de posición como hijos y asígnalos desde el editor
@export var spawn_delay := 0.5 #Segundos entre spawn
@export var delay_between_batches: float = 2.0
@onready var ui_wave_label = get_tree().current_scene.get_node("UI/WaveLabel")


var current_wave = 0
var enemies_remaining = 0
var spawning = false

func _ready():
	start_next_wave()

func start_next_wave():
	current_wave += 1
	show_wave_label("Oleada %d" % current_wave)

	# Espera 3 segundos antes de iniciar la oleada
	await get_tree().create_timer(3.0).timeout
	spawn_wave(current_wave)

func spawn_wave(wave_number):
	var total_to_spawn = current_wave * 4  # Aquí respetas tu lógica por ronda
	enemies_remaining = total_to_spawn
	
	while total_to_spawn > 0:
		var batch_count = min(4, total_to_spawn)
		
		# Baraja los spawnpoints para no repetir siempre el mismo patrón
		var available_points = spawn_points.duplicate()
		available_points.shuffle()
		
		for i in range(batch_count):
			var spawn_point = available_points[i]
			var enemy = enemy_scene.instantiate()
			enemy.global_position = spawn_point.global_position
			get_tree().current_scene.add_child(enemy)
			
			enemy.connect("enemy_died", Callable(self, "_on_enemy_died"))
		
		total_to_spawn -= batch_count
		await get_tree().create_timer(delay_between_batches).timeout

func _on_enemy_died():
	enemies_remaining -= 1
	if enemies_remaining <= 0:
		start_next_wave()

func show_wave_label(text):
	if ui_wave_label:
		ui_wave_label.text = text
		ui_wave_label.visible = true
		await get_tree().create_timer(2.0).timeout
		ui_wave_label.visible = false
