extends Hitbox

@export var frequency : float 
@export var amplitude : float
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var i_01: GPUParticles2D = $i01
var cooldown : float = 0.4
var on_cooldown = false
var ogpos:Vector2

func _ready() -> void:
	super() #Hitbox
	ogpos = global_position
	
func _process(_delta: float) -> void:
	if ogpos==null:return
	global_position = ogpos + Vector2(0,sin(Engine.get_process_frames() * frequency) * amplitude)


func _on_area_entered(area: Area2D) -> void:
	if not area is Hurtbox: return
	if on_cooldown: return
	on_cooldown = true
	
	sprite.play("jumping")
	i_01.emitting = true
	set_collision_mask_value(5, false)
	
	await get_tree().create_timer(cooldown).timeout
	
	sprite.play("idle")
	set_collision_mask_value(5, true)
	
	on_cooldown = false
