extends State
@onready var cooldown: Timer = $Cooldown
var can_charge = true

func onPhysics(delta:float):
	var plrChar:PlayerCharacter = GameHandler.Player
	var dist = character.global_position.direction_to(plrChar.global_position + Vector2(0,-10))
	character.constant_velocity.walk = character.constant_velocity.walk.lerp(dist*120,15*delta)
	character.apply_air_friction()
	character.default_move()
	
	if plrChar.global_position.distance_to(character.global_position)<75\
	and can_charge :
		stateMachine.requestStateChange("Charge")
		can_charge = false
		cooldown.start()
		
	#print(cooldown.time_left,can_charge)
	
	character.get_node("Sprite").flip_h =\
	character.global_position.direction_to(plrChar.global_position).x > 0

func onStateEntered(_old):
	character.constant_velocity.walk = Vector2.ZERO
	character.get_node("Sprite").play("Running")
	
func timeout():
	can_charge = true
