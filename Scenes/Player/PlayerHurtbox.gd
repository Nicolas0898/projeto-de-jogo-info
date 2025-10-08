extends BaseHurtbox

func onHit(other:Hitbox):
	super(other)
	character.state_machine.requestStateChange("Stunned")
	if character.get_node("GrapplingHook"):
		character.get_node("GrapplingHook").reset_hooks()
	get_tree().create_timer(0.12).timeout.connect(func():
		if character.state_machine.currentState.name == "Stunned":
			character.state_machine.requestStateChange("Falling"))
