extends State

func onPhysics(_delta:float):
	var plrChar:PlayerCharacter = GameHandler.Player
	#var dist = character.global_position.direction_to(plrChar.global_position)
	#character.constant_velocity.walk = dist*120
	character.apply_air_friction()
	character.default_move()
	
	character.get_node("Sprite").flip_h =\
	character.global_position.direction_to(plrChar.global_position).x > 0

func onStateEntered(_old):
	var og = character.get_node("BaseHurtbox").knockback_multiplier
	character.get_node("BaseHurtbox").knockback_multiplier = 0
	
	var plrChar:PlayerCharacter = GameHandler.Player
	
	create_tween().tween_method(speed_t,character.constant_velocity.walk,Vector2.ZERO,0.5)
	character.get_node("Sprite").play("Charge")
	character.blink(0.5,"#ffffff",0.5)
	await get_tree().create_timer(0.4).timeout
	if stateMachine.currentState!= self: return
	character.get_node("Sprite").play("Running")
	var dir = character.global_position.direction_to(plrChar.global_position)
	character.variable_velocity+=dir*530
	await get_tree().create_timer(0.3).timeout
	if stateMachine.currentState!= self: return
	character.get_node("BaseHurtbox").knockback_multiplier = og
	stateMachine.requestStateChange("Chase")

func speed_t(v):
	character.constant_velocity.walk = v
