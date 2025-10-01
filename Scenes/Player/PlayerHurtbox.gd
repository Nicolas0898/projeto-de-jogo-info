extends Hurtbox

@onready var character: CharacterBody2D = $".."

func upd(v):
	var shader = character.material as ShaderMaterial
	shader.set_shader_parameter("factor",v)

func onHit(damage:float):
	super(damage)
	var shader = character.material as ShaderMaterial
	print("AAA")
	shader.set_shader_parameter("factor",1)
	print(shader.get_shader_parameter("factor"))
	create_tween().tween_method(upd,1.0,0.0,0.3)
