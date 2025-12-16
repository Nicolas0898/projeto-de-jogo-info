extends State

@onready var sprite : AnimatedSprite2D = $"../../AnimatedSprite2D"
@export var jump_height : float
@export var center_target : Node2D
var impact : bool = false
var dir = null
var dist = null

func onStateEntered(_oldState:State):
	sprite.play("perfurar_01")
	
	dist = character.global_position.direction_to(center_target.global_position)
	dir = 1 if dist.x>0 else -1
	
	#character.constant_velocity.teste = Vector2(550 * dir, 0)
	var horizontal = character.create_tween()
	horizontal.tween_property(character, "position:x", center_target.global_position.x, 0.6)
	character.variable_velocity.y = jump_height
	character.default_move()

func onPhysics(_delta:float):
	#print(character.variable_velocity.y)
	if character.variable_velocity.y <= 0:
		character.apply_gravity(_delta)
	elif impact == false:
		impact = true
		await get_tree().create_timer(0.6).timeout #Pausa pro impacto, sla
		
		sprite.play("perfurar_02")
		character.variable_velocity.y = 2000
		
		await get_tree().create_timer(0.3).timeout #Pausa pro impacto, sla
		impact = false
		stateMachine.requestStateChange("idle")
		
	character.default_move()
