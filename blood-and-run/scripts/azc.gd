extends Node3D

var nd = false
# Called when the node enters the scene tree for the first time.
func _ready():
	$No_human.mtp_list = $Markers.get_children()
	pass # Replace with function body.

func _input(event):
	if Input.is_action_just_pressed("ui_copy"):
		$No_human.position = $"Markers/Marker3D".position
		$Timer.start()
		_tovar_otdan(2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _tovar_otdan(number: int):
	var kasa = $"Заправка/Table/CSGPolygon3D2/SubViewport/Control/Control"
	var cheaks = kasa.get_children()
	cheaks[number].button_pressed = true
	pass


func next():
	$No_human.movement_target_position = $Markers/Marker3D3.position
	$No_human.rotation_degrees = Vector3(0,180,0)
	$No_human.actor_setup()
	pass # Replace with function body.


func _on_timer_timeout():
	nd = true
	$No_human.movement_target_position = $Markers/Marker3D2.position
	$No_human.actor_setup() 
	pass # Replace with function body.
