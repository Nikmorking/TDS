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


var no = false
func change(named):
	$Label.hide()
	get_node(named).show()
	if named == "work" and !no:
		$"../руки".is_rem = true
		no = true
	else:
		no = false

func back():
	$Label.show()
	$Sprite2D.hide()
	$"2".hide()
	$"Разговор".hide()
	$"Лупа".hide()
	$work.hide()
	$"../руки".is_rem = false
	Global.nav_door.emit(null, false)


var chin = 0
func remont() -> void:
		if !Global.light_work and Global.target.name == "schitok":
			if chin == 0:
				$TextureProgressBar.max_value = 100
			elif chin == 100:
				chin = 0
				$TextureProgressBar.hide()
				Global.light_off.rpc()
		elif Global.target.name == "musorka2":
			if chin == 0:
				$"../game_ui/TextureProgressBar".max_value = 50
			elif chin == 50:
				chin = 0
				$"../game_ui/TextureProgressBar".hide()
				$"../руки".add_in_hand('paket')
				#Global.target.get_parent().pochin()
			print("affsafsfadfsfas")
		$"../game_ui/TextureProgressBar".show()
		chin += 2
		$TextureProgressBar.value = chin
		pass # Replace with function body.

func off():
	chin = 0
	$TextureProgressBar.hide()
