extends GraphEdit

var speed = 5

func _physics_process(delta):
	if Input.is_action_pressed("ui_right"):
		scroll_offset.x += speed * zoom
	if Input.is_action_pressed("ui_left"):
		scroll_offset.x -= speed * zoom
	
	if Input.is_action_pressed("ui_up"):
		scroll_offset.y -= speed * zoom
	if Input.is_action_pressed("ui_down"):
		scroll_offset.y += speed * zoom

func _on_GraphEdit_connection_request(from, from_slot, to, to_slot):
	get_node(from).connect("change_output", get_node(to), "_input_changed")
	connect_node(from,from_slot, to, to_slot)

func _on_GraphEdit_disconnection_request(from, from_slot, to, to_slot):
	disconnect_node(from,from_slot, to, to_slot)
	get_node(from).offset += Vector2(0, 0)

func save():
	var save_dict = {
		"filename":get_filename(),
		"class":get_class(),
		"parent":get_parent().get_path(),
		"name":name,
		"scroll_offset":var2str(scroll_offset),
		"zoom":zoom,
		"connection_list":get_connection_list(),
		"signals":get_signal_list()
	}
	return save_dict
