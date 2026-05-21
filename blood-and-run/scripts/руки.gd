extends Node3D

@onready var hand_marker = $SpringArm3D/Hand

var stakanchiki = load("res://Расходники/1.tscn")
var cofe = load("res://Расходники/cofe.tscn")
var stakan = load("res://Расходники/Stakan.tscn")
var stakan_s_cofe = load("res://Расходники/Stakan_s_cofe.tscn")
var ahabka_buttonov = load("res://Расходники/ahabka_buttonov.tscn")
var button = load("res://Models/button/source/poly.glb")
var pachka_snackov = load("res://Расходники/pachka_snackov.tscn")
var snack = load("res://Расходники/snack.tscn")
var zp = false
var zp_in = false
var points: Array 
var col_rashod = 15
var posled_naklon
var papa: Node3D

#var obj: RigidBody3D
var obj: Node3D
var kol = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	papa = get_parent()
	posled_naklon = papa.rotation_degrees.x
	pass # Replace with function body.

var chin = 0
var aim = false
var pr = false
func _on_timer_3_timeout() -> void:
		if is_rem and pr and !Global.light_work and !obj:
			$"../Control/TextureProgressBar".show()
			chin += 2
			$"../Control/TextureProgressBar".value = chin
			if chin == 100:
				chin = 0
				$"../Control/TextureProgressBar".hide()
				Global.light_off()
		else:
			chin = 0
			$"../Control/TextureProgressBar".hide()
		pass # Replace with function body.

func _input(event):
	if Input.is_action_just_released("ui_open"):
		pr = false
	if Input.is_action_just_pressed("ui_open"):
		print("click")
		pr = true
		if obj:
			_stavit_rashodnic()
		else: 
			if $RayCast3D.is_colliding():
				_colling()
	if Input.is_action_just_pressed("+"):
		if $SpringArm3D.spring_length < 2.5:
			$SpringArm3D.spring_length += 0.1
	if Input.is_action_just_pressed("-"):
		if $SpringArm3D.spring_length > 1:
			$SpringArm3D.spring_length -= 0.1
	if Input.is_action_just_pressed("eat"):
		eat()
			
var tea = 0
func eat():
		var chi = get_node("SpringArm3D/Hand").get_child(0)
		print(chi)
		if !aim and chi != null:
			print(chi.named)
			if chi.named == "Stakan_cofe" or chi.named == "snack":
				aim = true
				$SpringArm3D/AnimationPlayer.play("В ротик")
				if chi.named == "Stakan_cofe":
					tea += 1
					if tea == 5:
						Global.achivka("Достижение:\nКофеман\nВыпить 15 чашек кофе")

func instance_na(name: String) -> Object:
	var ret_obj
	if name == "Со стаканами" or name == "Stakanchiki":
		ret_obj = stakanchiki.instantiate()
	if name == "С кофе" or name == "Cofe":
		ret_obj = cofe.instantiate()
	if name == "Stakan":
		ret_obj = stakan.instantiate()
	if name == "Stakan_cofe":
		ret_obj = stakan_s_cofe.instantiate()
	if name == "batonovo" or name == "ahabka_buttonov":
		ret_obj = ahabka_buttonov.instantiate()
	if name == "button":
		ret_obj = button.instantiate()
	if name == "pachka_snackov" or name == "с снеками":
		ret_obj = pachka_snackov.instantiate()
	if name == "snack":
		ret_obj = snack.instantiate()
	return ret_obj

func add_to_hand(name: String):
	print(name)
	obj = instance_na(name)
	if obj:
		obj.freeze = true
		obj.position = Vector3.ZERO
		obj.name = obj.name + str(kol)
		hand_marker.add_child(obj)
		kol += 1
		print(obj.get_class())
	pass

func _process(delta):
	if zp:
		points.set(1, global_position)
	pass
var rashodnik: Node3D
func _stavit_rashodnic():
			if aim:
				$SpringArm3D/AnimationPlayer.play("RESET")
			rashodnik = instance_na(obj.named)
			rashodnik.position = obj.global_position 
			if rashodnik.named == "snack":
				rashodnik.scale = Vector3(0.5, 0.7,0.5)
			rashodnik.freeze = false
			rashodnik.gravity_scale = 1.4
			for i in hand_marker.get_children():
				if i.is_class("RigidBody3D"):
					i.queue_free()
			var coll: CollisionShape3D = rashodnik.get_node("Coll")
			coll.disabled = false
			$Timer.start()

