extends State

@onready var sprite: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var smoke: GPUParticles2D = $"../../AnimatedSprite2D/walking_smoke"
@onready var hitbox: Hitbox = $"../../Hitbox"

var started = false
var dir = Vector2(0,0)
var ending = false
var repeat = false

func onStateEntered(_old):
	character.rotate_to_plr()
	ending = false
	started = false
	if not stateData.get("last"):
		repeat = randi_range(1,2) == 1
	else : 
		character.clear_constant_velocity()
		repeat = false
		await get_tree().create_timer(0.3).timeout
	character.rotate_to_plr()
	var plr = GameHandler.Player
	sprite.play("roll_prepare")
	await sprite.animation_finished
	sprite.play("roll_action")
	smoke.emitting = true
	hitbox.monitoring = true
	started = true
	dir = character.global_position.direction_to(plr.global_position)

func onStateExit():
	hitbox.monitoring = false
	smoke.emitting = false
	sprite.play_backwards("roll_prepare")
	character.clear_constant_velocity()

func onPhysics(delta):
	if not started : return
	var plr = GameHandler.Player
	var current_dir = character.global_position.direction_to(plr.global_position)
	character.constant_velocity.r = Vector2(1 if dir.x > 0 else -1,0)*440
	if ((current_dir.x>0 and dir.x<0) or\
	(current_dir.x<0 and dir.x>0)) and not\
	ending:
		ending = true
		print("ending")
		get_tree().create_timer(0.3).timeout.connect(func():
			if not repeat:
				stateMachine.requestStateChange("Idle")
			else:
				stateMachine.requestStateChange("Roll",{"last":true})
		)
		 
	character.apply_gravity(delta)
	character.default_move()
