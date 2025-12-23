extends Node

static func act():
	var d = load("res://resource/dialogues/example.tres")
	Ui.dialogue.change_current_dialogue(d)
