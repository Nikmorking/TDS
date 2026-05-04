extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.



func _on_continue_button_down() -> void:
	cont()
	print("halihopler")
	pass # Replace with function body.


func _input(event: InputEvent) -> void:
	if Input.is_action_just_released("Escape"):
		if !Global.isOnMenu:
			Global.isOnMenu = true
			$Open.play()
			#$CharacterBody3D.velocity = Vector3(0, 0, 0)
			get_parent().get_node("Control").hide()
			show()
			get_node("AnimationPlayer").play("Open")
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			get_tree().paused = true
		else:
			cont()


	if Input.is_action_just_pressed("ui_open"):
		$AnimationPlayer.play("RESET")

func cont():
			Global.isOnMenu = false
			$Close.play()
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			get_tree().paused = false
			get_parent().get_node("Control").show()
			hide()

func _on_quit_button_down() -> void:
	get_tree().quit()
	pass # Replace with function body.



func focus_entered():
	if visible:
		$Nakodka.play()
	pass # Replace with function body.


func _on_animation_player_animation_finished(anim_name):
	$continue.grab_focus.call_deferred()
	pass # Replace with function body.
