extends Area3D




func _on_body_entered(body: Node3D):
	if !body.freeze:
		body.queue_free()
	pass # Replace with function body.
