extends Module

func _ready():
	inputs = [false, false]
	outputs = [false]

func process():
	var new_output = true
	for input in inputs:
		if input == false:
			new_output = false
			break
	
	if new_output != outputs[0]:
		outputs[0] = new_output
		
		update_outputs()
