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

func _ready():
	Global.connect("load", vis_time.rpc)

func _on_tick_timeout():
	if Global.mp_mode != "offline" and not multiplayer.is_server():
		return
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
					$"driving in my car"._start.rpc()
				elif proshlo - delta_light >60 and Global.fara_days >= 4:
					Global.light_off.rpc()
					delta_light = proshlo
				else:
					end_day -= 10
			else:
				if b> -1:
					Global.papa._start_sream.rpc()
				else:
					$"Лёлик тормоз".tormoz()
			rand = true
	pass # Replace with function body.

@rpc("any_peer", "call_local")
func vis_time(chas_t, min_t):
	print(chas_t, "  ", min_t)
	chas = chas_t
	min = min_t
	Global.player.get_node("Camera3D/game_ui/time/Label2").text = str(chas)
	if min == 0:
		Global.player.get_node("Camera3D/game_ui/time/Label4").text = "00"
	else:
		Global.player.get_node("Camera3D/game_ui/time/Label4").text = str(min)

func _end_day():
	Global.fara_days += 1
	Global.lela = true
	Global.player.get_node("Camera3D/end_day/Label1").text = str(Global.fara_days)
	Global.player.get_node("Camera3D/end_day/AnimationPlayer").play("End_day")
	start_day = true
	rand = true
	proshlo = 0
	energy = 0
	chas = 10
	min = 0
	if Global.mp_mode == "offline": Global.save() 
	get_tree().paused = true


func _on_proshlo_timeout():
	if not multiplayer.is_server():
		return
	proshlo +=1
	print(proshlo)
	if proshlo %15 == 0 and !start_day:
			min +=5
			if min %6 == 0:
				chas +=1
				min = 0
			vis_time.rpc(chas, min)
	pass # Replace with function body.
