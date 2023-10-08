@tool
class_name LogicGraphAddNodeContextMenu
extends PopupMenu


signal node_scene_chosen(scene: PackedScene)


class MenuSection:
	var entries: Dictionary
	var popup: PopupMenu
	
	func _init(entries_, popup_):
		entries = entries_
		popup = popup_


const ENTRIES: Dictionary = {
	"Dialogue": preload("res://addons/logic_graph/nodes/dialogue/dialogue.tscn"),
	"Folder": {
		"Test": preload("res://addons/logic_graph/nodes/dialogue/dialogue.tscn")
	}
}

var index_mapping: Dictionary = {}  # index : packed scene


func _ready():
	for child in get_children():
		child.queue_free()
	index_mapping.clear()
	
	var section_stack: Array[MenuSection] = []
	var current_section: MenuSection = MenuSection.new(ENTRIES, self)
	var entry_index: int = 0
	
	while current_section:
		for key in current_section.entries:
			var entry = current_section.entries[key]
			if entry is PackedScene:
				current_section.popup.add_item(key, entry_index)
				index_mapping[entry_index] = entry
			
			elif entry is Dictionary:
				var submenu = PopupMenu.new()
				submenu.index_pressed.connect(_on_index_pressed)
				current_section.popup.add_child(submenu)
				current_section.popup.add_submenu_item(key, submenu.name)
				section_stack.append(MenuSection.new(entry, submenu))
			entry_index += 1
		
		if section_stack.is_empty():
			break
		
		current_section = section_stack.pop_front()


func _on_index_pressed(index):
	var scene: PackedScene = index_mapping.get(index, null)
	if scene == null:
		return
	
	node_scene_chosen.emit(scene)
