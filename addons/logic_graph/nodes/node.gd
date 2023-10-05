@tool
class_name LogicGraphNode
extends GraphNode


func on_enter() -> void:
	pass


func on_exit() -> void:
	pass


func get_save_data() -> Dictionary:
	return {}


func load_save_data(data: Dictionary) -> void:
	pass


func _on_resize_request(new_minsize: Vector2) -> void:
	size = new_minsize
