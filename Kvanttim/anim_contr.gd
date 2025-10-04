extends Node3D

var stop = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_animation_player_animation_changed(old_name, new_name):
	if stop:
		$AnimationPlayer.stop()
	pass # Replace with function body.
