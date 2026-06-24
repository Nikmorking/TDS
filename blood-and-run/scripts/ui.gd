extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Global.mp_mode == "offline": $Lobby.queue_free()
	if multiplayer.is_server(): $Lobby.text = "Игроки ждут, когда вы нажмёте готово"
	pass # Replace with function body.



func _on_timer_timeout() -> void:
	$Label.text = "               O"
	pass # Replace with function body.
