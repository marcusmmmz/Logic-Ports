extends Node

var workbench : GraphEdit

func add_gate(gate : Gate):
	workbench.add_child(gate, true)
	gate.offset = workbench.scroll_offset + (workbench.rect_size / 2)
