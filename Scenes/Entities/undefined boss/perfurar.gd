extends State

@onready var sprite : AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var impact_spawn = $"../../impact_spawn"
@onready var i01 = $"../../Particles/i01"
@onready var i02 = $"../../Particles/i02"
@onready var impact_hitbox = preload("res://Scenes/Entities/undefined boss/impact.tscn")
@export var jump_height : float
@export var center_target : Node2D
@export var roof_particles : GPUParticles2D
var impact : bool = false
var dir = null
var dist = null
var started = false
var hitbox = null

func onStateEntered(_oldState:State):
	character.blink(0.4,Color(1.057, 1.057, 1.057, 1.0))
	if center_target != null: #Sprite virando pro centro
		if center_target.global_position.x > character.global_position.x: sprite.flip_h = true
		else : sprite.flip_h = false
	
	await get_tree().create_timer(0.4).timeout
	
	
	started = true
	sprite.play("perfurar_01")
	
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
	elif impact == false:
		impact = true
		await get_tree().create_timer(0.6).timeout #Pausa pro impacto, sla
		
		sprite.play("perfurar_02")
		character.variable_velocity.y = 2000
		
		await get_tree().create_timer(0.1).timeout #Pausa pro impacto, sla
		
		hitbox = impact_hitbox.instantiate()
		impact_spawn.add_child(hitbox)
		i01.emitting = true
		i02.emitting = true
		if roof_particles != null:
			roof_particles.emitting = true
		GameHandler.Player.camera.screen_shake(30, 0.3)
		
		await get_tree().create_timer(0.3).timeout #Pausa pro impacto, sla
		
		impact = false
		started = false
		
		hitbox.queue_free()
		stateMachine.requestStateChange("idle")
		
	character.default_move()
