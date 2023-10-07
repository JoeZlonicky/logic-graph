@tool
extends Button


signal path_chosen(path: String)


@onready var save_as_dialog: FileDialog = %SaveAsDialog


func _on_pressed() -> void:
	save_as_dialog.popup_centered()


func _on_save_as_dialog_file_selected(path: String) -> void:
	path_chosen.emit(path)
