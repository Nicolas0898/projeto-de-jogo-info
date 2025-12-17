extends State

@onready var sprite : AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var spear_spawn = $"../../spear_spawn"
@onready var spear = preload("res://Scenes/Entities/undefined boss/spear.tscn")
var throwing = false
var collect = true
var sp

@export var left_target : Node2D
@export var right_target : Node2D
#var original_pos : Vector2
var dist = null
var dir = null

func onStateEntered(_oldState:State):
	var player = GameHandler.Player
	#original_pos = character.global_position
	
	dist = character.global_position.direction_to(player.global_position)
	dir = 1 if dist.x>0 else -1
	sprite.flip_h = true if dist.x>0 else false
	
	character.blink(0.3,Color(0.973, 0.97, 0.0, 1.0))
	sprite.play("dash_01")
	await get_tree().create_timer(0.7).timeout
	
	
	sp = spear.instantiate()
	sp.get_node("Sprite2D").flip_h = true if dir == 1 else false
	sp.global_position = spear_spawn.global_position
	get_tree().current_scene.add_child(sp)
	#spear_spawn.add_child(sp)
	
	var sp_tween = create_tween()
	sp_tween.set_trans(Tween.TRANS_QUAD) #sine / expo / quad (conforme a força da desaceleração)
	sp_tween.set_ease(Tween.EASE_OUT)
	
	if dir == 1: sp_tween.tween_property(sp, "global_position:x", right_target.global_position.x, 0.5)
	else: sp_tween.tween_property(sp, "global_position:x", left_target.global_position.x, 0.5)
	throwing = true
	
	sprite.play("dash_02")

func onPhysics(_delta:float):
	if throwing:
		if sp.global_position.x == right_target.global_position.x or sp.global_position.x == left_target.global_position.x:
			throwing = false
			collect = false
			await get_tree().create_timer(0.2).timeout
			
			var character_tween = create_tween()
			if dir == 1: character_tween.tween_property(character, "global_position:x", right_target.global_position.x, 0.05)
			if dir == -1: character_tween.tween_property(character, "global_position:x", left_target.global_position.x, 0.05)
			#dist = original_pos.distance_to(right_target.global_position) if dir == 1 else original_pos.distance_to(left_target.global_position)
	if collect == false and (character.global_position.x == left_target.global_position.x or character.global_position.x == right_target.global_position.x):
		collect = true
		sp.queue_free()
		sprite.play("dash_03")
		
		await get_tree().create_timer(0.2).timeout
		stateMachine.requestStateChange("idle")
