extends State
@onready var sprite : AnimatedSprite2D = $"../../AnimatedSprite2D"


func onStateEntered(_oldState:State):
	character.blink(0.4,Color(1.0, 0.0, 1.0, 1.0))
	await get_tree().create_timer(0.4).timeout
	
	sprite.play("trail_01")
