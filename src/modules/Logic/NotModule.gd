extends Module

func _ready():
	inputs = [false]
	outputs = [false]

func process():
	var new_output = !inputs[0]
	
	if new_output != outputs[0]:
		outputs[0] = new_output
		
		update_outputs()
