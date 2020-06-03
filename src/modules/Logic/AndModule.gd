extends Module

func _ready():
	inputs = [false, false]

func input_changed(port, new_value):
	if inputs[port] != new_value:
		inputs[port] = new_value
		process()

func process():
	var output = true
	for input in inputs:
		if input == false:
			output = false
			break
	
	emit_signal("change_output", 0, output)
