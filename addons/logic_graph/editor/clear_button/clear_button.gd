@tool
class_name LogicGraphEditorClearButton
extends Button


signal clear_triggered

@onready var confirm_dialog: ConfirmationDialog = %ConfirmDialog


func _on_pressed() -> void:
	confirm_dialog.popup_centered()


func _on_confirm_dialog_confirmed() -> void:
	clear_triggered.emit()
