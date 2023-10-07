@tool
class_name LogicGraphEditorLoadButton
extends Button


signal path_chosen(path: String)

@export var should_confirm: bool = false

@onready var confirm_discard_dialog: ConfirmationDialog = %ConfirmDiscardDialog
@onready var load_dialog: FileDialog = %LoadDialog


func _on_pressed() -> void:
	if should_confirm:
		confirm_discard_dialog.popup_centered()
	else:
		load_dialog.popup_centered()


func _on_confirm_discard_dialog_confirmed():
	load_dialog.popup_centered()


func _on_load_dialog_file_selected(path: String) -> void:
	path_chosen.emit(path)
