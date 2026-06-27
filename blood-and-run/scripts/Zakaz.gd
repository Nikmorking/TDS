extends Time_manager
class_name Zakaz_manager

var zakaz_list = [
	[ "Cofe", "snack", "Zapravka"],
	["snack", "Zapravka"],
	["Zapravka"],
	[ "Cofe", "Stakan", "Zapravka"],
	[ "Cofe", "Stakan"]
]
var Check_boxes:Array
var zakaz:Array
var y_kassu = false

@rpc("any_peer", "call_local")
func vupoln(i:String):
	get_node("No_human/Good").play()
	var chexk: CheckBox = Check_boxes[zakaz.find(i)]
	chexk.button_pressed = true
	zakaz.remove_at(zakaz.find(i))

func prov_list(str:String):
			if Global.zp == 10:
				Global.achivka("Достижение: \nПочти Миллионник")
			$"Заправка/Table/CSGPolygon3D/SubViewport/Control/RichTextLabel".text = str + "\nСейчас ЗП "+str(Global.zp) + "р"
			for i in Check_boxes:
				i.hide()
			back()

func back():
	y_kassu = false
	if get_node("No_human"):
		$No_human.movement_target_position = $Markers/Marker3D.position
		$No_human.rotation_degrees = Vector3(0,90,0)
		$No_human.actor_setup()
	print("back")

func start_wait():
	$"Ожидание".wait_time =(zakaz.size() *(
				40-(k_event *5)
			)
		 	+randi_range(10,30)*(5-Global.fara_days)
		)/2
	$"Ожидание".start()

func next():
	if $No_human.movement_target_position == $Markers/Marker3D2.position:
		y_kassu = true
		$No_human.movement_target_position = $Markers/Marker3D3.position
		$No_human.rotation_degrees = Vector3(0,180,0)
		$No_human.actor_setup()
	pass # Replace with function body.

@rpc("any_peer", "call_local")
func zaprav():
	print(zakaz)
	print(zakaz.find("Zapravka") != -1)
	if zakaz.find("Zapravka") != -1:
		vupoln.rpc("Zapravka")
		print(zakaz)
		if 0 == zakaz.size():
			Global.zp += 1
			prov_list("+1р к ЗП")
