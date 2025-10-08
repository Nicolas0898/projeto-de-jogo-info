extends State

func onPhysics(delta:float):

	character.apply_gravity(delta)
	character.default_move()
