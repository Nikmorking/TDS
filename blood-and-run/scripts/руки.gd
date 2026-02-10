extends Node3D


var stakanchiki = load("res://Расходники/1.tscn")
var cofe = load("res://Расходники/cofe.tscn")
var stakan = load("res://Расходники/Stakan.tscn")
var stakan_s_cofe = load("res://Расходники/Stakan_s_cofe.tscn")
var ahabka_buttonov = load("res://Расходники/ahabka_buttonov.tscn")
var button = load("res://Models/button/source/poly.glb")
var pachka_snackov = load("res://Расходники/pachka_snackov.tscn")
var snack = load("res://Расходники/snack.tscn")

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
			var rashodnik = instance_na(obj.named)
			rashodnik.position = obj.global_position 
			if rashodnik.named == "snack":
				rashodnik.position += Vector3(2,0,0)
			rashodnik.freeze = false
			rashodnik.gravity_scale = 1.4
			for i in get_children():
				if i.is_class("RigidBody3D"):
					i.queue_free()
			var coll: CollisionShape3D = rashodnik.get_node("Coll")
			coll.disabled = false
			get_tree().root.get_node("Node3D").get_node("Расходники").add_child(rashodnik)
		if !obj and !get_parent().get_parent().in_door:
			if $RayCast3D.is_colliding():
				print("coll")
				var col: Node3D = $RayCast3D.get_collider()
				if col.is_class("Area3D"):
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
							add_to_hand("Stakan_s_cofe")
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
				else:
					add_to_hand(col.name)
	

func instance_na(name: String) -> Object:
	var ret_obj
	if name == "Со стаканами" or name == "Stakanchiki":
		ret_obj = stakanchiki.instantiate()
	if name == "С кофе" or name == "Cofe":
		ret_obj = cofe.instantiate()
	if name == "Stakan":
		ret_obj = stakan.instantiate()
	if name == "Stakan_s_cofe":
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
		obj.position -= Vector3(0,0,1.7)
		obj.name = obj.name + str(kol)
		add_child(obj)
		kol += 1
		print(obj.get_class())
	pass
