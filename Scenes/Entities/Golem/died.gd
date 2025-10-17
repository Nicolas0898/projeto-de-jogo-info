extends BasicEntityDiedState

func onStateEntered(_old):
	GameHandler.golem_dead = true
	super(_old)
