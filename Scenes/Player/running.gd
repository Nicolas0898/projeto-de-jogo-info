extends State

func onPhysics(delta:float):
	var player:PlayerCharacter = stateMachine.character
	player.apply_gravity(delta)
	player.check_for_collisions()
	player.default_player_input()
	player.default_move()
	
	if is_zero_approx(Input.get_axis("left","right")):
		stateMachine.requestStateChange("Idle")
		
	if not player.is_on_floor() : stateMachine.requestStateChange("Falling")
	if Input.is_action_pressed("jump"):stateMachine.requestStateChange("Jump")
	if Input.is_action_pressed("down"):stateMachine.requestStateChange("Crouching")
