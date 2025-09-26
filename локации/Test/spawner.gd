extends Node2D

# Called when the node enters the scene tree for the first time.
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("e"):
		load("res://Враги/Воин/Воин.tscn").instantiate()
		var voin = load("res://Враги/Воин/Воин.tscn").instantiate()
		add_child(voin)
		voin.position = $Marker2D.position


func tawer1() -> void:
	var q = load("res://tower/tawer_1.tscn").instantiate()
	q.position = $Button.position
	add_child(q) 
	pass # Replace with function body.
