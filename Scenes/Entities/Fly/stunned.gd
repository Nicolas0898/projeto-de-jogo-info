extends State
class_name DefaultEntityStun
@export var aerial := false

func onPhysics(delta):
	character.clear_constant_velocity()
	character.check_for_collisions()
	if aerial:
		character.apply_air_friction()
	else:
		character.apply_gravity(delta)
	character.default_move()
	
	for child in character.get_children():
		if child is AnimatedSprite2D:
			if child.sprite_frames.has_animation("idle"):
				child.play("idle")
			break
