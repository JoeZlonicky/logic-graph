@tool
extends EditorPlugin


const EDITOR_SCENE: PackedScene = preload("res://addons/logic_graph/editor/editor.tscn")

var editor_instance: LogicGraphEditor = null


func _enter_tree():
	editor_instance = EDITOR_SCENE.instantiate()
	get_editor_interface().get_editor_main_screen().add_child(editor_instance)
	_make_visible(false)


func _exit_tree():
	if editor_instance != null:
		editor_instance.queue_free()


func _save_external_data() -> void:
	if editor_instance != null:
		editor_instance.save_open_graph()


func _has_main_screen() -> bool:
	return true


func _make_visible(visible: bool):
	if editor_instance != null:
		editor_instance.visible = visible


func _get_plugin_name():
	return "LogicGraph"


func _get_plugin_icon():
	return get_editor_interface().get_base_control().get_theme_icon("GraphNode", "EditorIcons")
