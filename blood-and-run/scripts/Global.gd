extends Node

var new = false
var mp_mode: String = ""
var player: Node3D
var isOnMenu = false
var fara_days = 1
var papa
var zp = 0
var is_load = false
var lela = true
var igra = false
var light_work = true
var mouse_sens = 0.3
var krest = false
var krest_pos:Vector3

signal bad
signal load
signal _light_off

@rpc("any_peer", "call_local")
func light_off():
	_light_off.emit()
	light_work = !light_work
	if Global.light_work:
		papa.c.volumetric_fog_emission = Color("4f1c5e")
		papa.rand = false
	else:
		papa.c.volumetric_fog_emission = Color(0.139, 0.0, 0.081, 1.0)

func _input(event):
	#if Input.is_action_just_pressed("ui_copy"):
		#save()
	#if Input.is_action_just_pressed("ui_paste"):
		#load_game()
	pass



func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	pass # Replace with function body.


func get_papa(col: float, sel: Node) -> Node:
	for i in col:
		sel = sel.get_parent()
	return sel


func esc():
	get_tree().paused = false
	isOnMenu = false

func achivka(pr:String):
	get_parent().get_node("Node3D/Player/Camera3D/Achivka/Label2").text = pr
	get_parent().get_node("Node3D/Player/Camera3D/Achivka/AnimationPlayer").play("Achivka")

var kasa
func save():
	var save_file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	kasa = papa.get_node("Заправка/Table/Касса")
	var node_data = [
		fara_days,"Vector3"+str(player.position),
		"Vector3"+str(player.rotation_degrees),
		zp, 
		kasa.get_var(),
		papa.k_event,
		papa.proshlo,
		papa.chas,
		papa.min
		]
		# JSON provides a static method to serialized JSON string.
	var json_string = JSON.stringify(node_data)
		# Store the save dictionary as a new line in the save file.
	save_file.store_line(json_string)
	
	pass

func load_game():
	print("loading")
	if not FileAccess.file_exists("user://savegame.save"):
		print("err")
		return # Error! We don't have a save to load.
	var save_file = FileAccess.open("user://savegame.save", FileAccess.READ)
	print(save_file.get_position(), save_file.get_length())
	while save_file.get_position() < save_file.get_length():
		print(save_file)
		var json_string = save_file.get_line()
		# Creates the helper class to interact with JSON.
		var json = JSON.new()

		# Check if there is any error while parsing the JSON string, skip in case of failure.
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue
		var node_data = json.data
		print(node_data)
		fara_days = int(node_data.get(0))
		player.position = str_to_var(node_data.get(1))
		player.rotation_degrees = str_to_var(node_data.get(2))
		zp = node_data.get(3)
		kasa = papa.get_node("Заправка/Table/Касса")
		kasa.load_var(node_data.get(4))
		papa.k_event = int(node_data.get(5))
		papa.proshlo = int(node_data.get(6))
		papa.chas = int(node_data.get(7))
		papa.min = int(node_data.get(8))
		load.emit()
	pass
	
