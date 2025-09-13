extends Node
class_name HealthComponent

@export var max_health:float=100
var health:float

func _ready() -> void:
	health = max_health


func takeDamage(damage:float):
	health -= damage

func heal(healing:float):
	health += healing
