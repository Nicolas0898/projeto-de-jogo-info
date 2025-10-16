extends Area2D

@onready var timer: Timer = $Timer

func _on_body_entered(body: Node2D) -> void:
	if body is PlayerCharacter:
		body = body as PlayerCharacter
		timer.start()
		print("Entrou")
		Ui.set_transition(true)

func _on_timer_timeout() -> void:
	NavigationManager.go_to_level("jungle/final_room","jungle/room_1")
