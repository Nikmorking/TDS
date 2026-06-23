extends StaticBody3D

signal _player_in
signal _player_out
signal _open

@export var rot = 0
@export var door_open = true
@export var start_rot = Vector3()

var need_door = false
var k_otk = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rot = 0
	pass # Replace with function body.

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("rush_e") and Global.lobby_ready:
		if need_door and !Global.player.get_node("Camera3D/руки").obj:
			print("door")
			k_otk += 1
			if k_otk ==62:
				Global.achivka("Достижение: \n Открыть 62 раза \n (нет 67 в этой игре)")
				Global.papa._67()
				printerr("Буква: B")
			if door_open:
				$AnimationPlayer.play("close door")
				$Open.play()
				$Timer.start()
			else:
				print("open")
				$AnimationPlayer.play("close_door")
				$Key.play()
				$Timer.start()
				$Timer2.start()
			door_open = !door_open
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	rotation_degrees = start_rot + Vector3(0, rot, 0)
	pass




func Next_to_door(body: Node3D) -> void:
	if body.get_parent().name == "cont_players":
		_player_in.emit()
		print()
		need_door = true
	pass # Replace with function body.


func come_back(body: Node3D) -> void:
	if body.get_parent().name == "cont_players":
		need_door = false
		_player_out.emit()
	pass # Replace with function body.


func _on_timer_2_timeout():
	print("open3")
	_open.emit()
	pass # Replace with function body.
