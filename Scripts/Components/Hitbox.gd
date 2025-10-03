extends Area2D
class_name Hitbox

@export var damage:float=0
@export_category("knockback")
@export var knockback:Vector2=Vector2(1,1)
@export var override_direction:bool=false
@export var direction:Vector2=Vector2.ZERO

signal onHit(other:Area2D)
enum {ENEMY=4,PLAYER=5}

func _ready() -> void:
	area_entered.connect(onAreaEntered)

func onAreaEntered(other:Area2D):
	if other is Hurtbox:
		other.onHit(self)
		onHit.emit(other)

static func from_rect(damage,size:Vector2,lifetime=0.2,target=ENEMY) -> Hitbox:
	var hitbox = Hitbox.new()
	hitbox.damage = 10

	hitbox.set_collision_mask_value(target,true)
	var collision = CollisionShape2D.new()
	collision.shape = RectangleShape2D.new()
	collision.shape.size = size
	collision.debug_color = Color("#f900655b")
	
	hitbox.add_child(collision)
	
	if lifetime>0:
		GameHandler.get_tree().create_timer(lifetime).timeout.connect(func():
			hitbox.queue_free())
	
	return hitbox
