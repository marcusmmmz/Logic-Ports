extends Module

func _ready():
	outputs = [false]

func _on_Button_button_down():
	outputs[0] = true
	
	update_outputs()
	update_debug_text()

func _on_Button_button_up():
	outputs[0] = false
	
	update_outputs()
	update_debug_text()
