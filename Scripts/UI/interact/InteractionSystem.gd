extends Node
const INTERACTION_PANEL = preload("uid://bp3o2i8u5huij")

@export var current_action : Interactable #Ação recebida pelo Area2D
@export var current_area : Area2D:
	set(n):
		if not panel or panel.get_parent() == null:
			panel = INTERACTION_PANEL.instantiate()
			panel.scale = Vector2(0.5,0.5)
			panel.modulate = Color(1,1,1,0)
			get_tree().current_scene.add_child(panel)
		current_area = n
		if n!=null:
			panel.global_position = n.global_position + Vector2(-panel.size.x/2.0 * panel.scale.x,-20)
			get_tree().create_tween().tween_property(panel,"modulate",Color(1,1,1,1),0.2)
		else:
			get_tree().create_tween().tween_property(panel,"modulate",Color(1,1,1,0),0.2)
@onready var action = null #Ação que o jogador está executando

var panel:Panel

	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
			active(current_action)
			return

func active(resource : Resource):
	if resource is Interactable:
		resource.activate()
		current_action = null
		current_area   = null
	
