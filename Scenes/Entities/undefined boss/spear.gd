extends BaseEntity


var spear_velocity : float
var randomness : float
var active : bool = false
var r : bool = false
var pos : Vector2
var to_middle = false
var dir
var collision
var scale_tween : Tween
var modulate_tween : Tween
var trail_modulate : Tween
var trail : GPUParticles2D
var vfx = null
@onready var sprite_2d: Sprite2D = $Sprite2D
#@export var roof_particles : GPUParticles2D

signal on_middle()

func _ready():
	active = false
	r = false
	to_middle = false
	pass

func _physics_process(delta: float) -> void:
	#print(velocity)
	#print(hp_component.health)
	if not active: return
	if sprite_2d.flip_h == false: sprite_2d.flip_h = true
	
	
	if global_position.distance_to(pos) < 5.0 and to_middle:
		active = false
		emit_signal("on_middle")
		return
	
	if not to_middle:
		rotation = velocity.angle()
	else:
		velocity = dir * (spear_velocity + 50)
	collision = move_and_collide(velocity * delta)
	
	if collision and not to_middle:
		if r:
			to_middle = true
			dir = (pos - global_position).normalized()
			velocity = dir * (spear_velocity + 50)
			rotation = velocity.angle()
			return
		GameHandler.Player.camera.screen_shake(10, 0.2, 3, 0.2)
		#roof_particles.restart()
		#roof_particles.emitting = true
		
		if scale_tween and scale_tween.is_running():
			scale_tween.kill()
			modulate_tween.kill()
		
		scale = Vector2(0.3, 0.4)
		modulate = Color(3.974, 4.683, 6.127, 1.0)
		trail.modulate = Color(3.974, 4.683, 6.127, 1.0)
		scale_tween = create_tween()
		modulate_tween = create_tween()
		trail_modulate = create_tween()
		scale_tween.tween_property(self, "scale", Vector2(0.5, 0.6), 0.3)
		modulate_tween.tween_property(self, "modulate", Color(1.825, 1.825, 1.825, 1.0), 0.3)
		trail_modulate.tween_property(trail, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.3)
		velocity = velocity.bounce(collision.get_normal())

func return_to(p : Vector2):
	pos = p
	r = true
