extends Control

func _ready():
	$VBoxContainer/PlayButton.pressed.connect(on_play_pressed)
	$VBoxContainer/OptionsButton.pressed.connect(on_options_pressed)
	$VBoxContainer/QuitButton.pressed.connect(on_quit_pressed)
	
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func on_play_pressed():
	get_tree().change_scene_to_file("res://mundo.tscn")

func on_options_pressed():
	# Si no hay opciones aún, puedes mostrar un mensaje temporal o dejarlo vacío
	print("Opciones aún no implementadas")

func on_quit_pressed():
	get_tree().quit()
