extends CSGBox3D

var kol_stakan = 0
var cofe = 0
var stakan = false
var cofe_gotova = false
var snacks = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	#cofe = 10
	$"../CSGPolygon3D/ekran/AnimationPlayer".play("glich")
	#stakan = true
	if Global.fara_days == 0:
		$Cofe_machine/CollisionShape3D.disabled = true
		$Cofe_machine/mesh.hide()
		$Cofe_machine/Sprite3D.hide()
		
	pass # Replace with function body.

func _input(event):
	#if Input.is_action_just_pressed("ui_open"):
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.

@rpc("any_peer", "call_local")
func vospoln_stakanchiki():
		print("add stakan")
		$CSGCylinder3D.show()
		kol_stakan = 5
		$CSGCylinder3D.show()
		$Stakan.position.y = 1
		for i in $CSGCylinder3D.get_children():
			i.show()
		vis_stakan()

@rpc("any_peer", "call_local")
func add_stakan():
		print("staklam")
		kol_stakan += 1
		vis_stakan()
		$Stakan.position.y += 0.3
		$CSGCylinder3D.get_child(kol_stakan-1).show()

func statan_voshol(body: Node3D):
	if body.named == "Stakanchiki" and kol_stakan == 0:
		vospoln_stakanchiki.rpc()
		body.queue_free()
	if body.named == "Stakan" and kol_stakan != 5 and !body.freeze:
		body.queue_free()
		add_stakan.rpc()
	pass # Replace with function body.

@rpc("any_peer", "call_local")
func vis_stakan():
	$SubViewport/Control/Label.text = str(kol_stakan) + "/5"

func on_cofe_machine(body: Node3D):
	body.queue_free()
	if body.named == "Cofe" and cofe <10:
		cofe = 10
		sel(str(cofe)+"/10")
	elif body.named == "Stakan":
		stakan = true
		$Cofe_machine/Stakan.show()
	pass # Replace with function body.

var vari = 0

func sel(str: String):
	$Cofe_machine/SubViewport/Control/Label.text = str
	if str == "Варка":
		vari += 1
			#printerr("L")
		$Cofe_machine/Timer.start()
	pass

func cofe_gotovo():
	$Cofe_machine/AudioStreamPlayer3D.stop()
	$Cofe_machine/SubViewport/Control/Label.text = "Кофе готово"
	$Cofe_machine/Stakan.hide()
	$Cofe_machine/Stakan_s_cofe.show()
	cofe -= 1
	cofe_gotova = true
	stakan = false
	pass # Replace with function body.


@rpc("any_peer", "call_local")
func _snack_voshlo(named):
	print("voxhjlo")
	if named == "pachka_snackov":
		snacks = 10
		set_snack()
	if named == "snack":
		snacks += 1
		set_snack()

func set_snack():
	$"Снеки/SubViewport/Control/Label".text = str(snacks) + "/10"
	var snaki:Array = $"Снеки/snek polka".get_children()
	snaki.remove_at(0)
	for i in snaki:
		i.hide()
	for i in range(0, snacks):
		snaki.get(i).show()



func on_snaks(body):
	_snack_voshlo.rpc(body.named)
	if body.named == "snack" or body.named == "pachka_snackov":
		body.queue_free()
	pass # Replace with function body.


func get_var():
	var data = [kol_stakan,cofe,stakan,cofe_gotova,snacks]
	return data

func load_var(data):
	kol_stakan = int(data.get(0))
	cofe = int(data.get(1))
	stakan = data.get(2)
	cofe_gotova = data.get(3)
	snacks = int(data.get(4))
	sel(str(cofe)+"/10")
	if kol_stakan >0:
		$CSGCylinder3D.show()
		$Stakan.position.y = 1
		var st = $CSGCylinder3D.get_children()
		for i in kol_stakan:
			st.get(i).show()
	else:
		$CSGCylinder3D.hide()
	set_snack()
	vis_stakan()


@rpc("any_peer", "call_local")
func vzat_stakan():
	kol_stakan -= 1
	$Stakan.position.y -= 0.3
	$CSGCylinder3D.get_children().get(kol_stakan).hide()
	vis_stakan()

@rpc("any_peer", "call_local")
func vzat_snack():
	snacks -= 1
	set_snack()
