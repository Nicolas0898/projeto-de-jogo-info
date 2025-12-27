extends State

@onready var sprite : AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var particles : GPUParticles2D = $"../../Particles/t01"
@onready var cube: AnimatedSprite2D = $"../../Particles/t01/cube"
@onready var trail = preload("res://Scenes/Entities/undefined boss/trail_bite.tscn")

var trail_amount : int

func onStateEntered(_oldState:State):
	var rng = RandomNumberGenerator.new()
	trail_amount = rng.randi_range(7, 13)
	
	character.blink(0.4,Color(1.18, 0.807, 1.162, 1.0))
	await get_tree().create_timer(0.4).timeout #Começa a tocar o sprite
	
	sprite.play("trail_01")
	await get_tree().create_timer(0.2).timeout #Começa a emitir as partículas e o cubo
	
	particles.emitting = true
	particles.modulate = Color(1, 1, 1, 1)
	var t = create_tween()
	t.tween_property(cube, "scale", Vector2(1, 1), 0.3)
	cube.play("idle")
	
	await get_tree().create_timer(1.3).timeout #Spawna os portais
	trail_spawn(trail_amount)
	
	await get_tree().create_timer(1).timeout #Para as partículas
	sprite.play("trail_02")
	var t2 = create_tween()
	t2.tween_property(particles, "modulate", Color(1, 1, 1, 0), 0.3)
	particles.emitting = false
	
	await get_tree().create_timer(0.3).timeout
	cube.scale = Vector2(0, 0)
	stateMachine.requestStateChange("idle")

func trail_spawn(amount):
	for i in range(amount):
		var t = trail.instantiate()
		t.global_position = GameHandler.Player.global_position
		get_tree().root.add_child(t)
		await get_tree().create_timer(0.6).timeout
