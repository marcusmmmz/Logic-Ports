extends FileDialog

enum requesters {
	PROJECT
	MODULE
}

var requester = requesters.PROJECT setget set_requester

func set_requester(new_value):
	requester = new_value
	var text = ""
	
	if mode == MODE_SAVE_FILE:
		text += "Save a "
	elif mode == MODE_OPEN_FILE:
		text += "Open a "
	
	if requester == requesters.PROJECT:
		text += "Project"
	elif requester == requesters.MODULE:
		text += "Module"
	
	window_title = text

func _on_FileDialog_confirmed():
	if mode == MODE_SAVE_FILE:
		if requester == requesters.PROJECT:
			get_parent().save_project(current_path)
		else:
			pass
	
	elif mode == MODE_OPEN_FILE:
		if requester == requesters.PROJECT:
			get_parent().load_project(current_path)
		else:
			pass
