extends Node

var player: Node3D

func _get_player():
	player = get_parent().get_node("Node3D/Player")
	pass
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
