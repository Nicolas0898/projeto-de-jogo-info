extends Hurtbox

@onready var sprite: AnimatedSprite2D = $"../AnimatedSprite2D"
@onready var impact: GPUParticles2D = $"../impact"

func onHit(hitbox:Hitbox):
	super.onHit(hitbox)
	
	impact.emitting = true
	sprite.modulate *= Color(1.5, 1.5, 1.5, 1)
