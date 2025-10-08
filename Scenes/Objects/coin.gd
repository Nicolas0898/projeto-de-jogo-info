extends RigidBody2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerCharacter:
		body = body as PlayerCharacter
		self.queue_free()
		GameHandler.collect_coin(1)
