@tool
extends LogicGraphNode


@onready var text_edit: TextEdit = %TextEdit

func on_enter() -> void:
	var game: Game = Globals.game
	game.play_dialogue(text_edit.text)
	game.next_dialogue.connect(_on_game_next_dialogue, CONNECT_ONE_SHOT)

func get_save_data() -> Dictionary:
	return {"text": text_edit.text}

func load_save_data(data: Dictionary) -> void:
	text_edit.text = data.get("text", "")

func _on_game_next_dialogue():
	var next: StringName = get_first_connection()
	if next == "":
		var game: Game = Globals.game
		game.close_dialogue()
	
	get_graph().transition(next)
