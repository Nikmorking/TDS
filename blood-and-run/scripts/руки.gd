extends Node3D


var stakanchiki = load("res://Расходники/1.tscn")
var cofe = load("res://Расходники/cofe.tscn")
var stakan = load("res://Расходники/Stakan.tscn")
var stakan_s_cofe = load("res://Расходники/Stakan_s_cofe.tscn")
var ahabka_buttonov = load("res://Расходники/ahabka_buttonov.tscn")
var button = load("res://Models/button/source/poly.glb")

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
			var rashodnik: RigidBody3D
			if obj.named == "Stakanchiki":
				rashodnik = stakanchiki.instantiate()
			if obj.named == "Cofe":
				rashodnik = cofe.instantiate()
			if obj.named == "Stakan":
				rashodnik = stakan.instantiate()
			if obj.named == "Stakan_s_cofe":
				rashodnik = stakan_s_cofe.instantiate()
			if obj.named == "ahabka_buttonov":
				rashodnik = ahabka_buttonov.instantiate()
			rashodnik.position = obj.global_position
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
					elif col.name == "хлебница":
						if kasa.buttons > 0:
							add_to_hand("button")
							kasa.buttons -= 1
				if col.is_class("RigidBody3D"):
					add_to_hand(col.named)
					if col.get_parent().name == "Расходники":
						col.queue_free()
				else:
					add_to_hand(col.name)
	

func add_to_hand(name: String):
	print(name)
	if name == "Со стаканами" or name == "Stakanchiki":
		obj = stakanchiki.instantiate()
	if name == "С кофе" or name == "Cofe":
		obj = cofe.instantiate()
	if name == "Stakan":
		obj = stakan.instantiate()
	if name == "Stakan_s_cofe":
		obj = stakan_s_cofe.instantiate()
	if name == "batonovo" or name == "ahabka_buttonov":
		obj = ahabka_buttonov.instantiate()
	if name == "button":
		obj = button.instantiate()
	if obj:
		obj.position -= Vector3(0,0,2)
		obj.name = obj.name + str(kol)
		add_child(obj)
		kol += 1
		print(obj.get_class())
	pass
