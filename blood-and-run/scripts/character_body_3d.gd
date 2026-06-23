extends CharacterBody3D
class_name Player


var nickname = "Niki"
var SPEED = 5.0
var JUMP_VELOCITY = 4.5
var in_door = false


var camera_anglev=0
var JumpVel: Vector3
var walk = false

var run = false


func _ready() -> void:
	if Global.mp_mode != "offline" and multiplayer.multiplayer_peer.get_connection_status() == MultiplayerPeer.CONNECTION_CONNECTED:
		# Если этот персонаж чужой для данного окна
		if not is_multiplayer_authority():
			# Полностью отключаем у него считывание встроенного ввода
			set_process_input(false)
			set_physics_process(false)
			if has_node("Camera3D"):
				$Camera3D.current = false
			return
			
	if not multiplayer.is_server():
		Global._add_player.rpc_id(1, multiplayer.get_unique_id(), Global.nickname)
		#Код, который выполнится ТОЛЬКО для вашего родного персонажа:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Global.player = self
	position = Vector3(-21,2.5,0)
	nickname = Global.nickname
	$Sprite3D/SubViewport/Label.text = nickname
	if has_node("Camera3D"):
		$Camera3D.current = true


func _physics_process(_delta: float) -> void:
	# СЕТЕВОЙ ФИЛЬТР:
	if not is_on_floor():
		velocity.y += get_gravity().y * _delta
		if run:
			run = false
			SPEED -= 3

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and !Global.isOnMenu:
		velocity.y = JUMP_VELOCITY
		JumpVel = velocity
	
	if Input.is_action_just_pressed("Run"):
		if !run and !Global.isOnMenu and is_on_floor():
			run = true
			SPEED += 3
			$AudioStreamPlayer3D.pitch_scale = 2
			$AudioStreamPlayer3D.volume_db += 10
	if Input.is_action_just_released("Run"):
		$AudioStreamPlayer3D.pitch_scale =  1
		$AudioStreamPlayer3D.volume_db -= 10
		if run and !Global.isOnMenu :
			run = false
			SPEED -= 3
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("A", "D", "W", "S")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction and !Global.isOnMenu:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		walk = true
	else:
		walk = false
		if is_on_floor():
			velocity.x = move_toward(velocity.x * 1.8, 0, SPEED)
			velocity.z = move_toward(velocity.z * 1.8, 0, SPEED)
			JumpVel = Vector3(0,0,0)
		#if !is_on_floor():
			#velocity.x = move_toward(velocity.x * 2, velocity.x + JumpVel.x * 0.9, SPEED)
			#velocity.z = move_toward(velocity.z * 2, velocity.z + JumpVel.z  * 0.9, SPEED)
	
	move_and_slide()
	#$Camera3D.rotate_y(deg_to_rad(-event.relative.x * mouse_sens))
		#var changev= -event.relative.y * mouse_sens
		#if camera_anglev +changev>-50 and camera_anglev + changev < 50:
			#camera_anglev+=changev
			#$Camera3D.rotate_x(deg_to_rad(changev))



func _input(event):
	if Global.mp_mode != "offline" and multiplayer.multiplayer_peer.get_connection_status() == MultiplayerPeer.CONNECTION_CONNECTED:
		if not is_multiplayer_authority():
			return
	if event is InputEventMouseMotion and !Global.isOnMenu:
		if $Camera3D.rotation.x - deg_to_rad(event.relative.y) < deg_to_rad(90) and $Camera3D.rotation.x - deg_to_rad(event.relative.y) > deg_to_rad(-70):
			$Camera3D.rotation += Vector3(deg_to_rad(-event.relative.y * Global.mouse_sens), 0, 0)
		rotation += Vector3(0 ,deg_to_rad(-event.relative.x * Global.mouse_sens), 0)
	var input:Vector2 = Input.get_vector("con_left", "con_right", "con_up", "con_down")
	if input != Vector2(0,0):
		if $Camera3D.rotation.x - deg_to_rad(input.y) < deg_to_rad(90) and $Camera3D.rotation.x - deg_to_rad(input.y) > deg_to_rad(-70):
			$Camera3D.rotation += Vector3(deg_to_rad(-input.y * Global.mouse_sens), 0, 0)
		rotation += Vector3(0 ,deg_to_rad(-input.x * Global.mouse_sens), 0)
		

	



func _print_in_ui(text:String):
	$Camera3D/game_ui/Label.text = text
	$Camera3D/game_ui/Timer.start()
	


func _on_h_slider_value_changed(value):
	Global.mouse_sens = value
	pass # Replace with function body.


func _on_tick_timeout():
	if randi_range(0,4)>1:
		if (absf(velocity.x) > 0.7 or absf(velocity.z) >0.7) and is_on_floor():
			if !$AudioStreamPlayer3D.playing:
				$AudioStreamPlayer3D.play()
		else:
			$AudioStreamPlayer3D.stop()
	pass # Replace with function body.



func _on_door_2__player_in():
	in_door = true
	pass # Replace with function body.


func _on_door_2__player_out():
	in_door = false
	pass # Replace with function body.


func _enter_tree() -> void:
	print(multiplayer.multiplayer_peer)
	if Global.mp_mode != "offline" and multiplayer.multiplayer_peer.get_connection_status() == MultiplayerPeer.CONNECTION_CONNECTED:
		var current_node_name = name
		var target_id = 1 # По умолчанию сервер
		
		var name_string = str(current_node_name)
	
		if name_string.is_valid_int():
			target_id = name_string.to_int()
		else:
		# Теперь спокойно перебираем символы строки
			var digits = ""
			for i in range(name_string.length()):
				if name_string[i].is_valid_int():
					digits += name_string[i]
			if digits != "":
				target_id = digits.to_int()

		
		# Жёстко выставляем сетевые права
		set_multiplayer_authority(target_id)
		var sync_node = get_node_or_null("MultiplayerSynchronizer")
		if sync_node:
			sync_node.set_multiplayer_authority(target_id)
		if not is_multiplayer_authority():
			if has_node("Camera3D"):
				$Camera3D.current = false # Принудительно гасим чужую камеру чтобы она никогда не перехватила экран
				$Camera3D/Menu.queue_free()
				$Camera3D/end_day.queue_free()
				$Camera3D/game_ui.queue_free()
				$Camera3D/Duhota.queue_free()
				$Camera3D/Achivka.queue_free()
		
		print("ЛОГ: Узел [", current_node_name, "] привязан к ID: ", target_id, ". Моё окно: ", multiplayer.get_unique_id(), ". Права совпали? ", is_multiplayer_authority())
