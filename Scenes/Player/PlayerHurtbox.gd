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
	character.variable_velocity += pos.direction_to(character.global_position)*600*hitbox.knockback
	shader.set_shader_parameter("factor",1)
	print(shader.get_shader_parameter("factor"))
	create_tween().tween_method(upd,1.0,0.0,0.3)
