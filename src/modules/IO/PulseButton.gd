extends Module

func _ready():
	outputs = [false]

func _on_Button_button_down():
	outputs[0] = true
	var connections = get_parent().get_connection_list()
	for connection in connections:
		if connection.from == name:
			set_slot(0, false, 0, Color(0,0,0), true, 0, Color(255,255,255))
			offset += Vector2(0, 0)
			emit_signal("change_output", connection.to_port, outputs[0])

func _on_Button_button_up():
	outputs[0] = false
	var connections = get_parent().get_connection_list()
	for connection in connections:
		if connection.from == name:
			set_slot(0, false, 0, Color(0,0,0), true, 0, Color(0,0,0))
			emit_signal("change_output", connection.to_port, outputs[0])
