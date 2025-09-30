extends Node

@export var current_action : Interactable #parte pra testar mas talvez fique (pro area2d passar resource)
@export var current_area : Node
@onready var action = null
# i = inventario
# d = dialogo


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("up"):
		if action is Dialogue: Ui.dialogue.loadNextMessage()
		elif action == null:active(current_action)
	
	if event.is_action_pressed("down"):
		if action is Dialogue: Ui.dialogue.question_handler(0)
	
	if event.is_action_pressed("z"):
		if action is Dialogue: Ui.dialogue.confirm()
	
	if event.is_action_pressed("i"): Ui.inventory.input()

#func _physics_process(delta: float) -> void:
	#print(action)

func active(resource : Resource):
	if resource is Interactable:
		resource.activate()
