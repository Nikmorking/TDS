extends StaticBody3D

@export var rot = 0
@export var door_open = true

var need_door = false
@export var start_rot = Vector3()
var player


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rot = 0
	pass # Replace with function body.

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_open"):
		if need_door:
			print("door")
			if door_open:
				$AnimationPlayer.play("close door")
				$Open.play()
				$Timer.start()
			else:
				$AnimationPlayer.play("close_door")
				$Key.play()
				$Timer.start()
			door_open = !door_open
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	rotation_degrees = start_rot + Vector3(0, rot, 0)
	pass




func Next_to_door(body: Node3D) -> void:
	if body.name == "Player":
		need_door = true
	pass # Replace with function body.


func come_back(body: Node3D) -> void:
	if body.name == "Player":
		need_door = false
	pass # Replace with function body.
