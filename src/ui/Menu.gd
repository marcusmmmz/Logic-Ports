extends Panel

func _ready():
	update_project_list()
	update_gate_list()
	$UserPath.text = OS.get_user_data_dir()

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
		var path = file
		projects[file] = path
	
	for project in projects.keys():
		var project_path = projects[project]
		
		spawn_button(
			$HBox/Projects/VBox, 
			load("res://src/ui/ProjectButton.tscn"),
			project,
			project_path
		)

func update_gate_list():
	var gate_types = {
		"Logic": {
			"AND":"res://src/gates/logic/AND.tscn",
			"OR":"res://src/gates/logic/OR.tscn",
			"NOT":"res://src/gates/logic/NOT.tscn",
			"NAND":"res://src/gates/logic/NAND.tscn",
			"NOR":"res://src/gates/logic/NOR.tscn",
			"XOR":"res://src/gates/logic/XOR.tscn"
		},
		"IO": {
			"Press Button":"res://src/gates/io/Press.tscn",
			"Toggle Button":"res://src/gates/io/Toggle.tscn",
			"LED":"res://src/gates/io/LED.tscn"
		},
	}
	
	for gate_type in gate_types.keys():
		
		var label_instance := Label.new()
		label_instance.text = gate_type
		label_instance.align = Label.ALIGN_CENTER
		label_instance.valign = Label.VALIGN_CENTER
		label_instance.rect_min_size = Vector2(32, 32)
		label_instance.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		
		$HBox/Gates/VBox.add_child(label_instance)
		
		for gate in gate_types[gate_type].keys():
			var gate_path = gate_types[gate_type][gate]
			
			spawn_button(
				$HBox/Gates/VBox,
				load("res://src/ui/GatesButton.tscn"),
				gate,
				gate_path
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
