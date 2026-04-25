extends "res://scripts/no_human.gd"

var start = false
var i = 0
var n = 2

signal end_put
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
	print(i,n, mtp_list)
	if navigation_agent.is_navigation_finished() and start:
		print("dsfg"+str(i))
		i += 1
		if i >n: 
			start =false
			end_put.emit()
			pass
		else:
			movement_target_position = mtp_list[i].position
			rotate_y(1.57)
			actor_setup()
	if start:
		go()
		move_and_slide()

func _start():
	#if randi_range(0, 10) > 9:
	$AudioStreamPlayer3D.play()
	movement_target_position = mtp_list[i].position
	actor_setup()
	start = true
	pass # Replace with function body.
