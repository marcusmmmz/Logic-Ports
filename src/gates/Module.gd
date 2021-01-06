class_name Module
extends Gate

var model : ModuleSave

func _ready():
	title = model.data.name

func setup_io():
	setup_module()
	.setup_io()

func setup_module():
	inputs_size = model.data.inputs_size
	outputs_size = model.data.outputs_size

func process():
	pass
