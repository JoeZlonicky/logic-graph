class_name Game
extends Node2D


signal next_dialogue

const TIME_PER_CHARACTER: float = 0.05

var is_playing_dialogue: bool = false
var is_current_finished: bool = false
var timer: float = 0.0

@onready var dialogue_panel: Panel = $Dialogue/Panel
@onready var dialogue_label: Label = %DialogueLabel
@onready var graph_container: LogicGraphContainer = $LogicGraphContainer
@onready var fps_label: Label = %FPSLabel


func _ready() -> void:
	Globals.game = self
	dialogue_panel.hide()


func _process(delta: float) -> void:
	fps_label.text = str(Engine.get_frames_per_second())
	
	if is_current_finished == true:
		return
	
	timer += delta
	while timer > TIME_PER_CHARACTER:
		timer -= TIME_PER_CHARACTER
		dialogue_label.visible_characters += 1
		if dialogue_label.visible_characters >= dialogue_label.text.length():
			is_current_finished = true
			break


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if is_playing_dialogue:
			if is_current_finished:
				next_dialogue.emit()
			else:
				dialogue_label.visible_characters = dialogue_label.text.length()
				is_current_finished = true
		else:
			graph_container.run()


func play_dialogue(text: String):
	dialogue_label.text = text
	dialogue_label.visible_characters = 0
	timer = 0.0
	is_current_finished = false
	is_playing_dialogue = true
	dialogue_panel.show()


func close_dialogue():
	dialogue_panel.hide()
