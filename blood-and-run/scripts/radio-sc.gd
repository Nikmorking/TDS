extends CSGBox3D

var into = false

var kol_stakan = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.get_player()
	pass # Replace with function body.

func _input(event):
	if Input.is_action_just_pressed("ui_open"):
		if into:
			if !$AudioStreamPlayer3D.playing:
				$AudioStreamPlayer3D.play()
			else:
				$AudioStreamPlayer3D.stop()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var marker: Node3D = Global.player.get_child(2)
	if into:
		$Sprite3D.look_at(marker.global_position)
	pass



func _on_radio_body_entered(body):
	if body.name == "Player":
		$Sprite3D.show()
		into = true
	pass # Replace with function body.


func _on_radio_body_exited(body):
	if body.name == "Player":
		$Sprite3D.hide()
		into = false
	pass # Replace with function body.
