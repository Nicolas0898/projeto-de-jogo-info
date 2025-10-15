extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body is PlayerCharacter:
		body = body as PlayerCharacter
		
		var tween = create_tween()
		tween.tween_property(GameHandler.Player.camera, "zoom", Vector2(1.8,1.8), 3)


func _on_body_exited(body: Node2D) -> void:
	if body is PlayerCharacter:
		body = body as PlayerCharacter
		
		var tween = create_tween()
		tween.tween_property(GameHandler.Player.camera, "zoom", Vector2(1.3,1.3), 3)
