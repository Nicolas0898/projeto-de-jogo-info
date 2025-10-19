extends Area2D
class_name InteractionArea

@export var action : Interactable
var player_inside = false;

func _ready() -> void:
	set_collision_mask_value(3,true)

func _on_body_entered(body: Node2D) -> void:
	if body is PlayerCharacter: #SUBSTITUIR POR PLAYER
		InteractionSystem.current_action = action
		InteractionSystem.current_area = self
	#if body is PlayerCharacter:
		#body.interaction_node.resource = action

func _on_body_exited(body: Node2D) -> void:
	if InteractionSystem.current_action == action:
		InteractionSystem.current_action = null
		InteractionSystem.current_area = null
