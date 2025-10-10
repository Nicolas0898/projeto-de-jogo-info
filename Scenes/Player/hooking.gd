extends State
const ROPE = preload("res://Scenes/Objects/rope.tscn")
var current_active_rope:Node2D = null

var start_distance = 0

func onInput(event:InputEvent):
	var character:PlayerCharacter= stateMachine.character
	if event.is_action_released("jump"):
		if stateData.hook.type == GrappleNode.SWING:
			boost_character(-400)
		stateMachine.requestStateChange("Falling")

func onStateEntered(_last):
	var character:PlayerCharacter= stateMachine.character
	
	var hookpos = stateData.hook.global_position
	var plrpos = character.global_position
	
	current_active_rope = ROPE.instantiate()
	
	if stateData.hook.type == GrappleNode.PULL:
		current_active_rope.n_points = 5
	
	character.add_child(current_active_rope)
	
	#current_active_rope.position = Vector2(0,-16)
	current_active_rope.target.global_position = stateData.hook.global_position
	current_active_rope.start()
	
	start_distance = plrpos.distance_to(hookpos)
	

func boost_character(y=-400):
	var character:PlayerCharacter= stateMachine.character
	character.variable_velocity.y = 0
	character.variable_velocity.y+=y
	character.variable_velocity += character.true_constant_velocity*1.7

func onStateExit():
	current_active_rope.queue_free()
	
func onPhysics(delta:float):
	if stateData.hook.type == GrappleNode.SWING:
		swingPhysics(delta)
	else:
		pullPhysics(delta)


func swingPhysics(delta:float):
	var player:PlayerCharacter = stateMachine.character
	var hookpos = stateData.hook.global_position
	var plrpos = player.global_position
	
	
	var distance = plrpos.distance_to(hookpos)
	
	player.default_player_input(1.7)
	player.apply_gravity(delta)
	player.check_for_collisions()
	
	
	var nextpos = plrpos + player.velocity*delta
	
	var direction = nextpos.direction_to(hookpos).normalized()
	var normal_v = player.velocity.normalized()
	
	if distance>start_distance:
		player.variable_velocity += -player.variable_velocity
	var factor = max(distance-start_distance,0)
	player.variable_velocity += direction*factor*20
	if player.constant_velocity.input == Vector2.ZERO:
		player.constant_velocity.input = Vector2(direction.x*150,0)
	
	player.update_velocity()
	player.move_and_slide()

func pullPhysics(delta:float):
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
		boost_character()
	player.default_move()
	
