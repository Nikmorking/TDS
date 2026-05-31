extends Node3D

var m:Material

func change_envir_light()-> void:
		if $OmniLight3D.light_color == Color("b1af00"):
			$OmniLight3D.light_color = Color(0.475, 0.0, 0.0, 1.0)
			$OmniLight3D.light_energy = 1.3
			$OmniLight3D.omni_range = 20
			m.albedo_color = Color(0.475, 0.0, 0.0, 1.0)
		else:
			$OmniLight3D.light_color = Color("b1af00")
			$OmniLight3D.light_energy = 0.8
			$OmniLight3D.omni_range = 15
			m.albedo_color = Color("c3bf00")
		pass

func power_off():
	print("off")
	if Global.light_work:
		$OmniLight3D.light_energy = 0
		m.albedo_color = Color(0.299, 0.301, 0.289, 1.0)
	else:
		$OmniLight3D.light_energy = 0.8
		m.albedo_color = Color("c3bf00")
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if get_node("CSGSphere3D"):
		m = get_node("CSGSphere3D").material
	if get_node("CSGCylinder3D2"):
		m = get_node("CSGCylinder3D2").material
	Global.connect("bad", change_envir_light)
	Global.connect("_light_off", power_off)
	pass # Replace with function body.
