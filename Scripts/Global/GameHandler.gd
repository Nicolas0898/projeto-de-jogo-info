extends Node
var total_coins = 35

signal PlayerSpawned
signal GameInputChanged()

var Player : PlayerCharacter
var player_health = 100 #original é 100 mas o pires mudou p teste
var spawnpoint = null
var player_habilities = []
var golem_dead = false
var roomswocoins = []
var controller = false

func collect_coin(value:int):
	total_coins+= value

const COIN = preload("res://Scenes/Objects/coin.tscn")
func spawn_coins(at_pos:Vector2,number):
	for i in range(number):
		var coin = COIN.instantiate()
		get_tree().current_scene.add_child.call_deferred(coin)
		coin.global_position = at_pos
		coin.linear_velocity = Vector2(randf_range(-50,50),randf_range(-450,-350))
		
func emit_player_spawn():
	PlayerSpawned.emit()

@warning_ignore("shadowed_variable")
func emit_game_input_changed(controller:bool):
	self.controller = controller
	GameInputChanged.emit()
	

func play_particle_one(particle:GPUParticles2D):
	particle.emitting = true
	particle.finished.connect(func():
		particle.queue_free()
		)
