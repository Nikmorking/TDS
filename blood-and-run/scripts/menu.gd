extends Control
class_name Menu


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global._syn_players.connect(on_players_sun)
	if Global.mp_mode == "offline": $VBoxContainer.queue_free()
	pass # Replace with function body.



func _on_continue_button_down() -> void:
	cont()
	print("halihopler")
	pass # Replace with function body.


func _input(event: InputEvent) -> void:
	if Input.is_action_just_released("Escape") and Global.igra:
		if Global.mp_mode != "offline" and multiplayer.multiplayer_peer.get_connection_status() == MultiplayerPeer.CONNECTION_CONNECTED:
			if not is_multiplayer_authority():
				return # Если это сетевой клон чужого игрока, полностью игнорируем нажатие
		if !Global.isOnMenu:
			#get_tree().paused = true
			Global.isOnMenu = true
			$Open.play()
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			#$CharacterBody3D.velocity = Vector3(0, 0, 0)
			get_parent().get_node("game_ui").hide()
			show()
			get_node("AnimationPlayer").play("Open")
			if  Global.mp_mode != "offline":
				if Global.lobby_ready: $Label.text = "Лобби закрыто"
				else: $Label.text = "Лобби открыто"
				$Save.hide()
				for i in $VBoxContainer.get_children():
					if str(i.name) != "ready" or not multiplayer.is_server(): i.queue_free()
				for i in Global.players[1].size():
					var item = load("res://demo/item_player_list.tscn").instantiate()
					item.get_node("Label").text = str(Global.players[1][i])
					item.list = [Global.players[0][i], Global.players[1][i]]
					if Global.lobby_ready: item.get_node("Button").queue_free()
					$VBoxContainer.add_child(item)
			else:
				$Label.text = "Сервер не запущен"
		else:
			cont()


	if Input.is_action_just_pressed("ui_open"):
		$AnimationPlayer.play("RESET")

func cont():
			Global.esc()
			$Close.play()
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			get_parent().get_node("game_ui").show()
			hide()

func _on_quit_button_down() -> void:
	if  Global.mp_mode == "offline": Global.save()
	get_tree().quit()
	pass # Replace with function body.



func focus_entered():
	if visible:
		$Nakodka.play()
	pass # Replace with function body.


func _on_animation_player_animation_finished(anim_name):
	$continue.grab_focus.call_deferred()
	pass # Replace with function body.

var settin = 0

func _on_settings_button_down():
	settin += 1
	if settin == 6:
		Global.achivka("Достижение: \nМастер по настройке")
		printerr("Буква: P")
	get_tree().change_scene_to_file("res://demo/Options.tscn")
	pass # Replace with function body.


func _on_restart_button_down():
	Global.esc()
	get_tree().reload_current_scene()
	pass # Replace with function body.


func _on__quit_button_down():
	get_tree().quit()
	pass # Replace with function body.


func _on_save_button_down():
	Global.save()
	pass # Replace with function body.


func _on_ready_button_down() -> void:
	if multiplayer.is_server():
		Global._lobby_ready.rpc()
		$VBoxContainer/ready.queue_free()
		$Label.text = "Лобби закрыто"
		for i in $VBoxContainer.get_children():
			if not i.is_class("Button"): i.get_node("Button").queue_free()
	pass # Replace with function body.

func on_players_sun(id, nick):
	var item = load("res://demo/item_player_list.tscn").instantiate()
	item.get_node("Label").text = str(nick)
	item.list = [id,nick]
	$VBoxContainer.add_child(item)
	
