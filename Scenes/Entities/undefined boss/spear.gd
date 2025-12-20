extends BaseEntity

var spear_velocity : float
var randomness : float
var active : bool = false
@onready var hp_component : Node = $HealthComponent
@onready var sprite_2d: Sprite2D = $Sprite2D
@export var roof_particles : GPUParticles2D

func _ready():
	pass
	#var tween = create_tween()
	#tween.tween_property(self, "scale", Vector2(0.8, 0.8), 1)

func _physics_process(delta: float) -> void:
	#print(velocity)
	#print(hp_component.health)
	if not active: return
	if sprite_2d.flip_h == false: sprite_2d.flip_h = true
	
	var collision = move_and_collide(velocity * delta)
	rotation = velocity.angle()
	
	#print(scale)
	if collision:
		GameHandler.Player.camera.screen_shake(10, 0.5)
		#roof_particles.restart()
		roof_particles.emitting = true
		
		var tween = create_tween()
		sprite_2d.scale = Vector2(0.1, 0.1)
		tween.tween_property(sprite_2d, "scale", Vector2(0.8, 0.8), 0.1)
		velocity = velocity.bounce(collision.get_normal())
