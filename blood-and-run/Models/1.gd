extends RigidBody3D # Или KinematicBody/CharacterBody3D

class_name Stakanchiki
@export var named:String
var play = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _on_timer_timeout():
	$Bonk.stop()
	pass # Replace with function body.


func _on_area_3d_body_entered(body):
	if play:
		$Bonk.play()
		play = false
		if $Timer:
			$Timer.start()
	pass # Replace with function body.


func _on_area_3d_body_exited(body):
	play = true
	pass # Replace with function body.
