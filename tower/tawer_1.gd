extends Node2D


var body: Node2D = self

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	look_at(body.global_position)
	pass


func _on_area_2d_area_entered(area: Area2D) -> void:
	body = area
	$Timer.start()
	pass # Replace with function body.


func _on_timer_timeout() -> void:
	if $"АрбалетВерх/Спрайт-0001".visible:
		$"АрбалетВерх/Спрайт-0001".hide()
	else:
		$"АрбалетВерх/Спрайт-0001".show()
	pass # Replace with function body.
