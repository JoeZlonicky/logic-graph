@tool
class_name LogicGraphStartNode
extends LogicGraphNode


func on_enter() -> void:
	print("Start")
	get_graph().transition(get_first_connection())
