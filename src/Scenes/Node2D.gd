extends Node2D

func _on_AddButton_pressed():
	$AddPopup.visible = !$AddPopup.visible

func _on_FilePopup_ready():
	$FilePopup.call_deferred("popup")
	$FilePopup.call_deferred("hide")

func _on_Save_pressed():
	$FilePopup.mode = FileDialog.MODE_SAVE_FILE
	$FilePopup.visible = !$FilePopup.visible

func _on_Load_pressed():
	$FilePopup.mode = FileDialog.MODE_OPEN_FILE
	$FilePopup.visible = !$FilePopup.visible

func _on_FilePopup_confirmed():
	if $FilePopup.mode == FileDialog.MODE_SAVE_FILE:
		save_game($FilePopup.current_path)
	
	elif $FilePopup.mode == FileDialog.MODE_OPEN_FILE:
		load_game($FilePopup.current_path)

func save_game(path):
	var save = File.new()
	save.open(path, File.WRITE)
	
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for i in save_nodes:
		var node_data = i.call("save");
		save.store_line(to_json(node_data))
	save.close()

func load_game(path):
	var save = File.new()
	print(path)
	if not save.file_exists(path):
		return # Error! We don't have a save to load.
	
#	if not path.ends_with("logic"):
#		return

	# We need to revert the game state so we're not cloning objects during loading. This will vary wildly depending on the needs of a project, so take care with this step.
	# For our example, we will accomplish this by deleting savable objects.
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for i in save_nodes:
		
		if i is GraphEdit:
			i.clear_connections()
		else:
			i.queue_free()

	# Load the file line by line and process that dictionary to restore the object it represents
	save.open(path, File.READ)
	while save.get_position() < save.get_len():
		
		var node_data = parse_json(save.get_line())
		
		# First we need to create the object and add it to the tree and set its position.
		var new_object
		if node_data["filename"] == "":
			if node_data.class == "GraphEdit":
				new_object = $GraphEdit
		else:
			new_object = load(node_data.filename).instance()
			
			if node_data.has("signals"):
				for sgnl in node_data["signals"]:
					sgnl.source.call_deferred("connect", sgnl.signal, sgnl.target, sgnl.method)
		
		if not new_object is GraphEdit:
			get_node(node_data["parent"]).add_child(new_object)
		
		# Now we set the remaining variables.
		for i in node_data.keys():
			if i == "filename" or i == "parent":
				continue
			elif i == "offset" or i == "scroll_offset":
				node_data[i] = str2var(node_data[i])
			elif i == "signals":
				for s in i:
					print(s)
					get_node(i.source).call_deferred("connect", i.signal, i.target, i.method, i.binds)
					#get_node(i.source).connect(i.signal, i.target, i.method, i.binds)
			
			new_object.set(i, node_data[i])
	
	save.close()
	
	save.open(path, File.READ)
	
	while save.get_position() < save.get_len():
		
		var node_data = parse_json(save.get_line())
		
		if node_data["filename"] == "":
			if node_data.class == "GraphEdit":
				for connection in node_data["connection_list"]:
					var from = connection["from"]
					var from_port = connection["from_port"]
					var to = connection["to"]
					var to_port = connection["to_port"]
					$GraphEdit.get_node(from).connect("change_output", $GraphEdit.get_node(to), "_input_changed")
					$GraphEdit.connect_node(from, from_port, to, to_port)
		else:
			pass
	
	save.close()
