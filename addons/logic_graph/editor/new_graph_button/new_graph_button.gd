@tool
extends Button


signal path_chosen(path: String)

@export var graph: LogicGraph = null

@onready var confirm_discard_dialog: ConfirmationDialog = %ConfirmDiscardDialog
@onready var create_graph_dialog: FileDialog = %CreateGraphDialog


func _on_pressed() -> void:
	if graph == null:
		return
	
	if graph.visible:
		confirm_discard_dialog.popup_centered()
	else:
		create_graph_dialog.popup_centered()


func _on_confirm_discard_dialog_confirmed() -> void:
	create_graph_dialog.popup_centered()


func _on_create_graph_dialog_file_selected(path: String) -> void:
	path_chosen.emit(path)
