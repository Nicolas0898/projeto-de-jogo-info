extends Node
class_name HealthComponent

signal died()
signal healthChanged(new,old)
signal damaged(damage,origin)
@export var max_health:float=100
var health:float

func _ready() -> void:
	health = max_health
	
func takeDamage(damage:float,origin=null):
	healthChanged.emit(health-damage,health)
	damaged.emit(damage,origin)
	health -= damage

func heal(healing:float):
	healthChanged.emit(health+healing,health)
	health = min(health+healing,max_health)
