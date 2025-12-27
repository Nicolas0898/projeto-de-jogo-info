extends Node2D

@onready var effects: Sprite2D = $AnimatedSprite2D/Sprite2D
@onready var an_sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: Hitbox = $Hitbox
@onready var impact: GPUParticles2D = $impact
@export var time_before_bite : float = 0.5
@export var time_after_bite : float = 0.3

func _ready() -> void:
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(an_sprite, "scale", Vector2(1, 1), time_before_bite)
	
	an_sprite.play("bite_01")
	await get_tree().create_timer(time_before_bite + 0.3).timeout
	
	an_sprite.modulate *= Color(3.0, 2.398, 3.0, 1.0)
	hitbox.monitoring = true
	hitbox.set_collision_layer_value(1, true)
	hitbox.set_collision_mask_value(5, true)
	
	var t = create_tween()
	t.set_trans(Tween.TRANS_QUAD)
	t.set_ease(Tween.EASE_OUT)
	t.tween_property(an_sprite, "scale", Vector2(0, 0), time_after_bite)
	an_sprite.play("bite_02")
	impact.emitting = true
	
	await get_tree().create_timer(time_after_bite).timeout
	queue_free()
	
func _physics_process(delta: float) -> void:
	effects.rotation+=0.1
