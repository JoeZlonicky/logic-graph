class_name LogicGraphContainer
extends Node


const LOGIC_GRAPH_SCENE: PackedScene = preload("res://addons/logic_graph/graph/graph.tscn")

var graph: LogicGraph = null

@export var data: LogicGraphData


func _ready() -> void:
	if data == null:
		return
	
	graph = LOGIC_GRAPH_SCENE.instantiate()
	add_child(graph)
	graph.hide()
	graph.load_from_data(data)


func run() -> void:
	if graph:
		graph.start()
