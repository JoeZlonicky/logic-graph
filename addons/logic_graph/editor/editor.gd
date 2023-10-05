@tool
extends Control


const DIALOGUE_NODE_SCENE: PackedScene = preload("res://addons/logic_graph/nodes/dialogue/dialogue.tscn")

var open_file_path: String = ""

@onready var graph: LogicGraph = %Graph
@onready var confirm_clear_dialog: ConfirmationDialog = %ConfirmClearDialog
@onready var new_graph_confirm_discard_dialog: ConfirmationDialog = %NewGraphConfirmDiscardDialog
@onready var create_graph_dialog: FileDialog = %CreateGraphDialog
@onready var save_dialog: FileDialog = %SaveDialog
@onready var open_file_label: Label = %OpenFileLabel

@onready var buttons_that_started_disabled: Array = [
	$VBoxContainer/Banner/MarginContainer/Buttons/SaveButton,
	$VBoxContainer/Banner/MarginContainer/Buttons/SaveAsButton,
	$VBoxContainer/Banner/MarginContainer/Buttons/ClearButton
]


func _ready() -> void:
	graph.hide()
	for button in buttons_that_started_disabled:
		button.disabled = true


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			var mouse_pos: Vector2 = get_viewport().get_mouse_position()
			var spawn_position: Vector2 = mouse_pos + graph.scroll_offset - graph.global_position
			spawn_position /= graph.zoom
			
			graph.add_node(DIALOGUE_NODE_SCENE, spawn_position)


func reset_view() -> void:
	graph.zoom = 1
	graph.scroll_offset = Vector2.ZERO


func _on_clear_button_pressed() -> void:
	confirm_clear_dialog.popup_centered()


func _on_confirm_clear_dialog_confirmed() -> void:
	graph.clear_all_nodes_and_connections()
	graph.add_start_node()


func _on_new_graph_button_pressed() -> void:
	if graph.visible:
		new_graph_confirm_discard_dialog.popup_centered()
	else:
		create_graph_dialog.popup_centered()


func _on_confirm_new_graph_dialog_confirmed() -> void:
	create_graph_dialog.popup_centered()


func _on_create_graph_dialog_file_selected(path: String) -> void:
	open_file_path = path
	open_file_label.text = path
	graph.clear_all_nodes_and_connections()
	graph.add_start_node()
	graph.show()
	for button in buttons_that_started_disabled:
		button.disabled = false
	reset_view()


func _on_save_button_pressed() -> void:
	trigger_save()


func _on_save_dialog_file_selected(path: String) -> void:
	save_graph(path)


func auto_save() -> void:
	if graph.get_child_count() == 1:  # Don't auto save just start node
		return
	
	#trigger_save()


func trigger_save() -> void:
	if open_file_path != "":
		save_graph(open_file_path)
	else:
		save_dialog.popup_centered()


func save_graph(path: String) -> void:
	var graph_data: LogicGraphData = graph.create_save_data()
	var result: Error = ResourceSaver.save(graph_data, path)
	if result != Error.OK:
		print("Error saving logic graph")
	else:
		open_file_path = path
		open_file_label.text = path.get_file()
		print("Logic graph saved")


func _on_save_as_button_pressed() -> void:
	save_dialog.popup_centered()
