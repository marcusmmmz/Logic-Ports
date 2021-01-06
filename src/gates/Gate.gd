class_name Gate
extends GraphNode

signal output_updated(gate)
export var inputs_size : int
export var outputs_size : int
var inputs : Array
var outputs : Array

func _ready():
	connect("output_updated", get_parent(), "_on_Gate_output_updated")
	setup_io()

func setup_io():
	for i in range( max(inputs_size, outputs_size) ):
		var panel = Panel.new()
		panel.rect_min_size.y = 32
		add_child(panel)
		
		if i < inputs_size:
			inputs.append(false)
		
		if i < outputs_size:
			outputs.append(false)
		
		set_slot(i,
			i < inputs_size, 0, Color.black,
			i < outputs_size, 0, Color.black
		)
	
	update_io()

func process():
	pass #virtual

func update_io():
	var old_outputs := outputs.duplicate()
	update_inputs()
	process()
	
	if old_outputs != outputs:
		update_outputs()

func update_inputs():
	for i in range( inputs.size() ):
		
		var color := Color.black
		if inputs[i]:
			color = Color.white
		
		set_slot(i,
			is_slot_enabled_left(i), 0,
			color,
			is_slot_enabled_right(i), 0,
			get_slot_color_right(i)
		)

func update_outputs():
	for i in range( outputs.size() ):
		
		var color := Color.black
		if outputs[i]:
			color = Color.white
		
		set_slot(i,
			is_slot_enabled_left(i), 0,
			get_slot_color_left(i),
			is_slot_enabled_right(i), 0,
			color
		)
		
		# Connection colors are only changed when offset is changed
		offset += Vector2.ZERO
	
	emit_signal("output_updated", self)

func save(save_game : Resource):
	save_game.data["gates"].append({
		"filename":get_filename(),
		"name":name,
		"offset": var2str(offset),
	})

func _on_Gate_close_request():
	queue_free()
	get_parent().disconnect_gate_connections(name)
