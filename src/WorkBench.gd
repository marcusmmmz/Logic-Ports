extends GraphEdit

func _ready():
	WorkbenchManager.workbench = self

# inneficient, optimize later if possible
func get_node_connections(node_name):
	var conns := { "inputs":[], "outputs":[] }
	
	for conn in get_connection_list():
		if node_name == conn.from: conns.outputs.append(conn)
		if node_name == conn.to: conns.inputs.append(conn)
	
	return conns

func update_gate_inputs(gate):
	# inneficient, optimize later
	for i in range( gate.inputs.size() ):
		gate.inputs[i] = false
	
	for conn in get_node_connections(gate.name).inputs:
		get_node(conn.to).inputs[conn.to_port] = get_node(conn.from).outputs[conn.from_port]
	gate.update_io()

func save(save_game : Resource):
	save_game.data["graph_edit"] = ({
		"scroll_offset":var2str(scroll_offset),
		"zoom":zoom,
		"connection_list":get_connection_list()
	})

func _on_WorkBench_connection_request(from, from_slot, to, to_slot):
	connect_node(from, from_slot, to, to_slot)
	update_gate_inputs( get_node(to) )

func _on_WorkBench_disconnection_request(from, from_slot, to, to_slot):
	disconnect_node(from, from_slot, to, to_slot)
	update_gate_inputs( get_node(to) )

func _on_WorkBench_delete_nodes_request():
	for child in get_children():
		if child is GraphNode and child.is_selected():
			
			disconnect_gate_connections(child)
			
			child.queue_free()

func disconnect_gate_connections(gate):
	var conns = get_node_connections(gate)
		
	for conn in conns.inputs:
		disconnect_node(conn.from, conn.from_port, conn.to, conn.to_port)
	
	for conn in conns.outputs:
		disconnect_node(conn.from, conn.from_port, conn.to, conn.to_port)
		update_gate_inputs( get_node(conn.to) )

func _on_Gate_output_updated(gate):
	for conn in get_node_connections(gate.name).outputs:
		update_gate_inputs( get_node(conn.to) )
