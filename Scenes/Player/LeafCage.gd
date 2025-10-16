extends BaseWeapon
const LEAF_CAGE = preload("res://Scenes/Player/Habilities/leaf_cage.tscn")

func _ready() -> void:
	read_from = "magic1"

func use():
	var dir = -1 if GameHandler.Player.sprite.flip_h else 1
	var instance = LEAF_CAGE.instantiate()
	instance.global_position = GameHandler.Player.global_position + Vector2(dir*100,10)
	
	var area2D = Area2D.new()
	var shape = CollisionShape2D.new()
	var rectShape = RectangleShape2D.new()
	rectShape.size = Vector2(500,200)
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
			
		var destun = func():
			if not is_instance_valid(body): return
			if body.state_machine.currentState.name == "Stunned":
				body.state_machine.requestStateChange(b)
		
		
		get_tree().current_scene.add_child(instance)
		var timer = get_tree().create_timer(2)
		var destroyOnHit = func(_a,origin):
			if origin!=instance.get_node("Hitbox"):
				timer.time_left = 0
		
		body.get_node("HealthComponent").damaged.connect(destroyOnHit)
		
		timer.timeout.connect(func():
			if body: destun.call()
			if is_instance_valid(body):
				body.get_node("HealthComponent").damaged.disconnect(destroyOnHit)
			create_tween().tween_property(instance,"modulate",Color(1,1,1,0),0.3)
			await get_tree().create_timer(0.3).timeout
			instance.queue_free()
		)
	
