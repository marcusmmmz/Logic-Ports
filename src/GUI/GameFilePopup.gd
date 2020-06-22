extends FileDialog

func _on_Save_pressed():
	mode = FileDialog.MODE_SAVE_FILE
	visible = !visible
	$Label2.rect_position.y = -48

func _on_Load_pressed():
	mode = FileDialog.MODE_OPEN_FILE
	visible = !visible
	$Label2.rect_position.y = -48

func _on_GameFilePopup_confirmed():
	if mode == FileDialog.MODE_SAVE_FILE:
		get_parent().save_game(current_path)
	
	elif mode == FileDialog.MODE_OPEN_FILE:
		get_parent().load_game(current_path)
