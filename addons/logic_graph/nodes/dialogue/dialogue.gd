@tool
extends LogicGraphNode


@onready var text_edit: TextEdit = %TextEdit


func get_save_data() -> Dictionary:
	return {"text": text_edit.text}


func load_save_data(data: Dictionary) -> void:
	text_edit.text = data.get("text", "")
	
