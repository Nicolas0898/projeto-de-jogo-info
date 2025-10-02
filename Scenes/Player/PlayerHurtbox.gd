extends Hurtbox

@onready var character: PlayerCharacter = $".."

func upd(v):
	var shader = character.material as ShaderMaterial
	shader.set_shader_parameter("factor",v)

func onHit(hitbox:Hitbox):
	super(hitbox)
	var shader = character.material as ShaderMaterial
	
	var pos = null
	for node in hitbox.get_children():
		if node is CollisionShape2D:
			if not pos: pos=node.global_position
			else: pos = (pos+node.global_position)/2
		
	character.variable_velocity = Vector2.ZERO
	character.state_machine.requestStateChange("Falling")
	var direction = pos.direction_to(character.global_position)
	if hitbox.override_direction:
		direction = hitbox.direction
	character.variable_velocity += direction*600*hitbox.knockback
	
	if character.get_node("GrapplingHook"):
		character.get_node("GrapplingHook").reset_hooks()
	
	if hitbox.damage>0:
		shader.set_shader_parameter("blink_color",Color("#dc1b00"))
		create_tween().tween_method(upd,0.5,0.0,0.3)
	else:
		create_tween().tween_method(upd,0.2,0.0,0.3)
		shader.set_shader_parameter("blink_color",Color("#ffffff"))
	
	
	
