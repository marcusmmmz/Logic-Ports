extends Module

func _ready():
	outputs = [false]

func _on_Button_pressed():
	outputs[0] = !outputs[0]
	
	update_outputs()
	update_debug_text()
