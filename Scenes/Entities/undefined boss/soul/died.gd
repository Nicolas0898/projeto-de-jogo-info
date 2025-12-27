extends BasicEntityDiedState

func onStateEntered(_old):
	var tween = create_tween()
	tween.tween_property(character, "scale", Vector2(0, 0), 0.3)
	
	await get_tree().create_timer(0.3).timeout
	super(_old) #A parte que ele realmente some da tela
