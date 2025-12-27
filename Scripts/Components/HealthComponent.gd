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
	print(health)
	healthChanged.emit(health-damage,health)
	damaged.emit(damage,origin)
	health -= damage

func heal(healing:float):
	var val = min(health+healing,max_health)
	healthChanged.emit(val,health)
	health = val
