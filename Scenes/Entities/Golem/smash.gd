extends State
const IMPACT_SMOKE = preload("res://Scenes/particles/impact_smoke.tscn")
const SPAWN_SMOKE = preload("res://Scenes/particles/spawn_smoke.tscn")
const STONE = preload("res://Scenes/Entities/Golem/stone.tscn")
const STONE_EXPLOSION = preload("res://Scenes/particles/stone_explosion.tscn")

@onready var rockspawnpos: Node2D = $"../../rockspawnpos"
@onready var sprite: AnimatedSprite2D = $"../../AnimatedSprite2D"

@export var n_rocks := 10

signal spawn
var effects = []
var distance = 100

func clearpart():
	for i  in effects:
		i = i as GPUParticles2D
		i.emitting = false
		get_tree().create_timer(2).timeout.connect(func():
			if is_instance_valid(i):
				i.queue_free())
	effects.clear()

func onStateEntered(_d):
		character.rotate_to_plr()
		sprite.play("smash")
		
		var bottom_pos = rockspawnpos.global_position
		var plrpos = GameHandler.Player.global_position
		var factor = 1 if character.global_position.direction_to(plrpos).x > 0 else -1
		for i in range(n_rocks):
			var effect = SPAWN_SMOKE.instantiate()
			effect.position = bottom_pos + Vector2(distance,0)*i*factor
			get_tree().current_scene.add_child(effect)
			effects.push_back(effect)
		
		await spawn
		clearpart()
		
		
		for i in range(n_rocks):
			var rock = STONE.instantiate() as RigidBody2D
			rock.position = bottom_pos + Vector2(distance,0)*i*factor
			get_tree().current_scene.add_child(rock)
			rock.linear_velocity = Vector2(0,-600)
			rock.angular_velocity = randf_range(-3,3)
			await get_tree().create_timer(0.05).timeout
		
		stateMachine.requestStateChange("Idle")
		
		
func onStateExit():
	clearpart()

func _frame_changed() -> void:
	if sprite.frame==5:
		spawn.emit()
