extends "res://scripts/no_human.gd"

var start = false
var i = 0
var n = 2
var frame = 0

signal end_put
signal davka(prichina:String)

func _ready():
	mtp_list = get_parent().get_node("Дорога/Markers").get_children()
	# These values need to be adjusted for the actor's speed
	# and the navigation layout.
	navigation_agent.path_desired_distance = 0.5
	navigation_agent.target_desired_distance = 0.5

	# Make sure to not await during _ready.
	#actor_setup.call_deferred()
	print(i, mtp_list[0].name, mtp_list[1].name, mtp_list[2].name)
	movement_target_position = mtp_list[0].position

func _physics_process(delta):
	if navigation_agent.is_navigation_finished() and start:
		print("dsfg"+str(i))
		i += 1
		if i >n: 
			start =false
			end_put.emit()
			frame = $Driving.get_playback_position()
			$Parking.play()
			$Driving.stop()
			pass
		else:
			movement_target_position = mtp_list[i].position
			if i == 2:
				rotate_y(-1.57)
			else:
				rotate_y(1.57)
			actor_setup()
	if start:
		go()
		move_and_slide()

func conti():
	$Parking.stop()
	$Driving.play(frame)


func _start():
	rotation_degrees = Vector3(0, 0, 0)
	if randi_range(0, 10) > 9:
		$Driving.stream = load("res://sounds/Driving in my car.mp3")
	else:
		$Driving.stream = load("res://sounds/inside-car-wet-driving_fydabreu.mp3")
	$Driving.play()
	movement_target_position = mtp_list[i].position
	actor_setup()
	start = true
	pass # Replace with function body.


func davi(body):
	if body.name == "Player" and start:
		davka.emit("Задавлен")
	pass # Replace with function body
