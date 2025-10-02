extends Area2D
class_name Hitbox

@export var damage:float=0
@export_category("knockback")
@export var knockback:Vector2=Vector2(1,1)
@export var override_direction:bool=false
@export var direction:Vector2=Vector2.ZERO
func _ready() -> void:
	area_entered.connect(onAreaEntered)

func onAreaEntered(other:Area2D):
	if other is Hurtbox:
		other.onHit(self)
