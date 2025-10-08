extends State
var player:PlayerCharacter

func onPhysics(delta:float):
	var player:PlayerCharacter = stateMachine.character
	player.default_player_input()
	player.apply_gravity(delta)
	player.check_for_collisions()
	player.default_move()
	
	player.sprite.play("idle")
	
	if not player.is_on_floor() : stateMachine.requestStateChange("Falling")
	if Input.is_action_pressed("jump"):stateMachine.requestStateChange("Jump")
	#if Input.is_action_pressed("down"):stateMachine.requestStateChange("Crouching")

func onInput(event:InputEvent):
	if not is_zero_approx(Input.get_axis("left","right")):
		stateMachine.requestStateChange("Running")
