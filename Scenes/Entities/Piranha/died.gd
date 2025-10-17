extends State

func onPhysics(delta:float):
	character.apply_air_friction()
	character.default_move()


func onStateEntered(_old):
	GameHandler.spawn_coins(character.global_position,5)
	stateMachine.lockstate = true
	character.variable_velocity*=10
	character.queue_free()
