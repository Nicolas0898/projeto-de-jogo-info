extends State

@onready var sprite : AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var spear_spawn = $"../../spear_spawn"
@onready var spear = preload("res://Scenes/Entities/undefined boss/spear.tscn")
var throwing = false
var sp

@export var left_target : Node2D
@export var right_target : Node2D
var dist = null
var dir = null

func onStateEntered(_oldState:State):
	var player = GameHandler.Player
	
	dist = character.global_position.direction_to(player.global_position)
	dir = 1 if dist.x>0 else -1
	sprite.flip_h = true if dir == 1 else false
	
	character.blink(0.3,Color(0.973, 0.97, 0.0, 1.0))
	sprite.play("dash_01")
	await get_tree().create_timer(0.3).timeout
	
	
	sp = spear.instantiate()
	sp.get_node("Sprite2D").flip_h = true if dir == 1 else false
	spear_spawn.add_child(sp)
	throwing = true
	
	var sp_tween = create_tween()
	if dir == 1: sp_tween.tween_property(sp, "position:x", right_target.position.x - 100, 0.3)
	else: sp_tween.tween_property(sp, "position:x", left_target.position.x + 100, 0.3)
	#sp.velocity.x = 500 * dir
	sprite.play("dash_02")

func onPhysics(_delta:float):
	pass
	#if throwing:
		#sp.move_and_slide()
