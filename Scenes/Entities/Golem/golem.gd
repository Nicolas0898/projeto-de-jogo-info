extends BaseEntity
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func rotate_to_plr():
	var plr = GameHandler.Player
	if plr.global_position.x > global_position.x:
		sprite.flip_h = true
	else : sprite.flip_h = false
