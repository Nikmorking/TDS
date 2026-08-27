extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.connect("end_dialog", show)
	if Global.mp_mode == "offline": $Lobby.queue_free()
	if multiplayer.is_server(): $Lobby.text = "Игроки ждут, когда вы нажмёте готово"
	pass # Replace with function body.



func _on_timer_timeout() -> void:
	$Label.text = "               O"
	pass # Replace with function body.



func change(named):
	$Label.hide()
	get_node(named).show()

func back():
	$Label.show()
	$Sprite2D.hide()
	$"2".hide()
	$"Разговор".hide()
	$"Лупа".hide()
	Global.nav_door.emit(null, false)
