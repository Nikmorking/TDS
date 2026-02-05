extends Node3D

var zakaz:Array
var zakaz_list = [["Cofe", "Cofe"], ["ahabka_buttonov", "cofe"]]
var nd = false

var Check_boxes:Array
# Called when the node enters the scene tree for the first time.
func _ready():
	$No_human.mtp_list = $Markers.get_children()
	Check_boxes = $"Заправка/Table/CSGPolygon3D2/SubViewport/Control/Control".get_children()
	zakaz = zakaz_list[1]
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
	for i in zakaz.size():
		Check_boxes[i].show()
	pass # Replace with function body.


func _on_no_human_body_entered(body: Node):
	for i in zakaz:
		if i == body.named:
			var chexk:CheckBox = Check_boxes[zakaz.find(i)]
			chexk.button_pressed = true
			zakaz.remove_at(zakaz.find(i))
			body.queue_free()
	pass # Replace with function body.
