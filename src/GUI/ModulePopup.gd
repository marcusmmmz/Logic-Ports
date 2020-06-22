extends Popup

onready var ModuleFilePopup = $"../ModuleFilePopup"

func _on_ModuleFilePopup_ready():
	call_deferred("popup")
	call_deferred("hide")

func _on_ModuleButton_pressed():
	visible = !visible

func _on_SaveModule_pressed():
	visible = false
	$"../ModuleFilePopup".mode = FileDialog.MODE_SAVE_FILE
	$"../ModuleFilePopup".visible = !$"../ModuleFilePopup".visible
	$"../ModuleFilePopup/Label2".rect_position.y = -48

func _on_LoadModule_pressed():
	visible = false
	$"../ModuleFilePopup".mode = FileDialog.MODE_OPEN_FILE
	$"../ModuleFilePopup".visible = !$"../ModuleFilePopup".visible
	$"../ModuleFilePopup/Label2".rect_position.y = -48

func _on_ModuleFilePopup_confirmed():
	if $"../ModuleFilePopup".mode == FileDialog.MODE_SAVE_FILE:
		save_module($"../ModuleFilePopup".current_path)
	
	elif $"../$ModuleFilePopup".mode == FileDialog.MODE_OPEN_FILE:
		load_module($"../ModuleFilePopup".current_path)

func save_module(path):
	pass

func load_module(path):
	pass
