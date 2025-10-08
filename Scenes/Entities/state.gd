extends State
class_name BasicEntityDiedState

func onStateEntered(_a):
	character.queue_free()
