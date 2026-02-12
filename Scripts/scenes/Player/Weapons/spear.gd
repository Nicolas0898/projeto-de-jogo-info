extends BaseWeapon
const SPEAR = preload("res://Scenes/Player/Weapons/spear.tscn")
const SMEAR_FRAMES = preload("uid://cm3ri7qyxtw8v")
const CHARGE = preload("uid://6itq3v3mqj7a")
const HEAVYHIT = preload("uid://dvwauk2vkbf5f")
const BASEIMPACT = preload("uid://qflm7bpdrk3m")

var timer:Timer
var charged_start:Timer
var is_charged = false
var vfx = null
func setvelo(x):
	character.constant_velocity.attack_knockback = Vector2(x,0)

func _ready() -> void:
	super()
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = 0.07
	timer.one_shot = true
	timer.timeout.connect(timeout)
	
	charged_start = Timer.new()
	add_child(charged_start)
	charged_start.wait_time = 0.8
	charged_start.one_shot = true
	charged_start.timeout.connect(charged_start_timeout)

func charged_start_timeout ():
	if not active: return
	Crosshair.current.cache = {"time":0.6}
	Crosshair.atkrange = Vector2(200,200)
	Crosshair.current.requestStateChange("charged_attack",2)
	character.blink(0.3,"#ffffff")
	vfx = CHARGE.instantiate()
	GameHandler.play_particle_one(vfx)
	character.add_child(vfx)
	is_charged = true
		
func use():
	if on_cooldown: return
	is_charged = false
	active = true
	charged_start.start()
	default_attack()
	
func use_end():
	charged_start.stop()
	Crosshair.current.backToCore(2)
	if not active: return
	active = false
	if is_charged:
		if vfx : 
			vfx.emitting = false
			vfx = null
		GameHandler.spawn_particle(BASEIMPACT,Vector2.ZERO,character)
		default_attack()

func default_attack():
	#character.sprite.playAnimation("spearattack",1)
	var size = Vector2(40,15)
	
	var damagemult = 1
	if is_charged: damagemult = 3
		
	
	var hitbox = Hitbox.from_rect(damage*damagemult,size)
	
	var center = Node2D.new()
	center.position = Vector2(size.x/2,0);
	center.name = "center"
	hitbox.add_child(center)
	
	var sprite = SPEAR.instantiate()
	set_on_cooldown()
	
	hitbox.position = Crosshair.look*size.x*0.7
	sprite.position = Crosshair.look
	add_child(hitbox)
	add_child(sprite)
	hitbox.look_at(character.global_position)
	sprite.look_at(character.global_position)
	sprite.rotate(PI)
	sprite.play("default")
	var t = create_tween()
	sprite.modulate = Color(1,1,1,0)
	t.tween_property(sprite,"modulate",Color(1,1,1,1),0.2)
	t.tween_property(sprite,"modulate",Color(1,1,1,0),0.1)
	
	if is_charged:
		var target = Crosshair.current.get_closest_enemy_from_area()
		
		character.variable_velocity += Crosshair.look*500*Vector2(1,0.1)
		var smear:AnimatedSprite2D = SMEAR_FRAMES.instantiate()
		var targetpos
		if target:
			targetpos = target.global_position + character.global_position.direction_to(target.global_position).normalized() * 20
		else:
			targetpos = character.to_global(Crosshair.look*20)
		smear.global_position = character.global_position
		get_tree().current_scene.add_child(smear)
		smear.look_at(targetpos)
		smear.scale.x = character.global_position.distance_to(targetpos)/128
		hitbox.rotation = smear.rotation
		hitbox.global_position = smear.global_position
		hitbox.scale.x = character.global_position.distance_to(targetpos)/40 
		
		#print(smear.rotation)
		if abs(smear.rotation)>=(PI/2):
			smear.flip_v = true
		smear.reset_physics_interpolation()
		character.global_position = targetpos
		#create_tween().tween_property(character,"global_position",targetpos,0.05)
		
		
		
	else:
		character.variable_velocity += Crosshair.look*200*Vector2(1,0)
	
	
	sprite.animation_finished.connect(func():
		await t.finished
		sprite.queue_free())
	var hitdir = Crosshair.look
	hitbox.onHit.connect(func(other):
		if other is Bell: return
		
		
		character.health_component.heal(1)
		var dir = other.global_position.direction_to(character.global_position).normalized()
		var mult = 1
		if is_charged:
			mult = 0
			Engine.time_scale = 0.1
			Ui.player_ui.register_hit(0.07)
			var t2 = create_tween()
			t2.set_trans(Tween.TRANS_BACK)
			t2.set_ease(Tween.EASE_OUT)
			t2.tween_property(Engine,"time_scale",1,0.5)
			GameHandler.spawn_particle(HEAVYHIT,other.global_position)
		else:
			Ui.player_ui.register_hit()
			
		character.variable_velocity *= Vector2.ONE-abs(hitdir)*mult
		character.variable_velocity.y += min((dir*300*abs(hitdir)).y,0)*mult
		character.constant_velocity.attack_knockback = Vector2(dir.x*170*mult,0)
		timer.start()
	)

func timeout():
	create_tween().tween_method(setvelo,character.constant_velocity.attack_knockback.x,0,0.1)
