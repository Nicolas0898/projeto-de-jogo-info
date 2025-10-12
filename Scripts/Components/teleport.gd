extends Area2D
class_name Teleport

@onready var timer: Timer = $Timer
@export var actual_level: String
@export var destination_level: String
@export var spawn_direction = "right"

func _on_body_entered(body: Node2D) -> void:
	if body is PlayerCharacter:
		body = body as PlayerCharacter
		timer.start()
		print("Entrou")

func _on_timer_timeout() -> void:
	NavigationManager.go_to_level(actual_level,destination_level)
