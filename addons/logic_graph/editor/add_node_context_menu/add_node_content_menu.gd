@tool
class_name LogicGraphAddNodeContextMenu
extends PopupMenu


signal node_scene_chosen(scene: PackedScene)


var scenes: Dictionary = {}  # id : PackedScene


func _ready():
	for child in get_children():
		child.queue_free()
	clear()
	scenes.clear()
	if !id_pressed.is_connected(_on_id_pressed):
		id_pressed.connect(_on_id_pressed)


func add_entries(entries: Dictionary) -> void:
	var entry_id: int = 0
	
	for key in entries:
		var entry: Variant = entries[key]
		if entry is PackedScene:
			add_item(key, entry_id)
			scenes[entry_id] = entry
		
		elif entry is Dictionary:
			var submenu = LogicGraphAddNodeContextMenu.new()
			submenu.node_scene_chosen.connect(_on_submenu_node_scene_chosen)
			add_child(submenu)
			add_submenu_item(key, submenu.name)
			submenu.add_entries(entry)
		
		entry_id += 1


func _on_id_pressed(id: int) -> void:
	var scene: PackedScene = scenes.get(id, null)
	if scene == null:
		return

	node_scene_chosen.emit(scene)


func _on_submenu_node_scene_chosen(scene: PackedScene) -> void:
	node_scene_chosen.emit(scene)
