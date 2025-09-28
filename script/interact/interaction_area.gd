extends Area2D
class_name InteractionArea

@export var action : Interactable
var player_inside = false;

func _on_body_entered(body: Node2D) -> void:
	InteractionSystem.current_action = action
	InteractionSystem.current_area = self
	#if body is PlayerCharacter:
		#body.interaction_node.resource = action

func _on_body_exited(body: Node2D) -> void:
	if InteractionSystem.current_action == action:
		InteractionSystem.current_action = null
		InteractionSystem.current_area = null
