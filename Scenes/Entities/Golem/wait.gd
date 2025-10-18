extends State
@onready var sprite: AnimatedSprite2D = $"../../AnimatedSprite2D"

func onStateEntered(_old):
	if GameHandler.golem_dead:
		character.queue_free()
		if get_tree().current_scene.has_node("DOOR"):
			get_tree().current_scene.get_node("DOOR").enabled = false
		return
	sprite.play("spawn")
	sprite.pause()
	sprite.frame = 0

func onPhysics(delta):
	var dist = character.global_position.distance_to(GameHandler.Player.global_position)
	character.apply_air_friction()
	
	if dist < 140:
		sprite.play("spawn")
		stateMachine.requestStateChange("Idle")
