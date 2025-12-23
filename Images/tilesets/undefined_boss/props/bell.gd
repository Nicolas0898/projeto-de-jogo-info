extends Hurtbox
class_name Bell

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var particles: GPUParticles2D = $GPUParticles2D
@onready var point_light_2d: PointLight2D = $PointLight2D
@export var cooldown : float
@export var kb_intensity : float

func onHit(hitbox:Hitbox):
	sprite.modulate *= Color(1.5, 1.5, 1.5, 1)
	point_light_2d.energy = 0
	var modulate_tween = create_tween()
	var scale_tween = create_tween()
	var pl_tween = create_tween()
	pl_tween.set_ease(Tween.EASE_IN)
	
	modulate_tween.tween_property(sprite, "modulate", Color(1, 1, 1, 1), 0.15)
	pl_tween.tween_property(point_light_2d, "energy", 1, cooldown)
	scale_tween.tween_property(sprite, "scale", Vector2(0.8, 0.8), 0.01)
	scale_tween.tween_property(sprite, "scale", Vector2(1, 1), cooldown)
	
	GameHandler.Player.variable_velocity = global_position.direction_to(GameHandler.Player.global_position) * kb_intensity
	
	particles.emitting = true
	sprite.play("moving")
	
	set_collision_layer_value(1, false) # Pra não poder bater nele até o tempo do cooldown
	
	await get_tree().create_timer(0.16).timeout #Timeout da cor
	
	sprite.modulate = Color(0.523, 0.523, 0.523, 1.0)
	create_tween().tween_property(sprite, "modulate", Color(1, 1, 1, 1), cooldown - 0.15)
	await get_tree().create_timer(cooldown - 0.15).timeout
	
	set_collision_layer_value(1, true)
	sprite.play("idle")
