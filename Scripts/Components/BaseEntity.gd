extends CharacterBody2D
class_name BaseEntity

var constant_velocity = {"input":Vector2(),"jump":Vector2.ZERO}
var variable_velocity = Vector2()
var true_constant_velocity = Vector2.ZERO
@onready var state_machine: StateMachine = $StateMachine
@onready var shader = material as ShaderMaterial

func _ready() -> void:
	add_to_group("Enemy",true)

func apply_gravity(delta:float):
	variable_velocity  += get_gravity()*delta
	variable_velocity.x += -variable_velocity.normalized().x*20

func apply_air_friction():
	variable_velocity.y += -variable_velocity.normalized().y*20
	variable_velocity.x += -variable_velocity.normalized().x*20

@warning_ignore("shadowed_global_identifier")
func check_for_collisions(wall=true,floor=true,ceiling=true):
	if wall and is_on_wall():
		variable_velocity.x = 0
	
	if floor and is_on_floor() and variable_velocity.y>0:
		variable_velocity.y = 0
	
	if ceiling and is_on_ceiling() and variable_velocity.y<0:
		variable_velocity.y = 0

func update_velocity():
	true_constant_velocity = Vector2.ZERO
	for index in constant_velocity:
		true_constant_velocity+=constant_velocity[index]
	velocity = variable_velocity + true_constant_velocity

func clear_constant_velocity():
	for index in constant_velocity:
		constant_velocity[index] = Vector2.ZERO

func default_move():
	update_velocity()
	move_and_slide()
	
func blink(duration=0.3,color="#dc1b00",strength=0.5):
	if not has_meta("isshaderunique"):
		material = shader.duplicate()
		shader = material
		set_meta("isshaderunique",true)
		
	shader.set_shader_parameter("blink_color",Color(color))
	create_tween().tween_method(upd,strength,0.0,duration)
		

func rotate_to_plr(sprite): #se quiserem melhorar isso rsrs - pires
	var plr = GameHandler.Player
	if plr.global_position.x > global_position.x:
		sprite.flip_h = true
	else : sprite.flip_h = false

func upd(v):
	shader.set_shader_parameter("factor",v)
	
