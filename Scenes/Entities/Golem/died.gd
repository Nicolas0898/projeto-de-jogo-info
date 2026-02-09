extends BasicEntityDiedState
const GOLEM_DEATH = preload("uid://ctuqqvilh3v2g")

func onStateEntered(_old):
	GameHandler.spawn_coins(character.global_position,15)
	GameHandler.golem_dead = true
	await get_tree().create_timer(0.1).timeout
	super(_old)
	
	for i in range(16):
		var a:RigidBody2D = GOLEM_DEATH.instantiate()
		a.global_position = character.global_position
		var b = randf_range(-100,100)
		a.linear_velocity = Vector2(b,-600)
		a.angular_velocity = b/(PI*10)
		a.rotation_degrees = randf_range(-360,360)
		a.get_node("Sprite2D").frame = i
		create_tween().tween_property(a,"modulate",Color(1,1,1,0),2)
		get_tree().current_scene.add_child(a)
		get_tree().create_timer(4).timeout.connect(func(): if is_instance_valid(a):  a.queue_free())
	
	if get_tree().current_scene.has_node("DOOR"):
		get_tree().current_scene.get_node("DOOR").enabled = false
