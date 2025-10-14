extends Node

@export var current_action : Interactable #Ação recebida pelo Area2D
@export var current_area : Node
@onready var action = null #Ação que o jogador está executando
# i = inventario
# d = dialogo

func _input(event: InputEvent) -> void:
	
	if event.is_action_pressed("up"):
		if action is Dialogue: Ui.dialogue.question_handler(1)
	if event.is_action_pressed("down"):
		if action is Dialogue: Ui.dialogue.question_handler(0)
	
	if event.is_action_pressed("interact"):
		if action is Dialogue:
			Ui.dialogue.loadNextMessage()
			#Ui.dialogue.confirm()
		elif action == null:
			active(current_action)
			return
			
		if action is Confirm: Ui.confirm.input()
		if action is Inventory: Ui.inventory.interact()
	
	if event.is_action_pressed("inventory"): Ui.inventory.input()

#func _physics_process(delta: float) -> void:
	#print(action)

func active(resource : Resource):
	if resource is Interactable:
		resource.activate()
