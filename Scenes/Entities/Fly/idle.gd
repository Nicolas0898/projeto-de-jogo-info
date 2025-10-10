extends State

func onPhysics(delta:float):
	var dist = character.global_position.distance_to(GameHandler.Player.global_position)
	print(dist)
	if dist < 175:
		stateMachine.requestStateChange("Chase")
