@tool
extends Button


signal path_chosen(path: String)

@onready var load_dialog: FileDialog = %LoadDialog


func _on_pressed() -> void:
	load_dialog.popup_centered()


func _on_load_dialog_file_selected(path: String) -> void:
	path_chosen.emit(path)
