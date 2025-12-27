extends Area2D
class_name Hurtbox
const BLOOD = preload("uid://c6v43gqmnumlk")

@export var health_component:HealthComponent
signal on_hit(other:Hitbox)

func onHit(hitbox:Hitbox):
	if not health_component : return
	on_hit.emit(hitbox)
	var damage = hitbox.damage
	health_component.takeDamage(damage,hitbox)
	
	var character = get_parent() as BaseEntity
	
	if damage>0:
		character.blink()
		var blood:GPUParticles2D = BLOOD.instantiate()
		get_tree().current_scene.add_child(blood)
		blood.global_position = character.global_position
		blood.emitting = true
		
		blood.finished.connect(func():
			blood.queue_free())
	else:
		character.blink(0.2,"#ffffff",0.3)
