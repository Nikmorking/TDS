extends Line2D

var dragging = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Button.button_down.connect(press.bind("Button"))
	$Button2.button_down.connect(press.bind("Button2"))
	pass # Replace with function body.

func _process(delta: float) -> void:
	if dragging: 
		points[1] = get_global_mouse_position() - global_position

func press(string:String):
	dragging = true
	points[0] = get_node(string).position + Vector2(20, 20)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and not event.is_pressed():
		dragging = false
	#if event is InputEventMouseMotion:
	if event is InputEventMouseMotion and dragging:
			print(event)
			var input: InputEventMouseMotion = event
			points.set(0, input.position)
