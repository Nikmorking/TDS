extends Zaz
var zaper = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.




func _on_area_3d_area_entered(area: Area3D) -> void:
	$Chubaka.queue_free()
	$FogVolume.show()
	pass # Replace with function body.


func _on_area_3d_body_entered(body):
	body.position = $Marker3D.position
	get_tree().change_scene_to_file("res://scenes/AZC.tscn")
	print("good")
	pass # Replace with function body.


func _on_area_entered(body):
	print(get_node("Chubaka"))
	if !zaper:
		$Chubaka/AudioStreamPlayer3D.play()
		get_node("Chubaka/Timer").start()
		$Node3D/Door/AnimationPlayer.play("close door")
		$Node3D/Door.need_door = false
		zaper = true
	pass # Replace with function body.
