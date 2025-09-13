extends State

func canChangeState():
	var player:PlayerCharacter = stateMachine.character
	return not player.crouch_cast.get_collider()\
		   and not player.crouch_cast_2.get_collider()

func onPhysics(delta:float):
	var player:PlayerCharacter = stateMachine.character
	player.apply_gravity(delta)
	player.check_for_collisions()
	player.default_player_input()
	player.default_move()
	
	if not Input.is_action_pressed("down") and canChangeState():
		stateMachine.requestStateChange("Running")
	
	if Input.is_action_pressed("jump") and canChangeState():
		stateMachine.requestStateChange("Jump")
		
	if not player.is_on_floor() and canChangeState():
		stateMachine.requestStateChange("Falling")

func onStateEntered(_old):
	var player:PlayerCharacter = stateMachine.character
	player.hitbox.scale = Vector2(1,0.5)
	player.sprite.scale = Vector2(1,0.5)
	player.hurtbox.scale = Vector2(1,0.5)
	player.position.y  += 16
	player.crouch_cast.enabled = true
	player.crouch_cast_2.enabled = true
	player.speed_multiplier = 0.6

func onStateExit():
	var player:PlayerCharacter = stateMachine.character
	player.hitbox.scale = Vector2(1,1)
	player.sprite.scale = Vector2(1,1)
	player.hurtbox.scale = Vector2(1,1)
	player.position.y  -= 16
	player.crouch_cast.enabled = false
	player.crouch_cast_2.enabled = false
	player.speed_multiplier = 1
