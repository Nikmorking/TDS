extends Control

var duhota = 0
var in_gas = 1
@export var need = 3000

func _ready():
	$TextureProgressBar2.max_value = need
	pass

var lev = 0
func _on_tick_timeout():
	$TextureProgressBar2.value = duhota
	if duhota > need*0.3 and lev == 0:
		$AnimationPlayer.play("0.3")
		lev += 1
	if duhota >need/2 and lev == 1:
		$AnimationPlayer.play("0.5")
		lev += 1
	if duhota >need*0.75 and lev == 2:
		lev += 1
		$TextureRect.base_alpha = 0.5
	if duhota >need*0.9:
		$TextureRect.base_alpha = 0.75
		$TextureRect.pulse_speed = 7
	if in_gas == 1:
		duhota += (Global.fara_days+1)/2*randi_range(0,5)
		if duhota > need:
			duhota = 0
			Global.papa.die("задожнулся")
	elif in_gas == -1:
		if duhota <= 0:
			duhota = 0
		else:
			duhota -= (Global.fara_days+1)*randi_range(0,5)
			if $TextureRect.pulse_speed >0 :
				$TextureRect.pulse_speed -= 0.01
			else:
				$TextureRect.pulse_speed = 0
			if $TextureRect.base_alpha >0 :
				$TextureRect.base_alpha -= 0.001
			else:
				$TextureRect.base_alpha = 0
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
			if duhota > need/3*2:
				$AnimationPlayer.play("exit")
	pass # Replace with function body.


func _on_in_body_exited(body):
	if body.name == "Player":
		if Global.player.in_door:
			in_gas = 0
		else:
			$In.start()
	pass # Replace with function body.


func _on_in_timeout():
	in_gas = 1
	pass # Replace with function body.
