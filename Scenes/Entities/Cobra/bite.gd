extends State
@onready var hitbox_2: Hitbox = $"../../Hitbox2"
@onready var hitbox_3: Hitbox = $"../../Hitbox3"

func onPhysics(delta:float):
	var plrChar:PlayerCharacter = GameHandler.Player
	var dist = character.global_position.direction_to(plrChar.global_position)
	#character.constant_velocity.walk = dist*120
	character.apply_gravity(delta)
	character.default_move()
	
	character.get_node("Sprite").flip_h =\
	character.global_position.direction_to(plrChar.global_position).x < 0

func onStateEntered(_old):
	var plrChar:PlayerCharacter = GameHandler.Player
	
	var sprite = character.get_node("Sprite") as AnimatedSprite2D
	sprite.play("bite")
	hitbox_2.set_collision_mask_value(5,true)
	hitbox_3.set_collision_mask_value(5,true)
	character.get_node("Sprite").flip_h =\
	character.global_position.direction_to(plrChar.global_position).x < 0
	await sprite.animation_finished
	hitbox_2.set_collision_mask_value(5,false)
	hitbox_3.set_collision_mask_value(5,false)
	stateMachine.requestStateChange("Chase")
