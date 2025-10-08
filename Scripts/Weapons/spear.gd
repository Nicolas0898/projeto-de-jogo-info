extends BaseWeapon
const SPEAR = preload("res://Scenes/Player/Weapons/spear.tscn")

var timer:Timer
func setvelo(x):
	character.constant_velocity.attack_knockback = Vector2(x,0)

func _ready() -> void:
	super()
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = 0.07
	timer.one_shot = true
	timer.timeout.connect(timeout)

func use():
	if on_cooldown: return
	var size = Vector2(40,15)
	var hitbox = Hitbox.from_rect(5,size)
	
	var sprite = SPEAR.instantiate()
	set_on_cooldown()
	
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
		var dir = other.global_position.direction_to(character.global_position).normalized()
		character.variable_velocity *= Vector2.ONE-abs(hitdir)
		character.variable_velocity.y += (dir*300*abs(hitdir)).y
		character.constant_velocity.attack_knockback = Vector2(dir.x*170,0)
		timer.start()
	)

func timeout():
	create_tween().tween_method(setvelo,character.constant_velocity.attack_knockback.x,0,0.1)
