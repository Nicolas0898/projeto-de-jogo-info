extends State
const ROPE = preload("res://Scenes/Objects/rope.tscn")
var current_active_rope:Node2D = null

var start_distance = 0

func onInput(event:InputEvent):
	if event.is_action_released("jump"):

		stateMachine.requestStateChange("Falling")

func onStateEntered(_last):
	var character:PlayerCharacter= stateMachine.character
	
	var hookpos = stateData.hook.global_position
	var plrpos = character.global_position
	
	current_active_rope = ROPE.instantiate()
	
	if stateData.hook.type == GrappleNode.PULL:
		current_active_rope.n_points = 2
	
	character.add_child(current_active_rope)
	
	current_active_rope.position = Vector2(0,-16)
	current_active_rope.target.global_position = stateData.hook.global_position
	current_active_rope.start()
	
	start_distance = plrpos.distance_to(hookpos)
	
	print(start_distance)

func onStateExit():
	var character:PlayerCharacter= stateMachine.character
	current_active_rope.queue_free()
	character.variable_velocity.y = 0
	character.variable_velocity.y+=-700
	character.variable_velocity += character.true_constant_velocity*1.3
	

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
	
	player.default_player_input(2.2)
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
		player.constant_velocity.input = Vector2(direction.x*440,0)
	
	player.update_velocity()
	player.move_and_slide()

func pullPhysics(delta:float):
	var player:PlayerCharacter = stateMachine.character
	var hookpos = stateData.hook.global_position
	var plrpos = player.global_position
	var direction = plrpos.direction_to(hookpos)
	var distance = plrpos.distance_to(hookpos)
	player.clear_player_input()
	player.variable_velocity = direction*1000
	player.check_for_collisions()
	if distance<30:
		stateMachine.requestStateChange("Falling")
	player.default_move()
	
