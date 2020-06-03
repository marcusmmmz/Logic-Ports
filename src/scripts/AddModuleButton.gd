extends Button

var Graph

func get_graph():
	var node = get_parent()
	while not node is Node2D:
		node = node.get_parent()
	
	for child in node.get_children():
		if child is GraphEdit:
			Graph = child

func _ready():
	get_graph()

func _pressed():
	var module
	
	#Logic
	if name == "AND":
		module = load("res://src/modules/Logic/AndModule.tscn")
	elif name == "OR":
		module = load("res://src/modules/Logic/OrModule.tscn")
	elif name == "NOT":
		module = load("res://src/modules/Logic/NotModule.tscn")
	
	#IO
	if name == "PULSE":
		module = load("res://src/modules/IO/PulseButton.tscn")
	elif name == "TOGGLE":
		module = load("res://src/modules/IO/ToggleButton.tscn")
	elif name == "LIGHT":
		module = load("res://src/modules/IO/LightBulb.tscn")
	
	if Graph == null:
		get_graph()
	
	Graph.add_child(module.instance())
