extends Module

func _ready():
	outputs = [false]

func _on_Button_pressed():
	outputs[0] = !outputs[0]
	var connections = get_parent().get_connection_list()
	for connection in connections:
		if connection.from == name:
			var color
			if outputs[0] == true:
				color = Color(255, 255, 255)
			else:
				color = Color(0, 0, 0)
			
			set_slot(0, false, 0, Color(0,0,0), true, 0, Color(color))
			offset += Vector2(0, 0)
			emit_signal("change_output", connection.to_port, outputs[0])
