extends Area3D

var kol_musor = 0
var mus = load("res://Расходники/rigid_body_3d.tscn")
@export var maxim = 7

func bros_musor():
	kol_musor += 1
	if kol_musor > maxim:
		$Timer.stop()
	var musor = mus.instantiate()
	$musor.add_child(musor)
	for i in kol_musor:
		$musor.get_children()[i].show()
	pass


func _on_body_entered(body: Node3D):
	if !body.freeze:
		if body.named == "paket":
			return
		print("Буква: E")
		bros_musor()
	pass # Replace with function body.

func pochin():
	for i in $musor.get_children():
		i.queue_free()

func _on_timer_timeout():
	bros_musor()
	pass # Replace with function body.
