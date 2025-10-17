extends BasicEntityDiedState

func onStateEntered(_old):
	GameHandler.spawn_coins(character.global_position,15)
	GameHandler.golem_dead = true
	super(_old)
