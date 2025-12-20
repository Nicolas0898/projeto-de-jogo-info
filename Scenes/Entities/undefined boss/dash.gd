extends State

@onready var sprite : AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var spear_spawn = $"../../spear_spawn"
@onready var d01 = $"../../Particles/d01"
@onready var spear = preload("res://Scenes/Entities/undefined boss/spear.tscn")
var throwing = false
var collect = true
var trail = false
var sp

@export var left_target : Node2D
@export var right_target : Node2D
var dist = null
var dir = null
var c = 0


func onStateEntered(_oldState:State):
	var player = GameHandler.Player
	#original_pos = character.global_position
	
	dist = character.global_position.direction_to(player.global_position)
	dir = 1 if dist.x>0 else -1
	sprite.flip_h = true if dist.x>0 else false
	
	character.blink(0.3,Color(0.749, 0.241, 0.408, 1.0))
	sprite.play("dash_01")
	await get_tree().create_timer(0.7).timeout
	
	
	sp = spear.instantiate()
	sp.get_node("Sprite2D").flip_h = true if dir == 1 else false
	sp.get_node("point").position = Vector2(55, 0) if dir == -1 else Vector2(-55, 0)
	sp.get_node("point").rotation = 135 if dir == 1 else 0
	sp.get_node("point").emitting = true
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
		if abs(sp.global_position.x - right_target.global_position.x) < 1 or abs(sp.global_position.x - left_target.global_position.x) < 1:
			throwing = false
			collect = false
			await get_tree().create_timer(0.2).timeout #tempo que fica parado antes de pegar a lança
			
			d01.emitting = true
			d01.rotation = 0 if dir == -1 else 135
			GameHandler.Player.camera.screen_shake(25, 0.2)
			
			trail = true
			var character_tween = create_tween()
			if dir == 1: character_tween.tween_property(character, "global_position:x", right_target.global_position.x, 0.3)
			if dir == -1: character_tween.tween_property(character, "global_position:x", left_target.global_position.x, 0.3)
			#dist = original_pos.distance_to(right_target.global_position) if dir == 1 else original_pos.distance_to(left_target.global_position)
	if collect == false and ((character.global_position.x == left_target.global_position.x and dir == -1) or (character.global_position.x == right_target.global_position.x and dir == 1)):
		collect = true
		throwing = false
		trail = false
		d01.emitting = false
		
		sp.queue_free()
		sprite.play("dash_03")
		
		await get_tree().create_timer(0.2).timeout
		stateMachine.requestStateChange("idle")
	if trail: #TRAIL
		if c < 1: #contador p ele colocar um novo frame só 1/2 das vezes
			c+=1
			return
		else:
			c = 0
			var s = sprite.duplicate()
			s.global_position = character.global_position
			get_tree().root.add_child(s)
			
			var tween = create_tween()
			tween.tween_property(s, "modulate", Color(0.879, 0.239, 0.495, 0.0), 0.15)
			tween.tween_callback(s.queue_free)
