extends BaseHurtbox

func onHit(other:Hitbox):
	super(other)
	if character.get_node("GrapplingHook"):
		character.get_node("GrapplingHook").reset_hooks()
