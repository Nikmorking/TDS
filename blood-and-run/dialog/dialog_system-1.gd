extends Control


const SPEECH_SCENE = preload("res://dialog/margin_container.tscn")
const CHOICE_SCENE = preload("res://dialog/panel_container_2.tscn")
var flags = {"videl": false, "zp_bad": false, "sovest": false, 
"bread": false, "Kolb": false, "cofe": false, "nothing": false, 
"oil_no": false, "oil": false}


@onready var history_container = $VBoxContainer / MarginContainer / ScrollContainer / VBoxContainer
@onready var choices_container = $VBoxContainer / VBoxContainer
var meta_data = {}


var dialogue_data: Dictionary = {}
var current_node_lines: Array = []
var current_line_index: int = 0

signal press

func _ready() -> void :
	load_dialogue_from_file("res://dialog/dialog-1.txt")


func parse_dialogue_text(text: String) -> void :
	dialogue_data.clear()
	var part = text.split("|")
	text = part[0]
	meta_data.assign(str_to_var(part[1]))
	var lines = text.split("\n")
	var current_title: String = ""

	for line in lines:
		var clean_line = line.strip_edges()
		if clean_line.is_empty() or clean_line.begins_with("#"):
			continue


		if clean_line.begins_with("~"):
			current_title = clean_line.trim_prefix("~").strip_edges()
			dialogue_data[current_title] = []
			continue
		if clean_line.begins_with("&"):
			clean_line = clean_line.replacen("&", "")
			var data = {
				"type": "function", 
				"name": clean_line, 
				"arg": ""
			}
			var parts = clean_line.split(":")
			if parts.size() != 1:
				data.set("name", parts[0])
				data.set("arg", parts[1])
			dialogue_data[current_title].append(data)
			continue

		if not current_title.is_empty():
			if clean_line.begins_with("-"):
				parse_choice(clean_line, current_title)
			elif ":" in clean_line:
				parse_speech(clean_line, current_title)

func parse_speech(line: String, title: String) -> void :
	var parts = line.split(":")
	var is_me = parts.get(2).to_int()
	if !is_me: is_me = 1
	var speed = parts.get(3).to_float()
	if !speed: speed = 0.05
	print(parts)
	dialogue_data[title].append({
		"type": "speech", 
		"character": parts[0].strip_edges(), 
		"text": parts[1].strip_edges(), 
		"is_me": is_me, 
		"speed": speed
	})

func parse_choice(line: String, title: String) -> void :
	var clean_line = line.trim_prefix("-").strip_edges()

	var parts = clean_line.split("=>", false, 1)
	var party = parts[0].split(":")
	var data: Dictionary = {
		"type": "choice", 
			"text": parts[0].strip_edges(), 
				"target": parts[1].strip_edges()
					}
	if party.size() > 1:
		parts[0] = party[0]
		var locky = party[1].to_int()
		if locky:
			data.get_or_add("locky", locky)
		if party.size() == 3:
			data.get_or_add("flag", party[2])
			data.set("text", party[0])
	dialogue_data[title].append(data)


func start_dialogue_node(node_name: String) -> void :
	if not dialogue_data.has(node_name):
		push_error("Метка диалога не найдена: " + node_name)
		return

	current_node_lines = dialogue_data[node_name]
	current_line_index = 0
	clear_choices()
	show_next_line()

func show_next_line() -> void :
	if current_line_index >= current_node_lines.size():
		return

	var current_data = current_node_lines[current_line_index]

	if current_data.get("type") == "speech":
		clear_choices()
		spawn_speech_box(current_data["character"], current_data["text"], 
		current_data["is_me"], current_data["speed"]
		)
		current_line_index += 1
		check_for_immediate_choices()

	elif current_data["type"] == "choice":
		spawn_choice_buttons()
	elif current_data["type"] == "function":
		if current_data["arg"] == "":
			call(current_data["name"])
		else:
			call(current_data["name"], current_data["arg"])
		pass


