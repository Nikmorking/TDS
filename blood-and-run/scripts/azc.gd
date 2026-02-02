extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if Input.is_action_just_pressed("ui_copy"):
		_tovar_otdan(2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _tovar_otdan(number: int):
	var kasa = get_node("Заправка/Касса/CSGPolygon3D2/SubViewport/Control/Control")
	var cheaks = kasa.get_children()
	cheaks[number].button_pressed = true
	pass


func cofe_gotovo():
	pass # Replace with function body.
