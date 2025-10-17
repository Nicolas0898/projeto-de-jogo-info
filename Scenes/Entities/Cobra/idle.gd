extends State

func onPhysics(delta:float):
	character.constant_velocity.walk = Vector2.ZERO
	if not GameHandler.Player: return
	var dist = character.global_position.distance_to(GameHandler.Player.global_position)
	character.apply_gravity(delta)
	character.default_move()
	
	if dist < 75:
		stateMachine.requestStateChange("Chase")

func onStateEntered(_old):
	character.get_node("Sprite").play("idle")
