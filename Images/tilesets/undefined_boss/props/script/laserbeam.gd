extends Hitbox
class_name Laserbeam

@export var time : float #Tempo entre ativar e desativar
@export var offset : float #Quanto tempo ele vai estar adiantado
@export var trajectory : Curve #Como ele deve se comportar (ativa colisão a partir de 0.8)
@onready var light = $PointLight2D #11 = ativado, 0 = desativado (energy)
var t = 0

func _ready() -> void:
	super() #Executa o _ready do Hitbox
	monitoring = false
	light.energy = 0
	t = fmod(offset, time)

func _physics_process(delta: float) -> void:
	if t > time: t = 0
	t += delta
	var graph_pos = t/time
	var graph_sample = trajectory.sample(graph_pos)
	light.energy = graph_sample * 11
	
	if graph_sample >= 0.8: monitoring = true
	else: monitoring = false