func end(arg: String):
	#spawn_speech_box("я", meta_data.get(arg), 0, 0.5)
	await press
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	posledniy_dialog = "start"
	hide()
	Global.end_dialog.emit()
	await get_tree().create_timer(0.1).timeout
	Global.isOnMenu = false
	#$VBoxContainer.hide()
	#$CenterContainer.show()


func check_for_immediate_choices() -> void :
	if current_line_index < current_node_lines.size():
		if current_node_lines[current_line_index]["type"] == "choice":
			spawn_choice_buttons()


func spawn_speech_box(char_name: String, char_text: String, is_me: int, speed: float
) -> void :
	var speech_instance: MarginContainer = SPEECH_SCENE.instantiate()
	history_container.add_child(speech_instance)


	var name_label = speech_instance.get_node("PanelContainer/Margin/VBoxContainer/Label2")
	var text_label = speech_instance.get_node("PanelContainer/Margin/VBoxContainer/Label")

	name_label.text = char_name
	text_label.text = char_text
	print(char_text)

	$VBoxContainer / PanelContainer2 / Margin / VBoxContainer / Label._tween(char_text, (1 - speed) * 0.1)
	$VBoxContainer / PanelContainer2 / Margin / VBoxContainer / Label2.text = char_name
	if is_me == 0:
		speech_instance.add_theme_constant_override("margin_left", 200)
	else:
		speech_instance.add_theme_constant_override("margin_right", 100)



	await get_tree().process_frame
	var scroll_container = history_container.get_parent()
	if scroll_container is ScrollContainer:
		scroll_container.scroll_vertical = int(history_container.size.y)


func spawn_choice_buttons() -> void :
	clear_choices()
	pass

	while current_line_index < current_node_lines.size() and current_node_lines[current_line_index].get("type") == "choice":
		var choice_data: Dictionary = current_node_lines[current_line_index]
		if choice_data.has("locky"):
			if choice_data["locky"] < randi_range(0, 99):
				current_line_index += 1
				continue

		var choice_instance = CHOICE_SCENE.instantiate()
		choices_container.add_child(choice_instance)


		var choice_label = choice_instance.get_node("pan/Label")
		choice_label.text = " > " + choice_data["text"]
		var data = choice_data.has("flag")

		if data:
			if choice_data["flag"].replace(" ", "") != "true" and choice_data["flag"] != "":
				if !flags[choice_data["flag"].replace(" ", "")]:
					choice_label.text = "locked"
		if choice_label.text != "locked": 
			choice_instance.get_node("Button").button_down.connect(_on_choice_selected.bind(choice_data["target"], choice_data["text"]))
			

		current_line_index += 1


func _on_choice_selected(target_node: String, text) -> void :
	spawn_speech_box("Игрок", text, 0, 0.05)
	posledniy_dialog = target_node
	start_dialogue_node(target_node)

func clear_choices() -> void :
	for child in choices_container.get_children():
		child.queue_free()


func _input(event: InputEvent) -> void :
	if event.is_action_pressed("ui_accept") or (event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT):
		var has_choices = false
		press.emit()
		for child in choices_container.get_children():
			if child.name.begins_with("PanelContainer"):
				has_choices = true
				break

		if not has_choices:
			show_next_line()


func load_dialogue_from_file(file_path: String) -> void :
	if FileAccess.file_exists(file_path):
		var file = FileAccess.open(file_path, FileAccess.READ)
		var content = file.get_as_text()
		parse_dialogue_text(content)


func _on_return_button_down() -> void :
	get_tree().reload_current_scene()
	pass


func _on_exit_button_down() -> void :
	get_tree().quit()
	pass


func _on_button_button_down():
	for i in flags:
		flags.set(i, true)
	pass


var posledniy_dialog = "start"
func start_dialogue():
	$"../game_ui".hide()
	show()
	Global.isOnMenu = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	start_dialogue_node(posledniy_dialog)
	
