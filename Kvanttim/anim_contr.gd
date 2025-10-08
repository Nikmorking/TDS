extends Node3D

var anim: AnimationTree
var direct = Vector3()

# Called when the node enters the scene tree for the first time.
func _ready():
	anim = get_node("AnimationTree")
	pass # Replace with function body.
