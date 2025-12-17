extends State
const IMPACT_SMOKE = preload("res://Scenes/particles/impact_smoke.tscn")
const SPAWN_SMOKE = preload("res://Scenes/particles/spawn_smoke.tscn")
const STONE = preload("res://Scenes/Entities/Golem/stone.tscn")
const STONE_EXPLOSION = preload("res://Scenes/particles/stone_explosion.tscn")

@onready var throwspawnpos: Node2D = $"../../throwspawnpos"
@onready var sprite: AnimatedSprite2D = $"../../AnimatedSprite2D"

@export var n_rocks := 10

signal spawn
var effects = []
var distance = 100

func onStateEntered(_d):
		character.rotate_to_plr(sprite)
		sprite.play("throw")
		
		await spawn
		
		var stone = STONE.instantiate()
		stone.global_position = throwspawnpos.global_position
		get_tree().current_scene.add_child(stone)
		
		var plrpos = GameHandler.Player.global_position
		var dir = throwspawnpos.global_position.direction_to(plrpos)
		
		#var t = 0.4
		var dist_x = abs(plrpos.x-throwspawnpos.global_position.x) 
		#var v_x = dist_x/t
		#var v_x = -(plrpos.x-throwspawnpos.global_position.x)/t*1.3
		#var vi_y = -character.get_gravity().y*t
		#print(v_x)
		#stone.linear_velocity = dir*Vector2(v_x,vi_y)
		stone.linear_velocity = dir*700 + Vector2(0,-1*dist_x)
		
		stateMachine.requestStateChange("Idle")
		
		


func _frame_changed() -> void:
	if sprite.frame==5:
		spawn.emit()
