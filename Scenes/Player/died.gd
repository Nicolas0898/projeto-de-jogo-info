extends State
	
func onStateEntered(_old):
	character = character as PlayerCharacter
	character.sprite.character.sprite.playAnimation("death",2)
	character.get_node("Hurtbox").monitoring = false
	await get_tree().create_timer(2).timeout
	Ui.set_transition(true)
	await get_tree().create_timer(2).timeout
	GameHandler.player_health = character.get_node("HealthComponent").max_health
	get_tree().reload_current_scene()
	
func onPhysics(delta: float) -> void:
	character = character as PlayerCharacter
	character.apply_gravity(delta)
	character.clear_player_input()
	character.check_for_collisions()
	character.default_move()
