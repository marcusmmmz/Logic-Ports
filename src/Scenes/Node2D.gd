extends Control

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
	if not save.file_exists(path):
		return # Error! We don't have a save to load.

	# We need to revert the game state so we're not cloning objects during loading. This will vary wildly depending on the needs of a project, so take care with this step.
	# For our example, we will accomplish this by deleting savable objects.
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for i in save_nodes:
		
		if i is GraphEdit:
			i.clear_connections()
		elif i is Module:
			#it's so it doesn't conflict with the
			#save node names
			i.name = str(1)
			
			i.queue_free()
		else:
			print_debug("something's wrong")

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
		
		if not new_object is GraphEdit:
			get_node(node_data["parent"]).add_child(new_object)
		
		# Now we set the remaining variables.
		for i in node_data.keys():
			if i == "filename" or i == "parent":
				continue
			elif i == "offset" or i == "scroll_offset":
				node_data[i] = str2var(node_data[i])
			elif i == "connection_list":
				for cnn in node_data[i]:
					$GraphEdit.call_deferred("_on_GraphEdit_connection_request", cnn.from, cnn.from_port, cnn.to, cnn.to_port)
			
			new_object.set(i, node_data[i])
	
	save.close()
