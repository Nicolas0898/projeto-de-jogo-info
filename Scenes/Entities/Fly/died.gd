extends State
const FLY_BODY = preload("res://Scenes/Entities/Fly/fly_body.tscn")
func onPhysics(delta:float):
	character.apply_air_friction()
	character.default_move()


func onStateEntered(_old):
	GameHandler.spawn_coins(character.global_position,5)
	stateMachine.lockstate = true
	character.variable_velocity*=10
	create_tween().tween_method(speed_t,character.constant_velocity.walk,Vector2.ZERO,2)
	var sprite = character.get_node("Sprite") as AnimatedSprite2D
	sprite.play("Died")
	await sprite.animation_finished
	var body = FLY_BODY.instantiate()
	body.global_position = sprite.global_position
	body.linear_velocity = Vector2(randf_range(-100,100),-300)
	body.angular_velocity = -10 if body.linear_velocity.x < 0 else 10
	body.get_node("Sprite").flip_h = sprite.flip_h
	get_tree().current_scene.add_child(body)
	character.queue_free()
	
func speed_t(v):
	character.constant_velocity.walk = v
