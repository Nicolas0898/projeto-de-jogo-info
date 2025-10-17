extends State

func onStateEntered(_old):
	var sprite = character.get_node("Sprite") as AnimatedSprite2D
	sprite.play("die")
	await sprite.animation_finished
	print("morreu")
	character.queue_free()
