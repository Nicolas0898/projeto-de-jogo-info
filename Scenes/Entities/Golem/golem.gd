extends BaseEntity
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	super()
	set_collision_layer_value(2,true)

func rotate_to_plr():
	var plr = GameHandler.Player
	if plr.global_position.x > global_position.x:
		sprite.flip_h = true
	else : sprite.flip_h = false
