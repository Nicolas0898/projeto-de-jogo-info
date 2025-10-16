extends State

func onStateEntered(_o):
	character = character as PlayerCharacter
	character.remove_core(INF)

func onPhysics(delta):
	character = character as PlayerCharacter
	character.clear_player_input()
	character.apply_gravity(delta)
	character.check_for_collisions()
	character.default_move()
