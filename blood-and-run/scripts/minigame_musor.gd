extends Node2D  # Работает для Area2D, Sprite2D и др.

var is_dragging: bool = false
var drag_offset: Vector2 = Vector2.ZERO
var touch_index: int = -1

@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _input(event: InputEvent) -> void:
	
	# 1. Фиксируем КАСАНИЕ экрана пальцем
	if event is InputEventScreenTouch:
		if event.pressed and not is_dragging:
			# Проверяем, нажал ли игрок именно внутри границ нашего CollisionShape2D
			if _is_point_inside_collision(event.position):
				is_dragging = true
				touch_index = event.index  # Запоминаем ID пальца, чтобы игнорировать мультитач
				drag_offset = event.position - global_position
				print("Предмет успешно схвачен тачем! ID пальца: ", touch_index)
				get_viewport().set_input_as_handled() # Говорим движку, что касание обработано
				
		# 2. Фиксируем ОТПУСКАНИЕ экрана
		elif not event.pressed and event.index == touch_index:
			is_dragging = false
			touch_index = -1
			print("Предмет выпущен из рук")
			get_viewport().set_input_as_handled()

	# 3. ФИКСИРУЕМ ДВИЖЕНИЕ пальца (перетаскивание)
	if event is InputEventScreenDrag and is_dragging:
		# Двигаем только если экран двигает именно тот палец, который схватил предмет
		if event.index == touch_index:
			global_position = event.position - drag_offset
			get_viewport().set_input_as_handled()

# Функция математической проверки: попал ли тач в зону коллизии
func _is_point_inside_collision(touch_pos: Vector2) -> bool:
	if not collision_shape or not collision_shape.shape:
		return false
		
	var local_touch_pos = to_local(touch_pos)
	var shape = collision_shape.shape
	
	# Проверка для прямоугольной формы (RectangleShape2D)
	if shape is RectangleShape2D:
		var half_size = shape.size / 2
		return abs(local_touch_pos.x) <= half_size.x and abs(local_touch_pos.y) <= half_size.y
		
	# Проверка для круглой формы (CircleShape2D)
	elif shape is CircleShape2D:
		return local_touch_pos.length() <= shape.radius
		
	# Проверка для капсулы (CapsuleShape2D)
	elif shape is CapsuleShape2D:
		var radius = shape.radius
		var half_height = shape.height / 2 - radius
		if abs(local_touch_pos.y) <= half_height:
			return abs(local_touch_pos.x) <= radius
		var disk_center_y = half_height if local_touch_pos.y > 0 else -half_height
		var dist_to_disk_center = Vector2(local_touch_pos.x, local_touch_pos.y - disk_center_y).length()
		return dist_to_disk_center <= radius
		
	return false
