extends State

var max_jumptime = 0.3
var jumptime = 0

func _ready() -> void:
	super()
	%DebugMenu.watch(self,"jumptime")

func onPhysics(delta:float):
	var player:PlayerCharacter = stateMachine.character
	player.constant_velocity.jump = Vector2(0,-500)
	player.check_for_collisions()
	player.default_player_input()
	player.default_move()
	
	jumptime+=delta
	if jumptime>= max_jumptime:
		stateMachine.requestStateChange("Falling")
		player.variable_velocity.y = -400
	
	if player.top_edge_cast.get_collider():
		stateMachine.requestStateChange("Falling")

func onStateEntered(_old):
	var player:PlayerCharacter = stateMachine.character
	player.variable_velocity.y = 0
	jumptime = 0

func onStateExit():
	var player:PlayerCharacter = stateMachine.character
	player.constant_velocity.jump = Vector2(0,0)

func onInput(event:InputEvent):
	var player:PlayerCharacter = stateMachine.character
	
	if event.is_action_released("jump"):
		player.variable_velocity.y = -200
		stateMachine.requestStateChange("Falling")
	
