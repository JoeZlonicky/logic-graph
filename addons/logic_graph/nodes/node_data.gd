@tool
class_name LogicGraphNodeData
extends Resource


@export var name: String = ""
@export var position_offset: Vector2 = Vector2.ZERO
@export var custom_data: Dictionary = {}
@export var out_connections: Array[LogicGraphNodeConnectionData] = []

var uid: int = ResourceUID.INVALID_ID
