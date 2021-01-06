extends Control

const project_save_path := "user://projects/"
const module_save_path := "user://modules/"

const gate_types = {
	"logic": ["AND", "OR", "NOT", "NAND", "NOR", "XOR"],
	"io": ["Press", "Toggle", "LED"],
}

func _ready():
	var dir := Directory.new()
	if not dir.dir_exists(project_save_path):
		dir.make_dir(project_save_path)
	if not dir.dir_exists(module_save_path):
		dir.make_dir(module_save_path)

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

func save_module():
	var module_save := ModuleSave.new()
	
	#dummy data for testing
	module_save.data = {
		"name":"Triple AND",
		"dependencies":[],
		"inputs_size":3,
		"outputs_size":1,
		"gates":[
			"AND",
			"AND",
		],
		# negative numbers = comes from the module
		"connections":[
			{"from":-1, "from_slot":0, "to":0, "to_slot":0},
			{"from":-1, "from_slot":1, "to":0, "to_slot":1},
			{"from":0, "from_slot":0, "to":1, "to_slot":0},
			{"from":-1, "from_slot":2, "to":1, "to_slot":1},
			{"from":1, "from_slot":0, "to":-1, "to_slot":0}
		]
	}
	
#	for node in get_tree().get_nodes_in_group("save"):
#		node.save(module_save)
	
	var error := ResourceSaver.save(
		module_save_path + $ProjectName.text + ".tres",
		module_save
	)
	
	$Menu.update_module_list()
