extends Node

@export var enemy_scene: PackedScene
@export var spawn_points: Array[Marker3D]  # Añade nodos de posición como hijos y asígnalos desde el editor
#@export var spawn_delay := 0.5 #Segundos entre spawn
@export var delay_between_batches: float = 1.0
@onready var ui_wave_label = get_tree().current_scene.get_node("UI/WaveLabel")


var current_wave = 0
var enemies_remaining = 0
var spawning = false

var enemy_scenes = {
	"Red": preload("res://Enemies/Enemy.tscn"),
	"Blue": preload("res://Enemies/BlueEnemy.tscn"),
	"Green": preload("res://Enemies/GreenEnemy.tscn")
}

var rounds_data = {
	1: repeat_str("Red", 10) + repeat_str("Blue", 25) + repeat_str("Red", 15),
	2: repeat_str("Red", 35),
	3: repeat_str("Red", 25) + repeat_str("Blue", 5),
	4: repeat_str("Red", 35) + repeat_str("Blue", 18),
	5: repeat_str("Red", 5) + repeat_str("Blue", 27),
	6: repeat_str("Red", 15) + repeat_str("Blue", 15) + repeat_str("Green", 4)
}

func _ready():
	start_next_wave()

func start_next_wave():
	current_wave += 1
	show_wave_label("Oleada %d" % current_wave)

	# Espera 3 segundos antes de iniciar la oleada
	await get_tree().create_timer(3.0).timeout
	spawn_wave(current_wave)

func spawn_wave(wave_number):
	if !rounds_data.has(wave_number):
		print("No hay datos para la oleada ", wave_number)
		return

	var enemies_to_spawn = rounds_data[wave_number]
	enemies_remaining = enemies_to_spawn.size()

	var i = 0
	while i < enemies_to_spawn.size():
		var batch = enemies_to_spawn.slice(i, i + 4)
		var available_points = spawn_points.duplicate()
		available_points.shuffle()

		for j in range(batch.size()):
			var enemy_type = batch[j]
			if enemy_scenes.has(enemy_type):
				var enemy = enemy_scenes[enemy_type].instantiate()
				enemy.global_position = available_points[j % available_points.size()].global_position
				get_tree().current_scene.add_child(enemy)
				enemy.connect("enemy_died", Callable(self, "_on_enemy_died"))
			else:
				print("No se encontró escena para tipo de enemigo: ", enemy_type)
		i += 4
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
		

#Funcion para asginar las rondas
func repeat_str(name: String, times: int) -> Array:
	var result := []
	for i in range(times):
		result.append(name)
	return result
