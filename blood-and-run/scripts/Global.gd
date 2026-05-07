extends Control

var player: Node3D
var isOnMenu = false
var fara_days = 1
@onready var papa = get_tree().root.get_node("Node3D")

func get_player():
	player = get_parent().get_node("Node3D/Player")
	pass
# Called when the node enters the scene tree for the first time.
func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	pass # Replace with function body.

func get_papa(col: float, sel: Node) -> Node:
	for i in col:
		sel = sel.get_parent()
	return sel

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func achivka(pr:String):
	get_parent().get_node("Node3D/Player/Camera3D/Control3/Label2").text = pr
	get_parent().get_node("Node3D/Player/Camera3D/Control3/AnimationPlayer").play("Achivka")
