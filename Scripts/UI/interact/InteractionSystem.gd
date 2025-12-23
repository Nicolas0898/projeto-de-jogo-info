extends Node

@export var current_action : Interactable #Ação recebida pelo Area2D
@export var current_area : Node
@onready var action = null #Ação que o jogador está executando
# i = inventario
# d = dialogo

func _input(event: InputEvent) -> void:
	
	if event.is_action_pressed("up"):
		if action is Dialogue: 
			if Ui.dialogue.is_question: Ui.dialogue.question_handler(1)
	if event.is_action_pressed("down"):
		if action is Dialogue: 
			if Ui.dialogue.is_question: Ui.dialogue.question_handler(1)
	if event.is_action_pressed("left"):
		if action is Bestiary: Ui.bestiary_node.pass_page("left")
	if event.is_action_pressed("right"):
		if action is Bestiary: Ui.bestiary_node.pass_page("right")
	
	#if event.is_action_pressed("use_weapon"):
		#if action is Inventory: Ui.inventory.interact()
	
	if event.is_action_pressed("interact"):
		#if action is Bestiary:
			#Ui.bestiary_node.open()
		#if action is Map and Ui.map_node.is_open: 
			#Ui.map_node.deactivate()
		if action is Dialogue:
			if Ui.dialogue.is_question: Ui.dialogue.confirm()
			else:  Ui.dialogue.loadNextMessage()
		elif action == null:
			active(current_action)
			return
		
		#if action is Confirm: Ui.confirm.input()
		#if action is Inventory: Ui.inventory.interact()	

func active(resource : Resource):
	if resource is Interactable:
		resource.activate()
	
