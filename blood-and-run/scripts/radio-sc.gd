extends CSGBox3D

var into = false
var frame = 0
var kol_stakan = 0
var pesna = "E"

# Called when the node enters the scene tree for the first time.

func _input(event):
	if Input.is_action_just_pressed("rush_e"):
		if into:
			if pesna == "":
					pesna = "Alan"
			_start()
	
	if Input.is_action_just_pressed("left"):
		if into and pesna != "Friend":
			pesna = "Friend"
			$AudioStreamPlayer3D.stream = load("res://sounds/friend.mp3")
			_start()
	
	if Input.is_action_just_pressed("right"):
		if into and pesna != "Alan":
			pesna = "Alan"
			$AudioStreamPlayer3D.stream = load("res://sounds/alan.mp3")
			_start()
		

var uche = true
func _start():
			if uche:
				uche = false
				Global.achivka("Достижение: \nМиломан")
				printerr("Буква: X")
			$E.hide()
			$Alan.hide()
			$Friend.hide()
			if !$AudioStreamPlayer3D.playing:
				$AudioStreamPlayer3D.play(frame)
				get_node(pesna).show()
			else:
				frame = $AudioStreamPlayer3D.get_playback_position()
				$AudioStreamPlayer3D.stop()
				$E.show()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#var marker: Node3D = Global.player.get_child(2)
	#if into:
		#if !$E.visible:
			#get_node(pesna).look_at(marker.global_position)
		#else:
			#$E.look_at(marker.global_position)
	pass



func _on_radio_body_entered(body):
	if body.name == "Player":
		$E.show()
		into = true
	pass # Replace with function body.


func _on_radio_body_exited(body):
	if body.name == "Player":
		$E.hide()
		$Alan.hide()
		$Friend.hide()
		into = false
	pass # Replace with function body.
