extends StaticBody2D

@export var trajectory : Curve
@export var time : float
@export var offset : float
@onready var hitbox: Hitbox = $Hitbox
@onready var hurtbox: Hurtbox = $Hurtbox
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
var t : float = 0

func _ready() -> void:
	hitbox.monitoring = false
	hurtbox.set_collision_layer_value(1, false)
	t = fmod(offset, time)

func _physics_process(delta: float) -> void:
	if t > time: t = 0
	t += delta
	var graph_pos = t/time
	var graph_sample = trajectory.sample(graph_pos)
	
	
	
	sprite.play(str(int(round(graph_sample * 4)))) #Pega o número do gráfico e converte de 0 a 4
	if round(graph_sample * 4) > 1: 
		hitbox.monitoring = true
		hurtbox.set_collision_layer_value(1, true)
	else: 
		hitbox.monitoring = false
		hurtbox.set_collision_layer_value(1, false)
	
	var s = 1 + (0.5 * graph_sample)
	scale = Vector2(s, s)
