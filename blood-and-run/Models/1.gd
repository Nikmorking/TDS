extends RigidBody3D # Или KinematicBody/CharacterBody3D

class_name Stakanchiki
@export var named:String
var play = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	if $RayCast3D.is_colliding():
		if play:
			$Bonk.play()
			play = false
			if $Timer:
				$Timer.start()
	else: play = true


func _on_timer_timeout():
	$Bonk.stop()
	pass # Replace with function body.
