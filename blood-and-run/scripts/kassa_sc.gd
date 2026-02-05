extends CSGBox3D


var kol_stakan = 0
var cofe = 0
var stakan = false
var cofe_gotova = false
var buttons = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	cofe = 10
	stakan = true
	Global.get_player()
	pass # Replace with function body.

func _input(event):
	#if Input.is_action_just_pressed("ui_open"):
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.

func statan_voshol(body: Node3D):
	if body.named == "Stakanchiki" and !$CSGCylinder3D.visible:
		body.queue_free()
		$CSGCylinder3D.show()
		kol_stakan = 10
	pass # Replace with function body.


func on_cofe_machine(body: Node3D):
	body.queue_free()
	if body.named == "Cofe" and cofe <10:
		cofe = 10
		sel(str(cofe)+"/10")
	elif body.named == "Stakan":
		stakan = true
	pass # Replace with function body.


func sel(str: String):
	$Cofe_machine/SubViewport/Control/Label.text = str
	if str == "Варка":
		$Cofe_machine/Timer.start()
	pass


func cofe_gotovo():
	$Cofe_machine/SubViewport/Control/Label.text = "Кофе готово"
	cofe -= 1
	cofe_gotova = true
	stakan = false
	pass # Replace with function body.


func on_хлебница(body):
	if body.named == "pachka_snackov":
		buttons = 10
		body.queue_free()
		set_snack()
	pass # Replace with function body.

func set_snack():
	$"Снеки/SubViewport/Control/Label".text = str(buttons) + "/10"
