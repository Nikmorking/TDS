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

#var obj: RigidBody3D
var obj: Node3D
var kol = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if Input.is_action_just_pressed("ui_open"):
		print("click")
		if !get_parent().get_parent().in_door and obj:
			_stavit_rashodnic()
		if !obj and !get_parent().get_parent().in_door: 
			if $RayCast3D.is_colliding():
				_colling()
	if Input.is_action_just_pressed("+"):
		if $SpringArm3D.spring_length < 2.5:
			$SpringArm3D.spring_length += 0.1
	if Input.is_action_just_pressed("-"):
		if $SpringArm3D.spring_length > 1:
			$SpringArm3D.spring_length -= 0.1
			
	

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

func _stavit_rashodnic():
			var rashodnik: Node3D = instance_na(obj.named)
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
			get_tree().root.get_node("Node3D").get_node("Расходники").add_child(rashodnik)

func fnc_zp():
	if zp_in:
		if $RayCast3D.get_collider().name == "ZP1":
			points = $"../../../LineRenderer3D".points
		if $RayCast3D.get_collider().name == "ZP2":
			points = $"../../../LineRenderer3D2".points
		if $RayCast3D.get_collider().name == "ZP3":
			points = $"../../../LineRenderer3D3".points
		if $RayCast3D.get_collider().name == "ZP4":
			points = $"../../../LineRenderer3D4".points
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

func _colling():
				print("coll")
				var col: Node3D = $RayCast3D.get_collider()
				if col.is_class("Area3D"):
					fnc_zp()
					print(col.name)
					var kasa = col.get_parent()
					if col.name == "Stakan":
						if kasa.kol_stakan > 0:
							add_to_hand("Stakan")
							kasa.kol_stakan -= 1
					elif col.name == "Cofe_machine":
						if kasa.cofe > 0:
							if kasa.stakan:
								kasa.sel("Варка")
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
				elif col.is_class("RigidBody3D"):
					add_to_hand(col.named)
					if col.get_parent().name == "Расходники":
						col.queue_free()
				elif $"../../../Расходники".get_children().size() < 10:
					add_to_hand(col.name)
				else:
					$"../.."._print_in_ui("               O \n \n ты утилизируй шнягу")
					print("Продай что нибудь ненужное! Но чтобы продать что то ненужное,сначало нужно купить что-то ненужное, а у нас денег нет.")
