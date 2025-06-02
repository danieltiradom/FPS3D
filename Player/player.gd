extends CharacterBody3D

var speed = 7
var gravity = 9.8
var jump = 4.5
var hp: int = 5
var max_hp: int = 5

var total_ammo = 60
var ammo = total_ammo
var recargando = false

var damage = 1
var is_invulnerable = false

var canshoot = true

@onready var head = $Node3D
@onready var raycast = $Node3D/Camera3D/RayCast3D
@onready var health_bar = get_tree().get_root().get_node("Main/UI/HealthBar") # Ajusta el path según tu estructura



var EnemyPart = preload("res://Enemies/enemypart.tscn")


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	#Configura la direccion del jugador en el mundo
	rotation.y = deg_to_rad(-90)
	# Reinicia rotaciones locales del head
	head.rotation = Vector3(0, 0, 0)


func update_health_bar():
	if health_bar:
		health_bar.max_value = max_hp
		health_bar.value = hp

func _unhandled_input(event):
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			head.rotation.y -= event.relative.x * 0.0025
			head.rotation.x -= event.relative.y * 0.0025
			head.rotation.x = clamp(head.rotation.x, deg_to_rad(-80), deg_to_rad(80))

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump
	
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (head.global_transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
		
	move_and_slide()
	
	if Input.is_action_pressed("Shoot") && canshoot == true && ammo > 0:
		canshoot = false
		$Firerate.start()
		shoot()
		ammo -= 1
		print(ammo)
		
	if ammo == 0 && recargando == false:
		recargar()
		
	if Input.is_action_just_pressed("Reload") && recargando == false:
		recargar()
		
	var ammo_label = get_tree().get_root().get_node("Main/UI/Ammo_label")
	ammo_label.text = "Munición: " + str(ammo) + " / " + str(total_ammo)


func shoot():
	if raycast.is_colliding():
		var colpoint = raycast.get_collision_point()
		var normal = raycast.get_collision_normal()
		var target = raycast.get_collider()
		
		if target != null:
			if target.is_in_group("Enemy") && target.has_method("Enemy_hit"):
				target.Enemy_hit(damage)
				
				var enemypart = EnemyPart.instantiate()
				enemypart.global_position = colpoint
				get_tree().current_scene.add_child(enemypart)
				
				enemypart.look_at(colpoint + normal, Vector3.UP)
				enemypart.look_at(colpoint + normal, Vector3.RIGHT)


func _on_firerate_timeout():
	canshoot = true
	
func take_damage(enemy_damage):
	if is_invulnerable:
		return
		
	is_invulnerable = true
	$InvulTimer.start()
	
	hp-=enemy_damage
	update_health_bar()
	print(hp)
	if hp<=0:
		die()
		
func die():
	# Muestra el mensaje "Game Over"
	var game_over_label = get_tree().current_scene.get_node("UI/GameOverLabel")
	game_over_label.text = "GAME OVER"
	game_over_label.visible = true
	get_tree().paused = true

	await get_tree().create_timer(2.5).timeout  # Esperar 2.5 segundos
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().paused = false
	get_tree().change_scene_to_file("res://MainMenu.tscn")


func _on_InvulTimer_timeout():
	is_invulnerable = false
	
func recargar():
	recargando = true
	print("Recarganding")
	$Firerate.stop()
	canshoot = false
	await get_tree().create_timer(3.0).timeout
	ammo = total_ammo
	canshoot = true
	$Firerate.start()
	recargando = false
