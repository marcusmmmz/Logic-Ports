extends GraphNode

class_name Module

var inputs : Array

var outputs : Array
signal change_output

func _input_changed(port, new_value):
	process()

func process():
	pass

func _on_Module_close_request():
	offset += Vector2(0, 0)
	queue_free()

func save():
	var save_dict = {
		"filename":get_filename(),
		"parent":get_parent().get_path(),
		"name":name,
		"title":title,
		"offset":var2str(offset),
		"signals":[get_signal_connection_list("change_output")]
	}
	return save_dict
