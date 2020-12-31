extends Control

const project_save_path := "user://projects/"

func _ready():
	var dir := Directory.new()
	if not dir.dir_exists(project_save_path):
		dir.make_dir(project_save_path)

func save_project():
	var project_save := ProjectSave.new()
	
	project_save.data.gates = []
	
	for node in get_tree().get_nodes_in_group("save"):
		node.save(project_save)
	
	var error := ResourceSaver.save(
		project_save_path + $ProjectName.text + ".tres",
		project_save
	)
	
	$Menu.update_project_list()

func load_project(file : String):
	
	#insecure, change later
	$WorkBench.clear_connections()
	for child in $WorkBench.get_children():
		if child is GraphNode:
			child.free()
	
	print( load( project_save_path + file ) )
	var project_save : ProjectSave = load( project_save_path + file )
	
	for gate in project_save.data.gates:
		var gate_node = load(gate.filename).instance()
		
		for key in gate.keys():
			var value = gate[key]
			
			match key:
				"filename":
					continue
				"offset":
					value = str2var(value)
			
			gate_node.set(key, value)
		
		$WorkBench.add_child(gate_node)
	
	for key in project_save.data.graph_edit.keys():
		var value = project_save.data.graph_edit[key]
		
		match key:
			"connection_list":
				for cnn in value:
					$WorkBench.call_deferred("_on_WorkBench_connection_request", cnn.from, cnn.from_port, cnn.to, cnn.to_port)
			"scroll_offset":
				value = str2var(value)
			_:
				$WorkBench.set(key, value)
	
	$ProjectName.text = file.trim_suffix(".tres")
