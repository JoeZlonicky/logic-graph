@tool
class_name LogicGraphEditor
extends Control


const DIALOGUE_NODE_SCENE: PackedScene = preload("res://addons/logic_graph/nodes/dialogue/dialogue.tscn")

var open_file_path: String = ""

@onready var graph: LogicGraph = %Graph

@onready var open_file_label: Label = %OpenFileLabel
@onready var save_failed_dialog: AcceptDialog = %SaveFailedDialog
@onready var load_failed_dialog: AcceptDialog = %LoadFailedDialog

@onready var enable_only_for_active_graph: Array = [
	%SaveButton,
	%SaveAsButton,
	%ClearButton,
	%CloseGraphButton
]


func _ready() -> void:
	set_graph_enabled(false)


func _on_graph_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			var mouse_pos: Vector2 = get_viewport().get_mouse_position()
			var spawn_position: Vector2 = mouse_pos + graph.scroll_offset - graph.global_position
			spawn_position /= graph.zoom
			
			graph.add_node(DIALOGUE_NODE_SCENE, spawn_position)


func set_graph_enabled(enable: bool = true) -> void:
	graph.visible = enable
	for button in enable_only_for_active_graph:
		button.disabled = !enable


func reset_view() -> void:
	graph.zoom = 1
	graph.scroll_offset = Vector2.ZERO


func reset_graph() -> void:
	graph.clear_all_nodes_and_connections()
	graph.add_start_node()


func new_graph(path: String) -> void:
	_set_open_file_path(path)
	reset_graph()
	reset_view()
	set_graph_enabled(true)


func save_open_graph() -> void:
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
	if result != OK:
		save_failed_dialog.popup_centered()
		return
	
	_set_open_file_path(path)
	print("Saved logic graph")


func load_graph(path: String) -> void:
	var res: LogicGraphData = load(path)
	if res == null:
		load_failed_dialog.popup_centered()
		return
	
	graph.load_from_data(res)
	_set_open_file_path(path)
	set_graph_enabled(true)
	reset_view()


func close_graph() -> void:
	reset_graph()
	set_graph_enabled(false)


func _set_open_file_path(path: String) -> void:
	open_file_path = path
	open_file_label.text = path.get_file()
