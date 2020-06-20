extends GraphNode

class_name Module

var inputs : Array
var outputs : Array

var connections = []

class Connection:
	var from
	var from_port
	var to
	var to_port
	
	func _init(_from : String, _from_port : int, _to : String, _to_port : int):
		from = _from
		from_port = _from_port
		to = _to
		to_port = _to_port

func _ready():
	call_deferred("_input_changed")

func add_connection(connection : Connection):
	connections.append(connection)
	
	_input_changed()

func find_connection(connection : Connection):
	var i = 0
	for cnn in connections:
		var all_pass = true
		
		if cnn.from != connection.from:
			all_pass = false
		if cnn.from_port != connection.from_port:
			all_pass = false
		if cnn.to != connection.to:
			all_pass = false
		if cnn.to_port != connection.to_port:
			all_pass = false
		
		if all_pass:
			return i
		i+=1

func delete_connection(connection : Connection):
	var cnn = find_connection(connection)
	if cnn != -1:
		connections.remove(cnn)
	
	_input_changed()

func update_inputs():
	var i = 0
	while i < inputs.size():
		inputs[i] = false
		i+=1
	
	for cnn in connections:
		
		if cnn.to == self.name:
			var from_node = get_parent().get_node(cnn.from)
			
			if from_node.outputs[cnn.from_port] == true:
				inputs[cnn.to_port] = true

func update_debug_text():
	if !Engine.editor_hint:
		var text : String
		text += "in: " + var2str(inputs) + "\n"
		text += "out: " + var2str(outputs)
		$DebugText.text = text

func process():
	pass

func _input_changed():
	update_inputs()
	process()
	update_debug_text()

func update_outputs():
	var color
	if outputs[0] == true:
		color = Color(255, 255, 255)
	else:
		color = Color(0, 0, 0)
	
	set_slot(0,
		is_slot_enabled_left(0), 0,
		get_slot_color_left(0),
		is_slot_enabled_right(0), 0,
		color
	)
	
	for cnn in connections:
		if cnn.from == name:
			get_parent().get_node(cnn.to)._input_changed()

func _on_Module_close_request():
	
	while connections.size() > 0:
		var cnn = connections[0]
		get_parent()._on_GraphEdit_disconnection_request(
			cnn.from, cnn.from_port, cnn.to, cnn.to_port
		)
	
	queue_free()

func save():
	var save_dict = {
		"filename":get_filename(),
		"parent":get_parent().get_path(),
		"name":name,
		"title":title,
		"offset":var2str(offset),
	}
	return save_dict
