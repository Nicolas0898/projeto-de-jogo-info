extends BaseWeapon
const SPEAR = preload("res://Scenes/Player/Weapons/spear.tscn")

func use():
	var size = Vector2(60,15)
	var hitbox = Hitbox.from_rect(5,size)
	
	var sprite = SPEAR.instantiate()
	
	
	hitbox.position = character.last_looked_at*size.x*0.7
	sprite.position = character.last_looked_at
	add_child(hitbox)
	add_child(sprite)
	hitbox.look_at(character.global_position)
	sprite.look_at(character.global_position)
	sprite.rotate(PI)
	sprite.play("default")
	var t = create_tween()
	sprite.modulate = Color(1,1,1,0)
	t.tween_property(sprite,"modulate",Color(1,1,1,1),0.1)
	t.tween_property(sprite,"modulate",Color(1,1,1,0),0.2)
	
	
	sprite.animation_finished.connect(func():
		await t.finished
		sprite.queue_free())
	var hitdir = character.last_looked_at
	hitbox.onHit.connect(func(other):
		var dir = other.global_position.direction_to(character.global_position)
		character.variable_velocity *= Vector2.ONE-abs(hitdir)
		character.variable_velocity += dir*500*abs(hitdir)*Vector2(1.3,1)
		)

	
