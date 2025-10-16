extends BaseWeapon
const LEAF_CAGE = preload("res://Scenes/Player/Habilities/leaf_cage.tscn")

func _ready() -> void:
	super()
	read_from = "magic1"

signal go(value)

func returntoog():
	if character.state_machine.currentState.name == "Core":
		character.remove_core(2)
		
func spritechanged():
	if character.sprite.frame == 8 and character.sprite.animation == "cage":
		go.emit(true)
		
func use():
	if on_cooldown: return
	set_on_cooldown()
	
	go.emit(false)
	character.sprite.animation_finished.disconnect(returntoog)
	character.sprite.frame_changed.disconnect(spritechanged)
	character.set_core(2)
	character.sprite.play("cage")
	
	character.sprite.animation_finished.connect(returntoog)
	
	character.sprite.frame_changed.connect(spritechanged)
	var a = await go
	if not a:return
	character.sprite.frame_changed.disconnect(spritechanged)
	
	
	var dir = -1 if GameHandler.Player.sprite.flip_h else 1
	var instance = LEAF_CAGE.instantiate()
	
	var raycast = RayCast2D.new()
	raycast.target_position = Vector2(dir*100,0)
	raycast.global_position = GameHandler.Player.global_position
	get_tree().current_scene.add_child(raycast)
	raycast.force_raycast_update()
	print(raycast.get_collision_point())
	
	if raycast.get_collider():
		instance.global_position = raycast.get_collision_point() - Vector2(16*dir,0)
	else:
		instance.global_position = GameHandler.Player.global_position + Vector2(100*dir,10)
	
	
	var area2D = Area2D.new()
	var shape = CollisionShape2D.new()
	var rectShape = RectangleShape2D.new()
	rectShape.size = Vector2(230,180)
	shape.shape = rectShape
	area2D.add_child(shape)
	
	area2D.global_position = GameHandler.Player.global_position + Vector2(rectShape.size.x/2,0)*dir
	area2D.set_collision_mask_value(1,false)
	area2D.set_collision_mask_value(2,true)
	get_tree().current_scene.add_child(area2D)


	await get_tree().physics_frame
	await get_tree().physics_frame
	var bodies = area2D.get_overlapping_bodies()
	var body = null
	var destun
	print(bodies)
	if bodies.size() > 0:
		body = bodies[0] as BaseEntity
		
		var sprite2d:AnimatedSprite2D
		
		for child in body.get_children():
			if child is AnimatedSprite2D:
				sprite2d = child
				sprite2d.play("idle")
				break
		
		var proportion = sprite2d.sprite_frames.get_frame_texture(sprite2d.animation,0).get_size().x/32
		
		instance.global_position = body.global_position + Vector2(0,10*proportion)
		instance.scale = Vector2.ONE*proportion
		
		var b = body.state_machine.currentState.name
		body.state_machine.requestStateChange("Stunned")
			
		destun = func():
			print("ASDASDASDSA")
			if not is_instance_valid(body): return
			if body.state_machine.currentState.name == "Stunned":
				body.state_machine.requestStateChange(b)
	
	if not body:
		instance.get_node("Hitbox").monitoring = false
		instance.get_node("StaticBody2D").set_collision_layer_value(1,true)
	
	get_tree().current_scene.add_child(instance)
	var time = 2 if body else 6
	var timer = get_tree().create_timer(time)
	var destroyOnHit = func(_a,origin):
		if origin!=instance.get_node("Hitbox"):
			timer.time_left = 0
	
	if body:
		body.get_node("HealthComponent").damaged.connect(destroyOnHit)
	
	timer.timeout.connect(func():
		character.sprite.animation_finished.disconnect(returntoog)
		if body: destun.call()
		area2D.queue_free()
		if is_instance_valid(body):
			body.get_node("HealthComponent").damaged.disconnect(destroyOnHit)
		create_tween().tween_property(instance,"modulate",Color(1,1,1,0),0.3)
		await get_tree().create_timer(0.3).timeout
		instance.queue_free()
	)
	
