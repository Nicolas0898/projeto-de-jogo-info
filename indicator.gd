extends Sprite2D

var ogpos:Vector2
@export var frequency := 1.0
@export var amplitude := 1.0

func _ready() -> void:
	ogpos = global_position
	
func _process(delta: float) -> void:
	if ogpos==null:return
	global_position = ogpos + Vector2(0,sin(Engine.get_process_frames() * frequency) * amplitude)
