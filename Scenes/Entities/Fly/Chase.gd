extends State

func onPhysics(delta:float):
	var dist = character.global_position.direction_to(GameHandler.Player.global_position)
	character.constant_velocity.walk = dist*100
	character.default_move()