func fnc_zp():
	if zp_in:
		if $RayCast3D.get_collider().name == "ZP1":
			points = $"../../../LineRenderer3D".points
			$RayCast3D.get_collider().get_parent().get_node("AudioStreamPlayer3D").play()
		if $RayCast3D.get_collider().name == "ZP2":
			points = $"../../../LineRenderer3D2".points
			$RayCast3D.get_collider().get_parent().get_node("AudioStreamPlayer3D").play()
		if $RayCast3D.get_collider().name == "ZP3":
			points = $"../../../LineRenderer3D3".points
			$RayCast3D.get_collider().get_parent().get_node("AudioStreamPlayer3D").play()
		if $RayCast3D.get_collider().name == "ZP4":
			points = $"../../../LineRenderer3D4".points
			$RayCast3D.get_collider().get_parent().get_node("AudioStreamPlayer3D").play()
		if !zp:
			zp = true
		else:
			points.set(1, points.get(0))
			zp = false
	pass


func _on_area_3d_area_entered(area: Area3D) -> void:
	print("dadf")
	zp_in = true
	pass # Replace with function body.


func _on_area_3d_area_exited(area: Area3D) -> void:
	points.set(1, points.get(0))
	zp = false
	zp_in = false
	pass # Replace with function body.

var kalendar = 0
var is_rem = false
func _colling():
				is_rem = false
				var col: Node3D = $RayCast3D.get_collider()
				print("coll", col.name)
				if col.is_class("Area3D"):
					print(col.name)
					var kasa = col.get_parent()
					if col.name == "Stakan":
						if kasa.kol_stakan > 0:
							add_to_hand("Stakan")
							kasa.vzat_stakan()
					elif col.name == "Календарь":
						kalendar += 1
						if kalendar == 6:
							if Global.fara_days == 3:
								Global.achivka("Достижение: \n С 3 сентября!")
								printerr("Буква: U")
							col.get_node("Aud").play()
							kalendar = 0
					elif col.name == "Бак" and zp:
						col.get_node("Au").play()
						Global.get_papa(3, self).zaprav()
						print(Global.get_papa(3, self), "zzz")
					elif col.name == "Cofe_machine":
						if kasa.cofe > 0:
							if kasa.stakan:
								kasa.sel("Варка")
								kasa.get_node("Cofe_machine/AudioStreamPlayer3D").play()
							else:
								kasa.sel("нет стакана")
						else:
							kasa.sel("Нет кофе")
						if kasa.cofe_gotova:
							kasa.cofe_gotova = false
							add_to_hand("Stakan_cofe")
							kasa.sel(str(kasa.cofe)+"/10")
					elif col.name == "Снеки":
						if kasa.snacks > 0:
							add_to_hand("snack")
							kasa.snacks -= 1
							kasa.set_snack()
					elif col.name == "schitok":
						$"../../../Timer3".start()
						is_rem = true
				elif col.is_class("RigidBody3D"):
					add_to_hand(col.named)
					if col.get_parent().name == "Расходники":
						col.queue_free()
				elif $"../../../Расходники".get_children().size() < col_rashod:
					add_to_hand(col.name)
					print(col.get_parent())
					if Global.get_papa(2, col).name == "Ящики":
						col.get_parent().get_node("AudioStreamPlayer3D").play()
				else:
					$"../.."._print_in_ui("               O \n \n ты утилизируй шнягу")
					print("Продай что нибудь ненужное! Но чтобы продать что то ненужное,сначало нужно купить что-то ненужное, а у нас денег нет.")
				fnc_zp()


func _on_tik_timeout():
	var tek_nakl = papa.rotation_degrees.x
	if obj:
		if obj.named == "Cofe":
			print(absf(tek_nakl - posled_naklon))
			if absf(papa.rotation_degrees.x - posled_naklon) > 16:
				obj.get_node("Hik").play()
			elif absf(tek_nakl - posled_naklon) < 7:
				obj.get_node("Hik").stop()
	posled_naklon = tek_nakl
	pass # Replace with function body.


func _on_animation_player_animation_finished(anim_name):
	aim = false
	pass # Replace with function body.


func _on_timer_timeout():
	Global.papa.get_node("Расходники").add_child(rashodnik)
	pass # Replace with function body.
