extends Area2D
class_name Hurtbox

@export var health_component:HealthComponent

func upd(v):
	var shader = get_parent().material as ShaderMaterial
	shader.set_shader_parameter("factor",v)
	
func onHit(hitbox:Hitbox):
	if not health_component : return
	var damage = hitbox.damage
	print(damage)
	health_component.takeDamage(damage)
	print(health_component.health)
	
	var shader = get_parent().material as ShaderMaterial
	if not get_parent().has_meta("isshaderunique"):
		get_parent().material = shader.duplicate()
		shader = get_parent().material
		get_parent().set_meta("isshaderunique",true)
	if hitbox.damage>0:
		shader.set_shader_parameter("blink_color",Color("#dc1b00"))
		create_tween().tween_method(upd,0.5,0.0,0.3)
	else:
		create_tween().tween_method(upd,0.2,0.0,0.3)
		shader.set_shader_parameter("blink_color",Color("#ffffff"))
