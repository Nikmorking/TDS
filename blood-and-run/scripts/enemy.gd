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
	if start:
		go()
		look_at(movement_target_position)
		$Running/AnimationPlayer.play("mixamo_com")
		move_and_slide()


func _on_timer_timeout():
	movement_target_position = Global.player.position
	actor_setup()
	pass # Replace with function body.
