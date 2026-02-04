extends State
const WALK_PARTICLES = preload("uid://bm3ld46ea6iud")

func first():
	var anim:AnimatedSprite2D = character.get_node("Sprite")
	anim.frame_changed.connect(func():
		if(stateMachine.currentState!=self) : return
		if(anim.frame == 2 or anim.frame== 6):
			var p:GPUParticles2D = WALK_PARTICLES.instantiate()
			character.add_child(p)
			p.global_position = character.get_node("ParticleSpawnPoint").global_position
			p.emitting = true
			await p.finished
			p.queue_free()
		)
	
func onPhysics(delta:float):
	var player:PlayerCharacter = stateMachine.character
	player.apply_gravity(delta)
	player.check_for_collisions()
	player.default_player_input(delta)
	player.default_move()
	
	player.sprite.playAnimation("run")
	
	if is_zero_approx(Input.get_axis("left","right")):
		stateMachine.requestStateChange("Idle")
		
	if not player.is_on_floor() : stateMachine.requestStateChange("Falling")
	if Input.is_action_pressed("jump"):stateMachine.requestStateChange("Jump")
	#if Input.is_action_pressed("down"):stateMachine.requestStateChange("Crouching")
