@tool
class_name LogicGraphNodeData
extends Resource


@export var name: StringName = ""
@export var position_offset: Vector2 = Vector2.ZERO
@export var size: Vector2 = Vector2.ZERO
@export var custom_data: Dictionary = {}
@export var type_uid_path: String = "uid://<invalid>"
@export var out_connections: Array[LogicGraphNodeConnectionData] = []
