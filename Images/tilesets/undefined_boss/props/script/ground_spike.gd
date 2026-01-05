extends Hitbox

@export var time : float 
@export var offset : float
@export var trajectory : Curve
@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D
var t = 0

#pos -> 19,5 para -23 (-46 de diferença)

func _ready() -> void:
	super() #Executa o _ready do Hitbox
	monitoring = false
	t = fmod(offset, time)

func _physics_process(delta: float) -> void:
	if t > time: t = 0
	t += delta
	var graph_pos = t/time
	var graph_sample = trajectory.sample(graph_pos)
	
	
	collision.position.y = 19.5 - (graph_sample * 46)
	sprite.play(str(int(round(graph_sample * 5)))) #Pega o número do gráfico e converte de 0 a 5
	
