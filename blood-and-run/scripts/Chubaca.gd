extends Node3D

@export var posis: Array
var i = 0
var start = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if start:
		position = lerp(position, get_node(posis[i]).global_position, 0.2*delta)
	pass


func _on_area_3d_body_entered(body: Node3D) -> void:
	print("die")
	pass # Replace with function body.


func _on_timer_timeout() -> void:
	start = true
	pass # Replace with function body.
