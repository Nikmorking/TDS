extends Label

var tweener: Tween

func _ready() -> void :



	pass


func _tween(_text, speed) -> void :
	print(speed)
	text = _text
	tweener = create_tween()
	tweener.tween_property(self, "visible_characters", text.length(), text.length() * speed).from(0)
	pass
