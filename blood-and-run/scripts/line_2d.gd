extends Line2D

var dragging = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Button.button_down.connect(press)
	pass # Replace with function body.

func press():
	dragging = true

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and not event.is_pressed():
		dragging = false
	#if event is InputEventMouseMotion:
	if event is InputEventMouseMotion and dragging:
			print(event)
			var input: InputEventMouseMotion = event
			points.set(0, input.position)
