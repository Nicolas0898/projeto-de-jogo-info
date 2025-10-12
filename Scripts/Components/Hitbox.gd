extends Area2D
class_name Hitbox

@export_category("Damage")
@export var damage:float=0
@export var stun:bool = true
@export_category("Knockback")
@export var knockback:Vector2=Vector2(1,1)
@export var override_direction:bool=false
@export var direction:Vector2=Vector2.ZERO
@export var one_hit:bool = false


var ignore = []

signal onHit(other:Area2D)
enum {ENEMY=4,PLAYER=5}

func _ready() -> void:
	area_entered.connect(onAreaEntered)

func onAreaEntered(other:Area2D):
	if other is Hurtbox and not other in ignore:
		other.onHit(self)
		onHit.emit(other)
		if one_hit:
			ignore.push_back(other)

@warning_ignore("shadowed_variable")
static func from_rect(damage,size:Vector2,lifetime=0.2,target=ENEMY) -> Hitbox:
	var hitbox = Hitbox.new()
	hitbox.damage = damage
	hitbox.one_hit = true

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
