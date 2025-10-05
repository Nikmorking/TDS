extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var mouse_sens = 0.3
var camera_anglev=0
var JumpVel: Vector3

var mouse_sens = 0.1

var isOnMenu = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += get_gravity().y * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and !isOnMenu:
		velocity.y = JUMP_VELOCITY
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("A", "D", "W", "S")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction and !isOnMenu and is_on_floor():
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		$monk_character_Walking/AnimationPlayer.play("mixamo_com")
		JumpVel = direction
	else:
		if is_on_floor():
			velocity.x = move_toward(velocity.x * 1.8, 0, SPEED)
			velocity.z = move_toward(velocity.z * 1.8, 0, SPEED)
		if !is_on_floor():
			velocity.x = move_toward(velocity.x * 2, JumpVel.x * 4.5, SPEED)
			velocity.z = move_toward(velocity.z * 2, JumpVel.z * 4.5, SPEED)

	move_and_slide()
	#$Camera3D.rotate_y(deg_to_rad(-event.relative.x * mouse_sens))
		#var changev= -event.relative.y * mouse_sens
		#if camera_anglev +changev>-50 and camera_anglev + changev < 50:
			#camera_anglev+=changev
			#$Camera3D.rotate_x(deg_to_rad(changev))



func _input(event): 
	if event is InputEventMouseMotion and !isOnMenu:
		if $Camera3D.rotation.x - deg_to_rad(event.relative.y) < deg_to_rad(90) and $Camera3D.rotation.x - deg_to_rad(event.relative.y) > deg_to_rad(-70):
			$Camera3D.rotation += Vector3(deg_to_rad(-event.relative.y * mouse_sens), 0, 0)
		rotation += Vector3(0 ,deg_to_rad(-event.relative.x * mouse_sens), 0)
	
