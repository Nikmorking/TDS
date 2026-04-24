extends Control

var player: Node3D
var isOnMenu = false

func get_player():
	player = get_parent().get_node("Node3D/Player")
	pass
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _continue():
			isOnMenu = false
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			get_tree().paused = false
			player.get_node("Camera3D/Control").show()
			player.get_node("Camera3D/Menu").hide()

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Escape"):
		if !isOnMenu:
			isOnMenu = true
			#$CharacterBody3D.velocity = Vector3(0, 0, 0)
			get_player()
			player.get_node("Camera3D/Control").hide()
			player.get_node("Camera3D/Menu").show()
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			get_tree().paused = true
		else:
			isOnMenu = false
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			get_tree().paused = false
