extends Module

func _ready():
	inputs = [false, false]
	outputs = [false]

func process():
	var new_output = false
	for input in inputs:
		if input == true:
			new_output = true
			break
	
	if new_output != outputs[0]:
		outputs[0] = new_output
		
		update_outputs()
