@tool
class_name LogicGraph
extends GraphEdit


const START_NODE_SCENE: PackedScene = preload("res://addons/logic_graph/nodes/start/start_node.tscn")
const START_NODE_DEFAULT_POSITION = Vector2(200, 250)

var start_node: LogicGraphNode = null
var current_node: LogicGraphNode = null
var node_map: Dictionary = {}  # StringName : LogicGraphNode


func add_node(node_scene: PackedScene, position_offset: Vector2 = Vector2.ZERO) -> LogicGraphNode:
	var node: LogicGraphNode = node_scene.instantiate()
	add_child(node)
	node_map[node.name] = node
	node.position_offset = position_offset
	node.close_request.connect(_on_delete_nodes_request.bind([node.name]))
	return node


func remove_node(node_name: StringName) -> void:
	var node: Node = node_map[node_name]
	_remove_all_connections_to_node(node_name)
	node_map.erase(node_name)
	remove_child(node)
	node.queue_free()


func add_start_node() -> void:
	if start_node != null:
		return
	
	add_node(START_NODE_SCENE, START_NODE_DEFAULT_POSITION)


func clear_all_nodes_and_connections() -> void:
	start_node = null
	clear_connections()
	for child in get_children():
		if child is LogicGraphNode:
			node_map.erase(child.name)
			remove_child(child)
			child.queue_free()


func start() -> void:
	transition(start_node.name)


func end() -> void:
	transition("")


func transition(to: StringName) -> void:
	if current_node != null:
		current_node.on_exit()
	
	current_node = node_map.get(to, null)
	if current_node != null:
		current_node.on_enter()


func create_save_data() -> LogicGraphData:
	var data = LogicGraphData.new()
	for child in get_children():
		if child is LogicGraphNode:
			var node_data = LogicGraphNodeData.new()
			var scene_path: String = child.scene_file_path
			
			node_data.name = child.name
			node_data.position_offset = child.position_offset
			node_data.type_uid = ResourceLoader.get_resource_uid(scene_path)
			node_data.custom_data = child.get_save_data()
			node_data.out_connections = child.outward_connections.duplicate()
			data.node_data.append(node_data)
	
	return data


func load_from_data(data: LogicGraphData):
	pass


func _remove_all_connections_to_node(node_name: StringName) -> void:
	for c in get_connection_list():
		if c.to == node_name or c.from == node_name:
			disconnect_node(c.from, c.from_port, c.to, c.to_port)
		if c.to == node_name:
			var node: LogicGraphNode = node_map[c.from]
			node.remove_outward_connection(c.from_port, c.to, c.to_port)


# Nodes should be StringNames but editor doesn't like that static typing :(
func _on_delete_nodes_request(nodes: Array) -> void:
	# Only nodes that have a close button are given
	for node_name in nodes:
		remove_node(node_name)


func _on_connection_request(from_node: StringName, from_port: int, to_node: StringName,
		to_port: int) -> void:
	connect_node(from_node, from_port, to_node, to_port)
	var node: LogicGraphNode = node_map[from_node]
	node.add_outward_connection(from_port, to_node, to_port)


func _on_disconnection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	disconnect_node(from_node, from_port, to_node, to_port)
	var node: LogicGraphNode = node_map[from_node]
	node.remove_outward_connection(from_port, to_node, to_port)
