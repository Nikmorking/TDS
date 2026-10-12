extends Node2D # Работает для Area2D, Sprite2D и других 2D-узлов

var is_dragging: bool = false
var drag_offset: Vector2 = Vector2.ZERO

@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _input(event: InputEvent) -> void:
	
	# 1. Фиксируем КЛИК мыши
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and not is_dragging:
			# Проверяем, попал ли курсор внутрь границ нашего CollisionShape2D
			if _is_point_inside_collision(event.position):
				is_dragging = true
				# Вычисляем смещение, чтобы объект не прыгал центром к курсору
				drag_offset = event.position - global_position
				print("Предмет успешно схвачен мышкой!")
				get_viewport().set_input_as_handled() # Помечаем инпут как обработанный
				
		# 2. Фиксируем ОТПУСКАНИЕ кнопки мыши
		elif not event.pressed and is_dragging:
			is_dragging = false
			print("Предмет отпущен мышкой")
			get_viewport().set_input_as_handled()

	# 3. Фиксируем ДВИЖЕНИЕ мыши (перетаскивание)
	if event is InputEventMouseMotion and is_dragging:
		global_position = event.position - drag_offset
		get_viewport().set_input_as_handled()

# Универсальная функция проверки попадания в зону коллизии
func _is_point_inside_collision(mouse_pos: Vector2) -> bool:
	if not collision_shape or not collision_shape.shape:
		return false
		
	var local_mouse_pos = to_local(mouse_pos)
	var shape = collision_shape.shape
	
	# Проверка для прямоугольника (RectangleShape2D)
	if shape is RectangleShape2D:
		var half_size = shape.size / 2
		return abs(local_mouse_pos.x) <= half_size.x and abs(local_mouse_pos.y) <= half_size.y
		
	# Проверка для круга (CircleShape2D)
	elif shape is CircleShape2D:
		return local_mouse_pos.length() <= shape.radius
		
	# Проверка для капсулы (CapsuleShape2D)
	elif shape is CapsuleShape2D:
		var radius = shape.radius
		var half_height = shape.height / 2 - radius
		if abs(local_mouse_pos.y) <= half_height:
			return abs(local_mouse_pos.x) <= radius
		var disk_center_y = half_height if local_mouse_pos.y > 0 else -half_height
		var dist_to_disk_center = Vector2(local_mouse_pos.x, local_mouse_pos.y - disk_center_y).length()
		return dist_to_disk_center <= radius
		
	return false
