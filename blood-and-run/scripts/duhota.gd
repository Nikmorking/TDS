extends Control

var duhota = 0
var in_gas = 1
@export var need = 3000

func _ready():
	$TextureProgressBar2.max_value = need
	pass

func _on_tick_timeout():
	$TextureProgressBar2.value = duhota
	if in_gas == 1:
		duhota += (Global.fara_days+1)/2*randi_range(0,5)
		if duhota > need:
			duhota = 0
			get_parent().die("задожнулся")
	elif in_gas == -1:
		duhota -= (Global.fara_days+1)/2*randi_range(0,5)
		if duhota < 0:
			duhota = 0
	pass # Replace with function body.

func _on_out_timeout():
	in_gas = -1
	pass # Replace with function body.


 


func _on_out_body_exited(body):
	if body.name == "Player":
		if Global.player.in_door:
			in_gas = 0
		else:
			$Out.start()
			if duhota > need/3:
				$Camera3D/Duhota/AnimationPlayer.play("exit")
	pass # Replace with function body.


func _on_in_body_exited(body):
	if body.name == "Player":
		$In.start()
	pass # Replace with function body.


func _on_in_timeout():
	if Global.player.in_door:
		in_gas = 0
	else:
		in_gas = 1
	pass # Replace with function body.
