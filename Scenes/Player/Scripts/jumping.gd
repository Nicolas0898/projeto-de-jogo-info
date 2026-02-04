extends State
const JUMP = preload("uid://bqwi4vmu04dmo")

var max_jumptime = 0.3 
var jumptime = 0

func _ready() -> void:
	super()
	%DebugMenu.watch(self,"jumptime")

func onPhysics(delta:float):
	var player:PlayerCharacter = stateMachine.character
	player.constant_velocity.jump = Vector2(0,-270)
	player.check_for_collisions()
	player.default_player_input(delta)
	player.default_move()
	
	jumptime+=delta
	if jumptime>= max_jumptime:
		stateMachine.requestStateChange("Falling")
		player.variable_velocity.y += -170
	
	if player.top_edge_cast.get_collider():
		stateMachine.requestStateChange("Falling")

func onStateEntered(_old):
	var player:PlayerCharacter = stateMachine.character
	player.sprite.playAnimation("jump")
	player.variable_velocity.y = 0
	jumptime = 0
	
	var p:GPUParticles2D = JUMP.instantiate()
	character.add_child(p)
	p.global_position = character.get_node("ParticleSpawnPoint").global_position
	p.emitting = true
	p.finished.connect(func():
		p.queue_free()
		)

func onStateExit():
	var player:PlayerCharacter = stateMachine.character
	player.constant_velocity.jump = Vector2(0,0)

func onInput(event:InputEvent):
	var player:PlayerCharacter = stateMachine.character
	
	if event.is_action_released("jump"):
		player.variable_velocity.y += -200
		stateMachine.requestStateChange("Falling")
	
