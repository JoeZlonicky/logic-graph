@tool
class_name LogicGraphEditor
extends Control


var open_file_path: String = ""
var has_unsaved_changes: bool = false

@onready var graph: LogicGraph = %Graph
@onready var open_file_label: Label = %OpenFileLabel

@onready var save_failed_dialog: AcceptDialog = %SaveFailedDialog
@onready var load_failed_dialog: AcceptDialog = %LoadFailedDialog
@onready var add_node_context_menu: LogicGraphAddNodeContextMenu = %AddNodeContentMenu

@onready var enable_only_for_active_graph: Array = [
	%SaveButton,
	%SaveAsButton,
	%ClearButton,
	%CloseGraphButton
]

@onready var should_confirm_if_unsaved_changes: Array = [
	%NewGraphButton,
	%LoadButton,
	%CloseGraphButton
]


func _ready() -> void:
	set_graph_enabled(false)
	remove_unsaved_changes_mark()
	add_node_context_menu.add_entries(LogicGraphNodeList.get_nodes())
	for button in should_confirm_if_unsaved_changes:
		assert("should_confirm" in button, "Button is missing should_confirm property")


func _on_graph_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			_spawn_add_node_context_menu_at_mouse_position()


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
	mark_unsaved_changes()


func new_graph(path: String) -> void:
	reset_graph()
	reset_view()
	set_graph_enabled(true)
	_set_open_file_path(path)
	remove_unsaved_changes_mark()


func save_open_graph() -> void:
	if graph.visible == false:
		return
	
	if !has_unsaved_changes and FileAccess.file_exists(open_file_path):
		return
	
	save_graph(open_file_path)


func save_graph(path: String) -> void:
	# Need to load it like this to get cached resource to update in editor
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
	remove_unsaved_changes_mark()
	print("Saved logic graph")


func load_graph(path: String) -> void:
	var res: LogicGraphData = load(path) as LogicGraphData
	if res == null:
		load_failed_dialog.popup_centered()
		return
	
	graph.load_from_data(res)
	_set_open_file_path(path)
	set_graph_enabled(true)
	reset_view()
	remove_unsaved_changes_mark()
	print("Loaded logic graph")


func close_graph() -> void:
	reset_graph()
	set_graph_enabled(false)
	_set_open_file_path("")
	remove_unsaved_changes_mark()


func mark_unsaved_changes() -> void:
	if has_unsaved_changes:
		return
	
	open_file_label.text = "*" + open_file_path.get_file()
	has_unsaved_changes = true
	for button in should_confirm_if_unsaved_changes:
		button.should_confirm = true


func remove_unsaved_changes_mark() -> void:
	open_file_label.text = open_file_path.get_file()
	has_unsaved_changes = false
	for button in should_confirm_if_unsaved_changes:
		button.should_confirm = false


func _spawn_add_node_context_menu_at_mouse_position() -> void:
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	var spawn_position: Vector2 = mouse_pos + graph.scroll_offset - graph.global_position
	spawn_position /= graph.zoom
	
	add_node_context_menu.popup(Rect2(mouse_pos, Vector2(200, 200)))
	if add_node_context_menu.node_scene_chosen.is_connected(graph.add_node):
		add_node_context_menu.node_scene_chosen.disconnect(graph.add_node)
	add_node_context_menu.node_scene_chosen.connect(graph.add_node.bind(spawn_position),
		CONNECT_ONE_SHOT)


func _set_open_file_path(path: String) -> void:
	open_file_path = path
	open_file_label.text = path.get_file()
