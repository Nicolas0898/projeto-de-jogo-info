extends BaseWeapon

func use():
	var size = Vector2(60,15)
	var hitbox = Hitbox.from_rect(5,size)
	
	hitbox.position = character.last_looked_at*size.x*0.8
	add_child(hitbox)
	hitbox.look_at(character.global_position)
	
	
	var hitdir = character.last_looked_at
	hitbox.onHit.connect(func(other):
		var dir = other.global_position.direction_to(character.global_position)
		character.variable_velocity *= Vector2.ONE-abs(hitdir)
		character.variable_velocity += dir*500*abs(hitdir)*Vector2(1.3,1)
		)

	
