extends Area2D
class_name Hurtbox

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
	else:
		character.blink(0.2,"#ffffff",0.3)
