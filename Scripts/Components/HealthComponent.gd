extends Node
class_name HealthComponent

signal died()
signal healthChanged(new,old)
@export var max_health:float=100
var health:float

func _ready() -> void:
	health = GameHandler.player_health
	

func takeDamage(damage:float):
	healthChanged.emit(health-damage,health)
	health -= damage
	GameHandler.player_health = health

func heal(healing:float):
	healthChanged.emit(health+healing,health)
	health += healing
