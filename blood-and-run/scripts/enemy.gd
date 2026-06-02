extends "res://scripts/no_human.gd"

var start = false
func _ready():
	# These values need to be adjusted for the actor's speed
	# and the navigation layout.
	navigation_agent.path_desired_distance = 0.5
	navigation_agent.target_desired_distance = 0.5

	# Make sure to not await during _ready.
	#actor_setup.call_deferred()
	movement_target_position = position
func _physics_process(delta):
	if start and !navigation_agent.is_navigation_finished():
		go()
		look_at(Global.player.position)
		#$Running/AnimationPlayer.play("mixamo_com")
		move_and_slide()


func _on_timer_timeout():
	Global.get_player()
	get_parent()._run_pl()
	#movement_target_position =Krest Global.player.global_position
	#if get_parent().get_node("Расходники").get_child(0):
		#movement_target_position = get_parent().get_node("Расходники").get_child(0).position
	#print(movement_target_position)
	#actor_setup()
	#pass # Replace with function body.
