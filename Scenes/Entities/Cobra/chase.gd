extends State

@onready var timer: Timer = $Timer
@onready var ray_cast_2d: RayCast2D = $"../../RayCast2D"

var can_bite = true

func onPhysics(delta:float):
	var plrChar:PlayerCharacter = GameHandler.Player
	var dist = character.global_position.direction_to(plrChar.global_position)
	var dir = 1 if dist.x>0 else -1
	character.constant_velocity.walk = character.constant_velocity.walk.lerp(Vector2(100*dir,0),10*delta)
	character.apply_gravity(delta)
	character.check_for_collisions()
	ray_cast_2d.target_position = Vector2(16*dir,0)
	if ray_cast_2d.get_collider():
		character.variable_velocity.y=-300
	character.default_move()
	
	if plrChar.global_position.distance_to(character.global_position)<50\
	and can_bite :
		can_bite = false
		timer.start()
		print("Passou canbite")
		stateMachine.requestStateChange("Bite")
		
		
	#print(cooldown.time_left,can_bite)
	
	character.get_node("Sprite").flip_h =\
	character.global_position.direction_to(plrChar.global_position).x < 0

func onStateEntered(_old):
	character.constant_velocity.walk = Vector2.ZERO
	character.get_node("Sprite").play("walk")
	
func on_timer_timeout():
	can_bite = true
	print("passou")
