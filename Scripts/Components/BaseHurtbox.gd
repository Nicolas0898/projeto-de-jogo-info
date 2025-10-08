extends Hurtbox
class_name BaseHurtbox

@onready var character:BaseEntity = $".."
@export var knockback_multiplier = 1.0

func onHit(hitbox:Hitbox):
	super(hitbox)
	
	Time.get_ticks_msec()
	var pos = null
	for node in hitbox.get_children():
		if node is CollisionShape2D:
			if not pos: pos=node.global_position
			else: pos = (pos+node.global_position)/2
		
	character.variable_velocity = Vector2.ZERO
	character.state_machine.requestStateChange("Falling")
	if hitbox.has_node("center"):
		pos = hitbox.get_node("center").global_position
	var direction = pos.direction_to(character.global_position)
		
	if hitbox.override_direction:
		direction = hitbox.direction
	character.variable_velocity += direction*300*hitbox.knockback*knockback_multiplier
	
