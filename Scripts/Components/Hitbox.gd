extends Area2D
class_name Hitbox

@export var damage:float=0

func _ready() -> void:
	area_entered.connect(onAreaEntered)

func onAreaEntered(other:Area2D):
	if other is Hurtbox:
		other.onHit(damage)
