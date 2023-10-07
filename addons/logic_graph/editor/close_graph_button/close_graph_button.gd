@tool
extends Button


signal confirmed


@onready var confirm_dialog: ConfirmationDialog = %ConfirmDialog


func _on_pressed() -> void:
	confirm_dialog.popup_centered()


func _on_confirm_dialog_confirmed() -> void:
	confirmed.emit()
