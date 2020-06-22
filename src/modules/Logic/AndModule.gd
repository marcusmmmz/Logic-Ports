extends Module

func _ready():
	inputs = [false, false]
	outputs = [false]

func process():
	var new_output = true
	for input in inputs:
		new_output = new_output and input
	
	if new_output != outputs[0]:
		outputs[0] = new_output
		
		update_outputs()
