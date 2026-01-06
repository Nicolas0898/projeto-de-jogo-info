extends Hitbox

@export var frequency : float 
@export var amplitude : float
var ogpos:Vector2

func _ready() -> void:
	super()
	ogpos = global_position
	
func _process(_delta: float) -> void:
	if ogpos==null:return
	global_position = ogpos + Vector2(0,sin(Engine.get_process_frames() * frequency) * amplitude)


func _on_area_entered(area: Area2D) -> void:
	if not area is Hurtbox: return
