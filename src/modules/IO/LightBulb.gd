extends Module

func _ready():
	inputs = [false]

func process():
	if inputs[0] == true:
		$ColorRect.color = Color(255,255,255)
	else:
		$ColorRect.color = Color(0,0,0)
