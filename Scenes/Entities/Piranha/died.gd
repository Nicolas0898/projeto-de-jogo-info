extends State

func onPhysics(delta:float):
	character.apply_air_friction()
	character.default_move()


func onStateEntered(_old):
	stateMachine.lockstate = true
	character.variable_velocity*=10
	character.queue_free()
