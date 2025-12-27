extends State

@onready var spear_trail  = preload("res://Scenes/Entities/undefined boss/trail_particle.tscn")
@onready var portal_trail = preload("res://Scenes/Entities/undefined boss/trail_bite.tscn")
@onready var spear = preload("res://Scenes/Entities/undefined boss/spear.tscn")
@onready var soul = preload("res://Scenes/Entities/undefined boss/soul/soul.tscn")
@onready var sprite : AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var throw_spawn : Node2D = $"../../throw_spawn"
@onready var a_01: GPUParticles2D = $"../../Particles/a01"
@onready var a_02: GPUParticles2D = $"../../Particles/a02"
@onready var glow: PointLight2D = $"../../glow"
@onready var hurtbox: Hurtbox = $"../../Hurtbox"
@export var jump_height : float
@export var center_target : Node2D
@export var spear_velocity : float
@export var black_bg : Sprite2D
@export var soul_spawn : Node
#@export var roof_particles : GPUParticles2D
var started = false
var throw = false
var falling = false
var dist
var dir
var souls_left = 3
var s
var trail : GPUParticles2D
var trail_follow = false

func onStateEntered(_oldState:State):
	character.blink(0.4,Color(0.968, 0.849, 0.0, 1.0))
	if center_target != null: #Sprite virando pro centro
		if center_target.global_position.x > character.global_position.x: sprite.flip_h = true
		else : sprite.flip_h = false
	
	await get_tree().create_timer(0.4).timeout
	
	
	started = true
	sprite.play("atirar_01")
	
	if center_target != null: 
		dist = character.global_position.direction_to(center_target.global_position)
		dir = 1 if dist.x>0 else -1
	
	if center_target != null:
		var horizontal = character.create_tween() 
		horizontal.tween_property(character, "position:x", center_target.global_position.x, 0.6)
	character.variable_velocity.y = jump_height
	character.default_move()

func onPhysics(_delta:float):
	if not started: return
	if character.variable_velocity.y <= 0 or falling:
		character.apply_gravity(_delta)
	elif throw == false:
		throw = true
		character.variable_velocity.y = 2
		s = spear.instantiate()
		trail = spear_trail.instantiate()
		#s.roof_particles = roof_particles
		
		if dir == 1: 
			s.rotation = 135
			throw_spawn.position.x = -22 
		else:
			s.rotation = 35 
			throw_spawn.position.x = +22
			
		throw_spawn.add_child(s)
		s.on_middle.connect(on_middle)
		
		var t = create_tween()
		var t2 = create_tween()
		t.tween_property(black_bg, "modulate", Color(1.0, 1.0, 1.0, 0.6), 3)
		t2.tween_property(s, "modulate", Color(2.454, 2.454, 2.454, 1.0), 1.5)
		a_02.emitting = true
		GameHandler.Player.camera.screen_shake(15, 4, 3, 0.6)
		hurtbox.set_collision_layer_value(1, false)
		await get_tree().create_timer(3.5).timeout #TEMPO QUE ELE FICA PARADO
		
		var te = create_tween()
		te.tween_property(black_bg, "modulate", Color(1.0, 1.0, 1.0, 0.3), 0.5)
		var spear_pos = s.global_position #pra lança sair do node do boss
		s.get_parent().remove_child(s)
		s.global_position = spear_pos
		get_tree().root.add_child(s)
		get_tree().root.add_child(trail)
		trail_follow = true
		trail_spawn()
		
		var player_direction = character.global_position.direction_to(GameHandler.Player.global_position)
		s.velocity = spear_velocity * player_direction
		s.spear_velocity = spear_velocity
		s.trail = trail
		
		#s.get_node("point").emitting = true
		s.active = true
		falling = true
		
		a_02.emitting = false
		sprite.play("atirar_02")
		
		await get_tree().create_timer(0.4).timeout #Parte que ele fica com o escudo
		
		for node in soul_spawn.get_children():
			var so = soul.instantiate()
			node.add_child(so)
			so.state_machine.get_node("Died").warning.connect(warning)
		
		
		glow.modulate = Color(1, 1, 1, 1)
		a_01.emitting = true
		sprite.play("atirar_03")
	
	
	#35 graus a lança p esquerda
	#145 graus a lança p direita
	if trail_follow: trail.global_position = s.global_position
	character.default_move()

func warning(): #Avisar que o soul fragment foi quebrado
	if souls_left > 0: 
		souls_left -= 1
	
	if souls_left == 0: 
		souls_left = 3
		returning()

func trail_spawn(): #portais que causam dano p krlh-
	while trail_follow == true:
		var t = portal_trail.instantiate()
		t.global_position = s.global_position
		t.scale = Vector2(0.7, 0.7)
		t.modulate = Color(1.022, 1.27, 1.27, 1.0)
		get_tree().root.add_child(t)
		await get_tree().create_timer(0.4).timeout

func returning(): #Para a lança voltar ao meio
	s.return_to(center_target.global_position)

func on_middle():
	trail_follow = false
	await get_tree().create_timer(0.4).timeout
	
	glow.modulate = Color(1, 1, 1, 0)
	a_01.emitting = false
	sprite.play("atirar_04")
	
	character.variable_velocity.y = jump_height
	character.default_move()
	
	hurtbox.set_collision_layer_value(1, true)
	await get_tree().create_timer(0.2).timeout
	s.queue_free()
	
	await get_tree().create_timer(0.7).timeout
	
	started = false
	throw = false
	falling = false
	
	stateMachine.requestStateChange("idle")
