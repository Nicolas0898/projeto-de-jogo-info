extends BaseWeapon
const SPEAR = preload("res://Scenes/Player/Weapons/spear.tscn")

var timer:Timer
var charged_start:Timer
var is_charged = false
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
	Crosshair.current.requestStateChange("charged_attack",2)
	character.blink(0.3,"#ffffff")
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
		default_attack()

func default_attack():
	#character.sprite.playAnimation("spearattack",1)
	var size = Vector2(40,15)
	
	var damagemult = 1
	if is_charged: damagemult = 1.5
		
	
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
		character.variable_velocity += character.get_local_mouse_position().normalized()*500
	
	
	sprite.animation_finished.connect(func():
		await t.finished
		sprite.queue_free())
	var hitdir = Crosshair.look
	hitbox.onHit.connect(func(other):
		if other is Bell: return
		character.health_component.heal(1)
		var dir = other.global_position.direction_to(character.global_position).normalized()
		var mult = 1
		if is_charged: mult = 2
		character.variable_velocity *= Vector2.ONE-abs(hitdir)*mult
		character.variable_velocity.y += min((dir*300*abs(hitdir)).y,0)*mult
		character.constant_velocity.attack_knockback = Vector2(dir.x*170*mult,0)
		timer.start()
	)

func timeout():
	create_tween().tween_method(setvelo,character.constant_velocity.attack_knockback.x,0,0.1)
