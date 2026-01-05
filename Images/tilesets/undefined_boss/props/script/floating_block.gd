extends StaticBody2D

@export var frequency : float 
@export var amplitude : float
var ogpos:Vector2

func _ready() -> void:
	ogpos = global_position
	
func _process(_delta: float) -> void:
	if ogpos==null:return
	global_position = ogpos + Vector2(0,sin(Engine.get_process_frames() * frequency) * amplitude)
