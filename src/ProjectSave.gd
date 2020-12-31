class_name ProjectSave
extends Resource

export var data := {
	"gates": [],
	"graph_edit": {}
}
export var game_version : String = ProjectSettings.get_setting("application/config/version")
