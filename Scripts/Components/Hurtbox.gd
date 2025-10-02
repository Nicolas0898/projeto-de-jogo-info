extends Area2D
class_name Hurtbox

@export var health_component:HealthComponent

func onHit(hitbox:Hitbox):
	if not health_component : return
	var damage = hitbox.damage
	print(damage)
	health_component.takeDamage(damage)
	print(health_component.health)
