extends Area2D
class_name Hurtbox

@export var health_component:HealthComponent

	
func onHit(hitbox:Hitbox):
	if not health_component : return
	var damage = hitbox.damage
	health_component.takeDamage(damage)
	
	var character = get_parent() as BaseEntity
	if damage>0:
		character.blink()
	else:
		character.blink(0.2,"#ffffff",0.3)
