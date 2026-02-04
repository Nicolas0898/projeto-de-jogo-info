extends State

var coyoteAvaliable = false
var timer = Timer.new()

func begin():
	timer.wait_time = 0.175
	timer.timeout.connect(coyote_timeout)
	add_child(timer)
	%DebugMenu.watch(self,"coyoteAvaliable")

func onPhysics(delta:float):
	var player:PlayerCharacter = stateMachine.character
	player.apply_gravity(delta)
	player.check_for_collisions()
	player.default_player_input(delta)
	player.default_move()
	
	#if Input.is_action_pressed("down"): player.apply_gravity(delta)
	if player.is_on_floor(): stateMachine.requestStateChange("Running")

func onStateEntered(oldState):
	var player:PlayerCharacter = stateMachine.character
	player.sprite.playAnimation("fall")
	if oldState.name.to_lower() == "running"\
	or oldState.name.to_lower() == "idle"\
	or oldState.name.to_lower() == "crouching":
		coyoteAvaliable = true
		timer.start()
	else:
		coyoteAvaliable = false

func onInput(event:InputEvent):
	if event.is_action_pressed("jump") and coyoteAvaliable:
		stateMachine.requestStateChange("Jump")

func coyote_timeout():
	coyoteAvaliable = false
	
