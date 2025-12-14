extends AnimatedSprite2D
@onready var cast: RayCast2D = $Cast
@onready var line_2d: Line2D = $Line2D

func _ready() -> void:
	cast.force_raycast_update()
	line_2d.set_point_position(1,to_local(cast.get_collision_point()))
func _physics_process(_delta: float) -> void:
	line_2d.set_point_position(1,to_local(cast.get_collision_point()))
