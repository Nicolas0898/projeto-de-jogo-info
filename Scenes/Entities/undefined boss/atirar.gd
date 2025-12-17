extends State

@onready var sprite : AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var throw_spawn : Node2D = $"../../throw_spawn"
@onready var spear = preload("res://Scenes/Entities/undefined boss/spear.tscn")
@export var jump_height : float
@export var center_target : Node2D
var started = false
var throw = false
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
	if character.variable_velocity.y <= 0:
		character.apply_gravity(_delta)
	elif throw == false:
		throw = true
		character.variable_velocity.y = 2
		var s = spear.instantiate()
		if dir == 1: 
			s.rotation = 135
			throw_spawn.position.x = -22 
		else:
			s.rotation = 35 
			throw_spawn.position.x = +22
		throw_spawn.add_child(s)
		
		
	
	#35 graus a lança p esquerda
	#145 graus a lança p direita
	character.default_move()
