extends BasicEntityDiedState

func onStateEntered(_old):
	GameHandler.spawn_coins(character.global_position,15)
	GameHandler.golem_dead = true
	await get_tree().create_timer(0.1).timeout
	super(_old)
	
	if get_tree().current_scene.has_node("DOOR"):
		get_tree().current_scene.get_node("DOOR").enabled = false
