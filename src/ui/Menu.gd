extends Panel

func _ready():
	update_lists()
	$UserPath.text = OS.get_user_data_dir()

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_FOCUS_IN:
		update_lists()

func update_lists():
	update_project_list()
	update_gate_list()
	update_module_list()

func dir_contents(path):
	var output := []
	var dir := Directory.new()
	
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name := dir.get_next()
		
		while file_name != "":
			if file_name == "." or file_name == "..":
				file_name = dir.get_next()
				continue
			
			output.append(file_name)
			file_name = dir.get_next()
	
	return output

func update_project_list():
	for child in $HBox/Projects/VBox.get_children():
		if not child is Label:
			child.queue_free()
	
	var projects := {}
	for file in dir_contents("user://projects/"):
		projects[file] = file
	
	for project in projects.keys():
		var project_path = projects[project]
		
		spawn_button(
			$HBox/Projects/VBox, 
			load("res://src/ui/ProjectButton.tscn"),
			project,
			project_path
		)

func update_gate_list():
	var gate_types = get_parent().gate_types
	
	for gate_type in gate_types.keys():
		
		var label_instance := Label.new()
		label_instance.text = gate_type
		label_instance.align = Label.ALIGN_CENTER
		label_instance.valign = Label.VALIGN_CENTER
		label_instance.rect_min_size = Vector2(32, 32)
		label_instance.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		
		$HBox/Gates/VBox.add_child(label_instance)
		
		for gate in gate_types[gate_type]:
			
			spawn_button(
				$HBox/Gates/VBox,
				load("res://src/ui/GatesButton.tscn"),
				gate,
				"res://src/gates/"+gate_type+"/"+gate+".tscn"
			)

func update_module_list():
	for child in $HBox/Modules/VBox.get_children():
		if not child is Label:
			child.queue_free()
	
	var modules := {}
	for file in dir_contents("user://modules/"):
		modules[file] = file
	
	for module in modules.keys():
		var module_path = modules[module]
		
		spawn_button(
			$HBox/Modules/VBox, 
			load("res://src/ui/ModuleButton.tscn"),
			module,
			get_parent().module_save_path + module_path
		)

func on_button_pressed():
	if !(Input.is_key_pressed(KEY_CONTROL) or Input.is_key_pressed(KEY_SHIFT)):
		hide()

func spawn_button(parent_node : Node, button : PackedScene, text : String, path : String):
	var button_instance := button.instance()
	button_instance.text = text
	button_instance.load_path = path
	
	button_instance.connect("pressed", self, "on_button_pressed")
	
	parent_node.add_child( button_instance )
