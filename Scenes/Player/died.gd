extends State

func onStateEntered(_old):
	character = character as PlayerCharacter
	character.sprite.play("death")
	
func onPhysics(delta: float) -> void:
	character = character as PlayerCharacter
	character.apply_gravity(delta)
	character.clear_player_input()
	character.check_for_collisions()
	character.default_move()
