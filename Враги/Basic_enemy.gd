extends Entity
class_name Enemies

var player
var player_position
var play = true
var hit = false
var movi = true
var top = false

@onready var nav: NavigationAgent2D = $NavigationAgent2D
@onready var start_pos = position


func move_to_player(delta: float) -> void:
	nav.target_position = Gs.pos_kindom
	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = nav.get_next_path_position()

	var direction = current_agent_position.direction_to(next_path_position) * nav.max_speed
	nav.set_velocity(direction)
	pass

func char_mode(new_velosity:Vector2)->void:
	if !movi: return
	velocity = new_velosity
	move_and_slide()
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	movi = false
	pass # Replace with function body.
	


func _on_area_2d_body_exited(body: Node2D) -> void:
	movi = true
	pass # Replace with function body.

func wait(time: float) -> void:
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = time
	timer.start()
	if(timer.time_left == 0):
		hit = true
	pass

func _ready() -> void:
	nav.velocity_computed.connect(char_mode)
	health = max_health
	pass

func _on_area_2d_area_entered(area: Area2D) -> void:
	movi = false
	pass # Replace with function body.

func _on_area_2d_area_exited(area: Area2D) -> void:
	movi = true
	pass # Replace with function body.
