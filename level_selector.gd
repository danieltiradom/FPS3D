extends Control

func _ready():
	$HBoxContainer/Facil.pressed.connect(on_facil_pressed)
	$HBoxContainer/Normal.pressed.connect(on_normal_pressed)
	$HBoxContainer/Dificil.pressed.connect(on_dificil_pressed)
	$VBoxContainer/QuitButton.pressed.connect(on_volver_pressed)
	
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func on_facil_pressed():
	get_tree().change_scene_to_file("res://mundo.tscn")
	
func on_normal_pressed():
	get_tree().change_scene_to_file("res://mundo2.tscn")
	
func on_dificil_pressed():
	#get_tree().change_scene_to_file("res://mundo3.tscn")
	print("Opciones aún no implementadas")

func on_volver_pressed():
	get_tree().change_scene_to_file("res://MainMenu.tscn")
