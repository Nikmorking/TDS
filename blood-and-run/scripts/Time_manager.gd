extends Node3D
class_name Time_manager

var time_left = false
var energy = 0
@export var min_a = -5
@export var max_a = 5
var k_event = 0
var proshlo = 0
@export var end_day = 15 # 5 minuts
var min = 0
var chas = 10
var delta_light = 0

var rand = true
var start_day = true

func _on_tick_timeout():
	if time_left:
			Global.zp -= 1
			Global.papa.prov_list("-1р к ЗП")
			time_left = false
			if Global.zp == -10:
				Global.achivka("Достижение: \nБомж")
	if !rand:
		if chas > end_day:
					rand = true
					_end_day()
					return
		#print(energy)
		if proshlo == 400:
			energy += 100 # *Zp
			
		energy += 13
		energy += randi_range(min_a,max_a)
		if energy > 2000:
			k_event +=1
			energy = 0
			var b = randi_range(-10,1)
			if b < -1:
				if b>=-8 or Global.fara_days < 3:
					$"driving in my car"._start()
				elif proshlo - delta_light >60 and Global.fara_days >= 4:
					Global.light_off()
					delta_light = proshlo
				else:
					end_day -= 10
			else:
				if b> -1:
					Global.papa._start_sream()
				else:
					$"Лёлик тормоз".tormoz()
			rand = true
	pass # Replace with function body.



func _end_day():
	Global.fara_days += 1
	Global.lela = true
	$Player/Camera3D/end_day/Label1.text = str(Global.fara_days)
	$Player/Camera3D/end_day/AnimationPlayer.play("End_day")
	start_day = true
	rand = true
	proshlo = 0
	energy = 0
	chas = 10
	min = 0
	Global.save() 
	get_tree().paused = true


func _on_proshlo_timeout():
	proshlo +=1
	print(proshlo)
	if proshlo %15 == 0 and !start_day:
			min +=5
			Global.player.get_node("Camera3D/game_ui/time/Label4").text = str(min)
			if min %6 == 0:
				chas +=1
				Global.player.get_node("Camera3D/game_ui/time/Label2").text = str(chas)
				Global.player.get_node("Camera3D/game_ui/time/Label4").text = "00"
				min = 0
	pass # Replace with function body.
