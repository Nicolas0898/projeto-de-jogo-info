extends State

@onready var timer: Timer = $Timer

func onPhysics(delta:float):
	var plrChar:PlayerCharacter = GameHandler.Player
	var dist = character.global_position.direction_to(plrChar.global_position + Vector2(0,-10))
	character.constant_velocity.walk = character.constant_velocity.walk.lerp(dist*120,15*delta)
	character.apply_air_friction()
	character.default_move()
	
	character.get_node("Sprite").flip_h =\
	character.global_position.direction_to(plrChar.global_position).x > 0
	
	if plrChar.global_position.distance_to(character.global_position)<50:
		character.get_node("Sprite").play("bite")
		await character.get_node("Sprite").animation_finished
		character.get_node("Sprite").flip_h =\
		character.global_position.direction_to(plrChar.global_position).x > 0
		
		character.get_node("Sprite").play("opening_mouth")
		await character.get_node("Sprite").animation_finished
		character.get_node("Sprite").flip_h =\
		character.global_position.direction_to(plrChar.global_position).x > 0
		
		character.get_node("Sprite").play("chase")
		
	character.get_node("Sprite").flip_h =\
	character.global_position.direction_to(plrChar.global_position).x > 0

func onStateEntered(_old):
	character.constant_velocity.walk = Vector2.ZERO
	character.get_node("Sprite").play("opening_mouth")
	await character.get_node("Sprite").animation_finished
	character.get_node("Sprite").play("chase")
