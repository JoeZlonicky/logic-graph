@tool
class_name LogicGraphEditorCloseGraphButton
extends Button


signal close_triggered

@export var should_confirm: bool = true

@onready var confirm_dialog: ConfirmationDialog = %ConfirmDialog


func _on_pressed() -> void:
	if should_confirm:
		confirm_dialog.popup_centered()
	else:
		close_triggered.emit()


func _on_confirm_dialog_confirmed() -> void:
	close_triggered.emit()
