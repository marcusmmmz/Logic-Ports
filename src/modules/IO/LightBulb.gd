extends Module

func _ready():
	inputs = [false]

func _input_changed(port, new_value):
	
	if new_value == true:
		set_slot(0, true, 0, Color(255,255,255), false, 0, Color(0,0,0))
		offset += Vector2(0, 0)
		$ColorRect.color = Color(255,255,255)
	else:
		set_slot(0, true, 0, Color(0,0,0), false, 0, Color(0,0,0))
		offset += Vector2(0, 0)
		$ColorRect.color = Color(0,0,0)
