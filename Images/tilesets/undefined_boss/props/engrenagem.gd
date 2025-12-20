extends Hitbox
class_name Engrenagem

@export var rpm : float
@export var return_to_node : Node2D
@export var random_spawn : bool = true
var r

func _ready() -> void:
	area_entered.connect(_on_area_entered) #O desse código
	area_entered.connect(onAreaEntered) #O da hitbox
	r = rpm * TAU / 60 #calcular quantos graus ele precisa se mover por frame
	
	if random_spawn:
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		rotation = rng.randi_range(0, 360)

func _physics_process(delta: float) -> void:
	rotation+= r * delta


func _on_area_entered(area: Area2D) -> void:
	if return_to_node == null: return
	GameHandler.Player.global_position = return_to_node.global_position
