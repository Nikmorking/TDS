extends CharacterBody3D
class_name Player

var SPEED = 5.0
var JUMP_VELOCITY = 4.5
var in_door = false

var mouse_sens = 0.3
var camera_anglev=0
var JumpVel: Vector3
var isOnMenu = false
var walk = false

var run = false

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(_delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += get_gravity().y * _delta
		if run:
			run = false
			SPEED -= 3

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and !isOnMenu:
		velocity.y = JUMP_VELOCITY
		JumpVel = velocity
	
	if Input.is_action_just_pressed("Run"):
		if !run and !isOnMenu and JumpVel == Vector3(0,0,0):
			run = true
			SPEED += 3
	if Input.is_action_just_released("Run"):
		if run and !isOnMenu :
			run = false
			SPEED -= 3
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("A", "D", "W", "S")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction and !isOnMenu:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		walk = true
	else:
		walk = false
		if is_on_floor():
			velocity.x = move_toward(velocity.x * 1.8, 0, SPEED)
			velocity.z = move_toward(velocity.z * 1.8, 0, SPEED)
			JumpVel = Vector3(0,0,0)
		#if !is_on_floor():
			#velocity.x = move_toward(velocity.x * 2, velocity.x + JumpVel.x * 0.9, SPEED)
			#velocity.z = move_toward(velocity.z * 2, velocity.z + JumpVel.z  * 0.9, SPEED)

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
	if Input.is_action_just_pressed("Escape"):
		if !isOnMenu:
			isOnMenu = true
			#$CharacterBody3D.velocity = Vector3(0, 0, 0)
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			isOnMenu = false
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	


func player_in():
	in_door = true
	pass # Replace with function body.


func player_out():
	in_door = false
	pass # Replace with function body.

func _print_in_ui(text:String):
	$Camera3D/Control/Label.text = "O \n \n ты утилизируй шнягу"
	$Camera3D/Control/Timer.start()
	
