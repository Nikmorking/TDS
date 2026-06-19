extends Zakaz_manager
class_name Target_manager

var nd = false
var norm = true
var no_hum: CharacterBody3D
@onready var c:Environment = $WorldEnvironment.environment

func _run_pl():
			if Global.krest:
				$emeny.navigation_agent.path_desired_distance = 1.5
				$emeny.navigation_agent.target_desired_distance = 1.5
				$emeny.movement_target_position = Global.player.get_node("Camera3D/руки").obj.get_node("Marker").global_position
			else:
				$emeny.movement_target_position = Global.player.global_position
			$emeny.actor_setup()
			$emeny.start = true
			$emeny/Timer.start()

func _start_sream():
		Global.bad.emit()
		if norm:
			c.volumetric_fog_emission = Color(0.299, 0.301, 0.289, 1.0)
			c.volumetric_fog_density = 0.03
			$emeny.position = $Marker3D.position
			_run_pl()
			norm = false
			$Timer2.wait_time = randi_range(42,62)
			$Timer2.start()
		else:
			c.volumetric_fog_emission = Color("4f1c5e")
			c.volumetric_fog_density = 0.05
			$emeny.start = false
			$emeny.get_node("Timer").stop()
			$emeny.position = Vector3(10000, 100000,100000) 
			$emeny.movement_target_position = $emeny.position
			norm = true

func _on_emeny_body_entered(node):
	if node.name == "Player":
		printerr("Буква: O")
		Global.papa.die("Съели")
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

func _pripersa():
	$"driving in my car".n = 5
	$"driving in my car".i -= 1
	$"driving in my car".rotate_y(-1.57)
	$"driving in my car".start = true




func _stop_run():
	_start_sream()
	rand = false
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

func _pridi():
	if Global.fara_days == 1:
		zakaz = zakaz_list[randi_range(0, 4)]
	else:
		zakaz = zakaz_list[randi_range(0,20)]
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

@rpc("any_peer", "call_local")
func destroy_col(col):
	print(col)
	$"Расходники".get_node(str(col)).queue_free()
