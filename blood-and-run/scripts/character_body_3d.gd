extends CharacterBody3D
class_name Player

var stakanchiki = load("res://Models/1.tscn")
var cofe = load("res://Models/cofe.tscn")
var stakan = load("res://Models/Stakan.tscn")

var SPEED = 5.0
var JUMP_VELOCITY = 4.5
var in_door = false

var mouse_sens = 0.3
var camera_anglev=0
var JumpVel: Vector3
var st_mac: AnimationNodeStateMachinePlayback
var isOnMenu = false
var is_jumping := false
var anim_tree: AnimationTree
var walk = false
var obj: RigidBody3D
var kol = 0

var run = false

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(_delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += get_gravity().y * _delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and !isOnMenu:
		velocity.y = JUMP_VELOCITY
		is_jumping = true
	
	if Input.is_action_just_pressed("Run"):
		if !run and !is_jumping and !isOnMenu:
			run = true
			SPEED += 3
	if Input.is_action_just_released("Run"):
		if run and !is_jumping and !isOnMenu:
			run = false
			SPEED -= 3
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("A", "D", "W", "S")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction and !isOnMenu and is_on_floor():
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		JumpVel = direction
		walk = true
	else:
		walk = false
		if is_on_floor():
			velocity.x = move_toward(velocity.x * 1.8, 0, SPEED)
			velocity.z = move_toward(velocity.z * 1.8, 0, SPEED)
			
		if !is_on_floor():
			velocity.x = move_toward(velocity.x * 2, JumpVel.x * 4.5, SPEED)
			velocity.z = move_toward(velocity.z * 2, JumpVel.z * 4.5, SPEED)

	move_and_slide()
	
	if is_on_floor() and is_jumping:
		is_jumping = false
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
	if Input.is_action_just_pressed("ui_open"):
		print("click")
		if !in_door and obj:
			var rashodnik: RigidBody3D
			if obj.named == "Stakanchiki":
				rashodnik = stakanchiki.instantiate()
			if obj.named == "Cofe":
				rashodnik = cofe.instantiate()
			if obj.named == "Stakan":
				rashodnik = stakan.instantiate()
			rashodnik.position = obj.global_position
			rashodnik.freeze = false
			rashodnik.gravity_scale = 1.4
			for i in $Camera3D.get_children():
				if i.is_class("RigidBody3D"):
					i.queue_free()
			var coll: CollisionShape3D = rashodnik.get_node("Coll")
			coll.disabled = false
			get_parent().get_node("Расходники").add_child(rashodnik)
		if !obj and !in_door:
			if $Camera3D/RayCast3D.is_colliding():
				print("coll")
				var col: Node3D = $Camera3D/RayCast3D.get_collider()
				if col.is_class("Area3D"):
					print(col.name)
					if col.name == "Stakan":
						if col.get_parent().kol_stakan > 0:
							add_to_hand("Stakan")
							col.get_parent().kol_stakan -= 1
					elif col.name == "Cofe_machine":
						var kasa = col.get_parent()
						if kasa.cofe > 0:
							if kasa.stakan:
								kasa.sel("Варка")
							else:
								kasa.sel("нет стакана")
						else:
							kasa.sel("Нет кофе")
						
							
				if col.is_class("RigidBody3D"):
					add_to_hand(col.named)
					if col.get_parent().name == "Расходники":
						col.queue_free()
				else:
					add_to_hand(col.name)


func player_in():
	in_door = true
	pass # Replace with function body.


func player_out():
	in_door = false
	pass # Replace with function body.


func add_to_hand(name: String):
	if name == "Со стаканами" or name == "Stakanchiki":
		obj = stakanchiki.instantiate()
	if name == "С кофе" or name == "Cofe":
		obj = cofe.instantiate()
	if name == "Stakan":
		obj = stakan.instantiate()
	if obj:
		obj.position -= Vector3(0,0,2)
		obj.name = obj.name + str(kol)
		$Camera3D.add_child(obj)
		kol += 1
		print(obj.get_class())
	pass
