extends Area2D
class_name Hurtbox

@export var health_component:HealthComponent

func onHit(damage:float):
	if not health_component : return
	print(damage)
	health_component.takeDamage(damage)
	print(health_component.health)
