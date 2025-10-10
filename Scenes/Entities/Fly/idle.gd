extends State

func onPhysics(delta:float):
	var dist = character.global_position.distance_to(GameHandler.Player.global_position)
	character.apply_air_friction()
	
	if dist < 175:
		stateMachine.requestStateChange("Chase")

func onStateEntered(_old):
	character.get_node("Sprite").play("Idle")
