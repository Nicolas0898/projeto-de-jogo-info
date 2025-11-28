extends State
var player:PlayerCharacter

func onPhysics(delta:float):
	var player:PlayerCharacter = stateMachine.character
	player.clear_player_input()
	player.apply_gravity(delta)
	player.check_for_collisions()
	player.default_move()
	player.sprite.playAnimation("idle")
