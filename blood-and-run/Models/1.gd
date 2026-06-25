extends RigidBody3D # Или KinematicBody/CharacterBody3D

class_name Stakanchiki
@export var named:String
var play = true


func _ready():
	if !Global.krest_pos:
		Global.krest_pos = position

func _on_timer_timeout():
	$Bonk.stop()
	pass # Replace with function body.


func _on_area_3d_body_entered(body):
	if play:
		$Bonk.play()
		play = false
		if has_node("Timer"):
			$Timer.start()
	pass # Replace with function body.


func _on_area_3d_body_exited(body):
	play = true
	pass # Replace with function body.


func _on_time_timeout():
	$Area3D/Coll.disabled = true
	position = Global.krest_pos
	pass # Replace with function body.
