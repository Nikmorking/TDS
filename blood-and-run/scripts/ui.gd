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
		var path = str(Global.target).split('/')
		var node = get_tree().root.get_node(Global.target)
		if !Global.light_work and node.name == "schitok":
			if chin == 0:
				$TextureProgressBar.max_value = 100
			elif chin == 100:
				chin = 0
				$TextureProgressBar.hide()
				Global.light_off.rpc()
		elif node.name == "musorka3":
			if node.get_parent().kol_musor ==0: return
			if chin == 0:
				$"../game_ui/TextureProgressBar".max_value = 50
			elif chin == 50:
				print("affsafsfadfsfas")
				chin = 0
				$"../game_ui/TextureProgressBar".hide()
				if node.get_parent().kol_musor != 0:
					$"../руки".add_in_hand('paket')
					node.get_parent().pochin()
		$"../game_ui/TextureProgressBar".show()
		chin += 2
		$TextureProgressBar.value = chin
		pass # Replace with function body.

func off():
	chin = 0
	$TextureProgressBar.hide()
