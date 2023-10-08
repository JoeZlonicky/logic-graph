@tool
class_name LogicGraphNode
extends GraphNode


signal modified

var outward_connections: Array[LogicGraphNodeConnectionData] = []


func on_enter() -> void:
	pass


func on_exit() -> void:
	pass


func get_save_data() -> Dictionary:
	return {}


func load_save_data(data: Dictionary) -> void:
	pass


func get_graph() -> LogicGraph:
	return get_parent() as LogicGraph


func get_first_connection() -> StringName:
	if outward_connections.is_empty():
		return ""
	return outward_connections.front().to_node


func _on_resize_request(new_minsize: Vector2) -> void:
	size = new_minsize
	modified.emit()


func add_outward_connection(from_port: int, to_node: StringName, to_port: int):
	outward_connections.append(LogicGraphNodeConnectionData.new(from_port, to_node, to_port))


func remove_outward_connection(from_port: int, to_node: StringName, to_port: int):
	for i in outward_connections.size():
		var c: LogicGraphNodeConnectionData = outward_connections[i]
		if c.from_port == from_port and c.to_node == to_node and c.to_port == to_port:
			outward_connections.remove_at(i)
			break


func _on_dragged(_from: Vector2, _to: Vector2) -> void:
	modified.emit()
