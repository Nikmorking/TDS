extends Node3D

var zakaz:Array
var zakaz_list = [["Cofe", "Cofe"], ["ahabka_buttonov", "Cofe"], ["Stakan_s_cofe", "snack"], ["snack"]]
var nd = false
var y_kassu = false

var Check_boxes:Array
# Called when the node enters the scene tree for the first time.
func _ready():
	Check_boxes = $"Заправка/Table/CSGPolygon3D2/SubViewport/Control/Control".get_children()
	zakaz = zakaz_list[randi_range(0, 3)]
	print(Check_boxes)
	pass # Replace with function body.

func _input(event):
	if Input.is_action_just_pressed("ui_copy"):
		_pridi()

# Called every frame. 'delta' is the e		if Check_boxes[]lapsed time since the previous frame.
func _process(delta):
	pass


func next():
	if $No_human.movement_target_position == $Markers/Marker3D2.position:
		y_kassu = true
		$No_human.movement_target_position = $Markers/Marker3D3.position
		$No_human.rotation_degrees = Vector3(0,180,0)
		$No_human.actor_setup()
	pass # Replace with function body.

func back():
	y_kassu = false
	$No_human.movement_target_position = $Markers/Marker3D.position
	$No_human.rotation_degrees = Vector3(0,90,0)
	$No_human.actor_setup()
	print("back")


func _pridi():
	for i in Check_boxes:
		i.button_pressed = false
	add_child(load("res://scenes/no_human.tscn").instantiate())
	$No_human.connect("body_entered", _on_no_human_body_entered)
	$No_human.mtp_list = $Markers.get_children()
	$No_human.position = $"Markers/Marker3D".position 
	nd = true
	$No_human.movement_target_position = $Markers/Marker3D2.position
	$No_human.actor_setup() 
	for i in zakaz.size():
		Check_boxes[i].show()
	$"Заправка/Table/CSGPolygon3D2/SubViewport/Control/RichTextLabel".text = ""
	for i in zakaz:
		$"Заправка/Table/CSGPolygon3D2/SubViewport/Control/RichTextLabel".text += "* "
		if i == "ahabka_buttonov": 
			$"Заправка/Table/CSGPolygon3D2/SubViewport/Control/RichTextLabel".text += "Hleb"
		else:
			$"Заправка/Table/CSGPolygon3D2/SubViewport/Control/RichTextLabel".text += i
		$"Заправка/Table/CSGPolygon3D2/SubViewport/Control/RichTextLabel".text += "[br]"
	pass # Replace with function body.

func _on_no_human_body_entered(body: Node):
	if y_kassu:
		for i in zakaz:
			if i == body.named:
				var chexk:CheckBox = Check_boxes[zakaz.find(i)]
				chexk.button_pressed = true
				zakaz.remove_at(zakaz.find(i))
				body.queue_free()
		if 0 == zakaz.size(): back()
	pass # Replace with function body.


func _on_timer_timeout() -> void:
	if randi_range(0, 100) < 30:
		_pridi()
	else: $Timer.start()
	pass # Replace with function body.
