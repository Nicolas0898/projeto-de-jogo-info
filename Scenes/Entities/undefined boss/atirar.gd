extends State

@onready var sprite : AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var throw_spawn : Node2D = $"../../throw_spawn"
@onready var spear = preload("res://Scenes/Entities/undefined boss/spear.tscn")
@export var jump_height : float
@export var center_target : Node2D
@export var spear_velocity : float
@export var roof_particles : GPUParticles2D
var started = false
var throw = false
var falling = false
var dist
var dir

func onStateEntered(_oldState:State):
	character.blink(0.4,Color(0.0, 0.747, 0.752, 1.0))
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
		var s = spear.instantiate()
		s.roof_particles = roof_particles
		
		if dir == 1: 
			s.rotation = 135
			throw_spawn.position.x = -22 
		else:
			s.rotation = 35 
			throw_spawn.position.x = +22
			
		throw_spawn.add_child(s)
		await get_tree().create_timer(1.5).timeout #TEMPO QUE ELE FICA PARADO
		
		var spear_pos = s.global_position #pra lança sair do node do boss
		s.get_parent().remove_child(s)
		s.global_position = spear_pos
		get_tree().root.add_child(s)
		
		var player_direction = character.global_position.direction_to(GameHandler.Player.global_position)
		s.velocity = spear_velocity * player_direction
		s.get_node("point").emitting = true
		s.active = true
		
		falling = true
		
		sprite.play("atirar_02")
	
	
	#35 graus a lança p esquerda
	#145 graus a lança p direita
	character.default_move()
