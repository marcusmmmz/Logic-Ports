extends Module

var inputs = [false, false]

func input_changed(port, new_value):
	if inputs[port] != new_value:
		inputs[port] = new_value
		process()

func process():
	var output = false
	for input in inputs:
		if input == true:
			output = true
			break
	
	emit_signal("change_output", 0, output)
