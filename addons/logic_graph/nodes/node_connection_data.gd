@tool
class_name LogicGraphNodeConnectionData
extends Node


@export var from_port: int
@export var to_node: StringName
@export var to_port: int


func _init(from_port_: int, to_node_: StringName, to_port_: int):
	from_port = from_port_
	to_node = to_node_
	to_port = to_port_
