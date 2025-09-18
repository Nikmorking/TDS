extends Node

var pos_kindom

func _ready() -> void:
	pos_kindom = get_parent().get_node("Test/Marker").position
