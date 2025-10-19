extends RigidBody2D

func _ready() -> void:
	if GameHandler.roomswocoins.find("Jungle/"+get_tree().current_scene.name) != -1:
		queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerCharacter:
		body = body as PlayerCharacter
		self.queue_free()
		GameHandler.collect_coin(1)
