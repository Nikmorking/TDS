extends Control

var player: Node3D
var isOnMenu = false

func get_player():
	player = get_parent().get_node("Node3D/Player")
	pass
# Called when the node enters the scene tree for the first time.
func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
