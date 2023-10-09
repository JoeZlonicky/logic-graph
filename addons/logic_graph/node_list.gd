@tool
class_name LogicGraphNodeList
extends Node


# Format:
# {
#   String: PackedScene
#   String: {
#     String: PackedScene
#     String: {
#       ...
#   }
# }

static func get_nodes() -> Dictionary:
	var nodes: Dictionary = {
		"Folder": {
			"Dialogue": preload("res://example_nodes/dialogue/dialogue.tscn")
		},
		"Dialogue": preload("res://example_nodes/dialogue/dialogue.tscn")
	}
	return nodes
