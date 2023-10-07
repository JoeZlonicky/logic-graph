@tool
class_name LogicGraphStartNode
extends LogicGraphNode


func on_enter() -> void:
	get_graph().transition(get_first_connection())
