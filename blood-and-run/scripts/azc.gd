extends Node3D

var start_day = true
var zakaz:Array
var zakaz_list = [
  ["ahabka_buttonov", "Stakan_cofe"],
  [ "Cofe", "snack"],
  ["Stakan_cofe", "snack"],
  ["ahabka_buttonov", "snack"],
  ["Stakan_cofe"],
  ["Cofe", "snack"],
  [ "ahabka_buttonov"],
  ["ahabka_buttonov", "Stakan_cofe", "snack"],
  ["Cofe", "Stakan_cofe"],
  [ "ahabka_buttonov", "Stakan_cofe", "snack"]
]
var nd = false
var y_kassu = false
var norm = true
var no_hum: CharacterBody3D

var Check_boxes:Array
# Called when the node enters the scene tree for the first time.
func _ready():
	Check_boxes = $"Заправка/Table/CSGPolygon3D2/SubViewport/Control/Control".get_children()
	print(Check_boxes)
	pass # Replace with function body.

func _input(event):
	if Input.is_action_just_pressed("ui_copy"):
		_start_sream()
		$Timer2.start()
	if Input.is_action_just_pressed("ui_cut"):
		#_start_sream()
		$"driving in my car"._start()
		

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

func _start_sream():
		var c:Environment = $WorldEnvironment.environment
		if norm:
			c.volumetric_fog_emission = Color(0.295, 0.0, 0.0, 1.0)
			$emeny.start = true
			$emeny.actor_setup()
			$emeny.get_node("Timer").start()
			$emeny.position = $Marker3D.position
			norm = false
		else:
			c.volumetric_fog_emission = Color("4f1c5e")
			$emeny.start = false
			$emeny.get_node("Timer").stop()
			$emeny.position = Vector3(10000, 100000,100000) 
			$emeny.movement_target_position = $emeny.position
			norm = true

func _pridi():
	zakaz = zakaz_list[randi_range(0, 9)]
	for i in Check_boxes:
		i.button_pressed = false
	for i in zakaz.size():
		Check_boxes[i].show()
	add_child(load("res://scenes/no_human.tscn").instantiate())
	$No_human.connect("body_entered", _on_no_human_body_entered)
	$No_human.mtp_list = $Markers.get_children()
	$No_human.position = $"Markers/Marker3D".position 
	nd = true
	$No_human.movement_target_position = $Markers/Marker3D2.position
	$No_human.actor_setup() 
	print(zakaz)
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
		if 0 == zakaz.size(): 
			$"Заправка/Table/CSGPolygon3D2/SubViewport/Control/RichTextLabel".text = ""
			for i in Check_boxes:
				i.hide()
			back()
	pass # Replace with function body.


func _on_timer_timeout() -> void:
	var b = randi_range(0, 100)
	print(b)
	if b < 70:
		$"driving in my car"._start()
	else: 
		_start_sream()
		$Timer2.start()
	pass # Replace with function body.


func _on_emeny_body_entered(node):
	if node.name == "Player":
		print("Здох")
		$Player/Camera3D/Control/Sprite2D.show()
		$Be.play()
		get_tree().paused = true
	pass # Replace with function body.


func _on_door_2__open():
	if start_day:
		$Timer.start()
		start_day = false
	pass # Replace with function body.


func _stop_run():
	_start_sream()
	$Timer.start()
	pass # Replace with function body.


func _on_driving_in_my_car_end_put():	
	print(str($"driving in my car".n) + "hjhj")
	if $"driving in my car".n != 5:
		_pridi()
	else:
		print("llllaaaa")
		$"driving in my car".position = $Markers/Marker3D5.position
		$"driving in my car".i = 0
		$"driving in my car".n = 2
		$Timer.start()
	pass # Replace with function body.

func _pripersa():
	$"driving in my car".n = 5
	$"driving in my car".i -= 1
	$"driving in my car".rotate_y(1.57)
	$"driving in my car".start = true
