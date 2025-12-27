extends State

@onready var sprite = $"../../AnimatedSprite2D"

func onStateEntered(_old):
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(character, "modulate", Color(1, 1, 1, 1), 0.5)
	tween.tween_property(character, "scale", Vector2(1, 1), 0.5)
	sprite.play("default") 
