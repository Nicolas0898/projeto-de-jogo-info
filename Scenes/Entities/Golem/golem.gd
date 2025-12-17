extends BaseEntity
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	super()
	set_collision_layer_value(2,true)
