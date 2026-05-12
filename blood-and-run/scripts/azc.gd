extends Node3D
class_name Zaz

var rand = true
var start_day = true
var zakaz:Array
var zakaz_list = [
  ["ahabka_buttonov", "Stakan_cofe","Zapravka"],
  [ "Cofe", "snack", "Zapravka"],
  ["Stakan_cofe", "snack","Zapravka"],
  ["ahabka_buttonov", "snack"],
  ["Stakan_cofe", "Zapravka"],
  ["Cofe", "snack", "Zapravka"],
  [ "ahabka_buttonov", "Zapravka"],
  ["ahabka_buttonov", "Stakan_cofe", "snack"],
  ["Cofe", "Stakan_cofe", "Zapravka"],
  [ "ahabka_buttonov", "Stakan_cofe", "snack", "Zapravka"]
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
	Global.get_player()
	print(Global.is_load)
	if Global.is_load:
		Global.load_game()
	$Player/Camera3D/Menu.hide()
	Global.is_load = false
	pass # Replace with function body.

func _input(event):
	#if Input.is_action_just_pressed("ui_copy"):
		#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		#_start_sream()
		#$Timer2.start()
	#if Input.is_action_just_pressed("ui_cut"):
		#_start_sream()
		#$"driving in my car"._start()
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
	if get_node("No_human"):
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

func start_wait():
	$"Ожидание".wait_time = zakaz.size() *(35-k_event*5) + +randi_range(10,20)
	$"Ожидание".start()

func _pridi():
	zakaz = zakaz_list[randi_range(0, 9)]
	for i in Check_boxes:
		i.button_pressed = false
	for i in zakaz.size():
		Check_boxes[i].show()
	start_wait()
	add_child(load("res://scenes/no_human.tscn").instantiate())
	$"Заправка/Table/CSGPolygon3D2/SubViewport/Control/RichTextLabel".text = ""
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
				vupoln(i)
				body.queue_free()
		if 0 == zakaz.size():
			Global.zp += 1
			prov_list("+1р к ЗП")
	pass # Replace with function body.

func vupoln(i:String):
	get_node("No_human/Good").play()
	var chexk: CheckBox = Check_boxes[zakaz.find(i)]
	chexk.button_pressed = true
	zakaz.remove_at(zakaz.find(i))

func zaprav():
	print(zakaz)
	print(zakaz.find("Zapravka") != -1)
	if zakaz.find("Zapravka") != -1:
		vupoln("Zapravka")
		print(zakaz)
		if 0 == zakaz.size():
			Global.zp += 1
			prov_list("+1р к ЗП")

func prov_list(str:String):
			if Global.zp == 10:
				Global.achivka("Достижение: \nПочти Миллионник")
			$"Заправка/Table/CSGPolygon3D2/SubViewport/Control/RichTextLabel".text = str + "\nСейчас ЗП "+str(Global.zp) + "р"
			for i in Check_boxes:
				i.hide()
			back()


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
		_start_sream()
		printerr("Буква: O")
		die("Съели")
	pass # Replace with function body.


func _on_door_2__open():
	if start_day:
		rand = false
		start_day = false
	pass # Replace with function body.


func _stop_run():
	_start_sream()
	rand = false
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
		rand = false
	pass # Replace with function body.

func _pripersa():
	$"driving in my car".n = 5
	$"driving in my car".i -= 1
	$"driving in my car".rotate_y(1.57)
	$"driving in my car".start = true



var time_left = false
var energy = 0
@export var min_a = -5
@export var max_a = 5
var k_event = 0
var proshlo = 0
@export var end_day = 6000 # 5 minuts

func _on_tick_timeout():
	if time_left:
			Global.zp -= 1
			prov_list("-1р к ЗП")
			time_left = false
			if Global.zp == -10:
				Global.achivka("Достижение: \nБомж")
	if !rand:
		proshlo +=1
		print(proshlo)
		print(energy)
		if proshlo == 400:
			energy += 100 # *Zp
		if proshlo == end_day:
			rand = false
			_end_day()
			return
		energy += 13
		energy += randi_range(min_a,max_a)
		if energy > 1700:
			k_event +=1
			energy = 0
			var b = randi_range(-6,1)
			if b != 0:
				$"driving in my car"._start()
			else:
				_start_sream()
				$Timer2.wait_time = randi_range(15,20)
				$Timer2.start()
			rand = true
	pass # Replace with function body.

func die(prichina: String):
	print(prichina)
	if prichina == "Задавлен":
		$Player/Camera3D/Control3/AnimationPlayer.speed_scale = 4
		Global.achivka("                      Задавлен")
		printerr("Буква: Z")
	$Player/Camera3D/Control/Sprite2D.show()
	$Be.play()


func _on_be_finished():
	get_tree().reload_current_scene()
	pass # Replace with function body.

func _end_day():
	Global.fara_days += 1
	Global.save()
	$Player/Camera3D/Control2/Label1.text = str(Global.fara_days)
	$Player/Camera3D/AnimationPlayer.play("End_day")
	start_day = true
	rand = true
	proshlo = 0
	energy = 0
	get_tree().paused = true

func _on_ожидание_timeout():
	time_left = true
	pass # Replace with function body.

func _67():
	pass
