extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Escape"):
		if !$CharacterBody3D.isOnMenu:
			$CharacterBody3D.isOnMenu = true
			#$CharacterBody3D.velocity = Vector3(0, 0, 0)
			$CanvasLayer.show()
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			$CharacterBody3D.isOnMenu = false
			$CanvasLayer.hide()
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass
