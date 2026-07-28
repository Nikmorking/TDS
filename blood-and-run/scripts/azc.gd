extends Target_manager
class_name Zaz


# Called when the node enters the scene tree for the first time.
func _ready():
	multiplayer.peer_connected.connect(Multiplayer._on_player_connected)
	multiplayer.peer_disconnected.connect(Multiplayer._on_player_disconnected)
	multiplayer.connected_to_server.connect(func(): print("Клиент: Я успешно вошел на сервер!"))
	multiplayer.connection_failed.connect(func(): print("Клиент: Ошибка! Сервер не отвечает."))
	Check_boxes = $"Заправка/Table/CSGPolygon3D/SubViewport/Control/Control".get_children()
	print(Check_boxes)
	if Global.mp_mode == "host":
		Multiplayer.start_host()
	elif Global.mp_mode == "join":
		Multiplayer.start_join()
	else:
		Global.papa = self
		var player_instance = load("res://scenes/player.tscn").instantiate()
		$cont_players.add_child(player_instance)
		Global.player = player_instance
	print(Global.is_load)
	if Global.is_load:
		Global.load_game()
	#if Global.new:
		#$Prolog.start()
	#Global.player.get_node("Camera3D/Menu").hide()
	Global.is_load = false
	rand = true 
	if Global.fara_days != 1:
		zakaz_list.append_array(
			[["ahabka_buttonov", "Stakan_cofe","Zapravka"],
			[ "ahabka_buttonov", "Stakan_cofe", "snack", "Zapravka"],
			["Cofe", "Stakan_cofe", "Zapravka"],
			["ahabka_buttonov", "Stakan_cofe", "snack"],
			[ "ahabka_buttonov", "Zapravka"],
			["Stakan_cofe", "Zapravka"],
			["Stakan_cofe", "snack","Zapravka"],
  			["ahabka_buttonov", "snack"]
			]
		)
		zakaz_list.append_array(
			[["ahabka_buttonov", "Stakan_cofe","Zapravka"],
			[ "ahabka_buttonov", "Stakan_cofe", "snack", "Zapravka"],
			["Cofe", "Stakan_cofe", "Zapravka"],
			["ahabka_buttonov", "Stakan_cofe", "snack"],
			[ "ahabka_buttonov", "Zapravka"],
			["Stakan_cofe", "Zapravka"],
			["Stakan_cofe", "snack","Zapravka"],
  			["ahabka_buttonov", "snack"]
			]
		)
	c.volumetric_fog_emission = Color("4f1c5e")
	pass # Replace with function body.


func _input(event):
	if Input.is_action_just_pressed("ui_redo"):
		#Global.light_off()
		if multiplayer.is_server():
			Multiplayer.print_once_per_client.rpc()
		#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		#_start_sream()
		#$Timer2.start()
	if Input.is_action_just_pressed("ui_home"):
		#Global.light_off.rpc()
		#_start_sream()
		#back()
		$"driving in my car"._start()
		
	pass


@rpc("any_peer", "call_local")
func _start_day():
	if start_day:
		$Tick.start()
		rand = false
		$Proshlo.start()
		start_day = false

func _on_door_2__open():
	_start_day.rpc_id(1)
	pass # Replace with function body.



func die(prichina: String):
	print(prichina)
	#if prichina == "Задавлен":
		#$Player/Camera3D/Achivka/AnimationPlayer.speed_scale = 4
		#Global.achivka("                      Задавлен")
		#printerr("Буква: Z")
	#$Be.play()
	#if prichina == "Съели" :
		#$"emeny/Настоящий пельмень2/AnimationPlayer".play("new_animation")
	#else:
		#$Player/Camera3D/game_ui/Sprite2D.show()
		#$Timer4.start()
	#$emeny.vkl = false
	#$emeny.process_mode = ProcessMode.PROCESS_MODE_DISABLED
	#$emeny.start = false



func _on_ожидание_timeout():
	time_left = true
	pass # Replace with function body.

func _on_animation_player_animation_finished(ani_name):
	die_part2()

func die_part2():
	_start_sream()
	$"emeny/Настоящий пельмень2/AnimationPlayer".play("RESET")
	get_tree().change_scene_to_file("res://scenes/AZC.tscn")
	Global.is_load = true
	$Player/Camera3D/game_ui/Sprite2D.show()
	pass


func _on_multiplayer_spawner_spawned(node):
	Multiplayer._on_player_spawned(node)
	pass # Replace with function body.
