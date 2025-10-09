extends Node

@export var current_action : Interactable #parte pra testar mas talvez fique (pro area2d passar resource)
@export var current_area : Node
@onready var action = null

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("up"):
		if Ui.dialogue.current_loaded_dialogue!=null: #Dialogue Handler
			Ui.dialogue.loadNextMessage()
		else:
			active(current_action)
	if event.is_action_pressed("down"):
		if Ui.dialogue.current_loaded_dialogue!=null:
			Ui.dialogue.question_handler(0)
	if event.is_action_pressed("z"):
		if Ui.dialogue.current_loaded_dialogue!=null: #Dialogue Handler
			Ui.dialogue.confirm()

func active(resource : Resource):
	if resource is Interactable:
		resource.activate()
