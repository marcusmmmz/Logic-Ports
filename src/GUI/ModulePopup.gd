extends Popup

onready var FilePopup = $"../FileDialog"

func _on_ModuleButton_pressed():
	visible = !visible

func _on_SaveModule_pressed():
	hide()
	FilePopup.mode = FileDialog.MODE_SAVE_FILE
	FilePopup.requester = FilePopup.requesters.MODULE
	if !FilePopup.visible:
		FilePopup.popup_centered()

func _on_LoadModule_pressed():
	hide()
	FilePopup.mode = FileDialog.MODE_OPEN_FILE
	FilePopup.requester = FilePopup.requesters.MODULE
	if !FilePopup.visible:
		FilePopup.popup_centered()
