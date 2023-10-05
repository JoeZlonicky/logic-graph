@tool
extends Control


const DIALOGUE_NODE_SCENE: PackedScene = preload("res://addons/logic_graph/nodes/dialogue/dialogue.tscn")

var open_file_path: String = ""

@onready var graph: LogicGraph = %Graph
@onready var confirm_clear_dialog: ConfirmationDialog = %ConfirmClearDialog
@onready var new_graph_confirm_discard_dialog: ConfirmationDialog = %NewGraphConfirmDiscardDialog
@onready var create_graph_dialog: FileDialog = %CreateGraphDialog
@onready var save_as_dialog: FileDialog = %SaveAsDialog
@onready var open_file_label: Label = %OpenFileLabel
@onready var load_dialog: FileDialog = %LoadDialog

@onready var buttons_that_start_disabled: Array = [
	$VBoxContainer/Banner/MarginContainer/Buttons/SaveButton,
	$VBoxContainer/Banner/MarginContainer/Buttons/SaveAsButton,
	$VBoxContainer/Banner/MarginContainer/Buttons/ClearButton
]


func _ready() -> void:
	disable_graph()


func reset_view() -> void:
	graph.zoom = 1
	graph.scroll_offset = Vector2.ZERO


func disable_graph() -> void:
	graph.hide()
	for button in buttons_that_start_disabled:
		button.disabled = true


func enable_graph() -> void:
	graph.show()
	for button in buttons_that_start_disabled:
		button.disabled = false


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
	enable_graph()
	reset_view()


func _on_save_button_pressed() -> void:
	trigger_save()


func _on_save_as_dialog_file_selected(path: String) -> void:
	save_graph(path)


func trigger_save() -> void:
	if graph.visible:
		save_graph(open_file_path)


func save_graph(path: String) -> void:
	# Need to load it like this to get updates to trigger for the cached editor version
	var res: LogicGraphData = null
	if ResourceLoader.exists(path):
		res = ResourceLoader.load(path)
	else:
		res = LogicGraphData.new()
	
	var graph_data: LogicGraphData = graph.create_save_data()
	res.node_data = graph_data.node_data
	
	var result: Error = ResourceSaver.save(graph_data, path)
	if result != Error.OK:
		print("Error saving logic graph")
	else:
		open_file_path = path
		open_file_label.text = path.get_file()
		print("Logic graph saved")


func load_graph(path: String) -> void:
	var res: LogicGraphData = load(path)
	if res != null:
		graph.load_from_data(res)
		open_file_path = path
		open_file_label.text = path.get_file()
		enable_graph()
		reset_view()
	else:
		print("Failed to load logic graph")


func _on_save_as_button_pressed() -> void:
	save_as_dialog.popup_centered()


func _on_graph_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			var mouse_pos: Vector2 = get_viewport().get_mouse_position()
			var spawn_position: Vector2 = mouse_pos + graph.scroll_offset - graph.global_position
			spawn_position /= graph.zoom
			
			graph.add_node(DIALOGUE_NODE_SCENE, spawn_position)


func _on_load_button_pressed() -> void:
	load_dialog.popup_centered()


func _on_load_dialog_file_selected(path: String) -> void:
	load_graph(path)
