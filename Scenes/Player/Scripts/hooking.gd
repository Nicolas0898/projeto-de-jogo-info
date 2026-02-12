extends State
const ROPE = preload("res://Scenes/Objects/rope.tscn")
var current_active_rope:Node2D = null
const GRAPPLING_HOOK_LEAFS = preload("uid://7hyu1u2s2ekx")
const BASEIMPACT = preload("uid://qflm7bpdrk3m")
const LEAFCAGESTART = preload("uid://6itq3v3mqj7a")

var start_distance = 0
var leaf_particle:GPUParticles2D
var active_particle:GPUParticles2D

func onInput(event:InputEvent):
	character = stateMachine.character
	if event.is_action_released("jump"):
		if stateData.hook.type == GrappleNode.SWING:
			boost_character(-400)
		stateMachine.requestStateChange("Falling")

func onStateEntered(_last):
	character.sprite.playAnimation("hook",1)
	character = stateMachine.character
	
	var hookpos = stateData.hook.global_position
	var plrpos = character.global_position
	
	current_active_rope = ROPE.instantiate()
	
	if stateData.hook.type == GrappleNode.PULL:
		current_active_rope.n_points = 5
		leaf_particle = GameHandler.spawn_particle(GRAPPLING_HOOK_LEAFS,Vector2.ZERO,character)
		GameHandler.spawn_particle(BASEIMPACT,Vector2.ZERO,stateData.hook)
	else:
		active_particle = GameHandler.spawn_particle(LEAFCAGESTART,hookpos)
	
	character.add_child(current_active_rope)
	
	#current_active_rope.position = Vector2(0,-16)
	current_active_rope.target.global_position = stateData.hook.global_position
	current_active_rope.start()
	
	
	
	start_distance = plrpos.distance_to(hookpos)
	

	

func boost_character(y=-400):
	character = stateMachine.character
	character.variable_velocity.y = 0
	character.variable_velocity.y+=y
	character.variable_velocity += character.true_constant_velocity*1.7

func onStateExit():
	if leaf_particle:
		leaf_particle.emitting = false
		var ref = leaf_particle.get_instance_id()
		get_tree().create_timer(leaf_particle.lifetime).timeout.connect(func():
			instance_from_id(ref).queue_free())
		leaf_particle = null
	if active_particle:
		GameHandler.spawn_particle(BASEIMPACT,Vector2.ZERO,stateData.hook)
		active_particle.emitting = false
		var ref = active_particle.get_instance_id()
		get_tree().create_timer(active_particle.lifetime).timeout.connect(func():
			instance_from_id(ref).queue_free())
		active_particle = null
		
	character.sprite.rotation = PI/4
	character.sprite.stopAnimation(1)
	character.sprite.play_backwards("hook")
	var t = create_tween()
	t.set_ease(Tween.EASE_OUT)
	t.set_trans(Tween.TRANS_BACK)
	t.tween_property(character.sprite,"rotation",0,0.5)
	current_active_rope.queue_free()
	
func onPhysics(delta:float):
	character.sprite.rotation = (character.sprite.rotation+delta*10)
	if character.sprite.rotation>2*PI:
		character.sprite.rotation-= 2*PI
		
	current_active_rope.target.global_position = stateData.hook.global_position
	if stateData.hook.type == GrappleNode.SWING:
		swingPhysics(delta)
	else:
		pullPhysics(delta)


func swingPhysics(delta:float):
	var player:PlayerCharacter = stateMachine.character
	var hookpos = stateData.hook.global_position
	var plrpos = player.global_position
	
	
	var distance = plrpos.distance_to(hookpos)
	
	player.default_player_input(delta,1.7)
	player.apply_gravity(delta)
	player.check_for_collisions()
	
	
	var nextpos = plrpos + player.velocity*delta
	
	var direction = nextpos.direction_to(hookpos).normalized()
	#var normal_v = player.velocity.normalized()
	
	if distance>start_distance:
		player.variable_velocity += -player.variable_velocity
	var factor = max(distance-start_distance,0)
	player.variable_velocity += direction*factor*20
	if player.constant_velocity.input == Vector2.ZERO:
		player.constant_velocity.input = Vector2(direction.x*150,0)
	
	player.update_velocity()
	player.move_and_slide()

func pullPhysics(_delta:float):
	var player:PlayerCharacter = stateMachine.character
	var hookpos = stateData.hook.global_position
	var plrpos = player.global_position
	var direction = plrpos.direction_to(hookpos)
	var distance = plrpos.distance_to(hookpos)
	player.clear_player_input()
	player.variable_velocity = direction*500
	player.check_for_collisions()
	if distance<30:
		stateMachine.requestStateChange("Falling")
		boost_character(-300)
	player.default_move()
	
