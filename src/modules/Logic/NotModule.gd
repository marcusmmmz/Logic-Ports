extends Module

var times_executed = 9
var inputs = [true]

func input_changed(port, new_value):
	if inputs[port] != new_value:
		inputs[port] = new_value
		process()

func process():
	times_executed -= 1
	if times_executed < 0:
		return
	
	var output = !inputs[0]
	emit_signal("change_output", 0, output)

func _physics_process(delta):
	times_executed = 9
